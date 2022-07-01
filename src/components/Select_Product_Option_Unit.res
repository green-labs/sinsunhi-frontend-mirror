module type Status = {
  type status

  let options: array<status>

  let status_encode: status => Js.Json.t
  let status_decode: Js.Json.t => Result.t<status, Spice.decodeError>
}

module Select = (Status: Status) => {
  include Status

  let toString = status => status->status_encode->Js.Json.decodeString->Option.getWithDefault("")

  let fromString = str => str->Js.Json.string->status_decode

  let defaultStyle = %twc(
    "md:w-20 flex items-center border border-border-default-L1 rounded-md px-3 text-enabled-L1 h-9"
  )

  @react.component
  let make = (~status, ~onChange, ~forwardRef=?, ~disabled=false) => {
    let displayStatus = status->toString

    let handleProductOptionUnit = e => {
      let value = (e->ReactEvent.Synthetic.target)["value"]

      switch value->status_decode {
      | Ok(status') => onChange(status')
      | _ => ignore()
      }
    }

    <span>
      <label className=%twc("block relative")>
        <span
          className={disabled
            ? cx([defaultStyle, %twc("bg-disabled-L3")])
            : cx([defaultStyle, %twc("bg-white")])}>
          {displayStatus->React.string}
        </span>
        <span className=%twc("absolute top-1.5 right-2")>
          <IconArrowSelect height="24" width="24" fill="#121212" />
        </span>
        <select
          disabled
          value={status->toString}
          className=%twc("block w-full h-full absolute top-0 opacity-0")
          ref=?{forwardRef}
          onChange={handleProductOptionUnit}>
          {Status.options
          ->Garter.Array.map(s =>
            <option key={s->toString} value={s->toString}> {s->toString->React.string} </option>
          )
          ->React.array}
        </select>
      </label>
    </span>
  }
}

module WeightStatus = {
  @spice
  type status =
    | @spice.as("g") G
    | @spice.as("kg") KG
    | @spice.as("t") T

  let options = [G, KG, T]
}

module SizeStatus = {
  @spice
  type status =
    | @spice.as("mm") MM
    | @spice.as("cm") CM
    | @spice.as("m") M

  let options = [MM, CM, M]
}

module Weight = Select(WeightStatus)
module Size = Select(SizeStatus)
