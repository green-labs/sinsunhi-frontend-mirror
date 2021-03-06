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
          // ???????????? -> ????????? ??? redirect ??????????????????(redirect=...)??? ?????? ?????? ?????? ?????????.
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

              // ????????? ?????? ???, ????????? Braze ?????? ?????? ?????? ????????? ?????? userId??? postMessage ?????????.
              switch res.token->CustomHooks.Auth.decodeJwt->CustomHooks.Auth.user_decode {
              | Ok(user) =>
                Global.Window.ReactNativeWebView.PostMessage.storeBrazeUserId(user.id->Int.toString)
              | Error(_) => ()
              }

              // ???????????? ?????? -> ??? ?????? ?????? ????????? ????????? ?????? ??????
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
                // ????????? ?????????
                addToast(.
                  <div className=%twc("flex items-center")>
                    <IconCheck height="24" width="24" fill="#12B564" className=%twc("mr-2") />
                    {`??????????????? ?????????????????????.`->React.string}
                  </div>,
                  {appearance: "success"},
                )
                // ???????????? ?????? ?????? ????????? ??????
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
          email(Email, ~error=`????????? ????????? ????????? ??????????????????.`),
          regExp(
            Password,
            ~matches="^(?=.*\d)(?=.*[a-zA-Z]).{6,15}$",
            ~error=`??????, ?????? ?????? 6~15?????? ????????? ?????????.`,
          ),
          nonEmpty(Name, ~error=`???????????? ??????????????????.`),
          nonEmpty(Manager, ~error=`??????????????? ??????????????????.`),
          nonEmpty(Phone, ~error=`????????????????????? ??????????????????.`),
          nonEmpty(
            BusinessRegistrationNumber,
            ~error=`????????? ??????????????? ??????????????????.`,
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

  // ?????? ????????? ??? ?????? redirect ??????
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
      <title> {`???????????? - ????????????`->React.string} </title>
    </Next.Head>
    <div
      className=%twc(
        "container mx-auto max-w-lg min-h-screen flex flex-col justify-center items-center pb-24 relative"
      )>
      <main className=%twc("w-full px-5 lg:mt-10")>
        // ?????????
        // md, lg ?????????
        <h2 className=%twc("hidden xl:block text-text-L1 text-[26px] font-bold text-center")>
          {`????????????`->React.string}
        </h2>
        <form className=%twc("mt-10 divide-y") onSubmit={onSubmit}>
          <div>
            // ?????????
            <VerifyEmailAddress emailExisted onEmailChange=handleEmailChange />
            // ????????????
            <div className=%twc("mt-5")>
              <span className=%twc("text-base font-bold mb-2")>
                {`????????????`->React.string}
                <span className=%twc("ml-0.5 text-notice")> {"*"->React.string} </span>
              </span>
              <Input
                className=%twc("mt-2")
                name="password"
                type_={showPwd ? "text" : "password"}
                size=Input.Large
                placeholder={`???????????? ?????? (??????, ?????? ?????? 6~15???)`}
                onChange={FormFields.Password->form.handleChange->ReForm.Helpers.handleChange}
                error={FormFields.Password->Form.ReSchema.Field->form.getFieldError}
              />
              // ???????????? ??????
              <div className=%twc("flex items-center mt-2")>
                <Checkbox
                  id="show-pwd"
                  name="show-pwd"
                  checked={showPwd}
                  onChange={makeOnCheckedChange(setShowPwd)}
                />
                <span className=%twc("ml-2") onClick={_ => setShowPwd(.prev => !prev)}>
                  {`???????????? ??????`->React.string}
                </span>
              </div>
            </div>
          </div>
          <div className=%twc("mt-7")>
            // ?????????
            <div className=%twc("mt-10")>
              <span className=%twc("text-base font-bold")>
                {`?????????`->React.string}
                <span className=%twc("ml-0.5 text-notice")> {"*"->React.string} </span>
              </span>
              <Input
                className=%twc("mt-2")
                name="company-name"
                type_="text"
                size=Input.Large
                placeholder={`????????? ??????`}
                onChange={FormFields.Name->form.handleChange->ReForm.Helpers.handleChange}
                error={FormFields.Name->Form.ReSchema.Field->form.getFieldError}
              />
            </div>
            // ????????????
            <div className=%twc("mt-5")>
              <span className=%twc("text-base font-bold mb-2")>
                {`????????????`->React.string}
                <span className=%twc("ml-0.5 text-notice")> {"*"->React.string} </span>
              </span>
              <Input
                className=%twc("mt-2")
                name="manager-name"
                type_="text"
                size=Input.Large
                placeholder={`???????????? ??????`}
                onChange={FormFields.Manager->form.handleChange->ReForm.Helpers.handleChange}
                error={FormFields.Manager->Form.ReSchema.Field->form.getFieldError}
              />
            </div>
            // ?????????
            <div className=%twc("mt-5")>
              <span className=%twc("text-base font-bold")>
                {`??????????????????`->React.string}
                <span className=%twc("ml-0.5 text-notice")> {"*"->React.string} </span>
              </span>
              <VerifyBuyerPhoneNumber onVerified={onPhoneVerified} />
            </div>
          </div>
          <div className=%twc("mt-7")>
            // ????????? ????????????
            <div className=%twc("mt-10")>
              <span className=%twc("text-base font-bold mb-2")>
                {`????????? ????????????`->React.string}
                <span className=%twc("ml-0.5 text-notice")> {"*"->React.string} </span>
              </span>
              <div className=%twc("mt-2")>
                <VerifyBusinessNumber onChange=onBusinessNumberChange />
              </div>
            </div>
          </div>
          <div className=%twc("mt-7")>
            // ??????
            <div className=%twc("flex items-center mt-7")>
              <Checkbox
                id="agree-all" name="agree-all" checked={isAllAgreed} onChange={toggleAllCheck}
              />
              <span className=%twc("ml-2 font-bold text-base")>
                {`?????? ????????? ???????????????`->React.string}
              </span>
            </div>
            // ???????????? ????????????
            <div className=%twc("flex items-center justify-between mt-5")>
              <div className=%twc("flex items-center")>
                <Checkbox
                  id="basic"
                  name="basic"
                  checked={agreedTerms->Belt.Set.String.has("basic")}
                  onChange={toggleCheck}
                />
                <span className=%twc("ml-2 text-base")>
                  {`???????????? ???????????? (??????)`->React.string}
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
            // ???????????? ??????????????(??????)
            <div className=%twc("flex items-center justify-between mt-4")>
              <div className=%twc("flex items-center")>
                <Checkbox
                  id="privacy"
                  name="privacy"
                  checked={agreedTerms->Belt.Set.String.has("privacy")}
                  onChange={toggleCheck}
                />
                <span className=%twc("ml-2 text-base")>
                  {`???????????? ???????????? ?????? (??????)`->React.string}
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
            // ?????? ?????? ?????? ??? ????????? ?????? ??????(??????)
            <div className=%twc("flex items-center justify-between mt-4")>
              <div className=%twc("flex items-center")>
                <Checkbox
                  id="marketing"
                  name="marketing"
                  checked={agreedTerms->Belt.Set.String.has("marketing")}
                  onChange={toggleCheck}
                />
                <span className=%twc("ml-2 text-base")>
                  {`?????? ?????? ?????? ??? ????????? ?????? ?????? (??????)`->React.string}
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
                {`????????????`->React.string}
              </button>
            </span>
          </div>
        </form>
        <div className=%twc("text-text-L2 mt-9 text-center")>
          {j`?????? ??????????????????? `->React.string}
          <Next.Link href="/buyer/signin">
            <a className=%twc("underline")> {`???????????????`->React.string} </a>
          </Next.Link>
        </div>
      </main>
    </div>
    <Dialog
      isShow=showErr
      onCancel={_ => setShowErr(._ => Dialog.Hide)}
      textOnCancel={`??????`}
      boxStyle=%twc("rounded-xl")>
      <p className=%twc("text-text-L1 text-center whitespace-pre-wrap")>
        {`????????? ????????? ??????????????????.\n\n?????? ???????????? ??????\n???????????? ????????? ?????? ??????????????? ??? ?????????\n?????? ??????????????? ??????????????? ??????????????????.`->React.string}
      </p>
    </Dialog>
  </>
}
