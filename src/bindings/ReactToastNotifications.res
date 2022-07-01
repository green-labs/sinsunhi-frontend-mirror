module Custom = {
  module Styles = {
    open CssJs

    let container = style(. [
      position(#fixed),
      top(px(20)),
      left(pct(50.0)),
      transform(translateX(pct(-50.0))),
      zIndex(1000),
      width(pct(100.0)),
      maxWidth(px(728)),
      maxHeight(pct(100.0)),
      paddingRight(px(16)),
      paddingLeft(px(16)),
      overflow(#hidden),
    ])

    let toast = (transitionDuration, transitionState) =>
      style(. [
        display(#flex),
        alignItems(#center),
        width(pct(100.0)),
        height(px(50)),
        paddingRight(px(16)),
        paddingLeft(px(16)),
        borderRadius(px(10)),
        backgroundColor(hsla(deg(0.0), pct(0.0), pct(0.0), #num(0.8))),
        transition("all", ~duration=transitionDuration, ~timingFunction=#easeInOut),
        opacity(
          switch transitionState {
          | "entered" => 1.0
          | _ => 0.0
          },
        ),
        marginBottom(rem(0.5)),
      ])

    let p = style(. [
      fontSize(px(15)),
      color(white),
      overflow(#hidden),
      textOverflow(#ellipsis),
      whiteSpace(#nowrap),
    ])
  }

  module ToastContainer = {
    @react.component
    let make = (~children) => {
      <div className=Styles.container> {children} </div>
    }
  }

  module Toast = {
    @react.component
    let make = (~children, ~transitionDuration, ~transitionState) => {
      <div className={Styles.toast(transitionDuration, transitionState)}>
        <p className=Styles.p> {children} </p>
      </div>
    }
  }
}

module ToastProvider = {
  type componentProps = {
    // autoDismiss,
    // autoDismissTimeout,
    // isRunning,
    // onMouseEnter,
    // onMouseLeave,
    // appearance,
    // onDismiss,
    // placement,
    transitionDuration: int,
    transitionState: string,
    children: React.element,
  }

  type components = {
    "ToastContainer": componentProps => React.element,
    "Toast": componentProps => React.element,
  }

  module Component = {
    @module("react-toast-notifications") @react.component
    external make: (
      ~autoDismissTimeout: int,
      ~autoDismiss: bool,
      ~components: components,
      ~placement: string=?,
      ~portalTargetSelector: option<string>,
      ~transitionDuration: option<int>,
      ~children: React.element,
    ) => React.element = "ToastProvider"
  }

  @react.component
  let make = (
    // ~autoDismissTimeout=?,
    // ~autoDismiss=?,
    // ~components=?,
    ~placement=?,
    ~portalTargetSelector=?,
    ~transitionDuration=?,
    ~children,
  ) => {
    <Component
      autoDismissTimeout=2000
      autoDismiss=true
      components={{
        "ToastContainer": ({children}) =>
          <Custom.ToastContainer> {children} </Custom.ToastContainer>,
        "Toast": ({children, transitionDuration, transitionState}) =>
          <Custom.Toast transitionDuration transitionState> {children} </Custom.Toast>,
      }}
      placement={switch placement {
      | Some(p) => p
      | None => "top-center"
      }}
      portalTargetSelector
      transitionDuration>
      {children}
    </Component>
  }
}

type addToast = {appearance: string}

type hook = {
  addToast: (. React.element, addToast) => unit,
  // removeToast: removeToastT,
  // removeAllToasts: removeAllToastsT,
  // updateToast: updateToastT,
  // toastStack: toastStackT,
}

@module("react-toast-notifications")
external useToasts: unit => hook = "useToasts"
