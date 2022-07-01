let formatDateTime = d => d->Js.Date.fromString->Locale.DateTime.formatFromUTC("yyyy/MM/dd HH:mm")
let formatDate = d => d->Js.Date.fromString->Locale.DateTime.formatFromUTC("yyyy/MM/dd")
let formatTime = d => d->Js.Date.fromString->Locale.DateTime.formatFromUTC("HH:mm")

module Item = {
  module Table = {
    @react.component
    let make = (~transaction: CustomHooks.Transaction.transaction) => {
      <li className=%twc("flex justify-between text-gray-700 p-5")>
        <div className=%twc("h-full")>
          <span className=%twc("block text-text-L1 font-bold mb-1")>
            {transaction.type_->Converter.displayTransactionKind->React.string}
          </span>
          <span className=%twc("block text-gray-400 whitespace-nowrap")>
            {transaction.createdAt->formatDateTime->React.string}
          </span>
        </div>
        <div className=%twc("h-full text-right")>
          <span className=%twc("block")>
            {transaction.amount->Locale.Float.show(~digits=0)->React.string}
          </span>
          <span className=%twc("block font-bold")>
            {transaction.deposit->Locale.Float.show(~digits=0)->React.string}
          </span>
        </div>
      </li>
    }

    module Loading = {
      open Skeleton

      @react.component
      let make = () => {
        Garter.Array.make(7, 0)
        ->Garter.Array.map(k =>
          <li key={k->Int.toString} className=%twc("flex justify-between text-gray-700 p-5")>
            <div className=%twc("h-full")>
              <span className=%twc("block text-text-L1 font-bold mb-1")>
                <Box className=%twc("w-20") />
              </span>
              <span className=%twc("block text-gray-400 whitespace-nowrap")>
                <Box className=%twc("w-24") />
              </span>
            </div>
            <div className=%twc("h-full text-right")>
              <span className=%twc("block")> <Box className=%twc("w-20") /> </span>
              <span className=%twc("block font-bold")> <Box className=%twc("w-32") /> </span>
            </div>
          </li>
        )
        ->React.array
      }
    }
  }
}

@react.component
let make = (~transaction: CustomHooks.Transaction.transaction) => {
  // PC 뷰
  <Item.Table transaction />
}
