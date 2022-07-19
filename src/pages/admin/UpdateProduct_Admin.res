module Query = %relay(`
query UpdateProductAdminQuery($productId: ID!) {
  node(id: $productId) {
    ... on Product {
      __typename
      ...UpdateProductDetailAdminFragment
    }
  }
}
`)

module Detail = {
  @react.component
  let make = (~productId) => {
    let queryData = Query.use(
      ~variables={productId: productId},
      ~fetchPolicy=RescriptRelay.StoreAndNetwork,
      (),
    )

    switch queryData.node {
    | Some(node) =>
      switch node.__typename->Product_Parser.Type.decode {
      | Some(productType) => <UpdateProduct_Detail_Admin query={node.fragmentRefs} productType />
      | None => <div> {`지원하지 않은 상품 타입입니다.`->React.string} </div>
      }

    | None => <div> {`상품 정보가 존재하지 않습니다.`->React.string} </div>
    }
  }
}

@react.component
let make = () => {
  let router = Next.Router.useRouter()
  let pid = router.query->Js.Dict.get("pid")

  <Authorization.Admin title=`상품 조회/수정`>
    <RescriptReactErrorBoundary fallback={_ => <div> {`에러 발생`->React.string} </div>}>
      <React.Suspense fallback={<div> {`로딩 중..`->React.string} </div>}>
        {switch pid {
        | Some(pid') => <Detail productId={pid'} />
        | None => <div> {`상품 정보가 존재하지 않습니다.`->React.string} </div>
        }}
      </React.Suspense>
    </RescriptReactErrorBoundary>
  </Authorization.Admin>
}
