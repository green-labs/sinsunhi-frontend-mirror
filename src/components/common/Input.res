type size = Large | Medium | Small
type status = Normal | Error | Disabled
type textAlign = Left | Center | Right

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

let inputStyleBySize = (style, size) =>
  switch size {
  | Some(Large) => cx([%twc("w-full flex-1 rounded-xl px-3 h-13"), style])
  | Some(Small) => cx([%twc("w-full flex-1 rounded-md px-3 h-8"), style])
  | Some(Medium)
  | None =>
    cx([%twc("w-full flex-1 rounded-lg h-10 px-3"), style])
  }

let styleByTextAlign = (style, textAlign) =>
  switch textAlign {
  | Some(Left) => cx([%twc("text-left"), style])
  | Some(Center) => cx([%twc("text-center"), style])
  | Some(Right) => cx([%twc("text-right"), style])
  | None => style
  }

@react.component
let make = (
  ~id=?,
  ~type_,
  ~name,
  ~placeholder=?,
  ~className=?,
  ~value=?,
  ~onChange=?,
  ~defaultValue=?,
  ~size=?,
  ~error,
  ~disabled=?,
  ~tabIndex=?,
  ~min=?,
  ~step=?,
  ~textAlign=?,
  ~inputRef as ref=?,
) =>
  <div className=%twc("flex-1")>
    <label>
      <input
        ?id
        type_
        className={[
          style(error, disabled)->inputStyleBySize(size)->styleByTextAlign(textAlign),
          className->Option.getWithDefault(""),
        ]->Cx.cx}
        name
        ?placeholder
        ?value
        ?onChange
        ?disabled
        ?tabIndex
        ?defaultValue
        ?min
        ?step
        ?ref
      />
    </label>
    {error
    ->Option.map(err =>
      <span className=%twc("flex mt-2")>
        <IconError width="20" height="20" />
        <span className=%twc("text-sm text-notice ml-1")> {err->React.string} </span>
      </span>
    )
    ->Option.getWithDefault(React.null)}
  </div>

module InputWithRef = {
  @react.component
  let make = (
    ~type_,
    ~name,
    ~placeholder=?,
    ~className=?,
    ~value=?,
    ~onChange=?,
    ~defaultValue=?,
    ~size=?,
    ~error,
    ~disabled=?,
    ~tabIndex=?,
    ~min=?,
    ~step=?,
    ~inputRef,
  ) =>
    <label
      className={className->Option.mapWithDefault(
        %twc("flex flex-col min-w-0 relative"),
        className' => cx([%twc("flex flex-col min-w-0 relative"), className']),
      )}>
      <input
        type_
        className={style(error, disabled)->inputStyleBySize(size)}
        name
        ?placeholder
        ?value
        ?onChange
        ?disabled
        ?tabIndex
        ?defaultValue
        ?min
        ?step
        ref={inputRef}
      />
      {error
      ->Option.map(err =>
        <RadixUI.Tooltip.Root delayDuration=300>
          <RadixUI.Tooltip.Trigger asChild={true}>
            <span className={%twc("absolute top-1/2 right-2 transform -translate-y-1/2")}>
              <IconError height="16" width="16" />
            </span>
          </RadixUI.Tooltip.Trigger>
          <RadixUI.Tooltip.Content side=#top sideOffset=4 avoidCollisions=false>
            <div className=%twc("block min-w-max relative")>
              <div className=%twc("flex flex-col justify-center")>
                <h5
                  className=%twc(
                    "bg-white border border-notice text-notice text-sm text-center py-1 rounded-xl shadow-tooltip px-2"
                  )>
                  {err->React.string}
                </h5>
              </div>
            </div>
          </RadixUI.Tooltip.Content>
        </RadixUI.Tooltip.Root>
      )
      ->Option.getWithDefault(React.null)}
    </label>
}
