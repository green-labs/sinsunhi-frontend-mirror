module CustomDialog = Dialog
open RadixUI
let formatDate = d => d->Js.Date.fromString->Locale.DateTime.formatFromUTC("yyyy/MM/dd HH:mm")

module Summary = {
  module Amount = {
    open Skeleton

    @react.component
    let make = (~kind, ~className=?) => {
      let router = Next.Router.useRouter()
      let status = CustomHooks.TransactionSummary.use(
        router.query->Webapi.Url.URLSearchParams.makeWithDict->Webapi.Url.URLSearchParams.toString,
      )

      switch status {
      | Error(error) =>
        error->Js.Console.log
        <Box className=%twc("w-20") />
      | Loading => <Box className=%twc("w-20") />
      | Loaded(response) =>
        switch response->CustomHooks.TransactionSummary.response_decode {
        | Ok(response') =>
          open CustomHooks.TransactionSummary
          response'->Js.Console.log

          <span ?className>
            {switch kind {
            | OrderComplete =>
              `${response'.data.orderComplete->Locale.Float.show(
                  ~digits=0,
                  ~showPlusSign=true,
                )}원`->React.string
            | CashRefund =>
              `${response'.data.cashRefund->Locale.Float.show(
                  ~digits=0,
                  ~showPlusSign=true,
                )}원`->React.string
            | ImwebPay =>
              `${response'.data.imwebPay->Locale.Float.show(
                  ~digits=0,
                  ~showPlusSign=true,
                )}원`->React.string
            | ImwebCancel =>
              `${response'.data.imwebCancel->Locale.Float.show(
                  ~digits=0,
                  ~showPlusSign=true,
                )}원`->React.string
            | OrderCancel =>
              `${response'.data.orderCancel->Locale.Float.show(
                  ~digits=0,
                  ~showPlusSign=true,
                )}원`->React.string
            | OrderRefund =>
              `${response'.data.orderRefund->Locale.Float.show(
                  ~digits=0,
                  ~showPlusSign=true,
                )}원`->React.string
            | Deposit =>
              `${response'.data.deposit->Locale.Float.show(
                  ~digits=0,
                  ~showPlusSign=true,
                )}원`->React.string
            | SinsunCash =>
              `${response'.data.sinsunCash->Locale.Float.show(
                  ~digits=0,
                  ~showPlusSign=true,
                )}원`->React.string
            }}
          </span>
        | Error(error) =>
          error->Js.Console.log
          <Box className=%twc("w-20") />
        }
      }
    }
  }

  @react.component
  let make = () => {
    <div className=%twc("p-5")>
      <ol className=%twc("text-text-L1")>
        <li className=%twc("flex justify-between items-center py-1.5")>
          <span> {j`주문가능 잔액`->React.string} </span>
          <Amount
            kind={CustomHooks.TransactionSummary.Deposit} className=%twc("font-bold text-primary")
          />
        </li>
        <RadixUI.Separator.Root className=%twc("h-px bg-disabled-L2 my-3") />
        <li className=%twc("flex justify-between items-center py-1.5")>
          <span> {j`신선캐시 충전`->React.string} </span>
          <Amount kind={CustomHooks.TransactionSummary.SinsunCash} className=%twc("font-bold") />
        </li>
        <li className=%twc("flex justify-between items-center py-1.5")>
          <span> {j`상품결제`->React.string} </span>
          <Amount kind={CustomHooks.TransactionSummary.ImwebPay} className=%twc("font-bold") />
        </li>
        <li className=%twc("flex justify-between items-center py-1.5")>
          <span> {j`상품발주`->React.string} </span>
          <Amount kind={CustomHooks.TransactionSummary.OrderComplete} className=%twc("font-bold") />
        </li>
        <li className=%twc("flex justify-between items-center py-1.5")>
          <span> {j`주문취소`->React.string} </span>
          <Amount kind={CustomHooks.TransactionSummary.OrderCancel} className=%twc("font-bold") />
        </li>
        <li className=%twc("flex justify-between items-center py-1.5")>
          <span> {j`상품결제취소`->React.string} </span>
          <Amount kind={CustomHooks.TransactionSummary.ImwebCancel} className=%twc("font-bold") />
        </li>
        <li className=%twc("flex justify-between items-center py-1.5")>
          <span> {j`환불금액`->React.string} </span>
          <Amount kind={CustomHooks.TransactionSummary.OrderRefund} className=%twc("font-bold") />
        </li>
        <li className=%twc("flex justify-between items-center py-1.5")>
          <span> {j`잔액환불`->React.string} </span>
          <Amount kind={CustomHooks.TransactionSummary.CashRefund} className=%twc("font-bold") />
        </li>
      </ol>
    </div>
  }
}

@react.component
let make = () => {
  <Dialog.Root>
    <Dialog.Overlay className=%twc("dialog-overlay") />
    <Dialog.Trigger className=%twc("focus:outline-none")>
      <button className=%twc("btn-level6-small px-3 h-9")>
        {j`잔액 자세히보기`->React.string}
      </button>
    </Dialog.Trigger>
    <Dialog.Content className=%twc("dialog-content overflow-y-auto")>
      <h3 className=%twc("p-5 font-bold text-center")>
        {`주문가능 잔액 상세`->React.string}
      </h3>
      <Summary />
      <Dialog.Close className=%twc("w-full focus:outline-none")>
        <CustomDialog.ButtonBox textOnCancel=`닫기` onCancel={_ => Js.Console.log("!!")} />
      </Dialog.Close>
    </Dialog.Content>
  </Dialog.Root>
}
