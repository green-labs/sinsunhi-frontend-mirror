/*
 *
 * 1. 위치: 어드민 단품 수정 페이지 상단 서머리
 *
 * 2. 역할: 상품의 간략한 정보를 표현한다.
 *
 */

module Fragment = %relay(`
  fragment ProductSummaryAdminFragment on Product {
    productId
    displayName
    name
  
    ... on NormalProduct {
      producer {
        name
      }
    }
  
    ... on QuotableProduct {
      producer {
        name
      }
    }
  }
`)

@react.component
let make = (~query) => {
  let product = Fragment.use(query)
  let {producer} = product

  <section className=%twc("p-7 mt-4 mx-4 mb-7 bg-white rounded shadow-gl")>
    <h2 className=%twc("text-text-L1 text-lg font-bold mb-6")>
      {j`상품정보 요약`->React.string}
    </h2>
    <div className=%twc("flex flex-col gap-4 text-sm")>
      <div className=%twc("flex")>
        <div className=%twc("flex gap-2")>
          <span className=%twc("font-bold")> {`생산자`->React.string} </span>
          <span className=%twc("w-80")>
            {producer->Option.mapWithDefault("", ({name}) => name)->React.string}
          </span>
        </div>
        <div className=%twc("flex gap-2")>
          <span className=%twc("font-bold")> {`상품번호`->React.string} </span>
          <span> {product.productId->Int.toString->React.string} </span>
        </div>
      </div>
      <div className=%twc("flex gap-2")>
        <span className=%twc("font-bold")> {`생산자용 상품명`->React.string} </span>
        <span> {product.name->React.string} </span>
      </div>
      <div className=%twc("flex gap-2")>
        <span className=%twc("font-bold")> {`바이어용 상품명`->React.string} </span>
        <span> {product.displayName->React.string} </span>
      </div>
    </div>
  </section>
}
