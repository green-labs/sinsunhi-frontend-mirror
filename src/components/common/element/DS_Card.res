module Infomation1 = {
  module Root = {
    @react.component
    let make = (~children, ~className=?) => {
      let defaultStyle = %twc("flex flex-col items-center space-y-3 mx-5")
      <ul
        className={className->Option.mapWithDefault(defaultStyle, className' =>
          cx([defaultStyle, className'])
        )}>
        {children}
      </ul>
    }
  }
  module Content = {
    @react.component
    let make = (~children, ~className=?, ~onClick=?) => {
      let defaultStyle = %twc("w-full bg-white rounded-lg py-5")
      <li
        ?onClick
        className={className->Option.mapWithDefault(defaultStyle, className' =>
          cx([defaultStyle, className'])
        )}>
        {children}
      </li>
    }
  }
  module MainList = {
    @react.component
    let make = (~children, ~className=?, ~onClick=?) => {
      let defaultStyle = %twc("tab-highlight-color")

      <div
        ?onClick
        className={className->Option.mapWithDefault(defaultStyle, className' =>
          cx([defaultStyle, className'])
        )}>
        {children}
      </div>
    }
  }

  module SubList = {
    @react.component
    let make = (~children, ~className=?) => {
      let defaultStyle = %twc("flex flex-col pt-5")
      <div
        className={className->Option.mapWithDefault(defaultStyle, className' =>
          cx([defaultStyle, className'])
        )}>
        {children}
      </div>
    }
  }
}

module Infomation2 = {
  module Root = {
    @react.component
    let make = (~children, ~className=?) => {
      let defaultStyle = %twc("flex flex-col items-center space-y-3 mx-5")
      <ul
        className={className->Option.mapWithDefault(defaultStyle, className' =>
          cx([defaultStyle, className'])
        )}>
        {children}
      </ul>
    }
  }
  module Content = {
    @react.component
    let make = (~children, ~className=?, ~onClick=?) => {
      let defaultStyle = %twc("w-full bg-white rounded-lg py-5 mx-6")
      <li
        ?onClick
        className={className->Option.mapWithDefault(defaultStyle, className' =>
          cx([defaultStyle, className'])
        )}>
        {children}
      </li>
    }
  }
  module MainList = {
    @react.component
    let make = (~children, ~className=?, ~onClick=?) => {
      let defaultStyle = %twc("mb-6")

      <div
        ?onClick
        className={className->Option.mapWithDefault(defaultStyle, className' =>
          cx([defaultStyle, className'])
        )}>
        {children}
      </div>
    }
  }

  module SubList = {
    @react.component
    let make = (~children, ~className=?) => {
      let defaultStyle = %twc("flex flex-col gap-3")

      <div
        className={className->Option.mapWithDefault(defaultStyle, className' =>
          cx([defaultStyle, className'])
        )}>
        {children}
      </div>
    }
  }
}

module Selection1 = {
  @react.component
  let make = (~children, ~className=?) => {
    let defaultStyle = %twc(
      "bg-gray-50 rounded-lg border-border-default-L1 border-[1px] py-4 mx-5 divide-y-[1px] divide-border-default-L2 children:py-3 first:children:pt-0 last:children:pb-0"
    )
    <div
      className={className->Option.mapWithDefault(defaultStyle, className' =>
        cx([defaultStyle, className'])
      )}>
      {children}
    </div>
  }
}
