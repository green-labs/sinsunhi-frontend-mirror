let formatDate = d => d->Js.Date.fromString->Locale.DateTime.formatFromUTC("yyyy/MM/dd HH:mm")

let isCheckableOrder = (order: CustomHooks.OrdersAdmin.order) =>
  switch order.status {
  | CREATE
  | PACKING
  | DEPARTURE
  | ERROR
  | NEGOTIATING
  | COMPLETE => true
  | DELIVERING
  | CANCEL
  | REFUND => false
  }

let payTypeToText = payType => {
  open CustomHooks.OrdersAdmin
  switch payType {
  | PAID => `신선캐시`
  | AFTER_PAY => `나중결제`
  }
}

module Item = {
  module Table = {
    @react.component
    let make = (~order: CustomHooks.OrdersAdmin.order, ~check, ~onCheckOrder, ~onClickCancel) => {
      let (isShowCancelConfirm, setShowCancelConfirm) = React.Uncurried.useState(_ => Dialog.Hide)

      let status = CustomHooks.Courier.use()

      let courierName = switch status {
      | Loaded(couriers) =>
        order.courierCode
        ->Option.flatMap(courierCode' => {
          couriers
          ->CustomHooks.Courier.response_decode
          ->Result.map(couriers' => {
            couriers'.data->Array.getBy(courier => courier.code === courierCode')
          })
          ->Result.getWithDefault(None)
        })
        ->Option.map(courier => courier.name)
        ->Option.getWithDefault(`-`)
      | _ => `-`
      }

      let isDisabedCheckbox = !isCheckableOrder(order)

      let refundReason = order.refundReason

      <>
        <li className=%twc("grid grid-cols-10-gl-admin text-gray-700")>
          <div className=%twc("h-full flex flex-col px-4 py-2")>
            <Checkbox
              id={`checkbox-${order.orderProductNo}`}
              checked={check(order.orderProductNo)}
              onChange={onCheckOrder(order.orderProductNo)}
              disabled=isDisabedCheckbox
            />
          </div>
          <div className=%twc("h-full flex flex-col px-4 py-2")>
            <Order_Detail_Button_Admin order />
            <span className=%twc("block text-gray-400 mb-1")>
              {order.orderDate->formatDate->React.string}
            </span>
            {order.refundRequestorName->Option.mapWithDefault(React.null, v =>
              <span className=%twc("block mb-1")> {`(담당: ${v})`->React.string} </span>
            )}
            <Badge_Admin status=order.status ?refundReason />
          </div>
          <div className=%twc("h-full flex flex-col px-4 py-2")>
            <span className=%twc("block mb-1")> {order.buyerName->React.string} </span>
            <span className=%twc("block mb-1")> {order.farmerName->React.string} </span>
          </div>
          <div className=%twc("h-full flex flex-col px-4 py-2")>
            <span className=%twc("block text-gray-400")>
              {`${order.productId->Int.toString} ・ ${order.productSku}`->React.string}
            </span>
            <span className=%twc("block truncate")> {order.productName->React.string} </span>
            <span className=%twc("block")>
              {order.productOptionName->Option.getWithDefault("")->React.string}
            </span>
          </div>
          <div className=%twc("h-full flex flex-col px-4 py-2")>
            <span className=%twc("whitespace-nowrap text-right")>
              {`${order.productPrice->Locale.Float.show(~digits=0)}원`->React.string}
              <br />
              {order.payType->payTypeToText->React.string}
            </span>
          </div>
          <div className=%twc("h-full flex flex-col px-4 py-2")>
            <span className=%twc("block")> {order.quantity->Int.toString->React.string} </span>
          </div>
          <div className=%twc("h-full flex flex-col px-4 py-2")>
            {switch order.status {
            | CREATE
            | PACKING =>
              <div className=%twc("flex flex-col")>
                <span> {`미등록`->React.string} </span>
                <button
                  type_="button"
                  className=%twc(
                    "px-3 max-h-10 bg-gray-gl text-gray-gl rounded-lg whitespace-nowrap py-1 mt-2 max-w-min"
                  )
                  onClick={_ => setShowCancelConfirm(._ => Dialog.Show)}>
                  {j`주문취소`->React.string}
                </button>
              </div>
            | DEPARTURE
            | DELIVERING
            | COMPLETE
            | CANCEL
            | ERROR
            | REFUND
            | NEGOTIATING => <>
                <span className=%twc("block")> {courierName->React.string} </span>
                <span className=%twc("block text-gray-500")>
                  {order.invoice->Option.getWithDefault(`-`)->React.string}
                </span>
                <Tracking_Admin order />
              </>
            }}
          </div>
          {switch order.deliveryType {
          | Some(SELF) =>
            <div className=%twc("h-full flex flex-col px-4 py-2")>
              <span className=%twc("block")> {`직접수령`->React.string} </span>
            </div>
          | _ =>
            <div className=%twc("h-full flex flex-col px-4 py-2")>
              <span className=%twc("block")> {order.receiverName->Option.getWithDefault(`-`)->React.string} </span>
              <span className=%twc("block")>
                {order.receiverPhone->Option.getWithDefault(`-`)->React.string}
              </span>
              <span className=%twc("block text-gray-500")>
                {order.receiverAddress->Option.getWithDefault(`-`)->React.string}
              </span>
              <span className=%twc("block text-gray-500 whitespace-nowrap")>
                {order.receiverZipcode->Option.getWithDefault(`-`)->React.string}
              </span>
            </div>
          }}
          <div className=%twc("p-2 pr-4 align-top")>
            <span className=%twc("block")>
              {order.ordererName->Option.getWithDefault("")->React.string}
            </span>
            <span className=%twc("block")>
              {order.ordererPhone->Option.getWithDefault("")->React.string}
            </span>
          </div>
          <div className=%twc("h-full flex flex-col px-4 py-2 whitespace-nowrap")>
            <span className=%twc("block")>
              {order.deliveryDate->Option.map(formatDate)->Option.getWithDefault(`-`)->React.string}
            </span>
          </div>
        </li>
        // 다이얼로그
        <Dialog
          isShow=isShowCancelConfirm
          textOnCancel=`취소`
          onCancel={_ => setShowCancelConfirm(._ => Dialog.Hide)}
          textOnConfirm=`확인`
          onConfirm={_ => {
            setShowCancelConfirm(._ => Dialog.Hide)
            onClickCancel([order.orderProductNo])
          }}>
          <p className=%twc("text-black-gl text-center whitespace-pre-wrap")>
            {j`선택한 주문을 취소하시겠습니까?`->React.string}
          </p>
        </Dialog>
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
let make = (~order: CustomHooks.OrdersAdmin.order, ~check, ~onCheckOrder, ~onClickCancel) => {
  <Item.Table order check onCheckOrder onClickCancel />
}
