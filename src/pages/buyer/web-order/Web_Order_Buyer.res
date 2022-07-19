module Query = %relay(`
  query WebOrderBuyerQuery($productNodeId: ID!, $productOptionNodeId: ID!) {
    productNode: node(id: $productNodeId) {
      ... on NormalProduct {
        isCourierAvailable
      }
  
      ... on QuotableProduct {
        isCourierAvailable
      }
    }
    ...WebOrderProductInfoBuyerFragment
      @arguments(
        productNodeId: $productNodeId
        productOptionNodeId: $productOptionNodeId
      )
    ...WebOrderPaymentInfoBuyerFragment
      @arguments(productOptionNodeId: $productOptionNodeId)
    ...WebOrderHiddenInputBuyerFragment
      @arguments(
        productNodeId: $productNodeId
        productOptionNodeId: $productOptionNodeId
      )
    ...WebOrderDeliveryMethodSelectionBuyerFragment
      @arguments(productNodeId: $productNodeId)
  }
`)

module Mutation = %relay(`
  mutation WebOrderBuyerMutation(
    $orderUserId: Int!
    $paymentPurpose: String!
    $productOptions: [WosProductOptionInput!]!
    $totalDeliveryCost: Int!
    $totalOrderPrice: Int!
  ) {
    createWosOrder(
      input: {
        orderUserId: $orderUserId
        paymentPurpose: $paymentPurpose
        productOptions: $productOptions
        totalDeliveryCost: $totalDeliveryCost
        totalOrderPrice: $totalOrderPrice
      }
    ) {
      ... on CreateWosOrderResult {
        orderNo
        tempOrderId
      }
      ... on Error {
        # code
        message
      }
      ... on WosError {
        code
        message
      }
      ... on WosOrder {
        createUserId
      }
    }
  }
`)

module Dialog = {
  @react.component
  let make = (~show, ~confirmFn, ~cancel) => {
    <RadixUI.Dialog.Root _open=show>
      <RadixUI.Dialog.Portal>
        <RadixUI.Dialog.Overlay className=%twc("dialog-overlay") />
        <RadixUI.Dialog.Content
          className=%twc(
            "dialog-content p-7 bg-white rounded-xl w-[480px] flex flex-col gap-7 items-center justify-center"
          )>
          <span className=%twc("whitespace-pre text-center text-text-L1 pt-3")>
            {`화물배송의 경우 배송지에 따라
추가배송비(화물비)가 후청구 됩니다.

담당MD가 화물비를 알려드리기 위해
별도로 연락을 드릴 예정입니다.

위 사항이 확인되셨다면
결제를 눌러 다음 단계를 진행해 주세요.`->React.string}
          </span>
          <div className=%twc("flex w-full justify-center items-center gap-2")>
            <button className=%twc("w-1/2 rounded-xl h-13 bg-enabled-L5") onClick=cancel>
              {`취소`->React.string}
            </button>
            <button
              className=%twc("w-1/2 rounded-xl h-13 bg-primary text-inverted font-bold")
              onClick={ReactEvents.interceptingHandler(_ => confirmFn())}>
              {`결제`->React.string}
            </button>
          </div>
        </RadixUI.Dialog.Content>
      </RadixUI.Dialog.Portal>
    </RadixUI.Dialog.Root>
  }
}

@val @scope(("window", "location"))
external origin: string = "origin"

@val @scope(("window", "location"))
external pathname: string = "pathname"

@val @scope(("window", "location"))
external search: string = "search"

type cashReceipt = {"type": string}

type tossRequest = {
  amount: int,
  orderId: string,
  orderName: string,
  customerName: string,
  successUrl: string,
  failUrl: string,
  taxFreeAmount: int,
  validHours: option<int>,
  cashReceipt: option<cashReceipt>,
}

@val @scope(("window", "tossPayments"))
external requestTossPayment: (. string, tossRequest) => unit = "requestPayment"

open ReactHookForm
module Form = Web_Order_Buyer_Form
module PlaceHolder = Web_Order_Item_Buyer.PlaceHolder

