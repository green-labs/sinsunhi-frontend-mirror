module Fragment = %relay(`
        fragment WebOrderProductInfoBuyerFragment on Query
        @argumentDefinitions(
          productNodeId: { type: "ID!" }
          productOptionNodeId: { type: "ID!" }
        ) {
          productNode: node(id: $productNodeId) {
            ... on Product {
              displayName
              image {
                original
              }
            }
          }
          productOptionNode: node(id: $productOptionNodeId) {
            ... on ProductOption {
              optionName
              price
            }
          }
        }
  `)

module PlaceHolder = {
  @react.component
  let make = () => {
    open Skeleton
    <section className=%twc("flex flex-col gap-5 bg-white rounded-sm")>
      <span className=%twc("text-lg xl:text-xl text-enabled-L1 font-bold")>
        {`상품 정보`->React.string}
      </span>
      <div className=%twc("flex justify-between gap-3 h-18 xl:h-20")>
        <Box className=%twc("w-18 h-18 xl:w-20 xl:h-20 rounded-lg") />
        <div className=%twc("flex-auto")>
          <Box className=%twc("w-32 mb-1") />
          <Box className=%twc("w-32 mb-1") />
          <Box className=%twc("w-24") />
        </div>
        <Box className=%twc("w-24 hidden xl:flex min-w-fit") />
      </div>
    </section>
  }
}

@react.component
let make = (~query, ~quantity) => {
  let fragments = Fragment.use(query)

  let (productName, imageUrl) = switch fragments.productNode {
  | Some(productNode') =>
    switch productNode' {
    | #Product(product) => (product.displayName, product.image.original)
    | _ => ("", "")
    }
  | None => ("", "")
  }

  let (productOptionName, price) = switch fragments.productOptionNode {
  | Some(productOptionNode') =>
    switch productOptionNode' {
    | #ProductOption({optionName, price}) => (optionName, price->Option.getWithDefault(0))
    | _ => ("", 0)
    }
  | None => (`옵션이름 없음`, 0)
  }

  <section className=%twc("flex flex-col gap-5 bg-white rounded-sm")>
    <span className=%twc("text-lg xl:text-xl text-enabled-L1 font-bold")>
      {`상품 정보`->React.string}
    </span>
    <div className=%twc("flex justify-between gap-3 h-18 xl:h-20")>
      <img
        className=%twc("w-18 h-18 xl:w-20 xl:h-20 rounded-lg") src=imageUrl alt="product-image"
      />
      <div className=%twc("flex-auto")>
        <div className=%twc("font-bold text-enabled-L1 mb-1")> {productName->React.string} </div>
        <div className=%twc("text-sm text-text-L2 mb-2 xl:mb-3")>
          {productOptionName->React.string}
        </div>
        <div className=%twc("text-sm text-text-L2")>
          {`${price->Locale.Int.show}원 | 수량 ${quantity->Int.toString}개`->React.string}
        </div>
      </div>
      <div className=%twc("hidden xl:flex font-bold text-text-L1 min-w-fit")>
        {`총 ${(price * quantity)->Locale.Int.show}원`->React.string}
      </div>
    </div>
  </section>
}
