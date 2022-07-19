/*
 * 1. 컴포넌트 위치
 *    PLP (전시 카테고리 내 상품 리스트 페이지) 헤더
 *
 * 2. 역할
 *    쿼리 파라메터로 전달된 display-category-id를 활용하여, 전시 카테고리 이름을 조회, Gnb에 표현합니다
 *
 */
module DisplayCategoryName = {
  module Query = %relay(`
    query PLPHeaderBuyerQuery($displayCategoryId: ID!) {
      node(id: $displayCategoryId) {
        ... on DisplayCategory {
          name
        }
      }
    }
  `)

  @react.component
  let make = (~displayCategoryId) => {
    let {node} = Query.use(~variables=Query.makeVariables(~displayCategoryId), ())

    switch node {
    | None => <span />
    | Some({name}) => <span className=%twc("font-bold text-xl")> {name->React.string} </span>
    }
  }
}

@react.component
let make = () => {
  let router = Next.Router.useRouter()
  let displayCategoryId = router.query->Js.Dict.get("category-id")

  let (isCsr, setIsCsr) = React.Uncurried.useState(_ => false)

  React.useEffect0(() => {
    setIsCsr(._ => true)
    None
  })

  <>
    // position fixed
    <div className=%twc("w-full fixed top-0 left-0 z-10 bg-white")>
      <header className=%twc("w-full max-w-3xl mx-auto h-14 bg-white")>
        <div className=%twc("px-5 py-4 flex justify-between")>
          <button onClick={_ => router->Next.Router.back}>
            <img src="/assets/arrow-right.svg" className=%twc("w-6 h-6 rotate-180") />
          </button>
          <div>
            {switch isCsr {
            | false => <span />

            | true =>
              switch displayCategoryId {
              // 전체 상품 리스트
              | None =>
                <span className=%twc("font-bold text-xl")> {`전체 상품`->React.string} </span>

              // 특정 전시카테고리 내 상품 리스트
              | Some(displayCategoryId') =>
                <RescriptReactErrorBoundary fallback={_ => <span />}>
                  <React.Suspense fallback={<span />}>
                    <DisplayCategoryName displayCategoryId=displayCategoryId' />
                  </React.Suspense>
                </RescriptReactErrorBoundary>
              }
            }}
          </div>
          <button onClick={_ => router->Next.Router.push("/buyer")}>
            <IconHome height="24" width="24" fill="#262626" />
          </button>
        </div>
      </header>
    </div>
    // placeholder
    <div className=%twc("w-full h-14") />
  </>
}
