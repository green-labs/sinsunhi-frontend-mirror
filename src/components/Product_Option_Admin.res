module Fragment = %relay(`
  fragment ProductOptionAdminFragment on ProductOption {
    id
    weight
    weightUnit
    perWeightMin
    perWeightMax
    perWeightUnit
    perSizeUnit
    perSizeMin
    perSizeMax
    countPerPackageMax
    countPerPackageMin
    status
    product {
      id
      name
      productId
  
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
  
      md {
        name
      }
      category {
        item
        kind
      }
    }
    stockSku
    optionName
    grade
    packageType
    memo
    cutOffTime
    price
  }
`)

module Item = {
  module Table = {
    @react.component
    let make = (~query) => {
      let productOption = Fragment.use(query)

      let weightUnitToString = unit =>
        switch unit {
        | #G => "g"
        | #KG => "kg"
        | #T => "t"
        | _ => "g"
        }

      let sizeUnitToString = unit =>
        switch unit {
        | #MM => "mm"
        | #CM => "cm"
        | #M => "m"
        | _ => "mm"
        }

      <>
        <li className=%twc("grid grid-cols-15-admin-product text-gray-700")>
          <div className=%twc("h-full flex flex-col px-4 py-2")>
            <Product_Badge.V2
              status={switch productOption.status {
              | #SALE => SALE
              | #SOLDOUT => SOLDOUT
              | #HIDDEN_SALE => HIDDEN_SALE
              | #NOSALE => NOSALE
              | #RETIRE => RETIRE
              | _ => SALE
              }}
            />
          </div>
          <div className=%twc("h-full flex flex-col px-4 py-2")>
            <span className=%twc("block")>
              {productOption.product.producer->Option.mapWithDefault(React.null, ({name}) =>
                name->React.string
              )}
            </span>
          </div>
          <div className=%twc("h-full flex flex-col px-4 py-2")>
            <span className=%twc("block")>
              {productOption.product.productId->Int.toString->React.string}
            </span>
            <span className=%twc("block text-gray-500")>
              {productOption.stockSku->React.string}
            </span>
          </div>
          <div className=%twc("h-full flex flex-col px-4 py-2")>
            <span className=%twc("block truncate underline")>
              <Next.Link href={`/admin/products/${productOption.product.id}`}>
                <a> {productOption.product.name->React.string} </a>
              </Next.Link>
            </span>
            <span className=%twc("block text-gray-500 truncate underline")>
              <Next.Link href={`/admin/products/${productOption.product.id}/options`}>
                <a> {productOption.optionName->React.string} </a>
              </Next.Link>
            </span>
          </div>
          <div className=%twc("h-full flex flex-col px-4 py-2 ml-4")>
            <span className=%twc("whitespace-nowrap")>
              {`${productOption.price
                ->Option.map(p => p->Float.fromInt->Locale.Float.show(~digits=0))
                ->Option.getWithDefault("-")}원`->React.string}
            </span>
          </div>
          <div className=%twc("h-full flex flex-col px-4 py-2 ml-4")>
            <span className=%twc("block")>
              {productOption.product.category.item->Option.getWithDefault("")->React.string}
            </span>
            <span className=%twc("block text-gray-500")>
              {productOption.product.category.kind->Option.getWithDefault("")->React.string}
            </span>
          </div>
          <div className=%twc("h-full flex flex-col px-4 py-2 ml-4")>
            <span className=%twc("block")>
              {productOption.weight
              ->Option.mapWithDefault("", w =>
                `${w->Float.toString}${productOption.weightUnit->Option.mapWithDefault(
                    "",
                    weightUnitToString,
                  )}`
              )
              ->React.string}
            </span>
            <span className=%twc("block")>
              {switch (productOption.countPerPackageMin, productOption.countPerPackageMax) {
              | (Some(min), Some(max)) => `${min->Int.toString} ~ ${max->Int.toString}`
              | (Some(min), None) => `${min->Int.toString} ~`
              | (None, Some(max)) => `~ ${max->Int.toString}`
              | (None, None) => ""
              }->React.string}
            </span>
          </div>
          <div className=%twc("h-full flex flex-col px-4 py-2 ml-4")>
            <span className=%twc("block")>
              {
                let unit =
                  productOption.perWeightUnit->Option.mapWithDefault("", weightUnitToString)
                switch (productOption.perWeightMin, productOption.perWeightMax) {
                | (Some(min), Some(max)) => `${min->Float.toString} ~ ${max->Float.toString}${unit}`
                | (Some(min), None) => `${min->Float.toString} ~ ${unit}`
                | (None, Some(max)) => `~ ${max->Float.toString}${unit}`
                | (None, None) => ""
                }->React.string
              }
            </span>
            <span className=%twc("block")>
              {
                let unit = productOption.perSizeUnit->Option.mapWithDefault("", sizeUnitToString)
                switch (productOption.perSizeMin, productOption.perSizeMax) {
                | (Some(min), Some(max)) => `${min->Float.toString} ~ ${max->Float.toString}${unit}`
                | (Some(min), None) => `${min->Float.toString} ~ ${unit}`
                | (None, Some(max)) => `~ ${max->Float.toString}${unit}`
                | (None, None) => ""
                }->React.string
              }
            </span>
          </div>
          <div className=%twc("h-full flex flex-col px-4 py-2 ml-4")>
            <span className=%twc("block")>
              {productOption.grade->Option.getWithDefault("")->React.string}
            </span>
            <span className=%twc("block")>
              {productOption.packageType->Option.getWithDefault("")->React.string}
            </span>
          </div>
          <div className=%twc("h-full flex flex-col px-4 py-2 ml-4")>
            <span className=%twc("block")>
              {productOption.product.md->Option.mapWithDefault("", md => md.name)->React.string}
            </span>
          </div>
          <div className=%twc("h-full flex flex-col px-4 py-2 ml-4 ")>
            <span className=%twc("block truncate")>
              {productOption.cutOffTime->Option.getWithDefault("")->React.string}
            </span>
          </div>
          <div className=%twc("h-full flex flex-col px-4 py-2 ml-4")>
            <span className=%twc("block")>
              {productOption.memo->Option.getWithDefault("")->React.string}
            </span>
          </div>
        </li>
      </>
    }
  }
}

@react.component
let make = (~query) => {
  <Item.Table query />
}
