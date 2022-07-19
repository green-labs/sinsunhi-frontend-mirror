/*
  1. 컴포넌트 위치
  바이어 센터 전시 매장 > PDP Page > 모달
  
  2. 역할
  {인증}/{단품 선택 여부}/{기능 제공 현황} 등을 고려한 메세지를 모달로 보여줍니다.
*/

type contentType =
  | Unauthorized(string) // 미인증
  | NoOption // 단품을 선택하지 않음
  | Confirm // 컨펌

type visible =
  | Show(contentType)
  | Hide

module Unauthorized = {
  module PC = {
    @react.component
    let make = (~show, ~closeFn) => {
      let {useRouter, push} = module(Next.Router)
      let router = useRouter()

      let (isShow, message) = switch show {
      | Show(Unauthorized(message)) => (ShopDialog_Buyer.Show, message)
      | _ => (ShopDialog_Buyer.Hide, "")
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
          <span className=%twc("text-center")> {message->ReactNl2br.nl2br} </span>
        </div>
      </ShopDialog_Buyer>
    }
  }

  module MO = {
    @react.component
    let make = (~show, ~closeFn) => {
      let {useRouter, push} = module(Next.Router)
      let router = useRouter()

      let (isShow, message) = switch show {
      | Show(Unauthorized(message)) => (ShopDialog_Buyer.Show, message)
      | _ => (ShopDialog_Buyer.Hide, "")
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
          <span className=%twc("text-center")> {message->ReactNl2br.nl2br} </span>
        </div>
      </ShopDialog_Buyer.Mo>
    }
  }
}

module Confirm = {
  module MO = {
    @react.component
    let make = (~show, ~closeFn, ~selectedOptionId, ~quantity, ~setQuantity) => {
      let isShow = switch show {
      | Show(Confirm) => true
      | _ => false
      }

      <DS_BottomDrawer.Root isShow onClose=closeFn>
        <DS_BottomDrawer.Header />
        <DS_BottomDrawer.Body>
          <div className=%twc("px-4 pb-9")>
            {switch selectedOptionId {
            | Some(id) =>
              <React.Suspense fallback={<PDP_Normal_OrderSpecification_Buyer.Placeholder />}>
                <PDP_Normal_OrderSpecification_Buyer selectedSkuId=id quantity setQuantity />
              </React.Suspense>

            | None => React.null
            }}
          </div>
        </DS_BottomDrawer.Body>
      </DS_BottomDrawer.Root>
    }
  }

  module PC = {
    @react.component
    let make = (~show, ~closeFn, ~selectedOptionId, ~quantity, ~setQuantity) => {
      let _open = switch show {
      | Show(Confirm) => true
      | _ => false
      }

      <RadixUI.Dialog.Root _open>
        <RadixUI.Dialog.Portal>
          <RadixUI.Dialog.Overlay className=%twc("dialog-overlay") />
          <RadixUI.Dialog.Content
            className=%twc(
              "dialog-content-base bg-white rounded-xl w-[calc(100vw-40px)] max-w-[calc(768px-40px)]"
            )
            onPointerDownOutside=closeFn>
            <div className=%twc("px-5")>
              <section className=%twc("w-full h-14 flex justify-end items-center")>
                <button onClick=closeFn>
                  <DS_Icon.Common.CloseLarge2 height="24" width="24" />
                </button>
              </section>
              <section className=%twc("mt-4")>
                {switch selectedOptionId {
                | Some(id) =>
                  <React.Suspense fallback={<PDP_Normal_OrderSpecification_Buyer.Placeholder />}>
                    <PDP_Normal_OrderSpecification_Buyer selectedSkuId=id quantity setQuantity />
                  </React.Suspense>

                | None => React.null
                }}
              </section>
            </div>
          </RadixUI.Dialog.Content>
        </RadixUI.Dialog.Portal>
      </RadixUI.Dialog.Root>
    }
  }
}

module NoOption = {
  module PC = {
    @react.component
    let make = (~show, ~closeFn) => {
      let isShow = switch show {
      | Show(NoOption) => ShopDialog_Buyer.Show
      | _ => ShopDialog_Buyer.Hide
      }

      <ShopDialog_Buyer
        isShow
        cancelText=`확인`
        onCancel={_ => {
          closeFn()
        }}>
        <div
          className=%twc(
            "h-18 mt-8 px-8 py-6 flex flex-col items-center justify-center text-lg text-text-L1"
          )>
          <span> {`단품을 선택해 주세요.`->React.string} </span>
        </div>
      </ShopDialog_Buyer>
    }
  }

  module MO = {
    @react.component
    let make = (~show, ~closeFn) => {
      let isShow = switch show {
      | Show(NoOption) => ShopDialog_Buyer.Show
      | _ => ShopDialog_Buyer.Hide
      }

      <ShopDialog_Buyer.Mo
        isShow
        cancelText=`확인`
        onCancel={_ => {
          closeFn()
        }}>
        <div
          className=%twc(
            "h-18 mt-8 px-8 py-6 flex flex-col items-center justify-center text-lg text-text-L1"
          )>
          <span> {`단품을 선택해 주세요.`->React.string} </span>
        </div>
      </ShopDialog_Buyer.Mo>
    }
  }
}

module PC = {
  @react.component
  let make = (~show, ~setShow, ~selectedOptionId, ~quantity, ~setQuantity) => {
    let closeFn = _ => setShow(._ => Hide)

    <>
      <Confirm.PC show selectedOptionId quantity setQuantity closeFn />
      <Unauthorized.PC show closeFn />
      <NoOption.PC show closeFn />
    </>
  }
}

module MO = {
  @react.component
  let make = (~show, ~setShow, ~selectedOptionId, ~quantity, ~setQuantity) => {
    let closeFn = _ => setShow(._ => Hide)
    <>
      <Confirm.MO show selectedOptionId quantity setQuantity closeFn />
      <Unauthorized.MO show closeFn />
      <NoOption.MO show closeFn />
    </>
  }
}
