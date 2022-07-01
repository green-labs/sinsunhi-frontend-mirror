module type Status = {
  type status

  let options: array<status>

  let toDisplay: status => string

  let status_encode: status => Js.Json.t
  let status_decode: Js.Json.t => Result.t<status, Spice.decodeError>
}

module Select = (Status: Status) => {
  include Status

  let toString = status => status->status_encode->Js.Json.decodeString

  let defaultStyle = %twc(
    "flex px-3 py-2 border items-center border-border-default-L1 rounded-lg h-9 text-enabled-L1 focus:outline"
  )

  @react.component
  let make = (~status, ~onChange, ~forwardRef: ReactDOM.domRef, ~disabled=?) => {
    let displayStatus =
      status->Option.map(Status.toDisplay)->Option.getWithDefault(`운영상태 선택`)

    let value = status->Option.flatMap(toString)->Option.getWithDefault("")

    let handleProductOperationStatus = e => {
      let status = (e->ReactEvent.Synthetic.target)["value"]

      switch status->status_decode {
      | Ok(status') => onChange(status')
      | _ => ignore()
      }
    }

    <span>
      <label className=%twc("block relative")>
        <span
          className={disabled->Option.mapWithDefault(cx([defaultStyle, %twc("bg-white")]), d =>
            d ? cx([defaultStyle, %twc("bg-disabled-L3")]) : cx([defaultStyle, %twc("bg-white")])
          )}>
          {displayStatus->React.string}
        </span>
        <span className=%twc("absolute top-1.5 right-2")>
          <IconArrowSelect height="24" width="24" fill="#121212" />
        </span>
        <select
          value
          className=%twc("block w-full h-full absolute top-0 opacity-0")
          onChange={handleProductOperationStatus}
          ?disabled
          ref={forwardRef}>
          <option value="" disabled=true hidden={value == "" ? false : true}>
            {`운영상태 선택`->React.string}
          </option>
          {Status.options
          ->Array.map(s => {
            let value = s->toString->Option.getWithDefault("")
            <option key={value} value> {s->Status.toDisplay->React.string} </option>
          })
          ->React.array}
        </select>
      </label>
    </span>
  }
}

module BaseStatus = {
  @spice
  type status =
    | @spice.as(`SALE`) SALE
    | @spice.as(`SOLDOUT`) SOLDOUT
    | @spice.as(`NOSALE`) NOSALE
    | @spice.as(`RETIRE`) RETIRE
    | @spice.as(`HIDDEN_SALE`) HIDDEN_SALE

  let toDisplay = status =>
    switch status {
    | SALE => `판매중`
    | SOLDOUT => `품절`
    | NOSALE => `숨김`
    | RETIRE => `영구판매중지`
    | HIDDEN_SALE => `전시판매숨김`
    }

  let options = [SALE, SOLDOUT, HIDDEN_SALE, NOSALE, RETIRE]
}

module SearchStatus = {
  @spice
  type status =
    | @spice.as(`ALL`) ALL
    | @spice.as(`SALE`) SALE
    | @spice.as(`SOLDOUT`) SOLDOUT
    | @spice.as(`NOSALE`) NOSALE
    | @spice.as(`RETIRE`) RETIRE
    | @spice.as(`HIDDEN_SALE`) HIDDEN_SALE

  let toDisplay = status =>
    switch status {
    | ALL => `전체`
    | SALE => `판매중`
    | SOLDOUT => `품절`
    | NOSALE => `숨김`
    | RETIRE => `영구판매중지`
    | HIDDEN_SALE => `전시판매중지`
    }

  let options = [ALL, SALE, SOLDOUT, HIDDEN_SALE, NOSALE, RETIRE]
}

module Base = Select(BaseStatus)
module Search = Select(SearchStatus)
