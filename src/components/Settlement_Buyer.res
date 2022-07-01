let formatDateTime = d => d->Js.Date.fromString->Locale.DateTime.formatFromUTC("yyyy/MM/dd HH:mm")
let formatDate = d => d->Js.Date.fromString->Locale.DateTime.formatFromUTC("yyyy/MM/dd")
let formatTime = d => d->Js.Date.fromString->Locale.DateTime.formatFromUTC("HH:mm")

module Item = {
  module Table = {
    @react.component
    let make = (~settlement: CustomHooks.Orders.order) => {
      <li className=%twc("hidden lg:grid lg:grid-cols-9-gl-buyer text-gray-700")>
        <div className=%twc("h-full flex flex-col px-4 py-2")>
          <span className=%twc("block text-gray-400 mb-1")>
            {settlement.orderDate->formatDateTime->React.string}
          </span>
          <span className=%twc("block")> <Badge status=settlement.status /> </span>
        </div>
        <div className=%twc("h-full flex flex-col px-4 py-2")>
          <span className=%twc("block text-gray-400")>
            {settlement.productId->Int.toString->React.string}
          </span>
          <span className=%twc("block")> {settlement.productName->React.string} </span>
          <span className=%twc("block")>
            {settlement.productOptionName->Option.getWithDefault("")->React.string}
          </span>
        </div>
        <div className=%twc("h-full flex flex-col px-4 py-2")>
          <span className=%twc("whitespace-nowrap")>
            {`${settlement.productPrice->Locale.Float.show(~digits=0)}원`->React.string}
          </span>
        </div>
        <div className=%twc("h-full flex flex-col px-4 py-2")>
          <span className=%twc("block")> {settlement.quantity->Int.toString->React.string} </span>
        </div>
        <div className=%twc("h-full flex flex-col px-4 py-2")> {j`!!!`->React.string} </div>
        <div className=%twc("h-full flex flex-col px-4 py-2")>
          <span className=%twc("block")>
            {settlement.receiverName->Option.getWithDefault(`-`)->React.string}
          </span>
          <span className=%twc("block")>
            {settlement.receiverPhone->Option.getWithDefault(`-`)->React.string}
          </span>
          <span className=%twc("block text-gray-500")>
            {settlement.receiverAddress->Option.getWithDefault(`-`)->React.string}
          </span>
          <span className=%twc("block text-gray-500")>
            {settlement.receiverZipcode->Option.getWithDefault(`-`)->React.string}
          </span>
        </div>
        <div className=%twc("h-full flex flex-col px-4 py-2")>
          <span className=%twc("block")>
            {settlement.ordererName->Option.getWithDefault("")->React.string}
          </span>
          <span className=%twc("block")>
            {settlement.ordererPhone->Option.getWithDefault("")->React.string}
          </span>
        </div>
        <div className=%twc("h-full flex flex-col px-4 py-2")>
          <span className=%twc("block")>
            {settlement.deliveryDate
            ->Option.map(formatDateTime)
            ->Option.getWithDefault(`-`)
            ->React.string}
          </span>
        </div>
      </li>
    }
  }

  module Card = {
    @react.component
    let make = (~settlement: CustomHooks.Orders.order) => {
      <li className=%twc("py-7 px-5 lg:mb-4 lg:hidden text-black-gl")>
        <section className=%twc("flex justify-between items-start")>
          <div>
            <div className=%twc("flex")>
              <span className=%twc("w-20 text-gray-gl")> {j`주문번호`->React.string} </span>
            </div>
            <div className=%twc("flex mt-2")>
              <span className=%twc("w-20 text-gray-gl")> {j`일자`->React.string} </span>
              <span className=%twc("ml-2")>
                {settlement.orderDate->formatDateTime->React.string}
              </span>
            </div>
          </div>
          <Badge status=settlement.status />
        </section>
        <div className=%twc("divide-y divide-gray-100")>
          <section className=%twc("py-3")>
            <div className=%twc("flex")>
              <span className=%twc("w-20 text-gray-gl")> {j`주문상품`->React.string} </span>
              <div className=%twc("ml-2 ")>
                <span className=%twc("block")>
                  {settlement.productId->Int.toString->React.string}
                </span>
                <span className=%twc("block mt-1")> {settlement.productName->React.string} </span>
                <span className=%twc("block mt-1")>
                  {settlement.productOptionName->Option.getWithDefault("")->React.string}
                </span>
              </div>
            </div>
            <div className=%twc("flex mt-4 ")>
              <span className=%twc("w-20 text-gray-gl")> {j`상품금액`->React.string} </span>
              <span className=%twc("ml-2 ")>
                {`${settlement.productPrice->Locale.Float.show(~digits=0)}원`->React.string}
              </span>
            </div>
            <div className=%twc("flex mt-4")>
              <span className=%twc("w-20 text-gray-gl")> {j`수량`->React.string} </span>
              <span className=%twc("ml-2")>
                {settlement.quantity->Int.toString->React.string}
              </span>
            </div>
          </section>
          <section className=%twc("py-3")>
            <div className=%twc("flex justify-between")> {j`!!!`->React.string} </div>
            <div className=%twc("flex mt-4")>
              <span className=%twc("w-20 text-gray-gl")> {j`배송정보`->React.string} </span>
              <div className=%twc("flex-1 pl-2")>
                <span className=%twc("block")>
                  {j`${settlement.receiverName->Option.getWithDefault(`-`)} ${settlement.receiverPhone->Option.getWithDefault(`-`)}`->React.string}
                </span>
                <span className=%twc("block mt-1")>
                  {settlement.receiverAddress->Option.getWithDefault(`-`)->React.string}
                </span>
                <span className=%twc("block mt-1")>
                  {settlement.receiverZipcode->Option.getWithDefault(`-`)->React.string}
                </span>
              </div>
            </div>
            <div className=%twc("flex mt-4")>
              <span className=%twc("w-20 text-gray-gl")> {j`주문자명`->React.string} </span>
              <div className=%twc("ml-2 ")>
                <span className=%twc("block")>
                  {settlement.ordererName->Option.getWithDefault(`-`)->React.string}
                </span>
              </div>
            </div>
            <div className=%twc("flex mt-2")>
              <span className=%twc("w-20 text-gray-gl")> {j`연락처`->React.string} </span>
              <div className=%twc("ml-2")>
                <span className=%twc("block")>
                  {settlement.ordererPhone->Option.getWithDefault(`-`)->React.string}
                </span>
              </div>
            </div>
          </section>
          <section className=%twc("py-3")>
            <div className=%twc("flex")>
              <span className=%twc("w-20 text-gray-gl")> {j`출고일`->React.string} </span>
              <span className=%twc("ml-2")>
                {settlement.deliveryDate
                ->Option.map(formatDateTime)
                ->Option.getWithDefault(`-`)
                ->React.string}
              </span>
            </div>
          </section>
        </div>
      </li>
    }
  }
}

@react.component
let make = (~settlement: CustomHooks.Orders.order) => {
  <>
    // PC 뷰
    <Item.Table settlement />
    // 모바일뷰
    <Item.Card settlement />
  </>
}
