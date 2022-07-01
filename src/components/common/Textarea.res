type size = XLarge | Large | Medium | Small
type status = Normal | Error | Disabled

let normalStyle = %twc(
  "border border-border-default-L1 focus:outline-none focus:ring-1-gl focus:border-border-active focus:ring-opacity-100 remove-spin-button "
)
let errorStyle = %twc("border outline-none ring-2 ring-opacity-100 ring-notice remove-spin-button")
let disabledStyle = %twc(
  "bg-disabled-L3 border border-border-default-L1 focus:outline-none focus:ring-1-gl remove-spin-button focus:border-border-active"
)

let style = (error, disabled) =>
  switch disabled {
  | Some(true) => disabledStyle
  | Some(false)
  | None =>
    switch error {
    | Some(_) => errorStyle
    | None => normalStyle
    }
  }

let heightBySize = size =>
  switch size {
  | Some(XLarge) => %twc("h-[110px]")
  | Some(Large) => %twc("h-13")
  | Some(Small) => %twc("h-8")
  | Some(Medium)
  | None =>
    %twc("h-9")
  }

let defaultStyle = %twc("flex-1 flex px-3 h-full w-full")

let styleBySize = (style, size) =>
  switch size {
  | Some(XLarge)
  | Some(Large) =>
    cx([defaultStyle, style, %twc("rounded-xl py-3")])
  | Some(Small) => cx([defaultStyle, style, %twc("rounded-md py-1")])
  | Some(Medium)
  | None =>
    cx([defaultStyle, style, %twc("rounded-lg py-2")])
  }

@react.component
let make = (
  ~type_,
  ~name,
  ~placeholder,
  ~className=?,
  ~value=?,
  ~onChange=?,
  ~defaultValue=?,
  ~size=?,
  ~error,
  ~disabled=?,
  ~tabIndex=?,
  ~rows=?,
  ~maxLength=?,
  ~onKeyDown=?,
) =>
  <label
    className={className->Option.mapWithDefault(%twc("flex flex-col"), className' =>
      cx([%twc("flex flex-col"), className'])
    )}>
    <span className={heightBySize(size)}>
      <textarea
        type_
        className={style(error, disabled)->styleBySize(size)}
        name
        placeholder
        ?value
        ?onChange
        ?disabled
        ?tabIndex
        ?defaultValue
        ?rows
        ?maxLength
        ?onKeyDown
      />
    </span>
    {error
    ->Option.map(err =>
      <span className=%twc("flex mt-2")>
        <IconError width="20" height="20" />
        <span className=%twc("text-sm text-notice ml-1")> {err->React.string} </span>
      </span>
    )
    ->Option.getWithDefault(React.null)}
  </label>
