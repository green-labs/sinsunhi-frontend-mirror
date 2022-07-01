module Select_Crop_Std = Select_Crop_Search_Std

type query = {
  from: Js.Date.t,
  to_: Js.Date.t,
}
type target = From | To

type defaults = {
  std: option<string>,
  categoryId: option<string>,
  label: option<string>,
}

module FormFields = %lenses(
  type state = {
    applicantName: string,
    businessName: string,
    farmAddress: string,
  }
)

module Form = ReForm.Make(FormFields)

let initialState: FormFields.state = {
  applicantName: "",
  businessName: "",
  farmAddress: "",
}

@react.component
let make = () => {
  let router = Next.Router.useRouter()

  let (cropId, setCropId) = React.Uncurried.useState(_ => ReactSelect.NotSelected)
  let (productCategoryId, setProductCategoryId) = React.Uncurried.useState(_ =>
    ReactSelect.NotSelected
  )

  let (checkTest, setCheckTest) = React.Uncurried.useState(_ => false)
  let (selectStaff, setSelectStaff) = React.Uncurried.useState(_ => ReactSelect.NotSelected)
  let (query, setQuery) = React.Uncurried.useState(_ => {
    from: Js.Date.make()->DateFns.set({
      year: Some(2022),
      month: Some(0),
      date: Some(24),
      hours: None,
      minutes: None,
      seconds: None,
      milliseconds: None,
    }),
    to_: Js.Date.make(),
  })

  let onSubmit = ({state}: Form.onSubmitAPI) => {
    let applicantName = state.values->FormFields.get(FormFields.ApplicantName)
    let businessName = state.values->FormFields.get(FormFields.BusinessName)
    let farmAddress = state.values->FormFields.get(FormFields.FarmAddress)
    let (searchCropId, searchCropName) =
      cropId->ReactSelect.toOption->Option.mapWithDefault(("", ""), v => (v.value, v.label))
    let (searchCategoryId, searchCategoryName) =
      productCategoryId
      ->ReactSelect.toOption
      ->Option.mapWithDefault(("", ""), v => (v.value, v.label))
    let (staffId, staffName) =
      selectStaff->ReactSelect.toOption->Option.mapWithDefault(("", ""), v => (v.value, v.label))

    router.query->Js.Dict.set("applicant-name", applicantName)
    router.query->Js.Dict.set("business-name", businessName)
    router.query->Js.Dict.set("farm-address", farmAddress)
    router.query->Js.Dict.set("crop-id", searchCropId)
    router.query->Js.Dict.set("crop-name", searchCropName)
    router.query->Js.Dict.set("product-category-id", searchCategoryId)
    router.query->Js.Dict.set("product-category-name", searchCategoryName)
    router.query->Js.Dict.set("from", query.from->DateFns.format("yyyyMMdd"))
    router.query->Js.Dict.set("to", query.to_->DateFns.format("yyyyMMdd"))
    router.query->Js.Dict.set("is-test", checkTest->Js.String2.make)
    router.query->Js.Dict.set("staff-id", staffId)
    router.query->Js.Dict.set("staff-name", staffName)

    let {makeWithDict, toString} = module(Webapi.Url.URLSearchParams)

    router->Next.Router.push(`${router.pathname}?${router.query->makeWithDict->toString}`)

    None
  }

  let form: Form.api = Form.use(
    ~validationStrategy=Form.OnChange,
    ~onSubmit,
    ~initialState,
    ~schema={
      open Form.Validation
      Schema(
        [
          regExp(
            BusinessName,
            ~matches="^(?:.{2,}|)$",
            ~error=`최소 2글자를 입력해주세요.`,
          ),
          regExp(
            ApplicantName,
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

  React.useEffect1(_ => {
    form.resetForm()

    router.query
    ->Js.Dict.entries
    ->Garter.Array.forEach(entry => {
      let (k, v) = entry
      if k === "applicant-name" {
        FormFields.ApplicantName->form.setFieldValue(v, ~shouldValidate=false, ())
      } else if k === "business-name" {
        FormFields.BusinessName->form.setFieldValue(v, ~shouldValidate=false, ())
      } else if k === "farm-address" {
        FormFields.FarmAddress->form.setFieldValue(v, ~shouldValidate=false, ())
      } else if k === "is-test" {
        setCheckTest(._ => v->bool_of_string)
      }
    })

    Helper.Option.map2(
      router.query->Js.Dict.get("crop-id"),
      router.query->Js.Dict.get("crop-name"),
      (value, label) => {
        if value !== "" && label !== "" {
          setCropId(._ => ReactSelect.Selected({value: value, label: label}))
        }
      },
    )->ignore

    Helper.Option.map2(
      router.query->Js.Dict.get("product-category-id"),
      router.query->Js.Dict.get("product-category-name"),
      (value, label) => {
        if value !== "" && label !== "" {
          setProductCategoryId(._ => ReactSelect.Selected({value: value, label: label}))
        }
      },
    )->ignore

    Helper.Option.map2(
      router.query->Js.Dict.get("staff-id"),
      router.query->Js.Dict.get("staff-name"),
      (value, label) => {
        if value !== "" && label !== "" {
          setSelectStaff(._ => ReactSelect.Selected({value: value, label: label}))
        }
      },
    )->ignore

    None
  }, [router.query])

  let handleOnChangePeriod = d => {
    setQuery(.prev => {...prev, from: d})
  }

  let handleOnReset = (
    _ => {
      FormFields.ApplicantName->form.setFieldValue("", ~shouldValidate=false, ())
      FormFields.BusinessName->form.setFieldValue("", ~shouldValidate=false, ())
      FormFields.FarmAddress->form.setFieldValue("", ~shouldValidate=false, ())

      setCheckTest(._ => false)
      setSelectStaff(._ => ReactSelect.NotSelected)
      setQuery(.prev => {...prev, from: Js.Date.make()->DateFns.subMonths(1)})
      setQuery(.prev => {...prev, to_: Js.Date.make()})

      setCropId(._ => ReactSelect.NotSelected)
      setProductCategoryId(._ => ReactSelect.NotSelected)
    }
  )->ReactEvents.interceptingHandler

  let handleOnChangeDate = (t, e) => {
    let newDate = (e->DuetDatePicker.DuetOnChangeEvent.detail).valueAsDate
    switch (t, newDate) {
    | (From, Some(newDate')) => setQuery(.prev => {...prev, from: newDate'})
    | (To, Some(newDate')) => setQuery(.prev => {...prev, to_: newDate'})
    | _ => ()
    }
  }

  let handleOnSelect = (~cleanUpFn=?, setFn, value) => {
    setFn(._ => value)
    switch cleanUpFn {
    | Some(f) => f()
    | None => ()
    }
  }

  <div className=%twc("bg-white rounded")>
    <form onSubmit={handleOnSubmit}>
      <div className=%twc("py-3 flex flex-col text-sm bg-gray-gl rounded-xl")>
        <div className=%twc("flex")>
          <div className=%twc("w-32 font-bold mt-2 pl-7 whitespace-nowrap")>
            {j`검색`->React.string}
          </div>
          <div className=%twc("flex-1")>
            <div className=%twc("flex")>
              <div className=%twc("w-64 flex items-center mr-16")>
                <label htmlFor="farmer-name" className=%twc("whitespace-nowrap mr-2")>
                  {j`사용자명`->React.string}
                </label>
                <Input
                  type_="text"
                  name="farmer-name"
                  placeholder=`사용자명 입력`
                  value={form.values->FormFields.get(FormFields.ApplicantName)}
                  onChange={FormFields.ApplicantName
                  ->form.handleChange
                  ->ReForm.Helpers.handleChange}
                  error={FormFields.ApplicantName->Form.ReSchema.Field->form.getFieldError}
                  tabIndex=1
                />
              </div>
              <div className=%twc("w-64 flex items-center mr-16")>
                <label htmlFor="farmer-name" className=%twc("whitespace-nowrap mr-2")>
                  {j`사업자명`->React.string}
                </label>
                <Input
                  type_="text"
                  name="farmer-name"
                  placeholder=`사업자명 입력`
                  value={form.values->FormFields.get(FormFields.BusinessName)}
                  onChange={FormFields.BusinessName->form.handleChange->ReForm.Helpers.handleChange}
                  error={FormFields.BusinessName->Form.ReSchema.Field->form.getFieldError}
                  tabIndex=1
                />
              </div>
            </div>
            <div className=%twc("flex mt-3")>
              <div className=%twc("w-64 flex items-center mr-16")>
                <label htmlFor="farmer-name" className=%twc("whitespace-nowrap mr-2")>
                  {j`담당자명`->React.string}
                </label>
                <Select_BulkSale_Search.Staff
                  key={UniqueId.make(~prefix="bulkSaleSearch", ())}
                  staffInfo={selectStaff}
                  onChange={v => setSelectStaff(._ => v)}
                />
              </div>
              <div className=%twc("w-[350px] flex items-center mr-16")>
                <label htmlFor="farmer-name" className=%twc("whitespace-nowrap mr-8")>
                  {j`주소`->React.string}
                </label>
                <Input
                  type_="text"
                  name="farmer-name"
                  placeholder=`정확한 키워드로 단위로 주소를 검색하세요`
                  value={form.values->FormFields.get(FormFields.FarmAddress)}
                  onChange={FormFields.FarmAddress->form.handleChange->ReForm.Helpers.handleChange}
                  error={FormFields.FarmAddress->Form.ReSchema.Field->form.getFieldError}
                  tabIndex=1
                />
              </div>
            </div>
            <div className=%twc("flex mt-3")>
              <div className=%twc("h-9 flex justify-start items-center")>
                <label htmlFor="crop-kind" className=%twc("whitespace-nowrap mr-2")>
                  {j`작물품종`->React.string}
                </label>
              </div>
              <div className=%twc("relative")>
                <div className=%twc("absolute w-[200px] left-0")>
                  <React.Suspense fallback={<div> {j`로딩 중..`->React.string} </div>}>
                    <Select_BulkSale_Search.Crop
                      cropId
                      onChange={handleOnSelect(setCropId, ~cleanUpFn=_ => {
                        setProductCategoryId(._ => ReactSelect.NotSelected)
                      })}
                    />
                  </React.Suspense>
                </div>
                <div className=%twc("absolute w-[296px] left-[221px]")>
                  <React.Suspense fallback={<div> {j`로딩 중..`->React.string} </div>}>
                    <Select_BulkSale_Search.ProductCategory
                      key={switch cropId {
                      | ReactSelect.NotSelected => ""
                      | ReactSelect.Selected({value}) => value
                      }}
                      cropId
                      productCategoryId
                      onChange={handleOnSelect(setProductCategoryId)}
                    />
                  </React.Suspense>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div className=%twc("flex mt-3")>
          <div className=%twc("w-32 font-bold flex items-center pl-7")>
            {j`기간`->React.string}
          </div>
          <div className=%twc("flex")>
            <div className=%twc("flex mr-8")>
              <PeriodSelector from=query.from to_=query.to_ onSelect=handleOnChangePeriod />
            </div>
            <DatePicker
              id="from"
              date={query.from}
              onChange={handleOnChangeDate(From)}
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
          <div className=%twc("flex items-center justify-start ml-8")>
            <Checkbox
              id="check-all" checked=checkTest onChange={_ => setCheckTest(.prev => !prev)}
            />
            <span className=%twc("ml-2")> {`TEST건 제외`->React.string} </span>
          </div>
        </div>
      </div>
      <div className=%twc("flex justify-center mt-5")>
        <input
          type_="button"
          className=%twc(
            "w-20 py-2 bg-gray-button-gl text-black-gl rounded-xl ml-2 hover:bg-gray-button-gl focus:outline-none focus:ring-2 focus:ring-offset-1 focus:ring-gray-gl focus:ring-opacity-100"
          )
          value=`초기화`
          onClick={handleOnReset}
          tabIndex=5
        />
        <input
          type_="submit"
          className=%twc(
            "w-20 py-2 bg-green-gl text-white font-bold rounded-xl ml-2 hover:bg-green-gl-dark focus:outline-none focus:ring-2 focus:ring-offset-1 focus:ring-green-gl focus:ring-opacity-100"
          )
          value=`검색`
          tabIndex=4
        />
      </div>
    </form>
  </div>
}
