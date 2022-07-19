@spice
type status =
  | @spice.as("APPLIED") APPLIED
  | @spice.as("UNDER_DISCUSSION") UNDER_DISCUSSION
  | @spice.as("ON_SITE_MEETING_SCHEDULED") ON_SITE_MEETING_SCHEDULED
  | @spice.as("SAMPLE_REQUESTED") SAMPLE_REQUESTED
  | @spice.as("SAMPLE_REVIEWING") SAMPLE_REVIEWING
  | @spice.as("REJECTED") REJECTED
  | @spice.as("CONFIRMED") CONFIRMED
  | @spice.as("WITHDRAWN") WITHDRAWN
let stringifyStatus = s => s->status_encode->Js.Json.decodeString->Option.getWithDefault("")
let displayStatus = s =>
  switch s {
  | APPLIED => `신청 접수 중`
  | UNDER_DISCUSSION => `판매 협의 중`
  | ON_SITE_MEETING_SCHEDULED => `현장 미팅 예정`
  | SAMPLE_REQUESTED => `샘플 요청`
  | SAMPLE_REVIEWING => `품평회 진행 중`
  | REJECTED => `추후 판매`
  | CONFIRMED => `판매 확정`
  | WITHDRAWN => `고객 취소`
  }

let clearQueries = q => q->Js.Dict.entries->Js.Dict.fromArray

let handleOnClickStatus = (~router: Next.Router.router, ~status: option<status>=?, ()) =>
  (
    _ => {
      let newQueries = router.query->clearQueries
      switch status {
      | Some(status') => newQueries->Js.Dict.set("status", status'->stringifyStatus)
      | None => Js.Dict.unsafeDeleteKey(. newQueries, "status")
      }

      let newQueryString =
        newQueries->Webapi.Url.URLSearchParams.makeWithDict->Webapi.Url.URLSearchParams.toString

      router->Next.Router.push(`${router.pathname}?${newQueryString}`)
    }
  )->ReactEvents.interceptingHandler

let queriedStyle = (~router: Next.Router.router, ~status: option<status>=?, ()) => {
  let queried =
    router.query
    ->Js.Dict.get("status")
    ->Option.map(Js.Json.string)
    ->Option.map(status_decode)
    ->Option.flatMap(s => s->Result.mapWithDefault(None, s' => Some(s')))
  switch (status == queried, status) {
  | (true, _) =>
    %twc(
      "py-1 px-2 flex justify-between border border-green-gl text-green-gl sm:border-0 sm:flex-1 sm:flex-col sm:p-4 bg-green-gl-light sm:rounded-lg"
    )
  | (false, None) =>
    %twc(
      "py-1 px-2 flex justify-between border border-gray-200 border-t-0 border-l-0 text-gray-700 sm:flex-1 sm:flex-col sm:border-0 sm:p-4"
    )
  | (false, Some(APPLIED)) =>
    %twc(
      "py-1 px-2 flex justify-between border border-gray-200 border-t-0 text-gray-700 sm:flex-1 sm:flex-col sm:border-0 sm:p-4"
    )
  | (false, Some(UNDER_DISCUSSION)) =>
    %twc(
      "py-1 px-2 flex justify-between border border-gray-200 border-t-0 text-gray-700 sm:flex-1 sm:flex-col sm:border-0 sm:p-4"
    )
  | (false, Some(ON_SITE_MEETING_SCHEDULED)) =>
    %twc(
      "py-1 px-2 flex justify-between border border-gray-200 border-t-0 text-gray-700 sm:flex-1 sm:flex-col sm:border-0 sm:p-4"
    )
  | (false, Some(SAMPLE_REQUESTED)) =>
    %twc(
      "py-1 px-2 flex justify-between border border-gray-200 border-t-0 text-gray-700 sm:flex-1 sm:flex-col sm:border-0 sm:p-4"
    )
  | (false, Some(SAMPLE_REVIEWING)) =>
    %twc(
      "py-1 px-2 flex justify-between border border-gray-200 border-t-0 text-gray-700 sm:flex-1 sm:flex-col sm:border-0 sm:p-4"
    )
  | (false, Some(REJECTED)) =>
    %twc(
      "py-1 px-2 flex justify-between border border-gray-200 border-t-0 text-gray-700 sm:flex-1 sm:flex-col sm:border-0 sm:p-4"
    )
  | (false, Some(CONFIRMED)) =>
    %twc(
      "py-1 px-2 flex justify-between border border-gray-200 text-gray-700 sm:flex-1 sm:flex-col sm:border-0 sm:p-4"
    )
  | (false, Some(WITHDRAWN)) =>
    %twc(
      "py-1 px-2 flex justify-between border border-gray-200 text-gray-700 sm:flex-1 sm:flex-col sm:border-0 sm:p-4"
    )
  }
}

