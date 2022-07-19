/*
  1. 컴포넌트 위치
  PDP > 견적 상품 > 상품명
  
  2. 역할
  견적 상품의 타이틀 정보를 보여줍니다.
*/

module PC = {
  @react.component
  let make = (~displayName) => {
    <section>
      <h1 className=%twc("text-[32px] text-gray-800")> {displayName->React.string} </h1>
      <h1 className=%twc("mt-4 font-bold text-blue-500 text-[28px]")>
        {`최저가 견적받기`->React.string}
      </h1>
    </section>
  }
}

module MO = {
  @react.component
  let make = (~displayName) => {
    <section>
      <h1 className=%twc("text-lg text-gray-800")> {displayName->React.string} </h1>
      <h1 className=%twc("mt-2 font-bold text-blue-500 text-lg")>
        {`최저가 견적받기`->React.string}
      </h1>
    </section>
  }
}
