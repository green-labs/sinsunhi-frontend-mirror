module Header = {
  @react.component
  let make = (~checked=?, ~onChange=?, ~disabled=?) =>
    <div className=%twc("grid grid-cols-10-gl-admin bg-gray-100 text-gray-500 h-12")>
      <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
        <Checkbox id="check-all" ?checked ?onChange ?disabled />
      </div>
      <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
        {j`주문번호·일자`->React.string}
      </div>
      <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
        {j`바이어·생산자`->React.string}
      </div>
      <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
        {j`주문상품`->React.string}
      </div>
      <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
        {j`상품금액·결제수단`->React.string}
      </div>
      <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
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
}

module Loading = {
  @react.component
  let make = () =>
    <div className=%twc("w-full overflow-x-scroll")>
      <div className=%twc("min-w-max text-sm divide-y divide-gray-100")>
        <Header />
        <ol
          className=%twc(
            "divide-y divide-gray-100 lg:list-height-admin-buyer lg:overflow-y-scroll"
          )>
          {Garter.Array.make(5, 0)
          ->Garter.Array.map(_ => <Order_Admin.Item.Table.Loading />)
          ->React.array}
        </ol>
      </div>
    </div>
}

@react.component
let make = (
  ~status: CustomHooks.OrdersAdmin.result,
  ~check,
  ~onCheckOrder,
  ~onCheckAll,
  ~countOfChecked,
  ~onClickCancel,
) => {
  switch status {
  | Error(error) => <ErrorPanel error renderOnRetry={<Loading />} />
  | Loading => <Loading />
  | Loaded(orders) =>
    let countOfOrdersToCheck = {
      switch orders->CustomHooks.OrdersAdmin.orders_decode {
      | Ok(orders') =>
        orders'.data->Garter.Array.keep(Order_Admin.isCheckableOrder)->Garter.Array.length
      | Error(_) => 0
      }
    }

    let isCheckAll = countOfOrdersToCheck !== 0 && countOfOrdersToCheck === countOfChecked

    let isDisabledCheckAll = switch status {
    | Loaded(orders) =>
      switch orders->CustomHooks.OrdersAdmin.orders_decode {
      | Ok(orders') =>
        orders'.data->Garter.Array.keep(Order_Admin.isCheckableOrder)->Garter.Array.length == 0
      | Error(_) => true
      }
    | _ => true
    }

    <>
      <div className=%twc("w-full overflow-x-scroll")>
        <div className=%twc("min-w-max text-sm divide-y divide-gray-100")>
          <Header checked=isCheckAll onChange=onCheckAll disabled=isDisabledCheckAll />
          {switch orders->CustomHooks.OrdersAdmin.orders_decode {
          | Ok(orders') =>
            <ol
              className=%twc(
                "divide-y divide-gray-100 lg:list-height-admin-buyer lg:overflow-y-scroll"
              )>
              {orders'.data->Garter.Array.length > 0
                ? orders'.data
                  ->Garter.Array.map(order =>
                    <Order_Admin key=order.orderProductNo order check onCheckOrder onClickCancel />
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
          <div className=%twc("flex justify-center pt-5")>
            React.null
            <Pagination
              pageDisplySize=Constants.pageDisplySize itemPerPage=orders'.limit total=orders'.count
            />
          </div>
        | Error(_) => React.null
        }
      | _ => React.null
      }}
    </>
  }
}
