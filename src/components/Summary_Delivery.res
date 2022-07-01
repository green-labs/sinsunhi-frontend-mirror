module Admin = Summary_Delivery_Admin

module DeliveryCard = {
  @react.component
  let make = (~order: CustomHooks.OrdersSummaryFarmerDelivery.order) => {
    <div
      className=%twc(
        "inline-block border rounded py-4 px-5 min-w-4/5 mr-2 sm:min-w-1/2 lg:min-w-1/3 xl:min-w-1/5"
      )>
      <div className=%twc("flex justify-between items-center")>
        <span className=%twc("text-sm")> {order.productName->React.string} </span>
        <span className=%twc("text-green-gl font-bold ml-4")>
          {`${order.orderCount->Int.toString}건`->React.string}
        </span>
      </div>
      <div className=%twc("text-sm text-gray-400")> {order.productOptionName->React.string} </div>
    </div>
  }
}

@react.component
let make = () => {
  let status = CustomHooks.OrdersSummaryFarmerDelivery.use()

  let (undeliveredCount, orders) = switch status {
  | Loaded(orders) =>
    switch orders->CustomHooks.OrdersSummaryFarmerDelivery.orders_decode {
    | Ok(orders') => (orders'.count, orders'.data)
    | Error(_) => (0, [])
    }
  | _ => (0, [])
  }

  <div className=%twc("px-0 lg:px-20")>
    <div className=%twc("px-4 py-7 mt-4 shadow-gl sm:px-7")>
      <div className=%twc("flex")>
        <h3 className=%twc("font-bold text-lg")> {j`출고요약`->React.string} </h3>
        <span className=%twc("ml-4 text-green-gl text-sm")>
          {j`미출고`->React.string}
          <span className=%twc("ml-2 font-bold text-base")>
            {undeliveredCount->Int.toString->React.string}
          </span>
        </span>
      </div>
      <div className=%twc("mt-3 flex overflow-x-scroll")>
        {orders
        ->Garter.Array.map(order => {
          <DeliveryCard key={`${order.productName}-${order.productOptionName}`} order />
        })
        ->React.array}
      </div>
    </div>
  </div>
}
