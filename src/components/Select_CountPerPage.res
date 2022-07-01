let getCountPerPage = q => q->Js.Dict.get("limit")->Option.flatMap(Int.fromString)

@react.component
let make = (~className=?) => {
  let router = Next.Router.useRouter()

  let onChange = e => {
    let {makeWithDict, toString} = module(Webapi.Url.URLSearchParams)

    let limit = (e->ReactEvent.Synthetic.target)["value"]
    router.query->Js.Dict.set("limit", limit)
    router.query->Js.Dict.set("offset", "0")
    router->Next.Router.push(`${router.pathname}?${router.query->makeWithDict->toString}`)
  }

  let displayCount = q =>
    q
    ->getCountPerPage
    ->Option.mapWithDefault(`${Constants.defaultCountPerPage->Int.toString}개씩 보기`, limit =>
      `${limit->Int.toString}개씩 보기`
    )

  <span ?className>
    <label className=%twc("block relative")>
      <span
        className=%twc(
          "w-36 flex items-center border border-border-default-L1 rounded-md h-9 px-3 text-enabled-L1"
        )>
        {displayCount(router.query)->React.string}
      </span>
      <span className=%twc("absolute top-1.5 right-2")>
        <IconArrowSelect height="24" width="24" fill="#121212" />
      </span>
      <select
        value={getCountPerPage(
          router.query,
        )->Option.mapWithDefault(Constants.defaultCountPerPage->Int.toString, limit =>
          limit->Int.toString
        )}
        className=%twc("block w-full h-full absolute top-0 opacity-0")
        onChange>
        {Constants.countsPerPage
        ->Garter.Array.map(c =>
          <option key={c->Int.toString} value={c->Int.toString}>
            {`${c->Int.toString}개씩 보기`->React.string}
          </option>
        )
        ->React.array}
      </select>
    </label>
  </span>
}
