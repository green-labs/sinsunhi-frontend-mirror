module Fragment = %relay(`
  fragment ProductAdminFragment on Product {
    id
    displayName
    productId
  
    ... on QuotableProduct {
      producer {
        producerCode
        name
      }
    }
  
    ... on NormalProduct {
      producer {
        producerCode
        name
      }
    }
  
    ... on QuotedProduct {
      producer {
        producerCode
        name
      }
    }
  
    displayCategories {
      id
      fullyQualifiedName {
        name
      }
    }
  
    category {
      fullyQualifiedName {
        name
      }
    }
    ...ProductOperationStatusBadge
    ...ProductAdminTypedProductFragment
  }
`)

module TypedProductFragment = %relay(`
  fragment ProductAdminTypedProductFragment on Product {
    ... on MatchingProduct {
      id
    }
    ... on QuotedProduct {
      id
    }
    ... on QuotableProduct {
      id
      isCourierAvailable
      price
      productOptions {
        edges {
          node {
            id
          }
        }
      }
    }
  
    ... on NormalProduct {
      id
      isCourierAvailable
      price
      productOptions {
        edges {
          node {
            id
          }
        }
      }
    }
  }
`)

module Product_Option_Link_Button = {
  module Link_Button = {
    @react.component
    let make = (~productId, ~isOptionEmpty) => {
      let defaultStyle = %twc("max-w-min  py-0.5 px-2 rounded mr-2 whitespace-nowrap")

      {
        switch isOptionEmpty {
        | true =>
          <Next.Link href={`/admin/products/${productId}/create-options`}>
            <button className={cx([defaultStyle, %twc("text-gray-gl bg-gray-gl")])}>
              {`추가하기`->React.string}
            </button>
          </Next.Link>
        | false =>
          <Next.Link href={`/admin/products/${productId}/options`}>
            <button className={cx([defaultStyle, %twc("bg-green-gl-light text-green-gl")])}>
              {`조회하기`->React.string}
            </button>
          </Next.Link>
        }
      }
    }
  }
  @react.component
  let make = (~typedProduct: ProductAdminTypedProductFragment_graphql.Types.fragment) => {
    switch typedProduct {
    | #MatchingProduct(_)
    | #QuotedProduct(_) =>
      <button
        className={cx([
          %twc("max-w-min  py-0.5 px-2 rounded mr-2 whitespace-nowrap text-disabled-L2 bg-gray-gl"),
        ])}>
        {`추가하기`->React.string}
      </button>
    | #QuotableProduct(quotableProduct) =>
      <Link_Button
        productId={quotableProduct.id}
        isOptionEmpty={quotableProduct.productOptions.edges->Garter.Array.isEmpty}
      />
    | #NormalProduct(normalProduct) =>
      <Link_Button
        productId={normalProduct.id}
        isOptionEmpty={normalProduct.productOptions.edges->Garter.Array.isEmpty}
      />
    | #UnselectedUnionMember(_) => React.null
    }
  }
}

@react.component
let make = (~query) => {
  let product = Fragment.use(query)
  let typedProduct = TypedProductFragment.use(product.fragmentRefs)

  let displayCategoriesToTextes = (
    categories: array<ProductAdminFragment_graphql.Types.fragment_displayCategories>,
  ) =>
    categories->Array.map(({id, fullyQualifiedName}) => (
      id,
      Garter.Array.joinWith(fullyQualifiedName, " > ", f => f.name),
    ))

  let productCategoryText = (category: ProductAdminFragment_graphql.Types.fragment_category) =>
    category.fullyQualifiedName->Garter.Array.joinWith(" > ", f => f.name)

  <>
    <li className=%twc("grid grid-cols-9-admin-product text-gray-700")>
      <div className=%twc("h-full flex flex-col px-4 py-2")>
        <Product_Operation_Status_Badge query={product.fragmentRefs} />
      </div>
      <div className=%twc("h-full flex flex-col px-4 py-2")>
        {switch typedProduct {
        | #NormalProduct(_) => `일반 상품`
        | #QuotableProduct(_) => `일반+견적 상품`
        | #QuotedProduct(_) => `견적 상품`
        | #MatchingProduct(_) => `매칭 상품`
        | #UnselectedUnionMember(_) => ``
        }->React.string}
      </div>
      <div className=%twc("h-full flex flex-col px-4 py-2")>
        <Next.Link href={`/admin/products/${product.id}`}>
          <a className=%twc("underline")>
            {`${product.displayName}(${product.productId->Int.toString})`->React.string}
          </a>
        </Next.Link>
      </div>
      <div className=%twc("h-full flex flex-col px-4 py-2")>
        <Product_Option_Link_Button typedProduct />
      </div>
      <div className=%twc("h-full flex flex-col px-4 py-2")>
        <span className=%twc("block")>
          {product.producer
          ->Option.mapWithDefault("-", ({name, producerCode}) => {
            `${name}(${producerCode->Option.getWithDefault("")})`
          })
          ->React.string}
        </span>
      </div>
      <div className=%twc("h-full flex flex-col px-4 py-2")>
        <span className=%twc("block")> {product.category->productCategoryText->React.string} </span>
      </div>
      <div className=%twc("h-full flex flex-col px-4 py-2")>
        <span className=%twc("block")>
          {product.displayCategories
          ->displayCategoriesToTextes
          ->Array.map(((id, dCategories)) => {
            <p key={id}> {dCategories->React.string} </p>
          })
          ->React.array}
        </span>
      </div>
      <div className=%twc("h-full flex flex-col px-4 pl-8 py-2")>
        <span className=%twc("block")>
          {switch typedProduct {
          | #QuotableProduct(p) =>
            p.price->Option.map(p' => p'->Int.toFloat->Locale.Float.show(~digits=0) ++ `원`)
          | #NormalProduct(p) =>
            p.price->Option.map(p' => p'->Int.toFloat->Locale.Float.show(~digits=0) ++ `원`)
          | #QuotedProduct(_)
          | #MatchingProduct(_)
          | #UnselectedUnionMember(_) =>
            None
          }
          ->Option.getWithDefault(`-`)
          ->React.string}
        </span>
      </div>
      <div className=%twc("h-full flex flex-col px-4 pl-9 py-2")>
        <span className=%twc("block")>
          {switch typedProduct {
          | #QuotableProduct(p) => p.isCourierAvailable ? `가능` : `불가능`
          | #NormalProduct(p) => p.isCourierAvailable ? `가능` : `불가능`
          | #QuotedProduct(_)
          | #MatchingProduct(_)
          | #UnselectedUnionMember(_) => `-`
          }->React.string}
        </span>
      </div>
    </li>
  </>
}
