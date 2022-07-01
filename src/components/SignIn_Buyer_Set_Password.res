module FormFields = SignIn_Buyer_Form_SetPassword.FormFields
module Form = SignIn_Buyer_Form_SetPassword.Form

type passwordConfirmed = Waiting | Confirmed | NotConfirmed

@react.component
let make = (~onSuccess, ~onError) => {
  let router = Next.Router.useRouter()
  let (passwordConfirm, setPasswordConfirm) = React.Uncurried.useState(_ => "")

  let onSubmit = ({state}: Form.onSubmitAPI) => {
    router.query
    ->Js.Dict.get("token")
    ->Option.flatMap(redirectToken' => {
      {
        ...state.values,
        redirectToken: redirectToken',
      }->Js.Json.stringifyAny
    })
    ->Option.map(payload' => {
      FetchHelper.put(
        ~url=`${Env.restApiUrl}/user/password/buyer`,
        ~body=payload',
        ~onSuccess={
          _ => onSuccess(._ => Dialog.Hide)
        },
        ~onFailure={_ => onError(._ => Dialog.Show)},
      )
    })
    ->ignore

    None
  }

  let form: Form.api = Form.use(
    ~validationStrategy=Form.OnChange,
    ~onSubmit,
    ~initialState=SignIn_Buyer_Form_SetPassword.initialState,
    ~schema={
      open Form.Validation
      Schema(
        [
          regExp(
            Password,
            ~matches="^(?=.*\d)(?=.*[a-zA-Z]).{6,15}$",
            ~error=`비밀번호가 형식에 맞지 않습니다.`,
          ),
        ]->Array.concatMany,
      )
    },
    (),
  )

  let handleOnSubmitPasswordReset = (
    _ => {
      form.submit()
    }
  )->ReactEvents.interceptingHandler

  let handleOnChangePasswordConfirm = e => {
    let value = (e->ReactEvent.Synthetic.target)["value"]
    setPasswordConfirm(._ => value)
  }

  let isPasswordConfirmed = () => {
    let password1 = form.values->FormFields.get(FormFields.Password)
    switch (password1, passwordConfirm) {
    | ("", _)
    | (_, "") =>
      Waiting
    | (_, _) if password1 === passwordConfirm => Confirmed
    | (_, _) => NotConfirmed
    }
  }

  <div className=%twc("transform transition-all")>
    <h3 className=%twc("text-2xl font-bold text-center")>
      {j`비밀번호 설정이 필요합니다`->React.string}
    </h3>
    <p className=%twc("text-gray-500 mt-3 max-w-xs sm:px-8")>
      {j`신선하이에서 사용할 비밀번호를 영문·숫자 조합 6~15자로 입력해주세요.`->React.string}
    </p>
    <form className="mt-8" onSubmit={handleOnSubmitPasswordReset}>
      <label htmlFor="new-password1" className=%twc("block mt-3") />
      <Input
        type_="password"
        name="new-password1"
        className=%twc("mt-3")
        size=Input.Large
        placeholder=`비밀번호(영문·숫자 조합 6~15자)`
        onChange={FormFields.Password->form.handleChange->ReForm.Helpers.handleChange}
        error={FormFields.Password->Form.ReSchema.Field->form.getFieldError}
      />
      <label htmlFor="new-password2" className=%twc("block mt-3") />
      <input
        type_="password"
        name="new-password2"
        value=passwordConfirm
        onChange=handleOnChangePasswordConfirm
        className=%twc("w-full border rounded-xl py-3 px-3")
        placeholder=`비밀번호 확인`
      />
      {switch isPasswordConfirmed() {
      | Waiting
      | Confirmed => React.null
      | NotConfirmed =>
        <span className=%twc("flex mt-1")>
          <IconError width="20" height="20" />
          <span className=%twc("text-sm text-red-500 ml-1")>
            {`비밀번호가 일치하지 않습니다.`->React.string}
          </span>
        </span>
      }}
      <button
        type_="submit"
        className={switch isPasswordConfirmed() {
        | Confirmed if !form.isSubmitting =>
          %twc("w-full mt-8 py-3 bg-green-gl rounded-xl text-white font-bold")
        | _ => %twc("w-full mt-8 py-3 bg-gray-300 rounded-xl text-white font-bold")
        }}
        disabled={switch isPasswordConfirmed() {
        | Confirmed if !form.isSubmitting => false
        | _ => true
        }}>
        {`확인`->React.string}
      </button>
    </form>
  </div>
}
