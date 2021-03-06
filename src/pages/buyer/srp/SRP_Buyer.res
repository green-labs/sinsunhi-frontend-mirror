module Query = %relay(`
  query SRPBuyerQuery(
    $count: Int!
    $cursor: String
    $name: String!
    $sort: ProductsQueryInputSort!
    $onlyBuyable: Boolean
  ) {
    ...SRPBuyer_fragment
      @arguments(
        count: $count
        cursor: $cursor
        name: $name
        sort: $sort
        onlyBuyable: $onlyBuyable
      )
  }
`)

module Fragment = %relay(`
  fragment SRPBuyer_fragment on Query
  @refetchable(queryName: "ShopSearchBuyerRefetchQuery")
  @argumentDefinitions(
    count: { type: "Int", defaultValue: 20 }
    onlyBuyable: { type: "Boolean", defaultValue: null }
    cursor: { type: "String", defaultValue: null }
    name: { type: "String!" }
    sort: { type: "ProductsQueryInputSort!" }
  ) {
    products(
      first: $count
      after: $cursor
      name: $name
      sort: $sort
      onlyBuyable: $onlyBuyable
    ) @connection(key: "ShopSearchBuyer_products") {
      edges {
        cursor
        node {
          ...ShopProductListItemBuyerFragment
        }
      }
    }
  }
`)

module Placeholder = {
  @react.component
  let make = (~deviceType) => {
    let router = Next.Router.useRouter()
    switch deviceType {
    | DeviceDetect.Unknown => React.null

    | DeviceDetect.PC =>
      <div className=%twc("w-full min-w-[1280px] min-h-screen flex flex-col")>
        <Header_Buyer.PC key=router.asPath />
        <main className=%twc("flex flex-col grow w-full h-full bg-white")>
          <div className=%twc("w-[1280px] pt-20 mx-auto")>
            <section className=%twc("w-full flex items-center justify-center")>
              <div className=%twc("bg-gray-150 animate-pulse rounded-xl w-[400px] h-[48px]") />
            </section>
            <section className=%twc("mt-20 w-full flex items-center justify-end")>
              <div className=%twc("bg-gray-150 animate-pulse rounded-xl w-32 h-5") />
            </section>
            <section className=%twc("w-full mt-12")>
              <ol className=%twc("grid grid-cols-4 gap-x-10 gap-y-16")>
                {Array.range(1, 300)
                ->Array.map(number => {
                  <ShopProductListItem_Buyer.PC.Placeholder key={`box-${number->Int.toString}`} />
                })
                ->React.array}
              </ol>
            </section>
          </div>
        </main>
        <Footer_Buyer.PC />
      </div>

    | DeviceDetect.Mobile =>
      <div className=%twc("w-full bg-white")>
        <Header_Buyer.Mobile key=router.asPath />
        <main className=%twc("w-full max-w-3xl mx-auto relative bg-white min-h-screen")>
          <div className=%twc("w-full pb-8 px-5")>
            <div className=%twc("w-full py-4  flex items-center justify-end")>
              <div className=%twc("w-12 h-5 rounded-lg animate-pulse bg-gray-150") />
            </div>
            <div>
              <ol className=%twc("grid grid-cols-2 gap-x-4 gap-y-8")>
                {Array.range(1, 300)
                ->Array.map(idx => {
                  <ShopProductListItem_Buyer.MO.Placeholder
                    key={`search-result-skeleton-${idx->Int.toString}`}
                  />
                })
                ->React.array}
              </ol>
            </div>
          </div>
        </main>
        <Footer_Buyer.MO />
      </div>
    }
  }
}

