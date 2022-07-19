/*
 * 1. 컴포넌트 위치
 *    구 전체상품 페이지
 *
 * 2. 역할
 *    기존 전체상품 url 변경(/buyer/products/all -> /buyer/products)
 *    기존에 공유된 url 진입에 대응하기 위해, 구 url로 진입하는 경우 신 url로 redirect 시켜준다.
 *    적용일: 2022.07.04
 *    제거 예정일: 2022.08.01
 */

@react.component
let make = () => {
  let {useRouter, replace} = module(Next.Router)
  let router = useRouter()
  React.useEffect0(() => {
    router->replace(`/buyer/products`)
    None
  })

  <PLP_DisplayCategory_Buyer.Placeholder />
}
