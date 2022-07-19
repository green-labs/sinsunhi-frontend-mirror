/*
 * 1. 컴포넌트 위치
 *    바이어 상단 Gnb
 *
 * 2. 역할
 *    바이어 페이지의 공통 헤더로써 네비게이션을 제공합니다
 *
 */
@module("../../public/assets/home.svg")
external homeIcon: string = "default"
module Mobile = {
  module LoggedInUserMenu = {
    @react.component
    let make = () => {
      let {useRouter, push} = module(Next.Router)
      let router = useRouter()

      let (open_, setOpen) = React.Uncurried.useState(_ => false)

      let makeOnClick = action => {
        ReactEvents.interceptingHandler(_ => {
          setOpen(._ => false)
          action()
        })
      }

      let logOutAction = () => {
        CustomHooks.Auth.logOut()
        ChannelTalkHelper.logout()
        Redirect.setHref("/")
      }

      let itemStyle = %twc(
        "cursor-pointer w-full h-full py-3 px-4 whitespace-nowrap flex items-center justify-center"
      )

      open RadixUI.DropDown
      <Root _open=open_ onOpenChange={to_ => setOpen(._ => to_)}>
        <Trigger className=%twc("focus:outline-none")>
          <img
            src="/icons/user-gray-circle-3x.png"
            className=%twc("w-7 h-7 object-cover")
            alt="user-icon"
          />
        </Trigger>
        <Content
          align=#start
          sideOffset=12
          className=%twc(
            "dropdown-content w-[145px] bg-white rounded-lg drop-shadow-lg divide-y text-base text-gray-800"
          )>
          <Item className=%twc("focus:outline-none")>
            <div
              className=itemStyle
              onClick={makeOnClick(() => {
                let link = "https://drive.google.com/drive/u/0/folders/1DbaGUxpkYnJMrl4RPKRzpCqTfTUH7bYN"
                router->push(link)
              })}>
              <span> {`판매자료 다운로드`->React.string} </span>
            </div>
          </Item>
          <Item className=%twc("focus:outline-none")>
            <div
              className=itemStyle
              onClick={makeOnClick(() => {
                router->push("/buyer/upload")
              })}>
              <span> {`주문서 업로드`->React.string} </span>
            </div>
          </Item>
          <Item className=%twc("focus:outline-none")>
            <div
              className=itemStyle
              onClick={makeOnClick(() => {
                router->push("/buyer/orders")
              })}>
              <span> {`주문 내역`->React.string} </span>
            </div>
          </Item>
          <Item className=%twc("focus:outline-none")>
            <div
              className=itemStyle
              onClick={makeOnClick(() => {
                router->push("/buyer/transactions")
              })}>
              <span> {`결제 내역`->React.string} </span>
            </div>
          </Item>
          <Item className=%twc("focus:outline-none")>
            <div
              className=itemStyle
              onClick={makeOnClick(() => {
                router->push("/buyer/download-center")
              })}>
              <span> {`다운로드 센터`->React.string} </span>
            </div>
          </Item>
          <Item className=%twc("focus:outline-none")>
            <div
              className=itemStyle
              onClick={makeOnClick(() => {
                router->push("https://shinsunmarket.co.kr/532")
              })}>
              <span> {`고객지원`->React.string} </span>
            </div>
          </Item>
          <Item className=%twc("focus:outline-none")>
            <div
              className=itemStyle
              onClick={makeOnClick(() => {
                router->push("/buyer/products/advanced-search")
              })}>
              <span> {`단품 확인`->React.string} </span>
            </div>
          </Item>
          <Item className=%twc("focus:outline-none")>
            <div className=itemStyle onClick={makeOnClick(logOutAction)}>
              <span> {`로그아웃`->React.string} </span>
            </div>
          </Item>
        </Content>
      </Root>
    }
  }

  module Normal = {
    @react.component
    let make = (~title) => {
      let router = Next.Router.useRouter()

      <>
        // position fixed
        <div className=%twc("w-full fixed top-0 left-0 z-10 bg-white")>
          <header className=%twc("w-full max-w-3xl mx-auto h-14 bg-white")>
            <div className=%twc("px-5 py-4 flex justify-between")>
              <button onClick={_ => router->Next.Router.back}>
                <img src="/assets/arrow-right.svg" className=%twc("w-6 h-6 rotate-180") />
              </button>
              <div>
                <span className=%twc("font-bold text-xl")> {title->React.string} </span>
              </div>
              <button onClick={_ => router->Next.Router.push("/buyer")}>
                <img src=homeIcon />
              </button>
            </div>
          </header>
        </div>
        // placeholder
        <div className=%twc("w-full h-14") />
      </>
    }
  }

