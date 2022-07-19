/*
  1. 컴포넌트 위치
  PDP > 일반 상품 > 상품명, 가격
  
  2. 역할
  일반 상품의 타이틀 정보를 보여줍니다.
*/

module PC = {
  @react.component
  let make = (~displayName, ~price, ~isSoldout) => {
    let user = CustomHooks.User.Buyer.use2()

    let priceLabel = {
      price->Option.mapWithDefault("", price' => {
        price'->Int.toFloat->Locale.Float.show(~digits=0)
      })
    }

    <section>
      <h1 className=%twc("text-[32px] text-gray-800")> {displayName->React.string} </h1>
      {switch user {
      | Unknown => React.null

      | NotLoggedIn =>
        <h1 className=%twc("mt-5 text-[28px] text-green-500 font-bold")>
          {`공급가 회원공개`->React.string}
        </h1>

      | LoggedIn(_) => {
          let textColor = isSoldout ? %twc("text-gray-600") : %twc("text-gray-800")
          <h1 className={%twc("mt-5 text-[32px] font-bold") ++ textColor}>
            {priceLabel->React.string}
            <span className=%twc("text-lg")> {`원`->React.string} </span>
          </h1>
        }
      }}
      <div className=%twc("w-full h-16 my-4 px-6 flex items-center rounded-xl bg-[#FFF1EE]")>
        <span className=%twc("text-orange-500")>
          {`시세에 따라 가격이 변동될 수 있습니다`->React.string}
        </span>
      </div>
    </section>
  }
}

module MO = {
  @react.component
  let make = (~displayName, ~price, ~isSoldout) => {
    let user = CustomHooks.User.Buyer.use2()

    let priceLabel = {
      price->Option.mapWithDefault("", price' => {
        price'->Int.toFloat->Locale.Float.show(~digits=0)
      })
    }

    <section>
      <h1 className=%twc("text-lg text-gray-800")> {displayName->React.string} </h1>
      {switch user {
      | Unknown => React.null

      | NotLoggedIn =>
        <h1 className=%twc("text-xl text-green-500 font-bold")>
          {`공급가 회원공개`->React.string}
        </h1>

      | LoggedIn(_) => {
          let textColor = isSoldout ? %twc("text-gray-600") : %twc("text-gray-800")
          <h1 className={%twc("text-xl font-bold ") ++ textColor}>
            {priceLabel->React.string}
            <span className=%twc("text-lg")> {`원`->React.string} </span>
          </h1>
        }
      }}
    </section>
  }
}
