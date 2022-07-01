@spice
type response = {message: string}

type error =
  | Unregistered
  | Suspended
  | Closed
  | Unexpected

type status =
  | Waiting
  | Valid(string)
  | Invalid(error)

let parseMessage = (message, businessNumber) => {
  switch message {
  | "VALID" => Valid(businessNumber)
  | "NOT_REGISTERED" => Invalid(Unregistered)
  | "SUSPEND" => Invalid(Suspended)
  | "CLOSE" => Invalid(Closed)
  | _ => Invalid(Unexpected)
  }
}

let dictToQueryStr = dict => {
  dict->Webapi.Url.URLSearchParams.makeWithDict->Webapi.Url.URLSearchParams.toString
}

module FormFields = %lenses(type state = {businessNumber: string})
module Form = ReForm.Make(FormFields)

let initialState: FormFields.state = {businessNumber: ""}

let btnStyle = %twc(
  "w-full bg-blue-gray-700 rounded-xl text-white font-bold whitespace-nowrap focus:outline-none focus:ring-2 focus:ring-gray-700 focus:ring-offset-1"
)
let btnStyleDisabled = %twc(
  "w-full bg-gray-50 rounded-xl whitespace-nowrap focus:outline-none focus:ring-2 focus:ring-gray-300 focus:ring-offset-1"
)

@react.component
let make = (~onChange) => {
  let (isLoading, setLoading) = React.Uncurried.useState(_ => false)
  let (status, setStatus) = React.Uncurried.useState(_ => Waiting)

  let isValid = switch status {
  | Valid(_) => true
  | _ => false
  }

  let updateStatus = nextStatus => {
    switch nextStatus {
    | Valid(businessNumber) => onChange(Some(businessNumber))
    | _ => onChange(None)
    }
    setStatus(._ => nextStatus)
  }

  let submit = ({state}: Form.onSubmitAPI) => {
    setLoading(._ => true)

    // 입력된 형식 "123-45-67890" -> "1234567890"로 변경해야함.
    let businessNumber =
      state.values
      ->FormFields.get(FormFields.BusinessNumber)
      ->Garter.String.replaceByRe(Js.Re.fromStringWithFlags("\-", ~flags="g"), "")

    let queryStr = list{("b-no", businessNumber)}->Js.Dict.fromList->dictToQueryStr
    FetchHelper.get(
      ~url=`${Env.restApiUrl}/user/validate-business-number?${queryStr}`,
      ~onSuccess={
        json => {
          switch json->response_decode {
          | Ok(json') => json'.message->parseMessage(businessNumber)->updateStatus
          | Error(_) => Invalid(Unexpected)->updateStatus
          }
        }
      },
      ~onFailure={_ => Invalid(Unexpected)->updateStatus},
    )->ignore

    setLoading(._ => false)

    None
  }

  let form: Form.api = Form.use(
    ~validationStrategy=Form.OnChange,
    ~onSubmit=submit,
    ~initialState,
    ~schema={
      Schema(
        [
          Form.Validation.regExp(
            BusinessNumber,
            ~matches="^\d{3}-\d{2}-\d{5}$",
            ~error=`사업자 등록번호 형식을 확인해주세요.`,
          ),
        ]->Array.concatMany,
      )
    },
    (),
  )

  let onChangeBusinessNumber = e => {
    updateStatus(Waiting)

    let businessNumber =
      (e->ReactEvent.Synthetic.currentTarget)["value"]
      ->Js.String2.replaceByRe(%re("/[^\d]/g"), "")
      ->Js.String2.replaceByRe(%re("/(^\d{3})(\d+)?(\d{5})$/"), "$1-$2-$3")
      ->Js.String2.replace("--", "-")

    FormFields.BusinessNumber->form.setFieldValue(businessNumber, ~shouldValidate=true, ())
  }

  let errorMessage = {
    let statusErr = switch status {
    | Waiting
    | Valid(_) =>
      None

    | Invalid(Unexpected) =>
      Some(`인증에 실패하였습니다. 다시 한번 시도해주세요.`)
    | Invalid(_) => Some(`유효하지 않은 사업자 등록번호입니다.`)
    }

    if statusErr->Option.isSome {
      statusErr
    } else {
      FormFields.BusinessNumber->Form.ReSchema.Field->form.getFieldError
    }
  }

  <div className=%twc("w-full flex")>
    <div className=%twc("w-full relative")>
      <Input
        name="business-number"
        type_="text"
        size=Input.Large
        placeholder=`사업자 등록번호 입력`
        value={form.values->FormFields.get(FormFields.BusinessNumber)}
        onChange={onChangeBusinessNumber}
        error={errorMessage}
        disabled=isLoading
      />
      {switch status {
      | Valid(_) =>
        <span className=%twc("absolute top-3.5 right-4 text-green-gl")>
          {`인증됨`->React.string}
        </span>
      | _ => React.null
      }}
    </div>
    <span className=%twc("flex ml-2 w-24 h-13")>
      <button
        type_="button"
        className={isLoading || isValid ? btnStyleDisabled : btnStyle}
        disabled={isLoading || isValid}
        onClick={ReactEvents.interceptingHandler(_ => form.submit())}>
        {`인증`->React.string}
      </button>
    </span>
  </div>
}
