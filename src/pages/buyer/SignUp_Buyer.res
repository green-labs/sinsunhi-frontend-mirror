type businessNumberStatus = Verified | Unverified

let makeOnChange = (fn, e) => {
  let v = (e->ReactEvent.Synthetic.target)["value"]
  fn(._ => v)
}

let makeOnCheckedChange = (fn, e) => {
  let v = (e->ReactEvent.Synthetic.target)["checked"]
  fn(._ => v)
}

let makeTermUrl = termId => {
  `https://sinsun-policy.oopy.io/${termId}`
}

@react.component
let make = () => {
  module FormFields = SignUp_Buyer_Form.FormFields
  module Form = SignUp_Buyer_Form.Form

  let {useRouter, push} = module(Next.Router)
  let router = useRouter()
  let {addToast} = ReactToastNotifications.useToasts()

  let (showPwd, setShowPwd) = React.Uncurried.useState(_ => false)
  let (emailExisted, setEmailExisted) = React.Uncurried.useState(_ => None)
  let (phoneNumberStatus, setPhoneNumberStatus) = React.Uncurried.useState(_ =>
    VerifyBuyerPhoneNumber.BeforeSendVerificationCode
  )
  let (phoneNumberExistedStatus, setPhoneNumberExistedStatus) = React.Uncurried.useState(_ => None)
  let (
    businessNumberStatus,
    setBusinessNumberStatus,
  ) = React.Uncurried.useState((_): businessNumberStatus => Unverified)

  let (agreedTerms, setAgreedTerms) = React.Uncurried.useState(_ => Belt.Set.String.fromArray([]))

  let isAllAgreed = {
    ["basic", "privacy", "marketing"]->Belt.Array.every(term =>
      agreedTerms->Belt.Set.String.has(term)
    )
  }
  let isRequiredTermsAgreed = {
    ["basic", "privacy"]->Belt.Array.every(term => agreedTerms->Belt.Set.String.has(term))
  }

  let (showErr, setShowErr) = React.Uncurried.useState(_ => Dialog.Hide)

  let toggleCheck = e => {
    let name = (e->ReactEvent.Synthetic.target)["name"]
    agreedTerms->Belt.Set.String.has(name)
      ? setAgreedTerms(._ => agreedTerms->Belt.Set.String.remove(name))
      : setAgreedTerms(._ => agreedTerms->Belt.Set.String.add(name))
  }

  let toggleAllCheck = _ => {
    isAllAgreed
      ? setAgreedTerms(._ => Belt.Set.String.fromArray([]))
      : setAgreedTerms(._ => Belt.Set.String.fromArray(["basic", "privacy", "marketing"]))
  }

  let signIn = ({state}: Form.onSubmitAPI) => {
    let {makeWithArray, toString} = module(Webapi.Url.URLSearchParams)

    let email = state.values->FormFields.get(FormFields.Email)
    let password = state.values->FormFields.get(FormFields.Password)
    let urlSearchParams =
      [("grant-type", "password"), ("username", email), ("password", password)]
      ->makeWithArray
      ->toString

    FetchHelper.postWithURLSearchParams(
      ~url=`${Env.restApiUrl}/user/token`,
      ~urlSearchParams,
      ~onSuccess={
        res => {
          // 회원가입 -> 로그인 후 redirect 쿼리파라미터(redirect=...)가 있는 경우 이동 시킨다.
          let redirectUrlWithWelcome =
            router.query
            ->Js.Dict.get("redirect")
            ->Option.map(url => {
              if url->Js.String2.includes("?") {
                `${url}&welcome`
              } else {
                `${url}?welcome`
              }
            })
            ->Option.getWithDefault("/?welcome")

          switch FetchHelper.responseToken_decode(res) {
          | Ok(res) => {
              LocalStorageHooks.AccessToken.set(res.token)
              LocalStorageHooks.RefreshToken.set(res.refreshToken)
              ChannelTalkHelper.bootWithProfile()

              // 로그인 성공 시, 웹뷰에 Braze 푸시 기기 토큰 등록을 위한 userId를 postMessage 합니다.
              switch res.token->CustomHooks.Auth.decodeJwt->CustomHooks.Auth.user_decode {
              | Ok(user) =>
                Global.Window.ReactNativeWebView.PostMessage.storeBrazeUserId(user.id->Int.toString)
              | Error(_) => ()
              }

              // 회원가입 완료 -> 홈 진입 시에 서베이 출력용 쿼리 삽입
              Redirect.setHref(redirectUrlWithWelcome)
            }

          | Error(_) => router->push("/buyer/signin")
          }
        }
      },
      ~onFailure={_ => router->push("/buyer/signin")},
    )->ignore
  }

  let handleSubmit = ({state} as formApi: Form.onSubmitAPI) => {
    switch (
      emailExisted,
      phoneNumberStatus,
      phoneNumberExistedStatus,
      businessNumberStatus,
      isRequiredTermsAgreed,
    ) {
    | (
        Some(VerifyEmailAddress.NotExisted),
        VerifyBuyerPhoneNumber.SuccessToVerifyCode,
        Some(VerifyBuyerPhoneNumber.NotExisted),
        Verified,
        true,
      ) => {
        let payload = {
          ...state.values,
          terms: agreedTerms->Belt.Set.String.has("marketing") ? ["marketing"] : [],
        }

        payload
        ->Js.Json.stringifyAny
        ->Option.map(body => {
          FetchHelper.post(
            ~url=`${Env.restApiUrl}/user/register/new-buyer`,
            ~body,
            ~onSuccess={
              _ => {
                // 토스트 메세지
                addToast(.
                  <div className=%twc("flex items-center")>
                    <IconCheck height="24" width="24" fill="#12B564" className=%twc("mr-2") />
                    {`회원가입이 완료되었습니다.`->React.string}
                  </div>,
                  {appearance: "success"},
                )
                // 회원가입 이후 자동 로그인 처리
                signIn(formApi)

                // GTM
                let businessRegistrationNumber =
                  state.values->FormFields.get(FormFields.BusinessRegistrationNumber)
                DataGtm.push({
                  "method": "normal",
                  "business_number": businessRegistrationNumber,
                  "marketing": agreedTerms->Belt.Set.String.has("marketing"),
                })
              }
            },
            ~onFailure={_ => setShowErr(._ => Dialog.Show)},
          )
        })
        ->ignore
      }

    | _ => ()
    }

    None
  }

  let form = Form.use(
    ~validationStrategy={Form.OnChange},
    ~onSubmit={handleSubmit},
    ~initialState={SignUp_Buyer_Form.initialState},
    ~schema={
      open Form.Validation
      Schema(
        [
          email(Email, ~error=`올바른 이메일 주소를 입력해주세요.`),
          regExp(
            Password,
            ~matches="^(?=.*\d)(?=.*[a-zA-Z]).{6,15}$",
            ~error=`영문, 숫자 조합 6~15자로 입력해 주세요.`,
          ),
          nonEmpty(Name, ~error=`회사명을 입력해주세요.`),
          nonEmpty(Manager, ~error=`담당자명을 입력해주세요.`),
          nonEmpty(Phone, ~error=`휴대전화번호를 입력해주세요.`),
          nonEmpty(
            BusinessRegistrationNumber,
            ~error=`사업자 등록번호를 입력해주세요.`,
          ),
        ]->Array.concatMany,
      )
    },
    (),
  )

  let handleEmailChange = (~email, ~existed) => {
    switch email {
    | Some(email') => {
        setEmailExisted(._ => existed)
        FormFields.Email->form.setFieldValue(email', ~shouldValidate=true, ())
      }

    | None => {
        setEmailExisted(._ => existed)
        FormFields.Email->form.setFieldValue("", ~shouldValidate=true, ())
      }
    }
  }

  let onPhoneVerified = (~phoneNumber, ~isVerifed, ~isExisted) => {
    setPhoneNumberStatus(._ => isVerifed)
    setPhoneNumberExistedStatus(._ => isExisted)
    FormFields.Phone->form.setFieldValue(phoneNumber, ~shouldValidate=true, ())
  }

  let onBusinessNumberChange = businessNumber => {
    switch businessNumber {
    | Some(businessNumber') => {
        setBusinessNumberStatus(._ => Verified)
        FormFields.BusinessRegistrationNumber->form.setFieldValue(
          businessNumber',
          ~shouldValidate=true,
          (),
        )
      }

    | None => {
        setBusinessNumberStatus(._ => Unverified)
        FormFields.BusinessRegistrationNumber->form.setFieldValue("", ~shouldValidate=true, ())
      }
    }
  }

  let isSubmitDisabled = switch (
    emailExisted,
    phoneNumberStatus,
    phoneNumberExistedStatus,
    businessNumberStatus,
    isRequiredTermsAgreed,
    form.isSubmitting,
  ) {
  | (
      Some(VerifyEmailAddress.NotExisted),
      VerifyBuyerPhoneNumber.SuccessToVerifyCode,
      Some(VerifyBuyerPhoneNumber.NotExisted),
      Verified,
      true,
      false,
    ) => false
  | _ => true
  }

  let onSubmit = ReactEvents.interceptingHandler(_ => form.submit())

  // 이미 로그인 된 경우 redirect 하기
  let user = CustomHooks.Auth.use()
  React.useEffect1(_ => {
    switch user {
    | LoggedIn(user') =>
      switch user'.role {
      | Buyer => router->push("/")
      | Seller => router->push("/seller")
      | Admin => router->push("/admin")
      }
    | NotLoggedIn | Unknown => ()
    }

    None
  }, [user])

  <>
    <Next.Head>
      <title> {`회원가입 - 신선하이`->React.string} </title>
    </Next.Head>
    <div
      className=%twc(
        "container mx-auto max-w-lg min-h-screen flex flex-col justify-center items-center pb-24 relative"
      )>
      <main className=%twc("w-full px-5 lg:mt-10")>
        // 타이틀
        // md, lg 사이즈
        <h2 className=%twc("hidden xl:block text-text-L1 text-[26px] font-bold text-center")>
          {`회원가입`->React.string}
        </h2>
        <form className=%twc("mt-10 divide-y") onSubmit={onSubmit}>
          <div>
            // 이메일
            <VerifyEmailAddress emailExisted onEmailChange=handleEmailChange />
            // 비밀번호
            <div className=%twc("mt-5")>
              <span className=%twc("text-base font-bold mb-2")>
                {`비밀번호`->React.string}
                <span className=%twc("ml-0.5 text-notice")> {"*"->React.string} </span>
              </span>
              <Input
                className=%twc("mt-2")
                name="password"
                type_={showPwd ? "text" : "password"}
                size=Input.Large
                placeholder={`비밀번호 입력 (영문, 숫자 조합 6~15자)`}
                onChange={FormFields.Password->form.handleChange->ReForm.Helpers.handleChange}
                error={FormFields.Password->Form.ReSchema.Field->form.getFieldError}
              />
              // 비밀번호 표시
              <div className=%twc("flex items-center mt-2")>
                <Checkbox
                  id="show-pwd"
                  name="show-pwd"
                  checked={showPwd}
                  onChange={makeOnCheckedChange(setShowPwd)}
                />
                <span className=%twc("ml-2") onClick={_ => setShowPwd(.prev => !prev)}>
                  {`비밀번호 표시`->React.string}
                </span>
              </div>
            </div>
          </div>
          <div className=%twc("mt-7")>
            // 회사명
            <div className=%twc("mt-10")>
              <span className=%twc("text-base font-bold")>
                {`회사명`->React.string}
                <span className=%twc("ml-0.5 text-notice")> {"*"->React.string} </span>
              </span>
              <Input
                className=%twc("mt-2")
                name="company-name"
                type_="text"
                size=Input.Large
                placeholder={`회사명 입력`}
                onChange={FormFields.Name->form.handleChange->ReForm.Helpers.handleChange}
                error={FormFields.Name->Form.ReSchema.Field->form.getFieldError}
              />
            </div>
            // 담당자명
            <div className=%twc("mt-5")>
              <span className=%twc("text-base font-bold mb-2")>
                {`담당자명`->React.string}
                <span className=%twc("ml-0.5 text-notice")> {"*"->React.string} </span>
              </span>
              <Input
                className=%twc("mt-2")
                name="manager-name"
                type_="text"
                size=Input.Large
                placeholder={`담당자명 입력`}
                onChange={FormFields.Manager->form.handleChange->ReForm.Helpers.handleChange}
                error={FormFields.Manager->Form.ReSchema.Field->form.getFieldError}
              />
            </div>
            // 연락처
            <div className=%twc("mt-5")>
              <span className=%twc("text-base font-bold")>
                {`휴대전화번호`->React.string}
                <span className=%twc("ml-0.5 text-notice")> {"*"->React.string} </span>
              </span>
              <VerifyBuyerPhoneNumber onVerified={onPhoneVerified} />
            </div>
          </div>
          <div className=%twc("mt-7")>
            // 사업자 등록번호
            <div className=%twc("mt-10")>
              <span className=%twc("text-base font-bold mb-2")>
                {`사업자 등록번호`->React.string}
                <span className=%twc("ml-0.5 text-notice")> {"*"->React.string} </span>
              </span>
              <div className=%twc("mt-2")>
                <VerifyBusinessNumber onChange=onBusinessNumberChange />
              </div>
            </div>
          </div>
          <div className=%twc("mt-7")>
            // 약관
            <div className=%twc("flex items-center mt-7")>
              <Checkbox
                id="agree-all" name="agree-all" checked={isAllAgreed} onChange={toggleAllCheck}
              />
              <span className=%twc("ml-2 font-bold text-base")>
                {`전체 내용에 동의합니다`->React.string}
              </span>
            </div>
            // 신선하이 이용약관
            <div className=%twc("flex items-center justify-between mt-5")>
              <div className=%twc("flex items-center")>
                <Checkbox
                  id="basic"
                  name="basic"
                  checked={agreedTerms->Belt.Set.String.has("basic")}
                  onChange={toggleCheck}
                />
                <span className=%twc("ml-2 text-base")>
                  {`신선하이 이용약관 (필수)`->React.string}
                  <span className=%twc("ml-0.5 text-notice")> {"*"->React.string} </span>
                </span>
              </div>
              <Next.Link href={makeTermUrl("a9f5ca47-9dda-4a34-929c-60e1ce1dfbe5")}>
                <a target="_blank">
                  <IconArrow
                    height="18" width="18" strokeWidth="0" fill="#DDDDDD" stroke="#DDDDDD"
                  />
                </a>
              </Next.Link>
            </div>
            // 개인정보 수집·이용(필수)
            <div className=%twc("flex items-center justify-between mt-4")>
              <div className=%twc("flex items-center")>
                <Checkbox
                  id="privacy"
                  name="privacy"
                  checked={agreedTerms->Belt.Set.String.has("privacy")}
                  onChange={toggleCheck}
                />
                <span className=%twc("ml-2 text-base")>
                  {`개인정보 수집이용 동의 (필수)`->React.string}
                  <span className=%twc("ml-0.5 text-notice")> {"*"->React.string} </span>
                </span>
              </div>
              <Next.Link href={makeTermUrl("7d920089-18ba-4ca6-a806-f83ec8f6c335")}>
                <a target="_blank">
                  <IconArrow
                    height="18" width="18" strokeWidth="0" fill="#DDDDDD" stroke="#DDDDDD"
                  />
                </a>
              </Next.Link>
            </div>
            // 맞춤 소싱 제안 등 마케팅 정보 수신(선택)
            <div className=%twc("flex items-center justify-between mt-4")>
              <div className=%twc("flex items-center")>
                <Checkbox
                  id="marketing"
                  name="marketing"
                  checked={agreedTerms->Belt.Set.String.has("marketing")}
                  onChange={toggleCheck}
                />
                <span className=%twc("ml-2 text-base")>
                  {`맞춤 소싱 제안 등 마케팅 정보 수신 (선택)`->React.string}
                </span>
              </div>
              <Next.Link href={makeTermUrl("4f08bfe5-9ba7-4d1d-ba34-04281414ee00")}>
                <a target="_blank">
                  <IconArrow
                    height="18" width="18" strokeWidth="0" fill="#DDDDDD" stroke="#DDDDDD"
                  />
                </a>
              </Next.Link>
            </div>
            // Submit
            <span className=%twc("flex h-13 mt-10")>
              <button
                type_="submit"
                className={isSubmitDisabled ? %twc("btn-level1-disabled") : %twc("btn-level1")}
                disabled={isSubmitDisabled}>
                {`회원가입`->React.string}
              </button>
            </span>
          </div>
        </form>
        <div className=%twc("text-text-L2 mt-9 text-center")>
          {j`이미 가입하셨나요? `->React.string}
          <Next.Link href="/buyer/signin">
            <a className=%twc("underline")> {`로그인하기`->React.string} </a>
          </Next.Link>
        </div>
      </main>
    </div>
    <Dialog
      isShow=showErr
      onCancel={_ => setShowErr(._ => Dialog.Hide)}
      textOnCancel={`닫기`}
      boxStyle=%twc("rounded-xl")>
      <p className=%twc("text-text-L1 text-center whitespace-pre-wrap")>
        {`입력한 정보를 확인해주세요.\n\n이미 가입하신 경우\n비밀번호 찾기를 통해 로그인하실 수 있으며\n관련 문의사항은 채널톡으로 문의해주세요.`->React.string}
      </p>
    </Dialog>
  </>
}
