@react.component
let make = (~status: CustomHooks.OrdersAdminUncompleted.result) => {
  switch status {
  | Error(error) => <ErrorPanel error />
  | Loading => <div> {j`로딩 중..`->React.string} </div>
  | Loaded(orders) => <>
      <ol className=%twc("table w-full overflow-x-scroll text-sm")>
        <li className=%twc("hidden lg:table-row bg-gray-100 text-gray-500")>
          <div className=%twc("table-cell py-2 pl-4 whitespace-nowrap")>
            {j`일자`->React.string}
          </div>
          <div className=%twc("table-cell p-2 whitespace-nowrap")>
            {j`바이어명`->React.string}
          </div>
          <div className=%twc("table-cell p-2 whitespace-nowrap")>
            {j`이메일·연락처`->React.string}
          </div>
          <div className=%twc("table-cell p-2 whitespace-nowrap")>
            {j`주문가능금액`->React.string}
          </div>
          <div className=%twc("table-cell p-2 whitespace-nowrap")>
            {j`발주요청금액`->React.string}
          </div>
          <div className=%twc("table-cell p-2 whitespace-nowrap")>
            {j`처리실패 이유`->React.string}
          </div>
        </li>
        {switch orders->CustomHooks.OrdersAdminUncompleted.orders_decode {
        | Ok(orders') =>
          orders'.data
          ->Garter.Array.map(order => <Order_Admin_Uncompleted key=order.orderNo order />)
          ->React.array
        | Error(error) =>
          error->Js.Console.log
          React.null
        }}
      </ol>
      {switch status {
      | Loaded(orders) =>
        switch orders->CustomHooks.OrdersAdminUncompleted.orders_decode {
        | Ok(orders') =>
          <div className=%twc("flex justify-center py-10")>
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
