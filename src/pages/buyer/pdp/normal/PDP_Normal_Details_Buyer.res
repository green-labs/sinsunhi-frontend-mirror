/*
  1. 컴포넌트 위치
  PDP > 일반 상품 > 상품 디테일 정보
  
  2. 역할
  일반 상품의 상품 상세 정보를 보여줍니다.
*/

module Fragment = %relay(`
  fragment PDPNormalDetailsBuyerFragment on Product
  @argumentDefinitions(
    first: { type: "Int", defaultValue: 20 }
    after: { type: "ID", defaultValue: null }
  ) {
    origin
    category {
      item
      kind
    }
  
    ... on NormalProduct {
      productOptions(after: $after, first: $first) {
        edges {
          node {
            weight
            weightUnit
            grade
          }
        }
      }
    }
  
    ... on QuotableProduct {
      productOptions(after: $after, first: $first) {
        edges {
          node {
            weight
            weightUnit
            grade
          }
        }
      }
    }
  }
`)

module PC = {
  module Column = {
    @react.component
    let make = (~className, ~label, ~value) => {
      <div className={%twc("flex items-start justify-between ") ++ className}>
        <h1 className=%twc("min-w-[100px] w-[100px] text-gray-500 mr-7")>
          {label->React.string}
        </h1>
        <span className=%twc("text-gray-800 break-all text-right")> {value->React.string} </span>
      </div>
    }
  }

  @react.component
  let make = (~query) => {
    let {productOptions, origin, category} = query->Fragment.use

    let categoryLabel = {
      PDP_Parser_Buyer.Product.Normal.makeCategoryLabel(category.item, category.kind)
    }

    let weightLabel = switch productOptions {
    | Some(productOptions') =>
      productOptions'.edges
      ->Array.map(({node: {weight, weightUnit}}) => (weight, weightUnit))
      ->PDP_Parser_Buyer.Product.Normal.makeWeightLabel
    | None => "-"
    }

    let gradeLabel =
      productOptions
      ->Option.map(po => po.edges)
      ->Option.map(edges => edges->Array.keepMap(({node: {grade}}) => grade))
      ->Option.flatMap(PDP_Parser_Buyer.Product.Normal.makeGradeLabel)

    <div className=%twc("pb-5")>
      <h2 className=%twc("font-bold text-lg text-gray-800")> {`상품 정보`->React.string} </h2>
      <Column className=%twc("mt-5") label=`작물/품종` value=categoryLabel />
      <Column className=%twc("mt-2") label=`중량단위` value=weightLabel />
      {gradeLabel->Option.mapWithDefault(React.null, gradeLabel' => {
        <Column className=%twc("mt-5") label=`등급/용도명` value=gradeLabel' />
      })}
      {origin->Option.mapWithDefault(React.null, origin' => {
        <Column className=%twc("mt-5") label=`산지` value=origin' />
      })}
    </div>
  }
}

module MO = {
  module Column = {
    @react.component
    let make = (~className, ~label, ~value) => {
      <div className={%twc("flex items-start justify-between ") ++ className}>
        <span className=%twc("min-w-[100px] w-[100px] mr-7 text-text-L2")>
          {label->React.string}
        </span>
        <span className=%twc("text-text-L1 break-all text-right")> {value->React.string} </span>
      </div>
    }
  }

  @react.component
  let make = (~query) => {
    let {productOptions, origin, category} = query->Fragment.use

    let categoryLabel = {
      PDP_Parser_Buyer.Product.Normal.makeCategoryLabel(category.item, category.kind)
    }

    let weightLabel = switch productOptions {
    | Some(productOptions') =>
      productOptions'.edges
      ->Array.map(({node: {weight, weightUnit}}) => (weight, weightUnit))
      ->PDP_Parser_Buyer.Product.Normal.makeWeightLabel
    | None => "-"
    }

    let gradeLabel =
      productOptions
      ->Option.map(po => po.edges)
      ->Option.map(edges => edges->Array.keepMap(({node: {grade}}) => grade))
      ->Option.flatMap(PDP_Parser_Buyer.Product.Normal.makeGradeLabel)

    <div>
      <h2 className=%twc("font-bold text-lg text-text-L1")> {`상품 정보`->React.string} </h2>
      <Column className=%twc("mt-5") label=`작물/품종` value=categoryLabel />
      <Column className=%twc("mt-2") label=`중량단위` value=weightLabel />
      {gradeLabel->Option.mapWithDefault(React.null, gradeLabel' => {
        <Column className=%twc("mt-2") label=`등급/용도명` value=gradeLabel' />
      })}
      {origin->Option.mapWithDefault(React.null, origin' => {
        <Column className=%twc("mt-2") label=`산지` value=origin' />
      })}
    </div>
  }
}
