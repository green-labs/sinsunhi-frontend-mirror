external unsafeAsFile: Webapi.Blob.t => Webapi.File.t = "%identity"

module Mutation = %relay(`
  mutation TransactionsBuyerMutation(
    $encData: String!
    $encInfo: String!
    $paymentId: Int!
    $ordrMony: Int!
    $siteCd: String!
    $siteKey: String!
    $tranCd: String!
  ) {
    requestPaymentApprovalKCP(
      input: {
        encData: $encData
        encInfo: $encInfo
        paymentId: $paymentId
        ordrMony: $ordrMony
        siteCd: $siteCd
        siteKey: $siteKey
        tranCd: $tranCd
      }
    ) {
      ... on RequestPaymentApprovalKCPResult {
        paymentId
        amount
        resCd
        resEnMsg
        resMsg
        tno
      }
      ... on Error {
        code
        message
      }
    }
  }
`)

module Summary = {
  @react.component
  let make = () => {
    <div className=%twc("mt-4 p-5 lg:px-7 shadow-gl bg-white rounded")>
      <div className=%twc("flex flex-col lg:flex-row justify-between items-center")>
        <span className=%twc("w-full flex items-center gap-3 lg:text-xl font-bold")>
          <h2> {j`주문가능 잔액`->React.string} </h2>
          <Buyer_Deposit_Detail_Button_Admin.Summary.Amount
            kind={CustomHooks.TransactionSummary.Deposit} className=%twc("text-primary")
          />
        </span>
        <span className=%twc("flex flex-col lg:flex-row w-full mt-7 lg:mt-0 lg:justify-end")>
          <div className=%twc("flex gap-3 mr-3")>
            <Virtual_Account_Payment_Confirmation_Button_Buyer />
            <Buyer_Deposit_Detail_Button_Admin />
          </div>
          <Cash_Charge_Button_Buyer
            hasRequireTerms=false
            buttonClassName=%twc(
              "px-3 mt-2 lg:mt-0 h-9 max-w-fit rounded-lg text-white whitespace-nowrap focus:outline-none focus:ring-2 focus:ring-gray-150 focus:ring-offset-1 bg-primary"
            )
            buttonText=j`결제하기`
          />
        </span>
      </div>
    </div>
  }
}