let makeProductOption = (d: Form.productOptions) => {
  Mutation.make_wosProductOptionInput(
    ~deliveryCost=?{d.deliveryCost},
    ~deliveryDesiredDate=?{d.deliveryDesiredDate},
    ~deliveryMessage=?{d.deliveryMessage},
    ~deliveryType=d.deliveryType,
    ~grade=?{d.grade},
    ~isTaxFree=d.isTaxFree,
    ~ordererName=d.ordererName,
    ~ordererPhone=d.ordererPhone,
    ~price=d.price,
    ~productId=d.productId,
    ~productName=d.productName,
    ~productOptionName=d.productOptionName,
    ~quantity=d.quantity,
    ~receiverName=?{d.receiverName},
    ~receiverPhone=?{d.receiverPhone},
    ~receiverAddress={
      d.receiverAddress->Option.getWithDefault("") ++
        d.receiverDetailAddress->Option.mapWithDefault("", str => ` ${str}`)
    },
    ~receiverZipCode=?{d.receiverZipCode},
    ~stockSku=d.stockSku,
    (),
  )
}

let paymentMethodToTossValue = c =>
  switch c {
  | #CREDIT_CARD => `카드`
  | #VIRTUAL_ACCOUNT => `가상계좌`
  | #TRANSFER => `계좌이체`
  }

let tossPaymentsValidHours = c =>
  switch c {
  | #VIRTUAL_ACCOUNT => Some(24)
  | _ => None
  }

let tossPaymentsCashReceipt = c =>
  switch c {
  | #VIRTUAL_ACCOUNT => Some({"type": `미발행`})
  | _ => None
  }

