module Detail = {
  module Root = {
    @react.component
    let make = (~children, ~className=?, ~bgClassName=%twc("bg-white")) => {
      let defaultStyle = cx([
        %twc(
          "fixed top-0 left-1/2 w-full flex justify-between items-center max-w-3xl -translate-x-1/2 p-3"
        ),
        bgClassName,
      ])
      <div
        className={className->Option.mapWithDefault(defaultStyle, className' =>
          cx([defaultStyle, bgClassName, className'])
        )}>
        {children}
      </div>
    }
  }
  module Left = {
    @react.component
    let make = (~children, ~className=?) => {
      let defaultStyle = %twc("mr-2")
      <div
        className={className->Option.mapWithDefault(defaultStyle, className' =>
          cx([defaultStyle, className'])
        )}>
        {children}
      </div>
    }
  }
  module Center = {
    @react.component
    let make = (~children, ~className=?) => {
      let defaultStyle = %twc(
        "absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 tracking-tight font-bold truncate"
      )
      <div
        className={className->Option.mapWithDefault(defaultStyle, className' =>
          cx([defaultStyle, className'])
        )}>
        {children}
      </div>
    }
  }
  module Right = {
    @react.component
    let make = (~children, ~className=?) => {
      let defaultStyle = %twc("ml-2")
      <div
        className={className->Option.mapWithDefault(defaultStyle, className' =>
          cx([defaultStyle, className'])
        )}>
        {children}
      </div>
    }
  }
}
