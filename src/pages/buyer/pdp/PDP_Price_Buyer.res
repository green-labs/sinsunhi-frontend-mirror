/*
  1. 컴포넌트 위치
  바이어 센터 전시 매장 > PDP Page > 상단 상품 가격 컴포넌트
  
  2. 역할
  상품가격 + 상품 status + 인증 정보들을 고려하여 디스플레이 용 상품가격을 보여줍니다.
*/

module Fragment = %relay(`
  fragment PDPPriceBuyerFragment on Product {
    price
    status
  }
`)

module PC = {
  @react.component
  let make = (~query) => {
    let user = CustomHooks.User.Buyer.use2()
    let {price, status} = Fragment.use(query)
    let isSoldout = status == #SOLDOUT

    let priceLabel = {
      price->Option.mapWithDefault("", price' => {
        price'->Int.toFloat->Locale.Float.show(~digits=0)
      })
    }

    switch user {
    | LoggedIn(_) => {
        let textColor = isSoldout ? %twc("text-gray-600") : %twc("text-gray-800")
        <h1 className={%twc("mt-5 text-[32px] font-bold") ++ textColor}>
          {priceLabel->React.string} <span className=%twc("text-lg")> {`원`->React.string} </span>
        </h1>
      }
    | NotLoggedIn =>
      <h1 className=%twc("mt-5 text-[28px] text-green-500 font-bold")>
        {`공급가 회원공개`->React.string}
      </h1>
    | Unknown => <Skeleton.Box />
    }
  }
}

module MO = {
  @react.component
  let make = (~query) => {
    let user = CustomHooks.User.Buyer.use2()
    let {price, status} = Fragment.use(query)
    let isSoldout = status == #SOLDOUT

    let priceLabel = {
      price->Option.mapWithDefault("", price' => {
        price'->Int.toFloat->Locale.Float.show(~digits=0)
      })
    }

    switch user {
    | LoggedIn(_) => {
        let textColor = isSoldout ? %twc("text-gray-600") : %twc("text-gray-800")
        <h1 className={%twc("text-xl font-bold ") ++ textColor}>
          {priceLabel->React.string} <span className=%twc("text-lg")> {`원`->React.string} </span>
        </h1>
      }
    | NotLoggedIn =>
      <h1 className=%twc("text-xl text-green-500 font-bold")>
        {`공급가 회원공개`->React.string}
      </h1>
    | Unknown => <Skeleton.Box />
    }
  }
}
