module Left = {
  module Title2Subtitle1 = {
    @react.component
    let make = (~title1, ~title2, ~titleStyle=?, ~subTitle=?, ~subTitleStyle=?) => {
      <div>
        <div
          className={titleStyle->Option.mapWithDefault(
            %twc("flex justify-start items-center space-x-2 leading-7 font-bold"),
            style => Cn.make([style, %twc("flex justify-start items-center space-x-2 leading-7")]),
          )}>
          <span> {title1->React.string} </span>
          <div className=%twc("border-r-[2px] border-gray-400 h-4") />
          <span> {title2->React.string} </span>
        </div>
        {subTitle->Option.mapWithDefault(React.null, subTitle' =>
          <p
            className={subTitleStyle->Option.mapWithDefault(
              %twc("mt-3 text-gray-500 text-sm leading-4 whitespace-pre-line"),
              style => Cn.make([style, %twc("mt-3")]),
            )}>
            {subTitle'->React.string}
          </p>
        )}
      </div>
    }
  }
  module Title3Subtitle1 = {
    @react.component
    let make = (~title1, ~title2=?, ~title3=?, ~titleStyle=?, ~subTitle=?, ~subTitleStyle=?) => {
      <div>
        <div
          className={titleStyle->Option.mapWithDefault(
            %twc("flex justify-start items-center space-x-2 leading-7 font-bold"),
            style => Cn.make([style, %twc("flex justify-start items-center space-x-2 leading-7")]),
          )}>
          <span> {title1->React.string} </span>
          {title2->Option.mapWithDefault(React.null, title2' => {
            <>
              <div className=%twc("border-r-[2px] border-gray-400 h-4") />
              <span> {title2'->React.string} </span>
            </>
          })}
          {title3->Option.mapWithDefault(React.null, title3' => {
            <>
              <div className=%twc("border-r-[2px] border-gray-400 h-4") />
              <span> {title3'->React.string} </span>
            </>
          })}
        </div>
        {subTitle->Option.mapWithDefault(React.null, subTitle' =>
          <p
            className={subTitleStyle->Option.mapWithDefault(
              %twc("mt-3 text-gray-500 text-sm leading-4 whitespace-pre-line"),
              style => Cn.make([style, %twc("mt-3")]),
            )}>
            {subTitle'->React.string}
          </p>
        )}
      </div>
    }
  }

  module TitleSubtitle1 = {
    @react.component
    let make = (~title1, ~title2=?, ~titleStyle=?, ~subTitle=?, ~subTitleStyle=?) => {
      <div>
        <div
          className={titleStyle->Option.mapWithDefault(
            %twc(
              "flex flex-col justify-start items-start text-xl font-bold text-text-L1 leading-8 tracking-tight"
            ),
            style =>
              Cn.make([style, %twc("flex flex-col justify-start items-start tracking-tight")]),
          )}>
          <span className=%twc("truncate")> {title1->React.string} </span>
          {title2->Option.mapWithDefault(React.null, x => <span> {x->React.string} </span>)}
        </div>
        {subTitle->Option.mapWithDefault(React.null, x =>
          <p
            className={subTitleStyle->Option.mapWithDefault(
              %twc("mt-1 text-text-L2 text-sm leading-5 tracking-tight whitespace-pre-line"),
              style => Cn.make([style, %twc("mt-1 tracking-tight")]),
            )}>
            {x->React.string}
          </p>
        )}
      </div>
    }
  }
}

module Common = {
  module IconText1 = {
    module Root = {
      @react.component
      let make = (~children, ~className=?) => {
        let defaultStyle = %twc("flex justify-center items-center space-x-1 cursor-pointer")
        <div
          className={className->Option.mapWithDefault(defaultStyle, className' =>
            cx([defaultStyle, className'])
          )}>
          {children}
        </div>
      }
    }

    module Icon = {
      @react.component
      let make = (~children) => {
        <div className=%twc("flex justify-start items-center")> {children} </div>
      }
    }

    module Text = {
      @react.component
      let make = (~children, ~className=?) => {
        let defaultStyle = %twc("truncate")
        <span
          className={className->Option.mapWithDefault(defaultStyle, className' =>
            cx([defaultStyle, className'])
          )}>
          {children}
        </span>
      }
    }
  }

  module TextIcon1 = {
    module Root = {
      @react.component
      let make = (~children, ~className=?, ~onClick=?) => {
        let defaultStyle = %twc("flex justify-start items-center space-x-1 cursor-pointer")
        <div
          ?onClick
          className={className->Option.mapWithDefault(defaultStyle, className' =>
            cx([defaultStyle, className'])
          )}>
          {children}
        </div>
      }
    }

    module Icon = {
      @react.component
      let make = (~children) => {
        <div className=%twc("flex justify-start items-center")> {children} </div>
      }
    }

    module Text = {
      @react.component
      let make = (~children, ~className=?) => {
        let defaultStyle = %twc("pl-2")
        <span
          className={className->Option.mapWithDefault(defaultStyle, className' =>
            cx([defaultStyle, className'])
          )}>
          {children}
        </span>
      }
    }

    @react.component
    let make = (~children, ~label, ~onClick=?, ~fontStyle=%twc("")) => {
      <div className=%twc("flex justify-start items-center space-x-1 cursor-pointer") ?onClick>
        <span className={Cn.make([fontStyle, %twc("truncate")])}> {label->React.string} </span>
        {children}
      </div>
    }
  }
}
