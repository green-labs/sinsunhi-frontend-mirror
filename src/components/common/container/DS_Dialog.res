module Popup = {
  module Root = {
    @react.component
    let make = (
      ~children: React.element,
      ~defaultOpen=?,
      ~_open=?,
      ~onOpenChange=?,
      ~className=?,
    ) => {
      <RadixUI.Dialog.Root ?_open ?defaultOpen ?onOpenChange ?className>
        {children}
      </RadixUI.Dialog.Root>
    }
  }

  module Trigger = {
    @react.component
    let make = React.forwardRef((~children, ~className=?, ~asChild=?, ref_) => {
      <RadixUI.Dialog.Trigger
        ref=?{Js.Nullable.toOption(ref_)->Belt.Option.map(ReactDOM.Ref.domRef)} ?asChild ?className>
        {children}
      </RadixUI.Dialog.Trigger>
    })
  }

  module Portal = {
    @react.component
    let make = (~children, ~className=?) => {
      <RadixUI.Dialog.Portal ?className> {children} </RadixUI.Dialog.Portal>
    }
  }

  module Overlay = {
    @react.component
    let make = React.forwardRef((~className=?, ref_) => {
      let defaultStyle = %twc("dialog-overlay")
      <RadixUI.Dialog.Overlay
        ref=?{Js.Nullable.toOption(ref_)->Belt.Option.map(ReactDOM.Ref.domRef)}
        className={className->Option.mapWithDefault(defaultStyle, className' =>
          cx([defaultStyle, className'])
        )}
      />
    })
  }

  module Content = {
    @react.component
    let make = React.forwardRef((~children, ~className=?, ref_) => {
      let defaultStyle = %twc("dialog-content p-6 rounded-xl")
      <RadixUI.Dialog.Content
        ref=?{Js.Nullable.toOption(ref_)->Belt.Option.map(ReactDOM.Ref.domRef)}
        className={className->Option.mapWithDefault(defaultStyle, className' =>
          cx([defaultStyle, className'])
        )}>
        {children}
      </RadixUI.Dialog.Content>
    })
  }

  module Title = {
    @react.component
    let make = React.forwardRef((~children, ~className=?, ref_) => {
      let defaultStyle = %twc("font-bold text-lg text-center mb-2")
      <RadixUI.Dialog.Title
        ref=?{Js.Nullable.toOption(ref_)->Belt.Option.map(ReactDOM.Ref.domRef)}
        className={className->Option.mapWithDefault(defaultStyle, className' =>
          cx([defaultStyle, className'])
        )}>
        {children}
      </RadixUI.Dialog.Title>
    })
  }

  module Description = {
    @react.component
    let make = React.forwardRef((~children, ~className=?, ref_) => {
      let defaultStyle = %twc("text-center text-enabled-L2 font-normal")
      <RadixUI.Dialog.Description
        ref=?{Js.Nullable.toOption(ref_)->Belt.Option.map(ReactDOM.Ref.domRef)}
        className={className->Option.mapWithDefault(defaultStyle, className' =>
          cx([defaultStyle, className'])
        )}>
        {children}
      </RadixUI.Dialog.Description>
    })
  }

  module Buttons = {
    @react.component
    let make = (~children, ~className=?) => {
      let defaultStyle = %twc("flex justify-between mt-6 gap-[7px]")
      <div
        className={className->Option.mapWithDefault(defaultStyle, className' =>
          cx([defaultStyle, className'])
        )}>
        {children}
      </div>
    }
  }

  module Close = {
    @react.component
    let make = (~children, ~className=?, ~asChild=?) => {
      <RadixUI.Dialog.Close ?asChild ?className> {children} </RadixUI.Dialog.Close>
    }
  }
}
