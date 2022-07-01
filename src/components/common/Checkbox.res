@react.component
let make = (~id=?, ~name=?, ~checked=?, ~onChange=?, ~disabled=?) => {
  let style = switch disabled {
  | Some(true) =>
    %twc("w-5 h-5 border-2 border-gray-200 bg-gray-100 rounded flex justify-center items-center")
  | Some(false)
  | None =>
    switch checked {
    | Some(true) => %twc("w-5 h-5 bg-green-gl rounded flex justify-center items-center")
    | Some(false) =>
      %twc("w-5 h-5 bg-white border-2 border-gray-300 rounded flex justify-center items-center")
    | None =>
      %twc("w-5 h-5 border-2 border-gray-200 bg-gray-100 rounded flex justify-center items-center")
    }
  }

  <>
    <input type_="checkbox" ?id ?name className=%twc("hidden") ?checked ?onChange ?disabled />
    <label htmlFor={id->Option.getWithDefault("")} className=style>
      {checked->Option.mapWithDefault(React.null, checked' =>
        checked' ? <IconInputCheck height="12" width="14" fill="#FFF" /> : React.null
      )}
    </label>
  </>
}

module Uncontrolled = {
  @react.component
  let make = (
    ~id=?,
    ~name=?,
    ~defaultChecked=?,
    ~onBlur=?,
    ~onChange=?,
    ~disabled=?,
    ~inputRef=?,
  ) => {
    module PeerStyles = {
      let default = %twc("peer-default:bg-white border-2 peer-default:border-gray-300 ")
      let checked = %twc("peer-checked:bg-green-gl ")
      let disabled = %twc(
        "peer-disabled:border-2 peer-disabled:border-gray-200 peer-disabled:bg-gray-100"
      )
    }

    <>
      <input
        type_="checkbox"
        ?id
        ?name
        className={"peer " ++ %twc("hidden")}
        ?defaultChecked
        ?onChange
        ?onBlur
        ?disabled
        ref=?inputRef
      />
      <label
        htmlFor={id->Option.getWithDefault("")}
        className={%twc("w-5 h-5 rounded flex justify-center items-center ") ++
        PeerStyles.default ++
        PeerStyles.checked ++
        PeerStyles.disabled}>
        <IconInputCheck height="12" width="14" fill="#FFF" />
      </label>
    </>
  }
}
