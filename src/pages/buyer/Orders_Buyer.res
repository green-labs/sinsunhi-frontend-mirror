external unsafeAsFile: Webapi.Blob.t => Webapi.File.t = "%identity"

module List = {
  @react.component
  let make = (
    ~status: CustomHooks.Orders.result,
    ~check,
    ~onCheckOrder,
    ~onCheckAll,
    ~countOfChecked,
    ~onClickCancel,
  ) => {
    switch status {
    | Error(error) => <ErrorPanel error />
    | Loading => <div> {j`로딩 중..`->React.string} </div>
    | Loaded(orders) =>
      // 1024px 이하에서는 PC뷰의 레이아웃이 사용성을 해칠 수 밖에 없다고 판단되어
      // breakpoint lg(1024px)을 기준으로 구분한다.
      let countOfOrdersToCheck = {
        switch orders->CustomHooks.Orders.orders_decode {
        | Ok(orders') =>
          orders'.data->Garter.Array.keep(order => order.status === CREATE)->Garter.Array.length
        | Error(_) => 0
        }
      }

      let isCheckAll = countOfOrdersToCheck !== 0 && countOfOrdersToCheck === countOfChecked

      let isDisabledCheckAll = switch status {
      | Loaded(orders) =>
        switch orders->CustomHooks.Orders.orders_decode {
        | Ok(orders') =>
          orders'.data
          ->Garter.Array.keep(order => order.status === CREATE)
          ->Garter.Array.length == 0
        | Error(_) => true
        }
      | _ => true
      }

      <>
        <div className=%twc("w-full overflow-x-scroll")>
          <div className=%twc("text-sm lg:min-w-max")>
            <div
              className=%twc(
                "hidden lg:grid lg:grid-cols-9-buyer-order bg-gray-100 text-gray-500 h-12"
              )>
              <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
                <Checkbox
                  id="check-all"
                  checked={isCheckAll}
                  onChange=onCheckAll
                  disabled=isDisabledCheckAll
                />
              </div>
              <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
                {j`주문번호·일자·바이어`->React.string}
              </div>
              <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
                {j`주문상품`->React.string}
              </div>
              <div className=%twc("h-full px-4 flex items-center text-center whitespace-nowrap")>
                {j`상품금액·결제수단`->React.string}
              </div>
              <div className=%twc("h-full px-4 flex items-center text-center whitespace-nowrap")>
                {j`수량`->React.string}
              </div>
              <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
                {j`운송장번호`->React.string}
              </div>
              <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
                {j`배송정보`->React.string}
              </div>
              <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
                {j`주문자명·연락처`->React.string}
              </div>
              <div className=%twc("h-full px-4 flex items-center whitespace-nowrap text-center")>
                {j`출고일`->React.string}
              </div>
            </div>
            {switch orders->CustomHooks.Orders.orders_decode {
            | Ok(orders') =>
              <ol
                className=%twc(
                  "divide-y divide-gray-300 lg:divide-gray-100 lg:list-height-buyer lg:overflow-y-scroll"
                )>
                {orders'.data->Garter.Array.length > 0
                  ? orders'.data
                    ->Garter.Array.map(order =>
                      <Order_Buyer
                        key=order.orderProductNo order check onCheckOrder onClickCancel
                      />
                    )
                    ->React.array
                  : <EmptyOrders />}
              </ol>
            | Error(_error) => <EmptyOrders />
            }}
          </div>
        </div>
        {switch status {
        | Loaded(orders) =>
          switch orders->CustomHooks.Orders.orders_decode {
          | Ok(orders') =>
            <div className=%twc("flex justify-center py-5")>
              <Pagination
                pageDisplySize=Constants.pageDisplySize
                itemPerPage=orders'.limit
                total=orders'.count
              />
            </div>
          | Error(_) => React.null
          }
        | _ => React.null
        }}
      </>
    }
  }
}

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

module Orders = {
  @react.component
  let make = () => {
    let router = Next.Router.useRouter()
    let {mutate} = Swr.useSwrConfig()

    let status = CustomHooks.Orders.use(
      router.query->Webapi.Url.URLSearchParams.makeWithDict->Webapi.Url.URLSearchParams.toString,
    )

    let (ordersToCancel, setOrdersToCancel) = React.Uncurried.useState(_ => Set.String.empty)

    let (isShowCancelConfirm, setShowCancelConfirm) = React.Uncurried.useState(_ => Dialog.Hide)
    let (isShowNothingToCancel, setShowNothingToCancel) = React.Uncurried.useState(_ => Dialog.Hide)
    let (successResultCancel, setSuccessResultCancel) = React.Uncurried.useState(_ => None)
    let (isShowCancelSuccess, setShowCancelSuccess) = React.Uncurried.useState(_ => Dialog.Hide)
    let (isShowCancelError, setShowCancelError) = React.Uncurried.useState(_ => Dialog.Hide)

    // 검색 조건이 바뀌면(예를 들어 페이지 변경 등) 선택했던 취소할 주문을 초기화 한다.
    React.useEffect1(_ => {
      setOrdersToCancel(._ => Set.String.empty)
      None
    }, [router.query])

    let count = switch status {
    | Loaded(orders) =>
      switch orders->CustomHooks.Orders.orders_decode {
      | Ok(orders') => orders'.count->Int.toString
      | Error(_) => `-`
      }
    | _ => `-`
    }

    let handleOnCheckOrder = (orderProductNo, e) => {
      let checked = (e->ReactEvent.Synthetic.target)["checked"]
      if checked {
        let newOrdersToCancel = ordersToCancel->Set.String.add(orderProductNo)
        setOrdersToCancel(._ => newOrdersToCancel)
      } else {
        let newOrdersToCancel = ordersToCancel->Set.String.remove(orderProductNo)
        setOrdersToCancel(._ => newOrdersToCancel)
      }
    }
    let check = orderProductNo => {
      ordersToCancel->Set.String.has(orderProductNo)
    }

    let handleCheckAll = e => {
      let checked = (e->ReactEvent.Synthetic.target)["checked"]
      if checked {
        switch status {
        | Loaded(orders) =>
          let allOrderProductNo = switch orders->CustomHooks.Orders.orders_decode {
          | Ok(orders') =>
            orders'.data
            ->Garter.Array.keep(order => order.status === CREATE)
            ->Garter.Array.map(order => order.orderProductNo)
            ->Set.String.fromArray
          | Error(_) => Set.String.empty
          }
          setOrdersToCancel(._ => allOrderProductNo)
        | _ => ()
        }
      } else {
        setOrdersToCancel(._ => Set.String.empty)
      }
    }
    let countOfChecked = ordersToCancel->Set.String.size

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

              setOrdersToCancel(._ => Set.String.empty)
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

    let isTotalSelected = router.query->Js.Dict.get("status")->Option.isNone

    let isCreateSelected =
      router.query->Js.Dict.get("status")->Option.keep(status => status === "CREATE")->Option.isSome

    <>
      <div className=%twc("sm:px-10 md:px-20")>
        <Summary_Order_Buyer />
        <div className=%twc("lg:px-7 mt-4 shadow-gl")>
          <div className=%twc("md:flex md:justify-between pb-4 text-base")>
            <div
              className=%twc(
                "pt-10 px-5 flex flex-col lg:flex-row sm:flex-auto sm:justify-between"
              )>
              <h3 className=%twc("font-bold")>
                {j`주문내역`->React.string}
                <span className=%twc("ml-1 text-green-gl font-normal")>
                  {j`${count}건`->React.string}
                </span>
              </h3>
              <div className=%twc("flex flex-col lg:flex-row mt-4 lg:mt-0")>
                <div className=%twc("flex items-center")>
                  <Select_CountPerPage className=%twc("mr-2") />
                  <Select_Sorted className=%twc("mr-2") />
                </div>
                <div className=%twc("flex mt-2 lg:mt-0")>
                  {isTotalSelected || isCreateSelected
                    ? <button
                        className=%twc(
                          "hidden lg:flex items-center h-9 px-3 text-white bg-green-gl rounded-lg mr-2"
                        )
                        onClick={_ =>
                          countOfChecked > 0
                            ? setShowCancelConfirm(._ => Dialog.Show)
                            : setShowNothingToCancel(._ => Dialog.Show)}>
                        {j`선택한 항목 주문 취소`->React.string}
                      </button>
                    : React.null}
                  <Excel_Download_Request_Button
                    userType=Buyer requestUrl="/order/request-excel/buyer"
                  />
                </div>
              </div>
            </div>
          </div>
          <List
            status
            check
            onCheckOrder=handleOnCheckOrder
            countOfChecked
            onCheckAll=handleCheckAll
            onClickCancel=cancelOrder
          />
        </div>
      </div>
      <Dialog
        isShow=isShowCancelConfirm
        textOnCancel=`취소`
        onCancel={_ => setShowCancelConfirm(._ => Dialog.Hide)}
        textOnConfirm=`확인`
        onConfirm={_ => cancelOrder(ordersToCancel->Set.String.toArray)}>
        <a id="link-of-guide" href=Env.cancelFormUrl target="_blank" className=%twc("hidden") />
        <p className=%twc("text-black-gl text-center whitespace-pre-wrap")>
          <span className=%twc("font-bold")>
            {j`선택한 ${countOfChecked->Int.toString}개`->React.string}
          </span>
          {j`의 주문을 취소하시겠습니까?`->React.string}
        </p>
      </Dialog>
      <Dialog
        isShow=isShowNothingToCancel
        textOnCancel=`확인`
        onCancel={_ => setShowNothingToCancel(._ => Dialog.Hide)}>
        <a id="link-of-guide" href=Env.cancelFormUrl target="_blank" className=%twc("hidden") />
        <p className=%twc("text-black-gl text-center whitespace-pre-wrap")>
          {j`취소할 주문을 선택해주세요.`->React.string}
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
    </>
  }
}

@react.component
let make = () =>
  <Authorization.Buyer title=j`주문내역 조회`> <Orders /> </Authorization.Buyer>
