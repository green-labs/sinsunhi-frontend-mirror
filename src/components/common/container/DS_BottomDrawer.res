let toStyle = (isShow, show, hide, style) => {
  cx([isShow ? show : hide, style])
}

let useLockBodyScroll = isLock => {
  open Webapi
  let bodyElement = Dom.document->Dom.Document.querySelector("body")

  React.useEffect1(_ => {
    switch (isLock, bodyElement) {
    | (true, Some(el)) => {
        el->Dom.Element.setClassName("overflow-hidden")
        Some(() => el->Dom.Element.setClassName(""))
      }
    | (false, Some(el)) => {
        el->Dom.Element.setClassName("")
        None
      }
    | _ => None
    }
  }, [isLock])
}

module BottomDrawerContext = {
  let context = React.createContext(() => ())

  module Provider = {
    let provider = React.Context.provider(context)

    @react.component
    let make = (~value, ~children) => {
      React.createElement(provider, {"value": value, "children": children})
    }
  }
}

module Overlay = {
  @react.component
  let make = (~isShow) => {
    let overlayStyle = isShow->toStyle(%twc("opacity-100"), %twc("opacity-0 pointer-events-none"))
    let handleClose = React.useContext(BottomDrawerContext.context)
    <div
      className={%twc(
        "fixed top-0 left-0 w-full h-full bg-dim transition-opacity z-[12]"
      )->overlayStyle}
      onClick={_ => handleClose()}
    />
  }
}

module Header = {
  @react.component
  let make = (~children=?) => {
    let handleClose = React.useContext(BottomDrawerContext.context)

    <header className=%twc("flex justify-between items-center")>
      <div className=%twc("m-4")> {children->Option.getWithDefault(React.null)} </div>
      <span onClick={_ => handleClose()} className=%twc("cursor-pointer p-4")>
        <DS_Icon.Common.CloseLarge2 height="24" width="24" />
      </span>
    </header>
  }
}

module Body = {
  @react.component
  let make = (~children) => {
    <div className=%twc("flex flex-col overflow-hidden")> children </div>
  }
}

module Root = {
  @react.component
  let make = (~isShow, ~onClose, ~children, ~full=false) => {
    useLockBodyScroll(isShow)
    let showStyle = isShow->toStyle(%twc("bottom-0"), %twc("-bottom-full"))

    <BottomDrawerContext.Provider value={onClose}>
      <Overlay isShow={isShow} />
      <div
        ariaHidden={!isShow}
        className={cx([
          full ? "h-full" : "max-h-[85vh]",
          %twc(
            "flex flex-col fixed w-full z-[13] left-1/2 -translate-x-1/2 max-w-3xl mx-auto bg-white rounded-t-2xl drawer-tarnsition"
          ),
        ])->showStyle}>
        children
      </div>
    </BottomDrawerContext.Provider>
  }
}
