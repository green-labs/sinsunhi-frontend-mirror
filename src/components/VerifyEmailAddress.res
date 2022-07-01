@spice
type response = {data: bool, message: string}

type emailExisted = Existed | NotExisted

module FormFields = %lenses(type state = {email: string})
module Form = ReForm.Make(FormFields)

let initialState: FormFields.state = {email: ""}

let btnStyle = %twc(
  "w-full bg-enabled-L5 rounded-xl text-text-L1 whitespace-nowrap focus:outline-none focus:ring-2 focus:ring-gray-500 focus:ring-offset-1"
)
let btnStyleDisabled = %twc(
  "w-full bg-enabled-L4 rounded-xl whitespace-nowrap focus:outline-none focus:ring-2 focus:ring-gray-300 focus:ring-offset-1"
)

@react.component
let make = (~emailExisted, ~onEmailChange) => {
  let router = Next.Router.useRouter()

  let (isLoading, setLoading) = React.Uncurried.useState(_ => false)
  let (isShowEmailExisted, setShowEmailExisted) = React.Uncurried.useState(_ => Dialog.Hide)

  let submit = ({state}: Form.onSubmitAPI) => {
    setLoading(._ => true)

    let email = state.values->FormFields.get(FormFields.Email)
    FetchHelper.get(
      ~url=`${Env.restApiUrl}/user/check-duplicate-email?email=${email}`,
      ~onSuccess={
        json => {
          switch json->response_decode {
          | Ok(json') =>
            if json'.data {
              setShowEmailExisted(._ => Dialog.Show)
              onEmailChange(~email=None, ~existed=Some(Existed))
            } else {
              onEmailChange(~email=Some(email), ~existed=Some(NotExisted))
            }
          | Error(_) => onEmailChange(~email=Some(email), ~existed=None)
          }
          setLoading(._ => false)
        }
      },
      ~onFailure={
        _ => {
          onEmailChange(~email=Some(email), ~existed=None)
          setLoading(._ => false)
        }
      },
    )->ignore

    None
  }

  let form: Form.api = Form.use(
    ~validationStrategy=Form.OnChange,
    ~onSubmit=submit,
    ~initialState,
    ~schema={
      open Form.Validation
      Schema([email(Email, ~error=`이메일을 확인해주세요.`)]->Array.concatMany)
    },
    (),
  )

  <div className=%twc("w-full")>
    <span className=%twc("text-base font-bold")>
      {`이메일`->React.string}
      <span className=%twc("ml-0.5 text-notice")> {"*"->React.string} </span>
    </span>
    <div className=%twc("flex w-full mt-2")>
      <div className=%twc("flex flex-1 relative")>
        <Input
          name="email"
          type_="email"
          size=Input.Large
          placeholder=`이메일 입력`
          onChange={FormFields.Email->form.handleChange->ReForm.Helpers.handleChange}
          error={FormFields.Email->Form.ReSchema.Field->form.getFieldError}
          className=%twc("pr-[68px]")
        />
        {switch emailExisted {
        | Some(NotExisted) =>
          <span className=%twc("absolute top-3.5 right-2 sm:right-4 text-green-gl")>
            {`사용가능`->React.string}
          </span>
        | _ => React.null
        }}
      </div>
      <span className=%twc("flex ml-2 w-24 h-13")>
        <button
          type_="submit"
          className={isLoading || form.isSubmitting ? btnStyleDisabled : btnStyle}
          disabled={isLoading || form.isSubmitting}
          onClick={ReactEvents.interceptingHandler(_ => form.submit())}>
          {`중복확인`->React.string}
        </button>
      </span>
    </div>
    <Dialog
      isShow=isShowEmailExisted
      onCancel={_ => {
        FormFields.Email->form.setFieldValue("", ~shouldValidate=true, ())
        setShowEmailExisted(._ => Dialog.Hide)
      }}
      textOnCancel=`닫기`
      onConfirm={_ =>
        router->Next.Router.push(
          `/buyer/signin/find-id-password?mode=reset-password&uid=${form.values->FormFields.get(
              FormFields.Email,
            )}`,
        )}
      textOnConfirm=`비밀번호 찾기`
      boxStyle=%twc("rounded-xl")>
      <p className=%twc("text-text-L1 text-center whitespace-pre-wrap")>
        {`이미 가입한 계정입니다.\n로그인하시거나 비밀번호 찾기를 해주세요.`->React.string}
      </p>
    </Dialog>
  </div>
}
