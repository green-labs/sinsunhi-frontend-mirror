/*
  1. 컴포넌트 위치
  PDP > 매칭 상품 > 구매 신청하기 버튼
  
  2. 역할
  {인증}/{유저 롤} 등을 고려한 구매 신청하기 버튼을 제공합니다.
*/

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
  let make = (~setShowModal, ~selectedGroup) => {
    let buttonText = `최저가 견적받기`

    let {useRouter, pushObj} = module(Next.Router)
    let router = useRouter()
    let pid = router.query->Js.Dict.get("pid")

    let user = CustomHooks.User.Buyer.use2()

    let btnStyle = %twc("h-14 w-full rounded-xl bg-primary text-white text-lg font-bold")

    let disabledStyle = %twc("h-14 w-full rounded-xl bg-disabled-L2 text-white text-lg font-bold")

    <CTAContainer>
      {switch user {
      | Unknown =>
        <button disabled=true className=disabledStyle> {buttonText->React.string} </button>

      // 미인증
      | NotLoggedIn =>
        <button
          className=btnStyle
          onClick={_ => {
            setShowModal(._ => PDP_Matching_Modals_Buyer.Show(
              Unauthorized(`로그인 후에\n견적을 받으실 수 있습니다.`),
            ))
          }}>
          {buttonText->React.string}
        </button>

      | LoggedIn({role}) =>
        switch role {
        // 어드민 | 셀러
        | Admin | Seller =>
          <button disabled=true className=disabledStyle> {buttonText->React.string} </button>

        // 바이어
        | Buyer =>
          <button
            className=btnStyle
            onClick={_ =>
              pid
              ->Option.map(pid' => {
                router->pushObj({
                  pathname: `/buyer/tradematch/ask-to-buy/apply/${pid'}`,
                  query: Js.Dict.fromArray([("grade", selectedGroup)]),
                })
              })
              ->ignore}>
            {buttonText->React.string}
          </button>
        }
      }}
    </CTAContainer>
  }
}
