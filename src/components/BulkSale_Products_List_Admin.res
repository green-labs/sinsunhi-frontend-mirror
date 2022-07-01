module Fragment = %relay(`
  fragment BulkSaleProductsListAdminFragment on Query
  @refetchable(queryName: "BulkSaleProductsListAdminRefetchQuery")
  @argumentDefinitions(
    isOpen: { type: "Boolean", defaultValue: null }
    orderBy: { type: "BulkSaleCampaignOrderBy", defaultValue: CREATED_AT }
    orderDirection: { type: "OrderDirection", defaultValue: DESC }
    first: { type: "Int", defaultValue: 25 }
    after: { type: "ID", defaultValue: null }
  ) {
    bulkSaleCampaigns(
      first: $first,
      after: $after,
      isOpen: $isOpen,
      orderBy: $orderBy,
      orderDirection: $orderDirection
    )
      @connection(key: "BulkSaleProductsListAdmin_bulkSaleCampaigns") {
      __id
      count
      edges {
        cursor
        node {
          ...BulkSaleProductAdminFragment_bulkSaleCampaign
        }
      }
      pageInfo {
        startCursor
        endCursor
        hasNextPage
        hasPreviousPage
      }
    }
  }
`)

module Header = {
  @react.component
  let make = () =>
    <div
      className=%twc(
        "grid grid-cols-7-admin-bulk-sale-product bg-gray-50 text-gray-500 h-12 divide-y divide-gray-100"
      )>
      <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
        {j`생성일자`->React.string}
      </div>
      <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
        {j`상태`->React.string}
      </div>
      <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
        {j`작물`->React.string}
      </div>
      <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
        {j`적정 구매가격`->React.string}
      </div>
      <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
        {j`노출단위`->React.string}
      </div>
      <div className=%twc("col-span-2 h-full px-4 flex items-center whitespace-nowrap")>
        {j`추가비율`->React.string}
      </div>
    </div>
}

module Loading = {
  @react.component
  let make = () =>
    <div className=%twc("w-full overflow-x-scroll")>
      <div className=%twc("min-w-max text-sm")>
        <Header />
        <ol
          className=%twc(
            "divide-y divide-gray-100 lg:list-height-admin-bulk-sale lg:overflow-y-scroll"
          )>
          {Garter.Array.make(5, 0)
          ->Garter.Array.map(_ => <Order_Admin.Item.Table.Loading />)
          ->React.array}
        </ol>
      </div>
    </div>
}

module Skeleton = {
  @react.component
  let make = () => <>
    <div className=%twc("md:flex md:justify-between pb-4")>
      <div className=%twc("flex flex-auto justify-between h-8")>
        <h3 className=%twc("flex text-lg font-bold")>
          {j`내역`->React.string} <Skeleton.Box className=%twc("ml-1 w-10") />
        </h3>
        <Skeleton.Box className=%twc("w-28") />
      </div>
    </div>
    <div className=%twc("w-full overflow-x-scroll")>
      <div className=%twc("min-w-max text-sm")>
        <div
          className=%twc(
            "grid grid-cols-7-admin-bulk-sale-product bg-gray-50 text-gray-500 h-12 divide-y divide-gray-100"
          )
        />
        <span className=%twc("w-full h-[500px] flex items-center justify-center")>
          {`로딩중..`->React.string}
        </span>
      </div>
    </div>
  </>
}

module List = {
  @react.component
  let make = (
    ~query,
    ~refetchSummary,
    ~statistics: BulkSaleProductsAdminSummaryFragment_graphql.Types.fragment_bulkSaleCampaignStatistics,
  ) => {
    let router = Next.Router.useRouter()
    let queried =
      router.query
      ->Js.Dict.get("status")
      ->Option.flatMap(status =>
        switch status->Js.Json.string->Status_BulkSale_Product.status_decode {
        | Ok(status') => Some(status')
        | Error(_) => None
        }
      )
    let count = switch queried {
    | Some(OPEN) => statistics.openCount
    | Some(ENDED) => statistics.notOpenCount
    | Some(RESERVED)
    | Some(CANCELED) => 0
    | None => statistics.count // 전체를 선택한 경우
    }

    let listContainerRef = React.useRef(Js.Nullable.null)
    let loadMoreRef = React.useRef(Js.Nullable.null)
    let {data, hasNext, isLoadingNext, loadNext} = Fragment.usePagination(query)

    let isIntersecting = CustomHooks.IntersectionObserver.use(
      ~target=loadMoreRef,
      ~root=listContainerRef,
      ~rootMargin="50px",
      ~thresholds=0.1,
      (),
    )

    React.useEffect1(_ => {
      if hasNext && isIntersecting {
        loadNext(~count=5, ())->ignore
      }

      None
    }, [hasNext, isIntersecting])

    <>
      <div className=%twc("md:flex md:justify-between pb-4")>
        <div className=%twc("flex flex-auto justify-between")>
          <h3 className=%twc("text-lg font-bold")>
            {j`내역`->React.string}
            <span className=%twc("text-base ml-1 text-green-gl font-normal")>
              {j`${count->Int.toString}건`->React.string}
            </span>
          </h3>
          <div className=%twc("flex")>
            <BulkSale_Product_Create_Button
              connectionId=data.bulkSaleCampaigns.__id refetchSummary
            />
          </div>
        </div>
      </div>
      <div className=%twc("w-full overflow-x-scroll")>
        <div className=%twc("min-w-max text-sm")>
          <Header />
          <ol
            ref={ReactDOM.Ref.domRef(listContainerRef)}
            className=%twc(
              "divide-y divide-gray-100 lg:list-height-admin-bulk-sale lg:overflow-y-scroll"
            )>
            {data.bulkSaleCampaigns.edges
            ->Array.map(edge => {
              <BulkSale_Product_Admin node=edge.node refetchSummary />
            })
            ->React.array}
            {isLoadingNext ? <div> {j`로딩중...`->React.string} </div> : React.null}
            <div ref={ReactDOM.Ref.domRef(loadMoreRef)} className=%twc("h-5") />
          </ol>
        </div>
      </div>
    </>
  }
}

@react.component
let make = (~query, ~refetchSummary, ~statistics) => {
  <List query refetchSummary statistics />
}
