@module("../../../public/assets/error.svg?react") @react.component
external make: (
  ~width: string,
  ~height: string,
  ~className: string=?,
  ~stroke: string=?,
) => React.element = "default"
