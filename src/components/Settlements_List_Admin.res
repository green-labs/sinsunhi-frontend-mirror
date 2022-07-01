module Header = {
  @react.component
  let make = () =>
    <div className=%twc("grid grid-cols-6-admin-settlement bg-gray-100 text-gray-500 h-12")>
      <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
        {j``->React.string}
      </div>
      <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
        {j`생산자번호·명`->React.string}
      </div>
      <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
        {j`정산주기`->React.string}
      </div>
      <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
        {j`송장등록기준·가송장제외`->React.string}
      </div>
      <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
        {j`배송완료기준`->React.string}
      </div>
      <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
        {j`세액`->React.string}
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
  ~status: CustomHooks.Settlements.result,
  ~producerCodeToDownload,
  ~onCheckSettlement,
) => {
  switch status {
  | Error(error) => <ErrorPanel error renderOnRetry={<Loading />} />
  | Loading => <Loading />
  | Loaded(settlements) => <>
      <div className=%twc("w-full overflow-x-scroll")>
        <div className=%twc("min-w-max text-sm divide-y divide-gray-100")>
          <Header />
          {switch settlements->CustomHooks.Settlements.settlements_decode {
          | Ok(settlements') =>
            <ol className=%twc("lg:list-height-admin-buyer lg:overflow-y-scroll")>
              {settlements'.data->Garter.Array.length > 0
                ? <RadixUI.RadioGroup.Root
                    name="producer-code"
                    value={producerCodeToDownload->Option.getWithDefault("")}
                    className={"divide-y divide-gray-100"}
                    onValueChange=onCheckSettlement>
                    {settlements'.data
                    ->Garter.Array.map(settlement =>
                      <Settlement_Admin key=settlement.producerCode settlement />
                    )
                    ->React.array}
                  </RadixUI.RadioGroup.Root>
                : <EmptyOrders />}
            </ol>
          | Error(error) =>
            error->Js.Console.log
            React.null
          }}
        </div>
      </div>
      {switch status {
      | Loaded(settlements) =>
        switch settlements->CustomHooks.Settlements.settlements_decode {
        | Ok(settlements') =>
          <div className=%twc("flex justify-center pt-5")>
            <Pagination
              pageDisplySize=Constants.pageDisplySize
              itemPerPage=settlements'.limit
              total=settlements'.count
            />
          </div>
        | Error(_) => React.null
        }
      | _ => React.null
      }}
    </>
  }
}
