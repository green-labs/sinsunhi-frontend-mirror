module Fragment = %relay(`
  fragment ProductOptionListAdminFragment on Query
  @refetchable(queryName: "ProductOptionListAdminFragmentRefetchQuery")
  @argumentDefinitions(
    sort: { type: "ProductOptionSort", defaultValue: SKU_DESC }
    limit: { type: "Int", defaultValue: 25 }
    offset: { type: "Int" }
    producerName: { type: "String" }
    status: { type: "ProductOptionStatus" }
    productName: { type: "String" }
    categoryId: { type: "Int" }
  ) {
    productOptions(
      sort: $sort
      first: $limit
      offset: $offset
      producerName: $producerName
      productOptionStatus: $status
      productName: $productName
      categoryId: $categoryId
    ) {
      edges {
        node {
          id
          ...ProductOptionAdminFragment
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
  let {productOptions} = Fragment.use(query)
  let router = Next.Router.useRouter()

  let limit =
    router.query->Js.Dict.get("limit")->Option.flatMap(Int.fromString)->Option.getWithDefault(25)

  <>
    <div className=%twc("w-full overflow-x-scroll")>
      <div className=%twc("min-w-max text-sm divide-y divide-gray-100")>
        <div className=%twc("grid grid-cols-15-admin-product bg-gray-100 text-gray-500 h-12")>
          <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
            {j`판매상태`->React.string}
          </div>
          <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
            {j`생산자명`->React.string}
          </div>
          <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
            {j`상품번호·단품번호`->React.string}
          </div>
          <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
            {j`상품명·단품명`->React.string}
          </div>
          <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
            {j`현재 판매가`->React.string}
          </div>
          <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
            {j`작물명·품종명`->React.string}
          </div>
          <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
            {j`중량·입수(박스당)`->React.string}
          </div>
          <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
            {j`개당 무게·크기`->React.string}
          </div>
          <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
            {j`등급·포장규격`->React.string}
          </div>
          <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
            {j`담당소싱MD`->React.string}
          </div>
          <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
            {j`출고기준시간`->React.string}
          </div>
          <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
            {j`메모`->React.string}
          </div>
        </div>
        <ol
          className=%twc(
            "divide-y divide-gray-100 lg:list-height-admin-buyer lg:overflow-y-scroll"
          )>
          {productOptions.edges->Garter.Array.isEmpty
            ? <EmptyProducts />
            : productOptions.edges
              ->Garter.Array.map(edge => {
                <Product_Option_Admin key=edge.node.id query={edge.node.fragmentRefs} />
              })
              ->React.array}
        </ol>
      </div>
    </div>
    <div className=%twc("flex justify-center pt-5")>
      React.null
      <Pagination
        pageDisplySize=Constants.pageDisplySize itemPerPage=limit total=productOptions.totalCount
      />
    </div>
  </>
}
