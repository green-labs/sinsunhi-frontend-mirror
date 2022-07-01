module Info = {
  @react.component
  let make = () => {
    <div className=%twc("px-3 pt-16 pb-5")>
      <div className=%twc("text-xl py-1")>
        {`상품 먼저 받고 나중에 결제하세요`->React.string}
      </div>
      <div className=%twc("text-[2.25rem] font-bold text-green-500 py-1")>
        {`신선하이 나중결제`->React.string}
      </div>
      <div className=%twc("flex flex-col gap-2 py-9")>
        <div className=%twc("pb-1")>
          {`당장 상품이 필요한데 자금이 부족한가요? `->React.string}
        </div>
        <div className=%twc("flex items-center")>
          <div className=%twc("m-[2px]")> <IconCheck height="20" width="20" fill="#12B564" /> </div>
          <span> <b> {`수수료 0원`->React.string} </b> </span>
        </div>
        <div className=%twc("flex items-center")>
          <div className=%twc("m-[2px]")> <IconCheck height="20" width="20" fill="#12B564" /> </div>
          <span>
            {`최대 `->React.string}
            <b> {`4백 만원`->React.string} </b>
            {`까지`->React.string}
          </span>
        </div>
        <div className=%twc("flex items-center")>
          <div className=%twc("m-[2px]")> <IconCheck height="20" width="20" fill="#12B564" /> </div>
          <span>
            <b> {`최대 2개월 뒤 `->React.string} </b>
            {`결제하는 나중결제로 주문하세요!`->React.string}
          </span>
        </div>
      </div>
      <div className=%twc("text-sm text-gray-600")>
        {`*고객별 한도 및 세부조건은 상이할 수 있습니다.`->React.string}
      </div>
    </div>
  }
}

module AgreementItem = {
  @react.component
  let make = (~children, ~id, ~register, ~onChange=?, ~href=?) => {
    let r: ReactHookForm.Hooks.Register.t = register(. id, None)

    <div className=%twc("flex items-center gap-2")>
      <div>
        <Checkbox.Uncontrolled
          defaultChecked=false
          id
          disabled=false
          onChange={e => {
            r.onChange(e)
            onChange->Option.forEach(f => f(e))
          }}
          onBlur=r.onBlur
          inputRef=r.ref
          name=r.name
        />
      </div>
      <div> <label htmlFor=id> children </label> </div>
      {href->Option.mapWithDefault(React.null, href =>
        <div className=%twc("ml-auto")>
          <a href> <IconArrow height="20" width="20" fill={"#B2B2B2"} /> </a>
        </div>
      )}
    </div>
  }
}

module Agreement = {
  let agree1 = "AFTER_PAY_USAGE"
  let agree2 = "AFTER_PAY_COMPANY_CREDIT_INFO_COLLECT"
  let agree3 = "AFTER_PAY_COMPANY_CREDIT_INFO_INQUIRY"
  let agree4 = "AFTER_PAY_COMPANY_CREDIT_INFO_OFFER"

