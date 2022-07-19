module VerifyPhoneNumberFormFields = %lenses(type state = {phoneNumber: string})
module VerificationCodeFormFields = %lenses(type state = {verificationCode: string})

module VerifyPhoneNumberForm = ReForm.Make(VerifyPhoneNumberFormFields)
module VerificationCodeForm = ReForm.Make(VerificationCodeFormFields)

let initialStateVerifyPhoneNumber: VerifyPhoneNumberFormFields.state = {
  phoneNumber: "",
}
let initialStateVerificationCode: VerificationCodeFormFields.state = {
  verificationCode: "",
}

type statusSendingSMS = BeforeSendSMS | SendingSMS | SuccessToSendSMS | FailureToSendSMS
type statusVerificationCode =
  BeforeSendVerificationCode | SendingVerificationCode | SuccessToVerifyCode | FailureToVerifyCode

type statusExisted = Existed | NotExisted

let sendBtnStyle = %twc(
  "w-full bg-blue-gray-700 rounded-xl text-white font-bold whitespace-nowrap focus:outline-none focus:ring-2 focus:ring-gray-700 focus:ring-offset-1"
)
let resendBtnStyle = %twc(
  "w-full bg-gray-50 rounded-xl whitespace-nowrap focus:outline-none focus:ring-2 focus:ring-gray-300 focus:ring-offset-1"
)

