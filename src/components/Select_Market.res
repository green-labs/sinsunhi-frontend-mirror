type markets = CustomHooks.Shipments.marketType
let markets_encode = CustomHooks.Shipments.marketType_encode
let markets_decode = CustomHooks.Shipments.marketType_decode

let toOption = (r: Result.t<'a, 'b>) =>
  switch r {
  | Ok(str) => Some(str)
  | Error(_) => None
  }

let encodeMarkets = (market: markets): string =>
  market->markets_encode->Js.Json.stringify->Js.String2.replaceByRe(%re("/\"/g"), "")

let decodeMarket = (str: string): option<markets> => str->Js.Json.string->markets_decode->toOption

let parseMarket = q => q->Js.Dict.get("market")->Option.flatMap(decodeMarket)

let display = (market: markets) => {
  switch market {
  | ONLINE => `온라인 택배`
  | OFFLINE => `오프라인`
  | WHOLESALE => `도매출하`
  }
}

@react.component
let make = (~market: option<markets>, ~onChange) => {
  <span>
    <label className=%twc("block relative")>
      <span
        className=%twc(
          "sm:w-44 flex items-center border border-border-default-L1 bg-white rounded-md px-3 py-2 text-enabled-L1 leading-4.5"
        )>
        {market->Option.mapWithDefault(`전체 거래유형`, display)->React.string}
      </span>
      <span className=%twc("absolute top-1.5 right-2")>
        <IconArrowSelect height="24" width="24" fill="#121212" />
      </span>
      <select
        value={market->Option.mapWithDefault("", encodeMarkets)}
        className=%twc("block w-full h-full absolute top-0 opacity-0")
        onChange>
        <option value={""}> {`전체 거래유형`->React.string} </option>
        {
          open CustomHooks.Shipments
          [ONLINE, OFFLINE, WHOLESALE]
          ->Garter.Array.map(s =>
            <option key={s->encodeMarkets} value={s->encodeMarkets}>
              {s->display->React.string}
            </option>
          )
          ->React.array
        }
      </select>
    </label>
  </span>
}
