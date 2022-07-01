open ReactHookForm

@val @scope("window")
external jsfPay: Dom.element => unit = "jsf__pay"

@val @scope("window")
external jsAlert: string => unit = "alert"

@val @scope(("window", "location"))
external origin: string = "origin"

@spice
type paymentMethod = [
  | @spice.as("card") #CREDIT_CARD
  | @spice.as("virtual") #VIRTUAL_ACCOUNT
  | @spice.as("transfer") #TRANSFER
]

type cashReceipt = {"type": string}

type tossRequest = {
  amount: int,
  orderId: string,
  orderName: string,
  customerName: string,
  successUrl: string,
  failUrl: string,
  validHours: option<int>,
  cashReceipt: option<cashReceipt>,
}

@val @scope(("window", "tossPayments"))
external requestTossPayment: (. string, tossRequest) => unit = "requestPayment"

let paymentMethodToKCPValue = c =>
  switch c {
  | #CREDIT_CARD => "100000000000"
  | #VIRTUAL_ACCOUNT => "001000000000"
  | #TRANSFER => "001000000000"
  }

let paymentMethodToTossValue = c =>
  switch c {
  | #CREDIT_CARD => `카드`
  | #VIRTUAL_ACCOUNT => `가상계좌`
  | #TRANSFER => `계좌이체`
  }

let tossPaymentsValidHours = c =>
  switch c {
  | #VIRTUAL_ACCOUNT => Some(24)
  | _ => None
  }

let tossPaymentsCashReceipt = c =>
  switch c {
  | #VIRTUAL_ACCOUNT => Some({"type": `미발행`})
  | _ => None
  }

@spice
type form = {
  @spice.key("payment-method") paymentMethod: paymentMethod,
  amount: int,
}

let setValueToHtmlInputElement = (name, v) => {
  open Webapi.Dom
  document
  ->Document.getElementById(name)
  ->Option.flatMap(HtmlInputElement.ofElement)
  ->Option.map(e => e->HtmlInputElement.setValue(v))
  ->ignore
}

module MutationCreateCharge = %relay(`
  mutation CashChargeButtonBuyerMutation(
    $paymentMethod: PaymentMethod!
    $amount: Int!
    $device: Device
    $purpose: PaymentPurpose!
  ) {
    requestPayment(
      input: {
        paymentMethod: $paymentMethod
        amount: $amount
        device: $device
        purpose: $purpose
      }
    ) {
      ... on RequestPaymentKCPResult {
        siteCd
        siteKey
        siteName
        ordrIdxx
        currency
        shopUserId
        buyrName
      }
      ... on RequestPaymentTossPaymentsResult {
        orderId
        amount
        clientKey
        customerName
        customerEmail
        paymentId
      }
      ... on Error {
        code
        message
      }
    }
  }
`)

