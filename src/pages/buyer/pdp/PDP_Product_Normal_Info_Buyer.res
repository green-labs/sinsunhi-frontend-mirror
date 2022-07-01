/*
  1. 컴포넌트 위치
  바이어 센터 전시 매장 > PDP Page > 상품 정보 (일반 상품)
  
  2. 역할
  일반 상품의 상품 정보를 보여줍니다.
*/

module Fragment = %relay(`
  fragment PDPProductNormalInfoBuyerFragment on Product
  @argumentDefinitions(
    first: { type: "Int", defaultValue: 20 }
    after: { type: "ID", defaultValue: null }
  ) {
    origin
    productOptions(after: $after, first: $first) {
      edges {
        node {
          weight
          weightUnit
          grade
        }
      }
    }
    category {
      item
      kind
    }
  }
`)

module PC = {
  @react.component
  let make = (~query) => {
    let {productOptions, origin, category} = Fragment.use(query)

    let categoryLabel = {
      PDP_Parser_Buyer.Product.Normal.makeCategoryLabel(category.item, category.kind)
    }

    let weightLabel = {
      productOptions.edges
      ->Array.map(({node: {weight, weightUnit}}) => (weight, weightUnit))
      ->PDP_Parser_Buyer.Product.Normal.makeWeightLabel
    }

    let gradeLabel = {
      productOptions.edges
      ->Array.keepMap(({node: {grade}}) => grade)
      ->PDP_Parser_Buyer.Product.Normal.makeGradeLabel
    }

    <div className=%twc("pb-5")>
      <h2 className=%twc("font-bold text-lg text-gray-800")> {`상품 정보`->React.string} </h2>
      <div className=%twc("mt-5 flex items-center justify-between")>
        <span className=%twc("text-gray-500")> {`작물/품종`->React.string} </span>
        <span className=%twc("text-gray-800")> {categoryLabel->React.string} </span>
      </div>
      <div className=%twc("mt-2 flex items-center justify-between")>
        <span className=%twc("text-gray-500")> {`중량단위`->React.string} </span>
        <span className=%twc("text-gray-800")> {weightLabel->React.string} </span>
      </div>
      {gradeLabel->Option.mapWithDefault(React.null, gradeLabel' => {
        <div className=%twc("mt-2 flex items-center justify-between")>
          <span className=%twc("text-gray-500")> {`등급/용도명`->React.string} </span>
          <span className=%twc("text-gray-800")> {gradeLabel'->React.string} </span>
        </div>
      })}
      {origin->Option.mapWithDefault(React.null, origin' => {
        <div className=%twc("mt-2 flex items-center justify-between")>
          <span className=%twc("text-gray-500")> {`산지`->React.string} </span>
          <span className=%twc("text-gray-800")> {origin'->React.string} </span>
        </div>
      })}
    </div>
  }
}

module MO = {
  @react.component
  let make = (~query) => {
    let {productOptions, origin, category} = Fragment.use(query)

    let categoryLabel = {
      PDP_Parser_Buyer.Product.Normal.makeCategoryLabel(category.item, category.kind)
    }

    let weightLabel = {
      productOptions.edges
      ->Array.map(({node: {weight, weightUnit}}) => (weight, weightUnit))
      ->PDP_Parser_Buyer.Product.Normal.makeWeightLabel
    }

    let gradeLabel = {
      productOptions.edges
      ->Array.keepMap(({node: {grade}}) => grade)
      ->PDP_Parser_Buyer.Product.Normal.makeGradeLabel
    }

    <div>
      <h2 className=%twc("font-bold text-lg text-text-L1")> {`상품 정보`->React.string} </h2>
      <div className=%twc("mt-5 flex items-center justify-between")>
        <span className=%twc("text-text-L2")> {`작물/품종`->React.string} </span>
        <span className=%twc("text-text-L1")> {categoryLabel->React.string} </span>
      </div>
      <div className=%twc("mt-2 flex items-center justify-between")>
        <span className=%twc("text-text-L2")> {`중량단위`->React.string} </span>
        <span className=%twc("text-text-L1")> {weightLabel->React.string} </span>
      </div>
      {gradeLabel->Option.mapWithDefault(React.null, gradeLabel' => {
        <div className=%twc("mt-2 flex items-center justify-between")>
          <span className=%twc("text-text-L2")> {`등급/용도명`->React.string} </span>
          <span className=%twc("text-text-L1")> {gradeLabel'->React.string} </span>
        </div>
      })}
      {origin->Option.mapWithDefault(React.null, origin' => {
        <div className=%twc("mt-2 flex items-center justify-between")>
          <span className=%twc("text-text-L2")> {`산지`->React.string} </span>
          <span className=%twc("text-text-L1")> {origin'->React.string} </span>
        </div>
      })}
    </div>
  }
}
