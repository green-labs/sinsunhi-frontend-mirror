type sorted = Newest | Oldest

let encodeSorted = sorted =>
  switch sorted {
  | Newest => `-created`
  | Oldest => `created`
  }
let decodeSorted = sorted =>
  if sorted === "-created" {
    Newest->Ok
  } else if sorted === "created" {
    Oldest->Ok
  } else {
    Error(`정의되지 않은 값 입니다.`)
  }
let parseSorted = q => q->Js.Dict.get("sort")->Option.mapWithDefault(Ok(Newest), decodeSorted)
let formatSorted = sorted =>
  switch sorted {
  | Newest => `최신순`
  | Oldest => `생성순`
  }

@react.component
let make = (~className=?) => {
  let router = Next.Router.useRouter()

  let onChange = e => {
    let {makeWithDict, toString} = module(Webapi.Url.URLSearchParams)

    let sorted = (e->ReactEvent.Synthetic.target)["value"]
    router.query->Js.Dict.set("sort", sorted)
    router.query->Js.Dict.set("offset", "0")
    router->Next.Router.push(`${router.pathname}?${router.query->makeWithDict->toString}`)
  }

  let displaySorted = q => q->parseSorted->Result.mapWithDefault(`최신순`, formatSorted)

  <span ?className>
    <label className=%twc("block relative")>
      <span
        className=%twc(
          "w-24 flex items-center border border-border-default-L1 rounded-md h-9 px-3 text-enabled-L1"
        )>
        {displaySorted(router.query)->React.string}
      </span>
      <span className=%twc("absolute top-1.5 right-2")>
        <IconArrowSelect height="24" width="24" fill="#121212" />
      </span>
      <select
        value={parseSorted(router.query)->Result.mapWithDefault(`-created`, encodeSorted)}
        className=%twc("block w-full h-full absolute top-0 opacity-0")
        onChange>
        {[Newest, Oldest]
        ->Garter.Array.map(s =>
          <option key={s->encodeSorted} value={s->encodeSorted}>
            {s->formatSorted->React.string}
          </option>
        )
        ->React.array}
      </select>
    </label>
  </span>
}
