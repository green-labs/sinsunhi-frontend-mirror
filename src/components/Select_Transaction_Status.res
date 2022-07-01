open CustomHooks.Transaction

let getKind = q =>
  q
  ->Js.Dict.get("type")
  ->Option.flatMap(type_ =>
    switch type_->Js.Json.string->kind_decode {
    | Ok(type_') => Some(type_')
    | Error(_) => None
    }
  )

@react.component
let make = (~className=?) => {
  let router = Next.Router.useRouter()

  let onChange = e => {
    let {makeWithDict, toString} = module(Webapi.Url.URLSearchParams)

    let type_ = (e->ReactEvent.Synthetic.target)["value"]

    router.query->Js.Dict.set("type", type_)
    router.query->Js.Dict.set("offset", "0")
    router->Next.Router.push(`${router.pathname}?${router.query->makeWithDict->toString}`)
  }

  <span ?className>
    <label className=%twc("block relative")>
      <span
        className=%twc(
          "w-36 flex items-center border border-border-default-L1 rounded-md h-9 px-3 text-enabled-L1"
        )>
        {getKind(router.query)
        ->Option.mapWithDefault(`전체 정산유형`, Converter.displayTransactionKind)
        ->React.string}
      </span>
      <span className=%twc("absolute top-1.5 right-2")>
        <IconArrowSelect height="24" width="24" fill="#121212" />
      </span>
      <select
        value={router.query->Js.Dict.get("type")->Option.getWithDefault("all")}
        className=%twc("block w-full h-full absolute top-0 opacity-0")
        onChange>
        <option key=`all` value=``> {`전체 정산유형`->React.string} </option>
        {[
          OrderComplete,
          CashRefund,
          ImwebPay,
          ImwebCancel,
          OrderCancel,
          OrderRefundDeliveryDelayed,
          OrderRefundDefectiveProduct,
          SinsunCash,
        ]
        ->Garter.Array.map(t =>
          <option
            key={t->kind_encode->Converter.getStringFromJsonWithDefault("")}
            value={t->kind_encode->Converter.getStringFromJsonWithDefault("")}>
            {t->Converter.displayTransactionKind->React.string}
          </option>
        )
        ->React.array}
      </select>
    </label>
  </span>
}