module Error = {
  @react.component
  let make = (~deviceType) => {
    let router = Next.Router.useRouter()

    switch deviceType {
    | DeviceDetect.Unknown => React.null

    | DeviceDetect.PC =>
      <div className=%twc("w-full min-w-[1280px] min-h-screen flex flex-col")>
        <Header_Buyer.PC key=router.asPath />
        <main className=%twc("flex flex-col grow w-full h-full bg-white")>
          <div className=%twc("w-full flex items-center justify-center mt-40")>
            <span className=%twc("text-3xl text-gray-800")>
              {`????????? ?????????????????????`->React.string}
            </span>
          </div>
        </main>
        <Footer_Buyer.PC />
      </div>

    | DeviceDetect.Mobile =>
      <div className=%twc("w-full bg-white")>
        <Header_Buyer.Mobile key=router.asPath />
        <main className=%twc("w-full max-w-3xl mx-auto relative bg-white min-h-screen")>
          <div className=%twc("w-full flex items-center justify-center pt-[134px] px-5")>
            <span className=%twc("text-gray-800 text-xl text-center")>
              {`????????? ?????????????????????`->React.string}
            </span>
          </div>
        </main>
        <Footer_Buyer.MO />
      </div>
    }
  }
}

module PC = {
  @react.component
  let make = (~keyword, ~query) => {
    let router = Next.Router.useRouter()

    let {data: {products}, hasNext, loadNext} = Fragment.usePagination(query)
    let loadMoreRef = React.useRef(Js.Nullable.null)

    let isIntersecting = CustomHooks.IntersectionObserver.use(
      ~target=loadMoreRef,
      ~rootMargin="50px",
      ~thresholds=0.1,
      (),
    )

    React.useEffect1(_ => {
      if hasNext && isIntersecting {
        loadNext(~count=20, ())->ignore
      }

      None
    }, [hasNext, isIntersecting])

    <div className=%twc("w-full min-w-[1280px] min-h-screen flex flex-col")>
      <Header_Buyer.PC key=router.asPath />
      <main className=%twc("flex flex-col grow w-full h-full bg-white")>
        {switch products.edges {
        // ???????????? ??????
        | [] =>
          <>
            <div className=%twc("w-full flex items-center justify-center mt-40")>
              <span className=%twc("text-3xl text-gray-800")>
                <span className=%twc("font-bold")> {keyword->React.string} </span>
                {`??? ?????? ????????????`->React.string}
              </span>
            </div>
            <div className=%twc("mt-7 w-full flex flex-col items-center justify-center")>
              <span className=%twc("text-gray-800")>
                <span className=%twc("text-green-500 font-bold")> {keyword->React.string} </span>
                {`??? ??????????????? ????????????.`->React.string}
              </span>
              <span className=%twc("text-gray-800")>
                {`?????? ???????????? ?????????????????? ????????? ??????????????? ????????? ?????????.`->React.string}
              </span>
            </div>
          </>

        | edges =>
          <div className=%twc("w-[1280px] mx-auto min-h-full px-5")>
            <div className=%twc("w-full flex items-center justify-center pt-20")>
              <span className=%twc("text-3xl text-gray-800")>
                <span className=%twc("font-bold")> {keyword->React.string} </span>
                {`??? ?????? ????????????`->React.string}
              </span>
            </div>
            <div className=%twc("mt-20 w-full flex items-center justify-end")>
              <ShopProductsSortSelect_Buyer />
            </div>
            <div>
              <ol className=%twc("mt-12 grid grid-cols-4 gap-x-10 gap-y-16")>
                {edges
                ->Array.map(({cursor, node}) => {
                  <ShopProductListItem_Buyer.PC key=cursor query=node.fragmentRefs />
                })
                ->React.array}
              </ol>
              <div ref={ReactDOM.Ref.domRef(loadMoreRef)} className=%twc("h-20 w-full") />
            </div>
          </div>
        }}
      </main>
      <Footer_Buyer.PC />
    </div>
  }
}