  // 뒤로가기 버튼이 없는 해더
  module NoBack = {
    @react.component
    let make = (~title) => {
      let router = Next.Router.useRouter()
      <>
        // position fixed
        <div className=%twc("w-full fixed top-0 left-0 z-10 bg-white")>
          <header className=%twc("w-full max-w-3xl mx-auto h-14 bg-white")>
            <div className=%twc("px-5 py-4 flex justify-between")>
              <div className=%twc("w-[24px]") />
              <div>
                <span className=%twc("font-bold text-xl")> {title->React.string} </span>
              </div>
              <button onClick={_ => router->Next.Router.push("/buyer")}>
                <img src=homeIcon />
              </button>
            </div>
          </header>
        </div>
        // placeholder
        <div className=%twc("w-full h-14") />
      </>
    }
  }

  module GnbHome = {
    @react.component
    let make = () => {
      let router = Next.Router.useRouter()

      let (isCsr, setCsr) = React.Uncurried.useState(_ => false)
      let user = CustomHooks.User.Buyer.use2()

      // category select 내에 query 때문에 ssr 이용시 hydration mismatch error 발생
      // csr 사용
      React.useEffect0(_ => {
        setCsr(._ => true)
        None
      })

      <div className=%twc("w-full bg-white")>
        <header className=%twc("w-full max-w-3xl mx-auto h-14 flex items-center px-3 bg-white")>
          <div className=%twc("flex flex-1")>
            {switch isCsr {
            | true =>
              <RescriptReactErrorBoundary fallback={_ => React.null}>
                <React.Suspense fallback=React.null>
                  <ShopCategorySelect_Buyer.Mobile />
                </React.Suspense>
              </RescriptReactErrorBoundary>
            | false => <IconHamburger width="28" height="28" fill="#12B564" />
            }}
          </div>
          <img
            src="/assets/sinsunhi-logo.svg"
            className=%twc("w-[88px] h-7 object-contain")
            alt="sinsunhi-logo-header-mobile"
          />
          <div className=%twc("flex flex-1 justify-end")>
            {
              let {makeWithDict, toString} = module(Webapi.Url.URLSearchParams)
              let redirectUrl = switch router.query->Js.Dict.get("redirect") {
              | Some(redirect) =>
                [("redirect", redirect)]->Js.Dict.fromArray->makeWithDict->toString
              | None => [("redirect", router.asPath)]->Js.Dict.fromArray->makeWithDict->toString
              }
              switch user {
              | LoggedIn(_) => <LoggedInUserMenu />
              | NotLoggedIn =>
                <Next.Link href={`/buyer/signin?${redirectUrl}`}>
                  <a
                    className=%twc(
                      "px-3 py-[6px] bg-green-50 flex items-center justify-center rounded-full text-[15px] text-green-500"
                    )>
                    {`로그인`->React.string}
                  </a>
                </Next.Link>

              | Unknown => <div className=%twc("w-20 h-6 bg-gray-150 animate-pulse rounded-lg") />
              }
            }
          </div>
        </header>
      </div>
    }
  }

  module Search = {
    @react.component
    let make = () => {
      let router = Next.Router.useRouter()

      <>
        // position fixed
        <div className=%twc("w-full fixed top-0 left-0 z-10 bg-white")>
          <div className=%twc("w-full max-w-3xl mx-auto h-14 py-2 px-3 bg-white flex items-center")>
            <button onClick={_ => router->Next.Router.back} className=%twc("mr-1")>
              <img src="/assets/arrow-right.svg" className=%twc("w-6 h-6 rotate-180") />
            </button>
            <ShopSearchInput_Buyer.MO />
          </div>
        </div>
        // placeholder
        <div className=%twc("w-full h-14") />
      </>
    }
  }

