@send
external submitFormData: Webapi.Dom.Element.t => unit = "submit"

@react.component
let make = (~order: CustomHooks.OrdersAdmin.order) => {
  let status = CustomHooks.SweetTracker.use()

  let openPopupPostFormData = (
    _ => {
      let popUpWindowName = "tacking"
      let popUpWindowFeatures = "width=800, height=1000,location=yes,resizable=yes,scrollbars=yes,status=yes"
      let form =
        Webapi.Dom.document->Webapi.Dom.Document.getElementById(
          `${order.orderProductNo}-tracking-form`,
        )
      switch (Global.window, form) {
      | (Some(window'), Some(form')) => {
          Global.Window.openLink(
            window',
            ~url="",
            ~windowName=popUpWindowName,
            ~windowFeatures=popUpWindowFeatures,
            (),
          )

          form'->Webapi.Dom.Element.setAttribute("target", popUpWindowName)
          form'->Webapi.Dom.Element.setAttribute("action", Env.sweettrackerUrl)

          form'->submitFormData
        }
      | _ => ()
      }
    }
  )->ReactEvents.interceptingHandler

  switch status {
  | Loaded(data) =>
    switch data->CustomHooks.SweetTracker.response_decode {
    | Ok(data') =>
      Helper.Option.map2(order.courierCode, order.invoice, (courierCode, invoice) => {
        <>
          <form
            action=Env.sweettrackerUrl
            method="post"
            id={`${order.orderProductNo}-tracking-form`}
            className=%twc("hidden")>
            <input type_="text" name="t_key" defaultValue=data'.data.stApiKey />
            <input type_="text" name="t_code" defaultValue=courierCode />
            <input type_="text" name="t_invoice" defaultValue=invoice />
          </form>
          <button
            type_="button"
            className=%twc(
              "px-3 max-h-10 bg-green-gl-light text-green-gl font-bold rounded-lg whitespace-nowrap py-1 mt-2 max-w-min"
            )
            onClick={openPopupPostFormData}>
            {j`조회하기`->React.string}
          </button>
        </>
      })->Option.getWithDefault(
        <button
          type_="button"
          className=%twc(
            "px-3 max-h-10 bg-gray-100 text-gray-300 rounded-lg whitespace-nowrap py-1 mt-2 max-w-min"
          )
          onClick={openPopupPostFormData}
          disabled=true>
          {j`조회하기`->React.string}
        </button>,
      )
    | Error(_) =>
      <button
        type_="button"
        className=%twc(
          "px-3 max-h-10 bg-gray-100 text-gray-300 rounded-lg whitespace-nowrap py-1 mt-2 max-w-min"
        )
        disabled=true>
        {j`조회하기`->React.string}
      </button>
    }
  | _ =>
    <button
      type_="button"
      className=%twc(
        "px-3 max-h-10 bg-gray-100 text-gray-300 rounded-lg whitespace-nowrap py-1 mt-2 max-w-min"
      )
      disabled=true>
      {j`조회하기`->React.string}
    </button>
  }
}
