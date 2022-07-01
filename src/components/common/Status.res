// limit, sort, from, to만 빼고 쿼리 파라미터를 초기화 한다.
let clearQueries = q =>
  q
  ->Js.Dict.entries
  ->Garter.Array.keep(((k, _)) => k === `limit` || k === "from" || k === "to")
  ->Js.Dict.fromArray

let isSeller = (r: Next.Router.router) => {
  let firstPathname = r.pathname->Js.String2.split("/")->Array.getBy(x => x !== "")
  firstPathname === Some("seller")
}

let handleOnClickStatus = (
  ~router: Next.Router.router,
  ~status: option<CustomHooks.OrdersSummary.status>=?,
  (),
) =>
  (
    _ => {
      let newQueries = router.query->clearQueries
      switch status {
      | Some(status') =>
        newQueries->Js.Dict.set(
          "status",
          status'
          ->CustomHooks.OrdersSummary.status_encode
          ->Converter.getStringFromJsonWithDefault(""),
        )
        switch (status', isSeller(router)) {
        | (CREATE, true) => newQueries->Js.Dict.set("sort", "created")
        | _ => ()
        }
      | None => Js.Dict.unsafeDeleteKey(. newQueries, "status")
      }

      let newQueryString =
        newQueries->Webapi.Url.URLSearchParams.makeWithDict->Webapi.Url.URLSearchParams.toString

      router->Next.Router.push(`${router.pathname}?${newQueryString}`)
    }
  )->ReactEvents.interceptingHandler

let queriedStyle = (
  ~router: Next.Router.router,
  ~status: option<CustomHooks.OrdersSummary.status>=?,
  (),
) => {
  let queried =
    router.query
    ->Js.Dict.get("status")
    ->Option.flatMap(status' =>
      switch status'->Js.Json.string->CustomHooks.OrdersSummary.status_decode {
      | Ok(status'') => Some(status'')
      | Error(_) => None
      }
    )
  switch (status === queried, status) {
  | (true, _) =>
    %twc(
      "py-1 px-2 flex justify-between border border-green-gl text-green-gl sm:border-0 sm:flex-1 sm:flex-col sm:p-4 bg-green-gl-light sm:rounded-lg"
    )
  | (false, None) =>
    %twc(
      "py-1 px-2 flex justify-between border border-gray-200 border-b-0 text-gray-700 sm:flex-1 sm:flex-col sm:border-0 sm:p-4"
    )
  | (false, Some(CREATE)) =>
    %twc(
      "py-1 px-2 flex justify-between border border-gray-200 border-l-0 border-b-0 text-gray-700 sm:flex-1 sm:flex-col sm:border-0 sm:p-4"
    )
  | (false, Some(PACKING)) =>
    %twc(
      "py-1 px-2 flex justify-between border border-gray-200 text-gray-700 sm:flex-1 sm:flex-col sm:border-0 sm:p-4"
    )
  | (false, Some(DEPARTURE)) =>
    %twc(
      "py-1 px-2 flex justify-between border border-gray-200 border-l-0 text-gray-700 sm:flex-1 sm:flex-col sm:border-0 sm:p-4"
    )
  | (false, Some(DELIVERING)) =>
    %twc(
      "py-1 px-2 flex justify-between border border-gray-200 border-t-0 text-gray-700 sm:flex-1 sm:flex-col sm:border-0 sm:p-4"
    )
  | (false, Some(COMPLETE)) =>
    %twc(
      "py-1 px-2 flex justify-between border border-gray-200 border-t-0 border-l-0 text-gray-700 sm:flex-1 sm:flex-col sm:border-0 sm:p-4"
    )
  | (false, Some(CANCEL)) =>
    %twc(
      "py-1 px-2 flex justify-between border border-gray-200 border-t-0 text-gray-700 sm:flex-1 sm:flex-col sm:border-0 sm:p-4"
    )
  | (false, Some(REFUND)) =>
    %twc(
      "py-1 px-2 flex justify-between border border-gray-200 border-t-0 border-l-0 text-gray-700 sm:flex-1 sm:flex-col sm:border-0 sm:p-4"
    )
  | (false, Some(ERROR)) =>
    %twc(
      "py-1 px-2 flex justify-between border border-gray-200 border-t-0 text-gray-700 sm:flex-1 sm:flex-col sm:border-0 sm:p-4"
    )
  | (false, Some(NEGOTIATING)) =>
    %twc(
      "py-1 px-2 flex justify-between border border-gray-200 border-t-0 text-gray-700 sm:flex-1 sm:flex-col sm:border-0 sm:p-4"
    )
  }
}

