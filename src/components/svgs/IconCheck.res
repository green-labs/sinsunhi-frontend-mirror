@module("../../../public/assets/check.svg?react") @react.component
external make: (
  ~height: string,
  ~width: string,
  ~fill: string,
  ~className: string=?,
) => React.element = "default"
