module Custom: {
  module ToastContainer: {
    @react.component
    let make: (~children: React.element) => React.element
  }

  module Toast: {
    @react.component
    let make: (
      ~children: React.element,
      ~transitionDuration: int,
      ~transitionState: string,
    ) => React.element
  }
}

module ToastProvider: {
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

  module Component: {
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
  let make: (
    // ~autoDismissTimeout=?,
    // ~autoDismiss=?,
    // ~components=?,
    ~placement: string=?,
    ~portalTargetSelector: string=?,
    ~transitionDuration: int=?,
    ~children: React.element,
  ) => React.element
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
