module Styles = ResetPassword_Style

module VerifyPhoneNumberFormFields = %lenses(type state = {phoneNumber: string})
module ResetPasswordFormFields = %lenses(
  type state = {
    verificationCode: string,
    password: string,
  }
)

module VerifyPhoneNumberForm = ReForm.Make(VerifyPhoneNumberFormFields)
module ResetPasswordForm = ReForm.Make(ResetPasswordFormFields)

let initialStateVerifyPhoneNumber: VerifyPhoneNumberFormFields.state = {
  phoneNumber: "",
}
let initialStateResetPassword: ResetPasswordFormFields.state = {
  verificationCode: "",
  password: "",
}

type statusRequestVerificationCode =
  | BeforeRequestVerificationCode
  | SendingRequestVerificationCode
  | SuccessRequestVerificationCode
  | FailedRequestVerificationCode
type statusRequestReset =
  BeforeRequestReset | SendingRequestReset | SuccessRequestReset | FailedRequestReset
type passwordConfirmed = Waiting | Confirmed | NotConfirmed

let checkDisabledSubmitVerifyPhoneNumberButton = phoneNumber => phoneNumber === ""

let checkPasswordConfirmed = (pw1, pw2) => {
  if pw1 === "" || pw2 === "" {
    Waiting
  } else if pw1 !== "" && pw2 !== "" && pw1 === pw2 {
    Confirmed
  } else {
    NotConfirmed
  }
}

