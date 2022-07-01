module List = Order_List_Admin_Buyer

external unsafeAsFile: Webapi.Blob.t => Webapi.File.t = "%identity"

@spice
type data = {
  @spice.key("total-count") totalCount: int,
  @spice.key("update-count") updateCount: int,
}
@spice
type response = {
  data: data,
  message: string,
}
@spice
type refundReason =
  | @spice.as("delivery-delayed") DeliveryDelayed | @spice.as("defective-product") DefectiveProduct

let displayRefundReason = rr =>
  switch rr {
  | DeliveryDelayed => `배송지연`
  | DefectiveProduct => `상품불량`
  }

module Orders = {
  @react.component
  let make = () => {
    let router = Next.Router.useRouter()
    let {mutate} = Swr.useSwrConfig()

    let status = CustomHooks.OrdersAdmin.use(
      router.query->Webapi.Url.URLSearchParams.makeWithDict->Webapi.Url.URLSearchParams.toString,
    )

    let (selectedOrders, setSelectedOrders) = React.Uncurried.useState(_ => Set.String.empty)
    // 취소 관련
    let (isShowCancelConfirm, setShowCancelConfirm) = React.Uncurried.useState(_ => Dialog.Hide)
    let (isShowNothingToCancel, setShowNothingToCancel) = React.Uncurried.useState(_ => Dialog.Hide)
    let (isShowCancelSuccess, setShowCancelSuccess) = React.Uncurried.useState(_ => Dialog.Hide)
    let (isShowCancelError, setShowCancelError) = React.Uncurried.useState(_ => Dialog.Hide)
    let (successResultCancel, setSuccessResultCancel) = React.Uncurried.useState(_ => None)
    // 환불 관련
    let (refundReason, setRefundReason) = React.Uncurried.useState(_ => DeliveryDelayed)
    let (isShowNothingToRefund, setShowNothingToRefund) = React.Uncurried.useState(_ => Dialog.Hide)
    let (isShowRefundConfirm, setShowRefundConfirm) = React.Uncurried.useState(_ => Dialog.Hide)
    let (isShowRefundSuccess, setShowRefundSuccess) = React.Uncurried.useState(_ => Dialog.Hide)
    let (isShowRefundError, setShowRefundError) = React.Uncurried.useState(_ => Dialog.Hide)
    let (successResultRefund, setSuccessResultRefund) = React.Uncurried.useState(_ => None)
    // 배송완료 관련
    let (isShowCompleteConfirm, setShowCompleteConfirm) = React.Uncurried.useState(_ => Dialog.Hide)
    let (isShowNothingToComplete, setShowNothingToComplete) = React.Uncurried.useState(_ =>
      Dialog.Hide
    )
    let (isShowCompleteSuccess, setShowCompleteSuccess) = React.Uncurried.useState(_ => Dialog.Hide)
    let (isShowCompleteError, setShowCompleteError) = React.Uncurried.useState(_ => Dialog.Hide)
    let (successResultComplete, setSuccessResultComplete) = React.Uncurried.useState(_ => None)

    // 검색 조건이 바뀌면(예를 들어 페이지 변경 등) 선택했던 취소할 주문을 초기화 한다.
    React.useEffect1(_ => {
      setSelectedOrders(._ => Set.String.empty)
      None
    }, [router.query])

    let count = switch status {
    | Loaded(orders) =>
      switch orders->CustomHooks.OrdersAdmin.orders_decode {
      | Ok(orders') => orders'.count->Int.toString
      | Error(_) => `-`
      }
    | _ => `-`
    }

    let handleOnCheckOrder = (orderProductNo, e) => {
      let checked = (e->ReactEvent.Synthetic.target)["checked"]
      if checked {
        let newOrders = selectedOrders->Set.String.add(orderProductNo)
        setSelectedOrders(._ => newOrders)
      } else {
        let newOrders = selectedOrders->Set.String.remove(orderProductNo)
        setSelectedOrders(._ => newOrders)
      }
    }
    let check = orderProductNo => {
      selectedOrders->Set.String.has(orderProductNo)
    }

    let handleCheckAll = e => {
      let checked = (e->ReactEvent.Synthetic.target)["checked"]
      if checked {
        switch status {
        | Loaded(orders) =>
          let allOrderProductNo = switch orders->CustomHooks.OrdersAdmin.orders_decode {
          | Ok(orders') =>
            orders'.data
            ->Garter.Array.keep(Order_Admin.isCheckableOrder)
            ->Garter.Array.map(order => order.orderProductNo)
            ->Set.String.fromArray
          | Error(_) => Set.String.empty
          }
          setSelectedOrders(._ => allOrderProductNo)
        | _ => ()
        }
      } else {
        setSelectedOrders(._ => Set.String.empty)
      }
    }
    let countOfChecked = selectedOrders->Set.String.size

    let cancelOrder = orders => {
      setShowCancelConfirm(._ => Dialog.Hide)
      {
        "order-product-numbers": orders,
      }
      ->Js.Json.stringifyAny
      ->Option.map(body => {
        FetchHelper.requestWithRetry(
          ~fetcher=FetchHelper.postWithToken,
          ~url=`${Env.restApiUrl}/order/cancel`,
          ~body,
          ~count=3,
          ~onSuccess={
            res => {
              let result = switch res->response_decode {
              | Ok(res') => Some(res'.data.totalCount, res'.data.updateCount)
              | Error(_) => None
              }

              setSuccessResultCancel(._ => result)

              setShowCancelSuccess(._ => Dialog.Show)

              setSelectedOrders(._ => Set.String.empty)
              // 주문 취소 후 revalidate
              mutate(.
                ~url=`${Env.restApiUrl}/order?${router.query
                  ->Webapi.Url.URLSearchParams.makeWithDict
                  ->Webapi.Url.URLSearchParams.toString}`,
                ~data=None,
                ~revalidation=None,
              )
              mutate(.
                ~url=`${Env.restApiUrl}/order/summary?${Period.currentPeriod(router)}`,
                ~data=None,
                ~revalidation=None,
              )
            }
          },
          ~onFailure={_ => setShowCancelError(._ => Dialog.Show)},
        )
      })
      ->ignore
    }

    let handleOnChangeRefundReason = e => {
      let value = (e->ReactEvent.Synthetic.target)["value"]
      switch value->refundReason_decode {
      | Ok(refundReason) => setRefundReason(._ => refundReason)
      | Error(_) => setRefundReason(._ => DeliveryDelayed)
      }
    }

    let refundOrder = orders => {
      setShowRefundConfirm(._ => Dialog.Hide)
      {
        "order-product-numbers": orders,
        "reason": refundReason->refundReason_encode,
      }
      ->Js.Json.stringifyAny
      ->Option.map(body => {
        FetchHelper.requestWithRetry(
          ~fetcher=FetchHelper.postWithToken,
          ~url=`${Env.restApiUrl}/order/refund`,
          ~body,
          ~count=3,
          ~onSuccess={
            res => {
              let result = switch res->response_decode {
              | Ok(res') => Some(res'.data.totalCount, res'.data.updateCount)
              | Error(_) => None
              }

              setSuccessResultRefund(._ => result)

              setShowRefundSuccess(._ => Dialog.Show)

              setSelectedOrders(._ => Set.String.empty)
              // 주문 취소 후 revalidate
              mutate(.
                ~url=`${Env.restApiUrl}/order?${router.query
                  ->Webapi.Url.URLSearchParams.makeWithDict
                  ->Webapi.Url.URLSearchParams.toString}`,
                ~data=None,
                ~revalidation=None,
              )
              mutate(.
                ~url=`${Env.restApiUrl}/order/summary?${Period.currentPeriod(router)}`,
                ~data=None,
                ~revalidation=None,
              )
            }
          },
          ~onFailure={_ => setShowCancelError(._ => Dialog.Show)},
        )
      })
      ->ignore
    }

    let completeOrder = orders => {
      setShowCompleteConfirm(._ => Dialog.Hide)
      {
        "order-product-numbers": orders,
      }
      ->Js.Json.stringifyAny
      ->Option.map(body => {
        FetchHelper.requestWithRetry(
          ~fetcher=FetchHelper.postWithToken,
          ~url=`${Env.restApiUrl}/order/complete`,
          ~body,
          ~count=3,
          ~onSuccess={
            res => {
              let result = switch res->response_decode {
              | Ok(res') => Some(res'.data.totalCount, res'.data.updateCount)
              | Error(_) => None
              }

              setSuccessResultComplete(._ => result)

              setShowCompleteSuccess(._ => Dialog.Show)

              setSelectedOrders(._ => Set.String.empty)
              // 주문 취소 후 revalidate
              mutate(.
                ~url=`${Env.restApiUrl}/order?${router.query
                  ->Webapi.Url.URLSearchParams.makeWithDict
                  ->Webapi.Url.URLSearchParams.toString}`,
                ~data=None,
                ~revalidation=None,
              )
              mutate(.
                ~url=`${Env.restApiUrl}/order/summary?${Period.currentPeriod(router)}`,
                ~data=None,
                ~revalidation=None,
              )
            }
          },
          ~onFailure={_ => setShowCompleteError(._ => Dialog.Show)},
        )
      })
      ->ignore
    }

    <>
      <div
        className=%twc(
          "max-w-gnb-panel overflow-auto overflow-x-scroll bg-div-shape-L1 min-h-screen"
        )>
        <header className=%twc("flex items-baseline p-7 pb-0")>
          <h1 className=%twc("text-text-L1 text-xl font-bold")>
            {j`주문서 조회`->React.string}
          </h1>
        </header>
        <Summary_Order_Admin />
        <div className=%twc("p-7 m-4 shadow-gl overflow-auto overflow-x-scroll bg-white rounded")>
          <div className=%twc("md:flex md:justify-between pb-4")>
            <div className=%twc("flex flex-auto justify-between")>
              <h3 className=%twc("font-bold")>
                {j`주문내역`->React.string}
                <span className=%twc("ml-1 text-green-gl font-normal")>
                  {j`${count}건`->React.string}
                </span>
              </h3>
              <div className=%twc("flex")>
                <Select_CountPerPage className=%twc("mr-2") />
                <Select_Sorted className=%twc("mr-2") />
                {
                  open CustomHooks.OrdersAdmin
                  switch router.query
                  ->Js.Dict.get("status")
                  ->Option.flatMap(status' =>
                    switch status'->Js.Json.string->CustomHooks.OrdersAdmin.status_decode {
                    | Ok(status'') => Some(status'')
                    | Error(_) => None
                    }
                  ) {
                  | Some(COMPLETE) =>
                    <button
                      className=%twc(
                        "h-9 px-3 text-black-gl bg-gray-button-gl rounded-lg flex items-center mr-2"
                      )
                      onClick={_ => {
                        countOfChecked > 0
                          ? setShowRefundConfirm(._ => Dialog.Show)
                          : setShowNothingToRefund(._ => Dialog.Show)
                      }}>
                      {j`선택 항목 환불 처리`->React.string}
                    </button>
                  | Some(CREATE)
                  | Some(PACKING)
                  | Some(DEPARTURE)
                  | Some(ERROR) =>
                    <button
                      className=%twc(
                        "h-9 px-3 text-enabled-L1 bg-div-shape-L1 rounded-lg flex items-center mr-2 focus:outline-none focus:ring-2 focus:ring-offset-1 focus:ring-div-shape-L1 focus:ring-opacity-100"
                      )
                      onClick={_ => {
                        countOfChecked > 0
                          ? setShowCancelConfirm(._ => Dialog.Show)
                          : setShowNothingToCancel(._ => Dialog.Show)
                      }}>
                      {j`주문 취소`->React.string}
                    </button>
                  | Some(NEGOTIATING) => <>
                      <button
                        className=%twc(
                          "h-9 px-3 text-primary bg-primary-light rounded-lg flex items-center mr-2 focus:outline-none focus:ring-2 focus:ring-offset-1 focus:ring-primary-light focus:ring-opacity-100"
                        )
                        onClick={_ => {
                          countOfChecked > 0
                            ? setShowCompleteConfirm(._ => Dialog.Show)
                            : setShowNothingToComplete(._ => Dialog.Show)
                        }}>
                        {j`배송완료 처리`->React.string}
                      </button>
                      <button
                        className=%twc(
                          "h-9 px-3 text-enabled-L1 bg-div-shape-L1 rounded-lg flex items-center mr-2 focus:outline-none focus:ring-2 focus:ring-offset-1 focus:ring-div-shape-L1 focus:ring-opacity-100"
                        )
                        onClick={_ => {
                          countOfChecked > 0
                            ? setShowCancelConfirm(._ => Dialog.Show)
                            : setShowNothingToCancel(._ => Dialog.Show)
                        }}>
                        {j`주문 취소`->React.string}
                      </button>
                    </>
                  | Some(DELIVERING)
                  | Some(CANCEL)
                  | Some(REFUND)
                  | None => React.null
                  }
                }
                <Excel_Download_Request_Button
                  userType=Admin requestUrl="/order/request-excel/buyer"
                />
              </div>
            </div>
          </div>
          <List
            status
            check
            onCheckOrder=handleOnCheckOrder
            onCheckAll=handleCheckAll
            countOfChecked
            onClickCancel=cancelOrder
          />
        </div>
      </div>
      <Dialog
        isShow=isShowCancelConfirm
        textOnCancel=`취소`
        onCancel={_ => setShowCancelConfirm(._ => Dialog.Hide)}
        textOnConfirm=`확인`
        onConfirm={_ => cancelOrder(selectedOrders->Set.String.toArray)}>
        <p className=%twc("text-black-gl text-center whitespace-pre-wrap")>
          <span className=%twc("font-bold")>
            {j`선택한 ${countOfChecked->Int.toString}개`->React.string}
          </span>
          {j`의 주문을 취소하시겠습니까?`->React.string}
        </p>
      </Dialog>
      <Dialog
        isShow=isShowRefundConfirm
        textOnCancel=`취소`
        onCancel={_ => setShowRefundConfirm(._ => Dialog.Hide)}
        textOnConfirm=`확인`
        onConfirm={_ => refundOrder(selectedOrders->Set.String.toArray)}>
        <div className=%twc("text-black-gl text-center whitespace-pre-wrap")>
          <h3>
            <span className=%twc("font-bold")>
              {j`선택한 ${countOfChecked->Int.toString}개`->React.string}
            </span>
            {j`의 주문을 환불 처리하시겠습니까?`->React.string}
          </h3>
          <ul className=%twc("list-disc list-inside text-left mt-4")>
            <li className=%twc("py-1")>
              {j`자동환불이 되지 않습니다. 카드사, 무통장 입금 환불 완료 후 환불처리를 진행해주세요.`->React.string}
            </li>
            <li className=%twc("py-1")>
              {j`이후 수정이 어렵습니다. 신중히 처리 부탁드립니다.`->React.string}
            </li>
          </ul>
          <span className=%twc("block text-left mt-8 mb-1")> {j`환불사유`->React.string} </span>
          <span className=%twc("block")>
            <label className=%twc("flex items-center relative")>
              <span
                className=%twc(
                  "flex-1 flex items-center border border-border-default-L1 rounded-lg h-12 px-3 text-enabled-L1"
                )>
                {displayRefundReason(refundReason)->React.string}
              </span>
              <span className=%twc("absolute right-2")>
                <IconArrowSelect height="24" width="24" fill="#121212" />
              </span>
              <select
                value={refundReason
                ->refundReason_encode
                ->Converter.getStringFromJsonWithDefault("")}
                className=%twc("block w-full h-full absolute top-0 opacity-0")
                onChange=handleOnChangeRefundReason>
                {[DeliveryDelayed, DefectiveProduct]
                ->Garter.Array.map(rr =>
                  <option
                    key={rr->refundReason_encode->Converter.getStringFromJsonWithDefault("")}
                    value={rr->refundReason_encode->Converter.getStringFromJsonWithDefault("")}>
                    {rr->displayRefundReason->React.string}
                  </option>
                )
                ->React.array}
              </select>
            </label>
          </span>
        </div>
      </Dialog>
      <Dialog
        isShow=isShowCompleteConfirm
        textOnCancel=`취소`
        onCancel={_ => setShowCompleteConfirm(._ => Dialog.Hide)}
        textOnConfirm=`확인`
        onConfirm={_ => completeOrder(selectedOrders->Set.String.toArray)}>
        <p className=%twc("text-black-gl text-center whitespace-pre-wrap")>
          <span className=%twc("font-bold")>
            {j`선택한 ${countOfChecked->Int.toString}개`->React.string}
          </span>
          {j`의 주문을 배송완료처리 하시겠습니까?`->React.string}
        </p>
      </Dialog>
      <Dialog
        isShow=isShowNothingToCancel
        textOnCancel=`확인`
        onCancel={_ => setShowNothingToCancel(._ => Dialog.Hide)}>
        <p className=%twc("text-black-gl text-center whitespace-pre-wrap")>
          {j`취소할 주문을 선택해주세요.`->React.string}
        </p>
      </Dialog>
      <Dialog
        isShow=isShowNothingToRefund
        textOnCancel=`확인`
        onCancel={_ => setShowNothingToRefund(._ => Dialog.Hide)}>
        <p className=%twc("text-black-gl text-center whitespace-pre-wrap")>
          {j`환불 처리할 주문을 선택해주세요.`->React.string}
        </p>
      </Dialog>
      <Dialog
        isShow=isShowNothingToComplete
        textOnCancel=`확인`
        onCancel={_ => setShowNothingToComplete(._ => Dialog.Hide)}>
        <p className=%twc("text-black-gl text-center whitespace-pre-wrap")>
          {j`배송완료할 주문을 선택해주세요.`->React.string}
        </p>
      </Dialog>
      <Dialog isShow=isShowCancelSuccess onConfirm={_ => setShowCancelSuccess(._ => Dialog.Hide)}>
        <p className=%twc("text-gray-500 text-center whitespace-pre-wrap")>
          {successResultCancel->Option.mapWithDefault(
            `주문 취소에 성공하였습니다.`->React.string,
            ((totalCount, updateCount)) =>
              if totalCount - updateCount > 0 {
                <>
                  <span className=%twc("font-bold")>
                    {`${totalCount->Int.toString}개 중 ${updateCount->Int.toString}개가 정상적으로 주문취소 처리되었습니다.`->React.string}
                  </span>
                  {`\n\n${(totalCount - updateCount)
                      ->Int.toString}개의 주문은 상품준비중 등의 이유로 주문취소 처리되지 못했습니다`->React.string}
                </>
              } else {
                `${totalCount->Int.toString}개의 주문이 정상적으로 주문취소 처리되었습니다.`->React.string
              },
          )}
        </p>
      </Dialog>
      <Dialog isShow=isShowCancelError onConfirm={_ => setShowCancelError(._ => Dialog.Hide)}>
        <p className=%twc("text-gray-500 text-center whitespace-pre-wrap")>
          {`주문 취소에 실패하였습니다.\n다시 시도하시기 바랍니다.`->React.string}
        </p>
      </Dialog>
      <Dialog isShow=isShowRefundSuccess onConfirm={_ => setShowRefundSuccess(._ => Dialog.Hide)}>
        <p className=%twc("text-gray-500 text-center whitespace-pre-wrap")>
          {successResultRefund->Option.mapWithDefault(
            `주문 환불 처리에 성공하였습니다.`->React.string,
            ((totalCount, updateCount)) =>
              if totalCount - updateCount > 0 {
                <>
                  <span className=%twc("font-bold")>
                    {`${totalCount->Int.toString}개 중 ${updateCount->Int.toString}개가 정상적으로 환불 처리되었습니다.`->React.string}
                  </span>
                  {`\n\n${(totalCount - updateCount)
                      ->Int.toString}개의 주문은 상품준비중 등의 이유로 환불 처리되지 못했습니다`->React.string}
                </>
              } else {
                `${totalCount->Int.toString}개의 주문이 정상적으로 환불 처리되었습니다.`->React.string
              },
          )}
        </p>
      </Dialog>
      <Dialog isShow=isShowRefundError onConfirm={_ => setShowRefundError(._ => Dialog.Hide)}>
        <p className=%twc("text-gray-500 text-center whitespace-pre-wrap")>
          {`환불 처리에 실패하였습니다.\n다시 시도하시기 바랍니다.`->React.string}
        </p>
      </Dialog>
      <Dialog
        isShow=isShowCompleteSuccess onConfirm={_ => setShowCompleteSuccess(._ => Dialog.Hide)}>
        <p className=%twc("text-gray-500 text-center whitespace-pre-wrap")>
          {successResultComplete->Option.mapWithDefault(
            `배송완료 처리에 성공하였습니다.`->React.string,
            ((totalCount, updateCount)) =>
              if totalCount - updateCount > 0 {
                <>
                  <span className=%twc("font-bold")>
                    {`${totalCount->Int.toString}개 중 ${updateCount->Int.toString}개가 정상적으로 배송완료 처리되었습니다.`->React.string}
                  </span>
                  {`\n\n${(totalCount - updateCount)
                      ->Int.toString}개의 주문은 상품준비중 등의 이유로 배송완료 처리되지 못했습니다`->React.string}
                </>
              } else {
                `${totalCount->Int.toString}개의 주문이 정상적으로 배송완료 처리되었습니다.`->React.string
              },
          )}
        </p>
      </Dialog>
      <Dialog isShow=isShowCompleteError onConfirm={_ => setShowCompleteError(._ => Dialog.Hide)}>
        <p className=%twc("text-gray-500 text-center whitespace-pre-wrap")>
          {`배송완료 처리에 실패하였습니다.\n다시 시도하시기 바랍니다.`->React.string}
        </p>
      </Dialog>
    </>
  }
}

@react.component
let make = () =>
  <Authorization.Admin title=j`관리자 주문서 조회`> <Orders /> </Authorization.Admin>
