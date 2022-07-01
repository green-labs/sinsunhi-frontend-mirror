module Header = {
  @react.component
  let make = (~checked=?, ~onChange=?, ~disabled=?) =>
    <div className=%twc("grid grid-cols-14-admin-cost bg-gray-100 text-gray-500 h-12")>
      <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
        <Checkbox id="check-all" ?checked ?onChange ?disabled />
      </div>
      <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
        {j`생산자명`->React.string}
      </div>
      <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
        {j`상품번호·단품번호`->React.string}
      </div>
      <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
        {j`상품명·단품명`->React.string}
      </div>
      <div className=%twc("h-full pr-4 flex items-center whitespace-nowrap")>
        {j`현재원매가시작일`->React.string}
      </div>
      <div
        className=%twc(
          "h-full px-4 justify-center flex items-center whitespace-nowrap text-center"
        )>
        {j`현재 총원가·원물원가·포장작업비·택배비`->React.string}
      </div>
      <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
        {j`바이어판매가`->React.string}
      </div>
      <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
        {j`원가타입`->React.string}
      </div>
      <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
        {j`변경원가시작일`->React.string}
      </div>
      <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
        {j`변경후 바이어판매가`->React.string}
      </div>
      <div className=%twc("h-full px-4 flex items-center whitespace-nowrap text-center")>
        {j`변경후 총원가`->React.string}
      </div>
      <div className=%twc("h-full pl-2 flex items-center whitespace-nowrap")>
        {j`변경후 원물원가`->React.string}
      </div>
      <div className=%twc("h-full flex items-center whitespace-nowrap")>
        {j`변경후 포장작업비`->React.string}
      </div>
      <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
        {j`변경후 택배비`->React.string}
      </div>
    </div>
}

module Loading = {
  @react.component
  let make = () =>
    <div className=%twc("w-full overflow-x-scroll")>
      <div className=%twc("min-w-max text-sm divide-y divide-gray-100")>
        <Header />
        <ol
          className=%twc(
            "divide-y divide-gray-100 lg:list-height-admin-buyer lg:overflow-y-scroll"
          )>
          {Garter.Array.make(5, 0)
          ->Garter.Array.map(_ => <Settlement_Admin.Item.Table.Loading />)
          ->React.array}
        </ol>
      </div>
    </div>
}

@react.component
let make = (
  ~status: CustomHooks.Costs.result,
  ~newCosts: Map.String.t<Cost_Admin.newCost>,
  ~onChangeEffectiveDate,
  ~onChangePrice,
  ~onChangeRawCost,
  ~onChangeDeliveryCost,
  ~onChangeWorkingCost,
  ~check,
  ~onCheckCost,
  ~onCheckAll,
  ~countOfChecked,
  ~onChangeContractType,
) => {
  switch status {
  | Error(error) => <ErrorPanel error renderOnRetry={<Loading />} />
  | Loading => <Loading />
  | Loaded(costs) =>
    let countOfCostsToCheck = {
      switch costs->CustomHooks.Costs.costs_decode {
      | Ok(costs') => costs'.data->Garter.Array.length
      | Error(_) => 0
      }
    }

    let isCheckAll = countOfCostsToCheck !== 0 && countOfCostsToCheck === countOfChecked

    let isDisabledCheckAll = switch status {
    | Loaded(costs) =>
      switch costs->CustomHooks.Costs.costs_decode {
      | Ok(costs') => costs'.data->Garter.Array.length == 0
      | Error(_) => true
      }
    | _ => true
    }

    <>
      <div className=%twc("w-full overflow-x-scroll")>
        <div className=%twc("min-w-max text-sm divide-y divide-gray-100")>
          <Header checked=isCheckAll onChange=onCheckAll disabled=isDisabledCheckAll />
          {switch costs->CustomHooks.Costs.costs_decode {
          | Ok(costs') =>
            <ol
              className=%twc(
                "divide-y divide-gray-100 lg:list-height-admin-buyer lg:overflow-y-scroll"
              )>
              {costs'.data->Garter.Array.length > 0
                ? costs'.data
                  ->Garter.Array.map(cost =>
                    newCosts
                    ->Map.String.get(cost.sku)
                    ->Option.mapWithDefault(React.null, newCost =>
                      <Cost_Admin
                        key=cost.sku
                        cost
                        newCost
                        check
                        onCheckCost
                        onChangeEffectiveDate={onChangeEffectiveDate(cost.sku)}
                        onChangePrice={onChangePrice(cost.sku)}
                        onChangeRawCost={onChangeRawCost(cost.sku)}
                        onChangeDeliveryCost={onChangeDeliveryCost(cost.sku)}
                        onChangeWorkingCost={onChangeWorkingCost(cost.sku)}
                        onChangeContractType={onChangeContractType(cost.sku)}
                      />
                    )
                  )
                  ->React.array
                : <EmptyOrders />}
            </ol>
          | Error(error) =>
            error->Js.Console.log
            React.null
          }}
        </div>
      </div>
      {switch status {
      | Loaded(costs) =>
        switch costs->CustomHooks.Costs.costs_decode {
        | Ok(costs') =>
          <div className=%twc("flex justify-center pt-5")>
            <Pagination
              pageDisplySize=Constants.pageDisplySize itemPerPage=costs'.limit total=costs'.count
            />
          </div>
        | Error(_) => React.null
        }
      | _ => React.null
      }}
    </>
  }
}
