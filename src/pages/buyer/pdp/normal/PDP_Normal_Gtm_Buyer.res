/*
  1. 컴포넌트 위치
  PDP > 일반 상품 > Gtm 이벤트
  
  2. 역할
  PDP 일반상품에서 발송하는 gtm 이벤트들을 관리한다.
*/

// 일반상품 > 구매버튼 클릭 시
module ClickBuy = {
  module Query = %relay(`
    query PDPNormalGtmBuyer_ClickBuy_Query($id: ID!) {
      node(id: $id) {
        ... on ProductOption {
          stockSku
          price
        }
      }
    }
  `)

  module Fragment = %relay(`
    fragment PDPNormalGtmBuyer_ClickBuy_Fragment on Product {
      productId
      displayName
      category {
        fullyQualifiedName {
          name
        }
      }
      ... on NormalProduct {
        producer {
          producerCode
        }
      }
      ... on QuotableProduct {
        producer {
          producerCode
        }
      }
    }
  `)

  let use = (~query, ~selectedOptionId, ~quantity) => {
    let {node} = Query.use(
      ~variables=Query.makeVariables(~id=selectedOptionId),
      ~fetchPolicy=RescriptRelay.StoreOrNetwork,
      (),
    )
    let {productId, displayName, producer, category} = query->Fragment.use

    let categoryNames = category.fullyQualifiedName->Array.map(({name}) => name)
    let producerCode = producer->Option.map(({producerCode}) => producerCode)
    let stockSku = node->Option.map(({stockSku}) => stockSku)
    let price = node->Option.map(({price}) => price)

    () => {
      DataGtm.push({
        "event": "click_purchase", // 이벤트 타입: 상품 구매 클릭 시
        "items": [
          {
            "currency": "KRW", // 화폐 KRW 고정
            "item_id": productId->Int.toString, // 상품 코드
            "item_name": displayName, // 상품명
            "item_brand": producerCode->Js.Nullable.fromOption, // maker - 생산자코드
            "item_variant": stockSku->Js.Nullable.fromOption, // 단품 코드
            "price": price->Js.Nullable.fromOption, // 상품 가격 (바이어 판매가) - nullable
            "quantity": quantity, // 수량
            "item_category": categoryNames->Array.get(0)->Js.Nullable.fromOption, // 표준 카테고리 Depth 1
            "item_category2": categoryNames->Array.get(1)->Js.Nullable.fromOption, // 표준 카테고리 Depth 2
            "item_category3": categoryNames->Array.get(2)->Js.Nullable.fromOption, // 표준 카테고리 Depth 3
            "item_category4": categoryNames->Array.get(3)->Js.Nullable.fromOption, // 표준 카테고리 Depth 4
            "item_category5": categoryNames->Array.get(4)->Js.Nullable.fromOption, // 표준 카테고리 Depth 5
          },
        ],
      })
    }
  }
}
