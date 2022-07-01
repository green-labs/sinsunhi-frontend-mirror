open SignUp_Seller_Types

module FormFields = SignUp_Seller_Form.FormFields
module Form = SignUp_Seller_Form.Form
module Terms = SignUp_Seller_Terms

let {
  parseProducerType,
  parseProductType,
  stringifyProducerType,
  displayProductType,
  displayProducerType,
  optionValues,
} = module(SignUp_Seller_Form)

module Select = {
  @react.component
  let make = (~t, ~values, ~title, ~display, ~onChange, ~isError) =>
    <div>
      <label id="select-occupation" className=%twc("block text-sm font-medium text-gray-700") />
      <div className=%twc("relative")>
        <button
          type_="button"
          className={switch (t, isError) {
          | (Some(_), false) =>
            %twc(
              "relative w-full bg-gray-gl text-gray-gl border border-gray-gl-light rounded-xl py-[13px] px-3 focus:outline-none focus:ring-1-gl remove-spin-button focus:border-gray-gl"
            )
          | (None, false) =>
            %twc(
              "relative w-full text-gray-gl border border-gray-gl-light rounded-xl py-[13px] px-3 focus:outline-none focus:ring-1-gl remove-spin-button focus:border-gray-gl"
            )
          | (_, true) =>
            %twc(
              "relative w-full text-gray-gl border ring-2 ring-notice rounded-xl py-[13px] px-3 remove-spin-button "
            )
          }}>
          <span className=%twc("flex items-center text-disabled-L1")>
            <span className=%twc("block truncate")>
              {t
              ->Option.map(t => t->display)
              ->Option.getWithDefault(`${title} 선택`)
              ->React.string}
            </span>
          </span>
          <span className=%twc("absolute top-2 right-3")>
            <IconArrowSelect height="28" width="28" fill="#121212" />
          </span>
        </button>
        <select
          className=%twc("absolute left-0 w-full py-3 opacity-0")
          value={t->Option.map(t => t->display)->Option.getWithDefault(`${title} 선택`)}
          onChange>
          <option value=title> {j`-- ${title} 선택 --`->React.string} </option>
          {values
          ->Array.map(value => <option key=value value> {value->React.string} </option>)
          ->React.array}
        </select>
      </div>
      {isError
        ? <span className=%twc("flex mt-2")>
            <IconError width="20" height="20" />
            <span className=%twc("text-sm text-notice ml-1")>
              {`${title}을 선택해주세요.`->React.string}
            </span>
          </span>
        : React.null}
    </div>
}