let queriedFill = (
  ~router: Next.Router.router,
  ~status: option<CustomHooks.OrdersSummary.status>=?,
  (),
) => {
  let queried =
    router.query
    ->Js.Dict.get("status")
    ->Option.flatMap(status' =>
      switch status'->Js.Json.string->CustomHooks.OrdersSummary.status_decode {
      | Ok(status'') => Some(status'')
      | Error(_) => None
      }
    )
  switch status === queried {
  | true => "#12b564"
  | false => "#262626"
  }
}

let displayCount = (status: CustomHooks.OrdersSummary.result, s) => {
  switch status {
  | Loaded(orders) =>
    switch orders->CustomHooks.OrdersSummary.orders_decode {
    | Ok(orders') =>
      `${orders'.data
        ->Garter.Array.getBy(d => d.status === s)
        ->Option.mapWithDefault(0, d => d.count)
        ->Int.toString}건`
    | Error(_) => `에러`
    }
  | _ => `-`
  }
}

module Tooltip = {
  @react.component
  let make = (~text, ~fill) => {
    <RadixUI.Tooltip.Root delayDuration=300>
      <RadixUI.Tooltip.Trigger> <IconInfo height="16" width="16" fill /> </RadixUI.Tooltip.Trigger>
      <RadixUI.Tooltip.Content side=#top sideOffset=4>
        <div className=%twc("block w-32 bg-red-400 relative")>
          <div
            className=%twc(
              "absolute w-full -top-6 left-1/2 transform -translate-x-1/2 flex flex-col justify-center"
            )>
            <h5
              className=%twc(
                "absolute w-full left-1/2 transform -translate-x-1/2 bg-white border border-primary text-primary text-sm text-center py-1.5 font-bold rounded-xl shadow-tooltip"
              )>
              {text->React.string}
            </h5>
            <div
              className=%twc(
                "absolute h-3 w-3 rounded-sm top-3 bg-white border-b border-r border-primary left-1/2 transform -translate-x-1/2 rotate-45"
              )
            />
          </div>
        </div>
      </RadixUI.Tooltip.Content>
    </RadixUI.Tooltip.Root>
  }
}

module Total = {
  @react.component
  let make = () => {
    let router = Next.Router.useRouter()
    let status = CustomHooks.OrdersSummary.use(~queryParams=Period.currentPeriod(router), ())

    let totalCount = () => {
      switch status {
      | Loaded(orders) =>
        switch orders->CustomHooks.OrdersSummary.orders_decode {
        | Ok(orders') =>
          `${orders'.data->Garter.Array.reduce(0, (acc, cur) => acc + cur.count)->Int.toString}건`
        | Error(_) => `에러`
        }
      | _ => `-`
      }
    }

    <li className={queriedStyle(~router, ())} onClick={handleOnClickStatus(~router, ())}>
      <span className=%twc("flex justify-center items-center pb-1 text-sm")>
        {j`전체`->React.string}
      </span>
      <span className=%twc("block font-bold sm:text-center")> {totalCount()->React.string} </span>
    </li>
  }
}

module Item = {
  @react.component
  let make = (~kind: CustomHooks.OrdersSummary.status) => {
    let router = Next.Router.useRouter()
    let status = CustomHooks.OrdersSummary.use(~queryParams=Period.currentPeriod(router), ())

    module Converter = Converter.Status(CustomHooks.OrdersSummary)

    <li
      className={queriedStyle(~router, ~status=kind, ())}
      onClick={handleOnClickStatus(~router, ~status=kind, ())}>
      <span className=%twc("flex justify-center items-center pb-1 text-sm")>
        {kind->Converter.displayStatus->React.string}
      </span>
      <span className=%twc("block font-bold sm:text-center")>
        {displayCount(status, kind)->React.string}
      </span>
    </li>
  }
}
