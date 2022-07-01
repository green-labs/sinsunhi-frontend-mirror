// 선택된 기간 (없으면 7일)
let currentPeriod = (router: Next.Router.router) => {
  let currentFrom =
    router.query
    ->Webapi.Url.URLSearchParams.makeWithDict
    ->Webapi.Url.URLSearchParams.get("from")
    ->Option.getWithDefault(Js.Date.make()->DateFns.subDays(7)->DateFns.format("yyyyMMdd"))
  let currentTo =
    router.query
    ->Webapi.Url.URLSearchParams.makeWithDict
    ->Webapi.Url.URLSearchParams.get("to")
    ->Option.getWithDefault(Js.Date.make()->DateFns.format("yyyyMMdd"))
  `from=${currentFrom}&to=${currentTo}`
}
