let formatDate = d => d->Js.Date.fromString->Locale.DateTime.formatFromUTC("yyyy/MM/dd HH:mm")

module Item = {
  module Table = {
    @react.component
    let make = (~settlement: CustomHooks.Settlements.settlement) => {
      <li className=%twc("grid grid-cols-6-admin-settlement text-gray-700")>
        <div className=%twc("h-full flex flex-col px-4 py-2")>
          <RadixUI.RadioGroup.Item value=settlement.producerCode className=%twc("radio-item")>
            <RadixUI.RadioGroup.Indicator className=%twc("radio-indicator") />
          </RadixUI.RadioGroup.Item>
        </div>
        <div className=%twc("h-full flex flex-col px-4 py-2")>
          <span className=%twc("block mb-1")> {settlement.producerCode->React.string} </span>
          <span className=%twc("block text-gray-400 mb-1")>
            {settlement.producerName->React.string}
          </span>
        </div>
        <div className=%twc("h-full flex flex-col px-4 py-2")>
          <span className=%twc("block text-gray-400")>
            {settlement.settlementCycle->Converter.stringifySettlementCycle->React.string}
          </span>
        </div>
        <div className=%twc("h-full flex flex-col px-4 py-2")>
          <span className=%twc("whitespace-nowrap")>
            {`${settlement.invoiceUpdatedSum->Locale.Float.show(~digits=0)}원`->React.string}
          </span>
          <span className=%twc("whitespace-nowrap")>
            {`${settlement.falseExcludedSum->Locale.Float.show(~digits=0)}원`->React.string}
          </span>
        </div>
        <div className=%twc("h-full flex flex-col px-4 py-2")>
          <span className=%twc("block")>
            {`${settlement.completeSum->Locale.Float.show(~digits=0)}원`->React.string}
          </span>
        </div>
        <div className=%twc("h-full flex flex-col px-4 py-2")>
          <span className=%twc("block")>
            {`${settlement.completeTax->Locale.Float.show(~digits=0)}원`->React.string}
          </span>
        </div>
      </li>
    }

    module Loading = {
      open Skeleton

      @react.component
      let make = () => {
        <li className=%twc("grid grid-cols-6-admin-settlement text-gray-700")>
          <div className=%twc("h-full flex flex-col px-4 py-2")>
            <Box className=%twc("w-6") />
          </div>
          <div className=%twc("h-full flex flex-col px-4 py-2")>
            <Box /> <Box className=%twc("w-2/3") />
          </div>
          <div className=%twc("h-full flex flex-col px-4 py-2")>
            <Box className=%twc("w-1/2") />
          </div>
          <div className=%twc("h-full flex flex-col px-4 py-2")> <Box /> <Box /> </div>
          <div className=%twc("h-full flex flex-col px-4 py-2")> <Box /> </div>
          <div className=%twc("h-full flex flex-col px-4 py-2")>
            <Box className=%twc("w-2/3") />
          </div>
        </li>
      }
    }
  }
}

@react.component
let make = (~settlement: CustomHooks.Settlements.settlement) => {
  <Item.Table settlement />
}
