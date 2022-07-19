/*
  1. 컴포넌트 위치
  PDP > 견적 상품 > 최저가 견적받기 버튼
  
  2. 역할
  {인증}/{유저 롤} 등을 고려한 최저가 견적받기 버튼을 제공합니다.
*/

type orderStatus =
  | Loading // SSR
  | Unauthorized // 미인증
  | NoPermission // 바이어 롤이 아닌 사용자
  | Fulfilled // 견적요청 가능

module PC = {
  @react.component
  let make = (~setShowModal, ~query) => {
    let user = CustomHooks.User.Buyer.use2()
    let gtmPushClickRfq = PDP_Quoted_Gtm_Buyer.ClickRfq.use(~query)

    let btnStyle = %twc(
      "w-full h-16 rounded-xl bg-primary hover:bg-primary-variant text-white text-lg font-bold"
    )

    let disabledStyle = %twc(
      "w-full h-16 rounded-xl flex items-center justify-center bg-gray-300 text-white font-bold text-xl"
    )

    let orderStatus = {
      switch user {
      | Unknown => Loading
      | NotLoggedIn => Unauthorized
      | LoggedIn({role}) =>
        switch role {
        | Admin | Seller => NoPermission
        | Buyer => Fulfilled
        }
      }
    }

    orderStatus->Js.log

    switch orderStatus {
    // SSR
    | Loading =>
      <button disabled=true className=disabledStyle>
        {`최저가 견적받기`->React.string}
      </button>

    // 미인증
    | Unauthorized =>
      <button
        className=btnStyle
        onClick={_ => setShowModal(._ => PDP_Quoted_Modals_Buyer.Show(Unauthorized))}>
        {`최저가 견적받기`->React.string}
      </button>

    // 바이어 롤이 아닌 사용자
    | NoPermission =>
      <button disabled=true className=disabledStyle>
        {`최저가 견적받기`->React.string}
      </button>

    // 견적요청 가능
    | Fulfilled =>
      <div onClick={_ => gtmPushClickRfq()}>
        <RfqCreateRequestButton className=btnStyle buttonText={`최저가 견적받기`} />
      </div>
    }
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

  @react.component
  let make = (~setShowModal, ~query) => {
    let user = CustomHooks.User.Buyer.use2()
    let gtmPushClickRfq = PDP_Quoted_Gtm_Buyer.ClickRfq.use(~query)

    let btnStyle = %twc("h-14 w-full rounded-xl bg-primary text-white text-lg font-bold")

    let disabledStyle = %twc("h-14 w-full rounded-xl bg-disabled-L2 text-white text-lg font-bold")

    let orderStatus = {
      switch user {
      | Unknown => Loading
      | NotLoggedIn => Unauthorized
      | LoggedIn({role}) =>
        switch role {
        | Admin | Seller => NoPermission
        | Buyer => Fulfilled
        }
      }
    }

    switch orderStatus {
    // SSR
    | Loading =>
      <button disabled=true className=disabledStyle>
        {`최저가 견적받기`->React.string}
      </button>

    // 미인증
    | Unauthorized =>
      <>
        <button
          className=btnStyle
          onClick={_ => setShowModal(._ => PDP_Quoted_Modals_Buyer.Show(Unauthorized))}>
          {`최저가 견적받기`->React.string}
        </button>
        <CTAContainer>
          <button
            className=btnStyle
            onClick={_ => setShowModal(._ => PDP_Quoted_Modals_Buyer.Show(Unauthorized))}>
            {`최저가 견적받기`->React.string}
          </button>
        </CTAContainer>
      </>

    // 바이어 롤이 아닌 사용자
    | NoPermission =>
      <>
        <button disabled=true className=disabledStyle>
          {`최저가 견적받기`->React.string}
        </button>
        <CTAContainer>
          <button disabled=true className=disabledStyle>
            {`최저가 견적받기`->React.string}
          </button>
        </CTAContainer>
      </>

    // 견적요청 가능
    | Fulfilled =>
      <>
        <div onClick={_ => gtmPushClickRfq()}>
          <RfqCreateRequestButton className=btnStyle buttonText={`최저가 견적받기`} />
        </div>
        <CTAContainer>
          <div onClick={_ => gtmPushClickRfq()}>
            <RfqCreateRequestButton className=btnStyle buttonText={`최저가 견적받기`} />
          </div>
        </CTAContainer>
      </>
    }
  }
}
