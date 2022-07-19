/*
 * 1. 컴포넌트 위치
 *    PDP 모바일 헤더
 *
 * 2. 역할
 *    쿼리 파라메터로 전달된 pid(product node id)를 활용하여, 상품 타입에 맞는 헤더를 표현합니다
 *
 */

module Query = %relay(`
  query PDPHeaderBuyerQuery($id: ID!) {
    node(id: $id) {
      ...PDPHeaderBuyerFragment
    }
  }
`)

module Fragment = %relay(`
  fragment PDPHeaderBuyerFragment on Product {
    __typename
  
    ...PDPMatchingHeaderBuyer_fragment
  }
`)

module Default = {
  @react.component
  let make = () => {
    let router = Next.Router.useRouter()

    <>
      // position fixed
      <div className=%twc("w-full fixed top-0 left-0 z-10 bg-white")>
        <header className=%twc("w-full max-w-3xl mx-auto h-14 bg-white")>
          <div className=%twc("px-5 py-4 flex justify-between")>
            <button onClick={_ => router->Next.Router.back}>
              <img src="/assets/arrow-right.svg" className=%twc("w-6 h-6 rotate-180") />
            </button>
            <div>
              <span className=%twc("font-bold text-xl")> {`상품 상세`->React.string} </span>
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
}

module Placeholder = {
  @react.component
  let make = () => {
    let router = Next.Router.useRouter()

    <>
      // position fixed
      <div className=%twc("w-full fixed top-0 left-0 z-10 bg-white")>
        <header className=%twc("w-full max-w-3xl mx-auto h-14 bg-white")>
          <div className=%twc("px-5 py-4 flex justify-between")>
            <button onClick={_ => router->Next.Router.back}>
              <img src="/assets/arrow-right.svg" className=%twc("w-6 h-6 rotate-180") />
            </button>
            <div />
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
}

module Presenter = {
  @react.component
  let make = (~query) => {
    let {__typename, fragmentRefs} = query->Fragment.use
    switch __typename->Product_Parser.Type.decode {
    | Some(Matching) => <PDP_Matching_Header_Buyer query=fragmentRefs />
    | _ => <Default />
    }
  }
}

module Container = {
  @react.component
  let make = (~nodeId) => {
    let {node} = Query.use(~variables={id: nodeId}, ~fetchPolicy=RescriptRelay.StoreAndNetwork, ())
    switch node {
    | Some({fragmentRefs}) => <Presenter query=fragmentRefs />
    | None => <Placeholder />
    }
  }
}

@react.component
let make = () => {
  let router = Next.Router.useRouter()
  let pid = router.query->Js.Dict.get("pid")
  switch pid {
  | Some(nodeId) => <Container nodeId />
  | None => <Placeholder />
  }
}
