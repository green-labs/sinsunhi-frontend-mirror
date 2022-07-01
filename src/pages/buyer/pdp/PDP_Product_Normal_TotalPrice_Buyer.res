/*
  1. 컴포넌트 위치
  바이어 센터 전시 매장 > PDP Page > 주문 최종 가격
  
  2. 역할
  일반 상품 최종 가격정보. 선택한 단품/수량에 따른 배송비, 최종 가격 정보를 보여줍니다.
*/

module Fragment = %relay(`
  fragment PDPProductNormalTotalPriceBuyerFragment on Product
  @argumentDefinitions(
    first: { type: "Int", defaultValue: 20 }
    after: { type: "ID", defaultValue: null }
  ) {
    status
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
  let make = (~query, ~selectedItem: option<PDP_SelectOption_Buyer.selectedSku>, ~quantity) => {
    let user = CustomHooks.User.Buyer.use2()
    let {status, productOptions} = query->Fragment.use
    let isSoldout = status == #SOLDOUT

    // 선택된 옵션
    let selectedSku = {
      selectedItem->Option.flatMap(selectedItem' => {
        productOptions.edges->Array.getBy(({node}) => node.stockSku == selectedItem'.stockSku)
      })
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

    // 총 배송비: 갯수 * 배송비
    let totalDeliveryCost = {
      selectedSku->Option.map(selectedSku' =>
        selectedSku'.node.productOptionCost.deliveryCost * quantity
      )
    }

    // 토탈 상품가격 + 토탈 배송비
    let totalPrice = {
      Helper.Option.map2(totalProductPrice, totalDeliveryCost, (a, b) => a + b)
    }

    <div className=%twc("py-7 px-6 flex items-center justify-between")>
      <span className=%twc("text-lg font-bold text-gray-800")>
        {`총 결제 금액`->React.string}
      </span>
      <div className=%twc("flex items-center")>
        {switch (user, selectedSku) {
        | (Unknown, _) => <Skeleton.Box />
        | (NotLoggedIn, _) =>
          // 미인증
          <span className=%twc("ml-2 text-green-500 text-sm")>
            {`로그인을 하시면 총 결제 금액을 보실 수 있습니다`->React.string}
          </span>
        | (LoggedIn(_), None) =>
          // 인증, 단품미선택
          switch isSoldout {
          | true =>
            <span className=%twc("ml-2 text-gray-500 text-sm")>
              {`품절된 상품으로 총 결제 금액을 보실 수 없습니다`->React.string}
            </span>
          | false =>
            <span className=%twc("ml-2 text-green-500 text-sm")>
              {`단품을 선택하시면 총 결제 금액을 보실 수 있습니다`->React.string}
            </span>
          }
        | (LoggedIn(_), Some(_)) => <>
            // 인증, 단품선택
            <span className=%twc("text-gray-600")>
              {totalDeliveryCost
              ->Option.mapWithDefault("", totalDeliveryCost' => {
                `배송비 ${totalDeliveryCost'
                  ->Int.toFloat
                  ->Locale.Float.show(~digits=0)}원 포함`
              })
              ->React.string}
            </span>
            <span className=%twc("ml-2 text-green-500 font-bold text-2xl")>
              {totalPrice
              ->Option.mapWithDefault("", totalPrice' => {
                `${totalPrice'->Int.toFloat->Locale.Float.show(~digits=0)}원`
              })
              ->React.string}
            </span>
          </>
        }}
      </div>
    </div>
  }
}

module MO = {
  @react.component
  let make = (~query, ~selectedItem: option<PDP_SelectOption_Buyer.selectedSku>, ~quantity) => {
    let user = CustomHooks.User.Buyer.use2()
    let {status, productOptions} = query->Fragment.use
    let isSoldout = status == #SOLDOUT

    // 선택된 옵션
    let selectedSku = {
      selectedItem->Option.flatMap(selectedItem' => {
        productOptions.edges->Array.getBy(({node}) => node.stockSku == selectedItem'.stockSku)
      })
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

    // 총 배송비: 갯수 * 배송비
    let totalDeliveryCost = {
      selectedSku->Option.map(selectedSku' =>
        selectedSku'.node.productOptionCost.deliveryCost * quantity
      )
    }

    // 토탈 상품가격 + 토탈 배송비
    let totalPrice = {
      Helper.Option.map2(totalProductPrice, totalDeliveryCost, (a, b) => a + b)
    }

    <div>
      <h1 className=%twc("text-lg font-bold text-text-L1")>
        {`총 결제 금액`->React.string}
      </h1>
      <div className=%twc("mt-2 flex items-center")>
        {switch (user, selectedSku) {
        | (Unknown, _) => <Skeleton.Box />
        | (NotLoggedIn, _) =>
          // 미인증
          <span className=%twc("text-green-500 text-sm")>
            {`로그인을 하시면 총 결제 금액을 보실 수 있습니다`->React.string}
          </span>

        | (LoggedIn(_), None) =>
          // 인증, 단품미선택
          switch isSoldout {
          | true =>
            <span className=%twc("text-gray-500 text-sm")>
              {`품절된 상품으로 총 결제 금액을 보실 수 없습니다`->React.string}
            </span>
          | false =>
            <span className=%twc("text-green-500 text-sm")>
              {`단품을 선택하시면 총 결제 금액을 보실 수 있습니다`->React.string}
            </span>
          }

        | (LoggedIn(_), Some(_)) =>
          // 인증, 단품선택
          <div className=%twc("w-full flex items-center justify-between")>
            <span className=%twc("text-gray-600")>
              {totalDeliveryCost
              ->Option.mapWithDefault("", totalDeliveryCost' => {
                `배송비 ${totalDeliveryCost'
                  ->Int.toFloat
                  ->Locale.Float.show(~digits=0)}원 포함`
              })
              ->React.string}
            </span>
            <span className=%twc("ml-2 text-green-500 font-bold text-2xl")>
              {totalPrice
              ->Option.mapWithDefault("", totalPrice' => {
                `${totalPrice'->Int.toFloat->Locale.Float.show(~digits=0)}원`
              })
              ->React.string}
            </span>
          </div>
        }}
      </div>
    </div>
  }
}
