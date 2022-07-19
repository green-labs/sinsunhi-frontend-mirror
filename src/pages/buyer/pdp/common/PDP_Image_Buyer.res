/*
  1. 컴포넌트 위치
  PDP > 메인 이미지
  
  2. 역할
  상품 이미지를 표현합니다
*/

module PC = {
  @react.component
  let make = (~src) => {
    <div className=%twc("relative w-[664px] pt-[100%] rounded-2xl overflow-hidden")>
      <ImageWithPlaceholder
        src
        placeholder=ImageWithPlaceholder.Placeholder.lg
        className=%twc("absolute left-0 top-0 w-full h-full object-cover")
        alt="product-detail-thumbnail"
      />
      <div className=%twc("w-full h-full absolute top-0 left-0 bg-black/[.03] rounded-2xl") />
    </div>
  }
}

module MO = {
  @react.component
  let make = (~src) => {
    <div className=%twc("w-full pt-[100%] relative overflow-hidden")>
      <ImageWithPlaceholder
        src
        placeholder=ImageWithPlaceholder.Placeholder.lg
        className=%twc("absolute top-0 left-0 w-full h-full object-cover")
        alt="product-detail-thumbnail"
      />
      <div className=%twc("w-full h-full absolute top-0 left-0 bg-black/[.03]") />
    </div>
  }
}
