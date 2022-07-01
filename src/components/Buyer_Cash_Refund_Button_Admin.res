module FormFields = Buyer_Cash_Refund_Form_Admin.FormFields
module Form = Buyer_Cash_Refund_Form_Admin.Form

@react.component
let make = (~buyerId) => {
  let {addToast} = ReactToastNotifications.useToasts()

  let close = _ => {
    open Webapi
    let buttonClose = Dom.document->Dom.Document.getElementById("btn-close")
    buttonClose
    ->Option.flatMap(buttonClose' => {
      buttonClose'->Dom.Element.asHtmlElement
    })
    ->Option.forEach(buttonClose' => {
      buttonClose'->Dom.HtmlElement.click
    })
    ->ignore
  }

  let onSubmit = ({state}: Form.onSubmitAPI) => {
    let tid = state.values->FormFields.get(FormFields.Tid)
    let amount = state.values->FormFields.get(FormFields.Amount)
    let reason = state.values->FormFields.get(FormFields.Reason)

    amount
    ->Float.fromString
    ->Option.flatMap(amount' =>
      {
        "uid": buyerId,
        "tid": tid,
        "amount": amount',
        "reason": reason,
      }->Js.Json.stringifyAny
    )
    ->Option.forEach(body =>
      FetchHelper.requestWithRetry(
        ~fetcher=FetchHelper.postWithToken,
        ~url=`${Env.restApiUrl}/cash/refund`,
        ~body,
        ~count=3,
        ~onSuccess={
          _ => {
            addToast(.
              <div className=%twc("flex items-center")>
                <IconCheck height="24" width="24" fill="#12B564" className=%twc("mr-2") />
                {j`잔액환불 요청 성공하였습니다.`->React.string}
              </div>,
              {appearance: "success"},
            )
            close()
          }
        },
        ~onFailure={
          err => {
            let customError = err->FetchHelper.convertFromJsPromiseError
            addToast(.
              <div className=%twc("flex items-center")>
                <IconError height="24" width="24" className=%twc("mr-2") />
                {customError.message
                ->Option.getWithDefault(`잔액환불 요청에 에러가 발생하였습니다.`)
                ->React.string}
              </div>,
              {appearance: "error"},
            )
          }
        },
      )->ignore
    )

    None
  }

  let form: Form.api = Form.use(
    ~validationStrategy=Form.OnChange,
    ~onSubmit,
    ~initialState=Buyer_Cash_Refund_Form_Admin.initialState,
    ~schema={
      open Form.Validation
      Schema(
        [
          nonEmpty(Tid, ~error=`TID를 입력해주세요.`),
          nonEmpty(Amount, ~error=`금액을 입력해주세요.`),
          nonEmpty(Reason, ~error=`사유를 입력해주세요.`),
        ]->Array.concatMany,
      )
    },
    (),
  )

  let handleOnSubmit = (
    _ => {
      form.submit()
    }
  )->ReactEvents.interceptingHandler

  <RadixUI.Dialog.Root>
    <RadixUI.Dialog.Overlay className=%twc("dialog-overlay") />
    <div className=%twc("text-right")>
      <RadixUI.Dialog.Trigger className=%twc("mb-1 underline focus:outline-none")>
        {j`잔액환불`->React.string}
      </RadixUI.Dialog.Trigger>
    </div>
    <RadixUI.Dialog.Content className=%twc("dialog-content overflow-y-auto text-text-L1")>
      <div className=%twc("flex p-5")>
        <RadixUI.Dialog.Close id="btn-close" className=%twc("focus:outline-none ml-auto")>
          {j``->React.string}
        </RadixUI.Dialog.Close>
      </div>
      <div className=%twc("p-5 pb-0")>
        <h3 className=%twc("text-center font-bold")>
          {j`잔액 환불을 진행하시겠어요?`->React.string}
        </h3>
        <ul className=%twc("list-inside list-disc px-2 mt-5")>
          <li className=%twc("py-0.5")>
            {j`신중히 작업 부탁드립니다. [확인]버튼 클릭 이후 수정 및 취소가 불가능합니다.`->React.string}
          </li>
          <li className=%twc("py-0.5")>
            {j`KG이니시스를 사용해 잔액환불 완료 후 작업부탁드립니다.`->React.string}
          </li>
          <li className=%twc("py-0.5")>
            {j`입금내역TID는 KG이니시스에서 확인 가능합니다.`->React.string}
          </li>
          <li className=%twc("py-0.5")> {j`단위는 1원입니다.`->React.string} </li>
        </ul>
        <div className=%twc("mt-5")>
          <span className=%twc("block mt-4 mb-1 text-sm")>
            {j`입금내역 TID`->React.string}
          </span>
          <Input
            type_="text"
            name="refund-tid"
            placeholder=`TID 입력`
            value={form.values->FormFields.get(FormFields.Tid)}
            onChange={FormFields.Tid->form.handleChange->ReForm.Helpers.handleChange}
            error={FormFields.Tid->Form.ReSchema.Field->form.getFieldError}
          />
          <span className=%twc("block mt-4 mb-1 text-sm")> {j`금액`->React.string} </span>
          <span className=%twc("block relative")>
            <Input
              type_="number"
              name="refund-amount"
              placeholder=`환불 금액 입력(단위 1원)`
              value={form.values->FormFields.get(FormFields.Amount)}
              onChange={FormFields.Amount->form.handleChange->ReForm.Helpers.handleChange}
              error={FormFields.Amount->Form.ReSchema.Field->form.getFieldError}
            />
            <span className=%twc("absolute top-2 right-3 bg-white")> {`원`->React.string} </span>
          </span>
          <span className=%twc("block mt-4 mb-1 text-sm")>
            {j`잔액환불사유`->React.string}
          </span>
          <Input
            type_="text"
            name="refund-reason"
            placeholder=`사유 입력`
            value={form.values->FormFields.get(FormFields.Reason)}
            onChange={FormFields.Reason->form.handleChange->ReForm.Helpers.handleChange}
            error={FormFields.Reason->Form.ReSchema.Field->form.getFieldError}
          />
        </div>
      </div>
      <Dialog.ButtonBox
        onCancel={_ => close()}
        textOnCancel=`닫기`
        onConfirm={handleOnSubmit}
        textOnConfirm=`확인`
      />
    </RadixUI.Dialog.Content>
  </RadixUI.Dialog.Root>
}
