external unsafeAsFile: Webapi.Blob.t => Webapi.File.t = "%identity"

module List = {
  @react.component
  let make = (~shipments: CustomHooks.Shipments.shipments) => {
    <>
      <div className=%twc("w-full overflow-x-scroll")>
        <div className=%twc("text-sm lg:min-w-max")>
          <div
            className=%twc("hidden lg:grid lg:grid-cols-8-seller bg-gray-100 text-gray-500 h-12")>
            <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
              {j`날짜`->React.string} <Tooltip_Shipment_Seller.Date />
            </div>
            <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
              {j`판로유형`->React.string} <Tooltip_Shipment_Seller.MarketType />
            </div>
            <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
              {j`작물·품종`->React.string}
            </div>
            <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
              {j`거래중량단위·포장규격`->React.string}
            </div>
            <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
              {j`등급`->React.string}
            </div>
            <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
              {j`총 수량`->React.string}
            </div>
            <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
              {j`총 금액`->React.string}
            </div>
            <div className=%twc("h-full px-4 flex items-center whitespace-nowrap")>
              {j`상세내역 조회`->React.string}
            </div>
          </div>
          <ol
            className=%twc(
              "divide-y divide-gray-300 lg:divide-gray-100 lg:list-height-seller lg:overflow-y-scroll"
            )>
            {shipments.data
            ->Array.map(shipment =>
              <Shipment_Seller key={UniqueId.make(~prefix="shipment", ())} shipment />
            )
            ->React.array}
          </ol>
        </div>
      </div>
      <div className=%twc("flex justify-center py-5")>
        <Pagination
          pageDisplySize=Constants.pageDisplySize itemPerPage=shipments.limit total=shipments.count
        />
      </div>
    </>
  }
}

module Shipments = {
  @react.component
  let make = () => {
    let router = Next.Router.useRouter()
    let queryParms =
      router.query->Webapi.Url.URLSearchParams.makeWithDict->Webapi.Url.URLSearchParams.toString
    let status = CustomHooks.Shipments.use(queryParms)

    let bodyOption =
      router.query->(
        dict =>
          [
            ("to", dict->Js.Dict.get("to")->Option.getWithDefault("")),
            ("from", dict->Js.Dict.get("from")->Option.getWithDefault("")),
            ("category-id", dict->Js.Dict.get("category-id")->Option.getWithDefault("")),
          ]->Js.Dict.fromArray
      )

    <>
      <div className=%twc("sm:px-10 md:px-20")>
        <Summary_Shimpment_Seller
          defaults={router.query->Summary_Shimpment_Seller.getProps} key={queryParms}
        />
        <div className=%twc("lg:px-7 mt-4 shadow-gl overflow-x-scroll")>
          {switch status {
          | Loading => <div> {j`로딩 중..`->React.string} </div>
          | Error(error) => <ErrorPanel error />
          | Loaded(data) =>
            switch data->CustomHooks.Shipments.shipments_decode {
            | Ok(shipments) => <>
                <div className=%twc("md:flex md:justify-between pb-4 text-base")>
                  <div
                    className=%twc(
                      "pt-10 px-5 lg:px-0 flex flex-col lg:flex-row sm:flex-auto sm:justify-between"
                    )>
                    <h3 className=%twc("font-bold")>
                      {j`내역`->React.string}
                      <span className=%twc("ml-1 text-green-gl font-normal")>
                        {j`${shipments.count->Int.toString}건`->React.string}
                      </span>
                    </h3>
                    <div className=%twc("flex flex-col lg:flex-row mt-4 lg:mt-0")>
                      <div className=%twc("flex items-center")>
                        <Select_CountPerPage className=%twc("mr-2") />
                      </div>
                      <div className=%twc("flex mt-2 lg:mt-0")>
                        <Excel_Download_Request_Button
                          userType=Seller requestUrl="/wholesale-market-order/excel" bodyOption
                        />
                      </div>
                    </div>
                  </div>
                </div>
                <List shipments />
              </>
            | Error(error) => {
                Js.log(error)
                React.null
              }
            }
          }}
        </div>
      </div>
    </>
  }
}

@react.component
let make = () => {
  let user = CustomHooks.User.Seller.use()

  <>
    <Next.Head> <title> {j`출하내역 조회 - 신선하이`->React.string} </title> </Next.Head>
    {switch user {
    | Unknown
    | NotLoggedIn =>
      <div> {j`인증 확인 중 입니다.`->React.string} </div>
    | LoggedIn(_) => <Shipments />
    }}
  </>
}
