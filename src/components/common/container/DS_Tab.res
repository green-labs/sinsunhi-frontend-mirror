module LeftTab = {
  module Root = {
    @react.component
    let make = (~children, ~className=?) => {
      let defaultStyle = %twc(
        "DS_tab_leftTab flex flex-row items-center gap-5 whitespace-nowrap overflow-x-auto h-11 px-5 text-lg text-gray-300 tab-highlight-color bg-white"
      )
      <div
        className={className->Option.mapWithDefault(defaultStyle, className' =>
          cx([defaultStyle, className'])
        )}>
        {children}
      </div>
    }
  }
  module Item = {
    @react.component
    let make = (~children, ~className=?) => {
      let defaultStyle = %twc("")
      <div
        className={className->Option.mapWithDefault(defaultStyle, className' =>
          cx([defaultStyle, className'])
        )}>
        {children}
      </div>
    }
  }
}
