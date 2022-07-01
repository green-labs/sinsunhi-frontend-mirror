let formatDate = d => d->Js.Date.fromString->Locale.DateTime.formatFromUTC("yyyy/MM/dd")

type newCost = {
  rawCost: option<string>,
  workingCost: option<string>,
  deliveryCost: option<string>,
  effectiveDate: option<Js.Date.t>,
  price: option<string>,
  contractType: CustomHooks.Costs.contractType,
  producerName: string,
  productName: string,
  optionName: string,
  producerId: int,
  productId: int,
  sku: string,
}

module Item = {
  module Table = {
    @react.component
    let make = (
      ~cost: CustomHooks.Costs.cost,
      ~newCost: newCost,
      ~check,
      ~onCheckCost,
      ~onChangePrice,
      ~onChangeDeliveryCost,
      ~onChangeWorkingCost,
      ~onChangeEffectiveDate,
      ~onChangeRawCost,
      ~onChangeContractType,
    ) => {
      let handleOnChange = (fn, e) => {
        let newData = (e->ReactEvent.Synthetic.target)["value"]
        newData->fn
      }

      let handleOnChangeDate = (fn, e) => {
        let newDate = (e->ReactEvent.Synthetic.target)["valueAsDate"]
        // valueAsDate 는 yyyy-MM-dd 09:00:00 (오전 9시)가 기본값이다.
        // yyyy-MM-dd 00:00:00 으로 맞춰서 보내야 해당 날짜 00시 부터 원가가 적용된다.
        newDate->DateFns.startOfDay->fn
      }

      let handleOnChangeType = e => {
        let newType = (e->ReactEvent.Synthetic.target)["value"]

        switch newType->CustomHooks.Costs.contractType_decode {
        | Ok(t) => t->onChangeContractType
        | Error(_) => ()
        }
      }

      <li className=%twc("grid grid-cols-14-admin-cost text-gray-700")>
        <div className=%twc("h-full flex flex-col px-4 py-2")>
          <Checkbox
            id={`checkbox-${cost.sku}`} checked={check(cost.sku)} onChange={onCheckCost(cost.sku)}
          />
        </div>
        <div className=%twc("h-full flex flex-col px-4 py-2")>
          <span className=%twc("block mb-1")> {cost.producerName->React.string} </span>
        </div>
        <div className=%twc("h-full flex flex-col px-4 py-2")>
          <span className=%twc("block text-gray-400")>
            {cost.productId->Int.toString->React.string}
          </span>
          <span className=%twc("block")> {cost.sku->React.string} </span>
        </div>
        <div className=%twc("h-full flex flex-col px-4 py-2")>
          <span className=%twc("whitespace-nowrap")> {cost.productName->React.string} </span>
          <span className=%twc("whitespace-nowrap")> {cost.optionName->React.string} </span>
        </div>
        <div className=%twc("h-full flex flex-col px-4 py-2")>
          <span className=%twc("block")> {cost.effectiveDate->formatDate->React.string} </span>
        </div>
        <div className=%twc("h-full flex flex-col px-4 py-2")>
          <span className=%twc("whitespace-nowrap text-center")>
            {cost.cost
            ->Option.mapWithDefault("- / ", cost => `${cost->Locale.Float.show(~digits=0)}원 / `)
            ->React.string}
            {cost.rawCost
            ->Option.mapWithDefault("- / ", cost => `${cost->Locale.Float.show(~digits=0)}원 / `)
            ->React.string}
            {cost.workingCost
            ->Option.mapWithDefault("- / ", cost => `${cost->Locale.Float.show(~digits=0)}원 / `)
            ->React.string}
            {cost.deliveryCost
            ->Option.mapWithDefault("-", cost => `${cost->Locale.Float.show(~digits=0)}원`)
            ->React.string}
          </span>
        </div>
        <div className=%twc("h-full flex flex-col pl-8 pr-4 py-2")>
          <span className=%twc("block")>
            {`${cost.price->Locale.Float.show(~digits=0)}원`->React.string}
          </span>
        </div>
        <div className=%twc("h-full flex flex-col px-4 py-2 relative")>
          <Select_ContractType_Admin
            contractType={newCost.contractType} onChange=handleOnChangeType
          />
        </div>
        <div className=%twc("h-full flex flex-col px-4 py-2")>
          <Input
            name="new-effective-date"
            type_="date"
            size=Input.Small
            value={newCost.effectiveDate->Option.mapWithDefault("", d =>
              d->DateFns.format("yyyy-MM-dd")
            )}
            onChange={handleOnChangeDate(onChangeEffectiveDate)}
            error=None
            min="2021-01-01"
          />
        </div>
        <div className=%twc("p-2 px-4 ml-2 align-top")>
          <Input
            type_="number"
            size=Input.Small
            name="new-cost"
            placeholder=`바이어판매가 입력`
            value={newCost.price->Option.getWithDefault("")}
            onChange={handleOnChange(onChangePrice)}
            error=None
          />
        </div>
        <div className=%twc("p-2 pr-4 align-top")>
          <div
            className=%twc(
              "bg-disabled-L3 border border-disabled-L1 text-sm rounded-lg h-8 items-center flex px-3"
            )>
            <span className=%twc("block")>
              {(Option.flatMap(newCost.rawCost, Float.fromString)->Option.getWithDefault(0.) +.
              Option.flatMap(newCost.deliveryCost, Float.fromString)->Option.getWithDefault(0.) +.
              Option.flatMap(newCost.workingCost, Float.fromString)->Option.getWithDefault(0.))
              ->Locale.Float.show(~digits=0)
              ->React.string}
            </span>
          </div>
        </div>
        <div className=%twc("p-2 pr-4 align-top")>
          <Input
            type_="number"
            size=Input.Small
            name="new-cost"
            placeholder=`원물원가 입력`
            value={newCost.rawCost->Option.getWithDefault("")}
            onChange={handleOnChange(onChangeRawCost)}
            error=None
          />
        </div>
        <div className=%twc("p-2 pr-4 align-top")>
          <Input
            type_="number"
            size=Input.Small
            name="new-cost"
            placeholder=`포장작업비 입력`
            value={newCost.workingCost->Option.getWithDefault("")}
            onChange={handleOnChange(onChangeWorkingCost)}
            error=None
          />
        </div>
        <div className=%twc("p-2 pr-4 align-top")>
          <Input
            type_="number"
            size=Input.Small
            name="new-cost"
            placeholder=`택배비 입력`
            value={newCost.deliveryCost->Option.getWithDefault("")}
            onChange={handleOnChange(onChangeDeliveryCost)}
            error=None
          />
        </div>
      </li>
    }

