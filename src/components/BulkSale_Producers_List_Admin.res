module Fragment = %relay(`
  fragment BulkSaleProducersListAdminFragment on Query
  @refetchable(queryName: "BulkSaleProducersListAdminRefetchQuery")
  @argumentDefinitions(
    progresses: { type: "[BulkSaleApplicationProgress!]", defaultValue: null }
    first: { type: "Int", defaultValue: 25 }
    after: { type: "ID", defaultValue: null }
    orderBy: { type: "BulkSaleApplicationOrderBy", defaultValue: CREATED_AT }
    orderDirection: { type: "OrderDirection", defaultValue: DESC }
    applicantNameMatch: { type: "String", defaultValue: null }
    businessNameMatch: { type: "String", defaultValue: null }
    farmAddressMatch: { type: "String", defaultValue: null }
    appliedDateGe: { type: "Date", defaultValue: null }
    appliedDateLe: { type: "Date", defaultValue: null }
    cropIds: { type: "[ID!]", defaultValue: null }
    productCategoryIds: { type: "[ID!]", defaultValue: null }
    productCategoryNameMatch: { type: "String", defaultValue: null }
    isTest: { type: "Boolean", defaultValue: null }
    staffIds: { type: "[ID!]", defaultValue: null }
  ) {
    bulkSaleApplications(
      first: $first
      after: $after
      progresses: $progresses
      orderBy: $orderBy
      orderDirection: $orderDirection
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
    ) @connection(key: "BulkSaleProducersListAdmin_bulkSaleApplications") {
      __id
      count
      edges {
        cursor
        node {
          ...BulkSaleProducerAdminFragment_bulkSaleApplication
        }
      }
      pageInfo {
        endCursor
        hasNextPage
        hasPreviousPage
        startCursor
      }
    }
  }
`)

module Header = {
  @react.component
  let make = () =>
    <div
      className=%twc(
        "grid grid-cols-11-admin-bulk-sale-producers bg-gray-50 text-gray-500 h-12 divide-y divide-gray-100"
      )>
      <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
        {j`생성일자`->React.string}
      </div>
      <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
        {j`상태`->React.string}
      </div>
      <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
        {j`담당자`->React.string}
      </div>
      <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
        {j`작물`->React.string}
      </div>
      <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
        {j`예상판매가`->React.string}
      </div>
      <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
        {j`생산자정보`->React.string}
      </div>
      <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
        {j`농사 경력/판매량`->React.string}
      </div>
      <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
        {j`구분`->React.string}
      </div>
      <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
        {j`시장출하 여부`->React.string}
      </div>
      <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
        {j`온라인판매 여부`->React.string}
      </div>
      <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
        {j`메모`->React.string}
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

external unsafeAsFile: Fetch.blob => Webapi.File.t = "%identity"

module List = {
  @react.component
  let make = (
    ~query,
    ~refetchSummary,
    ~statistics: BulkSaleProducersAdminSearchSummaryFragment_graphql.Types.fragment_searchStatistics,
  ) => {
    let router = Next.Router.useRouter()
    let queried =
      router.query
      ->Js.Dict.get("status")
      ->Option.flatMap(status =>
        switch status->Js.Json.string->Status_BulkSale_Producer.status_decode {
        | Ok(status') => Some(status')
        | Error(_) => None
        }
      )

    let count = switch queried {
    | Some(APPLIED) => statistics.progressAppliedCount
    | Some(UNDER_DISCUSSION) => statistics.progressUnderDiscussionCount
    | Some(ON_SITE_MEETING_SCHEDULED) => statistics.progressOnSiteMeetingScheduledCount
    | Some(SAMPLE_REQUESTED) => statistics.progressSampleRequestedCount
    | Some(SAMPLE_REVIEWING) => statistics.progressSampleReviewingCount
    | Some(REJECTED) => statistics.progressRejectedCount
    | Some(CONFIRMED) => statistics.progressConfirmedCount
    | Some(WITHDRAWN) => statistics.progressWithdrawnCount
    | None => statistics.count
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

    let download = () => {
      let progress =
        router.query
        ->Js.Dict.get("status")
        ->Option.mapWithDefault("ALL", status => status->Js.String2.toUpperCase)

      FetchHelper.requestWithRetry(
        ~fetcher=FetchHelper.getWithTokenForExcel,
        ~url=`${Env.restApiUrl}/farmmorning-bridge/api/bulk-sale/bulk-sale-applications/export/excel?progress=${progress}`,
        ~body="",
        ~count=3,
        ~onSuccess={
          res => {
            let headers = res->Fetch.Response.headers
            let filename =
              (headers |> Fetch.Headers.get("Content-Disposition"))
              ->Option.flatMap(Helper.Filename.parseFilename)
              ->Option.map(Js.Global.decodeURIComponent)
              ->Option.getWithDefault(
                `${Js.Date.make()->DateFns.format("yyyyMMdd")}_주문서.xlsx`,
              )

            (res->Fetch.Response.blob
            |> Js.Promise.then_(blob => {
              open Webapi
              let anchor = Dom.document->Dom.Document.createElement("a")->Dom.Element.asHtmlElement
              let body =
                Dom.document->Dom.Document.asHtmlDocument->Option.flatMap(Dom.HtmlDocument.body)

              Helper.Option.map2(body, anchor, (body', anchor') => {
                let url = Url.createObjectURL(blob->unsafeAsFile)
                anchor'->Dom.HtmlElement.setAttribute("href", url)
                anchor'->Dom.HtmlElement.setAttribute("download", filename)
                anchor'->Dom.HtmlElement.setAttribute("style", "{display: none;}")
                body'->Dom.Element.appendChild(~child=anchor')
                anchor'->Dom.HtmlElement.click
                let _ = body'->Dom.Element.removeChild(~child=anchor')
                Url.revokeObjectURL(url)
              })->ignore

              Js.Promise.resolve(blob)
            })
            |> Js.Promise.catch(err => {
              err->Js.Console.log
              Js.Promise.reject(Js.Exn.raiseError(`파일을 다운로드 할 수 없습니다.`))
            }))->ignore
          }
        },
        ~onFailure={
          err => err->Js.Console.log
        },
      )->ignore
    }

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
            <button
              className=%twc(
                "btn-level6-small px-3 py-1 flex justify-center items-center text-[15px]"
              )
              onClick={_ => download()}>
              <IconDownloadCenter width="20" height="20" fill="#262626" className=%twc("mr-1") />
              {j`엑셀 다운로드`->React.string}
            </button>
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
            {data.bulkSaleApplications.edges
            ->Array.map(edge => {
              <BulkSale_Producer_Admin key={edge.cursor} node=edge.node refetchSummary />
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
