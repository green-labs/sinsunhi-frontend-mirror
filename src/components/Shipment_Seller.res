let formatDate = d => d->Js.Date.fromString->DateFns.format("yyyy-MM-dd")
let displayKind = (kind: CustomHooks.Shipments.marketType) =>
  switch kind {
  | ONLINE => `온라인 택배`
  | WHOLESALE => `도매출하`
  | OFFLINE => `오프라인`
  }

module Item = {
  module Table = {
    @react.component
    let make = (~shipment: CustomHooks.Shipments.shipment) => {
      <>
        <li className=%twc("hidden lg:grid lg:grid-cols-8-seller text-gray-700")>
          <div className=%twc("h-full flex flex-col px-4 py-3 whitespace-nowrap justify-center")>
            <div> {shipment.date->formatDate->React.string} </div>
          </div>
          <div className=%twc("h-full flex flex-col px-4 py-3 whitespace-nowrap justify-center")>
            <div>
              <span className=%twc("px-2 py-0.5 rounded bg-green-gl-light text-green-gl")>
                {shipment.marketType->displayKind->React.string}
              </span>
            </div>
          </div>
          <div className=%twc("h-full flex flex-col px-4 py-3 whitespace-nowrap justify-center")>
            <div> {shipment.crop->React.string} </div>
            <div className=%twc("text-gray-gl")> {shipment.cultivar->React.string} </div>
          </div>
          <div className=%twc("h-full flex flex-col px-4 py-3 whitespace-nowrap justify-center")>
            <div>
              {Helper.Option.map2(shipment.weight, shipment.weightUnit, (w, wu) =>
                `${w->Float.toString}${wu
                  ->CustomHooks.Products.weightUnit_encode
                  ->Js.Json.decodeString
                  ->Option.getWithDefault("g")}`
              )
              ->Option.getWithDefault("")
              ->React.string}
            </div>
            <div className=%twc("text-gray-gl")>
              {shipment.packageType->Option.getWithDefault("")->React.string}
            </div>
          </div>
          <div className=%twc("h-full flex flex-col px-4 py-3 whitespace-nowrap justify-center")>
            <div> {shipment.grade->Option.getWithDefault("")->React.string} </div>
          </div>
          <div
            className=%twc("h-full flex flex-col px-4 py-3 whitespace-nowrap justify-center ml-4")>
            {shipment.totalQuantity->Float.toString->React.string}
          </div>
          <div className=%twc("h-full flex flex-col px-4 py-3 whitespace-nowrap justify-center")>
            {j`${shipment.totalPrice->Locale.Float.show(~digits=0)}원`->React.string}
          </div>
          <div className=%twc("h-full flex flex-col px-4 py-3 whitespace-nowrap justify-center")>
            {switch shipment.marketType {
            | WHOLESALE =>
              <Shipment_Detail_Button_Seller
                date={shipment.date->Js.Date.fromString->DateFns.format("yyyy-MM-dd")}
                sku=shipment.sku
              />
            | ONLINE => React.null
            | OFFLINE => React.null
            }}
          </div>
        </li>
      </>
    }
  }

  module Card = {
    @react.component
    let make = (~shipment: CustomHooks.Shipments.shipment) => {
      <>
        <li className=%twc("py-7 px-5 lg:hidden text-black-gl")>
          <section className=%twc("flex items-start justify-between text-base")>
            <div className=%twc("font-bold mr-1")> {shipment.date->formatDate->React.string} </div>
            <div className=%twc("px-2 py-0.5 rounded bg-green-gl-light text-green-gl")>
              {shipment.marketType->displayKind->React.string}
            </div>
          </section>
          <section className=%twc("divide-y divide-gray-100")>
            <div className=%twc("py-3")>
              <div className=%twc("flex")>
                <span className=%twc("w-20 text-gray-gl")> {j`작물·품종`->React.string} </span>
                <span className=%twc("ml-2")>
                  {j`${shipment.crop}·${shipment.cultivar}`->React.string}
                </span>
              </div>
              <div className=%twc("flex mt-2")>
                <span className=%twc("w-20 text-gray-gl")>
                  {j`거래중량단위·포장규격`->React.string}
                </span>
                <span className=%twc("ml-2")>
                  {j`${shipment.weight->Option.mapWithDefault(
                      "",
                      Float.toString,
                    )}·${shipment.packageType->Option.getWithDefault("")}`->React.string}
                </span>
              </div>
              <div className=%twc("flex mt-2")>
                <span className=%twc("w-20 text-gray-gl")> {j`등급`->React.string} </span>
                <span className=%twc("ml-2")>
                  {shipment.grade->Option.getWithDefault("")->React.string}
                </span>
              </div>
            </div>
            <div className=%twc("py-3")>
              <div className=%twc("flex")>
                <span className=%twc("w-20 text-gray-gl")> {j`총 수량`->React.string} </span>
                <span className=%twc("ml-2")>
                  {shipment.totalQuantity->Float.toString->React.string}
                </span>
              </div>
              <div className=%twc("flex mt-2")>
                <span className=%twc("w-20 text-gray-gl")> {j`총 금액`->React.string} </span>
                <span className=%twc("ml-2")>
                  {j`${shipment.totalPrice->Locale.Float.show(~digits=0)}원`->React.string}
                </span>
              </div>
            </div>
          </section>
        </li>
      </>
    }
  }
}

@react.component
let make = (~shipment: CustomHooks.Shipments.shipment) => {
  <> <Item.Table shipment /> <Item.Card shipment /> </>
}
