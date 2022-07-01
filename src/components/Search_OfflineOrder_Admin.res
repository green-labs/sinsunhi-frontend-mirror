module FormFields = Query_OfflineOrder_Form_Admin.FormFields
module Form = Query_OfflineOrder_Form_Admin.Form
module Select_Crop_Std = Select_Crop_Search_Std

type query = {
  from: Js.Date.t,
  to_: Js.Date.t,
}
type target = From | To

type defaults = {
  seller: option<string>,
  buyer: option<string>,
  orderFrom: option<string>,
  orderTo: option<string>,
  shipmentFrom: option<string>,
  shipmentTo: option<string>,
  std: option<string>,
  categoryId: option<string>,
  label: option<string>,
}

let getDefaults = (dict: Js.Dict.t<string>) => {
  seller: dict->Js.Dict.get("producer-name"),
  buyer: dict->Js.Dict.get("buyer-name"),
  orderFrom: dict->Js.Dict.get("created-at-from"),
  orderTo: dict->Js.Dict.get("created-at-to"),
  shipmentFrom: dict->Js.Dict.get("release-due-date-from"),
  shipmentTo: dict->Js.Dict.get("release-due-date-to"),
  std: dict->Js.Dict.get("std"),
  categoryId: dict->Js.Dict.get("category-id"),
  label: dict->Js.Dict.get("label"),
}