module Container = {
  @react.component
  let make = (~productId, ~productOptionId, ~quantity) => {
    let queryData = Query.use(
      ~variables={
        productNodeId: productId,
        productOptionNodeId: productOptionId,
      },
      ~fetchPolicy=RescriptRelay.StoreAndNetwork,
      (),
    )
    let (mutate, _) = Mutation.use()

    let (requestPaymentMutate, _) = Web_Order_Item_Buyer.Mutation.use()
    let (freightDialogShow, setFreightDialogShow) = React.Uncurried.useState(_ => false)
    let (confirmFn, setConfirmFn) = React.Uncurried.useState(_ => ignore)

    let {addToast} = ReactToastNotifications.useToasts()

    let handleOnCancel = ReactEvents.interceptingHandler(_ => {
      setFreightDialogShow(._ => false)
      setConfirmFn(._ => ignore)
    })

    let handleError = (~message=?, ()) => {
      setConfirmFn(._ => ignore)
      addToast(.
        <div className=%twc("flex items-center w-full whitespace-pre-wrap")>
          <IconError height="24" width="24" className=%twc("mr-2") />
          {j`결제가 실패하였습니다. ${message->Option.getWithDefault("")}`->React.string}
        </div>,
        {appearance: "error"},
      )
    }

    let methods = Hooks.Form.use(.
      ~config=Hooks.Form.config(
        ~mode=#onSubmit,
        ~defaultValues=[
          (
            Form.name,
            switch queryData.productNode {
            | Some(#NormalProduct({isCourierAvailable})) => [
                ("payment-method", Js.Json.string("card")),
                ("product-options", [Form.defaultValue(isCourierAvailable)]->Js.Json.array),
              ]
            | _ => [("web-order", Js.Json.null)]
            }
            ->Js.Dict.fromArray
            ->Js.Json.object_,
          ),
        ]
        ->Js.Dict.fromArray
        ->Js.Json.object_,
        (),
      ),
      (),
    )
    let {handleSubmit} = methods

    let onSubmit = (data: Js.Json.t, _) => {
      Js.log(data) // TODO: QA 시작전 지우기
      switch data->Form.submit_decode {
      | Ok({webOrder: data'}) =>
        let confirm = () =>
          {
            setFreightDialogShow(._ => false)
            // 토스 페이먼츠 결제 화면을 띄우기 직전에 화물배송확인 dialog를 닫는다
            mutate(
              ~variables={
                orderUserId: data'.orderUserId,
                paymentPurpose: data'.paymentPurpose,
                productOptions: data'.productOptions->Array.map(makeProductOption),
                totalDeliveryCost: data'.totalDeliveryCost,
                totalOrderPrice: data'.totalOrderPrice,
              },
              ~onCompleted={
                ({createWosOrder}, _) => {
                  switch createWosOrder {
                  | Some(result) =>
                    switch result {
                    | #CreateWosOrderResult({orderNo, tempOrderId}) =>
                      let (orderName, isTaxFree) = switch data'.productOptions->Array.get(0) {
                      | Some(option) => (option.productName, option.isTaxFree)
                      | None => ("", false)
                      }
                      requestPaymentMutate(
                        ~variables={
                          paymentMethod: data'.paymentMethod,
                          amount: data'.totalOrderPrice,
                          purpose: #ORDER,
                        },
                        ~onCompleted={
                          ({requestPayment}, _) => {
                            switch requestPayment {
                            | Some(result) =>
                              switch result {
                              | #RequestPaymentTossPaymentsResult(tossPaymentResult) =>
                                requestTossPayment(.
                                  data'.paymentMethod->paymentMethodToTossValue,
                                  {
                                    amount: data'.totalOrderPrice,
                                    orderId: orderNo,
                                    orderName: orderName,
                                    taxFreeAmount: isTaxFree ? data'.totalOrderPrice : 0,
                                    customerName: tossPaymentResult.customerName,
                                    validHours: data'.paymentMethod->tossPaymentsValidHours,
                                    successUrl: `${origin}/buyer/toss-payments/success?product-id=${productId}&product-option-id=${productOptionId}&quantity=${quantity->Int.toString}&payment-id=${tossPaymentResult.paymentId->Int.toString}&temp-order-id=${tempOrderId->Int.toString}`,
                                    failUrl: `${origin}/buyer/toss-payments/fail?product-id=${productId}&product-option-id=${productOptionId}&quantity=${quantity->Int.toString}`,
                                    cashReceipt: data'.paymentMethod->tossPaymentsCashReceipt,
                                  },
                                )
                              | #Error(err) =>
                                err.message->Option.forEach(message => handleError(~message, ()))
                              | _ =>
                                handleError(~message=`주문 생성에 실패하였습니다.`, ())
                              }
                            | None =>
                              handleError(~message=`주문 생성에 실패하였습니다.`, ())
                            }
                          }
                        },
                        ~onError={
                          err => handleError(~message=err.message, ())
                        },
                        (),
                      )->ignore
                    | #WosError({code, _}) =>
                      switch code {
                      | #INVALID_DELIVERY =>
                        handleError(~message=`유효하지 않은 배송 정보입니다.`, ())
                      | #INVALID_ORDER =>
                        handleError(~message=`유효하지 않은 주문 정보입니다.`, ())
                      | #INVALID_PAYMENT_PURPOSE =>
                        handleError(~message=`유효하지 않은 결제 목적입니다.`, ())
                      | #INVALID_PRODUCT =>
                        handleError(~message=`유효하지 않은 상품 정보입니다.`, ())
                      | _ => handleError()
                      }
                    | #Error(_)
                    | _ =>
                      handleError(~message=`주문 생성 에러`, ())
                    }
                  | _ => handleError(~message=`주문 생성 요청 실패`, ())
                  }
                }
              },
              ~onError={
                err => handleError(~message=err.message, ())
              },
              (),
            )
          }->ignore

        switch data'.productOptions->Array.get(0) {
        | Some({deliveryType}) =>
          switch deliveryType {
          | #FREIGHT => {
              setConfirmFn(._ => confirm)
              setFreightDialogShow(._ => true)
            }
          | _ => confirm()
          }
        | None => ()
        }

      | Error(msg) => {
          Js.log(msg)
          handleError(~message=msg.message, ())
        }
      }
    }
    <>
      <Dialog confirmFn cancel=handleOnCancel show=freightDialogShow />
      <ReactHookForm.Provider methods>
        <form onSubmit={handleSubmit(. onSubmit)}>
          <Web_Order_Item_Buyer query={queryData.fragmentRefs} quantity />
        </form>
      </ReactHookForm.Provider>
    </>
  }
}

@react.component
let make = () => {
  let router = Next.Router.useRouter()
  let productId = router.query->Js.Dict.get("pid")
  let productOptionId = router.query->Js.Dict.get("oid")
  let quantity = router.query->Js.Dict.get("quantity")->Option.flatMap(Int.fromString)

  <Authorization.Buyer title=j`주문하기` fallback={<PlaceHolder />}>
    <Next.Script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js" />
    <React.Suspense fallback={<PlaceHolder />}>
      {switch (productId, productOptionId, quantity) {
      | (Some(pid), Some(oid), Some(q)) =>
        <Container productId=pid productOptionId=oid quantity=q />

      | _ => <PlaceHolder />
      }}
    </React.Suspense>
  </Authorization.Buyer>
}
