@module("../../../public/assets/arrow-right.svg?react") @react.component
external make: (
  ~height: string,
  ~width: string,
  ~stroke: string=?,
  ~strokeWidth: string=?,
  ~fill: string=?,
  ~className: string=?,
) => React.element = "default"
