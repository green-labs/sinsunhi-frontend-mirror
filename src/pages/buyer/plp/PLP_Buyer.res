/*
 * 1. 컴포넌트 위치
 *    PLP
 *
 * 2. 역할
 *    전시카테고리(category-id)가 파라메터가 전달된 경우 특정 전시 카테고리 내 상품리스트,
      전시카테고리(category-id)가 파라메터가 전달되지 않은 경우 전체 상품
 *
 */

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
    <Next.Head> <title> {`신선하이`->React.string} </title> </Next.Head>
    {switch isCsr {
    | false => <PLP_DisplayCategory_Buyer.Placeholder />

    | true =>
      switch displayCategoryId {
      // 전체 상품
      | None => <PLP_All_Buyer />

      // 특정 전시카테고리 내 상품
      | Some(displayCategoryId') =>
        <PLP_DisplayCategory_Buyer displayCategoryId=displayCategoryId' />
      }
    }}
  </>
}
