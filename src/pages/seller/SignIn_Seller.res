module FormFields = SignIn_Seller_Form.FormFields
module Form = SignIn_Seller_Form.Form

@react.component
let make = () => {
  let {useRouter, push} = module(Next.Router)
  let router = useRouter()

  let (isCheckedSavePhone, setCheckedSavePhone) = React.Uncurried.useState(_ => true)
  let (isShowForError, setShowForError) = React.Uncurried.useState(_ => Dialog.Hide)

  let onSubmit = ({state}: Form.onSubmitAPI) => {
    let username = state.values->FormFields.get(FormFields.Phone)
    let password = state.values->FormFields.get(FormFields.Password)

    let {makeWithArray, makeWithDict, toString, get} = module(Webapi.Url.URLSearchParams)

    let redirectUrl = router.query->makeWithDict->get("redirect")->Option.getWithDefault("/seller")

    let urlSearchParams =
      [
        ("grant-type", "password"),
        ("username", username->Helper.PhoneNumber.removeDash),
        ("password", password),
      ]
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

              // 로그인 성공 시, 웹뷰에 Braze 푸시 기기 토큰 등록을 위한 userId를 postMessage 합니다.
              switch res.token->CustomHooks.Auth.decodeJwt->CustomHooks.Auth.user_decode {
              | Ok(user) =>
                Global.Window.ReactNativeWebView.PostMessage.storeBrazeUserId(
                  `sinsunhi-${user.id->Int.toString}`,
                )
              | Error(_) => ()
              }

              router->push(redirectUrl)
            }
          | Error(_) => setShowForError(._ => Dialog.Show)
          }
        }
      },
      ~onFailure={_ => setShowForError(._ => Dialog.Show)},
    )->ignore

    None
  }

  let form: Form.api = Form.use(
    ~validationStrategy=Form.OnChange,
    ~onSubmit,
    ~initialState=SignIn_Seller_Form.initialState,
    ~schema={
      open Form.Validation
      Schema(
        [
          nonEmpty(Phone, ~error=`휴대전화 번호를 입력해주세요.`),
          nonEmpty(Password, ~error=`비밀번호를 입력해주세요.`),
        ]->Array.concatMany,
      )
    },
    (),
  )

  let handleOnSubmit = (
    _ => {
      let phone = form.values->FormFields.get(FormFields.Phone)
      isCheckedSavePhone
        ? phone
          ->Helper.PhoneNumber.parse
          ->Option.flatMap(Helper.PhoneNumber.format)
          ->Option.forEach(phoneNumber => phoneNumber->LocalStorageHooks.PhoneNumber.set)
        : LocalStorageHooks.PhoneNumber.remove()
      form.submit()
    }
  )->ReactEvents.interceptingHandler

  let handleOnCheckSavePhone = e => {
    let checked = (e->ReactEvent.Synthetic.target)["checked"]
    setCheckedSavePhone(._ => checked)
  }

  let handleNavigateToSignUp = {
    _ => {
      router->push("/seller/signup")
    }
  }->ReactEvents.interceptingHandler

  let toggleDialogForError = s => setShowForError(._ => s)

  // 저장된 휴대폰 번호 prefill
  React.useEffect0(_ => {
    let phoneNumber = LocalStorageHooks.PhoneNumber.get()
    if phoneNumber != "" {
      setCheckedSavePhone(._ => true)
      FormFields.Phone->form.setFieldValue(phoneNumber, ())
    }

    None
  })

  let isFormFilled = () => {
    let phone = form.values->FormFields.get(FormFields.Phone)
    let password = form.values->FormFields.get(FormFields.Password)
    phone !== "" && password !== ""
  }

  let handleOnChangePhoneNumber = e => {
    let newValue =
      (e->ReactEvent.Synthetic.currentTarget)["value"]
      ->Js.String2.replaceByRe(%re("/[^0-9]/g"), "")
      ->Js.String2.replaceByRe(%re("/(^1[0-9]{3}|^0[0-9]{2})([0-9]+)?([0-9]{4})$/"), "$1-$2-$3")
      ->Js.String2.replace("--", "-")

    FormFields.Phone->form.setFieldValue(newValue, ~shouldValidate=true, ())
  }

  // 이미 로그인 된 경우 redirect 하기
  let user = CustomHooks.Auth.use()
  React.useEffect1(_ => {
    switch user {
    | LoggedIn(user') =>
      switch user'.role {
      | Buyer => router->Next.Router.push("/buyer")
      | Seller => router->Next.Router.push("/seller")
      // 어드민의 경우, 되돌리지 않고 접근하게 한다.
      | Admin => ()
      }
    | NotLoggedIn | Unknown => ()
    }

    None
  }, [user])

  ChannelTalkHelper.Hook.use()

  <>
    <Next.Head> <title> {j`생산자 로그인 - 신선하이`->React.string} </title> </Next.Head>
    <div
      className=%twc(
        "container mx-auto max-w-lg min-h-screen relative flex flex-col justify-center items-center"
      )>
      <div className=%twc("flex-auto flex flex-col justify-center items-center pt-10")>
        <img src="/assets/sinsunhi-logo.svg" width="164" height="42" alt=`신선하이 로고` />
        <div className=%twc("text-gray-500 mt-2")>
          <span> {`농축산물 생산자 `->React.string} </span>
          <span className=%twc("font-semibold")> {` 판로개척 플랫폼`->React.string} </span>
        </div>
        <div
          className="w-full px-5 sm:shadow-xl sm:rounded sm:border sm:border-gray-100 sm:py-12 sm:px-20 mt-6">
          <h2 className="text-2xl font-bold text-center">
            {`생산자 로그인`->React.string}
          </h2>
          <form onSubmit={handleOnSubmit} className=%twc("mt-8")>
            <label htmlFor="phone-number" className=%twc("block mt-3") />
            <Input
              type_="text"
              name="phone-number"
              size=Input.Large
              placeholder=`휴대전화번호`
              value={form.values->FormFields.get(FormFields.Phone)}
              onChange={handleOnChangePhoneNumber}
              error={FormFields.Phone->Form.ReSchema.Field->form.getFieldError}
            />
            <label htmlFor="password" className=%twc("block mt-3") />
            <Input
              type_="password"
              name="password"
              placeholder=`비밀번호`
              size=Input.Large
              onChange={FormFields.Password->form.handleChange->ReForm.Helpers.handleChange}
              error={FormFields.Password->Form.ReSchema.Field->form.getFieldError}
            />
            <div className="flex justify-between items-center mt-4">
              <span className=%twc("flex")>
                <Checkbox
                  id="auto-login" checked=isCheckedSavePhone onChange=handleOnCheckSavePhone
                />
                <span className=%twc("text-sm text-gray-700 ml-1")>
                  {`아이디 저장`->React.string}
                </span>
              </span>
              <Next.Link href="/seller/reset-password">
                <span className="text-sm text-gray-700 underline">
                  {`비밀번호 재설정`->React.string}
                </span>
              </Next.Link>
            </div>
            <button
              type_="submit"
              className={form.isSubmitting || !isFormFilled()
                ? %twc("w-full mt-12 py-3 bg-gray-300 rounded-xl text-gray-100")
                : %twc(
                    "w-full mt-12 py-3 bg-green-gl rounded-xl text-gray-100 focus:outline-none focus:ring-2 focus:ring-offset-1 focus:ring-green-gl focus:ring-opacity-100"
                  )}
              disabled={form.isSubmitting || !isFormFilled()}>
              {`로그인`->React.string}
            </button>
          </form>
          <p className="p-4 bg-gray-100 mt-8 rounded-xl">
            <span className="text-gray-500 whitespace-pre-wrap">
              {`기존에 신선하이와 거래하던 생산자이신가요?\n비밀번호 재설정 버튼을 눌러 비밀번호를 설정하시고 사용 부탁드립니다.`->React.string}
            </span>
            <span className="block mt-2 cursor-pointer" onClick={handleNavigateToSignUp}>
              <span className="text-gray-500 underline">
                {`신규 거래 생산자이신가요? `->React.string}
              </span>
              <span className="text-gray-500 font-bold underline">
                {` 회원가입`->React.string}
              </span>
            </span>
          </p>
          // <div className="flex justify-center">
          //   <span className="py-2 px-4 bg-gray-100 mt-5 rounded-xl text-gray-500">
          //     <a href=Env.kakaotalkChannel target="_blank">
          //       {`카카오톡 문의하기`->React.string}
          //     </a>
          //   </span>
          // </div>
        </div>
      </div>
      <div className="text-sm text-gray-400 py-4">
        {`ⓒ Copyright Greenlabs All Reserved. (주)그린랩스`->React.string}
      </div>
    </div>
    // 다이얼로그 모달
    <Dialog isShow=isShowForError onConfirm={_ => toggleDialogForError(Dialog.Hide)}>
      <p className=%twc("text-gray-500 text-center whitespace-pre-wrap")>
        {`로그인 정보가 일치하지 않거나 없는 계정입니다. 다시 한번 입력해주세요.`->React.string}
      </p>
    </Dialog>
  </>
}
