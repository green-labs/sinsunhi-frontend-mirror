type buttonType = [#primary | #secondary | #white]

module Normal = {
  let buttonStyle = (disabled, buttonType) =>
    switch disabled {
    | true => %twc("bg-disabled-L2 text-inverted text-opacity-50")
    | false =>
      switch buttonType {
      | #primary => %twc("bg-primary text-white")
      | #secondary => %twc("bg-primary bg-opacity-10 text-primary")
      | #white => %twc("bg-surface border border-border-default-L1 text-enabled-L1")
      }
    }

  module Large1 = {
    @react.component
    let make = React.forwardRef((
      ~className=?,
      ~label,
      ~disabled=false,
      ~onClick=?,
      ~buttonType: buttonType=#primary,
      ref_,
    ) => {
      let defaultStyle = cx([
        buttonStyle(disabled, buttonType),
        %twc("px-5 py-4 w-full rounded-xl font-bold"),
      ])
      <button
        ref=?{Js.Nullable.toOption(ref_)->Belt.Option.map(ReactDOM.Ref.domRef)}
        disabled
        ?onClick
        className={className->Option.mapWithDefault(defaultStyle, className' =>
          cx([defaultStyle, className'])
        )}>
        {label->React.string}
      </button>
    })
  }

  module Full1 = {
    @react.component
    let make = React.forwardRef((
      ~label,
      ~disabled=false,
      ~onClick=?,
      ~buttonType: buttonType=#primary,
      ref_,
    ) => {
      <button
        ref=?{Js.Nullable.toOption(ref_)->Belt.Option.map(ReactDOM.Ref.domRef)}
        disabled
        className={Cn.make([buttonStyle(disabled, buttonType), %twc("w-full py-4")])}
        ?onClick>
        {label->React.string}
      </button>
    })
  }
}

module Chip = {
  module TextSmall1 = {
    @react.component
    let make = (~label, ~selected=false, ~className=?, ~onClick=?) => {
      let defaultStyle = cx([
        switch selected {
        | true => %twc("bg-gray-800 text-white")
        | false => %twc("bg-white text-gray-500")
        },
        %twc("px-3 py-1.5 rounded-full"),
      ])

      <button
        ?onClick
        className={className->Option.mapWithDefault(defaultStyle, className' =>
          cx([defaultStyle, className'])
        )}>
        {label->React.string}
      </button>
    }
  }
}

module Tab = {
  module LeftTab1 = {
    @react.component
    let make = React.forwardRef((~text, ~selected=false, ~labelNumber=?, ~onClick=?, ref_) => {
      <button
        ref=?{Js.Nullable.toOption(ref_)->Belt.Option.map(ReactDOM.Ref.domRef)}
        ?onClick
        className={Cn.make([
          switch selected {
          | false => %twc("text-enabled-L4")
          | true => %twc("border-b-[3px] border-default text-default")
          },
          %twc("h-11 inline-flex flex-row items-center text-lg"),
        ])}>
        <span className=%twc("leading-7 font-bold")> {text->React.string} </span>
        {labelNumber->Option.mapWithDefault(React.null, number =>
          number->Option.mapWithDefault(React.null, number' => {
            <div className=%twc("flex items-center")>
              <span
                className=%twc(
                  "inline ml-1 text-primary bg-opacity-10 bg-primary-variant px-[6px] rounded-xl text-xs text-center font-bold"
                )>
                {number'->React.string}
              </span>
            </div>
          })
        )}
      </button>
    })
  }
}
