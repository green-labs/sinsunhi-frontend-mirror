module BalanceView = {
  @react.component
  let make = (~balance, ~credit, ~maxExpiryDays, ~rate) => {
    let (open_, setOpen) = React.Uncurried.useState(_ => false)

    let handleOrdersListOpen = _ => {
      setOpen(._ => true)
    }

    <>
      <After_Pay_Orders_List open_ setOpen />
      <div className=%twc("container max-w-lg mx-auto sm:shadow-gl px-7")>
        <div className=%twc("flex flex-col divide-y")>
          <div className=%twc("flex flex-col gap-6 py-7")>
            <div className=%twc("flex items-end")>
              <div>
                <div className=%twc("text-sm")> {`나중결제 가능 금액`->React.string} </div>
                <div className=%twc("text-lg font-bold text-green-500")>
                  {`${balance->Locale.Float.show(~digits=0)} 원`->React.string}
                </div>
              </div>
              <div className=%twc("ml-auto")>
                <ReactUtil.SpreadProps props={"data-gtm": `btn-after-pay-history-list`}>
                  <button onClick=handleOrdersListOpen className=%twc("btn-level6-small px-2 py-1")>
                    {`내역보기`->React.string}
                  </button>
                </ReactUtil.SpreadProps>
              </div>
            </div>
            <div>
              <div className=%twc("text-sm")>
                {`총 나중결제 이용 한도`->React.string}
              </div>
              <div className=%twc("text-lg font-bold")>
                {`${credit->Locale.Float.show(~digits=0)} 원`->React.string}
              </div>
            </div>
          </div>
          <div className=%twc("flex flex-col gap-3 text-sm py-5")>
            <div className=%twc("flex place-content-between")>
              <div className=%twc("text-gray-600")> {`수수료`->React.string} </div>
              <div className=%twc("col-span-3")> {`${rate}%`->React.string} </div>
            </div>
            <div className=%twc("flex place-content-between")>
              <div className=%twc("text-gray-600")> {`만기일`->React.string} </div>
              <div className=%twc("col-span-3")>
                {`주문서별 업로드 완료일 기준 `->React.string}
                <b> {`최대 ${maxExpiryDays->Belt.Int.toString}일`->React.string} </b>
              </div>
            </div>
            <div className=%twc("flex place-content-between")>
              <div className=%twc("text-gray-600")> {`상환계좌`->React.string} </div>
              <div className=%twc("col-span-3")>
                {`신한은행 140-013-193191`->React.string}
              </div>
            </div>
          </div>
        </div>
      </div>
    </>
  }
}

module Balance = {
  @react.component
  let make = () => {
    let result = CustomHooks.AfterPayCredit.use()
    switch result {
    | Error(_) => <div> {`처리 중 오류가 발생하였습니다.`->React.string} </div>
    | Loading | NotRegistered => React.null
    | Loaded({credit: response}) => {
        let balance = (response.debtMax - response.debtTotal)->Belt.Int.toFloat
        let credit = response.debtMax->Belt.Int.toFloat
        let maxExpiryDays = response.debtExpiryDays
        let rate = response.debtInterestRate->Belt.Float.toString
        <BalanceView balance credit maxExpiryDays rate />
      }
    }
  }
}

module Notice = {
  @react.component
  let make = () => {
    let (text, setText) = React.Uncurried.useState(_ => `자세히 보기`)

    let handleChange = value => {
      setText(._ =>
        switch value {
        | [] => `자세히 보기`
        | _ => `접기`
        }
      )
    }
    <div
      className=%twc(
        "text-red-500 bg-red-50 border-red-150 border py-4 px-5 container max-w-lg mx-auto mt-7"
      )>
      <div>
        <b> {`[필독사항]`->React.string} </b>
        <br />
        {`나중결제 주문을 위한 필독사항을 꼭 확인하세요`->React.string}
      </div>
      <RadixUI.Accordian.Root _type=#multiple onValueChange=handleChange>
        <RadixUI.Accordian.Item value="guide-1">
          <RadixUI.Accordian.Content className=%twc("accordian-content")>
            <ol className=%twc("space-y-4 mt-4")>
              <li>
                {`1. 나중결제는 기존 선결제와 달리 현금영수증이 자동발급되지 않으며,세금계산서(발주금액+수수료 합계액)로 발행됩니다.`->React.string}
              </li>
              <li>
                {`2. 나중결제는 주문서 단위로 접수, 관리됩니다. 따라서 만기시 수수료 포함하여 주문서별 총발주금액을 일괄 상환하셔야 합니다. 상환 필요 금액은 [이용내역]  및 별도 카톡 알림으로 확인 가능합니다.`->React.string}
              </li>
              <li>
                {`3. 나중결제 이용 가능 한도 및 수수료는 내부 기준에 따라 부여되며, 연체 없이 꾸준한 이용시에는 한도 상향, 수수료 인하 등의 추가 혜택으로 연결될 수 있습니다.`->React.string}
              </li>
              <li>
                {`4.연체시 나중결제 서비스를 이용할 수 없으며, 연체원금에 대한 연체수수료가 일할로 부과됩니다.`->React.string}
                <br />
                {`(일 0.03%)`->React.string}
              </li>
              <li>
                {`5.가이드를 참고하여 주문서를 작성해주세요. `->React.string}
                <a
                  href="https://drive.google.com/file/d/1BQQ5Vg0eNWjCNlY925cGi-VDUyfFvBkf/view"
                  target="_new"
                  className=%twc("underline")>
                  {`[가이드]`->React.string}
                </a>
                <br />
                {`양식에 맞지 않을 경우 주문이 실패할 수 있습니다 `->React.string}
              </li>
            </ol>
          </RadixUI.Accordian.Content>
          <RadixUI.Accordian.Header>
            <RadixUI.Accordian.Trigger className=%twc("mt-4 accordian-trigger")>
              <div className=%twc("flex items-center")>
                <div className=%twc("text-sm underline")> {text->React.string} </div>
                <IconDropdown height="16" width="16" className=%twc("accordian-icon") />
              </div>
            </RadixUI.Accordian.Trigger>
          </RadixUI.Accordian.Header>
        </RadixUI.Accordian.Item>
      </RadixUI.Accordian.Root>
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
          open Agreement_After_Pay_Buyer.Agreement
          [agree1, agree2, agree3, agree4]
        }->Belt.Set.String.fromArray

        if false == didAgreements->Belt.Set.String.eq(reuquiredAgreements) {
          router->Next.Router.replace("/buyer/after-pay/agreement")
        }
      }
    }
    None
  }, [agreements])

  <Authorization.Buyer title=j`주문서 업로드`>
    <Notice />
    <Upload_Buyer.Tab.AfterPay />
    <Balance />
    <Upload_After_Pay_Form.UploadForm />
    <Upload_After_Pay_Form.UploadResult />
    <Guide_Upload_Buyer />
  </Authorization.Buyer>
}
