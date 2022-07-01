module Header = {
  @react.component
  let make = () => {
    <div className=%twc("grid grid-cols-12-gl-admin-offline bg-gray-50 text-text-L2 h-12")>
      <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
        {j`수정중`->React.string}
      </div>
      <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
        {j`주문상품번호·주문번호`->React.string}
      </div>
      <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
        {j`출고예정일·출고일`->React.string}
      </div>
      <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
        {j`바이어명·코드`->React.string}
      </div>
      <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
        {j`생산자명·코드`->React.string}
      </div>
      <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
        {j`작물·품종명(코드)`->React.string}
      </div>
      <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
        {j`단품번호`->React.string}
      </div>
      <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
        {j`중량·포장규격`->React.string}
      </div>
      <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
        {j`등급`->React.string}
      </div>
      <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
        {j`주문수량·판매금액`->React.string}
      </div>
      <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
        {j`납품확정수량· 확정판매금액`->React.string}
      </div>
      <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
        {j`원가·판매가`->React.string}
      </div>
    </div>
  }
}
@react.component
let make = (~status: CustomHooks.OfflineOrders.result) => {
  switch status {
  | Loaded(orders) => <>
      <div className=%twc("w-full overflow-x-scroll")>
        <div className=%twc("min-w-max text-sm divide-y divide-gray-100")>
          <Header />
          <ol
            className=%twc(
              "divide-y divide-gray-100 lg:list-height-admin-buyer lg:overflow-y-scroll"
            )>
            {switch orders->CustomHooks.OfflineOrders.offlineOrders_decode {
            | Ok(orders') =>
              orders'.data
              ->Array.map(order => <OfflineOrder_Admin key={order.id->Int.toString} order />)
              ->React.array

            | Error(error) => {
                Js.log(error)
                React.null
              }
            }}
          </ol>
        </div>
      </div>
      <div className=%twc("flex justify-center pt-5")>
        {switch orders->CustomHooks.OfflineOrders.offlineOrders_decode {
        | Ok(orders') =>
          <Pagination
            pageDisplySize=Constants.pageDisplySize itemPerPage=orders'.limit total=orders'.count
          />

        | Error(error) => {
            Js.log(error)
            React.null
          }
        }}
      </div>
    </>
  | _ => React.null
  }
}
