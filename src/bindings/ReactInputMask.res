@module @react.component
external make: (
  ~type_: string=?,
  ~name: string=?,
  ~mask: string,
  ~maskPlaceholder: string=?,
  ~value: 'value=?,
  ~onBlur: 'onBlur=?,
  ~onFocus: 'onFocus=?,
  ~onChange: 'event => unit=?,
  ~className: 'className=?,
  ~placeholder: string=?,
  ~disabled: bool=?,
  ~children: React.element=?,
  ~tabIndex: int=?,
) => React.element = "react-input-mask"