@react.component
let make = (~hasRequireTerms, ~buttonClassName, ~buttonText) => {
  let {addToast} = ReactToastNotifications.useToasts()

  let {handleSubmit, control, reset, formState: {isDirty}} = Hooks.Form.use(.
    ~config=Hooks.Form.config(~mode=#onSubmit, ~revalidateMode=#onChange, ()),
    (),
  )

  let (mutate, isMutating) = MutationCreateCharge.use()

  let (requireTerms, setRequireTerms) = React.Uncurried.useState(_ => false)

  let close = _ => {
    open Webapi
    let buttonClose = Dom.document->Dom.Document.getElementById("btn-close")
    buttonClose
    ->Option.flatMap(buttonClose' => {
      buttonClose'->Dom.Element.asHtmlElement
    })
    ->Option.forEach(buttonClose' => {
      buttonClose'->Dom.HtmlElement.click
    })
    ->(() => reset(. None))
  }
  let errorElement =
    <>
      <IconNotice width="1.25rem" height="1.25rem" fill="none" />
      <div className=%twc("ml-1.5 text-sm")>
        {j`최소 결제금액(1,000원 이상)을 입력해주세요.`->React.string}
      </div>
    </>

  let handleError = (~message=?, ()) =>
    addToast(.
      <div className=%twc("flex items-center")>
        <IconError height="24" width="24" className=%twc("mr-2") />
        {j`결제가 실패하였습니다. ${message->Option.getWithDefault("")}`->React.string}
      </div>,
      {appearance: "error"},
    )

  // PC 결제 플로우
  // 1. 우리 API 통해서 주문 정보 생성(mutation)
  // 2. 1번의 주문 정보를 form input에 채웁니다. -> KCP의 SDK가 구식이어서 예상할
  //    수 없는 에러를 피하기위해 form을 채워서 사용합니다.
  // 3. jsf__pay 함수를 호출 -> 결제창이 열리고,
  // 4. KCP 결제창에서 결제 액션이 일어나면, m_completepayment 함수가 호출 됩니다.
  // 5. m_completepayment 함수 안에 우리 API에 mutation을 할 함수를 심어야 합니다.

  // 모바일 결제 플로우
  // 1. 우리 API 통해서 주문 정보 생성(mutation)
  // 2. 1번의 주문 정보를 이용해 requestTossPayment 호출합니다.
  // 3. 결제 성공, 실패 시 각 페이지로 이동하고 각 페이지에서 처리 로직을 실행합니다.

  let detectIsMobile = () => {
    let {os} = DetectBrowser.detect()
    let mobileOS = ["iOS", "Android OS", "BlackBerry OS", "Windows Mobile", "Amazon OS"]
    mobileOS->Array.some(x => x == os)
  }

  let handleConfirm = (data, _) => {
    switch data->form_decode {
    | Ok(data') =>
      {
        open Webapi.Dom

        setValueToHtmlInputElement("good_mny", data'.amount->Int.toString)
        setValueToHtmlInputElement("pay_method", data'.paymentMethod->paymentMethodToKCPValue)

        mutate(
          ~variables={
            paymentMethod: data'.paymentMethod,
            amount: data'.amount,
            device: detectIsMobile() ? Some(#MOBILE) : Some(#PC),
            purpose: #SINSUN_CASH,
          },
          ~onCompleted={
            ({requestPayment}, _) => {
              switch requestPayment {
              | Some(result) =>
                // 2번 플로우의 우리 API가 응답해준 주문 정보를 폼에 채운다.
                switch result {
                | #RequestPaymentKCPResult(requestPaymnetKCPResult) => {
                    // KCP 결제창이 뜨기 전에, 충전하기 다이얼로그를 닫는다.
                    close()

                    setValueToHtmlInputElement("site_cd", requestPaymnetKCPResult.siteCd)
                    setValueToHtmlInputElement("site_name", requestPaymnetKCPResult.siteName)
                    setValueToHtmlInputElement("site_key", requestPaymnetKCPResult.siteKey)
                    setValueToHtmlInputElement("ordr_idxx", requestPaymnetKCPResult.ordrIdxx)
                    setValueToHtmlInputElement("currency", requestPaymnetKCPResult.currency)
                    setValueToHtmlInputElement("shop_user_id", requestPaymnetKCPResult.shopUserId)
                    setValueToHtmlInputElement("buyr_name", requestPaymnetKCPResult.buyrName)

                    let orderInfo = document->Document.getElementById("order_info")

                    switch orderInfo {
                    | Some(orderInfo') => jsfPay(orderInfo')
                    | None =>
                      handleError(~message=`폼 데이터를 찾을 수가 없습니다.`, ())
                    }
                  }
                | #RequestPaymentTossPaymentsResult(requestPaymentTossPaymentsResult) =>
                  requestTossPayment(.
                    data'.paymentMethod->paymentMethodToTossValue,
                    {
                      amount: requestPaymentTossPaymentsResult.amount,
                      orderId: requestPaymentTossPaymentsResult.orderId,
                      orderName: `신선캐시 ${requestPaymentTossPaymentsResult.amount->Int.toString}`,
                      customerName: requestPaymentTossPaymentsResult.customerName,
                      validHours: data'.paymentMethod->tossPaymentsValidHours,
                      successUrl: `${origin}/buyer/toss-payments/success?payment-id=${requestPaymentTossPaymentsResult.paymentId->Int.toString}`, // TODO
                      failUrl: `${origin}/buyer/toss-payments/fail`,
                      cashReceipt: data'.paymentMethod->tossPaymentsCashReceipt,
                    },
                  )
                | #Error(_)
                | _ =>
                  handleError(~message=`주문 생성 에러`, ())
                }
              | _ => handleError(~message=`주문 생성 요청 실패`, ())
              }
            }
          },
          ~onError={
            err => handleError(~message=err.message, ())
          },
          (),
        )
      }->ignore
    | Error(msg) => {
        Js.Console.log(msg)
        handleError(~message=msg.message, ())
      }
    }
  }

  let handleOnChange = (fn, e) => {
    let v = (e->ReactEvent.Synthetic.target)["value"]

    let stringToFloat = str =>
      str->Js.String2.replaceByRe(%re("/\D/g"), "")->Float.fromString->Option.getWithDefault(0.)

    fn(Controller.OnChangeArg.value(v->stringToFloat->Js.Json.number))
  }

  let handleOnSelect = (fn, current, toPlusValue, e) => {
    e->ReactEvent.Synthetic.preventDefault
    let currentValue = current->Js.Json.decodeNumber->Option.getWithDefault(0.)
    fn(
      Controller.OnChangeArg.value(
        (currentValue +. toPlusValue->Float.fromString->Option.getWithDefault(0.))->Js.Json.number,
      ),
    )
  }

  let changeToFormattedFloat = (j: Js.Json.t) =>
    j->Js.Json.decodeNumber->Option.mapWithDefault("", f => f->Locale.Float.show(~digits=0))

  <RadixUI.Dialog.Root>
    <RadixUI.Dialog.Trigger className=buttonClassName>
      <span> {buttonText->React.string} </span>
    </RadixUI.Dialog.Trigger>
    <RadixUI.Dialog.Portal>
      <RadixUI.Dialog.Overlay className=%twc("dialog-overlay") />
      <RadixUI.Dialog.Content
        className=%twc("dialog-content p-5 overflow-y-auto text-text-L1 rounded-2xl")>
        <RadixUI.Dialog.Close id="btn-close" className=%twc("hidden")>
          {j``->React.string}
        </RadixUI.Dialog.Close>
        <div className=%twc("flex justify-between items-center")>
          <h3 className=%twc("font-bold text-xl")> {j`신선캐시 충전`->React.string} </h3>
          <button onClick={_ => close()} className=%twc("cursor-pointer border-none")>
            <IconClose height="1.5rem" width="1.5rem" fill="#262626" />
          </button>
        </div>
        <div className=%twc("flex items-center gap-4 mt-10 font-bold")>
          <h3 className=%twc("text-sm")> {j`신선캐시 잔액`->React.string} </h3>
          <Buyer_Deposit_Detail_Button_Admin.Summary.Amount
            kind={CustomHooks.TransactionSummary.Deposit} className=%twc("text-primary")
          />
        </div>
        <Divider className=%twc("my-5") />
        <form onSubmit={handleSubmit(. handleConfirm)}>
          <div className=%twc("flex items-center text-sm")>
            <h3 className=%twc("font-bold mr-1")> {j`충전금액`->React.string} </h3>
            <span> {j`* 최소금액 1,000원`->React.string} </span>
          </div>
          <Controller
            name="amount"
            control
            defaultValue={Js.Json.string("")}
            shouldUnregister=true
            rules={Rules.make(
              ~validate=Js.Dict.fromArray([
                ("required", Validation.sync(value => value !== "")),
                ("over1000", Validation.sync(v => v >= 1000)),
              ]),
              (),
            )}
            render={({field: {onChange, value, name}, fieldState: {error}}) => <>
              <InputWithAdornment
                type_="string"
                name
                value={value->changeToFormattedFloat}
                onChange={handleOnChange(onChange)}
                placeholder={`금액을 입력해주세요`}
                adornment={<span> {j`원`->React.string} </span>}
                errored={error->Option.isSome}
                errorElement
                className=%twc("mt-3 h-13")
              />
              <div className=%twc("w-full mt-2 mb-3 text-sm")>
                {Array.zip(
                  [j`+50만원`, j`+100만원`, j`+500만원`, j`+1000만원`],
                  ["500000", "1000000", "5000000", "10000000"],
                )
                ->Array.map(((label, toPlusValue)) =>
                  <button
                    key={label}
                    type_="button"
                    className={%twc(
                      "h-9 w-1/4 py-[7px] border border-gray-button-gl bg-white text-text-L2"
                    )}
                    onClick={handleOnSelect(onChange, value, toPlusValue)}>
                    {label->React.string}
                  </button>
                )
                ->React.array}
              </div>
            </>}
          />
          <h3 className=%twc("mt-7 mb-3 font-bold text-sm")> {j`결제수단`->React.string} </h3>
          <Controller
            name="payment-method"
            control
            shouldUnregister=true
            defaultValue={Js.Json.string("card")}
            render={({field: {onChange, value}}) =>
              <div className=%twc("flex gap-10")>
                {[
                  (Js.Json.string("virtual"), `가상계좌`),
                  (Js.Json.string("card"), `신용카드`),
                ]
                ->Array.map(((v, name)) =>
                  <button
                    key=name
                    onClick={e => {
                      e->ReactEvent.Synthetic.preventDefault
                      e->ReactEvent.Synthetic.stopPropagation
                      v->Controller.OnChangeArg.value->onChange
                    }}
                    className=%twc("flex items-center cursor-pointer gap-2 text-sm")>
                    {value == v
                      ? <IconRadioFilled width="1.25rem" height="1.25rem" fill="none" />
                      : <IconRadioDefault width="1.25rem" height="1.25rem" fill="none" />}
                    {name->React.string}
                  </button>
                )
                ->React.array}
              </div>}
          />
          {switch hasRequireTerms {
          | true =>
            <div className=%twc("flex justify-between")>
              <button
                className=%twc("flex items-center cursor-pointer")
                onClick={_ => setRequireTerms(.prev => !prev)}>
                {requireTerms
                  ? <IconCheckBoxChecked width="20" height="20" />
                  : <IconCheckBoxUnChecked width="20" height="20" />}
                <span className=%twc("ml-2 text-sm")>
                  {j`신선하이 이용약관 동의(필수)`->React.string}
                </span>
              </button>
              <a href={"/terms"} target="_blank">
                <IconArrow width="20" height="20" fill="#B2B2B2" className=%twc("cursor-pointer") />
              </a>
            </div>
          | false => React.null
          }}
          <div className=%twc("flex justify-between gap-3 mt-10 text-lg")>
            <button
              type_="button"
              className=%twc("w-1/2 py-3 btn-level6 font-bold")
              onClick={_ => close()}
              disabled=isMutating>
              {`닫기`->React.string}
            </button>
            <button
              type_="submit"
              disabled={isMutating || !isDirty}
              className={isDirty
                ? %twc("w-1/2 py-3 btn-level1 font-bold")
                : %twc("w-1/2 py-3 btn-level1-disabled font-bold")}>
              {`결제`->React.string}
            </button>
          </div>
        </form>
      </RadixUI.Dialog.Content>
    </RadixUI.Dialog.Portal>
  </RadixUI.Dialog.Root>
}
