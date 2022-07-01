module Query = %relay(`
  query BulkSaleProductsAdminQuery(
    $isOpen: Boolean,
    $orderBy: BulkSaleCampaignOrderBy,
    $orderDirection: OrderDirection
  ) {
    ...BulkSaleProductsAdminSummaryFragment
    ...BulkSaleProductsListAdminFragment @arguments(
      isOpen: $isOpen,
      orderBy: $orderBy,
      orderDirection: $orderDirection
    )
  }
`)

module Fragment = %relay(`
  fragment BulkSaleProductsAdminSummaryFragment on Query
  @refetchable(queryName: "BulkSaleProductsAdminSummaryRefetchQuery") {
    bulkSaleCampaignStatistics {
      id
      count
      openCount
      notOpenCount
    }
  }
`)

module List = {
  @react.component
  let make = (~query, ~refetchSummary, ~statistics) => {
    <div className=%twc("p-7 m-4 shadow-gl overflow-auto overflow-x-scroll bg-white rounded")>
      <BulkSale_Products_List_Admin query refetchSummary statistics />
    </div>
  }
}

module SummaryAndList = {
  @react.component
  let make = (~query) => {
    let (queryData, refetch) = Fragment.useRefetchable(query)

    let refetchSummary = () =>
      refetch(~variables=(), ~fetchPolicy=RescriptRelay.StoreAndNetwork, ())->ignore

    let statistics = queryData.bulkSaleCampaignStatistics

    <>
      <Summary_BulkSale_Products_Admin summary={queryData.bulkSaleCampaignStatistics} />
      <List query refetchSummary statistics />
    </>
  }
}

module Skeleton = {
  @react.component
  let make = () =>
    <div
      className=%twc(
        "max-w-gnb-panel overflow-auto overflow-x-scroll bg-div-shape-L1 min-h-gnb-admin"
      )>
      <header className=%twc("flex items-baseline p-7 pb-0")>
        <h1 className=%twc("text-text-L1 text-xl font-bold")>
          {j`소싱 상품 등록/수정`->React.string}
        </h1>
      </header>
      <Summary_BulkSale_Products_Admin.Skeleton />
      <div className=%twc("p-7 m-4 shadow-gl overflow-auto overflow-x-scroll bg-white rounded")>
        <BulkSale_Products_List_Admin.Skeleton />
      </div>
    </div>
}

module Products = {
  @react.component
  let make = () => {
    let router = Next.Router.useRouter()
    let isOpen =
      router.query
      ->Js.Dict.get("status")
      ->Option.flatMap(s =>
        if s == "open" {
          Some(true)
        } else if s == "ended" {
          Some(false)
        } else {
          None
        }
      )

    let queryData = Query.use(
      ~variables={isOpen: isOpen, orderBy: Some(#CREATED_AT), orderDirection: Some(#DESC)},
      (),
    )

    <div
      className=%twc(
        "max-w-gnb-panel overflow-auto overflow-x-scroll bg-div-shape-L1 min-h-gnb-admin"
      )>
      <header className=%twc("flex items-baseline p-7 pb-0")>
        <h1 className=%twc("text-text-L1 text-xl font-bold")>
          {j`소싱 상품 등록/수정`->React.string}
        </h1>
      </header>
      <SummaryAndList query={queryData.fragmentRefs} />
    </div>
  }
}

@react.component
let make = () =>
  <Authorization.Admin title=`소싱 상품 등록/수정`>
    <RescriptRelay.Context.Provider environment=RelayEnv.envFMBridge>
      <RescriptReactErrorBoundary fallback={_ => <div> {`에러 발생`->React.string} </div>}>
        <React.Suspense fallback={<Skeleton />}> <Products /> </React.Suspense>
      </RescriptReactErrorBoundary>
    </RescriptRelay.Context.Provider>
  </Authorization.Admin>
