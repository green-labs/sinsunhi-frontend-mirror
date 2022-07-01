let formatDateTime = d => d->Js.Date.fromString->Locale.DateTime.formatFromUTC("yyyy/MM/dd HH:mm")
let formatDate = d => d->Js.Date.fromString->Locale.DateTime.formatFromUTC("yyyy/MM/dd")
let formatTime = d => d->Js.Date.fromString->Locale.DateTime.formatFromUTC("HH:mm")

module Item = {
  module Table = {
    @react.component
    let make = (~transaction: CustomHooks.Transaction.transaction) => {
      <li className=%twc("hidden lg:grid lg:grid-cols-4-buyer-transaction text-text-L1")>
        <div className=%twc("h-full flex flex-col px-4 py-2")>
          <span className=%twc("block font-bold mb-1")>
            {transaction.type_->Converter.displayTransactionKind->React.string}
          </span>
        </div>
        <div className=%twc("h-full flex flex-col px-4 py-2")>
          <span className=%twc("block")>
            {transaction.createdAt->formatDateTime->React.string}
          </span>
        </div>
        <div className=%twc("h-full flex flex-col px-4 py-2")>
          <span className=%twc("whitespace-nowrap")>
            {`${transaction.amount->Locale.Float.show(~digits=0)}원`->React.string}
          </span>
        </div>
        <div className=%twc("h-full flex flex-col px-4 py-2")>
          <span className=%twc("block font-bold")>
            {`${transaction.deposit->Locale.Float.show(~digits=0)}원`->React.string}
          </span>
        </div>
      </li>
    }
  }

  module Card = {
    @react.component
    let make = (~transaction: CustomHooks.Transaction.transaction) => {
      <li className=%twc("py-4 lg:mb-4 lg:hidden text-black-gl")>
        <section className=%twc("flex justify-between")>
          <div className=%twc("flex flex-col")>
            <span className=%twc("font-bold")>
              {transaction.type_->Converter.displayTransactionKind->React.string}
            </span>
            <span> {transaction.createdAt->formatDateTime->React.string} </span>
          </div>
          <div className=%twc("flex flex-col")>
            <span className=%twc("text-right")>
              {`${transaction.amount->Locale.Float.show(~digits=0)}원`->React.string}
            </span>
            <span className=%twc("text-right font-bold")>
              {`${transaction.deposit->Locale.Float.show(~digits=0)}원`->React.string}
            </span>
          </div>
        </section>
      </li>
    }
  }
}

@react.component
let make = (~transaction: CustomHooks.Transaction.transaction) => {
  <>
    // PC 뷰
    <Item.Table transaction />
    // 모바일뷰
    <Item.Card transaction />
  </>
}
