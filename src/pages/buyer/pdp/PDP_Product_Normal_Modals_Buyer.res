/*
  1. 컴포넌트 위치
  바이어 센터 전시 매장 > PDP Page > 모달
  
  2. 역할
  {인증}/{단품 선택 여부}/{기능 제공 현황} 등을 고려한 메세지를 모달로 보여줍니다.
*/

type contentType =
  | Unauthorized // 미인증 안내
  | Confirm // 위탁배송주문/구매하기 통합형 커펌
  | Soon // 주문서 기능 준비중
  | NoOption // 단품을 선택하지 않음

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
          <span> {`구매하실 수 있습니다.`->React.string} </span>
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
          <span> {`구매하실 수 있습니다.`->React.string} </span>
        </div>
      </ShopDialog_Buyer.Mo>
    }
  }
}

module Confirm = {
  module MO = {
    @react.component
    let make = (
      ~show,
      ~closeFn,
      ~selected: option<PDP_SelectOption_Buyer.selectedSku>,
      ~quantity,
      ~setQuantity,
    ) => {
      <DS_BottomDrawer.Root isShow=show onClose=closeFn>
        <DS_BottomDrawer.Header />
        <DS_BottomDrawer.Body>
          <div className=%twc("px-4 pb-9")>
            {switch selected {
            | Some({id}) =>
              <React.Suspense
                fallback={<PDP_Product_Normal_OrderSpecification_Buyer.Placeholder />}>
                <PDP_Product_Normal_OrderSpecification_Buyer
                  selectedSkuId=id quantity setQuantity
                />
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
    let make = (
      ~show,
      ~closeFn,
      ~selected: option<PDP_SelectOption_Buyer.selectedSku>,
      ~quantity,
      ~setQuantity,
    ) => {
      <RadixUI.Dialog.Root _open=show>
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
                {switch selected {
                | Some({id}) =>
                  <React.Suspense
                    fallback={<PDP_Product_Normal_OrderSpecification_Buyer.Placeholder />}>
                    <PDP_Product_Normal_OrderSpecification_Buyer
                      selectedSkuId=id quantity setQuantity
                    />
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

module Soon = {
  module PC = {
    @react.component
    let make = (~show, ~closeFn) => {
      let onCancel = ReactEvents.interceptingHandler(_ => {
        closeFn()
      })

      <ShopDialog_Buyer isShow=show onCancel cancelText=`확인`>
        <div
          className=%twc("mt-8 px-8 py-6 flex flex-col items-center justify-center text-text-L1")>
          <span>
            {`위탁 사업자 배송을 제외한 구매하기 기능은 6월 30일 오픈입니다.`->React.string}
          </span>
          <span>
            {`위탁 배송을 원하시는 분은 ‘위탁 배송 주문’ 버튼을 눌러주세요.`->React.string}
          </span>
        </div>
      </ShopDialog_Buyer>
    }
  }

  module MO = {
    @react.component
    let make = (~show, ~closeFn) => {
      let onCancel = ReactEvents.interceptingHandler(_ => {
        closeFn()
      })

      <ShopDialog_Buyer.Mo isShow=show onCancel cancelText=`확인`>
        <div
          className=%twc(
            "mt-8 px-8 py-6 flex flex-col items-center justify-center text-lg text-text-L1 text-center"
          )>
          <span>
            {`위탁 사업자 배송을 제외한 구매하기 기능은 6월 30일 오픈입니다.`->React.string}
          </span>
          <span>
            {`위탁 배송을 원하시는 분은 ‘위탁 배송 주문’ 버튼을 눌러주세요.`->React.string}
          </span>
        </div>
      </ShopDialog_Buyer.Mo>
    }
  }
}

module NoOption = {
  module PC = {
    @react.component
    let make = (~show, ~closeFn) => {
      let onCancel = ReactEvents.interceptingHandler(_ => {
        closeFn()
      })

      <ShopDialog_Buyer isShow=show onCancel cancelText=`확인`>
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
      let onCancel = ReactEvents.interceptingHandler(_ => {
        closeFn()
      })

      <ShopDialog_Buyer.Mo isShow=show onCancel cancelText=`확인`>
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
  let make = (
    ~show,
    ~setShow,
    ~selected: option<PDP_SelectOption_Buyer.selectedSku>,
    ~quantity,
    ~setQuantity,
  ) => {
    let closeFn = _ => setShow(._ => Hide)
    <>
      <Confirm.PC
        show={show == Show(Confirm) ? true : false} selected quantity setQuantity closeFn
      />
      <Unauthorized.PC
        show={show == Show(Unauthorized) ? ShopDialog_Buyer.Show : ShopDialog_Buyer.Hide} closeFn
      />
      <NoOption.PC
        show={show == Show(NoOption) ? ShopDialog_Buyer.Show : ShopDialog_Buyer.Hide} closeFn
      />
      <Soon.PC show={show == Show(Soon) ? ShopDialog_Buyer.Show : ShopDialog_Buyer.Hide} closeFn />
    </>
  }
}

module MO = {
  @react.component
  let make = (
    ~show,
    ~setShow,
    ~selected: option<PDP_SelectOption_Buyer.selectedSku>,
    ~quantity,
    ~setQuantity,
  ) => {
    let closeFn = _ => setShow(._ => Hide)
    <>
      <Confirm.MO
        show={show == Show(Confirm) ? true : false} selected quantity setQuantity closeFn
      />
      <Unauthorized.MO
        show={show == Show(Unauthorized) ? ShopDialog_Buyer.Show : ShopDialog_Buyer.Hide} closeFn
      />
      <NoOption.MO
        show={show == Show(NoOption) ? ShopDialog_Buyer.Show : ShopDialog_Buyer.Hide} closeFn
      />
      <Soon.MO show={show == Show(Soon) ? ShopDialog_Buyer.Show : ShopDialog_Buyer.Hide} closeFn />
    </>
  }
}
