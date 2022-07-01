module RootMultiple = {
  @react.component
  let make = React.forwardRef((
    ~children: React.element,
    ~_type,
    ~asChild=?,
    ~className=?,
    ~value=?,
    ~onValueChange=?,
    ref_,
  ) => {
    let defaultStyle = %twc("")
    <RadixUI.Accordian.RootMultiple
      ref=?{Js.Nullable.toOption(ref_)->Option.map(ReactDOM.Ref.domRef)}
      _type
      ?asChild
      ?value
      ?onValueChange
      className={className->Option.mapWithDefault(defaultStyle, className' =>
        cx([defaultStyle, className'])
      )}>
      {children}
    </RadixUI.Accordian.RootMultiple>
  })
}

module RootSingle = {
  @react.component
  let make = React.forwardRef((
    ~children: React.element,
    ~_type,
    ~asChild=?,
    ~collapsible=?,
    ~className=?,
    ~value=?,
    ~onValueChange=?,
    ref_,
  ) => {
    let defaultStyle = %twc("")
    <RadixUI.Accordian.RootSingle
      ref=?{Js.Nullable.toOption(ref_)->Option.map(ReactDOM.Ref.domRef)}
      _type
      ?asChild
      ?collapsible
      ?value
      ?onValueChange
      className={className->Option.mapWithDefault(defaultStyle, className' =>
        cx([defaultStyle, className'])
      )}>
      {children}
    </RadixUI.Accordian.RootSingle>
  })
}

module Trigger = {
  @react.component
  let make = React.forwardRef((~children, ~className=?, ~asChild=?, ref_) => {
    let defaultStyle = %twc("focus:outline-none accordian-trigger")
    <RadixUI.Accordian.Trigger
      ref=?{Js.Nullable.toOption(ref_)->Belt.Option.map(ReactDOM.Ref.domRef)}
      ?asChild
      className={className->Option.mapWithDefault(defaultStyle, className' =>
        cx([defaultStyle, className'])
      )}>
      {children}
    </RadixUI.Accordian.Trigger>
  })
}

module Item = {
  @react.component
  let make = React.forwardRef((~children, ~value, ~className=?, ~disabled=?, ~asChild=?, ref_) => {
    let defaultStyle = %twc("")
    <RadixUI.Accordian.Item
      ref=?{Js.Nullable.toOption(ref_)->Belt.Option.map(ReactDOM.Ref.domRef)}
      value
      ?asChild
      ?disabled
      className={className->Option.mapWithDefault(defaultStyle, className' =>
        cx([defaultStyle, className'])
      )}>
      {children}
    </RadixUI.Accordian.Item>
  })
}

module Header = {
  @react.component
  let make = React.forwardRef((~children, ~className=?, ~asChild=?, ref_) => {
    let defaultStyle = %twc("")
    <RadixUI.Accordian.Header
      ref=?{Js.Nullable.toOption(ref_)->Option.map(ReactDOM.Ref.domRef)}
      ?asChild
      className={className->Option.mapWithDefault(defaultStyle, className' =>
        cx([defaultStyle, className'])
      )}>
      {children}
    </RadixUI.Accordian.Header>
  })
}

module Content = {
  @react.component
  let make = React.forwardRef((~children, ~className=?, ~asChild=?, ~forceMount=?, ref_) => {
    let defaultStyle = %twc("accordian-content")
    <RadixUI.Accordian.Content
      ref=?{Js.Nullable.toOption(ref_)->Option.map(ReactDOM.Ref.domRef)}
      ?asChild
      ?forceMount
      className={className->Option.mapWithDefault(defaultStyle, className' =>
        cx([defaultStyle, className'])
      )}>
      {children}
    </RadixUI.Accordian.Content>
  })
}
