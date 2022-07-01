module Query = %relay(`
  query RfqCreateRequestButton_RfqRequests_Query {
    ...RfqCreateRequestButton_RfqRequests_Fragment
  }
`)

module Fragment = %relay(`
    fragment RfqCreateRequestButton_RfqRequests_Fragment on Query
    @refetchable(queryName: "RfqCreateRequestButton_RfqRequests_Fragment_Query")
    @argumentDefinitions(
      after: { type: "ID" }
      first: { type: "Int", defaultValue: 20 }
      orderDirection: { type: "OrderDirection", defaultValue: DESC }
    ) {
      rfqRequests(after: $after, first: $first, orderDirection: $orderDirection)
        @connection(key: "RfqCreateRequestButton_rfqRequests") {
        __id
        edges {
          node {
            id
            status
          }
        }
      }
    }
`)

module Mutation = {
  module Create = %relay(`
    mutation RfqCreateRequestButton_Create_Request_Mutation($connections: [ID!]!) {
      createRfqRequest(input: { status: DRAFT }) {
        ... on RfqRequestMutationPayload {
          result
            @prependNode(
              connections: $connections
              edgeTypeName: "RfQRequestEdge"
            ) {
            id
            status
          }
        }
      }
    }`)

  module Delete = %relay(`
    mutation RfqCreateRequestButton_Delete_Request_Mutation(
      $id: ID!
      $connections: [ID!]!
    ) {
      deleteRfqRequest(id: $id) {
        ... on DeleteSuccess {
          deletedId @deleteEdge(connections: $connections)
        }
      }
    }`)
}