@react.component
let make = () => {
  let router = Next.Router.useRouter()

  let (
    statusRequestVerificationCode,
    setStatusRequestVerificationCode,
  ) = React.Uncurried.useState(_ => BeforeRequestVerificationCode)
  let (statusRequestReset, setStatusRequestReset) = React.Uncurried.useState(_ =>
    BeforeRequestReset
  )
  let (passwordConfirm, setPasswordConfirm) = React.Uncurried.useState(_ => "")

  let (isShowConfirmGoBack, setShowConfirmGoBack) = React.Uncurried.useState(_ => Dialog.Hide)
  let (
    isShowSendingVerificationCodeError,
    setShowSendingVerificationCodeError,
  ) = React.Uncurried.useState(_ => Dialog.Hide)
  let (isShowResetSuccess, setShowResetSuccess) = React.Uncurried.useState(_ => Dialog.Hide)
  let (isShowResetError, setShowResetError) = React.Uncurried.useState(_ => Dialog.Hide)

  /**
   * 휴대전화 인증 번호 전송
   */
  let onSubmitVerifyPhoneNumber = ({state}: VerifyPhoneNumberForm.onSubmitAPI) => {
    setStatusRequestVerificationCode(._ => SendingRequestVerificationCode)
    // 입력된 폰 번호 형식 "010-1234-5678" -> "01012345678" 로 변경해야함.
    let phoneNumber =
      state.values
      ->VerifyPhoneNumberFormFields.get(VerifyPhoneNumberFormFields.PhoneNumber)
      ->Garter.String.replaceByRe(Js.Re.fromStringWithFlags("\-", ~flags="g"), "")

    {"uid": phoneNumber}
    ->Js.Json.stringifyAny
    ->Option.map(body => {
      FetchHelper.post(
        ~url=`${Env.restApiUrl}/user/password-reset`,
        ~body,
        ~onSuccess={_ => setStatusRequestVerificationCode(._ => SuccessRequestVerificationCode)},
        ~onFailure={
          _ => {
            setShowSendingVerificationCodeError(._ => Dialog.Show)
            setStatusRequestVerificationCode(._ => FailedRequestVerificationCode)
          }
        },
      )
    })
    ->ignore
    None
  }

  let verifyPhoneNumberForm: VerifyPhoneNumberForm.api = VerifyPhoneNumberForm.use(
    ~validationStrategy=VerifyPhoneNumberForm.OnChange,
    ~onSubmit=onSubmitVerifyPhoneNumber,
    ~initialState=initialStateVerifyPhoneNumber,
    ~schema={
      open VerifyPhoneNumberForm.Validation
      Schema(
        [
          regExp(
            PhoneNumber,
            ~matches="^\d{3}-\d{3,4}-\d{4}$",
            ~error=`전화번호 형식이 맞지 않습니다.`,
          ),
        ]->Array.concatMany,
      )
    },
    (),
  )

  /**
   * 비밀번호 재설정 요청
   */
  let onSubmitResetPassword = ({state}: ResetPasswordForm.onSubmitAPI) => {
    setStatusRequestReset(._ => SendingRequestReset)

    let phoneNumber =
      verifyPhoneNumberForm.values
      ->VerifyPhoneNumberFormFields.get(VerifyPhoneNumberFormFields.PhoneNumber)
      ->Garter.String.replaceByRe(Js.Re.fromStringWithFlags("\-", ~flags="g"), "")
    let code = state.values->ResetPasswordFormFields.get(ResetPasswordFormFields.VerificationCode)
    let password = state.values->ResetPasswordFormFields.get(ResetPasswordFormFields.Password)

    {
      "uid": phoneNumber,
      "confirmed-no": code,
      "password": password,
    }
    ->Js.Json.stringifyAny
    ->Option.map(body =>
      FetchHelper.put(
        ~url=`${Env.restApiUrl}/user/password/farmer`,
        ~body,
        ~onSuccess={
          _ => {
            setStatusRequestReset(._ => SuccessRequestReset)
            setShowResetSuccess(._ => Dialog.Show)
          }
        },
        ~onFailure={
          _ => {
            setStatusRequestReset(._ => FailedRequestReset)
            setShowResetError(._ => Dialog.Show)
          }
        },
      )
    )
    ->ignore
    None
  }

  let resetPasswordForm: ResetPasswordForm.api = ResetPasswordForm.use(
    ~validationStrategy=ResetPasswordForm.OnChange,
    ~onSubmit=onSubmitResetPassword,
    ~initialState=initialStateResetPassword,
    ~schema={
      open ResetPasswordForm.Validation
      Schema(
        [
          nonEmpty(VerificationCode, ~error=`인증번호를 입력해주세요.`),
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

  let handleOnSubmitPhoneNumber = (
    _ => {
      switch statusRequestVerificationCode {
      | SuccessRequestVerificationCode => {
          setStatusRequestVerificationCode(._ => BeforeRequestVerificationCode)
          resetPasswordForm.resetForm()
          setPasswordConfirm(._ => "")
        }
      | FailedRequestVerificationCode
      | BeforeRequestVerificationCode =>
        verifyPhoneNumberForm.submit()
      | SendingRequestVerificationCode => ()
      }
    }
  )->ReactEvents.interceptingHandler

  let handleOnChangePhoneNumber = e => {
    let newValue =
      (e->ReactEvent.Synthetic.currentTarget)["value"]
      ->Js.String2.replaceByRe(%re("/[^0-9]/g"), "")
      ->Js.String2.replaceByRe(%re("/(^1[0-9]{3}|^0[0-9]{2})([0-9]+)?([0-9]{4})$/"), "$1-$2-$3")
      ->Js.String2.replace("--", "-")

    VerifyPhoneNumberFormFields.PhoneNumber->verifyPhoneNumberForm.setFieldValue(
      newValue,
      ~shouldValidate=true,
      (),
    )
  }

  let handleOnSubmitResetPassword =
    (_ => resetPasswordForm.submit())->ReactEvents.interceptingHandler

  let isDisabledVerifyPhoneNumberForm = switch statusRequestVerificationCode {
  | BeforeRequestVerificationCode => false
  | SendingRequestVerificationCode => true
  | SuccessRequestVerificationCode => true
  | FailedRequestVerificationCode => false
  }

  let isDisabledSubmitVerifyPhoneNumberButton = checkDisabledSubmitVerifyPhoneNumberButton(
    verifyPhoneNumberForm.values->VerifyPhoneNumberFormFields.get(
      VerifyPhoneNumberFormFields.PhoneNumber,
    ),
  )

  // 인증번호를 받은 후 타이머 상태
  let timerStatus = switch statusRequestVerificationCode {
  | BeforeRequestVerificationCode => Timer.Stop
  | SendingRequestVerificationCode => Timer.Stop
  | SuccessRequestVerificationCode =>
    switch statusRequestReset {
    | BeforeRequestReset => Timer.Start
    | SendingRequestReset => Timer.Pause
    | SuccessRequestReset => Timer.Stop
    | FailedRequestReset => Timer.Resume
    }
  | FailedRequestVerificationCode => Timer.Stop
  }

  let isDisabledResetPasswordForm = switch statusRequestVerificationCode {
  | BeforeRequestVerificationCode => true
  | SendingRequestVerificationCode => true
  | SuccessRequestVerificationCode =>
    switch statusRequestReset {
    | BeforeRequestReset => false
    | SendingRequestReset => true
    | SuccessRequestReset => true
    | FailedRequestReset => false
    }
  | FailedRequestVerificationCode => true
  }

  let isPasswordConfirmed = checkPasswordConfirmed(
    resetPasswordForm.values->ResetPasswordFormFields.get(ResetPasswordFormFields.Password),
    passwordConfirm,
  )

  let isDisabledSubmitResetPasswordButton = switch (
    resetPasswordForm.values->ResetPasswordFormFields.get(
      ResetPasswordFormFields.VerificationCode,
    ) !== "",
    resetPasswordForm.isSubmitting,
    isPasswordConfirmed,
  ) {
  | (true, false, Confirmed) => false
  | _ => true
  }

  let onChangeStatus = status => {
    switch status {
    | Timer.Stop =>
      switch statusRequestVerificationCode {
      | SuccessRequestVerificationCode => {
          setStatusRequestVerificationCode(._ => BeforeRequestVerificationCode)
          setStatusRequestReset(._ => BeforeRequestReset)
        }
      | _ => ()
      }
    | _ => ()
    }
  }

  let handleOnClickBackButton = (
    _ => {
      setShowConfirmGoBack(._ => Dialog.Show)
    }
  )->ReactEvents.interceptingHandler

  let handleOnChangePasswordConfirm = e => {
    let value = (e->ReactEvent.Synthetic.target)["value"]
    setPasswordConfirm(._ => value)
  }

  let goToSignIn = () => router->Next.Router.replace("/seller/signin")

  <>
    <Next.Head>
      <title> {j`생산자 비밀번호 재설정 - 신선하이`->React.string} </title>
    </Next.Head>
    <div
      className=%twc(
        "container mx-auto max-w-lg min-h-screen relative flex flex-col justify-center items-center"
      )>
      <div className=%twc("w-full flex-auto flex flex-col sm:justify-center items-center sm:pt-10")>
        <div className=%twc("hidden sm:block")>
          <img src="/assets/sinsunhi-logo.svg" width="164" height="42" alt=`신선하이 로고` />
        </div>
        <div className="hidden text-gray-500 sm:block mt-2">
          <span> {`농축산물 생산자 `->React.string} </span>
          <span className="ml-1 font-semibold"> {`판로개척 플랫폼`->React.string} </span>
        </div>
        <div
          className="w-full px-5 sm:shadow-xl sm:rounded sm:border sm:border-gray-100 sm:py-12 sm:px-20 mt-6">
          <h2 className="text-2xl font-bold text-center relative">
            {`비밀번호 재설정`->React.string}
            <button className=%twc("absolute left-0 p-2") onClick={handleOnClickBackButton}>
              <IconArrow
                height="24" width="24" fill="#262626" className=%twc("transform rotate-180")
              />
            </button>
          </h2>
          <div className=%twc("py-4 mt-12")>
            <div className=%twc("flex flex-col")>
              <span className=%twc("mb-4 text-black-gl")>
                {j`휴대전화번호를 입력해 주세요`->React.string}
              </span>
              <Input
                type_="text"
                name="phone-number"
                size=Input.Large
                placeholder=`-없이 숫자로만 입력`
                value={verifyPhoneNumberForm.values->VerifyPhoneNumberFormFields.get(
                  VerifyPhoneNumberFormFields.PhoneNumber,
                )}
                onChange=handleOnChangePhoneNumber
                error={VerifyPhoneNumberFormFields.PhoneNumber
                ->VerifyPhoneNumberForm.ReSchema.Field
                ->verifyPhoneNumberForm.getFieldError}
                disabled=isDisabledVerifyPhoneNumberForm
              />
              <button
                type_="button"
                onClick=handleOnSubmitPhoneNumber
                className={isDisabledSubmitVerifyPhoneNumberButton
                  ? Styles.disabledButton
                  : Styles.enabledButton}
                disabled={isDisabledSubmitVerifyPhoneNumberButton}>
                {switch statusRequestVerificationCode {
                | SuccessRequestVerificationCode => `재전송`
                | _ => `인증번호 전송`
                }->React.string}
              </button>
            </div>
          </div>
          <form className=%twc("pb-96 sm:pb-0")>
            <span className=%twc("inline-block mb-4 whitespace-pre mt-6 text-black-gl")>
              {j`문자로 발송된 인증번호와\n새 비밀번호를 입력해 주세요`->React.string}
            </span>
            <div className=%twc("relative")>
              <Input
                type_="number"
                name="verify-number"
                size=Input.Large
                placeholder=`인증번호 6자리 숫자 입력`
                value={resetPasswordForm.values->ResetPasswordFormFields.get(
                  ResetPasswordFormFields.VerificationCode,
                )}
                onChange={ResetPasswordFormFields.VerificationCode
                ->resetPasswordForm.handleChange
                ->ReForm.Helpers.handleChange}
                error={ResetPasswordFormFields.VerificationCode
                ->ResetPasswordForm.ReSchema.Field
                ->resetPasswordForm.getFieldError}
                disabled={isDisabledResetPasswordForm}
              />
              {switch (statusRequestVerificationCode, statusRequestReset) {
              | (SuccessRequestVerificationCode, BeforeRequestReset)
              | (SuccessRequestVerificationCode, SendingRequestReset)
              | (SuccessRequestVerificationCode, FailedRequestReset) =>
                <Timer
                  className=%twc("absolute top-3 right-4 text-red-gl")
                  status=timerStatus
                  onChangeStatus
                  startTimeInSec=180
                />
              | _ => React.null
              }}
              <span className=%twc("block py-1.5") />
              <Input
                type_="password"
                name="password"
                size=Input.Large
                placeholder=`비밀번호 (영문, 숫자 조합 6~15자)`
                value={resetPasswordForm.values->ResetPasswordFormFields.get(
                  ResetPasswordFormFields.Password,
                )}
                onChange={ResetPasswordFormFields.Password
                ->resetPasswordForm.handleChange
                ->ReForm.Helpers.handleChange}
                error={ResetPasswordFormFields.Password
                ->ResetPasswordForm.ReSchema.Field
                ->resetPasswordForm.getFieldError}
                disabled={isDisabledResetPasswordForm}
              />
              <label htmlFor="password2" className=%twc("block py-1") />
              <Input
                type_="password"
                name="password2"
                value=passwordConfirm
                onChange=handleOnChangePasswordConfirm
                size=Input.Large
                placeholder=`비밀번호 확인`
                error=None
                disabled=isDisabledResetPasswordForm
              />
              {switch isPasswordConfirmed {
              | NotConfirmed =>
                <span className=%twc("flex mt-1")>
                  <IconError width="20" height="20" />
                  <span className=%twc("text-sm text-red-500 ml-1")>
                    {`비밀번호가 일치하지 않습니다.`->React.string}
                  </span>
                </span>
              | _ => React.null
              }}
            </div>
            <span className=%twc("block py-1") />
            <button
              className={isDisabledSubmitResetPasswordButton
                ? Styles.disabledButton
                : Styles.enabledButton}
              onClick=handleOnSubmitResetPassword
              disabled={isDisabledSubmitResetPasswordButton}>
              {j`비밀번호 재설정`->React.string}
            </button>
          </form>
        </div>
      </div>
    </div>
    <Dialog
      isShow=isShowConfirmGoBack
      onConfirm={_ => goToSignIn()}
      textOnConfirm=`그만하기`
      onCancel={_ => setShowConfirmGoBack(._ => Dialog.Hide)}
      kindOfConfirm=Dialog.Negative>
      <p className=%twc("text-gray-500 text-center whitespace-pre-wrap")>
        {`비밀번호 재설정이 진행중 입니다.\n그만 하시겠어요?`->React.string}
      </p>
    </Dialog>
    <Dialog
      isShow=isShowSendingVerificationCodeError
      onCancel={_ => setShowSendingVerificationCodeError(._ => Dialog.Hide)}
      textOnCancel=`확인`>
      <p className=%twc("text-gray-500 text-center whitespace-pre-wrap")>
        {`문자 전송이 실패했습니다.\n다시한번 시도해주세요.`->React.string}
      </p>
    </Dialog>
    <Dialog isShow=isShowResetSuccess onConfirm={_ => goToSignIn()} textOnConfirm=`확인`>
      <p className=%twc("text-gray-500 text-center whitespace-pre-wrap")>
        {`비밀번호 재설정이\n완료되었습니다.`->React.string}
      </p>
    </Dialog>
    <Dialog
      isShow=isShowResetError
      onConfirm={_ => setShowResetError(._ => Dialog.Hide)}
      textOnConfirm=`확인`>
      <p className=%twc("text-gray-500 text-center whitespace-pre-wrap")>
        {`비밀번호 재설정 요청이 실패하였습니다.\n다시 시도해주세요.`->React.string}
      </p>
    </Dialog>
  </>
}
