/*
 * 1. 컴포넌트 위치
 *    바이어 메인 - 특별 기획전 리스트
 *
 * 2. 역할
 *    특별 기획전 리스트와 그에 속한 상품 리스트를 표현합니다.
 *
 */

module Fragment = %relay(`
  fragment ShopMainSpecialShowcaseListBuyerFragment on Query
  @argumentDefinitions(
    first: { type: "Int", defaultValue: 8 }
    after: { type: "ID", defaultValue: null }
    sort: { type: "DisplayCategoryProductsSort", defaultValue: UPDATED_DESC }
    onlyDisplayable: { type: "Boolean", defaultValue: true }
    onlyBuyable: { type: "Boolean", defaultValue: true }
  ) {
    specialDisplayCategories(onlyDisplayable: $onlyDisplayable) {
      id
      name
      products(
        first: $first
        after: $after
        sort: $sort
        onlyBuyable: $onlyBuyable
      ) {
        pageInfo {
          hasNextPage
        }
        edges {
          cursor
          node {
            ...ShopProductListItemBuyerFragment
          }
        }
      }
    }
  }
`)

module PC = {
  module Placeholder = {
    @react.component
    let make = () => {
      <div>
        {Array.range(1, 10)
        ->Array.map(categoryIdx => {
          let containerStyle =
            categoryIdx == 1 ? %twc("w-full bg-[#F9F9F9] py-16") : %twc("w-full bg-white py-16")

          <section key={`showcase-skeleton-${categoryIdx->Int.toString}`} className=containerStyle>
            <div className=%twc("w-[1280px] mx-auto")>
              <div className=%twc("w-[155px] h-[38px] animate-pulse bg-gray-150 rounded-lg") />
              <ol className=%twc("mt-12 grid grid-cols-4 gap-x-10 gap-y-16")>
                {Array.range(1, 8)
                ->Array.map(idx => {
                  <ShopProductListItem_Buyer.PC.Placeholder
                    key={`category-${categoryIdx->Int.toString}-product-skeleton-${idx->Int.toString}`}
                  />
                })
                ->React.array}
              </ol>
            </div>
          </section>
        })
        ->React.array}
      </div>
    }
  }

  @react.component
  let make = (~query) => {
    let {useRouter, pushObj} = module(Next.Router)
    let router = useRouter()

    let {specialDisplayCategories} = Fragment.use(query)

    let makeOnClick = (id, name) => {
      ReactEvents.interceptingHandler(_ => {
        router->pushObj({
          pathname: "/buyer/products",
          query: [
            ("category-id", id),
            ("category-name", name->Js.Global.encodeURIComponent),
          ]->Js.Dict.fromArray,
        })
      })
    }

    specialDisplayCategories
    ->Array.mapWithIndex((idx, {id, name, products: {edges, pageInfo}}) => {
      let containerStyle =
        idx == 0
          ? %twc("w-full bg-[#F9F9F9] py-16 mb-[144px] text-gray-800")
          : %twc("w-full mb-[144px] bg-white text-gray-800")

      switch edges {
      | [] => React.null

      | _ =>
        <section key={`main-special-category-${id}-pc`} className=containerStyle>
          <div className=%twc("w-[1280px] mx-auto")>
            <h1 className=%twc("text-2xl font-bold")> {name->React.string} </h1>
            <ol className=%twc("mt-12 grid grid-cols-4 gap-x-10 gap-y-16")>
              {edges
              ->Array.map(({cursor, node: {fragmentRefs}}) => {
                <React.Suspense
                  key={`main-special-category-${id}-list-item-${cursor}-pc`}
                  fallback={<ShopProductListItem_Buyer.PC.Placeholder />}>
                  <ShopProductListItem_Buyer.PC query=fragmentRefs />
                </React.Suspense>
              })
              ->React.array}
            </ol>
            {switch pageInfo.hasNextPage {
            | false => React.null

            | true =>
              <div className=%twc("mt-12 flex items-center justify-center")>
                <button
                  onClick={makeOnClick(id, name)}
                  className=%twc("px-6 py-3 bg-gray-100 rounded-full text-sm flex items-center")>
                  {`전체보기`->React.string}
                  <IconArrow className=%twc("ml-1") width="16" height="16" fill="#262626" />
                </button>
              </div>
            }}
          </div>
        </section>
      }
    })
    ->React.array
  }
}

module MO = {
  module Placeholder = {
    @react.component
    let make = () => {
      <div>
        {Array.range(1, 10)
        ->Array.map(categoryIdx => {
          <section
            key={`showcase-skeleton-${categoryIdx->Int.toString}`}
            className=%twc("w-full px-5 mt-12")>
            <div className=%twc("w-full")>
              <div className=%twc("w-[107px] h-[26px] animate-pulse bg-gray-150 rounded-lg") />
              <ol className=%twc("mt-4 grid grid-cols-2 gap-x-4 gap-y-8")>
                {Array.range(1, 6)
                ->Array.map(idx => {
                  <ShopProductListItem_Buyer.MO.Placeholder
                    key={`category-${categoryIdx->Int.toString}-product-skeleton-${idx->Int.toString}`}
                  />
                })
                ->React.array}
              </ol>
            </div>
          </section>
        })
        ->React.array}
      </div>
    }
  }

  @react.component
  let make = (~query) => {
    let {useRouter, pushObj} = module(Next.Router)
    let router = useRouter()

    let {specialDisplayCategories} = Fragment.use(query)

    let makeOnClick = (id, name) => {
      ReactEvents.interceptingHandler(_ => {
        router->pushObj({
          pathname: "/buyer/products",
          query: [
            ("category-id", id),
            ("category-name", name->Js.Global.encodeURIComponent),
          ]->Js.Dict.fromArray,
        })
      })
    }

    specialDisplayCategories
    ->Array.map(({id, name, products: {edges, pageInfo}}) => {
      switch edges {
      | [] => React.null

      | _ =>
        <section key={`main-special-category-${id}-mobile`} className=%twc("w-full px-5 mt-12")>
          <div className=%twc("w-full")>
            <h1 className=%twc("text-lg font-bold")> {name->React.string} </h1>
            <ol className=%twc("mt-4 grid grid-cols-2 gap-x-4 gap-y-8")>
              {edges
              ->Array.map(({cursor, node: {fragmentRefs}}) => {
                <React.Suspense
                  key={`main-special-category-${id}-list-item-${cursor}-mobile`}
                  fallback={<ShopProductListItem_Buyer.MO.Placeholder />}>
                  <ShopProductListItem_Buyer.MO query=fragmentRefs />
                </React.Suspense>
              })
              ->React.array}
            </ol>
            {switch pageInfo.hasNextPage {
            | false => React.null

            | true =>
              <div className=%twc("mt-8 flex items-center justify-center")>
                <button
                  onClick={makeOnClick(id, name)}
                  className=%twc(
                    "px-[18px] py-[10px] bg-gray-100 rounded-full text-sm flex items-center"
                  )>
                  {`전체보기`->React.string}
                  <IconArrow className=%twc("ml-1") width="16" height="16" fill="#262626" />
                </button>
              </div>
            }}
          </div>
        </section>
      }
    })
    ->React.array
  }
}
