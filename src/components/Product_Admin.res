module Fragment = %relay(`
  fragment ProductAdminFragment on Product {
    id
    displayName
    productId
    isCourierAvailable
    price
    _type: type
    producer {
      producerCode
      name
    }
    displayCategories {
      id
      fullyQualifiedName {
        name
      }
    }
    productOptions {
      edges {
        node {
          id
        }
      }
    }
    category {
      fullyQualifiedName {
        name
      }
    }
    ...ProductOperationStatusBadge
  }
`)

module Product_Option_Link_Button = {
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
let make = (~query) => {
  let product = Fragment.use(query)

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
        {switch product._type {
        | #QUOTED => `견적 상품`
        | #QUOTABLE => `일반+견적 상품`
        | #NORMAL
        | _ => `일반 상품`
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
        {switch product._type {
        | #QUOTED =>
          <button
            className={cx([
              %twc(
                "max-w-min  py-0.5 px-2 rounded mr-2 whitespace-nowrap text-disabled-L2 bg-gray-gl"
              ),
            ])}>
            {`추가하기`->React.string}
          </button>
        | _ =>
          <Product_Option_Link_Button
            productId={product.id}
            isOptionEmpty={product.productOptions.edges->Garter.Array.isEmpty}
          />
        }}
      </div>
      <div className=%twc("h-full flex flex-col px-4 py-2")>
        <span className=%twc("block")>
          {`${product.producer.name}(${product.producer.producerCode->Option.getWithDefault(
              "",
            )})`->React.string}
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
          {product.price
          ->Option.map(p => p->Int.toFloat->Locale.Float.show(~digits=0) ++ `원`)
          ->Option.getWithDefault("-")
          ->React.string}
        </span>
      </div>
      <div className=%twc("h-full flex flex-col px-4 pl-9 py-2")>
        <span className=%twc("block")>
          {switch product._type {
          | #QUOTED => `-`->React.string
          | _ => (product.isCourierAvailable ? `가능` : `불가능`)->React.string
          }}
        </span>
      </div>
    </li>
  </>
}
