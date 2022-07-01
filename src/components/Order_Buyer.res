let formatDateTime = d => d->Js.Date.fromString->Locale.DateTime.formatFromUTC("yyyy/MM/dd HH:mm")
let formatDate = d => d->Js.Date.fromString->Locale.DateTime.formatFromUTC("yyyy/MM/dd")
let formatTime = d => d->Js.Date.fromString->Locale.DateTime.formatFromUTC("HH:mm")

let payTypeToText = payType => {
  open CustomHooks.Orders
  switch payType {
  | PAID => `신선캐시`
  | AFTER_PAY => `나중결제`
  }
}

module Item = {
  module Table = {
    @react.component
    let make = (~order: CustomHooks.Orders.order, ~check, ~onCheckOrder, ~onClickCancel) => {
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
        ->Option.getWithDefault(`입력전`)
      | _ => `입력전`
      }

      let isDisabedCheckbox = switch order.status {
      | CREATE => false
      | _ => true
      }

      <>
        <li className=%twc("hidden lg:grid lg:grid-cols-9-buyer-order text-gray-700")>
          <div className=%twc("h-full flex flex-col px-4 py-2")>
            <Checkbox
              id={`checkbox-${order.orderProductNo}`}
              checked={check(order.orderProductNo)}
              onChange={onCheckOrder(order.orderProductNo)}
              disabled=isDisabedCheckbox
            />
          </div>
          <div className=%twc("h-full flex flex-col px-4 py-2")>
            <Order_Detail_Button_Buyer_Seller order />
            <span className=%twc("block text-gray-400 mb-1")>
              {order.orderDate->formatDateTime->React.string}
            </span>
            <span className=%twc("block")> <Badge status=order.status /> </span>
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
            | CREATE =>
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
            | PACKING => `미등록`->React.string
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
                <Tracking_Buyer order />
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
              <span className=%twc("block")> {order.receiverPhone->Option.getWithDefault(`-`)->React.string} </span>
              <span className=%twc("block text-gray-500")>
                {order.receiverAddress->Option.getWithDefault(`-`)->React.string}
              </span>
              <span className=%twc("block text-gray-500")>
                {order.receiverZipcode->Option.getWithDefault(`-`)->React.string}
              </span>
            </div>
          }}
          <div className=%twc("h-full flex flex-col px-4 py-2")>
            <span className=%twc("block")>
              {order.ordererName->Option.getWithDefault("")->React.string}
            </span>
            <span className=%twc("block")>
              {order.ordererPhone->Option.getWithDefault("")->React.string}
            </span>
          </div>
          <div className=%twc("h-full flex flex-col px-4 py-2")>
            <span className=%twc("block")>
              {order.deliveryDate
              ->Option.map(formatDateTime)
              ->Option.getWithDefault(`-`)
              ->React.string}
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
  }

  module Card = {
    @react.component
    let make = (~order: CustomHooks.Orders.order, ~onClickCancel) => {
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
        ->Option.getWithDefault(`택배사 선택`)
      | _ => `택배사 선택`
      }

      <>
        <li className=%twc("py-7 px-5 lg:mb-4 lg:hidden text-black-gl")>
          <section className=%twc("flex justify-between items-start")>
            <div>
              <div className=%twc("flex")>
                <span className=%twc("w-20 text-gray-gl")> {j`주문번호`->React.string} </span>
                <span className=%twc("ml-2")> <Order_Detail_Button_Buyer_Seller order /> </span>
              </div>
              <div className=%twc("flex mt-2")>
                <span className=%twc("w-20 text-gray-gl")> {j`일자`->React.string} </span>
                <span className=%twc("ml-2")>
                  {order.orderDate->formatDateTime->React.string}
                </span>
              </div>
            </div>
            <Badge status=order.status />
          </section>
          <div className=%twc("divide-y divide-gray-100")>
            <section className=%twc("py-3")>
              <div className=%twc("flex")>
                <span className=%twc("w-20 text-gray-gl")> {j`주문상품`->React.string} </span>
                <div className=%twc("ml-2 ")>
                  <span className=%twc("block")>
                    {`${order.productId->Int.toString} ・ ${order.productSku}`->React.string}
                  </span>
                  <span className=%twc("block mt-1")> {order.productName->React.string} </span>
                  <span className=%twc("block mt-1")>
                    {order.productOptionName->Option.getWithDefault("")->React.string}
                  </span>
                </div>
              </div>
              <div className=%twc("flex mt-4 ")>
                <span className=%twc("w-20 text-gray-gl")> {j`상품금액`->React.string} </span>
                <span className=%twc("ml-2 ")>
                  {`${order.productPrice->Locale.Float.show(~digits=0)}원`->React.string}
                </span>
              </div>
              <div className=%twc("flex mt-4 ")>
                <span className=%twc("w-20 text-gray-gl")> {j`결제수단`->React.string} </span>
                <span className=%twc("ml-2 ")> {order.payType->payTypeToText->React.string} </span>
              </div>
              <div className=%twc("flex mt-4")>
                <span className=%twc("w-20 text-gray-gl")> {j`수량`->React.string} </span>
                <span className=%twc("ml-2")> {order.quantity->Int.toString->React.string} </span>
              </div>
            </section>
            <section className=%twc("py-3")>
              <div className=%twc("flex justify-between")>
                {switch order.status {
                | CREATE =>
                  <div className=%twc("flex-1 flex justify-between")>
                    <span className=%twc("w-20 text-gray-gl")>
                      {j`운송장번호`->React.string}
                    </span>
                    <div className=%twc("flex-1")>
                      <button
                        type_="button"
                        className=%twc(
                          "w-full py-3 px-3 bg-gray-gl text-gray-gl rounded-lg whitespace-nowrap text-base font-bold"
                        )
                        onClick={_ => setShowCancelConfirm(._ => Dialog.Show)}>
                        {j`주문취소`->React.string}
                      </button>
                    </div>
                  </div>
                | PACKING => `미등록`->React.string
                | DEPARTURE
                | DELIVERING
                | COMPLETE
                | CANCEL
                | ERROR
                | REFUND
                | NEGOTIATING => <>
                    <div className=%twc("flex")>
                      <span className=%twc("w-20 text-gray-gl")>
                        {j`운송장번호`->React.string}
                      </span>
                      <div className=%twc("ml-2")>
                        <span>
                          <span className=%twc("block")> {courierName->React.string} </span>
                          <span className=%twc("block")>
                            {order.invoice->Option.getWithDefault("-")->React.string}
                          </span>
                        </span>
                      </div>
                    </div>
                    <Tracking_Buyer order />
                  </>
                }}
              </div>
              <div className=%twc("flex mt-4")>
                <span className=%twc("w-20 text-gray-gl")> {j`배송정보`->React.string} </span>
                <div className=%twc("flex-1 pl-2")>
                  {switch order.deliveryType {
                  | Some(SELF) =>
                    <span className=%twc("block")> {j`직접수령`->React.string} </span>
                  | _ => <>
                      <span className=%twc("block")>
                        {j`${order.receiverName->Option.getWithDefault(`-`)} ${order.receiverPhone->Option.getWithDefault(`-`)}`->React.string}
                      </span>
                      <span className=%twc("block mt-1")>
                        {order.receiverAddress->Option.getWithDefault(`-`)->React.string}
                      </span>
                      <span className=%twc("block mt-1")>
                        {order.receiverZipcode->Option.getWithDefault(`-`)->React.string}
                      </span>
                    </>
                  }}
                </div>
              </div>
              <div className=%twc("flex mt-4")>
                <span className=%twc("w-20 text-gray-gl")> {j`주문자명`->React.string} </span>
                <div className=%twc("ml-2 ")>
                  <span className=%twc("block")>
                    {order.ordererName->Option.getWithDefault(`-`)->React.string}
                  </span>
                </div>
              </div>
              <div className=%twc("flex mt-2")>
                <span className=%twc("w-20 text-gray-gl")> {j`연락처`->React.string} </span>
                <div className=%twc("ml-2")>
                  <span className=%twc("block")>
                    {order.ordererPhone->Option.getWithDefault(`-`)->React.string}
                  </span>
                </div>
              </div>
            </section>
            <section className=%twc("py-3")>
              <div className=%twc("flex")>
                <span className=%twc("w-20 text-gray-gl")> {j`출고일`->React.string} </span>
                <span className=%twc("ml-2")>
                  {order.deliveryDate
                  ->Option.map(formatDateTime)
                  ->Option.getWithDefault(`-`)
                  ->React.string}
                </span>
              </div>
            </section>
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
  }
}

@react.component
let make = (~order: CustomHooks.Orders.order, ~check, ~onCheckOrder, ~onClickCancel) => {
  <>
    // PC 뷰
    <Item.Table order check onCheckOrder onClickCancel />
    // 모바일뷰
    <Item.Card order onClickCancel />
  </>
}