    module Loading = {
      open Skeleton

      @react.component
      let make = () => {
        <li className=%twc("grid grid-cols-14-admin-cost text-gray-700")>
          <div className=%twc("h-full flex flex-col px-4 py-2")>
            <Box className=%twc("w-6") />
          </div>
          <div className=%twc("h-full flex flex-col px-4 py-2")>
            <Box className=%twc("w-2/3") />
          </div>
          <div className=%twc("h-full flex flex-col px-4 py-2")>
            <Box className=%twc("w-1/2") /> <Box className=%twc("w-2/3") />
          </div>
          <div className=%twc("h-full flex flex-col px-4 py-2")> <Box /> </div>
          <div className=%twc("h-full flex flex-col px-4 py-2")> <Box /> </div>
          <div className=%twc("h-full flex flex-col px-4 py-2")> <Box /> </div>
          <div className=%twc("h-full flex flex-col px-4 py-2")> <Box /> </div>
          <div className=%twc("p-2 pr-4 align-top")> <Box /> </div>
        </li>
      }
    }
  }
}

@react.component
let make = (
  ~cost: CustomHooks.Costs.cost,
  ~newCost: newCost,
  ~check,
  ~onCheckCost,
  ~onChangeEffectiveDate,
  ~onChangePrice,
  ~onChangeRawCost,
  ~onChangeDeliveryCost,
  ~onChangeWorkingCost,
  ~onChangeContractType,
) => {
  <Item.Table
    cost
    newCost
    check
    onCheckCost
    onChangeEffectiveDate
    onChangePrice
    onChangeRawCost
    onChangeDeliveryCost
    onChangeWorkingCost
    onChangeContractType
  />
}