  @react.component
  let make = () => {
    let user = CustomHooks.User.Buyer.use()
    let userId = switch user {
    | LoggedIn({id}) => Some(id)
    | NotLoggedIn
    | Unknown =>
      None
    }

    let router = Next.Router.useRouter()

    let {register, handleSubmit, setValue, getValues} = {
      open ReactHookForm
      Hooks.Form.use(. ~config=Hooks.Form.config(~mode=#onChange, ()), ())
    }

    let didAllCheck = arr =>
      arr
      ->Js.Json.decodeArray
      ->Option.getWithDefault([false->Js.Json.boolean])
      ->Belt.Array.map(Js.Json.decodeBoolean)
      ->Belt.Array.every(x => x == Some(true))

    let onSubmit = (_, _) => {
      let names = ["agreeAll", agree1, agree2, agree3, agree4]
      let data = getValues(. names)

      let body =
        [agree1, agree2, agree3, agree4]
        ->Belt.Array.map(key => {"agreement": key})
        ->Js.Json.stringifyAny

      if data->didAllCheck {
        switch (userId, body) {
        | (Some(id), Some(body)) =>
          FetchHelper.requestWithRetry(
            ~fetcher=FetchHelper.postWithToken,
            ~url=`${Env.afterPayApiUrl}/buyers/${id->Belt.Int.toString}/terms`,
            ~body,
            ~count=3,
            ~onSuccess={
              _ => {
                router->Next.Router.replace("/buyer/after-pay/upload")
              }
            },
            ~onFailure={
              err => {
                Js.Console.error2("fail", err)
              }
            },
          )->ignore
        | _ => ()
        }
      } else {
        BrowserGuide.jsAlert(`서비스 이용을 위해 약관을 모두 동의해주세요.`)
      }
    }

    let handleAllChange = e => {
      let value = (e->ReactEvent.Synthetic.target)["checked"]
      setValue(. agree1, value)
      setValue(. agree2, value)
      setValue(. agree3, value)
      setValue(. agree4, value)
    }

    let handleAgreementChange = _ => {
      let names = [agree1, agree2, agree3, agree4]
      let agreeAll = getValues(. names)->didAllCheck

      setValue(. "agreeAll", Js.Json.boolean(agreeAll))
    }

    <div className=%twc("pt-7 pb-9")>
      <form onSubmit={handleSubmit(. onSubmit)}>
        <div className=%twc("px-3")>
          <AgreementItem id="agreeAll" register onChange={handleAllChange}>
            <div className=%twc("font-bold")>
              {`전체 내용에 동의합니다.`->React.string}
            </div>
          </AgreementItem>
        </div>
        <div className=%twc("flex flex-col gap-4 px-3 pt-5 pb-8")>
          <AgreementItem
            href="https://afterpay-terms.oopy.io/695e9bce-bc97-40d8-8f2a-c88b4611e057"
            id=agree1
            register
            onChange={handleAgreementChange}>
            <div className=%twc("text-sm")>
              {`(필수) 나중결제 이용약관`->React.string}
            </div>
          </AgreementItem>
          <AgreementItem
            href="https://afterpay-terms.oopy.io/347fb6de-ff87-4761-8eae-94b5559cc15e"
            id=agree2
            register
            onChange={handleAgreementChange}>
            <div className=%twc("text-sm")>
              {`(필수) 나중결제 기업신용정보 수집 및 이용`->React.string}
            </div>
          </AgreementItem>
          <AgreementItem
            href="https://afterpay-terms.oopy.io/126328c8-2f5d-4dc5-8ed0-363c07daadb2"
            id=agree3
            register
            onChange={handleAgreementChange}>
            <div className=%twc("text-sm")>
              {`(필수) 나중결제 기업신용정보 조회`->React.string}
            </div>
          </AgreementItem>
          <AgreementItem
            href="https://afterpay-terms.oopy.io/d69202a2-0ad3-4221-b40a-0059c0f5f835"
            id=agree4
            register
            onChange={handleAgreementChange}>
            <div className=%twc("text-sm")>
              {`(필수) 나중결제 기업신용정보 제공`->React.string}
            </div>
          </AgreementItem>
        </div>
        <div>
          <button type_="submit" className=%twc("btn-level1 py-3 px-5")>
            {`나중결제로 상품 주문하기`->React.string}
          </button>
        </div>
      </form>
    </div>
  }
}

@react.component
let make = () => {
  let agreements = CustomHooks.AfterPayAgreement.use()
  let router = Next.Router.useRouter()

  React.useEffect1(() => {
    switch agreements {
    | Loading => ()
    | NotRegistered | Error(_) => router->Next.Router.replace("/buyer/upload")
    | Loaded({terms}) => {
        let didAgreements =
          terms->Belt.Array.map(({agreement}) => agreement)->Belt.Set.String.fromArray
        let reuquiredAgreements = {
          open Agreement
          [agree1, agree2, agree3, agree4]
        }->Belt.Set.String.fromArray

        if true == didAgreements->Belt.Set.String.eq(reuquiredAgreements) {
          router->Next.Router.replace("/buyer/after-pay/upload")
        }
      }
    }
    None
  }, [agreements])

  <Authorization.Buyer title=j`주문서 업로드`>
    <Upload_Buyer.Tab.AfterPay />
    <div className=%twc("container max-w-lg mx-auto sm:shadow-gl px-7 divide-y")>
      <Info /> <Agreement />
    </div>
    <Upload_After_Pay_Form.UploadForm />
    <Guide_Upload_Buyer />
  </Authorization.Buyer>
}