@react.component
let make = (~defaults: defaults) => {
  let router = Next.Router.useRouter()

  let (selectedCrop, setSelectedCrop) = React.Uncurried.useState(_ =>
    Helper.Option.map2(defaults.categoryId, defaults.label, (v, l) => ReactSelect.Selected({
      value: v,
      label: l,
    }))->Option.getWithDefault(ReactSelect.NotSelected)
  )

  let (orderQuery, setOrderQuery) = React.Uncurried.useState(_ => {
    from: defaults.orderFrom->Option.mapWithDefault(Js.Date.make()->DateFns.setDate(1), d =>
      d->DateFns.parse("yyyy-MM-dd", Js.Date.make())
    ),
    to_: defaults.orderTo->Option.mapWithDefault(Js.Date.make(), d =>
      d->DateFns.parse("yyyy-MM-dd", Js.Date.make())
    ),
  })

  let (shipmentQuery, setShipmentQuery) = React.Uncurried.useState(_ => {
    from: defaults.shipmentFrom->Option.mapWithDefault(Js.Date.make()->DateFns.setDate(1), d =>
      d->DateFns.parse("yyyy-MM-dd", Js.Date.make())
    ),
    to_: defaults.shipmentTo->Option.mapWithDefault(Js.Date.make(), d =>
      d->DateFns.parse("yyyy-MM-dd", Js.Date.make())
    ),
  })

  let onSubmit = ({state}: Form.onSubmitAPI) => {
    let sellerName = state.values->FormFields.get(FormFields.SellerName)
    let buyerName = state.values->FormFields.get(FormFields.BuyerName)
    let std = state.values->FormFields.get(FormFields.Std)

    let {makeWithDict, toString} = module(Webapi.Url.URLSearchParams)

    router.query->Js.Dict.set("producer-name", sellerName)
    router.query->Js.Dict.set("buyer-name", buyerName)
    router.query->Js.Dict.set("std", std)
    router.query->Js.Dict.set("created-at-from", orderQuery.from->DateFns.format("yyyy-MM-dd"))
    router.query->Js.Dict.set("created-at-to", orderQuery.to_->DateFns.format("yyyy-MM-dd"))
    router.query->Js.Dict.set(
      "release-due-date-from",
      shipmentQuery.from->DateFns.format("yyyy-MM-dd"),
    )
    router.query->Js.Dict.set(
      "release-due-date-to",
      shipmentQuery.to_->DateFns.format("yyyy-MM-dd"),
    )

    let (categoryId, label) =
      selectedCrop->ReactSelect.toOption->Option.mapWithDefault(("", ""), v => (v.value, v.label))
    router.query->Js.Dict.set("category-id", categoryId)
    router.query->Js.Dict.set("label", label)

    router->Next.Router.push(`${router.pathname}?${router.query->makeWithDict->toString}`)

    None
  }

  let form: Form.api = Form.use(
    ~validationStrategy=Form.OnChange,
    ~onSubmit,
    ~initialState={
      sellerName: defaults.seller->Option.getWithDefault(""),
      buyerName: defaults.buyer->Option.getWithDefault(""),
      std: defaults.categoryId->Option.getWithDefault("Crop"),
    },
    ~schema={
      open Form.Validation
      Schema(
        [
          regExp(
            SellerName,
            ~matches="^(?:.{2,}|)$",
            ~error=`최소 2글자를 입력해주세요.`,
          ),
          regExp(
            BuyerName,
            ~matches="^(?:.{2,}|)$",
            ~error=`최소 2글자를 입력해주세요.`,
          ),
        ]->Array.concatMany,
      )
    },
    (),
  )

  let handleOnSubmit = (
    _ => {
      form.submit()
    }
  )->ReactEvents.interceptingHandler

  let handleOnChangeCropOrCultivar = e => {
    FormFields.Std->form.handleChange->ReForm.Helpers.handleChange(e)
    setSelectedCrop(._ => ReactSelect.NotSelected)
  }

  let handleOnChangeOrderPeriod = (f, t) => {
    setOrderQuery(._ => {from: f, to_: t})
  }

  let handleOnChangeOrderDate = (t, e) => {
    let newDate = (e->DuetDatePicker.DuetOnChangeEvent.detail).valueAsDate
    switch (t, newDate) {
    | (From, Some(newDate')) => setOrderQuery(.prev => {...prev, from: newDate'})
    | (To, Some(newDate')) => setOrderQuery(.prev => {...prev, to_: newDate'})
    | _ => ()
    }
  }

  let handleOnChangeShipmentPeriod = (f, t) => {
    setShipmentQuery(._ => {from: f, to_: t})
  }

  let handleOnChangeShipmentDate = (t, e) => {
    let newDate = (e->DuetDatePicker.DuetOnChangeEvent.detail).valueAsDate
    switch (t, newDate) {
    | (From, Some(newDate')) => setShipmentQuery(.prev => {...prev, from: newDate'})
    | (To, Some(newDate')) => setShipmentQuery(.prev => {...prev, to_: newDate'})
    | _ => ()
    }
  }

  let handleOnReset = (
    _ => {
      FormFields.SellerName->form.setFieldValue("", ~shouldValidate=false, ())
      FormFields.BuyerName->form.setFieldValue("", ~shouldValidate=false, ())
      FormFields.Std->form.setFieldValue("Crop", ~shouldValidate=false, ())

      let m_from = Js.Date.make()->DateFns.setDate(1)
      let m_to = Js.Date.make()->DateFns.endOfMonth
      setOrderQuery(._ => {from: m_from, to_: m_to})
      setShipmentQuery(._ => {from: m_from, to_: m_to})
      setSelectedCrop(._ => ReactSelect.NotSelected)
    }
  )->ReactEvents.interceptingHandler

  let handleChangeCrop = selection => {
    setSelectedCrop(._ => selection)
  }

  <div className=%twc("flex flex-col bg-white mt-5 p-7")>
    <h2 className=%twc("font-bold text-lg")> {j`조건 검색`->React.string} </h2>
    <form onSubmit={handleOnSubmit}>
      <div className=%twc("mt-6 bg-div-shape-L2 p-7 rounded-lg text-sm")>
        <div className=%twc("flex")>
          <div className=%twc("w-32 font-bold whitespace-nowrap")> {j`검색`->React.string} </div>
          <div className=%twc("flex-1")>
            <div className=%twc("flex")>
              <div
                className=%twc(
                  "flex flex-col sm:flex-initial sm:w-64 sm:flex-row sm:items-center mr-16"
                )>
                <label htmlFor="seller-name" className=%twc("whitespace-nowrap mr-2")>
                  {j`생산자명`->React.string}
                </label>
                <span className=%twc("w-48")>
                  <Input
                    type_="text"
                    name="seller-name"
                    placeholder=`생산자명`
                    value={form.values->FormFields.get(FormFields.SellerName)}
                    onChange={FormFields.SellerName->form.handleChange->ReForm.Helpers.handleChange}
                    error={FormFields.SellerName->Form.ReSchema.Field->form.getFieldError}
                    tabIndex=1
                  />
                </span>
              </div>
              <div
                className=%twc(
                  "flex flex-col sm:flex-initial sm:w-64 sm:flex-row sm:items-center mr-16"
                )>
                <label htmlFor="buyer-name" className=%twc("whitespace-nowrap mr-2")>
                  {j`바이어명`->React.string}
                </label>
                <span className=%twc("w-48")>
                  <Input
                    type_="text"
                    name="buyer-name"
                    placeholder=`바이어명`
                    value={form.values->FormFields.get(FormFields.BuyerName)}
                    onChange={FormFields.BuyerName->form.handleChange->ReForm.Helpers.handleChange}
                    error={FormFields.BuyerName->Form.ReSchema.Field->form.getFieldError}
                    tabIndex=2
                  />
                </span>
              </div>
            </div>
            <div className=%twc("mt-2 flex flex-col sm:flex-row items-start")>
              <div className=%twc("w-64 flex items-center")>
                <label htmlFor="crop-kind" className=%twc("whitespace-nowrap mr-2")>
                  {j`작물품종`->React.string}
                </label>
                <Select_Crop_Search_Std
                  std={form.values
                  ->FormFields.get(FormFields.Std)
                  ->Select_Crop_Std.decodeStd
                  ->Option.getWithDefault(#Crop)}
                  onChange=handleOnChangeCropOrCultivar
                />
              </div>
              <div className=%twc("relative")>
                <div className=%twc("absolute w-96")>
                  <Search_Crop_Cultivar
                    type_={form.values
                    ->FormFields.get(FormFields.Std)
                    ->Select_Crop_Search_Std.decodeStd
                    ->Option.getWithDefault(#Crop)}
                    value=selectedCrop
                    onChange=handleChangeCrop
                  />
                </div>
              </div>
            </div>
          </div>
        </div>
        <div className=%twc("flex mt-4")>
          <div className=%twc("flex items-center")>
            <div className=%twc("w-32 font-bold whitespace-nowrap ")>
              {j`주문일`->React.string}
            </div>
          </div>
          <div className=%twc("flex mr-2")>
            <PeriodSelector_OfflineOrders
              from={orderQuery.from} to_={orderQuery.to_} onSelect=handleOnChangeOrderPeriod
            />
          </div>
          <DatePicker
            id="order-from"
            date={orderQuery.from}
            onChange={handleOnChangeOrderDate(From)}
            maxDate={orderQuery.to_->DateFns.format("yyyy-MM-dd")}
            firstDayOfWeek=0
          />
          <span className=%twc("flex items-center mr-1")> {j`~`->React.string} </span>
          <DatePicker
            id="order-to"
            date={orderQuery.to_}
            onChange={handleOnChangeOrderDate(To)}
            minDate={orderQuery.from->DateFns.format("yyyy-MM-dd")}
            firstDayOfWeek=0
          />
        </div>
        <div className=%twc("flex mt-2 ")>
          <div className=%twc("flex items-center")>
            <div className=%twc("w-32 font-bold whitespace-nowrap")>
              {j`출고예정일`->React.string}
            </div>
          </div>
          <div className=%twc("flex mr-2")>
            <PeriodSelector_OfflineOrders
              from={shipmentQuery.from}
              to_={shipmentQuery.to_}
              onSelect=handleOnChangeShipmentPeriod
            />
          </div>
          <DatePicker
            id="from"
            date={shipmentQuery.from}
            onChange={handleOnChangeShipmentDate(From)}
            maxDate={shipmentQuery.to_->DateFns.format("yyyy-MM-dd")}
            firstDayOfWeek=0
          />
          <span className=%twc("flex items-center mr-1")> {j`~`->React.string} </span>
          <DatePicker
            id="to"
            date={shipmentQuery.to_}
            onChange={handleOnChangeShipmentDate(To)}
            minDate={shipmentQuery.from->DateFns.format("yyyy-MM-dd")}
            firstDayOfWeek=0
          />
        </div>
      </div>
      <div className=%twc("flex justify-center mt-5")>
        <span className=%twc("w-20 h-11 flex mr-2")>
          <input
            type_="button"
            className=%twc("btn-level6")
            value=`초기화`
            onClick={handleOnReset}
            tabIndex=7
          />
        </span>
        <span className=%twc("w-20 h-11 flex")>
          <input type_="submit" className=%twc("btn-level1") value=`검색` tabIndex=8 />
        </span>
      </div>
    </form>
  </div>
}
