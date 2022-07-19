/*
  1. 컴포넌트 위치
  PDP > 일반 상품 > 주문 버튼
  
  2. 역할
  {인증}/{단품 선택 여부} 등을 고려한 일반상품의 주문 버튼을 보여줍니다.
*/

module Fragment = %relay(`
  fragment PDPNormalSubmitBuyerFragment on Product {
    __typename
    status
  
    ...PDPNormalGtmBuyer_ClickBuy_Fragment
  }
`)

type orderStatus =
  | Loading // SSR
  | Soldout // 상품 품절
  | Unauthorized // 미인증
  | NoOption // 선택한 단품이 없음
  | Fulfilled(string) // 구매 가능 상태

module PC = {
  module ActionBtn = {
    @react.component
    let make = (~query, ~className, ~selectedOptionId, ~setShowModal, ~quantity, ~children) => {
      let pushGtmClickBuy = PDP_Normal_Gtm_Buyer.ClickBuy.use(~query, ~selectedOptionId, ~quantity)

      let onClick = _ => {
        setShowModal(._ => PDP_Normal_Modals_Buyer.Show(Confirm))
        pushGtmClickBuy()
      }

      <button className onClick> children </button>
    }
  }

  module OrderBtn = {
    @react.component
    let make = (~status, ~selectedOptionId, ~setShowModal, ~query, ~quantity) => {
      let user = CustomHooks.User.Buyer.use2()

      let btnStyle = %twc(
        "w-full h-16 rounded-xl flex items-center justify-center bg-primary hover:bg-primary-variant text-lg font-bold text-white"
      )

      let disabledStyle = %twc(
        "w-full h-16 rounded-xl flex items-center justify-center bg-gray-300 text-white font-bold text-xl"
      )

      let orderStatus = {
        switch (status, user, selectedOptionId) {
        | (#SOLDOUT, _, _) => Soldout
        | (_, Unknown, _) => Loading
        | (_, NotLoggedIn, _) => Unauthorized
        | (_, LoggedIn(_), None) => NoOption
        | (_, LoggedIn(_), Some(selectedOptionId')) => Fulfilled(selectedOptionId')
        }
      }

      switch orderStatus {
      // SSR
      | Loading => <button disabled=true className=disabledStyle> {``->React.string} </button>

      // 품절
      | Soldout => <button disabled=true className=disabledStyle> {`품절`->React.string} </button>

      // 미인증
      | Unauthorized =>
        <button
          className=btnStyle
          onClick={_ => {
            setShowModal(._ => PDP_Normal_Modals_Buyer.Show(
              Unauthorized(`로그인 후에\n구매하실 수 있습니다.`),
            ))
          }}>
          {`구매하기`->React.string}
        </button>

      // 단품 미선택
      | NoOption =>
        <button
          className=btnStyle
          onClick={_ => setShowModal(._ => PDP_Normal_Modals_Buyer.Show(NoOption))}>
          {`구매하기`->React.string}
        </button>

      // 구매 가능
      | Fulfilled(selectedOptionId') =>
        <ActionBtn
          className=btnStyle query selectedOptionId=selectedOptionId' setShowModal quantity>
          {`구매하기`->React.string}
        </ActionBtn>
      }
    }
  }

  module RfqBtn = {
    @react.component
    let make = (~setShowModal) => {
      let buttonText = `최저가 견적문의`
      let user = CustomHooks.User.Buyer.use2()

      let btnStyle = %twc(
        "mt-4 w-full h-16 rounded-xl bg-primary-light hover:bg-primary-light-variant text-primary text-lg font-bold hover:text-primary-variant"
      )

      let disabledStyle = %twc(
        "mt-4 w-full h-16 rounded-xl bg-disabled-L2 text-lg font-bold text-white"
      )

      switch user {
      | Unknown =>
        <button disabled=true className=disabledStyle> {buttonText->React.string} </button>

      | NotLoggedIn =>
        <button
          className=btnStyle
          onClick={_ => {
            setShowModal(._ => PDP_Normal_Modals_Buyer.Show(
              Unauthorized(`로그인 후에\n견적을 받으실 수 있습니다.`),
            ))
          }}>
          {buttonText->React.string}
        </button>

      | LoggedIn({role}) =>
        switch role {
        | Admin | Seller =>
          <button disabled=true className=disabledStyle> {buttonText->React.string} </button>

        | Buyer => <RfqCreateRequestButton className=btnStyle buttonText />
        }
      }
    }
  }

  @react.component
  let make = (~query, ~selectedOptionId, ~setShowModal, ~quantity) => {
    let {status, __typename, fragmentRefs} = query->Fragment.use

    <section className=%twc("w-full")>
      <OrderBtn status selectedOptionId setShowModal quantity query=fragmentRefs />
      {switch __typename->Product_Parser.Type.decode {
      | Some(Quotable) => <RfqBtn setShowModal />
      | _ => React.null
      }}
    </section>
  }
}

module MO = {
  module CTAContainer = {
    @react.component
    let make = (~children=?) => {
      <div className=%twc("fixed w-full bottom-0 left-0")>
        <div className=%twc("w-full max-w-[768px] p-3 mx-auto border-t border-t-gray-100 bg-white")>
          <div className=%twc("w-full h-14 flex")>
            <button onClick={_ => ChannelTalk.showMessenger()}>
              <img
                src="/icons/cs-gray-square.png"
                className=%twc("w-14 h-14 mr-2")
                alt="cta-cs-btn-mobile"
              />
            </button>
            {children->Option.getWithDefault(React.null)}
          </div>
        </div>
      </div>
    }
  }

  module OrderBtn = {
    module ActionBtn = {
      @react.component
      let make = (~query, ~className, ~selectedOptionId, ~setShowModal, ~quantity, ~children) => {
        let pushGtmClickBuy = PDP_Normal_Gtm_Buyer.ClickBuy.use(
          ~query,
          ~selectedOptionId,
          ~quantity,
        )

        let onClick = _ => {
          setShowModal(._ => PDP_Normal_Modals_Buyer.Show(Confirm))
          pushGtmClickBuy()
        }

        <button className onClick> children </button>
      }
    }

    @react.component
    let make = (~status, ~selectedOptionId, ~setShowModal, ~query, ~quantity) => {
      let user = CustomHooks.User.Buyer.use2()

      let btnStyle = %twc(
        "flex flex-1 rounded-xl items-center justify-center bg-primary font-bold text-white"
      )

      let disabledStyle = %twc(
        "flex flex-1 rounded-xl items-center justify-center bg-gray-300 text-white font-bold"
      )

      let orderStatus = {
        switch (status, user, selectedOptionId) {
        | (#SOLDOUT, _, _) => Soldout
        | (_, Unknown, _) => Loading
        | (_, NotLoggedIn, _) => Unauthorized
        | (_, LoggedIn(_), None) => NoOption
        | (_, LoggedIn(_), Some(selectedOptionId')) => Fulfilled(selectedOptionId')
        }
      }

      switch orderStatus {
      // SSR
      | Loading => <button disabled=true className=disabledStyle> {``->React.string} </button>

      // 품절
      | Soldout => <button disabled=true className=disabledStyle> {`품절`->React.string} </button>

      // 미인증
      | Unauthorized =>
        <button
          className=btnStyle
          onClick={_ => {
            setShowModal(._ => PDP_Normal_Modals_Buyer.Show(
              Unauthorized(`로그인 후에\n구매하실 수 있습니다.`),
            ))
          }}>
          {`구매하기`->React.string}
        </button>

      // 단품 미선택
      | NoOption =>
        <button
          className=btnStyle
          onClick={_ => setShowModal(._ => PDP_Normal_Modals_Buyer.Show(NoOption))}>
          {`구매하기`->React.string}
        </button>

      // 구매 가능
      | Fulfilled(selectedOptionId') =>
        <ActionBtn
          className=btnStyle query selectedOptionId=selectedOptionId' setShowModal quantity>
          {`구매하기`->React.string}
        </ActionBtn>
      }
    }
  }

  module RfqBtn = {
    @react.component
    let make = (~setShowModal) => {
      let buttonText = `최저가 견적문의`
      let user = CustomHooks.User.Buyer.use2()

      let btnStyle = %twc(
        "flex flex-1 items-center justify-center rounded-xl bg-white border border-primary text-primary text-lg font-bold"
      )
      let disabledStyle = %twc(
        "flex flex-1 items-center justify-center rounded-xl bg-disabled-L2 text-lg font-bold text-white"
      )

      switch user {
      | Unknown =>
        <button disabled=true className=disabledStyle> {buttonText->React.string} </button>

      | NotLoggedIn =>
        <>
          <button
            className=btnStyle
            onClick={_ => {
              setShowModal(._ => PDP_Normal_Modals_Buyer.Show(
                Unauthorized(`로그인 후에\n견적을 받으실 수 있습니다.`),
              ))
            }}>
            {buttonText->React.string}
          </button>
        </>

      | LoggedIn({role}) =>
        switch role {
        | Admin | Seller =>
          <button disabled=true className=disabledStyle> {buttonText->React.string} </button>

        | Buyer =>
          <RfqCreateRequestButton className=btnStyle buttonText={`최저가 견적문의`} />
        }
      }
    }
  }

  @react.component
  let make = (~query, ~selectedOptionId, ~setShowModal, ~quantity) => {
    let {__typename, status, fragmentRefs} = query->Fragment.use

    <>
      // 컨텐츠 내 버튼
      <div className=%twc("w-full h-14 flex")>
        {switch __typename->Product_Parser.Type.decode {
        | Some(Quotable) =>
          <>
            <RfqBtn setShowModal />
            <div className=%twc("w-2") />
          </>
        | _ => React.null
        }}
        <OrderBtn status selectedOptionId setShowModal query=fragmentRefs quantity />
      </div>
      // 플로팅 영역
      <CTAContainer>
        {switch __typename->Product_Parser.Type.decode {
        | Some(Quotable) =>
          <>
            <RfqBtn setShowModal />
            <div className=%twc("w-2") />
          </>
        | _ => React.null
        }}
        <OrderBtn status selectedOptionId setShowModal query=fragmentRefs quantity />
      </CTAContainer>
    </>
  }
}
