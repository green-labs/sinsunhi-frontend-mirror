module FormFields = SignIn_Admin_Form.FormFields
module Form = SignIn_Admin_Form.Form

@react.component
let make = () => {
  let {useRouter, push} = module(Next.Router)
  let router = useRouter()

  let (isCheckedSaveEmail, setCheckedSaveEmail) = React.Uncurried.useState(_ => true)
  let (isShowLoginError, setShowLoginError) = React.Uncurried.useState(_ => Dialog.Hide)

  let onSubmit = ({state}: Form.onSubmitAPI) => {
    let email = state.values->FormFields.get(FormFields.Email)
    let password = state.values->FormFields.get(FormFields.Password)

    let {makeWithArray, makeWithDict, toString, get} = module(Webapi.Url.URLSearchParams)

    let redirectUrl = router.query->makeWithDict->get("redirect")->Option.getWithDefault("/admin")

    let urlSearchParams =
      [("grant-type", "password"), ("username", email), ("password", password)]
      ->makeWithArray
      ->toString

    FetchHelper.postWithURLSearchParams(
      ~url=`${Env.restApiUrl}/user/token`,
      ~urlSearchParams,
      ~onSuccess={
        res => {
          let result = FetchHelper.responseToken_decode(res)
          switch result {
          | Ok(res) => {
              LocalStorageHooks.AccessToken.set(res.token)
              LocalStorageHooks.RefreshToken.set(res.refreshToken)

              router->push(redirectUrl)
            }
          | Error(_) => setShowLoginError(._ => Dialog.Show)
          }
        }
      },
      ~onFailure={_ => setShowLoginError(._ => Dialog.Show)},
    )->ignore

    None
  }

  let form: Form.api = Form.use(
    ~validationStrategy=Form.OnChange,
    ~onSubmit,
    ~initialState=SignIn_Admin_Form.initialState,
    ~schema={
      open Form.Validation
      Schema(
        [
          email(Email, ~error=`이메일을 입력해주세요.`),
          nonEmpty(Password, ~error=`비밀번호를 입력해주세요.`),
        ]->Array.concatMany,
      )
    },
    (),
  )

  let handleOnSubmit = (
    _ => {
      let email = form.values->FormFields.get(FormFields.Email)
      isCheckedSaveEmail
        ? LocalStorageHooks.EmailAdmin.set(email)
        : LocalStorageHooks.EmailAdmin.remove()
      form.submit()
    }
  )->ReactEvents.interceptingHandler

  let handleOnCheckSaveEmail = e => {
    let checked = (e->ReactEvent.Synthetic.target)["checked"]
    setCheckedSaveEmail(._ => checked)
  }

  // 저장된 휴대폰 번호 prefill
  React.useEffect0(_ => {
    let email = LocalStorageHooks.EmailAdmin.get()
    setCheckedSaveEmail(._ => true)
    FormFields.Email->form.setFieldValue(email, ~shouldValidate=true, ())

    None
  })

  <>
    <Next.Head>
      <title> {j`관리자 로그인 - 신선하이`->React.string} </title>
    </Next.Head>
    <div
      className=%twc(
        "container mx-auto max-w-lg min-h-screen flex flex-col justify-center items-center relative"
      )>
      <img src="/assets/sinsunhi-logo.svg" width="164" height="42" alt=`신선하이 로고` />
      <div className=%twc("text-gray-500 mt-2")>
        <span> {`농산물 바이어 전용`->React.string} </span>
        <span className=%twc("ml-1 font-semibold")> {`소싱플랫폼`->React.string} </span>
      </div>
      <div
        className=%twc(
          "w-full px-5 sm:shadow-xl sm:rounded sm:border sm:border-gray-100 sm:py-12 sm:px-20 mt-6"
        )>
        <h2 className=%twc("text-2xl font-bold text-center")>
          {`관리자 로그인`->React.string}
        </h2>
        <form onSubmit={handleOnSubmit}>
          <label htmlFor="email" className=%twc("block mt-3") />
          <Input
            type_="email"
            name="email"
            size=Input.Large
            placeholder=`이메일`
            value={form.values->FormFields.get(FormFields.Email)}
            onChange={FormFields.Email->form.handleChange->ReForm.Helpers.handleChange}
            error={FormFields.Email->Form.ReSchema.Field->form.getFieldError}
          />
          <label htmlFor="password" className=%twc("block mt-3") />
          <Input
            type_="password"
            name="password"
            size=Input.Large
            placeholder=`비밀번호`
            onChange={FormFields.Password->form.handleChange->ReForm.Helpers.handleChange}
            error={FormFields.Password->Form.ReSchema.Field->form.getFieldError}
          />
          <div className=%twc("flex items-center mt-4")>
            <Checkbox id="auto-login" checked=isCheckedSaveEmail onChange=handleOnCheckSaveEmail />
            <span className=%twc("text-sm text-gray-700 ml-1")>
              {`아이디 저장`->React.string}
            </span>
          </div>
          <button
            type_="submit"
            className={form.isSubmitting
              ? %twc("w-full mt-12 py-3 bg-gray-300 rounded-xl text-white font-bold")
              : %twc(
                  "w-full mt-12 py-3 bg-green-gl rounded-xl text-white font-bold focus:outline-none focus:ring-2 focus:ring-offset-1 focus:ring-green-gl focus:ring-opacity-100"
                )}
            disabled={form.isSubmitting}>
            {`로그인`->React.string}
          </button>
        </form>
      </div>
      <div className=%twc("absolute bottom-4 text-sm text-gray-400")>
        {`ⓒ Copyright Greenlabs All Reserved. (주)그린랩스`->React.string}
      </div>
    </div>
    // 로그인 오류 다이얼로그
    <Dialog isShow=isShowLoginError onConfirm={_ => setShowLoginError(._ => Dialog.Hide)}>
      <p className=%twc("text-gray-500 text-center whitespace-pre-wrap")>
        {`로그인 정보가 일치하지 않거나 없는 계정입니다.\n다시  한번 입력해주세요.`->React.string}
      </p>
    </Dialog>
  </>
}
