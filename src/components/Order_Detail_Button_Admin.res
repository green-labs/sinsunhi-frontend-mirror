let formatDate = d => d->Js.Date.fromString->Locale.DateTime.formatFromUTC("yyyy/MM/dd HH:mm")

module Converter = Converter.Status(CustomHooks.OrdersAdmin)

@react.component
let make = (~order: CustomHooks.OrdersAdmin.order) => {
  let router = Next.Router.useRouter()
  let {mutate} = Swr.useSwrConfig()
  let {addToast} = ReactToastNotifications.useToasts()

  let status = CustomHooks.Courier.use()

  let close = _ => {
    open Webapi
    let buttonClose = Dom.document->Dom.Document.getElementById("btn-close")
    buttonClose
    ->Option.flatMap(buttonClose' => {
      buttonClose'->Dom.Element.asHtmlElement
    })
    ->Option.forEach(buttonClose' => {
      buttonClose'->Dom.HtmlElement.click
    })
    ->ignore
  }

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

  let (adminMemo, setAdminMemo) = React.Uncurried.useState(_ =>
    order.adminMemo->Option.getWithDefault("")
  )

  let handleOnConfirm = (
    _ => {
      {
        "memo": adminMemo,
      }
      ->Js.Json.stringifyAny
      ->Option.map(body => {
        FetchHelper.requestWithRetry(
          ~fetcher=FetchHelper.patchWithToken,
          ~url=`${Env.restApiUrl}/order/${order.orderProductNo}/memo`,
          ~body,
          ~count=3,
          ~onSuccess={
            _ => {
              addToast(.
                <div className=%twc("flex items-center")>
                  <IconCheck height="24" width="24" fill="#12B564" className=%twc("mr-2") />
                  {j`저장되었습니다.`->React.string}
                </div>,
                {appearance: "success"},
              )
              mutate(.
                ~url=`${Env.restApiUrl}/order?${router.query
                  ->Webapi.Url.URLSearchParams.makeWithDict
                  ->Webapi.Url.URLSearchParams.toString}`,
                ~data=None,
                ~revalidation=Some(true),
              )
            }
          },
          ~onFailure={
            _ =>
              addToast(.
                <div className=%twc("flex items-center")>
                  <IconError height="24" width="24" className=%twc("mr-2") />
                  {j`오류가 발생하였습니다.`->React.string}
                </div>,
                {appearance: "error"},
              )
          },
        )
      })
      ->ignore
    }
  )->ReactEvents.interceptingHandler

  <RadixUI.Dialog.Root
    onOpenChange={_ => setAdminMemo(._ => order.adminMemo->Option.getWithDefault(""))}>
    <RadixUI.Dialog.Overlay className=%twc("dialog-overlay") />
    <RadixUI.Dialog.Trigger className=%twc("block text-left mb-1 underline focus:outline-none")>
      {order.orderProductNo->React.string}
    </RadixUI.Dialog.Trigger>
    <RadixUI.Dialog.Content className=%twc("dialog-content-detail overflow-y-auto")>
      <div className=%twc("p-5")>
        <div className=%twc("flex")>
          <h2 className=%twc("text-xl font-bold")> {j`주문상세조회`->React.string} </h2>
          <RadixUI.Dialog.Close id="btn-close" className=%twc("focus:outline-none ml-auto")>
            <IconClose height="24" width="24" fill="#262626" />
          </RadixUI.Dialog.Close>
        </div>
        <h3 className=%twc("mt-10 font-bold")> {j`주문정보`->React.string} </h3>
        <section className=%twc("divide-y text-sm text-text-L2 mt-2 border-t border-b")>
          <div className=%twc("grid grid-cols-4-detail")>
            <div className=%twc("p-3 bg-div-shape-L2")> {j`주문번호`->React.string} </div>
            <div className=%twc("p-3")> {order.orderProductNo->React.string} </div>
            <div className=%twc("p-3 bg-div-shape-L2")> {j`상품번호`->React.string} </div>
            <div className=%twc("p-3")> {order.productId->Int.toString->React.string} </div>
          </div>
          <div className=%twc("grid grid-cols-4-detail")>
            <div className=%twc("p-3 bg-div-shape-L2")> {j`주문일시`->React.string} </div>
            <div className=%twc("p-3")> {order.orderDate->formatDate->React.string} </div>
            <div className=%twc("p-3 bg-div-shape-L2")> {j`결제금액`->React.string} </div>
            <div className=%twc("p-3")>
              {`${(order.productPrice *. order.quantity->Int.toFloat)
                  ->Locale.Float.show(~digits=0)}원`->React.string}
            </div>
          </div>
          <div className=%twc("grid grid-cols-4-detail")>
            <div className=%twc("p-3 bg-div-shape-L2")> {j`바이어`->React.string} </div>
            <div className=%twc("p-3")> {order.buyerName->React.string} </div>
            <div className=%twc("p-3 bg-div-shape-L2")> {j`주문상태`->React.string} </div>
            <div className=%twc("p-3")> {order.status->Converter.displayStatus->React.string} </div>
          </div>
          <div className=%twc("grid grid-cols-4-detail")>
            <div className=%twc("p-3 bg-div-shape-L2")> {j`주문자`->React.string} </div>
            <div className=%twc("p-3")>
              {order.ordererName->Option.getWithDefault("-")->React.string}
            </div>
            <div className=%twc("p-3 bg-div-shape-L2")>
              {j`주문자 연락처`->React.string}
            </div>
            <div className=%twc("p-3")>
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
          <div className=%twc("grid grid-cols-2-detail")>
            <div className=%twc("p-3 bg-div-shape-L2")> {j`생산자명`->React.string} </div>
            <div className=%twc("p-3")> {order.farmerName->React.string} </div>
          </div>
          <div className=%twc("grid grid-cols-4-detail")>
            <div className=%twc("p-3 bg-div-shape-L2")> {j`수량`->React.string} </div>
            <div className=%twc("p-3")> {order.quantity->Int.toString->React.string} </div>
            <div className=%twc("p-3 bg-div-shape-L2")> {j`금액`->React.string} </div>
            <div className=%twc("p-3")>
              {`${order.productPrice->Locale.Float.show(~digits=0)}원`->React.string}
            </div>
          </div>
        </section>
        <h3 className=%twc("mt-10 font-bold")> {j`배송정보`->React.string} </h3>
        <section className=%twc("divide-y text-sm text-text-L2 mt-2 border-t border-b")>
          {switch order.deliveryType {
          | Some(FREIGHT) => <>
              <div className=%twc("grid grid-cols-2-detail")>
                <div className=%twc("p-3 bg-div-shape-L2")>
                  {j`배송 희망일`->React.string}
                </div>
                <div className=%twc("p-3")>
                  {
                    let timezone = Js.Date.now()->Js.Date.fromFloat->Js.Date.getTimezoneOffset
                    order.desiredDeliveryDate
                    ->Option.map(date =>
                      date
                      ->Js.Date.fromString
                      ->DateFns.subMinutesf(timezone)
                      ->DateFns.format("yyyy-MM-dd")
                    )
                    ->Option.getWithDefault(`-`)
                    ->React.string
                  }
                </div>
              </div>
              <div className=%twc("grid grid-cols-4-detail")>
                <div className=%twc("p-3 bg-div-shape-L2")> {j`수취인`->React.string} </div>
                <div className=%twc("p-3")>
                  {order.receiverName->Option.getWithDefault(`-`)->React.string}
                </div>
                <div className=%twc("p-3 bg-div-shape-L2")>
                  {j`수취인 연락처`->React.string}
                </div>
                <div className=%twc("p-3")>
                  {order.receiverPhone->Option.getWithDefault(`-`)->React.string}
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
                  {order.deliveryMessage->Option.getWithDefault(`-`)->React.string}
                </div>
              </div>
            </>
          | Some(SELF) => <>
              <div className=%twc("grid grid-cols-2-detail")>
                <div className=%twc("p-3 bg-div-shape-L2")>
                  {j`수령 희망일`->React.string}
                </div>
                <div className=%twc("p-3")>
                  {
                    let timezone = Js.Date.now()->Js.Date.fromFloat->Js.Date.getTimezoneOffset
                    order.desiredDeliveryDate
                    ->Option.map(date =>
                      date
                      ->Js.Date.fromString
                      ->DateFns.subMinutesf(timezone)
                      ->DateFns.format("yyyy-MM-dd")
                    )
                    ->Option.getWithDefault(`-`)
                    ->React.string
                  }
                </div>
              </div>
              <div className=%twc("grid grid-cols-2-detail")>
                <div className=%twc("p-3 bg-div-shape-L2")> {j`요청사항`->React.string} </div>
                <div className=%twc("p-3")>
                  {order.deliveryMessage->Option.getWithDefault(`-`)->React.string}
                </div>
              </div>
            </>
          | _ => <>
              <div className=%twc("grid grid-cols-4-detail")>
                <div className=%twc("p-3 bg-div-shape-L2")> {j`택배사`->React.string} </div>
                <div className=%twc("p-3")>
                  <span className=%twc("block")> {courierName->React.string} </span>
                </div>
                <div className=%twc("p-3 bg-div-shape-L2")> {j`송장번호`->React.string} </div>
                <div className=%twc("p-3")>
                  {order.invoice->Option.getWithDefault(`-`)->React.string}
                </div>
              </div>
              <div className=%twc("grid grid-cols-4-detail")>
                <div className=%twc("p-3 bg-div-shape-L2")> {j`수취인`->React.string} </div>
                <div className=%twc("p-3")>
                  {order.receiverName->Option.getWithDefault(`-`)->React.string}
                </div>
                <div className=%twc("p-3 bg-div-shape-L2")>
                  {j`수취인 연락처`->React.string}
                </div>
                <div className=%twc("p-3")>
                  {order.receiverPhone->Option.getWithDefault(`-`)->React.string}
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
            </>
          }}
        </section>
        <h3 className=%twc("mt-10 font-bold")> {j`담당MD 메모`->React.string} </h3>
        <textarea
          value=adminMemo
          onChange={e => {
            let v = (e->ReactEvent.Synthetic.target)["value"]
            setAdminMemo(._ => v)
          }}
          className=%twc(
            "px-3 py-2 mt-2 border border-border-default-L1 rounded-lg w-full h-24 focus:outline-none"
          )
          maxLength=1000
          placeholder=`공지사항 또는 메모 입력(최대 1000자)`
        />
        <span className=%twc("w-1/2")>
          <Dialog.ButtonBox
            textOnCancel=`닫기`
            onCancel={_ => close()}
            textOnConfirm=`저장`
            onConfirm={handleOnConfirm}
          />
        </span>
      </div>
    </RadixUI.Dialog.Content>
  </RadixUI.Dialog.Root>
}
