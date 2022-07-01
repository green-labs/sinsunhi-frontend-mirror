@spice
type status =
  | @spice.as(`과세`) TAX
  | @spice.as(`면세`) FREE

let toString = status => status->status_encode->Js.Json.decodeString

let toBool = status =>
  if status == `과세` {
    true
  } else {
    false
  }

let defaultStyle = %twc(
  "flex px-3 py-2 border items-center border-border-default-L1 rounded-lg h-9 text-enabled-L1 focus:outline"
)

@react.component
let make = (~status, ~onChange, ~forwardRef=?, ~disabled=?) => {
  let displayStatus =
    status->Option.flatMap(toString)->Option.getWithDefault(`과면세여부 선택`)

  let value = status->Option.flatMap(toString)->Option.getWithDefault("")

  <span>
    <label className=%twc("block relative")>
      <span
        className={disabled->Option.mapWithDefault(defaultStyle, d =>
          d ? cx([defaultStyle, %twc("bg-disabled-L3")]) : defaultStyle
        )}>
        {displayStatus->React.string}
      </span>
      <span className=%twc("absolute top-1.5 right-2")>
        <IconArrowSelect height="24" width="24" fill="#121212" />
      </span>
      <select
        value
        className=%twc("block w-full h-full absolute top-0 opacity-0")
        onChange
        ?disabled
        ref=?{forwardRef}>
        <option value="" disabled=true hidden={value == "" ? false : true}>
          {`과면세여부 선택`->React.string}
        </option>
        {[TAX, FREE]
        ->Array.map(s => {
          let value = s->status_encode->Js.Json.decodeString->Option.getWithDefault("")
          <option key={value} value> {value->React.string} </option>
        })
        ->React.array}
      </select>
    </label>
  </span>
}
