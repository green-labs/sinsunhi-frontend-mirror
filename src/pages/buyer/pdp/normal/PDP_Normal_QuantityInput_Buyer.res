/*
  1. 컴포넌트 위치
  바이어 센터 전시 매장 > PDP Page > 주문 수량
  
  2. 역할
  선택한 단품의 주문 수량을 입력할 수 있으며, 그에 따른 가격 정보를 보여줍니다.
*/

module Fragment = %relay(`
  fragment PDPNormalQuantityInputBuyerFragment on Product
  @argumentDefinitions(
    first: { type: "Int", defaultValue: 20 }
    after: { type: "ID", defaultValue: null }
  ) {
    displayName
  
    ... on NormalProduct {
      productOptions(first: $first, after: $after) {
        edges {
          node {
            id
            optionName
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
            optionName
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
  let make = (~query, ~selectedOptionId, ~quantity, ~setQuantity) => {
    let {productOptions} = query->Fragment.use

    let makeSelectedSku = selectedId => {
      selectedId->Option.flatMap(selectedId' => {
        productOptions->Option.flatMap(({edges}) =>
          edges->Array.getBy(({node}) => node.id == selectedId')
        )
      })
    }

    switch selectedOptionId->makeSelectedSku {
    | None => React.null

    | Some({node: {optionName, price, productOptionCost}}) =>
      // 총 상품가격: 갯수 * 단품 가격
      let totalProductPrice =
        PDP_Parser_Buyer.ProductOption.makeOptionPrice(
          ~price,
          ~deliveryCost=productOptionCost.deliveryCost,
          ~isFreeShipping=productOptionCost.isFreeShipping,
        )->Option.map(optionPrice' => optionPrice' * quantity)

      <div className=%twc("pt-6 flex items-center justify-between")>
        <Spinbox value=quantity setValue=setQuantity />
        <div className=%twc("flex flex-col")>
          <span className=%twc("mt-1 text-gray-800 text-right text-[15px]")>
            <span> {optionName->React.string} </span>
          </span>
          <span className=%twc("mt-1 text-gray-800 font-bold text-xl text-right")>
            {totalProductPrice
            ->Option.mapWithDefault("", totalProductPrice' => {
              `${totalProductPrice'->Int.toFloat->Locale.Float.show(~digits=0)}원`
            })
            ->React.string}
          </span>
        </div>
      </div>
    }
  }
}

module MO = {
  @react.component
  let make = (~query, ~selectedOptionId, ~quantity, ~setQuantity) => {
    let {productOptions} = query->Fragment.use

    let makeSelectedSku = selectedId => {
      selectedId->Option.flatMap(selectedId' => {
        productOptions->Option.flatMap(({edges}) =>
          edges->Array.getBy(({node}) => node.id == selectedId')
        )
      })
    }

    switch selectedOptionId->makeSelectedSku {
    | None => React.null

    | Some({node: {optionName, price, productOptionCost}}) =>
      // 총 상품가격: 갯수 * 단품 가격
      let totalProductPrice =
        PDP_Parser_Buyer.ProductOption.makeOptionPrice(
          ~price,
          ~deliveryCost=productOptionCost.deliveryCost,
          ~isFreeShipping=productOptionCost.isFreeShipping,
        )->Option.map(optionPrice' => optionPrice' * quantity)

      <section className=%twc("py-8 flex items-center justify-between")>
        <Spinbox value=quantity setValue=setQuantity />
        <div className=%twc("flex flex-col")>
          <span className=%twc("mt-1 text-gray-800 text-right text-[15px]")>
            <span> {optionName->React.string} </span>
          </span>
          <span className=%twc("mt-1 text-gray-800 font-bold text-xl text-right")>
            {totalProductPrice
            ->Option.mapWithDefault("", totalProductPrice' => {
              `${totalProductPrice'->Int.toFloat->Locale.Float.show(~digits=0)}원`
            })
            ->React.string}
          </span>
        </div>
      </section>
    }
  }
}
