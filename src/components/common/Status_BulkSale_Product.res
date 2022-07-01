@spice
type status =
  | @spice.as("reserved") RESERVED
  | @spice.as("open") OPEN
  | @spice.as("ended") ENDED
  | @spice.as("canceled") CANCELED
let stringifyStatus = s => s->status_encode->Js.Json.decodeString->Option.getWithDefault("")
let displayStatus = s =>
  switch s {
  | RESERVED => `모집예정`
  | OPEN => `모집중`
  | ENDED => `모집종료`
  | CANCELED => `모집취소`
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
  | (false, Some(OPEN)) =>
    %twc(
      "py-1 px-2 flex justify-between border border-gray-200 border-t-0 border-l-0 text-gray-700 sm:flex-1 sm:flex-col sm:border-0 sm:p-4"
    )
  | (false, Some(ENDED)) =>
    %twc(
      "py-1 px-2 flex justify-between border border-gray-200 border-t-0 text-gray-700 sm:flex-1 sm:flex-col sm:border-0 sm:p-4"
    )
  | (false, _) =>
    %twc(
      "py-1 px-2 flex justify-between border border-gray-200 border-b-0 text-gray-700 sm:flex-1 sm:flex-col sm:border-0 sm:p-4"
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
  data: BulkSaleProductsAdminSummaryFragment_graphql.Types.fragment_bulkSaleCampaignStatistics,
) => {
  switch status {
  | OPEN => `${data.openCount->Int.toString}건`
  | ENDED => `${data.notOpenCount->Int.toString}건`
  | RESERVED
  | CANCELED => ``
  }
}

module Total = {
  module Skeleton = {
    @react.component
    let make = () => {
      let router = Next.Router.useRouter()

      <li className={queriedStyle(~router, ())}>
        <span className=%twc("flex justify-center items-center pb-1 text-sm")>
          {`전체`->React.string}
        </span>
        <Skeleton.Box />
      </li>
    }
  }
  @react.component
  let make = (
    ~data: BulkSaleProductsAdminSummaryFragment_graphql.Types.fragment_bulkSaleCampaignStatistics,
  ) => {
    let router = Next.Router.useRouter()

    <li className={queriedStyle(~router, ())} onClick={handleOnClickStatus(~router, ())}>
      <span className=%twc("flex justify-center items-center pb-1 text-sm")>
        {`전체`->React.string}
      </span>
      <span className=%twc("block font-bold sm:text-center")>
        {j`${data.count->Int.toString}건`->React.string}
      </span>
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
    ~data: BulkSaleProductsAdminSummaryFragment_graphql.Types.fragment_bulkSaleCampaignStatistics,
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
