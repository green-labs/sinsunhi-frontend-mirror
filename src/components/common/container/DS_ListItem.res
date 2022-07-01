module Normal1 = {
  module Root = {
    @react.component
    let make = (~children, ~className=?) => {
      let defaultStyle = %twc("px-5 flex flex-col tab-highlight-color")
      <ul
        className={className->Option.mapWithDefault(defaultStyle, className' =>
          cx([defaultStyle, className'])
        )}>
        {children}
      </ul>
    }
  }
  module Item = {
    @react.component
    let make = (~children, ~className=?, ~onClick=?) => {
      let defaultStyle = switch onClick {
      | Some(_) => %twc("flex justify-between items-center cursor-pointer appearance-none")
      | None => %twc("flex justify-between items-center")
      }
      <li
        ?onClick
        className={className->Option.mapWithDefault(defaultStyle, className' =>
          cx([defaultStyle, className'])
        )}>
        {children}
      </li>
    }
  }
  module TextGroup = {
    @react.component
    let make = (~title1, ~title2=?, ~titleStyle=%twc(""), ~subTitle=?, ~subTitleStyle=?) => {
      <DS_TitleList.Left.TitleSubtitle1 title1 ?title2 titleStyle ?subTitle ?subTitleStyle />
    }
  }
  module RightGroup = {
    @react.component
    let make = (~children) => {
      <div className=%twc("flex justify-end items-center")> {children} </div>
    }
  }
}

module Information1 = {
  @react.component
  let make = (~children, ~title, ~content) => {
    <div className=%twc("px-5 flex flex-col justify-start items-start space-y-3")>
      <div className=%twc("flex justify-between items-center space-x-2")>
        {children}
        <span className=%twc("font-bold leading-7 tracking-tight text-enabled-L1")>
          {title->React.string}
        </span>
      </div>
      {content}
    </div>
  }
  module Left = {
    @react.component
    let make = (~children) => {
      <div className=%twc("flex items-center")> {children} </div>
    }
  }
}
