module Query = %relay(`
  query RfqConfirmSeller_RfqQuotatinoMeatNode_Query($id: ID!) {
    node(id: $id) {
      ... on RfqQuotationMeat {
        id
        requestItem {
          ... on RfqRequestItemMeat {
            id
          }
        }
      }
    }
  }
`)

module ConfirmPageRouter = {
  @react.component
  let make = (~quotationId) => {
    let {node} = Query.use(~variables={id: quotationId}, ())
    let router = Next.Router.useRouter()

    switch node {
    | Some(itemMeat) => {
        router->Next.Router.replace(`/seller/rfq/request/${itemMeat.requestItem.id}`)
        React.null
      }
    | None => <DS_None.Default message={`견적서 정보가 없습니다.`} />
    }
  }
}

@react.component
let make = (~quotationId: option<string>) => {
  <Authorization.Seller fallback={React.null} title=`견적 확인`>
    <React.Suspense>
      {switch quotationId {
      | Some(quotationId') => <ConfirmPageRouter quotationId={quotationId'} />
      | None =>
        <DS_None.Default
          message={`견적요청서 정보를 불러올 수 없습니다. 관리자에게 문의해주세요.`}
        />
      }}
    </React.Suspense>
  </Authorization.Seller>
}