  @react.component
  let make = () => {
    let router = Next.Router.useRouter()

    let secondPathname =
      router.pathname->Js.String2.split("/")->Array.keep(x => x !== "")->Garter.Array.get(1)

    let thirdPathname =
      router.pathname->Js.String2.split("/")->Array.keep(x => x !== "")->Garter.Array.get(2)

    switch (secondPathname, thirdPathname) {
    | (Some("signin"), Some("find-id-password")) => <Normal title={``} />
    | (Some("signin"), _) => <Normal title={`로그인`} />
    | (Some("signup"), _) => <Normal title={`회원가입`} />
    | (Some("upload"), _) => <Normal title={`주문서 업로드`} />
    | (Some("orders"), _) => <Normal title={`주문 내역`} />
    | (Some("download-center"), _) => <Normal title={`다운로드 센터`} />
    | (Some("transactions"), _) => <Normal title={`결제 내역`} />
    | (Some("products"), None) => <PLP_Header_Buyer />
    | (Some("products"), Some("all")) => <Normal title={`전체 상품`} /> // will be removed(2022.08.01)
    | (Some("products"), Some("advanced-search")) => <Normal title={`상품 검색`} />
    | (Some("products"), Some(_)) => <PDP_Header_Buyer />
    | (Some("search"), _) => <Search />
    | (Some("web-order"), Some("complete")) => <NoBack title={`주문 완료`} />
    | (Some("web-order"), _) => <Normal title={`주문·결제`} />
    | (None, _) => <GnbHome />
    | _ => <Normal title={``} />
    }
  }
}

module PC_Old = {
  // warning: this module will be deprecated
  module LoggedInUserMenu = {
    @react.component
    let make = (~user: CustomHooks.Auth.user) => {
      let {useRouter, push} = module(Next.Router)
      let router = useRouter()

      let logOut = ReactEvents.interceptingHandler(_ => {
        CustomHooks.Auth.logOut()
        ChannelTalkHelper.logout()
        Redirect.setHref("/")
      })

      let goTo = url => {
        ReactEvents.interceptingHandler(_ => {
          router->push(url)
        })
      }

      let itemStyle = %twc(
        "cursor-pointer w-full h-full py-3 px-8 whitespace-nowrap flex items-center justify-center"
      )

      open RadixUI.DropDown
      <div id="gnb-user" className=%twc("relative flex items-center h-16")>
        <Root>
          <Trigger className=%twc("focus:outline-none")>
            <div className=%twc("flex items-center")>
              <span className=%twc("text-base text-gray-800")>
                {user.email->Option.getWithDefault("")->React.string}
              </span>
              <span className=%twc("relative ml-1")>
                <IconArrowSelect height="22" width="22" fill="#262626" />
              </span>
            </div>
          </Trigger>
          <Content
            align=#end
            className=%twc(
              "dropdown-content w-[140px] bg-white rounded-lg shadow-md divide-y text-gray-800"
            )>
            <Item className=%twc("focus:outline-none")>
              <div className=itemStyle onClick={goTo("/buyer/orders")}>
                <span> {`주문 내역`->React.string} </span>
              </div>
            </Item>
            <Item className=%twc("focus:outline-none")>
              <div className=itemStyle onClick={goTo("/buyer/transactions")}>
                <span> {`결제 내역`->React.string} </span>
              </div>
            </Item>
            <Item className=%twc("focus:outline-none")>
              <div className=itemStyle onClick={goTo("/buyer/download-center")}>
                <span> {`다운로드 센터`->React.string} </span>
              </div>
            </Item>
            <Item className=%twc("focus:outline-none")>
              <div className=itemStyle onClick={goTo("/buyer/products/advanced-search")}>
                <span> {`단품 확인`->React.string} </span>
              </div>
            </Item>
            <Item className=%twc("focus:outline-none")>
              <div className=itemStyle onClick={logOut}>
                <span> {`로그아웃`->React.string} </span>
              </div>
            </Item>
          </Content>
        </Root>
      </div>
    }
  }

  module NotLoggedInUserMenu = {
    @react.component
    let make = () => {
      let router = Next.Router.useRouter()
      let {makeWithDict, toString} = module(Webapi.Url.URLSearchParams)
      let redirectUrl = switch router.query->Js.Dict.get("redirect") {
      | Some(redirect) => [("redirect", redirect)]->Js.Dict.fromArray->makeWithDict->toString
      | None => [("redirect", router.asPath)]->Js.Dict.fromArray->makeWithDict->toString
      }

      let buttonStyle = %twc(
        "ml-2 py-3 px-4 bg-green-50 flex items-center justify-center rounded-full text-sm text-green-500 cursor-pointer"
      )

      <div className=%twc("flex items-center justify-center")>
        <Next.Link href={`/buyer/signin?${redirectUrl}`}>
          <a className=buttonStyle> {`로그인`->React.string} </a>
        </Next.Link>
        <Next.Link href={`/buyer/signup?${redirectUrl}`}>
          <a className=buttonStyle> {`회원가입`->React.string} </a>
        </Next.Link>
      </div>
    }
  }

