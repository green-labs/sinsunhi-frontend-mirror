/*
  1. 컴포넌트 위치
  바이어 센터 전시 매장 > PDP Page > 주문 수량
  
  2. 역할
  선택한 단품의 주문 수량을 입력할 수 있으며, 그에 따른 가격 정보를 보여줍니다.
*/

module Fragment = %relay(`
  fragment PDPProductNormalQuantityInputBuyer on Product
  @argumentDefinitions(
    first: { type: "Int", defaultValue: 20 }
    after: { type: "ID", defaultValue: null }
  ) {
    productOptions(first: $first, after: $after) {
      edges {
        node {
          stockSku
          price
          productOptionCost {
            deliveryCost
          }
        }
      }
    }
  }
`)

module PC = {
  @react.component
  let make = (
    ~query,
    ~selectedItem: option<PDP_SelectOption_Buyer.selectedSku>,
    ~quantity,
    ~setQuantity,
  ) => {
    let {productOptions} = query->Fragment.use

    switch selectedItem {
    | None => React.null
    | Some(selected') =>
      // 선택된 옵션
      let selectedSku = {
        productOptions.edges->Array.getBy(({node}) => node.stockSku == selected'.stockSku)
      }

      // 총 상품가격: 갯수 * (바이어판매가 - 택배비) 가격
      let totalProductPrice = {
        selectedSku->Option.flatMap(selectedSku' => {
          selectedSku'.node.price->Option.map(price => {
            let deliveryCost = selectedSku'.node.productOptionCost.deliveryCost
            (price - deliveryCost) * quantity
          })
        })
      }

      <div className=%twc("pt-6 flex items-center justify-between")>
        <Spinbox value=quantity setValue=setQuantity />
        <div className=%twc("flex flex-col")>
          <span className=%twc("mt-1 text-gray-800 text-right text-[15px]")>
            <span> {selected'.label->React.string} </span>
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
  let make = (
    ~query,
    ~selectedItem: option<PDP_SelectOption_Buyer.selectedSku>,
    ~quantity,
    ~setQuantity,
  ) => {
    let {productOptions} = query->Fragment.use

    switch selectedItem {
    | None => React.null
    | Some(selected') =>
      // 선택된 옵션
      let selectedSku = {
        productOptions.edges->Array.getBy(({node}) => node.stockSku == selected'.stockSku)
      }

      // 총 상품가격: 갯수 * (바이어판매가 - 택배비) 가격
      let totalProductPrice = {
        selectedSku->Option.flatMap(selectedSku' => {
          selectedSku'.node.price->Option.map(price => {
            let deliveryCost = selectedSku'.node.productOptionCost.deliveryCost
            (price - deliveryCost) * quantity
          })
        })
      }

      <section className=%twc("py-8 flex items-center justify-between")>
        <Spinbox value=quantity setValue=setQuantity />
        <div className=%twc("flex flex-col")>
          <span className=%twc("mt-1 text-gray-800 text-right text-[15px]")>
            <span> {selected'.label->React.string} </span>
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