module MO = {
  @react.component
  let make = (~keyword, ~query) => {
    let router = Next.Router.useRouter()

    let {data: {products}, hasNext, loadNext} = Fragment.usePagination(query)
    let loadMoreRef = React.useRef(Js.Nullable.null)

    let isIntersecting = CustomHooks.IntersectionObserver.use(
      ~target=loadMoreRef,
      ~rootMargin="50px",
      ~thresholds=0.1,
      (),
    )

    React.useEffect1(_ => {
      if hasNext && isIntersecting {
        loadNext(~count=20, ())->ignore
      }

      None
    }, [hasNext, isIntersecting])

    <div className=%twc("w-full bg-white")>
      <Header_Buyer.Mobile key=router.asPath />
      <main className=%twc("w-full max-w-3xl mx-auto relative bg-white min-h-screen")>
        {switch products.edges {
        // ???????????? ??????
        | [] =>
          <>
            <div className=%twc("w-full flex items-center justify-center pt-[134px] px-5")>
              <span className=%twc("text-gray-800 text-xl text-center")>
                <span className=%twc("font-bold")> {keyword->React.string} </span>
                {`??? ?????? ????????????`->React.string}
              </span>
            </div>
            <div
              className=%twc(
                "mt-2 w-full flex flex-col items-center justify-center text-center text-base text-gray-600"
              )>
              <span>
                <span className=%twc("text-green-500 font-bold")> {keyword->React.string} </span>
                {`??? ??????????????? ????????????.`->React.string}
              </span>
              <span> {`?????? ???????????? ??????????????????`->React.string} </span>
              <span> {`????????? ??????????????? ????????? ?????????.`->React.string} </span>
            </div>
          </>

        | edges =>
          <div className=%twc("w-full px-5")>
            <div className=%twc("py-4 w-full flex items-center justify-end")>
              <ShopProductsSortSelect_Buyer.MO />
            </div>
            <div>
              <ol className=%twc("grid grid-cols-2 gap-x-4 gap-y-8")>
                {edges
                ->Array.map(({cursor, node}) => {
                  <ShopProductListItem_Buyer.MO key=cursor query=node.fragmentRefs />
                })
                ->React.array}
              </ol>
              <div ref={ReactDOM.Ref.domRef(loadMoreRef)} className=%twc("h-20 w-full") />
            </div>
          </div>
        }}
      </main>
      <Footer_Buyer.MO />
    </div>
  }
}

module Container = {
  @react.component
  let make = (~deviceType, ~keyword, ~sort) => {
    // ????????? ?????? ??????
    ChannelTalkHelper.Hook.use()

    let {fragmentRefs} = Query.use(
      ~variables=Query.makeVariables(~name=keyword, ~count=20, ~sort, ~onlyBuyable=true, ()),
      ~fetchPolicy=RescriptRelay.StoreOrNetwork,
      (),
    )

    React.useEffect1(() => {
      DataGtm.push({
        "event": "view_search_results", // ????????? ??????: ?????? ?????? ???
        "keyword": keyword, // ?????????
      })

      None
    }, [keyword])

    switch deviceType {
    | DeviceDetect.Unknown => React.null
    | DeviceDetect.PC => <PC keyword query=fragmentRefs />
    | DeviceDetect.Mobile => <MO keyword query=fragmentRefs />
    }
  }
}

@react.component
let make = (~deviceType) => {
  let router = Next.Router.useRouter()
  let keyword = router.query->Js.Dict.get("keyword")->Option.map(Js.Global.decodeURIComponent)
  let sort =
    router.query
    ->Js.Dict.get("sort")
    ->Option.flatMap(ShopProductsSortSelect_Buyer.decodeSort)
    ->Option.getWithDefault(#UPDATED_DESC)

  let (isCsr, setIsCsr) = React.Uncurried.useState(_ => false)

  React.useEffect0(() => {
    setIsCsr(._ => true)
    None
  })

  <>
    <Next.Head>
      <title> {`????????????`->React.string} </title>
    </Next.Head>
    <RescriptReactErrorBoundary fallback={_ => <Error deviceType />}>
      <React.Suspense fallback={<Placeholder deviceType />}>
        {switch (isCsr, keyword) {
        | (true, Some(keyword')) => <Container deviceType keyword=keyword' sort />
        | _ => <Placeholder deviceType />
        }}
      </React.Suspense>
    </RescriptReactErrorBoundary>
  </>
}
