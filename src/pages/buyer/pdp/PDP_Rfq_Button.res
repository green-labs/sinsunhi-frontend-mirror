/*
  1. 컴포넌트 위치
  바이어 센터 전시 매장 > PDP Page > 최저가 견적받기 버튼
  
  2. 역할
  {인증}/{유저 롤}/{상품 타입} 등을 고려한 rfq버튼을 제공합니다.
*/

module Quoted = {
  module PC = {
    @react.component
    let make = () => {
      let user = CustomHooks.User.Buyer.use2()

      let (showModal, setShowModal) = React.Uncurried.useState(_ =>
        PDP_Product_Quoted_Modals_Buyer.Hide
      )

      <>
        {switch user {
        // 미인증
        | NotLoggedIn =>
          let onClick = ReactEvents.interceptingHandler(_ => {
            setShowModal(._ => Show(Unauthorized))
          })
          <button
            onClick className=%twc("w-full h-16 rounded-xl bg-primary hover:bg-primary-variant")>
            <span className=%twc("text-white text-lg font-bold")>
              {`최저가 견적받기`->React.string}
            </span>
          </button>

        | LoggedIn({role}) =>
          switch role {
          // 어드민 | 셀러
          | Admin | Seller =>
            <button disabled=true className=%twc("w-full h-16 rounded-xl bg-disabled-L2")>
              <span className=%twc("text-white text-lg font-bold")>
                {`최저가 견적받기`->React.string}
              </span>
            </button>

          // 바이어
          | Buyer =>
            let btnStyle = %twc(
              "w-full h-16 rounded-xl bg-primary hover:bg-primary-variant text-white text-lg font-bold"
            )
            <RfqCreateRequestButton className=btnStyle buttonText=`최저가 견적받기` />
          }
        | Unknown => <Skeleton.Box />
        }}
        <PDP_Product_Quoted_Modals_Buyer.PC show=showModal setShow=setShowModal />
      </>
    }
  }

  module MO = {
    @react.component
    let make = () => {
      let user = CustomHooks.User.Buyer.use2()

      let (showModal, setShowModal) = React.Uncurried.useState(_ =>
        PDP_Product_Quoted_Modals_Buyer.Hide
      )

      <>
        {switch user {
        | Unknown => <Skeleton.Box />
        | NotLoggedIn => {
            // 미인증
            let btnStyle = %twc("h-14 w-full rounded-xl bg-primary")
            let onClick = ReactEvents.interceptingHandler(_ => {
              setShowModal(._ => Show(Unauthorized))
            })
            <>
              <button onClick className=btnStyle>
                <span className=%twc("text-white text-lg font-bold")>
                  {`최저가 견적받기`->React.string}
                </span>
              </button>
              <div className=%twc("fixed w-full bottom-0 left-0")>
                <div
                  className=%twc(
                    "w-full max-w-[768px] p-3 mx-auto border-t border-t-gray-100 bg-white"
                  )>
                  <button onClick className=btnStyle>
                    <span className=%twc("text-white text-lg font-bold")>
                      {`최저가 견적받기`->React.string}
                    </span>
                  </button>
                </div>
              </div>
            </>
          }
        | LoggedIn({role}) =>
          switch role {
          // 어드민 | 셀러
          | Admin | Seller =>
            let btnStyle = %twc("h-14 w-full rounded-xl bg-disabled-L2")
            <>
              <button disabled=true className=btnStyle>
                <span className=%twc("text-white text-lg font-bold")>
                  {`최저가 견적받기`->React.string}
                </span>
              </button>
              <div className=%twc("fixed w-full bottom-0 left-0")>
                <div
                  className=%twc(
                    "w-full max-w-[768px] p-3 mx-auto border-t border-t-gray-100 bg-white"
                  )>
                  <button disabled=true className=btnStyle>
                    <span className=%twc("text-white text-lg font-bold")>
                      {`최저가 견적받기`->React.string}
                    </span>
                  </button>
                </div>
              </div>
            </>
          // 바이어
          | Buyer =>
            let btnStyle = %twc("h-14 w-full rounded-xl bg-primary text-white text-lg font-bold")
            <>
              <RfqCreateRequestButton className=btnStyle buttonText=`최저가 견적받기` />
              <div className=%twc("fixed w-full bottom-0 left-0")>
                <div
                  className=%twc(
                    "w-full max-w-[768px] p-3 mx-auto border-t border-t-gray-100 bg-white"
                  )>
                  <RfqCreateRequestButton className=btnStyle buttonText=`최저가 견적받기` />
                </div>
              </div>
            </>
          }
        }}
        <PDP_Product_Quoted_Modals_Buyer.MO show=showModal setShow=setShowModal />
      </>
    }
  }
}

