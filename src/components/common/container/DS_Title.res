module Normal1 = {
  module Root = {
    @react.component
    let make = (~children, ~className=?) => {
      let defaultStyle = %twc("flex justify-between items-center px-5")
      <div
        className={className->Option.mapWithDefault(defaultStyle, className' =>
          cx([defaultStyle, className'])
        )}>
        {children}
      </div>
    }
  }
  module TextGroup = {
    @react.component
    let make = (~title1, ~title2=?, ~badge=?, ~titleStyle=?, ~subTitle=?, ~subTitleStyle=?) => {
      <div className=%twc("flex flex-col items-start space-y-3")>
        {badge->Option.mapWithDefault(React.null, b => <DS_Badge.Medium text={b} />)}
        <DS_TitleList.Left.TitleSubtitle1 title1 ?title2 ?titleStyle ?subTitle ?subTitleStyle />
      </div>
    }
  }
  module RightGroup = {
    @react.component
    let make = (~children) => {
      <div className=%twc("ml-2")> {children} </div>
    }
  }
}
