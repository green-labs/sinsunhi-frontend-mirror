@spice
type kind = | @spice.as("true") OnlyNullCost | @spice.as("false") ExcludeNullCost
let getIsOnlyNull = q => q->Js.Dict.get("only-null")
let displayKind = k =>
  switch k {
  | OnlyNullCost => `원가 없음`
  | ExcludeNullCost => `원가 있음`
  }

@react.component
let make = (~className=?) => {
  let router = Next.Router.useRouter()

  let onChange = e => {
    let {makeWithDict, toString} = module(Webapi.Url.URLSearchParams)

    let isOnlyNull = (e->ReactEvent.Synthetic.target)["value"]
    router.query->Js.Dict.set("only-null", isOnlyNull)
    router->Next.Router.push(`${router.pathname}?${router.query->makeWithDict->toString}`)
  }

  <span ?className>
    <label className=%twc("block relative")>
      <span
        className=%twc(
          "w-36 flex items-center border border-border-default-L1 rounded-md h-9 px-3 text-enabled-L1"
        )>
        {router.query
        ->getIsOnlyNull
        ->Option.flatMap(kind =>
          switch kind->Js.Json.string->kind_decode {
          | Ok(kind') => Some(kind')
          | Error(_) => None
          }
        )
        ->Option.map(displayKind)
        ->Option.getWithDefault(`전체`)
        ->React.string}
      </span>
      <span className=%twc("absolute top-1.5 right-2")>
        <IconArrowSelect height="24" width="24" fill="#121212" />
      </span>
      <select
        value={router.query->getIsOnlyNull->Option.getWithDefault("")}
        className=%twc("block w-full h-full absolute top-0 opacity-0")
        onChange>
        <option value=""> {`전체`->React.string} </option>
        {[OnlyNullCost, ExcludeNullCost]
        ->Garter.Array.map(k =>
          <option
            key={k->kind_encode->Converter.getStringFromJsonWithDefault("")}
            value={k->kind_encode->Converter.getStringFromJsonWithDefault("")}>
            {k->displayKind->React.string}
          </option>
        )
        ->React.array}
      </select>
    </label>
  </span>
}
