@val @scope("window")
external jsAlert: string => unit = "alert"

module Mutation = %relay(`
  mutation TossPaymentsSuccessBuyerMutation(
    $amount: Int!
    $paymentId: Int!
    $orderId: String!
    $paymentKey: String!
    $tempOrderId: Int
  ) {
    requestPaymentApprovalTossPayments(
      input: {
        paymentId: $paymentId
        amount: $amount
        orderId: $orderId
        paymentKey: $paymentKey
        tempOrderId: $tempOrderId
      }
    ) {
      ... on RequestPaymentApprovalTossPaymentsResult {
        paymentId
        amount
        paymentKey
        status
      }
      ... on Error {
        code
        message
      }
    }
  }
`)

module Dialog = {
  @react.component
  let make = (~children, ~show, ~href) => {
    <RadixUI.Dialog.Root _open=show>
      <RadixUI.Dialog.Portal>
        <RadixUI.Dialog.Overlay className=%twc("dialog-overlay") />
        <RadixUI.Dialog.Content
          className=%twc(
            "dialog-content p-7 bg-white rounded-xl w-[480px] flex flex-col items-center justify-center"
          )>
          children
          <Next.Link href>
            <a
              className=%twc(
                "flex w-full xl:w-1/2 h-13 mt-5 bg-surface rounded-lg justify-center items-center text-lg cursor-pointer text-enabled-L1"
              )>
              {`확인`->React.string}
            </a>
          </Next.Link>
        </RadixUI.Dialog.Content>
      </RadixUI.Dialog.Portal>
    </RadixUI.Dialog.Root>
  }
}

@react.component
let make = () => {
  let {useRouter} = module(Next.Router)

  let router = useRouter()

  let {makeWithDict, get} = module(Webapi.Url.URLSearchParams)
  let (showDialog, setShowDialog) = React.Uncurried.useState(_ => false)
  let (redirect, setRedirect) = React.Uncurried.useState(_ => "/buyer")
  let (isError, setIsError) = React.Uncurried.useState(_ => false)
  let (errMsg, setErrMsg) = React.Uncurried.useState(_ => None)

  let (mutate, isMutating) = Mutation.use()

  let handleError = (~message, ~url, ()) => {
    setShowDialog(._ => true)
    setIsError(._ => true)
    setErrMsg(._ => message)
    url->Option.forEach(url' => setRedirect(._ => url'))
  }

  React.useEffect1(_ => {
    let params = router.query->makeWithDict
    let orderId = params->get("orderId")
    let paymentKey = params->get("paymentKey")
    let amount = params->get("amount")->Option.flatMap(Int.fromString)
    let paymentId = params->get("payment-id")->Option.flatMap(Int.fromString)
    let tempOrderId = params->get("temp-order-id")->Option.flatMap(Int.fromString)
    let productId = params->get("product-id")
    let productOptionId = params->get("product-option-id")
    let quantity = params->get("quantity")

    switch (orderId, paymentKey, amount, paymentId, isMutating) {
    | (Some(orderId'), Some(paymentKey'), Some(amount'), Some(paymentId'), false) =>
      {
        let redirectByParams = message =>
          switch (productId, productOptionId, quantity) {
          | (Some(productId'), Some(productOptionId'), Some(quantity')) =>
            handleError(
              ~message,
              ~url=Some(
                `/buyer/web-order/${productId'}/${productOptionId'}?quantity=${quantity'}`,
              ),
              (),
            )
          | _ => handleError(~message, ~url=Some("/buyer/transactions"), ())
          }

        mutate(
          ~variables={
            paymentId: paymentId',
            amount: amount',
            orderId: orderId',
            paymentKey: paymentKey',
            tempOrderId: tempOrderId,
          },
          ~onCompleted={
            ({requestPaymentApprovalTossPayments}, _error) => {
              switch requestPaymentApprovalTossPayments {
              | Some(result) =>
                switch result {
                | #RequestPaymentApprovalTossPaymentsResult(_requestPaymentApprovalTossPayments) =>
                  switch tempOrderId {
                  | Some(_) => {
                      setShowDialog(._ => true)
                      setRedirect(._ => `/buyer/web-order/complete/${orderId'}`)
                    }
                  | None => {
                      setShowDialog(._ => true)
                      setRedirect(._ => `/buyer/transactions`)
                    }
                  }

                | #Error(error) => redirectByParams(error.message)
                | _ => redirectByParams(None)
                }
              | None => redirectByParams(None)
              }
            }
          },
          ~onError={error => redirectByParams(Some(error.message))},
          (),
        )
      }->ignore
    | _ => ()
    }

    None
  }, [router.query])

  <main className=%twc("bg-surface w-screen h-[560px]")>
    <Dialog show=showDialog href=redirect>
      <section className=%twc("flex flex-col items-center justify-center")>
        {switch isError {
        | true => <>
            <span> {`결제가 실패하여`->React.string} </span>
            <span className=%twc("mb-5")>
              {`주문이 정상 처리되지 못했습니다.`->React.string}
            </span>
            <span> {`주문/결제하기 페이지에서`->React.string} </span>
            <span className=%twc("mb-5")>
              {`결제를 다시 시도해주세요.`->React.string}
            </span>
            <span className=%twc("text-notice")>
              {errMsg->Option.getWithDefault("")->React.string}
            </span>
          </>
        | false => <>
            <span> {`결제 요청이 성공했습니다.`->React.string} </span>
            <span> {`결제완료 페이지로 이동합니다.`->React.string} </span>
          </>
        }}
      </section>
    </Dialog>
  </main>
}
