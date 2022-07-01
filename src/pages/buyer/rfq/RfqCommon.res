module CheckBuyerRequestStatus = {
  module Query = %relay(`
    query RfqCommon_RfqRequest_Query($id: ID!) {
      node(id: $id) {
        __typename
        ... on RfqRequest {
          id
          status
        }
      }
    }
  `)

  type status = RfqCommon_RfqRequest_Query_graphql.Types.enum_RfqRequestStatus
  type result = Unknown | RequestStatus(status)

  let use = id => {
    let {node} = Query.use(~variables={id: id}, ())

    switch node {
    | Some(node') => RequestStatus(node'.status)
    | None => Unknown
    }
  }

  @react.component
  let make = (~children, ~requestId) => {
    let router = Next.Router.useRouter()
    let result = use(requestId)

    let handleRedirect = _ => {
      router->Next.Router.push(`/buyer/rfq`)
    }

    React.useEffect0(_ => {
      switch result {
      | RequestStatus(status) =>
        switch status {
        | #DRAFT => ()
        | _ => handleRedirect()
        }
      | Unknown => handleRedirect()
      }
      None
    })

    switch result {
    | RequestStatus(status) =>
      switch status {
      | #DRAFT => children
      | _ => React.null
      }
    | Unknown => React.null
    }
  }
}
