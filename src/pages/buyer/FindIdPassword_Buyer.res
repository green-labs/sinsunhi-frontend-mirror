module FindId = {
  type mode =
    | VerifyPhoneNumber // 인증 전
    | Found // 아이디 찾은 상태
    | NotFound // 아이디 못 찾은 상태
  @react.component
  let make = (~phoneNumber) => {
    let router = Next.Router.useRouter()
    let (mode, setMode) = React.Uncurried.useState(_ => VerifyPhoneNumber)
    let (uids, setUid) = React.Uncurried.useState(_ => None)

    let onVerified = (~phoneNumber, ~uids, ~existed) => {
      phoneNumber->Js.Console.log

      open FindId_Buyer_VerifyPhoneNumber
      switch existed {
      | Some(Existed) => {
          setMode(._ => Found)
          setUid(._ => uids)
        }
      | Some(NotExisted) => setMode(._ => NotFound)
      | None => setMode(._ => VerifyPhoneNumber)
      }
    }

    let phoneNumberInputRef = React.useRef(Js.Nullable.null)
    React.useEffect0(_ => {
      ReactUtil.focusElementByRef(phoneNumberInputRef)

      None
    })

    <>
      {switch mode {
      | VerifyPhoneNumber => <>
          <h2 className=%twc("text-2xl font-bold relative xs:whitespace-pre-line")>
            {`가입시 등록하신 휴대전화번호로\n아이디를 찾을 수 있습니다.`->React.string}
          </h2>
          <div className=%twc("py-4 mt-12")>
            <FindId_Buyer_VerifyPhoneNumber
              phoneNumberInputRef phoneNumber onVerified={onVerified}
            />
          </div>
        </>
      | Found => <>
          <h2 className=%twc("text-2xl font-bold relative xs:whitespace-pre-line")>
            {`회원님의 휴대전화번호로 가입된\n아이디가 있습니다.`->React.string}
          </h2>
          <div className=%twc("border border-border-default-L2 rounded-2xl p-4 mt-5")>
            {switch uids {
            | Some(uids') => uids'->Array.map(uid => <p> {uid->React.string} </p>)->React.array
            | None => `email을 찾을 수 없습니다.`->React.string
            }}
          </div>
          <span className=%twc("flex h-13 mt-24")>
            <button
              className=%twc("btn-level1")
              onClick={_ =>
                router->Next.Router.push(
                  `/buyer/signin?uid=${uids
                    ->Option.flatMap(uids => uids->Garter.Array.first)
                    ->Option.getWithDefault("")}`,
                )}>
              {`로그인`->React.string}
            </button>
          </span>
        </>
      | NotFound => <>
          <h2 className="text-2xl font-bold relative xs:whitespace-pre-line">
            {`회원님의 휴대전화번호로 가입된\n아이디가 없습니다.`->React.string}
          </h2>
          <div className=%twc("flex h-13 mt-24")>
            <button
              className=%twc("btn-level1") onClick={_ => router->Next.Router.push(`/buyer/signup`)}>
              {`회원가입`->React.string}
            </button>
          </div>
          <div className=%twc("flex h-13 mt-4")>
            <button
              className=%twc(
                "w-full text-enabled-L1 bg-surface rounded-xl whitespace-nowrap focus:outline-none focus:ring-2 focus:ring-gray-300 focus:ring-offset-1"
              )
              onClick={_ => router->Next.Router.push(`/buyer`)}>
              {`메인으로`->React.string}
            </button>
          </div>
        </>
      }}
      <RadixUI.Separator.Root orientation=#horizontal className=%twc("bg-div-border-L1 h-px") />
      <div>
        <p className=%twc("mt-9 text-text-L2 md:text-center")>
          {`*본인의 휴대전화번호로 가입하지 않으셨을 경우 고객센터로 문의바랍니다.`->React.string}
        </p>
      </div>
    </>
  }
}

module ResetPassword = {
  module Styles = ResetPassword_Style
  module FormFields = %lenses(type state = {email: string})
  module Form = ReForm.Make(FormFields)

  @react.component
  let make = (~uid) => {
    let initialState: FormFields.state = {
      email: uid->Option.getWithDefault(""),
    }

    let router = Next.Router.useRouter()

    let (isShowResetSuccess, setShowResetSuccess) = React.Uncurried.useState(_ => Dialog.Hide)
    let (isShowResetError, setShowResetError) = React.Uncurried.useState(_ => Dialog.Hide)

    /**
     * 비밀번호 재설정 요청
     */
    let onSubmit = ({state}: Form.onSubmitAPI) => {
      let email = state.values->FormFields.get(FormFields.Email)

      {
        "uid": email,
      }
      ->Js.Json.stringifyAny
      ->Option.map(body =>
        FetchHelper.post(
          ~url=`${Env.restApiUrl}/user/password-reset`,
          ~body,
          ~onSuccess={
            _ => setShowResetSuccess(._ => Dialog.Show)
          },
          ~onFailure={
            _ => setShowResetError(._ => Dialog.Show)
          },
        )
      )
      ->ignore
      None
    }

    let form: Form.api = Form.use(
      ~validationStrategy=Form.OnChange,
      ~onSubmit,
      ~initialState,
      ~schema={
        open Form.Validation
        Schema([email(Email, ~error=`이메일을 입력해주세요.`)]->Array.concatMany)
      },
      (),
    )

    let handleOnSubmit = (_ => form.submit())->ReactEvents.interceptingHandler

    let isDisabledSubmitResetPasswordButton = switch (
      form.values->FormFields.get(FormFields.Email) !== "",
      form.isSubmitting,
    ) {
    | (true, false) => false
    | _ => true
    }

    let goToSignIn = () => router->Next.Router.replace("/buyer/signin")

    let emailInputRef = React.useRef(Js.Nullable.null)
    React.useEffect0(_ => {
      ReactUtil.focusElementByRef(emailInputRef)

      None
    })

    <>
      <h2 className="text-2xl font-bold relative whitespace-pre-line">
        {`신선하이에 가입한 계정으로\n비밀번호 재설정 이메일을 보내드립니다.`->React.string}
      </h2>
      <div className=%twc("py-4 mt-12")>
        <span className=%twc("text-[17px] font-bold inline-block mb-2")>
          {`이메일`->React.string}
        </span>
        <div className=%twc("flex")>
          <Input
            inputRef={ReactDOM.Ref.domRef(emailInputRef)}
            type_="email"
            name="email"
            size=Input.Large
            placeholder=`신선하이 계정 (이메일) 입력`
            value={form.values->FormFields.get(FormFields.Email)}
            onChange={FormFields.Email->form.handleChange->ReForm.Helpers.handleChange}
            error={FormFields.Email->Form.ReSchema.Field->form.getFieldError}
          />
        </div>
        <div className=%twc("mt-5 pb-96 sm:pb-0")>
          <button
            className={isDisabledSubmitResetPasswordButton
              ? Styles.disabledButton
              : Styles.enabledButton}
            onClick=handleOnSubmit
            disabled={isDisabledSubmitResetPasswordButton}>
            {j`재설정 메일 발송`->React.string}
          </button>
        </div>
      </div>
      <Dialog isShow=isShowResetSuccess onConfirm={_ => goToSignIn()} textOnConfirm=`확인`>
        <p className=%twc("text-gray-500 text-center whitespace-pre-wrap")>
          <span className=%twc("font-bold")>
            {form.values->FormFields.get(FormFields.Email)->React.string}
          </span>
          {`로 
비밀번호 재설정 메일을 전송했습니다.
메일함을 확인해주세요.

*신선하이에 가입한 회원이 아닐 경우 
이메일이 전송되지 않습니다.`->React.string}
        </p>
      </Dialog>
      <Dialog
        isShow=isShowResetError
        onConfirm={_ => setShowResetError(._ => Dialog.Hide)}
        textOnConfirm=`확인`>
        <p className=%twc("text-gray-500 text-center whitespace-pre-wrap")>
          {`비밀번호 재설정 요청을 실패하였습니다.\n다시 시도해주세요.`->React.string}
        </p>
      </Dialog>
    </>
  }
}

type mode = FindId | ResetPassword

module Tab = {
  @react.component
  let make = (~mode) => {
    let router = Next.Router.useRouter()

    let style = (self, mode) =>
      if self == mode {
        %twc("text-center text-lg py-4 font-bold border-b border-b-enabled-L1")
      } else {
        %twc("text-center text-lg py-4 border-b border-b-enabled-L5")
      }

    let handleOnClick = self => {
      let {makeWithDict, toString} = module(Webapi.Url.URLSearchParams)
      let query = router.query->Js.Dict.entries->Js.Dict.fromArray

      query->Js.Dict.set(
        "mode",
        switch self {
        | FindId => "find-id"
        | ResetPassword => "reset-password"
        },
      )
      router->Next.Router.push(`${router.pathname}?${query->makeWithDict->toString}`)
    }

    <ul className=%twc("w-full grid grid-cols-2")>
      <li className={style(FindId, mode)} onClick={_ => handleOnClick(FindId)}>
        {`아이디 찾기`->React.string}
      </li>
      <li className={style(ResetPassword, mode)} onClick={_ => handleOnClick(ResetPassword)}>
        {`비밀번호 찾기`->React.string}
      </li>
    </ul>
  }
}

type props = {query: Js.Dict.t<string>}
type params
type previewData

let default = (~props: props) => {
  let mode =
    props.query
    ->Js.Dict.get("mode")
    ->Option.mapWithDefault(FindId, mode => {
      if mode == "find-id" {
        FindId
      } else if mode == "reset-password" {
        ResetPassword
      } else {
        FindId
      }
    })
  let phoneNumber = props.query->Js.Dict.get("phone-number")
  let uid = props.query->Js.Dict.get("uid")

  <>
    <Next.Head>
      <title>
        {j`바이어 아이디 찾기 비밀번호 찾기 - 신선하이`->React.string}
      </title>
    </Next.Head>
    <div
      className=%twc(
        "container mx-auto max-w-lg min-h-buyer relative flex flex-col xl:justify-center items-center"
      )>
      <div
        className=%twc(
          "flex-auto flex flex-col sm:justify-center items-center w-full lg:w-[496px] px-5"
        )>
        <Tab mode />
        <div className="w-full py-16">
          {switch mode {
          | FindId => <FindId phoneNumber />
          | ResetPassword => <ResetPassword uid />
          }}
        </div>
      </div>
    </div>
  </>
}

let getServerSideProps = ({query}: Next.GetServerSideProps.context<props, params, previewData>) => {
  Js.Promise.resolve({"props": {"query": query}})
}
