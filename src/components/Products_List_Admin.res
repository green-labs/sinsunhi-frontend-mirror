module Fragment = %relay(`
  fragment ProductsListAdminFragment on Query
  @argumentDefinitions(
    sort: { type: "ProductsQueryInputSort!" }
    limit: { type: "Int", defaultValue: 25 }
    name: { type: "String" }
    isDelivery: { type: "Boolean" }
    offset: { type: "Int" }
    producerName: { type: "String" }
    producerCodes: { type: "[String!]" }
    productNos: { type: "[Int!]" }
    productCategoryId: { type: "ID" }
    displayCategoryId: { type: "ID" }
    statuses: { type: "[ProductStatus!]" }
    type: { type: "[ProductType!]" }
  ) {
    products(
      sort: $sort
      first: $limit
      name: $name
      isCourierAvailable: $isDelivery
      offset: $offset
      producerName: $producerName
      producerCodes: $producerCodes
      productNos: $productNos
      statuses: $statuses
      displayCategoryId: $displayCategoryId
      categoryId: $productCategoryId
      type: $type
    ) {
      edges {
        node {
          id
          ...ProductAdminFragment
        }
      }
      pageInfo {
        hasNextPage
        hasPreviousPage
      }
      totalCount
    }
  }
`)

module Skeleton = {
  @react.component
  let make = () => {
    <>
      <div className=%twc("md:flex md:justify-between pb-4")>
        <div className=%twc("flex flex-auto items-center justify-between h-8")>
          <h3 className=%twc("text-lg font-bold")> {j`내역`->React.string} </h3>
          <Skeleton.Box className=%twc("w-32") />
        </div>
      </div>
      <div className=%twc("w-full overflow-x-scroll")>
        <div className=%twc("min-w-max text-sm")>
          <div className=%twc("bg-gray-50 h-12 divide-y divide-gray-100") />
          <span className=%twc("w-full h-[500px] flex items-center justify-center")>
            {`로딩중..`->React.string}
          </span>
        </div>
      </div>
    </>
  }
}

@react.component
let make = (~query) => {
  let router = Next.Router.useRouter()
  let {products} = Fragment.use(query)

  let limit =
    router.query->Js.Dict.get("limit")->Option.flatMap(Int.fromString)->Option.getWithDefault(25)

  <>
    <div className=%twc("w-full overflow-x-scroll")>
      <div className=%twc("min-w-max text-sm divide-y divide-gray-100")>
        <div className=%twc("grid grid-cols-9-admin-product bg-gray-100 text-gray-500 h-12")>
          <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
            {j`판매상태`->React.string}
          </div>
          <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
            {j`상품 유형`->React.string}
          </div>
          <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
            {j`상품명·상품번호`->React.string}
          </div>
          <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
            {j`단품정보`->React.string}
          </div>
          <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
            {j`생산자·생산자번호`->React.string}
          </div>
          <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
            {j`표준카테고리`->React.string}
          </div>
          <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
            {j`전시카테고리`->React.string}
          </div>
          <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
            {j`바이어판매가`->React.string}
          </div>
          <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
            {j`택배여부`->React.string}
          </div>
        </div>
        <ol
          className=%twc(
            "divide-y divide-gray-100 lg:list-height-admin-buyer lg:overflow-y-scroll"
          )>
          {products.edges
          ->Array.map(({node: product}) =>
            <Product_Admin query={product.fragmentRefs} key={product.id} />
          )
          ->React.array}
        </ol>
      </div>
    </div>
    <div className=%twc("flex justify-center pt-5")>
      React.null
      <Pagination
        pageDisplySize=Constants.pageDisplySize itemPerPage={limit} total=products.totalCount
      />
    </div>
  </>
}
