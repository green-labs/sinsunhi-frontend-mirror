@react.component
let make = (~className=?) =>
  <div
    className={cx([%twc("my-5 w-full h-px bg-disabled-L2"), className->Option.getWithDefault("")])}
  />
