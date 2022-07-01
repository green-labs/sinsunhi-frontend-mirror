/**
 * 수기 주문데이터 관리자 업로드 시연용 컴포넌트
 * TODO: 시연이 끝나면 지워도 된다.
*/

module Header = {
  @react.component
  let make = () =>
    <div className=%twc("grid grid-cols-9-admin-orders-all bg-gray-100 text-gray-500 h-12")>
      <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
        {j`번호`->React.string}
      </div>
      <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
        {j`주문일자`->React.string}
      </div>
      <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
        {j`거래유형`->React.string}
      </div>
      <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
        {j`생산자명`->React.string}
      </div>
      <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
        {j`바이어명`->React.string}
      </div>
      <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
        {j`품목`->React.string}
      </div>
      <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
        {j`판매금액`->React.string}
      </div>
      <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
        {j`주문번호`->React.string}
      </div>
      <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
        {j`주문상품`->React.string}
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
          className=%twc("divide-y divide-gray-100 lg:list-height-admin-buyer lg:overflow-y-scroll")>
          {Garter.Array.make(5, 0)
          ->Garter.Array.map(_ => <Order_Admin.Item.Table.Loading />)
          ->React.array}
        </ol>
      </div>
    </div>
}

@react.component
let make = (~status: CustomHooks.OrdersAllAdmin.result) => {
  switch status {
  | Error(error) => <ErrorPanel error renderOnRetry={<Loading />} />
  | Loading => <Loading />
  | Loaded(orders) => <>
      <div className=%twc("w-full overflow-x-scroll")>
        <div className=%twc("min-w-max text-sm divide-y divide-gray-100")>
          <Header />
          {switch orders->CustomHooks.OrdersAllAdmin.orders_decode {
          | Ok(orders') =>
            <ol
              className=%twc(
                "divide-y divide-gray-100 lg:list-height-admin-buyer lg:overflow-y-scroll"
              )>
              {orders'.data->Garter.Array.length > 0
                ? orders'.data
                  ->Garter.Array.map(order =>
                    <Order_All_Admin key={order.no->Int.toString} order />
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
        switch orders->CustomHooks.OrdersAllAdmin.orders_decode {
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
