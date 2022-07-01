let formatDate = d => d->Js.Date.fromString->Locale.DateTime.formatFromUTC("yyyy/MM/dd")
let formatTime = d => d->Js.Date.fromString->Locale.DateTime.formatFromUTC("HH:mm")

module Item = {
  module Table = {
    @react.component
    let make = (
      ~order: CustomHooks.Orders.order,
      ~courierCode: option<string>,
      ~setCourier,
      ~invoice,
      ~onChangeInvoice,
      ~onSubmitInvoice,
      ~check,
      ~onCheckOrder,
      ~onClickPacking,
    ) => {
      let (isShowPackingConfirm, setShowPackingConfirm) = React.Uncurried.useState(_ => Dialog.Hide)

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

      let isDisabedCheckbox = switch order.status {
      | CREATE => false
      | _ => true
      }

      let isDisabledSubmitButton = switch (courierCode, invoice) {
      | (Some(_), Some(invoice')) if invoice' !== "" => false
      | _ => true
      }

      <>
        <li className=%twc("hidden lg:grid lg:grid-cols-11-gl-seller text-gray-700")>
          <div className=%twc("h-full flex flex-col px-4 py-2")>
            <Checkbox
              id={`checkbox-${order.orderProductNo}`}
              checked={check(order.orderProductNo)}
              onChange={onCheckOrder(order.orderProductNo)}
              disabled=isDisabedCheckbox
            />
          </div>
          <div className=%twc("h-full flex flex-col px-4 py-2")>
            <span className=%twc("block font-bold")>
              {order.orderDate->formatDate->React.string}
            </span>
            <span className=%twc("block font-bold text-gray-400")>
              {order.orderDate->formatTime->React.string}
            </span>
          </div>
          <div className=%twc("h-full py-2 pl-4 align-top")>
            <span className=%twc("block mb-2")>
              {`${order.productId->Int.toString} · ${order.productSku}`->React.string}
            </span>
            <span className=%twc("block")> <Badge status=order.status /> </span>
          </div>
          <div className=%twc("h-full flex flex-col px-4 py-2")>
            <Order_Detail_Button_Buyer_Seller order />
          </div>
          <div className=%twc("h-full flex flex-col px-4 py-2")>
            {switch order.status {
            | CREATE =>
              <button
                className=%twc(
                  "max-w-min p-2 bg-green-gl text-white rounded-md whitespace-nowrap focus:outline-none focus:ring-2 focus:ring-green-gl focus:ring-offset-1 focus:ring-opacity-100"
                )
                onClick={_ => setShowPackingConfirm(._ => Dialog.Show)}>
                {j`상품준비중 처리`->React.string}
              </button>
            | PACKING
            | DEPARTURE
            | DELIVERING
            | ERROR => <>
                <Select_Courier courierCode setCourier />
                <div className=%twc("flex mt-1")>
                  <label className=%twc("block flex-auto")>
                    <Input
                      type_="text"
                      name="invoice-number"
                      size=Input.Small
                      placeholder=`송장번호입력`
                      value={invoice->Option.getWithDefault("")}
                      onChange=onChangeInvoice
                      error=None
                    />
                  </label>
                  {switch order.invoice {
                  | Some(_) =>
                    <button
                      className=%twc(
                        "py-1 px-2 rounded-md bg-gray-300 text-white ml-1 whitespace-nowrap"
                      )
                      type_="button"
                      onClick={onSubmitInvoice}>
                      {j`수정`->React.string}
                    </button>
                  | None =>
                    <button
                      className={if isDisabledSubmitButton {
                        %twc(
                          "py-1 px-2 rounded-md bg-gray-button-gl text-gray-gl ml-1 whitespace-nowrap"
                        )
                      } else {
                        %twc("py-1 px-2 rounded-md bg-green-gl text-white ml-1 whitespace-nowrap")
                      }}
                      type_="button"
                      onClick={onSubmitInvoice}
                      disabled=isDisabledSubmitButton>
                      {j`등록`->React.string}
                    </button>
                  }}
                </div>
              </>
            | COMPLETE
            | CANCEL
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
          <div className=%twc("h-full flex flex-col px-4 py-2")>
            <span className=%twc("block")> {order.productName->React.string} </span>
            <span className=%twc("block")>
              {order.productOptionName->Option.getWithDefault("")->React.string}
            </span>
            <span className=%twc("block text-gray-500")>
              {order.quantity->Int.toString->React.string}
            </span>
          </div>
          <div className=%twc("h-full flex flex-col px-4 py-2")>
            {switch order.deliveryType {
            | Some(SELF) => <span className=%twc("block")> {`-`->React.string} </span>
            | _ => <>
                <span className=%twc("block")> {order.receiverName->Option.getWithDefault(`-`)->React.string} </span>
                <span className=%twc("block text-gray-500")>
                  {order.receiverPhone
                  ->Option.getWithDefault(`-`)
                  ->Helper.PhoneNumber.parse
                  ->Option.flatMap(Helper.PhoneNumber.format)
                  ->Option.getWithDefault(order.receiverPhone->Option.getWithDefault(`-`))
                  ->React.string}
                </span>
              </>
            }}
          </div>
          <div className=%twc("h-full flex flex-col px-4 py-2 whitespace-nowrap")>
            {`${order.productPrice->Locale.Float.show(~digits=0)}원`->React.string}
          </div>
          <div className=%twc("h-full flex flex-col px-4 py-2")>
            {switch order.deliveryType {
            | Some(SELF) => <span className=%twc("block")> {`-`->React.string} </span>
            | _ => <>
                <span className=%twc("block")> {order.receiverZipcode->Option.getWithDefault(`-`)->React.string} </span>
              </>
            }}
          </div>
          <div className=%twc("h-full flex flex-col px-4 py-2 whitespace-nowrap")>
            <span className=%twc("block")>
              {order.ordererName->Option.getWithDefault("")->React.string}
            </span>
            <span className=%twc("block")>
              {order.ordererPhone->Option.getWithDefault("")->React.string}
            </span>
          </div>
          <div className=%twc("h-full flex flex-col px-4 py-2")>
            <span className=%twc("block line-clamp-2")>
              {order.deliveryMessage->Option.getWithDefault("-")->React.string}
            </span>
          </div>
        </li>
        // 다이얼로그
        <Dialog
          isShow=isShowPackingConfirm
          textOnCancel=`취소`
          onCancel={_ => setShowPackingConfirm(._ => Dialog.Hide)}
          textOnConfirm=`확인`
          onConfirm={_ => {
            setShowPackingConfirm(._ => Dialog.Hide)
            onClickPacking([order.orderProductNo])
          }}>
          <p className=%twc("text-black-gl text-center whitespace-pre-wrap")>
            {j`선택한 주문을 상품준비중으로 변경하시겠습니까?`->React.string}
          </p>
        </Dialog>
      </>
    }
  }

  module Card = {
    @react.component
    let make = (
      ~order: CustomHooks.Orders.order,
      ~courierCode: option<string>,
      ~setCourier,
      ~invoice,
      ~onChangeInvoice,
      ~onSubmitInvoice,
      ~onClickPacking,
    ) => {
      let (isShowPackingConfirm, setShowPackingConfirm) = React.Uncurried.useState(_ => Dialog.Hide)

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

      let isDisabledSubmitButton = switch (courierCode, invoice) {
      | (Some(_), Some(invoice')) if invoice' !== "" => false
      | _ => true
      }

      <>
        <li className=%twc("py-7 px-5 lg:hidden text-black-gl")>
          <section className=%twc("flex justify-between items-start text-base")>
            <div>
              <span className=%twc("font-bold mr-1")>
                {order.orderDate->formatDate->React.string}
              </span>
              {order.orderDate->formatTime->React.string}
            </div>
            <Badge status=order.status />
          </section>
          <section className=%twc("divide-y divide-gray-100")>
            <div className=%twc("py-3")>
              <div className=%twc("flex")>
                <span className=%twc("w-20 text-gray-gl")> {j`상품번호`->React.string} </span>
                <span className=%twc("ml-2")> {order.productId->Int.toString->React.string} </span>
              </div>
              <div className=%twc("flex mt-2")>
                <span className=%twc("w-20 text-gray-gl")> {j`옵션번호`->React.string} </span>
                <span className=%twc("ml-2")> {order.productSku->React.string} </span>
              </div>
              <div className=%twc("flex mt-2")>
                <span className=%twc("w-20 text-gray-gl")> {j`주문번호`->React.string} </span>
                <span className=%twc("ml-2")> <Order_Detail_Button_Buyer_Seller order /> </span>
              </div>
            </div>
            <div className=%twc("py-3")>
              {switch order.status {
              | CREATE => <>
                  <div className=%twc("flex")>
                    <span className=%twc("w-20 text-gray-gl")>
                      {j`택배사명`->React.string}
                    </span>
                    <span className=%twc("ml-2")> {courierName->React.string} </span>
                  </div>
                  <div className=%twc("flex-1 flex mt-1")>
                    <span className=%twc("w-20 text-gray-gl")>
                      {j`송장번호`->React.string}
                    </span>
                    <button
                      type_="button"
                      className=%twc(
                        "flex-1 py-3 px-3 bg-green-gl text-white rounded-lg whitespace-nowrap text-base font-bold"
                      )
                      onClick={_ => setShowPackingConfirm(._ => Dialog.Show)}>
                      {j`상품준비중 처리`->React.string}
                    </button>
                  </div>
                </>
              | _ => <>
                  <div className=%twc("flex")>
                    <span className=%twc("w-20 text-gray-gl")>
                      {j`택배사명`->React.string}
                    </span>
                    <span className=%twc("flex-1")> <Select_Courier courierCode setCourier /> </span>
                  </div>
                  <div className=%twc("flex-1 flex mt-1")>
                    <span className=%twc("w-20 text-gray-gl")>
                      {j`송장번호`->React.string}
                    </span>
                    <div className=%twc("flex-1 flex")>
                      <label className=%twc("block flex-auto")>
                        <Input
                          type_="text"
                          name="invoice-number"
                          size=Input.Large
                          placeholder=`송장번호입력`
                          value={invoice->Option.getWithDefault("")}
                          onChange=onChangeInvoice
                          error=None
                        />
                      </label>
                      {switch order.invoice {
                      | Some(_) =>
                        <button
                          className=%twc(
                            "h-full px-4 rounded-xl bg-gray-300 text-white font-bold ml-1 whitespace-nowrap"
                          )
                          type_="button"
                          onClick={onSubmitInvoice}>
                          {j`수정`->React.string}
                        </button>
                      | None =>
                        <button
                          className={if isDisabledSubmitButton {
                            %twc(
                              "h-full px-4 rounded-xl bg-gray-gl text-gray-gl font-bold ml-1 whitespace-nowrap"
                            )
                          } else {
                            %twc(
                              "h-full px-4 rounded-xl bg-green-gl text-white font-bold ml-1 whitespace-nowrap"
                            )
                          }}
                          type_="button"
                          onClick={onSubmitInvoice}
                          disabled=isDisabledSubmitButton>
                          {j`등록`->React.string}
                        </button>
                      }}
                    </div>
                  </div>
                </>
              }}
            </div>
            <div className=%twc("py-3")>
              <div className=%twc("flex")>
                <span className=%twc("w-20 text-gray-gl")> {j`상품명`->React.string} </span>
                <span className=%twc("ml-2")> {order.productName->React.string} </span>
              </div>
              <div className=%twc("flex mt-2")>
                <span className=%twc("w-20 text-gray-gl")> {j`옵션`->React.string} </span>
                <span className=%twc("ml-2")>
                  {order.productOptionName->Option.getWithDefault(`-`)->React.string}
                </span>
              </div>
              <div className=%twc("flex mt-2")>
                <span className=%twc("w-20 text-gray-gl")> {j`수량`->React.string} </span>
                <span className=%twc("ml-2")> {order.quantity->Int.toString->React.string} </span>
              </div>
              <div className=%twc("flex mt-2")>
                <span className=%twc("w-20 text-gray-gl")> {j`가격정보`->React.string} </span>
                <span className=%twc("ml-2")>
                  {`${order.productPrice->Locale.Float.show(~digits=0)}원`->React.string}
                </span>
              </div>
            </div>
            <div className=%twc("py-3")>
              {switch order.deliveryType {
              | Some(SELF) => <>
                  <div className=%twc("flex")>
                    <span className=%twc("w-20 text-gray-gl")> {j`수취인`->React.string} </span>
                    <span className=%twc("ml-2")> {`-`->React.string} </span>
                  </div>
                  <div className=%twc("flex mt-2")>
                    <span className=%twc("w-20 text-gray-gl")> {j`연락처`->React.string} </span>
                    <span className=%twc("ml-2")> {`-`->React.string} </span>
                  </div>
                  <div className=%twc("flex mt-2")>
                    <span className=%twc("w-20 text-gray-gl")> {j`주소`->React.string} </span>
                    <span className=%twc("flex-1 ml-2")> {`-`->React.string} </span>
                  </div>
                  <div className=%twc("flex mt-2")>
                    <span className=%twc("w-20 text-gray-gl")>
                      {j`우편번호`->React.string}
                    </span>
                    <span className=%twc("ml-2")> {`-`->React.string} </span>
                  </div>
                </>
              | _ => <>
                  <div className=%twc("flex")>
                    <span className=%twc("w-20 text-gray-gl")> {j`수취인`->React.string} </span>
                    <span className=%twc("ml-2")> {order.receiverName->Option.getWithDefault(`-`)->React.string} </span>
                  </div>
                  <div className=%twc("flex mt-2")>
                    <span className=%twc("w-20 text-gray-gl")> {j`연락처`->React.string} </span>
                    <span className=%twc("ml-2")> {order.receiverPhone->Option.getWithDefault(`-`)->React.string} </span>
                  </div>
                  <div className=%twc("flex mt-2")>
                    <span className=%twc("w-20 text-gray-gl")> {j`주소`->React.string} </span>
                    <span className=%twc("flex-1 ml-2")> {order.receiverAddress->Option.getWithDefault(`-`)->React.string} </span>
                  </div>
                  <div className=%twc("flex mt-2")>
                    <span className=%twc("w-20 text-gray-gl")> {j`우편번호`->React.string} </span>
                    <span className=%twc("ml-2")> {order.receiverZipcode->Option.getWithDefault(`-`)->React.string} </span>
                  </div>
                </>
              }}
            </div>
            <div className=%twc("py-3")>
              <div className=%twc("flex")>
                <span className=%twc("w-20 text-gray-gl")> {j`배송메세지`->React.string} </span>
                <span className=%twc("ml-2")>
                  {order.deliveryMessage->Option.getWithDefault(``)->React.string}
                </span>
              </div>
              <div className=%twc("flex mt-2")>
                <span className=%twc("w-20 text-gray-gl")> {j`주문자명`->React.string} </span>
                <span className=%twc("ml-2")>
                  {order.ordererName->Option.getWithDefault(``)->React.string}
                </span>
              </div>
              <div className=%twc("flex mt-2")>
                <span className=%twc("w-20 text-gray-gl")> {j`연락처`->React.string} </span>
                <span className=%twc("flex-1 ml-2")>
                  {order.ordererPhone->Option.getWithDefault(``)->React.string}
                </span>
              </div>
            </div>
          </section>
        </li>
        // 다이얼로그
        <Dialog
          isShow=isShowPackingConfirm
          textOnCancel=`취소`
          onCancel={_ => setShowPackingConfirm(._ => Dialog.Hide)}
          textOnConfirm=`확인`
          onConfirm={_ => {
            setShowPackingConfirm(._ => Dialog.Hide)
            onClickPacking([order.orderProductNo])
          }}>
          <p className=%twc("text-black-gl text-center whitespace-pre-wrap")>
            {j`선택한 주문을 상품준비중으로 변경하시겠습니까?`->React.string}
          </p>
        </Dialog>
      </>
    }
  }
}

@react.component
let make = (~order: CustomHooks.Orders.order, ~check, ~onCheckOrder, ~onClickPacking) => {
  let router = Next.Router.useRouter()
  let {mutate} = Swr.useSwrConfig()
  let {addToast} = ReactToastNotifications.useToasts()
  let (invoice, handleOnChangeInvoice) = CustomHooks.useInvoice(order.invoice)

  let (courierCode, setCourier) = React.Uncurried.useState(_ => order.courierCode)

  let (
    isShowErrorPostCourierInvoiceNo,
    setShowErrorPostCourierInvoiceNo,
  ) = React.Uncurried.useState(_ => Dialog.Hide)

  let postCourierInvoiceNo = (
    _ => {
      Helper.Option.map2(courierCode, invoice, (courierCode', invoice') => {
        {
          "list": [
            {
              "order-product-number": order.orderProductNo,
              "invoice": invoice',
              "courier-code": courierCode',
            },
          ],
        }
        ->Js.Json.stringifyAny
        ->Option.map(body => {
          FetchHelper.requestWithRetry(
            ~fetcher=FetchHelper.postWithToken,
            ~url=`${Env.restApiUrl}/order/invoices`,
            ~body,
            ~count=3,
            ~onSuccess={
              _ => {
                addToast(.
                  <div className=%twc("flex items-center")>
                    <IconCheck height="24" width="24" fill="#12B564" className=%twc("mr-2") />
                    {j`송장번호가 입력되었습니다`->React.string}
                  </div>,
                  {appearance: "success"},
                )
                mutate(.
                  ~url=`${Env.restApiUrl}/order?${router.query
                    ->Webapi.Url.URLSearchParams.makeWithDict
                    ->Webapi.Url.URLSearchParams.toString}`,
                  ~data=None,
                  ~revalidation=None,
                )
                mutate(.
                  ~url=`${Env.restApiUrl}/order/summary?${Period.currentPeriod(router)}`,
                  ~data=None,
                  ~revalidation=None,
                )
              }
            },
            ~onFailure={_ => setShowErrorPostCourierInvoiceNo(._ => Dialog.Show)},
          )
        })
      })->ignore
    }
  )->ReactEvents.interceptingHandler

  <>
    // PC 뷰
    <Item.Table
      order
      courierCode
      setCourier
      invoice
      onChangeInvoice=handleOnChangeInvoice
      onSubmitInvoice=postCourierInvoiceNo
      check
      onCheckOrder
      onClickPacking
    />
    // 모바일 뷰
    <Item.Card
      order
      courierCode
      setCourier
      invoice
      onChangeInvoice=handleOnChangeInvoice
      onSubmitInvoice=postCourierInvoiceNo
      onClickPacking
    />
    <Dialog
      isShow=isShowErrorPostCourierInvoiceNo
      onConfirm={_ => setShowErrorPostCourierInvoiceNo(._ => Dialog.Hide)}>
      <p className=%twc("text-gray-500 text-center whitespace-pre-wrap")>
        {`송장번호 저장에 실패하였습니다.`->React.string}
      </p>
    </Dialog>
  </>
}
