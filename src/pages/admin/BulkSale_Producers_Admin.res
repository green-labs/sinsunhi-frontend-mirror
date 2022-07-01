module Query = %relay(`
  query BulkSaleProducersAdminQuery(
    $progresses: [BulkSaleApplicationProgress!]
    $applicantNameMatch: String
    $businessNameMatch: String
    $farmAddressMatch: String
    $appliedDateGe: Date
    $appliedDateLe: Date
    $cropIds: [ID!]
    $productCategoryIds: [ID!]
    $productCategoryNameMatch: String
    $isTest: Boolean
    $staffIds: [ID!]
  ) {
    ...BulkSaleProducersAdminTotalSummaryFragment
    ...BulkSaleProducersAdminSearchSummaryFragment
      @arguments(
        progresses: $progresses
        applicantNameMatch: $applicantNameMatch
        businessNameMatch: $businessNameMatch
        farmAddressMatch: $farmAddressMatch
        appliedDateGe: $appliedDateGe
        appliedDateLe: $appliedDateLe
        cropIds: $cropIds
        productCategoryIds: $productCategoryIds
        productCategoryNameMatch: $productCategoryNameMatch
        isTest: $isTest
        staffIds: $staffIds
      )
    ...BulkSaleProducersListAdminFragment
      @arguments(
        progresses: $progresses
        applicantNameMatch: $applicantNameMatch
        businessNameMatch: $businessNameMatch
        farmAddressMatch: $farmAddressMatch
        appliedDateGe: $appliedDateGe
        appliedDateLe: $appliedDateLe
        cropIds: $cropIds
        productCategoryIds: $productCategoryIds
        productCategoryNameMatch: $productCategoryNameMatch
        isTest: $isTest
        staffIds: $staffIds
      )
  }
`)

module Fragment = {
  module Total = %relay(`
  fragment BulkSaleProducersAdminTotalSummaryFragment on Query
  @refetchable(queryName: "BulkSaleProducersAdminTotalSummaryRefetchQuery") {
    totalStatistics: bulkSaleApplicationStatistics {
      id
      count
      progressAppliedCount
      progressUnderDiscussionCount
      progressOnSiteMeetingScheduledCount
      progressConfirmedCount
      progressRejectedCount
      progressSampleRequestedCount
      progressSampleReviewingCount
      progressWithdrawnCount
    }
  }
`)
  module Search = %relay(`
  fragment BulkSaleProducersAdminSearchSummaryFragment on Query
  @refetchable(queryName: "BulkSaleProducersAdminSearchSummaryRefetchQuery")
  @argumentDefinitions(
    progresses: { type: "[BulkSaleApplicationProgress!]", defaultValue: null }
    applicantNameMatch: { type: "String", defaultValue: null }
    businessNameMatch: { type: "String", defaultValue: null }
    farmAddressMatch: { type: "String", defaultValue: null }
    appliedDateGe: { type: "Date", defaultValue: null }
    appliedDateLe: { type: "Date", defaultValue: null }
    cropIds: { type: "[ID!]", defaultValue: null }
    productCategoryIds: { type: "[ID!]", defaultValue: null }
    productCategoryNameMatch: { type: "String", defaultValue: null }
    isTest: { type: "Boolean", defaultValue: true }
    staffIds: { type: "[ID!]", defaultValue: null }
  ) {
    searchStatistics: bulkSaleApplicationStatistics(
      progresses: $progresses
      applicantNameMatch: $applicantNameMatch
      businessNameMatch: $businessNameMatch
      farmAddressMatch: $farmAddressMatch
      appliedDateGe: $appliedDateGe
      appliedDateLe: $appliedDateLe
      cropIds: $cropIds
      productCategoryIds: $productCategoryIds
      productCategoryNameMatch: $productCategoryNameMatch
      isTest: $isTest
      staffIds: $staffIds
    ) {
      id
      count
      progressAppliedCount
      progressUnderDiscussionCount
      progressOnSiteMeetingScheduledCount
      progressConfirmedCount
      progressRejectedCount
      progressSampleRequestedCount
      progressSampleReviewingCount
      progressWithdrawnCount
    }
  }
`)
}

