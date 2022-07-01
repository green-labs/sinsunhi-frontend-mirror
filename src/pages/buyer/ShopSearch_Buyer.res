module Query = %relay(`
  query ShopSearchBuyerQuery(
    $count: Int!
    $cursor: String
    $name: String!
    $sort: ProductsQueryInputSort!
    $onlyBuyable: Boolean
  ) {
    ...ShopSearchBuyerSearchResultsFragment
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
fragment ShopSearchBuyerSearchResultsFragment on Query
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
  let make = () => {
    <Layout_Buyer.Responsive
      pc={<div className=%twc("w-[1280px] pt-20 mx-auto")>
        <section className=%twc("w-full flex items-center justify-center")>
          <Skeleton.Box className=%twc("w-[400px] h-[48px]") />
        </section>
        <section className=%twc("mt-20 w-full flex items-center justify-end")>
          <Skeleton.Box className=%twc("w-32 h-5") />
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
      </div>}
      mobile={<div className=%twc("w-full pb-8 px-5")>
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
      </div>}
    />
  }
}

module PC = {
  module Empty = {
    @react.component
    let make = (~keyword) => {
      <>
        <div className=%twc("w-full flex items-center justify-center mt-40")>
          <span className=%twc("text-3xl text-gray-800")>
            <span className=%twc("font-bold")> {keyword->React.string} </span>
            {`에 대한 검색결과`->React.string}
          </span>
        </div>
        <div className=%twc("mt-7 w-full flex flex-col items-center justify-center")>
          <span className=%twc("text-gray-800")>
            <span className=%twc("text-green-500 font-bold")> {keyword->React.string} </span>
            {`의 검색결과가 없습니다.`->React.string}
          </span>
          <span className=%twc("text-gray-800")>
            {`다른 검색어를 입력하시거나 철자와 띄어쓰기를 확인해 보세요.`->React.string}
          </span>
        </div>
      </>
    }
  }

  @react.component
  let make = (~keyword, ~query) => {
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

    if products.edges->Array.length == 0 {
      <Empty keyword />
    } else {
      <div className=%twc("w-[1280px] mx-auto min-h-full")>
        <div className=%twc("w-full flex items-center justify-center pt-20")>
          <span className=%twc("text-3xl text-gray-800")>
            <span className=%twc("font-bold")> {keyword->React.string} </span>
            {`에 대한 검색결과`->React.string}
          </span>
        </div>
        <div className=%twc("mt-20 w-full flex items-center justify-end")>
          <ShopProductsSortSelect_Buyer />
        </div>
        <div>
          <ol className=%twc("mt-12 grid grid-cols-4 gap-x-10 gap-y-16")>
            {products.edges
            ->Array.map(({cursor, node}) => {
              <ShopProductListItem_Buyer.PC key=cursor query=node.fragmentRefs />
            })
            ->React.array}
          </ol>
          <div ref={ReactDOM.Ref.domRef(loadMoreRef)} className=%twc("h-20 w-full") />
        </div>
      </div>
    }
  }
}

module MO = {
  module Empty = {
    @react.component
    let make = (~keyword) => {
      <>
        <div className=%twc("w-full flex items-center justify-center pt-[134px] px-5")>
          <span className=%twc("text-gray-800 text-xl text-center")>
            <span className=%twc("font-bold")> {keyword->React.string} </span>
            {`에 대한 검색결과`->React.string}
          </span>
        </div>
        <div
          className=%twc(
            "mt-2 w-full flex flex-col items-center justify-center text-center text-base text-gray-600"
          )>
          <span>
            <span className=%twc("text-green-500 font-bold")> {keyword->React.string} </span>
            {`의 검색결과가 없습니다.`->React.string}
          </span>
          <span> {`다른 검색어를 입력하시거나`->React.string} </span>
          <span> {`철자와 띄어쓰기를 확인해 보세요.`->React.string} </span>
        </div>
      </>
    }
  }

  @react.component
  let make = (~keyword, ~query) => {
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

    if products.edges->Array.length == 0 {
      <Empty keyword />
    } else {
      <div className=%twc("w-full px-5")>
        <div className=%twc("py-4 w-full flex items-center justify-end")>
          <ShopProductsSortSelect_Buyer.MO />
        </div>
        <div>
          <ol className=%twc("grid grid-cols-2 gap-x-4 gap-y-8")>
            {products.edges
            ->Array.map(({cursor, node}) => {
              <ShopProductListItem_Buyer.MO key=cursor query=node.fragmentRefs />
            })
            ->React.array}
          </ol>
          <div ref={ReactDOM.Ref.domRef(loadMoreRef)} className=%twc("h-20 w-full") />
        </div>
      </div>
    }
  }
}

module Container = {
  @react.component
  let make = (~keyword, ~sort) => {
    // 채널톡 버튼 사용
    ChannelTalkHelper.Hook.use()

    let {fragmentRefs} = Query.use(
      ~variables=Query.makeVariables(~name=keyword, ~count=20, ~sort, ~onlyBuyable=true, ()),
      ~fetchPolicy=RescriptRelay.StoreOrNetwork,
      (),
    )

    <Layout_Buyer.Responsive
      pc={<PC keyword query=fragmentRefs />} mobile={<MO keyword query=fragmentRefs />}
    />
  }
}

@react.component
let make = () => {
  let router = Next.Router.useRouter()
  let keyword = router.query->Js.Dict.get("keyword")->Option.map(Js.Global.decodeURIComponent)
  let sort =
    router.query
    ->Js.Dict.get("sort")
    ->Option.flatMap(ShopProductsSortSelect_Buyer.decodeSort)
    ->Option.getWithDefault(#UPDATED_DESC)

  <>
    <Next.Head> <title> {`신선하이`->React.string} </title> </Next.Head>
    <RescriptReactErrorBoundary fallback={_ => <div> {`에러`->React.string} </div>}>
      <React.Suspense fallback={<Placeholder />}>
        {switch keyword {
        | Some(keyword') => <Container keyword=keyword' sort />
        | None => <Placeholder />
        }}
      </React.Suspense>
    </RescriptReactErrorBoundary>
  </>
}
