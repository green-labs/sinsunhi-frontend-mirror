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

      let onConfirm = ReactEvents.interceptingHandler(_ => {
        let {makeWithDict, toString} = module(Webapi.Url.URLSearchParams)
        let redirectUrl = [("redirect", router.asPath)]->Js.Dict.fromArray->makeWithDict->toString
        router->push(`/buyer/signin?${redirectUrl}`)
      })

      let onCancel = ReactEvents.interceptingHandler(_ => {
        closeFn()
      })

      <ShopDialog_Buyer isShow=show onCancel onConfirm cancelText=`취소` confirmText=`로그인`>
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

      let onConfirm = ReactEvents.interceptingHandler(_ => {
        let {makeWithDict, toString} = module(Webapi.Url.URLSearchParams)
        let redirectUrl = [("redirect", router.asPath)]->Js.Dict.fromArray->makeWithDict->toString
        router->push(`/buyer/signin?${redirectUrl}`)
      })

      let onCancel = ReactEvents.interceptingHandler(_ => {
        closeFn()
      })

      <ShopDialog_Buyer.Mo
        isShow=show onCancel onConfirm cancelText=`취소` confirmText=`로그인`>
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
    <>
      <Unauthorized.PC
        show={show == Show(Unauthorized) ? ShopDialog_Buyer.Show : ShopDialog_Buyer.Hide}
        closeFn={_ => setShow(._ => Hide)}
      />
    </>
  }
}

module MO = {
  @react.component
  let make = (~show, ~setShow) => {
    <>
      <Unauthorized.MO
        show={show == Show(Unauthorized) ? ShopDialog_Buyer.Show : ShopDialog_Buyer.Hide}
        closeFn={_ => setShow(._ => Hide)}
      />
    </>
  }
}
