module StatusBoard = {
  @react.component
  let make = () => {
    let router = Next.Router.useRouter()
    let status = CustomHooks.ShipmentSummary.use(
      [
        ("to", router.query->Js.Dict.get("to")->Option.getWithDefault("")),
        ("from", router.query->Js.Dict.get("from")->Option.getWithDefault("")),
      ]
      ->Js.Dict.fromArray
      ->Webapi.Url.URLSearchParams.makeWithDict
      ->Webapi.Url.URLSearchParams.toString,
    )
    let montly = CustomHooks.ShipmentMontlyAmount.use()

    let firstDayOfMonth = Js.Date.make()->DateFns.setDate(1)->DateFns.format("yyyy-MM-dd")
    let today = Js.Date.make()->DateFns.format("yyyy-MM-dd")

    <div className=%twc("py-4 lg:px-5 flex flex-wrap")>
      {switch status {
      | Loading => React.null
      | Error(_) => React.null
      | Loaded(data) =>
        switch data->CustomHooks.ShipmentSummary.response_decode {
        | Ok(response) =>
          <div className=%twc("mr-20 w-full sm:w-auto")>
            <div className=%twc("text-sm text-gray-800")>
              {j`누적출하`->React.string}
              <span className=%twc("text-gray-gl")> {j`(검색기간 내)`->React.string} </span>
            </div>
            <div className=%twc("font-bold")>
              {j`${response.price->Locale.Float.show(~digits=0)} 원`->React.string}
            </div>
          </div>

        | Error(error) => {
            Js.log(error)
            React.null
          }
        }
      }}
      <span
        className=%twc("border-gray-200 border-t my-3 w-full sm:w-auto sm:mr-5 sm:my-2 sm:border-r")
      />
      {switch montly {
      | Loading => React.null
      | Error(_) => React.null
      | Loaded(data) =>
        switch data->CustomHooks.ShipmentMontlyAmount.response_decode {
        | Ok(response) =>
          <div className=%twc("flex-1")>
            <div className=%twc("text-sm text-gray-800")>
              {j`${Js.Date.make()->DateFns.format("MM")}월 출하`->React.string}
              <span className=%twc("text-gray-gl")>
                {j`(${firstDayOfMonth}~${today})`->React.string}
              </span>
            </div>
            <div className=%twc("font-bold")>
              {j`${response.price->Locale.Float.show(~digits=0)} 원`->React.string}
            </div>
          </div>

        | Error(error) =>
          Js.log(error)
          React.null
        }
      }}
    </div>
  }
}

module FormFields = Query_Shipment_Form_Seller.FormFields
module Form = Query_Shipment_Form_Seller.Form
module Select_Crop_Std = Select_Crop_Search_Std

type query = {
  from: Js.Date.t,
  to_: Js.Date.t,
}
type target = From | To

type defaults = {
  std: option<string>,
  market: option<string>,
  from: option<string>,
  to_: option<string>,
  crop: option<string>,
  label: option<string>,
}

let getProps = (queryParms): defaults => {
  std: queryParms->Js.Dict.get("crop-search-std"),
  market: queryParms->Js.Dict.get("market-type"),
  from: queryParms->Js.Dict.get("from"),
  to_: queryParms->Js.Dict.get("to"),
  crop: queryParms->Js.Dict.get("category-id"),
  label: queryParms->Js.Dict.get("label"),
}

