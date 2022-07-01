type service =
  | Seller
  | Buyer
  | Admin

let parsePath = path => {
  switch path {
  | "buyer" => Some(Buyer)
  | "seller" => Some(Seller)
  | "admin" => Some(Admin)
  | _ => None
  }
}

let getFirstPath = pathname => {
  pathname->Js.String2.split("/")->Array.get(1)
}

module Buyer = {
  @react.component
  let make = () => {
    <div className=%twc("w-screen h-screen flex flex-col items-center justify-start")>
      <Header_Buyer.PC />
      <div className=%twc("flex flex-col h-full items-center justify-center")>
        <IconNotFound width="160" height="160" />
        <h1 className=%twc("mt-7 text-3xl text-gray-800")>
          {`페이지를 찾을 수 없습니다.`->React.string}
        </h1>
        <span className=%twc("mt-7 text-gray-800")>
          {`페이지가 존재하지 않거나 사용할 수 없는 페이지입니다.`->React.string}
        </span>
        <span className=%twc("text-gray-800")>
          {`입력하신 주소가 정확한지 다시 한 번 확인해주세요.`->React.string}
        </span>
      </div>
    </div>
  }
}

module Default = {
  @react.component
  let make = () => {
    <div className=%twc("w-screen h-screen flex items-center justify-center")>
      <div className=%twc("flex flex-col items-center justify-center")>
        <IconNotFound width="160" height="160" />
        <h1 className=%twc("mt-7 text-3xl text-gray-800")>
          {`페이지를 찾을 수 없습니다.`->React.string}
        </h1>
        <span className=%twc("mt-7 text-gray-800")>
          {`페이지가 존재하지 않거나 사용할 수 없는 페이지입니다.`->React.string}
        </span>
        <span className=%twc("text-gray-800")>
          {`입력하신 주소가 정확한지 다시 한 번 확인해주세요.`->React.string}
        </span>
      </div>
    </div>
  }
}

module Container = {
  @react.component
  let make = () => {
    let router = Next.Router.useRouter()
    let service = router.asPath->getFirstPath->Option.flatMap(parsePath)

    switch service {
    | Some(Buyer) => <Buyer />
    | Some(Seller) | Some(Admin) | None => <Default />
    }
  }
}

@react.component
let make = () => {
  /*
   *  각 서비스 별 독립된 404페이지를 설정하기 위해선
   *  router.asPath를 이용하여 유저가 접근하고자 했던 url을 파악하여야함.
   *  router.asPath는 server-side에선 "/404"라고 보여지기때문에
   *  router.asPath를 활용하기 위해 404페이지는 csr로 작성하였음
   */

  let (isCsr, setIsCsr) = React.Uncurried.useState(_ => false)

  React.useEffect0(() => {
    setIsCsr(._ => true)
    None
  })

  <>
    <Next.Head> <title> {`신선하이`->React.string} </title> </Next.Head>
    {switch isCsr {
    | true => <Container />
    | false => React.null
    }}
  </>
}
