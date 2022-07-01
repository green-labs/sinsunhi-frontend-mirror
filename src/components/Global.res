type window
let window: option<window> = %external(window)

module Window = {
  type windowName = string
  type windowFeatures = string
  @send
  external openLink: (
    window,
    ~url: string,
    ~windowName: windowName=?,
    ~windowFeatures: windowFeatures,
    unit,
  ) => unit = "open"

  module ReactNativeWebView = {
    type t
    @val @scope("window") @return(nullable)
    external tOpt: option<t> = "ReactNativeWebView"

    @send
    external postMessage: (t, string) => unit = "postMessage"

    module PostMessage = {
      let storeBrazeUserId = userId => {
        switch tOpt {
        | Some(webView) => {
            let dict = Js.Dict.empty()
            dict->Js.Dict.set("type", "STORE_BRAZE_USER_ID"->Js.Json.string)
            dict->Js.Dict.set("userId", userId->Js.Json.string)

            webView->postMessage(dict->Js.Json.object_->Js.Json.stringify)
          }
        | None => ()
        }
      }
    }
  }
}