@react.component
let make = (~defaults: defaults) => {
  let router = Next.Router.useRouter()

  let (selectedCrop, setSelectedCrop) = React.Uncurried.useState(_ =>
    Helper.Option.map2(defaults.crop, defaults.label, (v, l) => {
      if v == "" || l == "" {
        ReactSelect.NotSelected
      } else {
        ReactSelect.Selected({value: v, label: l})
      }
    })->Option.getWithDefault(ReactSelect.NotSelected)
  )

  let (query, setQuery) = React.Uncurried.useState(_ => {
    from: defaults.from->Option.mapWithDefault(Js.Date.make()->DateFns.subDays(7), f =>
      f->DateFns.parse("yyyy-MM-dd", Js.Date.make())
    ),
    to_: defaults.to_->Option.mapWithDefault(Js.Date.make(), t =>
      t->DateFns.parse("yyyy-MM-dd", Js.Date.make())
    ),
  })

  let onSubmit = ({state}: Form.onSubmitAPI) => {
    let market = state.values->FormFields.get(FormFields.Market)
    let std = state.values->FormFields.get(FormFields.Std)

    let {makeWithDict, toString} = module(Webapi.Url.URLSearchParams)

    router.query->Js.Dict.set("crop-search-std", std)
    router.query->Js.Dict.set("market-type", market)
    router.query->Js.Dict.set("from", query.from->DateFns.format("yyyy-MM-dd"))
    router.query->Js.Dict.set("to", query.to_->DateFns.format("yyyy-MM-dd"))

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
      market: defaults.market->Option.getWithDefault(""),
      std: defaults.std->Option.getWithDefault(`Crop`),
    },
    ~schema={
      open Form.Validation
      Schema([]->Array.concatMany)
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

  let handleChangeCrop = selection => {
    setSelectedCrop(._ => selection)
  }

  let handleOnChangeDate = (t, e) => {
    let newDate = (e->DuetDatePicker.DuetOnChangeEvent.detail).valueAsDate
    switch (t, newDate) {
    | (From, Some(newDate')) => setQuery(.prev => {...prev, from: newDate'})
    | (To, Some(newDate')) => setQuery(.prev => {...prev, to_: newDate'})
    | _ => ()
    }
  }

  let handleOnChangePeriod = d => {
    setQuery(.prev => {...prev, from: d})
  }

  let handleOnReset = (
    _ => {
      FormFields.Market->form.setFieldValue("", ~shouldValidate=false, ())
      FormFields.Std->form.setFieldValue("Crop", ~shouldValidate=false, ())
      setQuery(._ => {from: Js.Date.make()->DateFns.subDays(7), to_: Js.Date.make()})
      setSelectedCrop(._ => ReactSelect.NotSelected)
    }
  )->ReactEvents.interceptingHandler

  <div className=%twc("py-3 px-4 pb-7 shadow-gl sm:mt-4")>
    <h3 className=%twc("py-4 lg:px-5 font-bold text-xl whitespace-nowrap")>
      {j`출하내역`->React.string}
    </h3>
    <StatusBoard />
    <form className=%twc("lg:px-4 mt-7") onSubmit={handleOnSubmit}>
      <div className=%twc("py-3 flex flex-col text-sm bg-gray-gl rounded-xl")>
        <div className=%twc("flex flex-col lg:flex-row")>
          <div className=%twc("w-32 font-bold pl-3 whitespace-nowrap lg:pl-7 lg:pt-3")>
            {j`검색`->React.string}
          </div>
          <div className=%twc("flex-1 px-3 lg:px-0")>
            <div className=%twc("flex mt-2 w-full flex-wrap sm:flex-nowrap sm:w-auto")>
              <div
                className=%twc(
                  "flex flex-col justify-between w-full sm:w-64 sm:flex-initial sm:flex-row sm:items-center mr-2"
                )>
                <label htmlFor="crop-kind" className=%twc("whitespace-nowrap mr-7")>
                  {j`작물품종`->React.string}
                </label>
                <Select_Crop_Search_Std
                  std={form.values
                  ->FormFields.get(FormFields.Std)
                  ->Select_Crop_Std.decodeStd
                  ->Option.getWithDefault(#Crop)}
                  onChange={handleOnChangeCropOrCultivar}
                />
              </div>
              <div className=%twc("relative w-full mt-2 sm:mt-0")>
                <div className=%twc("sm:absolute sm:w-96")>
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
            <div className=%twc("flex mt-5 w-full sm:w-auto sm:mt-3")>
              <div
                className=%twc(
                  "flex flex-col justify-between w-full sm:w-64 sm:flex-initial sm:flex-row sm:items-center sm:mr-16"
                )>
                <label htmlFor="order-product-no" className=%twc("whitespace-nowrap mr-2")>
                  {j`판로유형`->React.string}
                </label>
                <Select_Market
                  market={form.values
                  ->FormFields.get(FormFields.Market)
                  ->Select_Market.decodeMarket}
                  onChange={FormFields.Market->form.handleChange->ReForm.Helpers.handleChange}
                />
              </div>
            </div>
          </div>
        </div>
        <div className=%twc("flex flex-col lg:flex-row mt-4 mb-2")>
          <div className=%twc("w-32 font-bold pl-3 whitespace-nowrap lg:pl-7 lg:pt-3")>
            {j`기간`->React.string}
          </div>
          <div className=%twc("flex flex-col px-3 sm:flex-row lg:px-0")>
            <div className=%twc("flex mb-2 sm:mb-0 sm:mr-8")>
              <PeriodSelector from=query.from to_=query.to_ onSelect={handleOnChangePeriod} />
            </div>
            <div className=%twc("flex")>
              <DatePicker
                id="from"
                date={query.from}
                onChange={handleOnChangeDate(From)}
                minDate={"2021-01-01"}
                maxDate={Js.Date.make()->DateFns.format("yyyy-MM-dd")}
                firstDayOfWeek=0
              />
              <span className=%twc("flex items-center mr-1")> {j`~`->React.string} </span>
              <DatePicker
                id="to"
                date={query.to_}
                onChange={handleOnChangeDate(To)}
                maxDate={Js.Date.make()->DateFns.format("yyyy-MM-dd")}
                minDate={query.from->DateFns.format("yyyy-MM-dd")}
                firstDayOfWeek=0
              />
            </div>
          </div>
        </div>
      </div>
      <div className=%twc("flex justify-center mt-5")>
        <span className=%twc("w-20 h-11 flex mr-2")>
          <input
            type_="button"
            className=%twc("btn-level6")
            value=`초기화`
            onClick={handleOnReset}
            tabIndex=6
          />
        </span>
        <span className=%twc("w-20 h-11 flex")>
          <input type_="submit" className=%twc("btn-level1") value=`검색` tabIndex=5 />
        </span>
      </div>
    </form>
  </div>
}
