/*
  1. 컴포넌트 위치
  PDP > 견적 상품 >Gtm 이벤트
  
  2. 역할
  견적상품 PDP에서 발송하는 gtm 이벤트들을 관리한다.
*/

module ClickRfq = {
  module Fragment = %relay(`
    fragment PDPQuotedGtmBuyer_fragment on QuotedProduct {
      productId
      displayName
      category {
        fullyQualifiedName {
          name
        }
      }
    }
  `)

  let use = (~query) => {
    let {displayName, productId, category} = query->Fragment.use
    let categoryNames = category.fullyQualifiedName->Array.map(({name}) => name)

    () => {
      DataGtm.push({
        "event": "request_quotation", // 이벤트 타입: 견적 버튼 클릭 시
        "click_rfq_btn": {
          "item_type": `견적`, // 상품 유형
          "item_id": productId->Int.toString, // 상품 코드
          "item_name": displayName, // 상품명
          "item_category": categoryNames->Array.get(0)->Js.Nullable.fromOption, // 표준 카테고리 Depth 1
          "item_category2": categoryNames->Array.get(1)->Js.Nullable.fromOption, // 표준 카테고리 Depth 2
          "item_category3": categoryNames->Array.get(2)->Js.Nullable.fromOption, // 표준 카테고리 Depth 3
          "item_category4": categoryNames->Array.get(3)->Js.Nullable.fromOption, // 표준 카테고리 Depth 4
          "item_category5": categoryNames->Array.get(4)->Js.Nullable.fromOption, // 표준 카테고리 Depth 5
        },
      })
    }
  }
}