  @react.component
  let make = () => {
    let user = CustomHooks.User.Buyer.use2()

    <>
      <header className=%twc("w-full fixed top-0 bg-white z-10")>
        <div className=%twc("w-full flex justify-between items-center py-4 px-10")>
          <div className=%twc("flex items-center")>
            // 로고
            <Next.Link href="/">
              <a>
                <img
                  src="/assets/sinsunhi-logo.svg"
                  className=%twc("w-[120px] h-10 object-contain")
                  alt="sinsunhi-logo-header-pc"
                />
              </a>
            </Next.Link>
            // 검색창
            <div className=%twc("ml-12")>
              <ShopSearchInput_Buyer />
            </div>
          </div>
          <div className=%twc("flex items-center")>
            <span className=%twc("flex")>
              {switch user {
              | LoggedIn(user') => <LoggedInUserMenu user={user'} />
              | NotLoggedIn => <NotLoggedInUserMenu />
              | Unknown => <div className=%twc("w-40 h-6 bg-gray-150 animate-pulse rounded-lg") />
              }}
            </span>
          </div>
        </div>
        <nav className=%twc("flex items-center justify-between pr-10 pl-2 border-y")>
          <div className=%twc("flex items-center divide-x")>
            // 카테고리
            <RescriptReactErrorBoundary fallback={_ => React.null}>
              <React.Suspense fallback=React.null>
                <ShopCategorySelect_Buyer.PC />
              </React.Suspense>
            </RescriptReactErrorBoundary>
            // Gnb Banners
            <RescriptReactErrorBoundary fallback={_ => React.null}>
              <React.Suspense fallback=React.null>
                <GnbBannerList_Buyer />
              </React.Suspense>
            </RescriptReactErrorBoundary>
          </div>
          // 네비게이션
          <div className=%twc("flex items-center text-base text-gray-800")>
            {
              let (link, target) = switch user {
              | LoggedIn(_) => (
                  "https://drive.google.com/drive/u/0/folders/1DbaGUxpkYnJMrl4RPKRzpCqTfTUH7bYN",
                  "_blank",
                )
              | _ => ("/buyer/signin", "_self")
              }
              <Next.Link href=link>
                <a target className=%twc("ml-4 cursor-pointer")>
                  {`판매자료 다운로드`->React.string}
                </a>
              </Next.Link>
            }
            <Next.Link href="/buyer/upload">
              <a className=%twc("ml-4 cursor-pointer")> {`주문서 업로드`->React.string} </a>
            </Next.Link>
            <Next.Link href="https://shinsunmarket.co.kr/532">
              <a target="_blank" className=%twc("ml-4 cursor-pointer")>
                {`고객지원`->React.string}
              </a>
            </Next.Link>
          </div>
        </nav>
      </header>
      <div className=%twc("w-full h-[154px]") />
    </>
  }
}

module PC = {
  module LoggedInUserMenu = {
    @react.component
    let make = (~user: CustomHooks.Auth.user) => {
      let {useRouter, push} = module(Next.Router)
      let router = useRouter()

      let logOut = ReactEvents.interceptingHandler(_ => {
        CustomHooks.Auth.logOut()
        ChannelTalkHelper.logout()
        Redirect.setHref("/")
      })

      let goTo = url => {
        ReactEvents.interceptingHandler(_ => {
          router->push(url)
        })
      }

      let itemStyle = %twc(
        "cursor-pointer w-full h-full py-3 px-8 whitespace-nowrap flex items-center justify-center"
      )

      open RadixUI.DropDown
      <div id="gnb-user" className=%twc("relative flex items-center h-16")>
        <Root>
          <Trigger className=%twc("focus:outline-none")>
            <div className=%twc("flex items-center")>
              <span className=%twc("text-base text-gray-800")>
                {user.email->Option.getWithDefault("")->React.string}
              </span>
              <span className=%twc("relative ml-1")>
                <IconArrowSelect height="22" width="22" fill="#262626" />
              </span>
            </div>
          </Trigger>
          <Content
            align=#end
            className=%twc(
              "dropdown-content w-[140px] bg-white rounded-lg shadow-md divide-y text-gray-800"
            )>
            <Item className=%twc("focus:outline-none")>
              <div className=itemStyle onClick={goTo("/buyer/orders")}>
                <span> {`주문 내역`->React.string} </span>
              </div>
            </Item>
            <Item className=%twc("focus:outline-none")>
              <div className=itemStyle onClick={goTo("/buyer/transactions")}>
                <span> {`결제 내역`->React.string} </span>
              </div>
            </Item>
            <Item className=%twc("focus:outline-none")>
              <div className=itemStyle onClick={goTo("/buyer/download-center")}>
                <span> {`다운로드 센터`->React.string} </span>
              </div>
            </Item>
            <Item className=%twc("focus:outline-none")>
              <div className=itemStyle onClick={goTo("/buyer/products/advanced-search")}>
                <span> {`단품 확인`->React.string} </span>
              </div>
            </Item>
            <Item className=%twc("focus:outline-none")>
              <div className=itemStyle onClick={logOut}>
                <span> {`로그아웃`->React.string} </span>
              </div>
            </Item>
          </Content>
        </Root>
      </div>
    }
  }

