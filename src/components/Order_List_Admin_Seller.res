module Header = {
  @react.component
  let make = (~checked=?, ~onChange=?, ~disabled=?) =>
    <div className=%twc("grid grid-cols-12-gl-admin bg-gray-100 text-gray-500 h-12")>
      <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
        <Checkbox id="check-all" ?checked ?onChange ?disabled />
      </div>
      <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
        {j`생산자명·바이어명`->React.string}
      </div>
      <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
        {j`요청일`->React.string}
      </div>
      <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
        {j`상품번호·단품번호`->React.string}
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
      <div className=%twc("h-full px-4 flex items-center pr-4 whitespace-nowrap")>
        {j`주소·우편번호`->React.string}
      </div>
      <div className=%twc("h-full px-4 flex items-center pr-4 whitespace-nowrap")>
        {j`주문자명·연락처`->React.string}
      </div>
      <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
        {j`배송메세지`->React.string}
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
            "divide-y divide-gray-100 lg:list-height-admin-seller lg:overflow-y-scroll"
          )>
          {Garter.Array.make(5, 0)
          ->Garter.Array.map(_ => <Order_Admin_Seller.Item.Loading />)
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
  ~countOfChecked,
  ~onCheckAll,
  ~onClickPacking,
) => {
  switch status {
  | Error(error) => <ErrorPanel error renderOnRetry={<Loading />} />
  | Loading => <Loading />
  | Loaded(orders) =>
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
        orders'.data->Garter.Array.keep(order => order.status === CREATE)->Garter.Array.length == 0
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
                "divide-y divide-gray-100 lg:list-height-admin-seller lg:overflow-y-scroll"
              )>
              {orders'.data->Garter.Array.length > 0
                ? orders'.data
                  ->Garter.Array.map(order =>
                    <Order_Admin_Seller
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
        switch orders->CustomHooks.OrdersAdmin.orders_decode {
        | Ok(orders') =>
          <div className=%twc("flex justify-center pt-5")>
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
