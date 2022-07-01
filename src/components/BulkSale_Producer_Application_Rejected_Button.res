open RadixUI

module Mutation = %relay(`
  mutation BulkSaleProducerApplicationRejectedButtonMutation(
    $id: ID!
    $input: BulkSaleApplicationProgressInput!
  ) {
    changeBulkSaleApplicationProgress(id: $id, input: $input) {
      result {
        ...BulkSaleProducerAdminFragment_bulkSaleApplication
      }
    }
  }
`)

let makeInput = (
  progress,
  reason,
): BulkSaleProducerApplicationRejectedButtonMutation_graphql.Types.bulkSaleApplicationProgressInput => {
  progress: progress,
  reason: reason,
}

@react.component
let make = (
  ~application: BulkSaleProducerAdminFragment_bulkSaleApplication_graphql.Types.fragment,
  ~isShow,
  ~_open,
  ~close,
  ~refetchSummary,
) => {
  let {addToast} = ReactToastNotifications.useToasts()

  let (mutate, isMutating) = Mutation.use()

  let reason = application.bulkSaleEvaluations.edges->Array.get(0)->Option.map(r => r.node.reason)
  let (reason, setReason) = React.Uncurried.useState(_ => reason)

  let (formErrors, setFormErrors) = React.Uncurried.useState(_ => [])

  let handleOnSave = _ => {
    let input =
      makeInput
      ->V.map(V.pure(#REJECTED))
      ->V.ap(
        V.Option.nonEmpty(
          #ErrorReason(`보류 사유를 입력해주세요`),
          reason,
        )->Result.map(r => Some(r)),
      )

    switch input {
    | Ok(input') =>
      mutate(
        ~variables={
          id: application.id,
          input: input',
        },
        ~onCompleted={
          (_, _) => {
            addToast(.
              <div className=%twc("flex items-center")>
                <IconCheck height="24" width="24" fill="#12B564" className=%twc("mr-2") />
                {j`수정 요청에 성공하였습니다.`->React.string}
              </div>,
              {appearance: "success"},
            )
            close()
            setFormErrors(._ => [])
            refetchSummary()
          }
        },
        ~onError={
          err => {
            Js.Console.log(err)
            addToast(.
              <div className=%twc("flex items-center")>
                <IconError height="24" width="24" className=%twc("mr-2") />
                {err.message->React.string}
              </div>,
              {appearance: "error"},
            )
            setFormErrors(._ => [])
          }
        },
        (),
      )->ignore
    | Error(errors) => setFormErrors(._ => errors)
    }
  }

  let handleOnChange = (~cleanUpFn=?, setFn, e) => {
    let value = (e->ReactEvent.Synthetic.target)["value"]
    setFn(._ => value)
    switch cleanUpFn {
    | Some(f) => f()
    | None => ()
    }
  }

  let triggerStyle = switch application.progress {
  | #REJECTED => %twc("absolute top-9 left-0 text-text-L2 focus:outline-none text-left underline")
  | _ => %twc("hidden")
  }

  /*
   * 다이얼로그를 열어서 내용을 수정한 후 저장하지 않고 닫으면,
   * 수정한 내용이 남아 있는 이슈를 해결하기 위해, prefill 이용
   */
  <Dialog.Root _open=isShow>
    <Dialog.Overlay className=%twc("dialog-overlay") />
    <Dialog.Trigger className=triggerStyle onClick={_ => _open()}>
      <span className=%twc("block mt-[10px]")> {j`보류사유`->React.string} </span>
    </Dialog.Trigger>
    <Dialog.Content className=%twc("dialog-content overflow-y-auto")>
      <section className=%twc("p-5")>
        <article className=%twc("flex")>
          <h2 className=%twc("text-xl font-bold")> {j`판매 보류 사유`->React.string} </h2>
          <Dialog.Close
            className=%twc("inline-block p-1 focus:outline-none ml-auto") onClick={_ => close()}>
            <IconClose height="24" width="24" fill="#262626" />
          </Dialog.Close>
        </article>
        <article className=%twc("mt-4 whitespace-pre")>
          <p>
            {j`해당 사유는 농민에게 노출됩니다.\n신중히 입력 바랍니다.`->React.string}
          </p>
        </article>
        <article className=%twc("mt-5")>
          <h3> {j`내용`->React.string} </h3>
          <div className=%twc("flex mt-2")>
            <Input
              type_="rejected-reason"
              name="rejected-reason"
              className=%twc("flex-1 mr-1")
              placeholder=`내용 입력`
              value={reason->Option.getWithDefault("")}
              onChange={handleOnChange(setReason)}
              error={formErrors
              ->Array.keepMap(error =>
                switch error {
                | #ErrorReason(msg) => Some(msg)
                | _ => None
                }
              )
              ->Garter.Array.first}
            />
          </div>
        </article>
        <article className=%twc("flex justify-center items-center mt-5")>
          <Dialog.Close className=%twc("flex mr-2") onClick={_ => close()}>
            <span id="btn-close" className=%twc("btn-level6 py-3 px-5")>
              {j`닫기`->React.string}
            </span>
          </Dialog.Close>
          <span className=%twc("flex mr-2")>
            <button
              className={isMutating
                ? %twc("btn-level1-disabled py-3 px-5")
                : %twc("btn-level1 py-3 px-5")}
              onClick={_ => handleOnSave()}
              disabled=isMutating>
              {j`저장`->React.string}
            </button>
          </span>
        </article>
      </section>
    </Dialog.Content>
  </Dialog.Root>
}
