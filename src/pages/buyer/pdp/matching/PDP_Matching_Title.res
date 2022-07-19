/*
  1. 컴포넌트 위치
  PDP > 매칭 상품 > 상품명, 가격
  
  2. 역할
  매칭 상품의 타이틀 정보를 보여줍니다.
*/

module Fragment = %relay(`
  fragment PDPMatchingTitle_fragment on MatchingProduct {
    displayName
    representativeWeight
    recentMarketPrice {
      high {
        mean
      }
      medium {
        mean
      }
      low {
        mean
      }
    }
  }
`)

module MO = {
  @react.component
  let make = (~query, ~selectedGroup) => {
    let {displayName, representativeWeight, recentMarketPrice} = query->Fragment.use

    let priceLabel = {
      recentMarketPrice->Option.mapWithDefault("", ({high, medium, low}) => {
        let price = switch selectedGroup {
        | "high" => high.mean->Option.map(mean' => mean'->Int.toFloat *. representativeWeight)
        | "medium" => medium.mean->Option.map(mean' => mean'->Int.toFloat *. representativeWeight)
        | "low" => low.mean->Option.map(mean' => mean'->Int.toFloat *. representativeWeight)
        | _ => None
        }

        price->Option.mapWithDefault("", price' => `${price'->Locale.Float.show(~digits=0)}원`)
      })
    }

    let user = CustomHooks.User.Buyer.use2()

    <div className=%twc("w-full py-6 flex justify-between")>
      <div>
        <h1 className=%twc("text-lg text-black font-bold")> {displayName->React.string} </h1>
        <span className=%twc("mt-1 text-xs text-gray-600")>
          {`${representativeWeight->Float.toString}kg당 예상 거래가`->React.string}
        </span>
      </div>
      {switch user {
      | Unknown => React.null

      | NotLoggedIn =>
        <h1 className=%twc("text-[22px] text-black font-bold")>
          {`예상가 회원공개`->React.string}
        </h1>

      | LoggedIn(_) =>
        <h1 className=%twc("text-[22px] text-black font-bold")> {priceLabel->React.string} </h1>
      }}
    </div>
  }
}
