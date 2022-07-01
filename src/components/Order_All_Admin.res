/**
 * 수기 주문데이터 관리자 업로드 시연용 컴포넌트
 * TODO: 시연이 끝나면 지워도 된다.
 */

let formatDate = d => d->Js.Date.fromString->Locale.DateTime.formatFromUTC("yyyy/MM/dd")

module Item = {
  module Table = {
    @react.component
    let make = (~order: CustomHooks.OrdersAllAdmin.order) => {
      <>
        <li className=%twc("grid grid-cols-9-admin-orders-all text-gray-700")>
          <div className=%twc("h-full flex flex-col px-4 py-2")>
            <span className=%twc("block text-gray-400 mb-1")>
              {order.no->Int.toString->React.string}
            </span>
          </div>
          <div className=%twc("h-full flex flex-col px-4 py-2")>
            <span className=%twc("block text-gray-400 mb-1")>
              {order.orderDate->formatDate->React.string}
            </span>
          </div>
          <div className=%twc("h-full flex flex-col px-4 py-2")>
            <span className=%twc("block mb-1")>
              {order.orderType
              ->CustomHooks.OrdersAllAdmin.orderType_encode
              ->Js.Json.decodeString
              ->Option.getWithDefault(`-`)
              ->React.string}
            </span>
          </div>
          <div className=%twc("h-full flex flex-col px-4 py-2")>
            <span className=%twc("block mb-1")>
              {order.producerName->Option.getWithDefault(`-`)->React.string}
            </span>
          </div>
          <div className=%twc("h-full flex flex-col px-4 py-2")>
            <span className=%twc("block mb-1")>
              {order.buyerName->Option.getWithDefault(`-`)->React.string}
            </span>
          </div>
          <div className=%twc("h-full flex flex-col px-4 py-2")>
            <span className=%twc("block mb-1")> {order.productCategory->React.string} </span>
          </div>
          <div>
            <span className=%twc("whitespace-nowrap")>
              {`${order.totalPrice->Locale.Float.show(~digits=0)}원`->React.string}
            </span>
          </div>
          <div className=%twc("h-full flex flex-col px-4 py-2")>
            <span className=%twc("block text-gray-400 mb-1")>
              {order.orderNo->Option.getWithDefault(`-`)->React.string}
            </span>
          </div>
          <div className=%twc("h-full flex flex-col px-4 py-2")>
            <span className=%twc("block")> {order.productName->React.string} </span>
            <span className=%twc("block")>
              {order.productOptionName->Option.getWithDefault("")->React.string}
            </span>
          </div>
        </li>
      </>
    }

    module Loading = {
      open Skeleton

      @react.component
      let make = () => {
        <li className=%twc("grid grid-cols-10-gl-admin")>
          <div className=%twc("h-full flex flex-col px-4 py-2")> <Checkbox /> </div>
          <div className=%twc("h-full flex flex-col px-4 py-2")>
            <Box className=%twc("w-20") /> <Box /> <Box className=%twc("w-12") />
          </div>
          <div className=%twc("h-full flex flex-col px-4 py-2")> <Box /> <Box /> </div>
          <div className=%twc("h-full flex flex-col px-4 py-2")>
            <Box /> <Box className=%twc("w-2/3") /> <Box className=%twc("w-8") />
          </div>
          <div className=%twc("h-full flex flex-col px-4 py-2")> <Box /> </div>
          <div className=%twc("h-full flex flex-col px-4 py-2")> <Box /> </div>
          <div className=%twc("h-full flex flex-col px-4 py-2")> <Box /> <Box /> </div>
          <div className=%twc("h-full flex flex-col px-4 py-2")>
            <Box /> <Box className=%twc("w-2/3") /> <Box className=%twc("w-1/3") />
          </div>
          <div className=%twc("p-2 pr-4 align-top")> <Box className=%twc("w-1/2") /> <Box /> </div>
          <div className=%twc("h-full flex flex-col px-4 py-2")> <Box /> </div>
        </li>
      }
    }
  }
}

@react.component
let make = (~order: CustomHooks.OrdersAllAdmin.order) => {
  <Item.Table order />
}