@react.component
let make = (~onVerified) => {
  let router = Next.Router.useRouter()
  let (sms, setSMS) = React.Uncurried.useState(_ => BeforeSendSMS)
  let (verificationCode, setVerificationCode) = React.Uncurried.useState(_ =>
    BeforeSendVerificationCode
  )
  let (isShowDuplicated, setShowDuplicated) = React.Uncurried.useState(_ => Dialog.Hide)
  let (isShowVerifyError, setShowVerifyError) = React.Uncurried.useState(_ => Dialog.Hide)

  let inputVerificationCodeRef = React.useRef(Js.Nullable.null)

  // 휴대전화 인증 번호 전송
  let onSubmitVerifyPhoneNumber = ({state}: VerifyPhoneNumberForm.onSubmitAPI) => {
    setSMS(._ => SendingSMS)
    // 입력된 폰 번호 형식 "010-1234-5678" -> "01012345678" 로 변경해야함.
    let phoneNumber =
      state.values
      ->VerifyPhoneNumberFormFields.get(VerifyPhoneNumberFormFields.PhoneNumber)
      ->Garter.String.replaceByRe(Js.Re.fromStringWithFlags("\-", ~flags="g"), "")

    {
      "recipient-no": phoneNumber,
    }
    ->Js.Json.stringifyAny
    ->Option.map(body => {
      FetchHelper.post(
        ~url=`${Env.restApiUrl}/user/sms`,
        ~body,
        ~onSuccess={
          _ => {
            setSMS(._ => SuccessToSendSMS)
            ReactUtil.focusElementByRef(inputVerificationCodeRef)
          }
        },
        ~onFailure={
          err => {
            setSMS(._ => FailureToSendSMS)
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
            ~error=`휴대전화 번호를 다시 확인해주세요.`,
          ),
        ]->Array.concatMany,
      )
    },
    (),
  )

  // 인증번호 전송
  let onSubmitVerificationCode = ({state}: VerificationCodeForm.onSubmitAPI) => {
    setVerificationCode(._ => SendingVerificationCode)

    let phoneNumber =
      verifyPhoneNumberForm.values
      ->VerifyPhoneNumberFormFields.get(VerifyPhoneNumberFormFields.PhoneNumber)
      ->Garter.String.replaceByRe(Js.Re.fromStringWithFlags("\-", ~flags="g"), "")
    let code =
      state.values->VerificationCodeFormFields.get(VerificationCodeFormFields.VerificationCode)

    {
      "recipient-no": phoneNumber,
      "confirmed-no": code,
      "role": "buyer",
    }
    ->Js.Json.stringifyAny
    ->Option.map(body =>
      FetchHelper.post(
        ~url=`${Env.restApiUrl}/user/sms/check`,
        ~body,
        ~onSuccess={
          _ => {
            setVerificationCode(._ => SuccessToVerifyCode)
            onVerified(~phoneNumber, ~isVerifed=SuccessToVerifyCode, ~isExisted=Some(NotExisted))
          }
        },
        ~onFailure={
          err => {
            let customError = err->FetchHelper.convertFromJsPromiseError
            if customError.status === 409 {
              setVerificationCode(._ => SuccessToVerifyCode)
              setShowDuplicated(._ => Dialog.Show)
              onVerified(~phoneNumber, ~isVerifed=SuccessToVerifyCode, ~isExisted=Some(Existed))
            } else {
              setVerificationCode(._ => FailureToVerifyCode)
              setShowVerifyError(._ => Dialog.Show)
              onVerified(~phoneNumber, ~isVerifed=FailureToVerifyCode, ~isExisted=None)
            }
          }
        },
      )
    )
    ->ignore
    None
  }

  let verificationCodeForm: VerificationCodeForm.api = VerificationCodeForm.use(
    ~validationStrategy=VerificationCodeForm.OnChange,
    ~onSubmit=onSubmitVerificationCode,
    ~initialState=initialStateVerificationCode,
    ~schema={
      open VerificationCodeForm.Validation
      Schema(
        [
          nonEmpty(VerificationCode, ~error=`인증번호를 입력해주세요.`),
        ]->Array.concatMany,
      )
    },
    (),
  )

  // 인증 초기화
  let reset = () => {
    setSMS(._ => BeforeSendSMS)
    setVerificationCode(._ => BeforeSendVerificationCode)
    VerifyPhoneNumberFormFields.PhoneNumber->verifyPhoneNumberForm.setFieldValue(
      "",
      ~shouldValidate=false,
      (),
    )
    VerificationCodeFormFields.VerificationCode->verificationCodeForm.setFieldValue(
      "",
      ~shouldValidate=false,
      (),
    )
    onVerified(~phoneNumber="", ~isVerifed=BeforeSendVerificationCode, ~isExisted=None)
  }

  let handleOnSubmitPhoneNumber = (
    _ => {
      switch sms {
      | SuccessToSendSMS => reset()
      | FailureToSendSMS
      | BeforeSendSMS =>
        verifyPhoneNumberForm.submit()
      | SendingSMS => ()
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

  let handleOnSubmitVerificationCode = (
    _ => {
      verificationCodeForm.submit()
    }
  )->ReactEvents.interceptingHandler

  let isDisabledVerifyPhoneNumberForm = switch sms {
  | BeforeSendSMS => false
  | SendingSMS => true
  | SuccessToSendSMS => true
  | FailureToSendSMS => false
  }

  let isDisabledVerifyPhoneNumberButton = switch sms {
  | BeforeSendSMS => false
  | SendingSMS => true
  | SuccessToSendSMS => false
  | FailureToSendSMS => false
  }

  let isDisabledVerifyCodeForm = switch sms {
  | BeforeSendSMS => true
  | SendingSMS => false
  | SuccessToSendSMS =>
    switch verificationCode {
    | BeforeSendVerificationCode => false
    | SendingVerificationCode => true
    | SuccessToVerifyCode => true
    | FailureToVerifyCode => false
    }
  | FailureToSendSMS => true
  }

  let timerStatus = switch sms {
  | BeforeSendSMS => Timer.Stop
  | SendingSMS => Timer.Stop
  | SuccessToSendSMS =>
    switch verificationCode {
    | BeforeSendVerificationCode => Timer.Start
    | SendingVerificationCode => Timer.Pause
    | SuccessToVerifyCode => Timer.Stop
    | FailureToVerifyCode => Timer.Resume
    }
  | FailureToSendSMS => Timer.Stop
  }

  let onChangeStatus = status => {
    switch status {
    | Timer.Stop =>
      switch sms {
      | SuccessToSendSMS => {
          setSMS(._ => BeforeSendSMS)
          setVerificationCode(._ => BeforeSendVerificationCode)
        }
      | _ => ()
      }
    | _ => ()
    }
  }

  <>
    <div className=%twc("py-2")>
      <div className=%twc("flex")>
        <Input
          type_="text"
          name="phone-number"
          size=Input.Large
          placeholder=`휴대전화번호`
          className=%twc("flex-1")
          value={verifyPhoneNumberForm.values->VerifyPhoneNumberFormFields.get(
            VerifyPhoneNumberFormFields.PhoneNumber,
          )}
          onChange=handleOnChangePhoneNumber
          error={VerifyPhoneNumberFormFields.PhoneNumber
          ->VerifyPhoneNumberForm.ReSchema.Field
          ->verifyPhoneNumberForm.getFieldError}
          disabled=isDisabledVerifyPhoneNumberForm
        />
        <span className=%twc("flex ml-2 w-24 h-13")>
          <button
            type_="button"
            className={switch sms {
            | BeforeSendSMS => sendBtnStyle
            | SendingSMS => resendBtnStyle
            | SuccessToSendSMS => resendBtnStyle
            | FailureToSendSMS => sendBtnStyle
            }}
            disabled={isDisabledVerifyPhoneNumberButton}
            onClick=handleOnSubmitPhoneNumber>
            {switch sms {
            | SuccessToSendSMS => `재전송`
            | _ => `보내기`
            }->React.string}
          </button>
        </span>
      </div>
      <label htmlFor="verify-number" className=%twc("block mt-3") />
      <div className=%twc("relative")>
        <Input
          inputRef={ReactDOM.Ref.domRef(inputVerificationCodeRef)}
          type_="number"
          name="verify-number"
          size=Input.Large
          placeholder=`인증번호`
          value={verificationCodeForm.values->VerificationCodeFormFields.get(
            VerificationCodeFormFields.VerificationCode,
          )}
          onChange={VerificationCodeFormFields.VerificationCode
          ->verificationCodeForm.handleChange
          ->ReForm.Helpers.handleChange}
          error={VerificationCodeFormFields.VerificationCode
          ->VerificationCodeForm.ReSchema.Field
          ->verificationCodeForm.getFieldError}
          disabled={isDisabledVerifyCodeForm}
        />
        {switch sms {
        | BeforeSendSMS
        | SendingSMS
        | FailureToSendSMS => React.null
        | SuccessToSendSMS =>
          switch verificationCode {
          | BeforeSendVerificationCode
          | SendingVerificationCode
          | FailureToVerifyCode =>
            <Timer
              className=%twc("absolute top-3 right-4 text-red-gl")
              status=timerStatus
              onChangeStatus
              startTimeInSec=180
            />
          | SuccessToVerifyCode =>
            <div className=%twc("absolute top-3.5 right-4 text-green-gl")>
              {`인증됨`->React.string}
            </div>
          }
        }}
      </div>
      <span className=%twc("flex h-13 mt-3")>
        <button
          className={switch sms {
          | BeforeSendSMS => %twc("btn-level1-disabled")
          | SendingSMS => %twc("btn-level1-disabled")
          | SuccessToSendSMS =>
            switch verificationCode {
            | BeforeSendVerificationCode => %twc("btn-level1")
            | SendingVerificationCode => %twc("btn-level1-disabled")
            | SuccessToVerifyCode => %twc("btn-level1-disabled")
            | FailureToVerifyCode => %twc("btn-level1")
            }
          | FailureToSendSMS => %twc("btn-level1-disabled")
          }}
          onClick=handleOnSubmitVerificationCode
          disabled={isDisabledVerifyCodeForm}>
          {`인증`->React.string}
        </button>
      </span>
    </div>
    <Dialog
      isShow=isShowDuplicated
      onCancel={_ => setShowDuplicated(._ => Dialog.Hide)}
      textOnCancel=`아니오`
      onConfirm={_ =>
        router->Next.Router.push(
          `/buyer/signin/find-id-password?mode=find-id&phone-number=${verifyPhoneNumberForm.values->VerifyPhoneNumberFormFields.get(
              VerifyPhoneNumberFormFields.PhoneNumber,
            )}`,
        )}
      textOnConfirm=`아이디 찾기`>
      <p className=%twc("text-gray-500 text-center whitespace-pre-wrap")>
        {`이미 가입된 회원입니다.\n아이디 찾기를 진행하시겠어요?`->React.string}
      </p>
    </Dialog>
    <Dialog
      isShow=isShowVerifyError
      onConfirm={_ => setShowVerifyError(._ => Dialog.Hide)}
      textOnConfirm=`확인`>
      <p className=%twc("text-gray-500 text-center whitespace-pre-wrap")>
        {`인증번호가 일치하지 않습니다.`->React.string}
      </p>
    </Dialog>
  </>
}
