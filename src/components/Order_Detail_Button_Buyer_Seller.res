open RadixUI
let formatDate = d => d->Js.Date.fromString->Locale.DateTime.formatFromUTC("yyyy/MM/dd HH:mm")

module Converter = Converter.Status(CustomHooks.Orders)

@react.component
let make = (~order: CustomHooks.Orders.order) => {
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

  <Dialog.Root>
    <Dialog.Overlay className=%twc("dialog-overlay") />
    <Dialog.Trigger className=%twc("block text-left mb-1 underline focus:outline-none")>
      {order.orderProductNo->React.string}
    </Dialog.Trigger>
    <Dialog.Content className=%twc("dialog-content-detail overflow-y-auto")>
      <div className=%twc("p-5")>
        <div className=%twc("flex")>
          <h2 className=%twc("text-xl font-bold")> {j`주문상세조회`->React.string} </h2>
          <Dialog.Close className=%twc("focus:outline-none ml-auto")>
            <IconClose height="24" width="24" fill="#262626" />
          </Dialog.Close>
        </div>
        <h3 className=%twc("mt-10 font-bold")> {j`주문정보`->React.string} </h3>
        <section className=%twc("divide-y text-sm text-text-L2 mt-2 border-t border-b")>
          <div className=%twc("grid grid-cols-2-detail sm:grid-cols-4-detail")>
            <div className=%twc("p-3 bg-div-shape-L2")> {j`주문번호`->React.string} </div>
            <div className=%twc("p-3")> {order.orderProductNo->React.string} </div>
            <div className=%twc("p-3 bg-div-shape-L2 border-t sm:border-t-0")>
              {j`상품번호`->React.string}
            </div>
            <div className=%twc("p-3 border-t sm:border-t-0")>
              {order.productId->Int.toString->React.string}
            </div>
          </div>
          <div className=%twc("grid grid-cols-2-detail sm:grid-cols-4-detail")>
            <div className=%twc("p-3 bg-div-shape-L2")> {j`주문일시`->React.string} </div>
            <div className=%twc("p-3")> {order.orderDate->formatDate->React.string} </div>
            <div className=%twc("p-3 bg-div-shape-L2 border-t sm:border-t-0")>
              {j`결제금액`->React.string}
            </div>
            <div className=%twc("p-3 border-t sm:border-t-0")>
              {`${(order.productPrice *. order.quantity->Int.toFloat)
                  ->Locale.Float.show(~digits=0)}원`->React.string}
            </div>
          </div>
          <div className=%twc("grid grid-cols-2-detail")>
            <div className=%twc("p-3 bg-div-shape-L2")> {j`주문상태`->React.string} </div>
            <div className=%twc("p-3")> {order.status->Converter.displayStatus->React.string} </div>
          </div>
          <div className=%twc("grid grid-cols-2-detail sm:grid-cols-4-detail")>
            <div className=%twc("p-3 bg-div-shape-L2")> {j`주문자`->React.string} </div>
            <div className=%twc("p-3")>
              {order.ordererName->Option.getWithDefault("-")->React.string}
            </div>
            <div className=%twc("p-3 bg-div-shape-L2 border-t sm:border-t-0")>
              {j`주문자 연락처`->React.string}
            </div>
            <div className=%twc("p-3 border-t sm:border-t-0")>
              {order.ordererPhone->Option.getWithDefault("-")->React.string}
            </div>
          </div>
        </section>
        <h3 className=%twc("mt-10 font-bold")> {j`상품정보`->React.string} </h3>
        <section className=%twc("divide-y text-sm text-text-L2 mt-2 border-t border-b")>
          <div className=%twc("grid grid-cols-2-detail")>
            <div className=%twc("p-3 bg-div-shape-L2")> {j`상품명(번호)`->React.string} </div>
            <div className=%twc("p-3")>
              {order.productName->React.string}
              {` (${order.productId->Int.toString})`->React.string}
            </div>
          </div>
          <div className=%twc("grid grid-cols-2-detail")>
            <div className=%twc("p-3 bg-div-shape-L2")> {j`옵션명(번호)`->React.string} </div>
            <div className=%twc("p-3")>
              {order.productOptionName->Option.getWithDefault("-")->React.string}
              {` (${order.productSku})`->React.string}
            </div>
          </div>
          <div className=%twc("grid grid-cols-2-detail sm:grid-cols-4-detail")>
            <div className=%twc("p-3 bg-div-shape-L2")> {j`수량`->React.string} </div>
            <div className=%twc("p-3")> {order.quantity->Int.toString->React.string} </div>
            <div className=%twc("p-3 bg-div-shape-L2 border-t sm:border-t-0")>
              {j`금액`->React.string}
            </div>
            <div className=%twc("p-3 border-t sm:border-t-0")>
              {`${order.productPrice->Locale.Float.show(~digits=0)}원`->React.string}
            </div>
          </div>
        </section>
        <h3 className=%twc("mt-10 font-bold")> {j`배송정보`->React.string} </h3>
        <section className=%twc("divide-y text-sm text-text-L2 mt-2 border-t border-b")>
          <div className=%twc("grid grid-cols-2-detail sm:grid-cols-4-detail")>
            <div className=%twc("p-3 bg-div-shape-L2")> {j`택배사`->React.string} </div>
            <div className=%twc("p-3")>
              <span className=%twc("block")> {courierName->React.string} </span>
            </div>
            <div className=%twc("p-3 bg-div-shape-L2 border-t sm:border-t-0")>
              {j`송장번호`->React.string}
            </div>
            <div className=%twc("p-3 border-t sm:border-t-0")>
              {order.invoice->Option.getWithDefault(`-`)->React.string}
            </div>
          </div>
          <div className=%twc("grid grid-cols-2-detail sm:grid-cols-4-detail")>
            <div className=%twc("p-3 bg-div-shape-L2")> {j`수취인`->React.string} </div>
            <div className=%twc("p-3")>
              {order.receiverName->Option.getWithDefault(`-`)->React.string}
            </div>
            <div className=%twc("p-3 bg-div-shape-L2 border-t sm:border-t-0")>
              {j`수취인 연락처`->React.string}
            </div>
            <div className=%twc("p-3 border-t sm:border-t-0")>
              {order.receiverPhone
              ->Option.getWithDefault(`-`)
              ->Helper.PhoneNumber.parse
              ->Option.flatMap(Helper.PhoneNumber.format)
              ->Option.getWithDefault(order.receiverPhone->Option.getWithDefault(`-`))
              ->React.string}
            </div>
          </div>
          <div className=%twc("grid grid-cols-2-detail")>
            <div className=%twc("p-3 bg-div-shape-L2")>
              {j`주소·우편번호`->React.string}
            </div>
            <div className=%twc("p-3")>
              {order.receiverAddress->Option.getWithDefault(`-`)->React.string}
              {` (${order.receiverZipcode->Option.getWithDefault(`-`)})`->React.string}
            </div>
          </div>
          <div className=%twc("grid grid-cols-2-detail")>
            <div className=%twc("p-3 bg-div-shape-L2")> {j`배송메모`->React.string} </div>
            <div className=%twc("p-3")>
              {order.deliveryMessage->Option.getWithDefault("")->React.string}
            </div>
          </div>
        </section>
      </div>
    </Dialog.Content>
  </Dialog.Root>
}
