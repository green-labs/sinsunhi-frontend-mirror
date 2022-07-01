module Mutation = %relay(`
  mutation SelectBulkSaleCampaignStatusMutation(
    $id: ID!
    $input: BulkSaleCampaignUpdateInput!
  ) {
    updateBulkSaleCampaign(id: $id, input: $input) {
      result {
        ...BulkSaleProductAdminFragment_bulkSaleCampaign
      }
    }
  }
`)

let stringifyStatus = s => s ? "open" : "end"
let displayStatus = s =>
  switch s {
  | true => `모집중`
  | false => `모집완료`
  }

@react.component
let make = (
  ~product: BulkSaleProductAdminFragment_bulkSaleCampaign_graphql.Types.fragment,
  ~refetchSummary,
) => {
  let {addToast} = ReactToastNotifications.useToasts()

  let (mutate, isMutating) = Mutation.use()

  let handleOnChange = e => {
    let value = (e->ReactEvent.Synthetic.target)["value"]
    mutate(
      ~variables=Mutation.makeVariables(
        ~id=product.id,
        ~input=Mutation.make_bulkSaleCampaignUpdateInput(
          ~isOpen=value == "open" ? true : false,
          (),
        ),
      ),
      ~onCompleted={
        (_, _) => {
          addToast(.
            <div className=%twc("flex items-center")>
              <IconCheck height="24" width="24" fill="#12B564" className=%twc("mr-2") />
              {j`수정 요청에 성공하였습니다.`->React.string}
            </div>,
            {appearance: "success"},
          )
          refetchSummary()
        }
      },
      ~onError={
        err => {
          addToast(.
            <div className=%twc("flex items-center")>
              <IconError height="24" width="24" className=%twc("mr-2") />
              {err.message->React.string}
            </div>,
            {appearance: "error"},
          )
        }
      },
      (),
    )->ignore
  }

  <label className=%twc("block relative")>
    <span
      className=%twc(
        "flex items-center border border-border-default-L1 rounded-md h-9 px-3 text-enabled-L1"
      )>
      {product.isOpen->displayStatus->React.string}
    </span>
    <span className=%twc("absolute top-1.5 right-2")>
      <IconArrowSelect height="24" width="24" fill="#121212" />
    </span>
    <select
      value={product.isOpen->stringifyStatus}
      className=%twc("block w-full h-full absolute top-0 opacity-0")
      onChange={handleOnChange}
      disabled=isMutating>
      {[true, false]
      ->Garter.Array.map(s =>
        <option key={s->stringifyStatus} value={s->stringifyStatus}>
          {s->displayStatus->React.string}
        </option>
      )
      ->React.array}
    </select>
  </label>
}