module List = {
  @react.component
  let make = (~status: CustomHooks.Transaction.result) => {
    switch status {
    | Error(error) => <ErrorPanel error />
    | Loading => <div> {j`로딩 중..`->React.string} </div>
    | Loaded(
        transactions,
      ) => // 1024px 이하에서는 PC뷰의 레이아웃이 사용성을 해칠 수 밖에 없다고 판단되어
      // breakpoint lg(1024px)을 기준으로 구분한다.

      <>
        <div className=%twc("w-full overflow-x-scroll")>
          <div className=%twc("text-sm lg:min-w-max")>
            <div
              className=%twc(
                "hidden lg:grid lg:grid-cols-4-buyer-transaction bg-gray-100 text-gray-500 h-12"
              )>
              <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
                {j`정산유형`->React.string}
              </div>
              <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
                {j`날짜`->React.string}
              </div>
              <div className=%twc("h-full px-4 flex items-center text-center whitespace-nowrap")>
                {j`해당금액`->React.string}
              </div>
              <div className=%twc("h-full px-4 flex items-center text-center whitespace-nowrap")>
                {j`잔액`->React.string}
              </div>
            </div>
            {switch transactions->CustomHooks.Transaction.response_decode {
            | Ok(transactions') =>
              <ol
                className=%twc(
                  "divide-y divide-gray-300 lg:divide-gray-100 lg:list-height-buyer lg:overflow-y-scroll"
                )>
                {transactions'.data->Garter.Array.length > 0
                  ? transactions'.data
                    ->Garter.Array.map(transaction =>
                      <Transaction_Buyer key={transaction.id->Int.toString} transaction />
                    )
                    ->React.array
                  : <EmptyOrders />}
              </ol>
            | Error(_error) => <EmptyOrders />
            }}
          </div>
        </div>
        {switch status {
        | Loaded(transactions) =>
          switch transactions->CustomHooks.Transaction.response_decode {
          | Ok(transactions') =>
            <div className=%twc("flex justify-center py-5")>
              <Pagination
                pageDisplySize=Constants.pageDisplySize
                itemPerPage=transactions'.limit
                total=transactions'.count
              />
            </div>
          | Error(_) => React.null
          }
        | _ => React.null
        }}
      </>
    }
  }
}

type window
@val
external window: window = "window"
// KCP 결제 인증 후 결제 승인 요청 단계에서 호출될 전역 함수에 우리 함수를 심기 위한 바인딩
// _document.js에 KCP javascript 코드가 있음.
@set external setMutate: (window, 'form => unit) => unit = "mutate_completepayment"
// KCP 결제 승인 요청 단계에서 에러 발생 시 결제 창을 닫는 전역 함수에 우리 함수를 심는 바인딩
// _document.js에 KCP javascript 코드가 있음.
@val @scope("window")
external closeEventKCP: unit => unit = "closeEventKCP"

let getHtmlInputElementValue = id => {
  open Webapi.Dom
  document
  ->Document.getElementById(id)
  ->Option.flatMap(HtmlInputElement.ofElement)
  ->Option.map(HtmlInputElement.value)
}

module Transactions = {
  type test = {
    encData: option<string>,
    encInfo: option<string>,
    id: option<int>,
    ordrMony: option<int>,
    siteCd: option<string>,
    siteKey: option<string>,
    tranCd: option<string>,
  }

  @react.component
  let make = () => {
    let {addToast} = ReactToastNotifications.useToasts()
    let swr = Swr.useSwrConfig()
    let router = Next.Router.useRouter()
    let (mutate, _isMutating) = Mutation.use()
    let status = CustomHooks.Transaction.use(
      router.query->Webapi.Url.URLSearchParams.makeWithDict->Webapi.Url.URLSearchParams.toString,
    )

    let (isShowErrorForDownload, setShowErrorForDownload) = React.Uncurried.useState(_ =>
      Dialog.Hide
    )

    let count = switch status {
    | Loaded(transactions) =>
      switch transactions->CustomHooks.Transaction.response_decode {
      | Ok(transactions') => transactions'.count->Int.toString
      | Error(error) =>
        error->Js.Console.log
        `-`
      }
    | _ => `-`
    }

    let bodyOption = {
      let type_ = router.query->Js.Dict.get("type")->Option.getWithDefault("")
      Js.Dict.fromArray([("type", type_)])
    }

    let handleError = (~message=?, ()) =>
      addToast(.
        <div className=%twc("flex items-center")>
          <IconError height="24" width="24" className=%twc("mr-2") />
          {j`결제가 실패하였습니다. ${message->Option.getWithDefault("")}`->React.string}
        </div>,
        {appearance: "error"},
      )

    let notices = [
      j`1. 주문(발주)를 등록하기 위해서는 먼저 주문가능잔액(신선캐시) 충전이 필요합니다.`,
      j`2. 주문가능금액(신선캐시) 충전은 아래 [결제하기] 버튼을 눌러 충전창을 통해 진행해주세요.`,
      j`3. 충전금액과 결제수단을 선택하신 후에 NHN KCP의 결제창에서 결제를 정상적으로 수행해주셔야 충전이 완료됩니다.`,
      j`4. 충전을 위한 결제수단은 가상계좌(무통장입금)과 신용카드 결제가 지원됩니다.`,
      j`5. 가상계좌는 결제신청으로부터 만 24시간 후에는 무효화 됩니다.`,
      j`\t 새로 충전(결제요청) 해 주세요. 정해진 계좌에 신청한 금액만 정상적으로 입금처리가 됩니다.`,
      j`\t 간혹 ATM기기에서는 정상 처리되지 않는 경우가 있으니 창구입금이나 계좌이체 부탁드립니다.`,
      j`6. 신용카드 결제는 각 카드(개인 또는 사업자)의 한도에 따라서 최대 결제할 수 있는 금액이 정해져 있습니다. 이 금액을 초과한 경우 결제가 실패하게 되오니 양해부탁드립니다.`,
    ]

    React.useEffect0(_ => {
      switch %external(window) {
      | Some(window') =>
        // KCP의 m_CompletePayment 함수 내부에서 호출될 우리 API mutate 하는 함수
        setMutate(window', _ => {
          let encData = getHtmlInputElementValue("enc_data")
          let encInfo = getHtmlInputElementValue("enc_info")
          let paymentId = getHtmlInputElementValue("ordr_idxx")->Option.flatMap(Int.fromString)
          let ordrMony = getHtmlInputElementValue("good_mny")->Option.flatMap(Int.fromString)
          let siteCd = getHtmlInputElementValue("site_cd")
          let siteKey = getHtmlInputElementValue("site_key")
          let tranCd = getHtmlInputElementValue("tran_cd")

          switch (encData, encInfo, paymentId, ordrMony, siteCd, siteKey, tranCd) {
          | (
              Some(encData'),
              Some(encInfo'),
              Some(paymentId'),
              Some(ordrMony'),
              Some(siteCd'),
              Some(siteKey'),
              Some(tranCd'),
            ) =>
            mutate(
              ~variables={
                encData: encData',
                encInfo: encInfo',
                paymentId: paymentId',
                ordrMony: ordrMony',
                siteCd: siteCd',
                siteKey: siteKey',
                tranCd: tranCd',
              },
              ~onCompleted={
                ({requestPaymentApprovalKCP}, _error) => {
                  switch requestPaymentApprovalKCP {
                  | Some(result) =>
                    switch result {
                    | #RequestPaymentApprovalKCPResult(_requestPaymentApprovalKCP) => {
                        closeEventKCP()
                        addToast(.
                          <div className=%twc("flex items-center")>
                            <IconCheck
                              height="24" width="24" fill="#12B564" className=%twc("mr-2")
                            />
                            {j`결제가 완료되었습니다.`->React.string}
                          </div>,
                          {appearance: "success"},
                        )
                        // 결제 승인 요청 성공 응답 후, 주문가능 잔액 데이터를 갱신합니다.
                        swr.mutate(.
                          ~url=`${Env.restApiUrl}/transaction/summary?${router.query
                            ->Webapi.Url.URLSearchParams.makeWithDict
                            ->Webapi.Url.URLSearchParams.toString}`,
                          ~data=None,
                          ~revalidation=Some(true),
                        )
                        swr.mutate(.
                          ~url=`${Env.restApiUrl}/transaction?${router.query
                            ->Webapi.Url.URLSearchParams.makeWithDict
                            ->Webapi.Url.URLSearchParams.toString}`,
                          ~data=None,
                          ~revalidation=Some(true),
                        )
                      }
                    | #Error(error) => {
                        closeEventKCP()
                        handleError(~message=error.message->Option.getWithDefault(""), ())
                      }
                    | _ => {
                        closeEventKCP()
                        handleError(~message="", ())
                      }
                    }
                  | _ => ()
                  }
                }
              },
              ~onError={
                error => {
                  closeEventKCP()
                  handleError(~message=error.message, ())
                }
              },
              (),
            )->ignore
          | _ => handleError(~message=`결제 인증에 실패하였습니다.`, ())
          }
        })
      | None => () // SSR 단계
      }
      None
    })

    <>
      <div className=%twc("sm:px-10 md:px-20 text-enabled-L1")>
        <div
          className=%twc(
            "flex flex-col mx-4 lg:flex-row sm:mx-0 py-4 px-5 bg-red-gl rounded-lg text-red-500 mt-4"
          )>
          <span className=%twc("block font-bold mr-4 min-w-max")>
            {j`[주의사항]`->React.string}
          </span>
          <span className=%twc("whitespace-pre-wrap")>
            {notices->Array.map(notice => <p key=notice> {notice->React.string} </p>)->React.array}
          </span>
        </div>
        <Summary />
        <div className=%twc("px-5 lg:px-7 mt-4 shadow-gl")>
          <div className=%twc("md:flex md:justify-between pb-4 text-base")>
            <div className=%twc("pt-10 flex flex-col lg:flex-row sm:flex-auto sm:justify-between")>
              <h3 className=%twc("font-bold")>
                {j`결제내역`->React.string}
                <span className=%twc("ml-1 text-green-gl font-normal")>
                  {j`${count}건`->React.string}
                </span>
              </h3>
              <div className=%twc("flex flex-col lg:flex-row mt-4 lg:mt-0")>
                <div className=%twc("flex items-center")>
                  <Select_CountPerPage className=%twc("mr-2") />
                  <Select_Transaction_Status className=%twc("mr-2") />
                </div>
                <div className=%twc("flex mt-2 lg:mt-0")>
                  <Excel_Download_Request_Button
                    userType=Buyer requestUrl="/transaction/request-excel" bodyOption
                  />
                </div>
              </div>
            </div>
          </div>
          <List status />
        </div>
      </div>
      <form id="order_info" name="order_info" method="post" action="">
        // KCP 결제를 처리할 숨겨진 주문정보 form
        // 우리 API에 주문을 생성을 요청하고 응답 데이터로 채울 input들
        <input type_="hidden" id="ordr_idxx" name="ordr_idxx" value="TEST12345" maxLength=40 />
        <input type_="hidden" id="good_name" name="good_name" value=`신선하이` />
        <input type_="hidden" id="good_mny" name="good_mny" value="0" maxLength=12 />
        <input type_="hidden" id="currency" name="currency" value="0" maxLength=9 />
        <input type_="hidden" id="shop_user_id" name="shop_user_id" value="" />
        <input type_="hidden" id="buyr_name" name="buyr_name" value="" />
        <input type_="hidden" name="quotaopt" value="0" /> // 최대 할부 개월수
        // Optional 파라미터들
        // <input type_="hidden" id="buyr_tel1" name="buyr_tel1" value="02-0000-0000" />
        // <input type_="hidden" id="buyr_tel2" name="buyr_tel2" value="010-0000-0000" />
        // <input type_="hidden" id="buyr_mail" name="buyr_mail" value="test@test.co.kr" />
        // 신용카드 + 가상계좌
        // 신용카드 : 100000000000
        // 가상계좌 : 001000000000
        // 신용카드 + 가상계좌를 모두 표시하는 경우 101000000000
        <input type_="hidden" id="pay_method" name="pay_method" value="101000000000" />
        // 신선하이 KCP 정보
        <input type_="hidden" id="site_cd" name="site_cd" value="T0000" />
        <input type_="hidden" id="site_name" name="site_name" value="Sinsun Market" />
        <input type_="hidden" id="site_key" name="site_key" value="" />
        <input type_="hidden" id="site_logo" name="site_logo" value=Env.logo150x50 />
        // KCP의 GetField 함수가 데이터를 채울 input들
        <input type_="hidden" id="res_cd" name="res_cd" value="" />
        <input type_="hidden" id="res_msg" name="res_msg" value="" />
        <input type_="hidden" id="enc_info" name="enc_info" value="" />
        <input type_="hidden" id="enc_data" name="enc_data" value="" />
        <input type_="hidden" id="ret_pay_method" name="ret_pay_method" value="" />
        <input type_="hidden" id="tran_cd" name="tran_cd" value="" />
        <input type_="hidden" id="use_pay_method" name="use_pay_method" value="" />
      </form>
      <Dialog
        isShow=isShowErrorForDownload onConfirm={_ => setShowErrorForDownload(._ => Dialog.Hide)}>
        <p className=%twc("text-gray-500 text-center whitespace-pre-wrap")>
          {`다운로드에 실패하였습니다.\n다시 시도하시기 바랍니다.`->React.string}
        </p>
      </Dialog>
    </>
  }
}

@react.component
let make = () =>
  <Authorization.Buyer title=j`결제내역`>
    <RescriptReactErrorBoundary fallback={_ => <div> {`에러 발생`->React.string} </div>}>
      <React.Suspense fallback={<div> {j`로딩중..`->React.string} </div>}>
        <Transactions />
      </React.Suspense>
    </RescriptReactErrorBoundary>
  </Authorization.Buyer>
