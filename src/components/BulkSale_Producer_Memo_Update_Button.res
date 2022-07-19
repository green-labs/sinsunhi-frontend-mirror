open RadixUI

@module("../../public/assets/edit.svg")
external editIcon:string = "default"

module Mutation = %relay(`
  mutation BulkSaleProducerMemoUpdateButtonMutation(
    $id: ID!
    $input: BulkSaleApplicationUpdateInput!
  ) {
    updateBulkSaleApplication(id: $id, input: $input) {
      result {
        ...BulkSaleProducerAdminFragment_bulkSaleApplication
      }
    }
  }
`)

@react.component
let make = (~applicationId, ~memoData) => {
  let {addToast} = ReactToastNotifications.useToasts()
  let (mutate, isMutating) = Mutation.use()
  let (memo, setMemo) = React.Uncurried.useState(_ => memoData->Some)

  let close = () => {
    open Webapi
    let buttonClose = Dom.document->Dom.Document.getElementById("btn-close")
    buttonClose
    ->Option.flatMap(buttonClose' => {
      buttonClose'->Dom.Element.asHtmlElement
    })
    ->Option.forEach(buttonClose' => {
      buttonClose'->Dom.HtmlElement.click
    })
  }

  let handleOnChange = (setFn, e) => {
    let value = (e->ReactEvent.Synthetic.target)["value"]
    setFn(._ => value)
  }

  let handleOnSave = _ => {
    let input: BulkSaleProducerMemoUpdateButtonMutation_graphql.Types.variables = {
      id: applicationId,
      input: Mutation.make_bulkSaleApplicationUpdateInput(
        ~memo=memo->Option.getWithDefault(""),
        (),
      ),
    }

    mutate(
      ~variables=input,
      ~onCompleted=(_, _) => {
        addToast(.
          <div className=%twc("flex items-center")>
            <IconCheck height="24" width="24" fill="#12B564" className=%twc("mr-2") />
            {j`메모를 수정하였습니다.`->React.string}
          </div>,
          {appearance: "success"},
        )
        close()
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
          close()
        }
      },
      (),
    )->ignore
  }

  <Dialog.Root>
    <Dialog.Overlay className=%twc("dialog-overlay") />
    <Dialog.Trigger className=%twc("inline-flex")>
      <img src=editIcon className=%twc("mr-1") />
    </Dialog.Trigger>
    <Dialog.Content className=%twc("dialog-content-memo overflow-y-auto rounded-xl")>
      <section className=%twc("p-5")>
        <article className=%twc("flex justify-between")>
          <h2 className=%twc("text-xl font-bold")> {`메모작성`->React.string} </h2>
          <Dialog.Close className=%twc("inline-block p-1 focus:outline-none ml-auto")>
            <IconClose height="24" width="24" fill="#262626" />
          </Dialog.Close>
        </article>
        <article>
          <h5 className=%twc("mt-7")> {`메모`->React.string} </h5>
          <div className=%twc("flex mt-2 h-[140px]")>
            <Textarea
              type_="online-sale-urls"
              name="online-sale-urls"
              className=%twc("flex-1 mr-1 h-full")
              size=Textarea.XLarge
              placeholder=`유저에게 노출되지 않는 메모입니다. (최대 200자)
* test건의 경우, “#TEST”로 작성하여 표시합니다.
* 표에서 125자(작성기준 2줄)까지 노출됩니다.
* 전체 내용은 작성버튼을 누르거나 엑셀 파일을 다룬로드하여 확인할 수 있습니다.`
              value={memo->Option.getWithDefault("")}
              onChange={handleOnChange(setMemo)}
              error=None
            />
          </div>
        </article>
        <div className=%twc("flex justify-center items-center mt-8")>
          <Dialog.Close className=%twc("flex")>
            <span
              id="btn-close"
              className=%twc("py-1.5 px-3 text-sm font-normal rounded-lg bg-surface mr-1")>
              {`닫기`->React.string}
            </span>
          </Dialog.Close>
          <span
            onClick={_ => handleOnSave()}
            className=%twc("py-1.5 px-3 text-sm font-normal rounded-lg bg-primary text-white ml-1")
            disabled=isMutating>
            {`저장`->React.string}
          </span>
        </div>
      </section>
    </Dialog.Content>
  </Dialog.Root>
}
