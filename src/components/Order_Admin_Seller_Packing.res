let formatDate = d => d->Js.Date.fromString->Locale.DateTime.formatFromUTC("yyyy/MM/dd HH:mm")

module Item = {
  module Table = {
    @react.component
    let make = (
      ~order: CustomHooks.OrdersAdmin.order,
      ~courierCode: option<string>,
      ~setCourier,
      ~invoice,
      ~onChangeInvoice,
      ~onSubmitInvoice,
    ) => {
      let isDisabledSubmitButton = switch (courierCode, invoice) {
      | (Some(_), Some(invoice')) if invoice' !== "" => false
      | _ => true
      }

      <li className=%twc("grid grid-cols-11-gl-admin text-gray-700")>
        <div className=%twc("h-full flex flex-col px-4 py-2")>
          <span className=%twc("block mb-1")> {order.farmerName->React.string} </span>
          <span className=%twc("block mb-1")>
            {`(${order.farmerPhone
              ->Helper.PhoneNumber.parse
              ->Option.flatMap(Helper.PhoneNumber.format)
              ->Option.getWithDefault(order.farmerPhone)})`->React.string}
          </span>
          <span className=%twc("block mb-1")> {order.buyerName->React.string} </span>
        </div>
        <div className=%twc("h-full flex flex-col px-4 py-2")>
          <span className=%twc("block")> {order.orderDate->formatDate->React.string} </span>
        </div>
        <div className=%twc("h-full flex flex-col px-4 py-2")>
          <span className=%twc("block text-gray-400 mb-2")>
            {order.productId->Int.toString->React.string}
          </span>
          <Badge_Admin status=order.status />
        </div>
        <div className=%twc("h-full flex flex-col px-4 py-2")>
          <Order_Detail_Button_Admin order />
        </div>
        <div className=%twc("h-full flex flex-col px-4 py-2")>
          {switch order.status {
          | PACKING
          | DEPARTURE
          | DELIVERING
          | COMPLETE => <>
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
                <label>
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
                </label>
              </div>
            </>
          | _ => `-`->React.string
          }}
        </div>
        <div className=%twc("h-full flex flex-col px-4 py-2")>
          <span className=%twc("block whitespace-nowrap")> {order.productName->React.string} </span>
          <span className=%twc("block text-gray-500")>
            {order.productOptionName->Option.getWithDefault("-")->React.string}
          </span>
          <span className=%twc("block whitespace-nowrap")>
            {order.quantity->Int.toString->React.string}
          </span>
        </div>
        <div className=%twc("h-full flex flex-col px-4 py-2")>
          <span className=%twc("block")>
            {order.receiverName->Option.getWithDefault(`-`)->React.string}
          </span>
          <span className=%twc("block")>
            {order.receiverPhone->Option.getWithDefault(`-`)->React.string}
          </span>
        </div>
        <div className=%twc("h-full flex flex-col px-4 py-2 whitespace-nowrap")>
          <span className=%twc("block")>
            {`${order.productPrice->Locale.Float.show(~digits=0)}원`->React.string}
          </span>
        </div>
        <div className=%twc("h-full flex flex-col px-4 py-2 whitespace-nowrap")>
          <span className=%twc("block")>
            {order.receiverAddress->Option.getWithDefault(`-`)->React.string}
          </span>
          <span className=%twc("block")>
            {order.receiverZipcode->Option.getWithDefault(`-`)->React.string}
          </span>
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
            {order.deliveryMessage->Option.getWithDefault("")->React.string}
          </span>
        </div>
      </li>
    }
  }

  module Loading = {
    open Skeleton

    @react.component
    let make = () => {
      <li className=%twc("grid grid-cols-11-gl-admin")>
        <div className=%twc("h-full flex flex-col px-4 py-2")>
          <Box className=%twc("w-2/3") /> <Box /> <Box className=%twc("w-2/3") />
        </div>
        <div className=%twc("h-full flex flex-col px-4 py-2")> <Box /> </div>
        <div className=%twc("h-full flex flex-col px-4 py-2")> <Box /> <Box /> <Box /> </div>
        <div className=%twc("h-full flex flex-col px-4 py-2")> <Box /> </div>
        <div className=%twc("h-full flex flex-col px-4 py-2")> <Box /> </div>
        <div className=%twc("h-full flex flex-col px-4 py-2")>
          <Box /> <Box className=%twc("w-2/3") /> <Box className=%twc("w-8") />
        </div>
        <div className=%twc("h-full flex flex-col px-4 py-2")>
          <Box className=%twc("w-2/3") /> <Box />
        </div>
        <div className=%twc("h-full flex flex-col px-4 py-2")> <Box /> </div>
        <div className=%twc("h-full flex flex-col px-4 py-2")>
          <Box /> <Box className=%twc("w-1/2") />
        </div>
        <div className=%twc("h-full flex flex-col px-4 py-2")> <Box /> <Box /> </div>
        <div className=%twc("h-full flex flex-col px-4 py-2")> <Box /> </div>
      </li>
    }
  }
}

@react.component
let make = (~order: CustomHooks.OrdersAdmin.order) => {
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
                  ~revalidation=Some(true),
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
    <Item.Table
      order
      courierCode
      setCourier
      invoice
      onChangeInvoice=handleOnChangeInvoice
      onSubmitInvoice=postCourierInvoiceNo
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
