/*
  1. 컴포넌트 위치
  바이어 센터 전시 매장 > PDP Page > 주문 최종 가격
  
  2. 역할
  일반 상품 최종 가격정보. 선택한 단품/수량에 따른 배송비, 최종 가격 정보를 보여줍니다.
*/

module Fragment = %relay(`
  fragment PDPNormalTotalPriceBuyerFragment on Product
  @argumentDefinitions(
    first: { type: "Int", defaultValue: 20 }
    after: { type: "ID", defaultValue: null }
  ) {
    status
  
    ... on NormalProduct {
      productOptions(first: $first, after: $after) {
        edges {
          node {
            id
            stockSku
            price
            productOptionCost {
              deliveryCost
              isFreeShipping
            }
          }
        }
      }
    }
  
    ... on QuotableProduct {
      productOptions(first: $first, after: $after) {
        edges {
          node {
            id
            stockSku
            price
            productOptionCost {
              deliveryCost
              isFreeShipping
            }
          }
        }
      }
    }
  }
`)

module PC = {
  @react.component
  let make = (~query, ~selectedOptionId, ~quantity) => {
    let user = CustomHooks.User.Buyer.use2()
    let {status, productOptions} = query->Fragment.use

    let makeSelectedSku = selectedId => {
      selectedId->Option.flatMap(selectedId' => {
        productOptions->Option.flatMap(({edges}) =>
          edges->Array.getBy(({node}) => node.id == selectedId')
        )
      })
    }

    <div className=%twc("py-7 px-6 flex items-center justify-between")>
      <span className=%twc("text-lg font-bold text-gray-800")>
        {`총 결제 금액`->React.string}
      </span>
      <div className=%twc("flex items-center")>
        {switch user {
        | Unknown => React.null

        | NotLoggedIn =>
          // 미인증
          <span className=%twc("ml-2 text-green-500 text-sm")>
            {`로그인을 하시면 총 결제 금액을 보실 수 있습니다`->React.string}
          </span>

        | LoggedIn(_) =>
          switch status {
          | #SOLDOUT =>
            // 품절
            <span className=%twc("ml-2 text-gray-500 text-sm")>
              {`품절된 상품으로 총 결제 금액을 보실 수 없습니다`->React.string}
            </span>

          | _ =>
            switch selectedOptionId->makeSelectedSku {
            | None =>
              // 단품 미선택
              <span className=%twc("ml-2 text-green-500 text-sm")>
                {`단품을 선택하시면 총 결제 금액을 보실 수 있습니다`->React.string}
              </span>

            | Some({node: {price, productOptionCost}}) =>
              // 인증 완료 / 단품 선택 된 상태

              // 총 상품가격: 갯수 * 단품 가격
              let totalProductPrice = {
                let optionPrice = PDP_Parser_Buyer.ProductOption.makeOptionPrice(
                  ~price,
                  ~deliveryCost=productOptionCost.deliveryCost,
                  ~isFreeShipping=productOptionCost.isFreeShipping,
                )
                optionPrice->Option.map(optionPrice' => optionPrice' * quantity)
              }

              // 총 배송비: 갯수 * 배송비
              let totalDeliveryCost = {
                PDP_Parser_Buyer.ProductOption.makeOptionDeliveryCost(
                  ~deliveryCost=productOptionCost.deliveryCost,
                  ~isFreeShipping=productOptionCost.isFreeShipping,
                ) *
                quantity
              }

              // 총 결제 금액: 상품가격 총합 + 배송비 총합
              let totalPrice = {
                totalProductPrice->Option.map(totalProductPrice' =>
                  totalProductPrice' + totalDeliveryCost
                )
              }

              <>
                <span className=%twc("text-gray-600")>
                  {switch totalDeliveryCost {
                  | 0 => `배송비 무료`
                  | notZeroInt =>
                    `배송비 ${notZeroInt->Int.toFloat->Locale.Float.show(~digits=0)}원 포함`
                  }->React.string}
                </span>
                <span className=%twc("ml-2 text-green-500 font-bold text-2xl")>
                  {totalPrice
                  ->Option.mapWithDefault("", totalPrice' => {
                    `${totalPrice'->Int.toFloat->Locale.Float.show(~digits=0)}원`
                  })
                  ->React.string}
                </span>
              </>
            }
          }
        }}
      </div>
    </div>
  }
}

module MO = {
  @react.component
  let make = (~query, ~selectedOptionId, ~quantity) => {
    let user = CustomHooks.User.Buyer.use2()
    let {status, productOptions} = query->Fragment.use

    let makeSelectedSku = selectedId => {
      selectedId->Option.flatMap(selectedId' => {
        productOptions->Option.flatMap(({edges}) =>
          edges->Array.getBy(({node}) => node.id == selectedId')
        )
      })
    }

    <div>
      <h1 className=%twc("text-lg font-bold text-text-L1")>
        {`총 결제 금액`->React.string}
      </h1>
      <div className=%twc("mt-2 flex items-center")>
        {switch user {
        | Unknown => React.null

        | NotLoggedIn =>
          // 미인증
          <span className=%twc("text-green-500 text-sm")>
            {`로그인을 하시면 총 결제 금액을 보실 수 있습니다`->React.string}
          </span>

        | LoggedIn(_) =>
          switch status {
          | #SOLDOUT =>
            // 품절
            <span className=%twc("text-gray-500 text-sm")>
              {`품절된 상품으로 총 결제 금액을 보실 수 없습니다`->React.string}
            </span>

          | _ =>
            switch selectedOptionId->makeSelectedSku {
            | None =>
              // 단품 미선택
              <span className=%twc("text-green-500 text-sm")>
                {`단품을 선택하시면 총 결제 금액을 보실 수 있습니다`->React.string}
              </span>

            | Some({node: {price, productOptionCost}}) =>
              // 인증 완료 / 단품 선택 된 상태

              // 총 상품가격: 갯수 * 단품 가격
              let totalProductPrice = {
                let optionPrice = PDP_Parser_Buyer.ProductOption.makeOptionPrice(
                  ~price,
                  ~deliveryCost=productOptionCost.deliveryCost,
                  ~isFreeShipping=productOptionCost.isFreeShipping,
                )
                optionPrice->Option.map(optionPrice' => optionPrice' * quantity)
              }

              // 총 배송비: 갯수 * 배송비
              let totalDeliveryCost = {
                PDP_Parser_Buyer.ProductOption.makeOptionDeliveryCost(
                  ~deliveryCost=productOptionCost.deliveryCost,
                  ~isFreeShipping=productOptionCost.isFreeShipping,
                ) *
                quantity
              }

              // 총 결제 금액: 상품가격 총합 + 배송비 총합
              let totalPrice = {
                totalProductPrice->Option.map(totalProductPrice' =>
                  totalProductPrice' + totalDeliveryCost
                )
              }

              <div className=%twc("w-full flex items-center justify-between")>
                <span className=%twc("text-gray-600")>
                  {switch totalDeliveryCost {
                  | 0 => `배송비 무료`
                  | notZeroInt =>
                    `배송비 ${notZeroInt->Int.toFloat->Locale.Float.show(~digits=0)}원 포함`
                  }->React.string}
                </span>
                <span className=%twc("ml-2 text-green-500 font-bold text-2xl")>
                  {totalPrice
                  ->Option.mapWithDefault("", totalPrice' => {
                    `${totalPrice'->Int.toFloat->Locale.Float.show(~digits=0)}원`
                  })
                  ->React.string}
                </span>
              </div>
            }
          }
        }}
      </div>
    </div>
  }
}