module Quotable = {
  module PC = {
    @react.component
    let make = () => {
      let user = CustomHooks.User.Buyer.use2()

      let (showModal, setShowModal) = React.Uncurried.useState(_ =>
        PDP_Product_Quoted_Modals_Buyer.Hide
      )

      <>
        {switch user {
        | Unknown => <Skeleton.Box />
        // 미인증
        | NotLoggedIn =>
          let onClick = ReactEvents.interceptingHandler(_ => {
            setShowModal(._ => Show(Unauthorized))
          })
          <button
            onClick
            className=%twc(
              "w-full h-16 rounded-xl bg-primary-light hover:bg-primary-light-variant text-primary text-lg font-bold hover:text-primary-variant"
            )>
            {`최저가 견적문의`->React.string}
          </button>

        | LoggedIn({role}) =>
          switch role {
          // 어드민 | 셀러
          | Admin | Seller =>
            <button disabled=true className=%twc("w-full h-16 rounded-xl bg-disabled-L2")>
              <span className=%twc("text-white text-lg font-bold")>
                {`최저가 견적문의`->React.string}
              </span>
            </button>

          // 바이어
          | Buyer =>
            let btnStyle = %twc(
              "w-full h-16 rounded-xl bg-primary-light hover:bg-primary-light-variant text-primary text-lg font-bold hover:text-primary-variant"
            )
            <RfqCreateRequestButton className=btnStyle buttonText=`최저가 견적문의` />
          }
        }}
        <PDP_Product_Quoted_Modals_Buyer.PC show=showModal setShow=setShowModal />
      </>
    }
  }

  module MO = {
    @react.component
    let make = () => {
      let user = CustomHooks.User.Buyer.use2()

      let (showModal, setShowModal) = React.Uncurried.useState(_ =>
        PDP_Product_Quoted_Modals_Buyer.Hide
      )

      <>
        {switch user {
        | Unknown => <Skeleton.Box />
        | NotLoggedIn => {
            let btnStyle = %twc("h-14 w-full rounded-xl bg-primary-light")
            let onClick = ReactEvents.interceptingHandler(_ => {
              setShowModal(._ => Show(Unauthorized))
            })
            <button onClick className=btnStyle>
              <span className=%twc("text-primary text-lg font-bold")>
                {`최저가 견적문의`->React.string}
              </span>
            </button>
          }
        | LoggedIn({role}) =>
          switch role {
          // 어드민 | 셀러
          | Admin | Seller =>
            let btnStyle = %twc("h-14 w-full rounded-xl bg-disabled-L2")
            <button disabled=true className=btnStyle>
              <span className=%twc("text-white text-lg font-bold")>
                {`최저가 견적문의`->React.string}
              </span>
            </button>

          // 바이어
          | Buyer =>
            let btnStyle = %twc(
              "h-14 w-full rounded-xl bg-primary-light text-primary text-lg font-bold"
            )
            <RfqCreateRequestButton className=btnStyle buttonText=`최저가 견적문의` />
          }
        }}
        <PDP_Product_Quoted_Modals_Buyer.MO show=showModal setShow=setShowModal />
      </>
    }
  }
}
