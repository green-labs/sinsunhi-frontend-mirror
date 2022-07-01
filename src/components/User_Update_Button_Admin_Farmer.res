open RadixUI
open Webapi

module FormFields = %lenses(
  type state = {
    rep: string,
    manager: string,
    phone: string,
    etc: string,
  }
)
module Form = ReForm.Make(FormFields)
let initialState: FormFields.state = {
  rep: "",
  manager: "",
  phone: "",
  etc: "",
}

@react.component
let make = (~user: CustomHooks.QueryUser.Farmer.user, ~className: option<string>=?) => {
  let router = Next.Router.useRouter()
  let {mutate} = Swr.useSwrConfig()
  let {addToast} = ReactToastNotifications.useToasts()

  let close = () => {
    let buttonClose = Dom.document->Dom.Document.getElementById("btn-close")
    buttonClose
    ->Option.flatMap(buttonClose' => buttonClose'->Dom.Element.asHtmlElement)
    ->Option.forEach(buttonClose' => buttonClose'->Dom.HtmlElement.click)
  }

  let onSubmit = ({state}: Form.onSubmitAPI) => {
    let rep = state.values->FormFields.get(FormFields.Rep)
    let manager = state.values->FormFields.get(FormFields.Manager)
    let phone = state.values->FormFields.get(FormFields.Phone)
    let etc = state.values->FormFields.get(FormFields.Etc)

    {
      "farmer-id": user.id,
      "boss-name": rep,
      "manager": manager,
      "manager-phone": phone,
      "etc": etc,
    }
    ->Js.Json.stringifyAny
    ->Option.map(body => {
      FetchHelper.requestWithRetry(
        ~fetcher=FetchHelper.putWithToken,
        ~url=`${Env.restApiUrl}/user/farmer`,
        ~body,
        ~count=3,
        ~onSuccess={
          _ => {
            close()
            addToast(.
              <div className=%twc("flex items-center")>
                <IconCheck height="24" width="24" fill="#12B564" className=%twc("mr-2") />
                {j`저장되었습니다.`->React.string}
              </div>,
              {appearance: "success"},
            )
            mutate(.
              ~url=`${Env.restApiUrl}/user?${{
                  let rq = router.query
                  rq->Js.Dict.set("role", "farmer")
                  rq->Webapi.Url.URLSearchParams.makeWithDict->Webapi.Url.URLSearchParams.toString
                }}`,
              ~data=None,
              ~revalidation=Some(true),
            )
          }
        },
        ~onFailure={
          _ =>
            addToast(.
              <div className=%twc("flex items-center")>
                <IconError height="24" width="24" className=%twc("mr-2") />
                {j`오류가 발생하였습니다.`->React.string}
              </div>,
              {appearance: "error"},
            )
        },
      )
    })
    ->ignore

    None
  }

  let form: Form.api = Form.use(
    ~validationStrategy=Form.OnChange,
    ~onSubmit,
    ~initialState,
    ~schema={
      open Form.Validation
      Schema(
        [
          regExp(
            Phone,
            ~matches="^$|^\d{3}-\d{3,4}-\d{4}$",
            ~error=`전화번호 형식이 맞지 않습니다.`,
          ),
        ]->Array.concatMany,
      )
    },
    (),
  )

  let handleOnChangePhone = e => {
    let newValue =
      (e->ReactEvent.Synthetic.currentTarget)["value"]
      ->Js.String2.replaceByRe(%re("/[^0-9]/g"), "")
      ->Js.String2.replaceByRe(%re("/(^1[0-9]{3}|^0[0-9]{2})([0-9]+)?([0-9]{4})$/"), "$1-$2-$3")
      ->Js.String2.replace("--", "-")

    FormFields.Phone->form.setFieldValue(newValue, ~shouldValidate=true, ())
  }

  let prefill = isOpen =>
    if isOpen {
      FormFields.Rep->form.setFieldValue(
        user.rep->Option.getWithDefault(""),
        ~shouldValidate=false,
        (),
      )
      FormFields.Manager->form.setFieldValue(
        user.manager->Option.getWithDefault(""),
        ~shouldValidate=false,
        (),
      )
      FormFields.Phone->form.setFieldValue(
        user.managerPhone->Option.getWithDefault(""),
        ~shouldValidate=false,
        (),
      )
      FormFields.Etc->form.setFieldValue(
        user.etc->Option.getWithDefault(""),
        ~shouldValidate=false,
        (),
      )
    } else {
      form.resetForm()
    }

  let handleOnSubmit = (
    _ => {
      form.submit()
    }
  )->ReactEvents.interceptingHandler

  <Dialog.Root onOpenChange=prefill>
    <Dialog.Overlay className=%twc("dialog-overlay") />
    <Dialog.Trigger className=%twc("block text-left mb-1 underline focus:outline-none")>
      <IconEdit height="20" width="20" ?className />
    </Dialog.Trigger>
    <Dialog.Content className=%twc("dialog-content overflow-y-auto")>
      <div className=%twc("p-5")>
        <section className=%twc("flex")>
          <h2 className=%twc("text-xl font-bold")> {j`생산자 정보`->React.string} </h2>
          <Dialog.Close className=%twc("inline-block p-1 focus:outline-none ml-auto")>
            <IconClose height="24" width="24" fill="#262626" />
          </Dialog.Close>
        </section>
        <form onSubmit={handleOnSubmit}>
          <section className=%twc("mt-7")>
            <h3> {j`대표자`->React.string} </h3>
            <div className=%twc("mt-2")>
              <Input
                type_="text"
                name="rep"
                placeholder=`대표자명을 입력해주세요`
                value={form.values->FormFields.get(FormFields.Rep)}
                onChange={FormFields.Rep->form.handleChange->ReForm.Helpers.handleChange}
                error=None
              />
            </div>
          </section>
          <section className=%twc("mt-5")>
            <h3> {j`담당자`->React.string} </h3>
            <div className=%twc("mt-2")>
              <Input
                type_="text"
                name="mannger"
                placeholder=`담당자명을 입력해주세요`
                value={form.values->FormFields.get(FormFields.Manager)}
                onChange={FormFields.Manager->form.handleChange->ReForm.Helpers.handleChange}
                error=None
              />
            </div>
          </section>
          <section className=%twc("mt-5")>
            <h3> {j`담당자 연락처`->React.string} </h3>
            <div className=%twc("mt-2")>
              <Input
                type_="text"
                name="Mannger-phone-number"
                placeholder=`담당자명을 연락처를 입력해주세요(010-0000-0000)`
                value={form.values->FormFields.get(FormFields.Phone)}
                onChange={handleOnChangePhone}
                error={FormFields.Phone->Form.ReSchema.Field->form.getFieldError}
              />
            </div>
          </section>
          <section className=%twc("mt-5")>
            <h3> {j`업체비고`->React.string} </h3>
            <div className=%twc("mt-2")>
              <Textarea
                type_="text"
                name="etc"
                placeholder=`메모를 작성해주세요(어드민에서 최대 2줄까지 노출되며 그 이상은 말줄임 처리되어 엑셀 다운로드시 모든 내용을 확인할 수 있습니다.)`
                maxLength=200
                rows=4
                value={form.values->FormFields.get(FormFields.Etc)}
                onChange={FormFields.Etc->form.handleChange->ReForm.Helpers.handleChange}
                error=None
              />
            </div>
          </section>
          <section className=%twc("flex justify-center items-center mt-5")>
            <Dialog.Close className=%twc("flex mr-2")>
              <span id="btn-close" className=%twc("btn-level6 py-3 px-5")>
                {j`닫기`->React.string}
              </span>
            </Dialog.Close>
            <span className=%twc("flex mr-2")>
              <button className=%twc("btn-level1 py-3 px-5") type_="submit">
                {j`저장`->React.string}
              </button>
            </span>
          </section>
        </form>
      </div>
    </Dialog.Content>
  </Dialog.Root>
}