type bottonPosition = [#top | #bottom]

module Button = {
  module Buyer = {
    @react.component
    let make = (~className, ~buttonText, ~position=?) => {
      let router = Next.Router.useRouter()
      let {addToast} = ReactToastNotifications.useToasts()

      let query = Query.use(~variables=(), ())
      let {data} = query.fragmentRefs->Fragment.usePagination

      let firstRequest = data.rfqRequests->Fragment.getConnectionNodes->Array.get(0)

      let (createRequest, _) = Mutation.Create.use()
      let (deleteRequest, _) = Mutation.Delete.use()

      let moveBasketWithRequestId = requestId =>
        router->Next.Router.push(`/buyer/rfq/request/draft/basket?requestId=${requestId}`)

      let createToast = (text: string) =>
        addToast(. text->DS_Toast.getToastComponent(#error), {appearance: "error"})

      let createNewRequest = () => {
        createRequest(
          ~variables={connections: [data.rfqRequests.__id]},
          ~onCompleted={
            ({createRfqRequest}, _) => {
              switch createRfqRequest {
              | #RfqRequestMutationPayload(payload) =>
                switch payload.result {
                | Some(request) => moveBasketWithRequestId(request.id)
                | None => createToast(`새로운 견적 생성에 실패했습니다.`)
                }
              | #UnselectedUnionMember(_) =>
                createToast(`새로운 견적 생성에 실패했습니다.`)
              }
            }
          },
          ~onError=_ => createToast(`새로운 견적 생성에 실패했습니다.`),
          (),
        )->ignore
      }

      let deleteDraftRequest = id => {
        deleteRequest(
          ~variables={id: id, connections: [data.rfqRequests.__id]},
          ~onCompleted=(_, _) => createNewRequest(),
          ~onError=_ => createToast(`작성 중이던 견적 삭제에 실패했습니다.`),
          (),
        )->ignore
      }

      let btnComponent =
        <button className onClick={_ => createNewRequest()}> {buttonText->React.string} </button>

      let dataGtm = position->Option.mapWithDefault("", p =>
        switch p {
        | #top => "Click_Button1_RFQ_Livestock_Landing"
        | #bottom => "Click_Button2_RFQ_Livestock_Landing"
        }
      )

      firstRequest->Option.mapWithDefault(btnComponent, request => {
        switch request.status {
        | #DRAFT =>
          <DS_Dialog.Popup.Root>
            <DS_Dialog.Popup.Trigger asChild=true>
              <button className> {buttonText->React.string} </button>
            </DS_Dialog.Popup.Trigger>
            <DS_Dialog.Popup.Portal>
              <DS_Dialog.Popup.Overlay />
              <DS_Dialog.Popup.Content>
                <DS_Dialog.Popup.Title>
                  {`작성중인 견적서가 있습니다.`->React.string}
                </DS_Dialog.Popup.Title>
                <DS_Dialog.Popup.Description>
                  {`이어서 작성하시겠어요?`->React.string}
                </DS_Dialog.Popup.Description>
                <DS_Dialog.Popup.Buttons>
                  <DS_Dialog.Popup.Close asChild=true>
                    <DataGtm dataGtm>
                      <a className=%twc("w-full") onClick={_ => ()}>
                        <DS_Button.Normal.Large1
                          buttonType=#white
                          onClick={_ => deleteDraftRequest(request.id)}
                          label={`새로 작성하기`}
                        />
                      </a>
                    </DataGtm>
                  </DS_Dialog.Popup.Close>
                  <DS_Dialog.Popup.Close asChild=true>
                    <DataGtm dataGtm>
                      <a className=%twc("w-full") onClick={_ => ()}>
                        <DS_Button.Normal.Large1
                          label={`이어서 작성하기`}
                          onClick={_ => moveBasketWithRequestId(request.id)}
                        />
                      </a>
                    </DataGtm>
                  </DS_Dialog.Popup.Close>
                </DS_Dialog.Popup.Buttons>
              </DS_Dialog.Popup.Content>
            </DS_Dialog.Popup.Portal>
          </DS_Dialog.Popup.Root>
        | _ => btnComponent
        }
      })
    }
  }

  module UnauthorizedUser = {
    @react.component
    let make = (~className, ~buttonText) => {
      <DS_Dialog.Popup.Root>
        <DS_Dialog.Popup.Trigger asChild=true>
          <button className> {buttonText->React.string} </button>
        </DS_Dialog.Popup.Trigger>
        <DS_Dialog.Popup.Portal>
          <DS_Dialog.Popup.Overlay />
          <DS_Dialog.Popup.Content>
            <DS_Dialog.Popup.Title>
              {`바이어만 견적신청 서비스를 이용할 수 있어요.`->React.string}
            </DS_Dialog.Popup.Title>
            <DS_Dialog.Popup.Description>
              {`이용중인 계정을 다시 한번 확인해주세요.`->React.string}
            </DS_Dialog.Popup.Description>
            <DS_Dialog.Popup.Buttons>
              <DS_Dialog.Popup.Close asChild=true>
                <DS_Button.Normal.Large1 label={`닫기`} />
              </DS_Dialog.Popup.Close>
            </DS_Dialog.Popup.Buttons>
          </DS_Dialog.Popup.Content>
        </DS_Dialog.Popup.Portal>
      </DS_Dialog.Popup.Root>
    }
  }
}
@react.component
let make = (~className, ~buttonText=`최저가 견적받기`, ~position=?) => {
  let router = Next.Router.useRouter()
  let user = CustomHooks.User.Buyer.use2()

  let handleClickLoginButton = () => {
    let {makeWithDict, toString} = module(Webapi.Url.URLSearchParams)
    let redirectUrl = [("redirect", router.asPath)]->Js.Dict.fromArray->makeWithDict->toString
    router->Next.Router.push(`/buyer/signin?${redirectUrl}`)
  }

  switch user {
  | LoggedIn(user') =>
    switch user'.role {
    | Buyer => <Button.Buyer className buttonText ?position />
    | Seller | Admin => <Button.UnauthorizedUser className buttonText />
    }
  | NotLoggedIn
  | Unknown =>
    <button className onClick={_ => handleClickLoginButton()}> {buttonText->React.string} </button>
  }
}
