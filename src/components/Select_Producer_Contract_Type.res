@spice
type status =
  | @spice.as(`온라인택배`) ONLINESALE
  | @spice.as(`전량판매`) BULKSALE

let toString = status => status->status_encode->Js.Json.decodeString

@react.component
let make = (~status, ~onChange, ~forwardRef: ReactDOM.domRef) => {
  let displayStatus =
    status->Option.flatMap(toString)->Option.getWithDefault(`공급가 타입 선택`)

  let value = status->Option.flatMap(toString)->Option.getWithDefault("")

  let handleOnChange = e => {
    let status = (e->ReactEvent.Synthetic.target)["value"]

    switch status->status_decode {
    | Ok(status') => onChange(status')
    | _ => ignore()
    }
  }

  <span>
    <label className=%twc("block relative")>
      <span
        className=%twc(
          "flex px-3 py-2 border items-center bg-white border-border-default-L1 rounded-lg h-9 text-enabled-L1 focus:outline"
        )>
        {displayStatus->React.string}
      </span>
      <span className=%twc("absolute top-1.5 right-2")>
        <IconArrowSelect height="24" width="24" fill="#121212" />
      </span>
      <select
        value
        className=%twc("block w-full h-full absolute top-0 opacity-0")
        onChange={handleOnChange}
        ref={forwardRef}>
        <option value="" disabled=true hidden={value == "" ? false : true}>
          {`공급가 타입 선택`->React.string}
        </option>
        {[ONLINESALE, BULKSALE]
        ->Array.map(s => {
          let value = s->toString->Option.getWithDefault("")
          <option key={value} value> {value->React.string} </option>
        })
        ->React.array}
      </select>
    </label>
  </span>
}
