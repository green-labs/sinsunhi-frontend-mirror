let getFallback = fallback =>
  fallback->Option.getWithDefault(<div> {j`인증 확인 중 입니다.`->React.string} </div>)

module type UserHook = {
  let use: unit => CustomHooks.Auth.status
}

module Layout = (UserHook: UserHook) => {
  @react.component
  let make = (~children, ~title, ~fallback=?) => {
    let user = UserHook.use()
    <>
      <Next.Head> <title> {j`${title} - 신선하이`->React.string} </title> </Next.Head>
      {switch user {
      // TODO 로딩상태 페이지 추가 필요
      | Unknown => React.null
      | NotLoggedIn => fallback->getFallback
      | LoggedIn(_) => children
      }}
    </>
  }
}

module Admin = Layout(CustomHooks.User.Admin)

module Buyer = Layout(CustomHooks.User.Buyer)

module Seller = Layout(CustomHooks.User.Seller)
