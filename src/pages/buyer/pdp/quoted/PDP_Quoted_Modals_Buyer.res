/*
  1. 컴포넌트 위치
  바이어 센터 전시 매장 > PDP Page > 모달
  
  2. 역할
  {인증}/{기능 제공 현황} 등을 고려한 메세지를 모달로 보여줍니다.
*/

type contentType = Unauthorized // 미인증 안내

type visible =
  | Show(contentType)
  | Hide

module Unauthorized = {
  module PC = {
    @react.component
    let make = (~show, ~closeFn) => {
      let {useRouter, push} = module(Next.Router)
      let router = useRouter()

      let isShow = switch show {
      | Show(Unauthorized) => ShopDialog_Buyer.Show
      | _ => ShopDialog_Buyer.Hide
      }

      <ShopDialog_Buyer
        isShow
        cancelText=`취소`
        onCancel={_ => {
          closeFn()
        }}
        confirmText=`로그인`
        onConfirm={_ => {
          let {makeWithDict, toString} = module(Webapi.Url.URLSearchParams)
          let redirectUrl = switch router.query->Js.Dict.get("redirect") {
          | Some(redirect) => [("redirect", redirect)]->Js.Dict.fromArray->makeWithDict->toString
          | None => [("redirect", router.asPath)]->Js.Dict.fromArray->makeWithDict->toString
          }
          router->push(`/buyer/signin?${redirectUrl}`)
        }}>
        <div
          className=%twc(
            "h-18 mt-8 px-8 py-6 flex flex-col items-center justify-center text-lg text-text-L1"
          )>
          <span> {`로그인 후에`->React.string} </span>
          <span> {`견적을 받으실 수 있습니다.`->React.string} </span>
        </div>
      </ShopDialog_Buyer>
    }
  }

  module MO = {
    @react.component
    let make = (~show, ~closeFn) => {
      let {useRouter, push} = module(Next.Router)
      let router = useRouter()

      let isShow = switch show {
      | Show(Unauthorized) => ShopDialog_Buyer.Show
      | _ => ShopDialog_Buyer.Hide
      }

      <ShopDialog_Buyer.Mo
        isShow
        cancelText=`취소`
        onCancel={_ => {
          closeFn()
        }}
        confirmText=`로그인`
        onConfirm={_ => {
          let {makeWithDict, toString} = module(Webapi.Url.URLSearchParams)
          let redirectUrl = switch router.query->Js.Dict.get("redirect") {
          | Some(redirect) => [("redirect", redirect)]->Js.Dict.fromArray->makeWithDict->toString
          | None => [("redirect", router.asPath)]->Js.Dict.fromArray->makeWithDict->toString
          }
          router->push(`/buyer/signin?${redirectUrl}`)
        }}>
        <div
          className=%twc(
            "h-18 mt-8 px-8 py-6 flex flex-col items-center justify-center text-lg text-text-L1"
          )>
          <span> {`로그인 후에`->React.string} </span>
          <span> {`견적을 받으실 수 있습니다.`->React.string} </span>
        </div>
      </ShopDialog_Buyer.Mo>
    }
  }
}

module PC = {
  @react.component
  let make = (~show, ~setShow) => {
    let closeFn = _ => setShow(._ => Hide)
    <> <Unauthorized.PC show closeFn /> </>
  }
}

module MO = {
  @react.component
  let make = (~show, ~setShow) => {
    let closeFn = _ => setShow(._ => Hide)
    <> <Unauthorized.MO show closeFn /> </>
  }
}