  module NotLoggedInUserMenu = {
    @react.component
    let make = () => {
      let router = Next.Router.useRouter()
      let {makeWithDict, toString} = module(Webapi.Url.URLSearchParams)
      let redirectUrl = switch router.query->Js.Dict.get("redirect") {
      | Some(redirect) => [("redirect", redirect)]->Js.Dict.fromArray->makeWithDict->toString
      | None => [("redirect", router.asPath)]->Js.Dict.fromArray->makeWithDict->toString
      }

      let buttonStyle = %twc(
        "ml-2 py-3 px-4 bg-green-50 flex items-center justify-center rounded-full text-sm text-green-500 cursor-pointer"
      )

      <div className=%twc("flex items-center justify-center")>
        <Next.Link href={`/buyer/signin?${redirectUrl}`}>
          <a className=buttonStyle> {`로그인`->React.string} </a>
        </Next.Link>
        <Next.Link href={`/buyer/signup?${redirectUrl}`}>
          <a className=buttonStyle> {`회원가입`->React.string} </a>
        </Next.Link>
      </div>
    }
  }

  @react.component
  let make = () => {
    let user = CustomHooks.User.Buyer.use2()

    <header className=%twc("w-full sticky top-0 bg-white z-10")>
      <div className=%twc("w-full flex justify-between items-center py-4 px-10")>
        <div className=%twc("flex items-center")>
          // 로고
          <Next.Link href="/">
            <a>
              <img
                src="/assets/sinsunhi-logo.svg"
                className=%twc("w-[120px] h-10 object-contain")
                alt="sinsunhi-logo-header-pc"
              />
            </a>
          </Next.Link>
          // 검색창
          <div className=%twc("ml-12")>
            <ShopSearchInput_Buyer />
          </div>
        </div>
        <div className=%twc("flex items-center")>
          <span className=%twc("flex")>
            {switch user {
            | LoggedIn(user') => <LoggedInUserMenu user={user'} />
            | NotLoggedIn => <NotLoggedInUserMenu />
            | Unknown => <div className=%twc("w-40 h-6 bg-gray-150 animate-pulse rounded-lg") />
            }}
          </span>
        </div>
      </div>
      <nav className=%twc("flex items-center justify-between pr-10 pl-2 border-y")>
        <div className=%twc("flex items-center divide-x")>
          // 카테고리
          <RescriptReactErrorBoundary fallback={_ => React.null}>
            <React.Suspense fallback=React.null>
              <ShopCategorySelect_Buyer.PC />
            </React.Suspense>
          </RescriptReactErrorBoundary>
          // Gnb Banners
          <RescriptReactErrorBoundary fallback={_ => React.null}>
            <React.Suspense fallback=React.null>
              <GnbBannerList_Buyer />
            </React.Suspense>
          </RescriptReactErrorBoundary>
        </div>
        // 네비게이션
        <div className=%twc("flex items-center text-base text-gray-800")>
          {
            let (link, target) = switch user {
            | LoggedIn(_) => (
                "https://drive.google.com/drive/u/0/folders/1DbaGUxpkYnJMrl4RPKRzpCqTfTUH7bYN",
                "_blank",
              )
            | _ => ("/buyer/signin", "_self")
            }
            <Next.Link href=link>
              <a target className=%twc("ml-4 cursor-pointer")>
                {`판매자료 다운로드`->React.string}
              </a>
            </Next.Link>
          }
          <Next.Link href="/buyer/upload">
            <a className=%twc("ml-4 cursor-pointer")> {`주문서 업로드`->React.string} </a>
          </Next.Link>
          <Next.Link href="https://shinsunmarket.co.kr/532">
            <a target="_blank" className=%twc("ml-4 cursor-pointer")>
              {`고객지원`->React.string}
            </a>
          </Next.Link>
        </div>
      </nav>
    </header>
  }
}
