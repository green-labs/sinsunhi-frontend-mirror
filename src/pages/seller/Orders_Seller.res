external unsafeAsFile: Webapi.Blob.t => Webapi.File.t = "%identity"

module Notice = {
  @react.component
  let make = () => {
    <div className=%twc("mt-5 bg-div-shape-L2 rounded-lg")>
      <div className=%twc("p-7")>
        <div className=%twc("relative")>
          {`사전 품질관리를 통해 바이어와 소비자들의 신뢰도를 높이고 이를 통해 생산자분들께서 더 많은 매출을 올리실 수 있게끔`->React.string}
          <br />
          {`온라인 QC - PASS 제도가 다음과 같이 시행될 예정임을 안내드립니다.`->React.string}
          <span className=%twc("absolute bottom-0 right-0 underline text-text-L1")>
            <a
              href="https://greenlabs.notion.site/QC-PASS-a76474ecbdf545929b0b887de8d00801"
              target="_blank">
              {`자세히보기`->React.string}
            </a>
          </span>
        </div>
      </div>
    </div>
  }
}

module List = {
  @react.component
  let make = (
    ~status: CustomHooks.Orders.result,
    ~check,
    ~onCheckOrder,
    ~countOfChecked,
    ~onCheckAll,
    ~onClickPacking,
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
                "hidden lg:grid lg:grid-cols-11-gl-seller bg-gray-100 text-gray-500 h-12"
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
                {j`요청일`->React.string}
              </div>
              <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
                {j`상품번호·옵션번호`->React.string}
              </div>
              <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
                {j`주문번호`->React.string}
              </div>
              <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
                {j`택배사명·송장번호`->React.string}
              </div>
              <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
                {j`상품명·옵션·수량`->React.string}
              </div>
              <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
                {j`수취인·연락처`->React.string}
              </div>
              <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
                {j`가격정보`->React.string}
              </div>
              <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
                {j`주소·우편번호`->React.string}
              </div>
              <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
                {j`주문자명·연락처`->React.string}
              </div>
              <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
                {j`배송메세지`->React.string}
              </div>
            </div>
            {switch orders->CustomHooks.Orders.orders_decode {
            | Ok(orders') =>
              <ol
                className=%twc(
                  "divide-y divide-gray-300 lg:divide-gray-100 lg:list-height-seller lg:overflow-y-scroll"
                )>
                {orders'.data->Garter.Array.length > 0
                  ? orders'.data
                    ->Garter.Array.map(order =>
                      <Order_Seller
                        key=order.orderProductNo order check onCheckOrder onClickPacking
                      />
                    )
                    ->React.array
                  : <EmptyOrders />}
              </ol>
            | Error(error) =>
              error->Js.Console.log
              React.null
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

    let (ordersToPacking, setOrdersToPacking) = React.Uncurried.useState(_ => Set.String.empty)

    let (isShowPackingConfirm, setShowPackingConfirm) = React.Uncurried.useState(_ => Dialog.Hide)
    let (isShowNothingToPacking, setShowNothingToPacking) = React.Uncurried.useState(_ =>
      Dialog.Hide
    )
    let (successResultPacking, setSuccessResultPacking) = React.Uncurried.useState(_ => None)
    let (isShowPackingSuccess, setShowPackingSuccess) = React.Uncurried.useState(_ => Dialog.Hide)
    let (isShowPackingError, setShowPackingError) = React.Uncurried.useState(_ => Dialog.Hide)

    // 검색 조건이 바뀌면(예를 들어 페이지 변경 등) 선택했던 취소할 주문을 초기화 한다.
    React.useEffect1(_ => {
      setOrdersToPacking(._ => Set.String.empty)
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
        let newOrdersToPacking = ordersToPacking->Set.String.add(orderProductNo)
        setOrdersToPacking(._ => newOrdersToPacking)
      } else {
        let newOrdersToPacking = ordersToPacking->Set.String.remove(orderProductNo)
        setOrdersToPacking(._ => newOrdersToPacking)
      }
    }
    let check = orderProductNo => {
      ordersToPacking->Set.String.has(orderProductNo)
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
          setOrdersToPacking(._ => allOrderProductNo)
        | _ => ()
        }
      } else {
        setOrdersToPacking(._ => Set.String.empty)
      }
    }
    let countOfChecked = ordersToPacking->Set.String.size

    let changeOrdersToPacking = orders => {
      setShowPackingConfirm(._ => Dialog.Hide)
      {
        "order-product-numbers": orders,
      }
      ->Js.Json.stringifyAny
      ->Option.map(body => {
        FetchHelper.requestWithRetry(
          ~fetcher=FetchHelper.postWithToken,
          ~url=`${Env.restApiUrl}/order/packing`,
          ~body,
          ~count=3,
          ~onSuccess={
            res => {
              let result = switch res->response_decode {
              | Ok(res') => Some(res'.data.totalCount, res'.data.updateCount)
              | Error(_) => None
              }

              setSuccessResultPacking(._ => result)

              setShowPackingSuccess(._ => Dialog.Show)

              setOrdersToPacking(._ => Set.String.empty)
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
          ~onFailure={_ => setShowPackingError(._ => Dialog.Show)},
        )
      })
      ->ignore
    }

    let isTotalSelected = router.query->Js.Dict.get("status")->Option.isNone

    let isCreateSelected =
      router.query->Js.Dict.get("status")->Option.keep(status => status === "CREATE")->Option.isSome

    <>
      <div className=%twc("sm:px-10 md:px-20")>
        <Notice />
        <Summary_Order_Seller />
        <div className=%twc("lg:px-7 mt-4 shadow-gl overflow-x-scroll")>
          <div className=%twc("md:flex md:justify-between pb-4 text-base")>
            <div
              className=%twc(
                "pt-10 px-5 lg:px-0 flex flex-col lg:flex-row sm:flex-auto sm:justify-between"
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
                          "hidden lg:flex h-9 px-3 text-white bg-green-gl rounded-lg items-center mr-2"
                        )
                        onClick={_ =>
                          countOfChecked > 0
                            ? setShowPackingConfirm(._ => Dialog.Show)
                            : setShowNothingToPacking(._ => Dialog.Show)}>
                        {j`상품준비중으로 변경`->React.string}
                      </button>
                    : React.null}
                  <Excel_Download_Request_Button
                    userType=Seller requestUrl="/order/request-excel/farmer"
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
            onClickPacking=changeOrdersToPacking
          />
        </div>
      </div>
      // 다이얼로그
      <Dialog
        isShow=isShowPackingConfirm
        textOnCancel=`취소`
        onCancel={_ => setShowPackingConfirm(._ => Dialog.Hide)}
        textOnConfirm=`확인`
        onConfirm={_ => changeOrdersToPacking(ordersToPacking->Set.String.toArray)}>
        <p className=%twc("text-black-gl text-center whitespace-pre-wrap")>
          <span className=%twc("font-bold")>
            {j`선택한 ${countOfChecked->Int.toString}개`->React.string}
          </span>
          {j`의 주문을\n상품준비중으로 변경하시겠습니까?`->React.string}
        </p>
      </Dialog>
      <Dialog
        isShow=isShowNothingToPacking
        textOnCancel=`확인`
        onCancel={_ => setShowNothingToPacking(._ => Dialog.Hide)}>
        <a id="link-of-guide" href=Env.cancelFormUrl target="_blank" className=%twc("hidden") />
        <p className=%twc("text-black-gl text-center whitespace-pre-wrap")>
          {j`상품준비중으로 변경할 주문을 선택해주세요.`->React.string}
        </p>
      </Dialog>
      <Dialog isShow=isShowPackingSuccess onConfirm={_ => setShowPackingSuccess(._ => Dialog.Hide)}>
        <p className=%twc("text-gray-500 text-center whitespace-pre-wrap")>
          {successResultPacking->Option.mapWithDefault(
            `상품준비중 변경에 성공하였습니다.`->React.string,
            ((totalCount, updateCount)) =>
              if totalCount - updateCount > 0 {
                <>
                  <span className=%twc("font-bold")>
                    {`${totalCount->Int.toString}개 중 ${updateCount->Int.toString}개가 정상적으로 상품준비중으로 처리되었습니다.`->React.string}
                  </span>
                  {`\n\n${(totalCount - updateCount)
                      ->Int.toString}개의 주문은 바이어 주문취소 등의 이유로 상품준비중으로 처리되지 못했습니다`->React.string}
                </>
              } else {
                `${totalCount->Int.toString}개의 주문을 상품준비중으로 변경에 성공하였습니다.`->React.string
              },
          )}
        </p>
      </Dialog>
      <Dialog isShow=isShowPackingError onConfirm={_ => setShowPackingError(._ => Dialog.Hide)}>
        <p className=%twc("text-gray-500 text-center whitespace-pre-wrap")>
          {`상품준비중 변경에 실패하였습니다.\n다시 시도하시기 바랍니다.`->React.string}
        </p>
      </Dialog>
    </>
  }
}

@react.component
let make = () =>
  <Authorization.Seller title=j`주문내역 조회`> <Orders /> </Authorization.Seller>
