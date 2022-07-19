module Fragment = %relay(`
  fragment PDPQuotedDetailsBuyerFragment on QuotedProduct {
    category {
      item
      kind
    }
    grade
    origin
  }
`)

module PC = {
  @react.component
  let make = (~query) => {
    let {category, grade, origin} = query->Fragment.use

    let categoryLabel = {
      PDP_Parser_Buyer.Product.Normal.makeCategoryLabel(category.item, category.kind)
    }

    <div className=%twc("pb-5")>
      <h2 className=%twc("font-bold text-lg text-gray-800")> {`상품 정보`->React.string} </h2>
      <div className=%twc("mt-5 flex items-center justify-between")>
        <span className=%twc("text-gray-500")> {`작물/품종`->React.string} </span>
        <span className=%twc("text-gray-800")> {categoryLabel->React.string} </span>
      </div>
      {<div className=%twc("mt-2 flex items-center justify-between")>
        <span className=%twc("text-gray-500")> {`등급/용도명`->React.string} </span>
        <span className=%twc("text-gray-800")> {grade->React.string} </span>
      </div>}
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
    let {category, grade, origin} = query->Fragment.use

    let categoryLabel = {
      PDP_Parser_Buyer.Product.Normal.makeCategoryLabel(category.item, category.kind)
    }

    <div>
      <h2 className=%twc("font-bold text-lg text-text-L1")> {`상품 정보`->React.string} </h2>
      <div className=%twc("mt-5 flex items-center justify-between")>
        <span className=%twc("text-text-L2")> {`작물/품종`->React.string} </span>
        <span className=%twc("text-text-L1")> {categoryLabel->React.string} </span>
      </div>
      {<div className=%twc("mt-2 flex items-center justify-between")>
        <span className=%twc("text-text-L2")> {`등급/용도명`->React.string} </span>
        <span className=%twc("text-text-L1")> {grade->React.string} </span>
      </div>}
      {origin->Option.mapWithDefault(React.null, origin' => {
        <div className=%twc("mt-2 flex items-center justify-between")>
          <span className=%twc("text-text-L2")> {`산지`->React.string} </span>
          <span className=%twc("text-text-L1")> {origin'->React.string} </span>
        </div>
      })}
    </div>
  }
}