let getRouterQuery = (router: Next.Router.router) => {
  let progresses =
    router.query
    ->Js.Dict.get("status")
    ->Option.flatMap(s =>
      if s == "APPLIED" {
        Some([#APPLIED])
      } else if s == "UNDER_DISCUSSION" {
        Some([#UNDER_DISCUSSION])
      } else if s == "ON_SITE_MEETING_SCHEDULED" {
        Some([#ON_SITE_MEETING_SCHEDULED])
      } else if s == "SAMPLE_REQUESTED" {
        Some([#SAMPLE_REQUESTED])
      } else if s == "SAMPLE_REVIEWING" {
        Some([#SAMPLE_REVIEWING])
      } else if s == "REJECTED" {
        Some([#REJECTED])
      } else if s == "CONFIRMED" {
        Some([#CONFIRMED])
      } else if s == "WITHDRAWN" {
        Some([#WITHDRAWN])
      } else {
        None
      }
    )

  let applicantName =
    router.query->Js.Dict.get("applicant-name")->Option.flatMap(x => x === "" ? None : Some(x))
  let businessName =
    router.query->Js.Dict.get("business-name")->Option.flatMap(x => x === "" ? None : Some(x))
  let farmAddress =
    router.query->Js.Dict.get("farm-address")->Option.flatMap(x => x === "" ? None : Some(x))
  let cropId = router.query->Js.Dict.get("crop-id")->Option.flatMap(x => x === "" ? None : Some(x))
  let productCategoryId =
    router.query->Js.Dict.get("product-category-id")->Option.flatMap(x => x === "" ? None : Some(x))
  let appliedDateGe =
    router.query
    ->Js.Dict.get("from")
    ->Option.mapWithDefault("20220124", x => x === "" ? "20220124" : x)
    ->Some
  let appliedDateLe =
    router.query
    ->Js.Dict.get("to")
    ->Option.mapWithDefault(Js.Date.make()->DateFns.format("yyyyMMdd"), x =>
      x === "" ? Js.Date.make()->DateFns.format("yyyyMMdd") : x
    )
    ->Some
  let staffId =
    router.query
    ->Js.Dict.get("staff-id")
    ->Option.flatMap(x => x === "" ? None : Some(x === "" ? [] : [x]))
  let isTest =
    router.query
    ->Js.Dict.get("is-test")
    ->Option.mapWithDefault(None, x => x->bool_of_string ? Some(false) : None)

  (
    progresses,
    applicantName,
    businessName,
    farmAddress,
    productCategoryId->Option.mapWithDefault(
      cropId->Option.mapWithDefault(None, x => Some([x])),
      _ => None,
    ),
    productCategoryId->Option.mapWithDefault(None, x => Some([x])),
    appliedDateGe,
    appliedDateLe,
    staffId,
    isTest,
  )
}

module List = {
  @react.component
  let make = (~query, ~refetchSummary, ~statistics) => {
    <div className=%twc("p-7 m-4 shadow-gl overflow-auto overflow-x-scroll bg-white rounded")>
      <BulkSale_Producers_List_Admin query refetchSummary statistics />
    </div>
  }
}

module SummaryAndList = {
  @react.component
  let make = (~query) => {
    let router = Next.Router.useRouter()
    let (queryTatalData, refetchTotal) = Fragment.Total.useRefetchable(query)
    let (querySearchData, refetchSearch) = Fragment.Search.useRefetchable(query)

    let refetchSummary = () => {
      let (
        progresses,
        applicantName,
        businessName,
        farmAddress,
        cropId,
        productCategoryId,
        appliedDateGe,
        appliedDateLe,
        staffIds,
        isTest,
      ) = getRouterQuery(router)

      let searchInput: BulkSaleProducersAdminSearchSummaryRefetchQuery_graphql.Types.refetchVariables = {
        progresses: progresses,
        applicantNameMatch: applicantName,
        businessNameMatch: businessName,
        farmAddressMatch: farmAddress,
        cropIds: cropId,
        productCategoryIds: productCategoryId,
        productCategoryNameMatch: None,
        appliedDateGe: appliedDateGe,
        appliedDateLe: appliedDateLe,
        isTest: isTest,
        staffIds: staffIds,
      }

      refetchTotal(~variables=(), ~fetchPolicy=RescriptRelay.StoreAndNetwork, ())->ignore
      refetchSearch(~variables=searchInput, ~fetchPolicy=RescriptRelay.StoreAndNetwork, ())->ignore
    }

    <>
      <Summary_BulkSale_Producers_Admin summary={queryTatalData.totalStatistics} />
      <List query refetchSummary statistics={querySearchData.searchStatistics} />
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
          {j`생산자 소싱 관리`->React.string}
        </h1>
      </header>
      <Summary_BulkSale_Producers_Admin.Skeleton />
      <div className=%twc("p-7 m-4 shadow-gl overflow-auto overflow-x-scroll bg-white rounded")>
        <BulkSale_Producers_List_Admin.Skeleton />
      </div>
    </div>
}

module Producers = {
  @react.component
  let make = () => {
    let router = Next.Router.useRouter()
    let (
      progresses,
      applicantName,
      businessName,
      farmAddress,
      cropId,
      productCategoryId,
      appliedDateGe,
      appliedDateLe,
      staffIds,
      isTest,
    ) = getRouterQuery(router)

    let searchInput: Query.Types.variables = {
      progresses: progresses,
      applicantNameMatch: applicantName,
      businessNameMatch: businessName,
      farmAddressMatch: farmAddress,
      cropIds: cropId,
      productCategoryIds: productCategoryId,
      productCategoryNameMatch: None,
      appliedDateGe: appliedDateGe,
      appliedDateLe: appliedDateLe,
      isTest: isTest,
      staffIds: staffIds,
    }

    let queryData = Query.use(~variables=searchInput, ())

    <div
      className=%twc(
        "max-w-gnb-panel overflow-auto overflow-x-scroll bg-div-shape-L1 min-h-gnb-admin"
      )>
      <header className=%twc("flex items-baseline p-7 pb-0")>
        <h1 className=%twc("text-text-L1 text-xl font-bold")>
          {j`생산자 소싱 관리`->React.string}
        </h1>
      </header>
      <SummaryAndList query={queryData.fragmentRefs} />
    </div>
  }
}

@react.component
let make = () => {
  <Authorization.Admin title=`생산자 소싱 관리`>
    // TODO: 에러 표시 컴포넌트 필요
    <RescriptRelay.Context.Provider environment=RelayEnv.envFMBridge>
      <RescriptReactErrorBoundary fallback={_ => <div> {j`에러 발생`->React.string} </div>}>
        <React.Suspense fallback={<Skeleton />}> <Producers /> </React.Suspense>
      </RescriptReactErrorBoundary>
    </RescriptRelay.Context.Provider>
  </Authorization.Admin>
}
