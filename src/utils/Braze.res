type rec braze = {
  initialize: (. string, config) => unit,
  requestPushPermission: (. unit) => unit,
  openSession: (. unit) => unit,
  changeUser: (. string) => unit,
  isPushPermissionGranted: unit => bool,
  automaticallyShowInAppMessages: (. unit) => unit,
  getUser: unit => user,
  wipeData: (. unit) => unit,
}
and config = {
  baseUrl: string,
  enableLogging: bool,
  manageServiceWorkerExternally: bool,
  safariWebsitePushId: string,
}
and user = {getUserId: (. Js.Nullable.t<string> => unit) => unit}

let use = () => {
  let (braze, setBraze) = React.Uncurried.useState(_ => None)

  React.useEffect0(_ => {
    switch Global.Window.ReactNativeWebView.tOpt {
    | Some(_) => ()
    | None =>
      (Global.import_("@braze/web-sdk")
      |> Js.Promise.then_((sdk: Js.Nullable.t<braze>) => {
        setBraze(. _ => sdk->Js.Nullable.toOption)
        Js.Promise.resolve()
      })
      |> Js.Promise.catch(err => {
        Js.log2("braze init error: ", err)
        Js.Promise.resolve()
      }))->ignore
    }

    None
  })

  React.useEffect1(_ => {
    switch Global.Window.ReactNativeWebView.tOpt {
    | Some(_) => ()
    | None =>
      let _ =
        Global.Window.serviceWorkerRegister("/service-worker.js")
        |> Js.Promise.then_(_ => {
          switch braze {
          // (주의) 서비스워커가 등록된 다음에 세션을 오픈해야함
          | Some(braze') => braze'.openSession(.)
          | None => ()
          }
          Js.Promise.resolve()
        })
        |> Js.Promise.catch(err => {
          Js.log2("Failed to register service worker : ", err)
          Js.Promise.resolve()
        })

      switch braze {
      | Some(braze') =>
        braze'.initialize(.
          Env.brazeWebApiKey,
          {
            baseUrl: "sdk.iad-06.braze.com",
            enableLogging: false, // 로그를 확인하려면 true로 바꿔서 사용 (배포전에는 반드시 false)
            manageServiceWorkerExternally: true,
            safariWebsitePushId: "web.com.sinsunhi.app",
          },
        )
      | None => ()
      }
    }

    None
  }, [braze])

  braze
}

let changeUser = (user: CustomHooks.Auth.user, braze) => {
  switch user.role {
  | Seller
  | Buyer =>
    braze.changeUser(. user.id->Int.toString)
  | Admin => ()
  }
}