@react.component
let make = () => {
  let router = Next.Router.useRouter()

  let (isPhoneNumberVerifed, setPhoneNumberVerified) = React.Uncurried.useState(_ => Unverified)
  let (passwordConfirm, setPasswordConfirm) = React.Uncurried.useState(_ => "")
  let (detailedAddress, setDetailedAddress) = React.Uncurried.useState(_ => "")
  let (productType, setProductType) = React.Uncurried.useState(_ => None)
  let (producerType, setProducerType) = React.Uncurried.useState(_ => None)
  let (businessRegistrationNumber, setBusinessRegistrationNumber) = React.Uncurried.useState(_ =>
    ""
  )
  let (isTermsConfirmed, setTermsConfirmed) = React.Uncurried.useState(_ => false) // 필수 약관 동의
  let (isMarketing, setMarketing) = React.Uncurried.useState(_ => false) // 마케팅 정보 동의

  let ((isShowError, errorMessage), setShowErrorWithMessage) = React.Uncurried.useState(_ => (
    Dialog.Hide,
    None,
  ))
  let (isShowConfirmGoBack, setShowConfirmGoBack) = React.Uncurried.useState(_ => Dialog.Hide)

  let onSubmit = ({state}: Form.onSubmitAPI) => {
    switch (isPhoneNumberVerifed, isTermsConfirmed) {
    | (Verified, true) =>
      let payload = {
        ...state.values,
        address: `${state.values->FormFields.get(FormFields.Address)} ${detailedAddress}`,
        producerType: producerType->Option.map(stringifyProducerType)->Option.getWithDefault(""),
        terms: isMarketing ? ["marketing"] : [],
        businessRegistrationNumber: businessRegistrationNumber,
      }
      payload
      ->Js.Json.stringifyAny
      ->Option.map(body =>
        FetchHelper.post(
          ~url=`${Env.restApiUrl}/user/register`,
          ~body,
          ~onSuccess={_ => router->Next.Router.push("/seller/signin")},
          ~onFailure={
            err => {
              let customError = err->FetchHelper.convertFromJsPromiseError
              if customError.status === 409 {
                setShowErrorWithMessage(._ => (Dialog.Show, customError.message))
              } else {
                setShowErrorWithMessage(._ => (Dialog.Show, None))
              }
            }
          },
        )
      )
      ->ignore
    | (Verified, false)
    | (Unverified, _) => ()
    }
    None
  }

  let form: Form.api = Form.use(
    ~validationStrategy=Form.OnChange,
    ~onSubmit,
    ~initialState=SignUp_Seller_Form.initialState,
    ~schema={
      open Form.Validation
      Schema(
        [
          nonEmpty(Name, ~error=`정확한 이름을 입력해주세요.`),
          nonEmpty(Phone, ~error=`휴대전화 번호를 입력해주세요.`),
          regExp(
            Password,
            ~matches="^(?=.*\d)(?=.*[a-zA-Z]).{6,15}$",
            ~error=`비밀번호가 형식에 맞지 않습니다.`,
          ),
          nonEmpty(Address, ~error=`주소를 입력해주세요.`),
          nonEmpty(Zipcode, ~error=`우편번호를 입력해주세요.`),
          nonEmpty(Role, ~error=`농부`),
          nonEmpty(ProducerType, ~error=`필수 입력`),
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

  let handleOnChangePasswordConfirm = e => {
    let value = (e->ReactEvent.Synthetic.target)["value"]
    setPasswordConfirm(._ => value)
  }

  let handleOnChangeDetailedAddress = e => {
    let value = (e->ReactEvent.Synthetic.target)["value"]
    setDetailedAddress(._ => value)
  }

  let handleOnChangeProducerType = e => {
    let value = (e->ReactEvent.Synthetic.currentTarget)["value"]
    let parsed = value->parseProducerType(productType)
    setProducerType(._ => parsed)
    FormFields.ProducerType->form.setFieldValue(
      parsed->Option.mapWithDefault("", stringifyProducerType),
      ~shouldValidate=true,
      (),
    )
  }

  let handleOnChangeProductType = e => {
    let value = (e->ReactEvent.Synthetic.currentTarget)["value"]
    setProductType(._ => value->parseProductType)
    setProducerType(._ => None)
  }

  let handleOnChangeBusinessRegistrationNumber = e => {
    let value = (e->ReactEvent.Synthetic.target)["value"]
    setBusinessRegistrationNumber(._ => value)
  }

  let handleOnChangeTerms = c => {
    setTermsConfirmed(._ => c)
  }

  let handleVerifiedPhoneNumber = n => {
    setPhoneNumberVerified(._ => Verified)
    FormFields.Phone->form.setFieldValue(n, ~shouldValidate=true, ())
  }

  let handleOnClickSearchAddress = {
    _ => {
      open DaumPostCode

      let option = makeOption(~oncomplete=data => {
        FormFields.Address->form.setFieldValue(data.address, ~shouldValidate=true, ())
        FormFields.Zipcode->form.setFieldValue(data.zonecode, ~shouldValidate=true, ())
      }, ())
      let daumPostCode = option->make

      let openOption = makeOpenOption(~popupName="신선하이 회원가입 주소 검색", ())
      daumPostCode->openPostCode(openOption)
    }
  }->ReactEvents.interceptingHandler

  let isPasswordConfirmed = () => {
    let password1 = form.values->FormFields.get(FormFields.Password)
    password1 !== "" && passwordConfirm !== "" && password1 !== passwordConfirm
  }

  let toggleDialogForError = s => setShowErrorWithMessage(._ => s)

  let handleOnClickBackButton = (
    _ => {
      setShowConfirmGoBack(._ => Dialog.Show)
    }
  )->ReactEvents.interceptingHandler

  let isDisabledSubmit = switch (
    isPhoneNumberVerifed,
    isTermsConfirmed,
    producerType,
    form.isSubmitting,
  ) {
  | (Verified, true, Some(_), false) => false
  | (_, _, _, _) => true
  }

  <>
    <Next.Head>
      <title> {j`생산자 회원가입 - 신선하이`->React.string} </title>
      <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js" />
    </Next.Head>
    <div
      className=%twc(
        "container mx-auto max-w-lg min-h-screen flex flex-col justify-center items-center relative py-20"
      )>
      <img src="/assets/sinsunhi-logo.svg" width="164" height="42" alt=`신선하이 로고` />
      <div className=%twc("text-text-L2 mt-2")>
        <span> {`농축산물 생산자 `->React.string} </span>
        <span className=%twc("font-semibold")> {` 판로개척 플랫폼`->React.string} </span>
      </div>
      <div
        className=%twc(
          "w-full px-5 sm:shadow-xl sm:rounded sm:border sm:border-gray-100 sm:py-12 sm:px-20 mt-10"
        )>
        <h2 className=%twc("text-text-L1 text-2xl font-bold text-center relative")>
          {`생산자 회원가입`->React.string}
          <button className=%twc("absolute left-0 p-2") onClick={handleOnClickBackButton}>
            <IconArrow
              height="24" width="24" fill="#262626" className=%twc("transform rotate-180")
            />
          </button>
        </h2>
        <form onSubmit={handleOnSubmit}>
          <div className=%twc("divide-y")>
            // 이름
            <div className=%twc("py-4 mt-4 sm:mt-6")>
              <Input
                name="username"
                type_="text"
                size=Input.Large
                placeholder=`업체명 (개인생산자일 경우 대표자 성함)`
                onChange={FormFields.Name->form.handleChange->ReForm.Helpers.handleChange}
                error={FormFields.Name->Form.ReSchema.Field->form.getFieldError}
              />
            </div>
            <VerifyPhoneNumber onVerified=handleVerifiedPhoneNumber />
            // 주소
            <div className=%twc("py-4")>
              <div className=%twc("flex")>
                <Input
                  type_="text"
                  name="address1"
                  size=Input.Large
                  className=%twc("flex-1")
                  defaultValue={form.values->FormFields.get(FormFields.Address)}
                  placeholder=`주소`
                  error=None
                  disabled=true
                />
                <span className=%twc("flex w-24 h-13 ml-2")>
                  <button
                    type_="button"
                    className=%twc("btn-level1")
                    onClick={handleOnClickSearchAddress}>
                    {`주소검색`->React.string}
                  </button>
                </span>
              </div>
              <Input
                type_="text"
                name="address2"
                className=%twc("mt-2")
                size=Input.Large
                placeholder=`상세주소`
                value=detailedAddress
                onChange=handleOnChangeDetailedAddress
                error=None
              />
            </div>
            <div className=%twc("py-4")>
              <Input
                name="email"
                type_="email"
                size=Input.Large
                placeholder=`이메일`
                onChange={FormFields.Email->form.handleChange->ReForm.Helpers.handleChange}
                error={FormFields.Email->Form.ReSchema.Field->form.getFieldError}
              />
              <Input
                type_="password"
                name="password"
                size=Input.Large
                className=%twc("mt-2")
                placeholder=`비밀번호 (영문, 숫자 조합 6~15자)`
                onChange={FormFields.Password->form.handleChange->ReForm.Helpers.handleChange}
                error={FormFields.Password->Form.ReSchema.Field->form.getFieldError}
              />
              <Input
                type_="password"
                name="password2"
                size=Input.Large
                className=%twc("mt-2")
                value=passwordConfirm
                onChange=handleOnChangePasswordConfirm
                placeholder=`비밀번호 재입력`
                error=None
              />
              {isPasswordConfirmed()
                ? <span className=%twc("flex mt-1")>
                    <IconError width="20" height="20" />
                    <span className=%twc("text-sm text-red-500 ml-1")>
                      {`비밀번호가 일치하지 않습니다.`->React.string}
                    </span>
                  </span>
                : React.null}
            </div>
            <div className=%twc("flex flex-col py-4 gap-3")>
              <Select
                t=productType
                title=`판매상품`
                display=displayProductType
                onChange=handleOnChangeProductType
                values=[`농산물`, `축산물`, `수산물`]
                isError={FormFields.ProducerType
                ->Form.ReSchema.Field
                ->form.getFieldError
                ->Option.isSome && productType->Option.isNone}
              />
              {productType->Option.isSome
                ? <Select
                    t=producerType
                    title=`직업군`
                    display=displayProducerType
                    onChange=handleOnChangeProducerType
                    values={optionValues(productType)}
                    isError={FormFields.ProducerType
                    ->Form.ReSchema.Field
                    ->form.getFieldError
                    ->Option.isSome}
                  />
                : React.null}
              <Input
                type_="text"
                name="business-number"
                size=Input.Large
                placeholder={switch producerType {
                | Some(Farm(Farmer)) => `농민경영체번호(선택)`
                | Some(Seafood(Fishermen)) => `어업경영체등록번호`
                | _ => `사업자등록번호(선택)`
                }}
                value=businessRegistrationNumber
                onChange=handleOnChangeBusinessRegistrationNumber
                error=None
              />
              <span className=%twc("block text-text-L2 -mt-1")>
                {`*등록번호가 없을 경우 빈칸으로 제출해 주세요.`->React.string}
              </span>
            </div>
            <Terms onConfirmed=handleOnChangeTerms isMarketing setMarketing />
          </div>
          <span className=%twc("flex h-12")>
            <button
              type_="submit"
              className={isDisabledSubmit ? %twc("btn-level1-disabled") : %twc("btn-level1")}
              disabled={isDisabledSubmit}>
              {`회원가입`->React.string}
            </button>
          </span>
        </form>
      </div>
      <div className=%twc("absolute bottom-4 text-sm text-text-L3")>
        {`ⓒ Copyright Greenlabs All Reserved. (주)그린랩스`->React.string}
      </div>
    </div>
    // 회원가입 오류 다이얼로그
    <Dialog isShow=isShowError onConfirm={_ => toggleDialogForError((Dialog.Hide, None))}>
      <p className=%twc("text-text-L1 text-center whitespace-pre-wrap")>
        {errorMessage
        ->Option.getWithDefault(`회원가입에 실패하였습니다.\n다시 한번 입력해주세요.`)
        ->React.string}
      </p>
    </Dialog>
    <Dialog
      isShow=isShowConfirmGoBack
      textOnCancel=`닫기`
      onCancel={_ => setShowConfirmGoBack(._ => Dialog.Hide)}
      kindOfConfirm=Dialog.Negative
      textOnConfirm=`그만두기`
      onConfirm={_ => router->Next.Router.push("/seller/signin")}>
      <p className=%twc("text-text-L1 text-center whitespace-pre-wrap")>
        {`회원가입을 진행중이에요,\n회원가입을 중단하시겠어요?`->React.string}
      </p>
    </Dialog>
  </>
}