let queriedFill = (~router: Next.Router.router, ~status: option<status>=?, ()) => {
  let queried =
    router.query
    ->Js.Dict.get("status")
    ->Option.flatMap(status' =>
      switch status'->Js.Json.string->status_decode {
      | Ok(status'') => Some(status'')
      | Error(_) => None
      }
    )
  switch status === queried {
  | true => "#12b564"
  | false => "#262626"
  }
}

let displayCount = (
  status,
  data: BulkSaleProducersAdminTotalSummaryFragment_graphql.Types.fragment_totalStatistics,
) => {
  switch status {
  | APPLIED => `${data.progressAppliedCount->Int.toString}건`
  | UNDER_DISCUSSION => `${data.progressUnderDiscussionCount->Int.toString}건`
  | ON_SITE_MEETING_SCHEDULED => `${data.progressOnSiteMeetingScheduledCount->Int.toString}건`
  | SAMPLE_REQUESTED => `${data.progressSampleRequestedCount->Int.toString}건`
  | SAMPLE_REVIEWING => `${data.progressSampleReviewingCount->Int.toString}건`
  | REJECTED => `${data.progressRejectedCount->Int.toString}건`
  | CONFIRMED => `${data.progressConfirmedCount->Int.toString}건`
  | WITHDRAWN => `${data.progressWithdrawnCount->Int.toString}건`
  }
}

module Total = {
  module Skeleton = {
    @react.component
    let make = () => {
      let router = Next.Router.useRouter()

      <li className={queriedStyle(~router, ())}>
        <span className=%twc("flex justify-center items-center pb-1 text-sm")>
          {j`전체`->React.string}
        </span>
        <Skeleton.Box />
      </li>
    }
  }
  @react.component
  let make = (
    ~data: BulkSaleProducersAdminTotalSummaryFragment_graphql.Types.fragment_totalStatistics,
  ) => {
    let router = Next.Router.useRouter()

    let totalCount = `${data.count->Int.toString}건`

    <li className={queriedStyle(~router, ())} onClick={handleOnClickStatus(~router, ())}>
      <span className=%twc("flex justify-center items-center pb-1 text-sm")>
        {j`전체`->React.string}
      </span>
      <span className=%twc("block font-bold sm:text-center")> {totalCount->React.string} </span>
    </li>
  }
}

module Item = {
  module Skeleton = {
    @react.component
    let make = (~kind) => {
      let router = Next.Router.useRouter()

      <li className={queriedStyle(~router, ~status=kind, ())}>
        <span className=%twc("flex justify-center items-center pb-1 text-sm")>
          {kind->displayStatus->React.string}
        </span>
        <Skeleton.Box />
      </li>
    }
  }
  @react.component
  let make = (
    ~kind: status,
    ~data: BulkSaleProducersAdminTotalSummaryFragment_graphql.Types.fragment_totalStatistics,
  ) => {
    let router = Next.Router.useRouter()

    <li
      className={queriedStyle(~router, ~status=kind, ())}
      onClick={handleOnClickStatus(~router, ~status=kind, ())}>
      <span className=%twc("flex justify-center items-center pb-1 text-sm")>
        {kind->displayStatus->React.string}
      </span>
      <span className=%twc("block font-bold sm:text-center")>
        {displayCount(kind, data)->React.string}
      </span>
    </li>
  }
}
