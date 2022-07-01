type location =
  | Start
  | End

@react.component
let make = (
  ~name,
  ~type_="string",
  ~value,
  ~onChange,
  ~adornmentLocation=End,
  ~textLocation=End,
  ~adornment,
  ~placeholder,
  ~errored: bool=false,
  ~errorElement=?,
  ~helperText=``,
  ~className="",
) => {
  let (blur, setBlur) = React.Uncurried.useState(_ => false)

  let notice = errored && blur && value !== ""

  let outerCommonClassName = cx([
    %twc(
      "flex w-full border rounded-lg items-center p-2 focus-within:ring-1-gl focus-within:border-border-active focus-within:ring-opacity-100"
    ),
    className,
  ])

  let outerClassName = cx([
    switch (notice, adornmentLocation) {
    | (true, Start) => %twc("border-notice")
    | (false, Start) => %twc("border-border-default-L1")
    | (true, End) => %twc("flex-row-reverse border-notice")
    | (false, End) => %twc("flex-row-reverse border-border-default-L1")
    },
    outerCommonClassName,
  ])
  let inputClassName = switch textLocation {
  | Start => %twc("border-0 focus:outline-none mr-1 w-full remove-spin-button")
  | End => %twc("border-0 focus:outline-none text-right mr-1 w-full remove-spin-button")
  }

  <>
    <label className=outerClassName>
      adornment
      <input
        type_
        name
        value
        onChange
        onFocus={_ => setBlur(._ => false)}
        onBlur={_ => setBlur(._ => true)}
        className=inputClassName
        placeholder
      />
    </label>
    {notice
      ? <div className=%twc("flex items-center mt-1 h-5 text-notice")>
          {errorElement->Option.getWithDefault(React.null)}
        </div>
      : <div className=inputClassName> {helperText->React.string} </div>}
  </>
}
