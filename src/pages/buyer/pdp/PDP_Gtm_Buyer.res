/*
  1. 컴포넌트 위치
  PDP > Gtm 이벤트
  
  2. 역할
  PDP에서 상품타입과 관계없이 발송하는 gtm 이벤트들을 관리한다.
*/

module PageView = {
  module Fragment = %relay(`
    fragment PDPGtmBuyer_fragment on Product {
      __typename
      productId
      displayName
      category {
        fullyQualifiedName {
          name
        }
      }
      ... on NormalProduct {
        price
        producer {
          producerCode
        }
      }
      ... on QuotableProduct {
        price
        producer {
          producerCode
        }
      }
      ... on QuotedProduct {
        producer {
          producerCode
        }
      }
    }
  `)

  let use = (~query) => {
    let {__typename, productId, displayName, producer, price, category} = query->Fragment.use

    let categoryNames = category.fullyQualifiedName->Array.map(({name}) => name)
    let producerCode = producer->Option.map(({producerCode}) => producerCode)
    let typename = {
      switch __typename {
      | "NormalProduct" | "QuotableProduct" => Some(`일반`)
      | "QuotedProduct" => Some(`견적`)
      | "MatchingProduct" => Some(`매칭`)
      | _ => None
      }
    }

    () => {
      DataGtm.push({
        "event": "view_item", // 이벤트 타입: 상품페이지 진입 시
        "items": [
          {
            "item_type": typename->Js.Nullable.fromOption, // 상품 유형
            "currency": "KRW", // 화폐 KRW 고정
            "item_id": productId->Int.toString, // 상품 코드
            "item_name": displayName, // 상품명
            "item_brand": producerCode->Js.Nullable.fromOption, // maker - 생산자코드
            "price": price->Js.Nullable.fromOption, // 상품 가격 (바이어 판매가) - nullable
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
