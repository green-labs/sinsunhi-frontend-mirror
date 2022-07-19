@module("../../../../public/assets/searchbar-clear.svg")
external searchBarClear: string = "default"

module Convert = {
  let toOnlyNumber = value =>
    value->Js.String2.replaceByRe(%re("/[^0-9]/g"), "")->Js.String2.replaceByRe(%re("/^[0]/g"), "")

  let toTon = v => {
    v->Js.String2.sliceToEnd(~from=-2) == "00"
      ? {
          let ton = v->Js.String2.slice(~from=0, ~to_=v->Js.String2.length - 3)

          if v->Js.String2.sliceToEnd(~from=-3) == "000" {
            `${ton}톤`
          } else {
            `${ton}.${v->Js.String2.slice(~from=-3, ~to_=-2)}톤`
          }
        }
      : `${v}kg`
  }

  let convertNumber = (labelType, value) => {
    switch labelType {
    | #ton => value->Js.String2.length > 3 ? value->toTon : `${value}kg`
    | #won => `${value->Int64.of_string->KoreanNumeral.fromInt64()} 원`
    }
  }
}

module Line1 = {
  type status = Error | Default | Disable

  let normalStyle = %twc(
    "border border-border-default-L1 focus:outline-none focus:ring-1-gl focus:border-border-active focus:ring-opacity-100 remove-spin-button "
  )
  let errorStyle = %twc(
    "border outline-none ring-2 ring-opacity-100 ring-notice remove-spin-button"
  )
  let disabledStyle = %twc(
    "bg-disabled-L3 border border-border-default-L1 focus:outline-none focus:ring-1-gl remove-spin-button focus:border-border-active"
  )

  let lineStyle = (errorMessage, disabled, focused) =>
    switch disabled {
    | Some(true) => %twc("bg-border-disabled h-0.5 mt-1.5")
    | Some(false)
    | None =>
      switch errorMessage {
      | Some(_) => %twc("bg-emphasis h-0.5 mt-1.5")
      | None => focused ? %twc("bg-primary h-0.5 mt-1.5") : %twc("bg-border-disabled h-0.5 mt-1.5")
      }
    }

  module Root = {
    @react.component
    let make = (~children, ~className=?) => {
      let defaultStyle = %twc("relative flex flex-col min-w-0 mx-5")
      <label
        className={className->Option.mapWithDefault(defaultStyle, className' =>
          cx([defaultStyle, className'])
        )}>
        {children}
      </label>
    }
  }
  module Input = {
    @react.component
    let make = (
      ~type_,
      ~className=?,
      ~placeholder=?,
      ~value=?,
      ~onChange=?,
      ~disabled=?,
      ~autoFocus=?,
      ~inputMode=?,
      ~isClear=false,
      ~fnClear=?,
      ~unit=?,
      ~errorMessage=?,
      ~underLabel=?,
      ~underLabelType: option<[#ton | #won]>=?,
      ~maxLength=?,
    ) => {
      let (focused, setFocused) = React.Uncurried.useState(_ => false)
      <>
        <DS_Input.InputText1
          type_
          ?className
          ?placeholder
          ?value
          ?onChange
          ?disabled
          ?autoFocus
          ?inputMode
          ?maxLength
          onFocus={_ => setFocused(._ => true)}
          onBlur={_ => setFocused(._ => false)}
        />
        <div className=%twc("absolute top-0 right-0 flex justify-end items-center")>
          <div className=%twc("absolute top-0 right-0 flex justify-end items-center")>
            {unit->Option.mapWithDefault(React.null, x =>
              <span className=%twc("mr-2.5 text-xl w-20 text-right")> {x->React.string} </span>
            )}
            {isClear &&
            value->Option.isSome &&
            value->Option.mapWithDefault(false, x => x->Js.String2.trim !== "")
              ? <button
                  onClick={_ => fnClear->Option.mapWithDefault((), fn => fn())}
                  className=%twc("h-[30px]")>
                  <img src=searchBarClear />
                </button>
              : React.null}
          </div>
        </div>
        <div className={lineStyle(errorMessage, disabled, focused)} />
        {
          let getUnderLabel = {
            <span className=%twc("text-gray-400 text-sm leading-5 mt-3")>
              {switch (
                value,
                value->Option.mapWithDefault(false, x => x->Js.String2.trim !== ""),
                underLabelType,
              ) {
              | (Some(value'), true, Some(underLabelType')) =>
                Convert.convertNumber(underLabelType', value'->Convert.toOnlyNumber)->React.string
              | _ => underLabel->Option.getWithDefault(``)->React.string
              }}
            </span>
          }

          switch disabled {
          | Some(true) => getUnderLabel
          | Some(false)
          | None =>
            switch errorMessage->Option.flatMap(Garter_Fn.identity) {
            | Some(errorMessage') =>
              <span className=%twc("text-emphasis text-sm leading-5 mt-3")>
                {errorMessage'->React.string}
              </span>
            | None => getUnderLabel
            }
          }
        }
      </>
    }
  }
}
