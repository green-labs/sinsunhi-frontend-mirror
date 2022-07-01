module Query = %relay(`
  query PLPAllBuyerQuery(
    $cursor: String
    $count: Int!
    $sort: ProductsQueryInputSort!
    $onlyBuyable: Boolean
  ) {
    ...PLPAllBuyerFragment
      @arguments(
        count: $count
        cursor: $cursor
        sort: $sort
        onlyBuyable: $onlyBuyable
      )
  }
`)

module Fragment = %relay(`
  fragment PLPAllBuyerFragment on Query
  @refetchable(queryName: "PLPAllBuyerRefetchQuery")
  @argumentDefinitions(
    cursor: { type: "String", defaultValue: null }
    onlyBuyable: { type: "Boolean", defaultValue: null }
    count: { type: "Int!" }
    sort: { type: "ProductsQueryInputSort!" }
  ) {
    products(
      after: $cursor
      first: $count
      sort: $sort
      onlyBuyable: $onlyBuyable
    ) @connection(key: "PLPAllBuyer_products") {
      edges {
        cursor
        node {
          ...ShopProductListItemBuyerFragment
        }
      }
    }
  }
`)

module PC = {
  module Empty = {
    @react.component
    let make = () => {
      <>
        <div className=%twc("font-bold text-3xl text-gray-800")>
          {`전체 상품`->React.string}
        </div>
        <div className=%twc("mt-20 flex flex-col items-center justify-center text-gray-800")>
          <h1 className=%twc("text-3xl")>
            {`상품이 존재하지 않습니다`->React.string}
          </h1>
          <span className=%twc("mt-7")>
            {`해당 카테고리에 상품이 존재하지 않습니다.`->React.string}
          </span>
          <span> {`다른 카테고리를 선택해 주세요.`->React.string} </span>
        </div>
      </>
    }
  }

  @react.component
  let make = (~query) => {
    let {data: {products}, hasNext, loadNext} = query->Fragment.usePagination

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

    switch products.edges->Array.length == 0 {
    | true => <Empty />
    | false =>
      <div className=%twc("w-[1280px] pt-20 px-5 pb-16 mx-auto min-h-full")>
        <div className=%twc("font-bold text-3xl text-gray-800")>
          {`전체 상품`->React.string}
        </div>
        <div className=%twc("mt-[88px]")>
          <div className=%twc("mb-12 w-full flex items-center justify-end")>
            <ShopProductsSortSelect_Buyer />
          </div>
          <ol className=%twc("grid grid-cols-4 gap-x-10 gap-y-16")>
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
    let make = () => {
      <>
        <div
          className=%twc("mt-[126px] flex flex-col items-center justify-center text-gray-800 px-5")>
          <h1 className=%twc("text-xl")> {`상품이 존재하지 않습니다`->React.string} </h1>
          <span className=%twc("mt-2 text-sm text-gray-600 text-center")>
            {`해당 카테고리에 상품이 존재하지 않습니다.`->React.string}
          </span>
          <span className=%twc("mt-2 text-sm text-gray-600 text-center")>
            {`다른 카테고리를 선택해 주세요.`->React.string}
          </span>
        </div>
      </>
    }
  }

  @react.component
  let make = (~query) => {
    let {data: {products}, hasNext, loadNext} = query->Fragment.usePagination

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

    switch products.edges->Array.length == 0 {
    | true => <Empty />
    | false =>
      <div className=%twc("w-full pt-4 px-5")>
        <div className=%twc("mb-4 w-full flex items-center justify-end")>
          <ShopProductsSortSelect_Buyer.MO />
        </div>
        <ol className=%twc("grid grid-cols-2 gap-x-4 gap-y-8")>
          {products.edges
          ->Array.map(({cursor, node}) => {
            <ShopProductListItem_Buyer.MO key=cursor query=node.fragmentRefs />
          })
          ->React.array}
        </ol>
        <div ref={ReactDOM.Ref.domRef(loadMoreRef)} className=%twc("h-20 w-full") />
      </div>
    }
  }
}

module Placeholder = {
  @react.component
  let make = () => {
    <Layout_Buyer.Responsive
      pc={<div className=%twc("w-[1280px] pt-20 px-5 pb-16 mx-auto")>
        <div className=%twc("w-[160px] h-[44px] rounded-lg animate-pulse bg-gray-150") />
        <section className=%twc("w-full mt-[88px]")>
          <ol className=%twc("grid grid-cols-4 gap-x-10 gap-y-16")>
            {Array.range(1, 300)
            ->Array.map(number => {
              <ShopProductListItem_Buyer.PC.Placeholder key={`box-${number->Int.toString}`} />
            })
            ->React.array}
          </ol>
        </section>
      </div>}
      mobile={<div className=%twc("w-full py-4 px-5")>
        <div className=%twc("mb-4 w-full flex items-center justify-end")>
          <div className=%twc("w-12 h-5 bg-gray-150 rounded-lg animate-pulse") />
        </div>
        <ol className=%twc("grid grid-cols-2 gap-x-4 gap-y-8")>
          {Array.range(1, 300)
          ->Array.map(num => {
            <ShopProductListItem_Buyer.MO.Placeholder
              key={`list-item-skeleton-${num->Int.toString}`}
            />
          })
          ->React.array}
        </ol>
      </div>}
    />
  }
}

module Container = {
  @react.component
  let make = (~sort) => {
    // 채널톡 버튼 사용
    ChannelTalkHelper.Hook.use()

    let variables = Query.makeVariables(~sort, ~count=20, ~onlyBuyable=true, ())
    let {fragmentRefs} = Query.use(~variables, ~fetchPolicy=RescriptRelay.StoreOrNetwork, ())

    <Layout_Buyer.Responsive pc={<PC query=fragmentRefs />} mobile={<MO query=fragmentRefs />} />
  }
}

@react.component
let make = () => {
  let router = Next.Router.useRouter()
  let sort = {
    router.query
    ->Js.Dict.get("sort")
    ->Option.flatMap(ShopProductsSortSelect_Buyer.decodeSort)
    ->Option.getWithDefault(#UPDATED_DESC)
  }

  let (isCsr, setIsCsr) = React.Uncurried.useState(_ => false)

  React.useEffect0(() => {
    setIsCsr(._ => true)
    None
  })

  <>
    <Next.Head> <title> {`신선하이`->React.string} </title> </Next.Head>
    <RescriptReactErrorBoundary fallback={_ => <Placeholder />}>
      <React.Suspense fallback={<Placeholder />}>
        {switch isCsr {
        | true => <Container sort />
        | false => <Placeholder />
        }}
      </React.Suspense>
    </RescriptReactErrorBoundary>
  </>
}
