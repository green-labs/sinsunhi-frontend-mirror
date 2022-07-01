/*
  1. 컴포넌트 위치
  바이어 센터 전시 매장 > PDP Page > 상단 상품명 컴포넌트
  
  2. 역할
  상품명 + 일부 단품 옵션 정보들을 포함하여 디스플레이 용 상품명을 보여줍니다.
*/

module Fragment = %relay(`
  fragment PDPTitleBuyerFragment on Product {
    displayName
  }
`)

module PC = {
  @react.component
  let make = (~query) => {
    let {displayName} = query->Fragment.use

    <h1 className=%twc("text-[32px] text-gray-800")> {displayName->React.string} </h1>
  }
}

module MO = {
  @react.component
  let make = (~query) => {
    let {displayName} = query->Fragment.use

    <h1 className=%twc("text-lg text-gray-800")> {displayName->React.string} </h1>
  }
}
