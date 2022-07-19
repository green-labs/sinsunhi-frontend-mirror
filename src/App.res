// This type is based on the getInitialProps return value.
// If you are using getServerSideProps or getStaticProps, you probably
// will never need this
// See https://nextjs.org/docs/advanced-features/custom-app
type pageProps

module PageComponent = {
  type t = React.component<pageProps>
}

type props = {
  @as("Component")
  component: PageComponent.t,
  pageProps: pageProps,
}

@set external setNextRouterPush: (Global.window, string => unit) => unit = "nextRouterPush"

// We are not using `@react.component` since we will never
// use <App/> within our ReScript code.
// It's only used within `pages/_app.js`
let default = (props: props): React.element => {
  let {component, pageProps} = props

  let router = Next.Router.useRouter()
  let firstPathname = router.pathname->Js.String2.split("/")->Array.getBy(x => x !== "")
  let secondPathname =
    router.pathname->Js.String2.split("/")->Array.keep(x => x !== "")->Garter.Array.get(1)

  let content = React.createElement(component, pageProps)

  // IE로 접근 한 경우 /no-ie 로 리디렉션 시킨다.
  CustomHooks.NoIE.use(router)

  // CRM을 위한 유저 정보를 전역 객체로 추가한다.
  // window.user = { ... }
  CustomHooks.CRMUser.use()

  // 채널톡 Init
  // 아이콘 기본 invisible,
  // 각 페이지에서 ChannelTalk.use()를 통해 노출시킬 수 있다.
  ChannelTalkHelper.Hook.useBoot()

  // braze Init
  let braze = Braze.use()
  let user = CustomHooks.Auth.use()

  React.useEffect3(_ => {
    switch (Global.Window.ReactNativeWebView.tOpt, braze, user) {
    | (None, Some(braze'), LoggedIn(user')) =>
      // 참고 사항
      // 유저가 동록되어 있는 상태에서 푸시 허가를 물어봐야한다.
      // 그렇지 않으면 허락한 시점의 유저를 braze가 찾지 못해 푸시 메세지를 보내지 못한다.
      Braze.changeUser(user', braze')
      braze'.requestPushPermission(.)
    | _ => ()
    }

    None
  }, (braze, user, router.asPath))

  let router = Next.Router.useRouter()

  // window 전역에 Next.js의 라우터를 심어서 모바일앱에서 활용한다.
  React.useEffect1(_ => {
    switch Global.window {
    | Some(window') => window'->setNextRouterPush(url => router->Next.Router.push(url))
    | _ => ()
    }

    None
  }, [router])

  <Sentry.ErrorBoundary fallback={<ErrorPage />}>
    <RescriptRelay.Context.Provider environment=RelayEnv.envSinsunMarket>
      <ReactToastNotifications.ToastProvider>
        {switch (firstPathname, secondPathname) {
        | (Some("browser-guide"), _)
        | (Some("privacy"), _)
        | (Some("terms"), _)
        | (Some("seller"), Some("signin"))
        | (Some("seller"), Some("signup"))
        | (Some("seller"), Some("reset-password"))
        | (Some("seller"), Some("rfq")) => content
        | (Some("seller"), _) => <Layout_Seller> content </Layout_Seller>
        | (Some("buyer"), Some("rfq"))
        | (Some("buyer"), Some("tradematch")) =>
          <Layout_Estimation_Services_Buyer> content </Layout_Estimation_Services_Buyer>
        | (Some("buyer"), None)
        | (Some("buyer"), Some("search")) => content
        | (Some("buyer"), _) => <Layout_Buyer> content </Layout_Buyer>
        | (Some("admin"), Some("signin")) => content
        | (Some("admin"), _) => <Layout_Admin> content </Layout_Admin>
        | _ => content
        }}
        <BuyerInformation_Buyer />
        <Maintenance />
      </ReactToastNotifications.ToastProvider>
    </RescriptRelay.Context.Provider>
  </Sentry.ErrorBoundary>
}
