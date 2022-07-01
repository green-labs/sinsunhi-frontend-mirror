module Header = {
  @react.component
  let make = () =>
    <div className=%twc("grid grid-cols-11-gl-admin bg-gray-100 text-gray-500 h-12")>
      <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
        {j`생산자명·바이어명`->React.string}
      </div>
      <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
        {j`요청일`->React.string}
      </div>
      <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
        {j`상품번호`->React.string}
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
          ->Garter.Array.map(_ => <Order_Admin_Seller_Packing.Item.Loading />)
          ->React.array}
        </ol>
      </div>
    </div>
}

@react.component
let make = (~status: CustomHooks.OrdersAdmin.result) => {
  switch status {
  | Error(error) => <ErrorPanel error renderOnRetry={<Loading />} />
  | Loading => <Loading />
  | Loaded(orders) => <>
      <div className=%twc("w-full overflow-x-scroll")>
        <div className=%twc("min-w-max text-sm divide-y divide-gray-100")>
          <Header />
          {switch orders->CustomHooks.OrdersAdmin.orders_decode {
          | Ok(orders') =>
            <ol
              className=%twc(
                "divide-y divide-gray-100 lg:list-height-admin-seller lg:overflow-y-scroll"
              )>
              {orders'.data->Garter.Array.length > 0
                ? orders'.data
                  ->Garter.Array.map(order =>
                    <Order_Admin_Seller_Packing key=order.orderProductNo order />
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
