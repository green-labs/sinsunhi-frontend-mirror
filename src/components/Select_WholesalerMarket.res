module Query = %relay(`
  query SelectWholesalerMarketQuery(
    $first: Int
  ) {
    wholesalerMarkets(
      first: $first
    ) {
      count
      edges {
        cursor
        node {
          id
          code
          name
        }
      }
    }
  }
`)

module Loading = {
  @react.component
  let make = () => {
    <label className=%twc("block relative mt-2")>
      <span
        className=%twc(
          "flex items-center border border-border-default-L1 rounded-md h-9 px-3 text-enabled-L1"
        )>
        {`로딩 중`->React.string}
      </span>
      <span className=%twc("absolute top-1.5 right-2")>
        <IconArrowSelect height="24" width="24" fill="#121212" />
      </span>
    </label>
  }
}
module WholesalerMarkets = {
  @react.component
  let make = (~wholesalerMarketId, ~onChangeWholesalerMarket) => {
    let queryData = Query.use(~variables={first: Some(100)}, ())

    <>
      <label className=%twc("block relative mt-2")>
        <span
          className=%twc(
            "flex items-center border border-border-default-L1 rounded-md h-9 px-3 text-enabled-L1"
          )>
          {wholesalerMarketId
          ->Option.flatMap(id => {
            queryData.wholesalerMarkets.edges
            ->Array.keep(edge => edge.node.id == id)
            ->Array.map(edge => edge.node.name)
            ->Garter.Array.first
          })
          ->Option.getWithDefault(`시장 선택`)
          ->React.string}
        </span>
        <span className=%twc("absolute top-1.5 right-2")>
          <IconArrowSelect height="24" width="24" fill="#121212" />
        </span>
        <select
          value={wholesalerMarketId->Option.getWithDefault("")}
          className=%twc("block w-full h-full absolute top-0 opacity-0")
          onChange=onChangeWholesalerMarket>
          <option value=""> {j`택배사 선택`->React.string} </option>
          {queryData.wholesalerMarkets.edges
          ->Array.map(edge =>
            <option key={edge.node.id} value={edge.node.id}>
              {edge.node.name->React.string}
            </option>
          )
          ->React.array}
        </select>
      </label>
    </>
  }
}

@react.component
let make = (
  ~label,
  ~wholesalerMarketId,
  ~wholesalerId,
  ~onChangeWholesalerMarket,
  ~onChangeWholesaler,
  ~error,
) => {
  <section className=%twc("w-2/3")>
    <div className=%twc("flex gap-2")>
      <article className=%twc("flex-1")>
        <h3 className=%twc("text-sm")> {label->React.string} </h3>
        <RescriptReactErrorBoundary fallback={_ => <div> {`에러 발생`->React.string} </div>}>
          <React.Suspense fallback={<Loading />}>
            <WholesalerMarkets wholesalerMarketId onChangeWholesalerMarket />
          </React.Suspense>
        </RescriptReactErrorBoundary>
      </article>
      <RescriptReactErrorBoundary fallback={_ => <div> {`에러 발생`->React.string} </div>}>
        <React.Suspense fallback={<Select_Wholesaler.Loading />}>
          <Select_Wholesaler
            label=`법인명` wholesalerMarketId wholesalerId onChange=onChangeWholesaler
          />
        </React.Suspense>
      </RescriptReactErrorBoundary>
    </div>
    <div>
      {error
      ->Option.map(err =>
        <span className=%twc("flex mt-2")>
          <IconError width="20" height="20" />
          <span className=%twc("text-sm text-notice ml-1")> {err->React.string} </span>
        </span>
      )
      ->Option.getWithDefault(React.null)}
    </div>
  </section>
}
