module List = Order_List_Admin_Seller

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

module Orders = {
  @react.component
  let make = () => {
    let router = Next.Router.useRouter()
    let {mutate} = Swr.useSwrConfig()

    let status = CustomHooks.OrdersAdmin.use(
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
      switch orders->CustomHooks.OrdersAdmin.orders_decode {
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
      <div
        className=%twc(
          "max-w-gnb-panel overflow-auto overflow-x-scroll bg-div-shape-L1 min-h-screen"
        )>
        <header className=%twc("flex items-baseline p-7 pb-0")>
          <h1 className=%twc("font-bold text-xl")> {j`송장번호 조회`->React.string} </h1>
        </header>
        <Summary_Delivery_Admin />
        <div
          className=%twc("p-7 mt-4 mx-4 shadow-gl overflow-auto overflow-x-scroll bg-white rounded")>
          <div className=%twc("flex justify-between pb-4")>
            <div className=%twc("flex flex-auto justify-between")>
              <h3 className=%twc("font-bold")>
                {j`주문내역`->React.string}
                <span className=%twc("ml-1 text-green-gl font-normal")>
                  {j`${count}건`->React.string}
                </span>
              </h3>
              <div className=%twc("flex items-center")>
                <Select_CountPerPage className=%twc("mr-2") />
                <Select_Sorted className=%twc("mr-2") />
                {isTotalSelected || isCreateSelected
                  ? <button
                      className=%twc(
                        "h-9 px-3 text-white bg-green-gl rounded-lg flex items-center mr-2"
                      )
                      onClick={_ =>
                        countOfChecked > 0
                          ? setShowPackingConfirm(._ => Dialog.Show)
                          : setShowNothingToPacking(._ => Dialog.Show)}>
                      {j`상품준비중으로 변경`->React.string}
                    </button>
                  : React.null}
                <Excel_Download_Request_Button
                  userType=Admin requestUrl="/order/request-excel/farmer"
                />
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
  <Authorization.Admin title=j`관리자 송장번호 조회`> <Orders /> </Authorization.Admin>
