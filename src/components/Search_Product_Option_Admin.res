module FormFields = Query_Product_Form_Admin.FormFields
module Form = Query_Product_Form_Admin.Form
module Select = Select_Product_Option_Status
module Select_Crop_Std = Select_Crop_Search_Std

@react.component
let make = () => {
  let router = Next.Router.useRouter()

  let (status, setStatus) = React.Uncurried.useState(_ => Select.parseStatus(router.query))
  let (selectedCrop, setSelectedCrop) = React.Uncurried.useState(_ => ReactSelect.NotSelected)

  let handleOnChageStatus = e => {
    let newStatus = (e->ReactEvent.Synthetic.target)["value"]
    setStatus(._ => newStatus->Select.decodeStatus->Option.getWithDefault(ALL))
  }

  let onSubmit = ({state}: Form.onSubmitAPI) => {
    let producerName = state.values->FormFields.get(FormFields.ProducerName)
    let productName = state.values->FormFields.get(FormFields.ProductName)
    let std = state.values->FormFields.get(FormFields.Std)

    let {makeWithDict, toString} = module(Webapi.Url.URLSearchParams)

    router.query->Js.Dict.set("producer-name", producerName)
    router.query->Js.Dict.set("product-name", productName)
    router.query->Js.Dict.set("status", status->Select.encodeStatus)
    router.query->Js.Dict.set("crop-search-std", std)

    let (categoryId, label) =
      selectedCrop->ReactSelect.toOption->Option.mapWithDefault(("", ""), v => (v.value, v.label))

    router.query->Js.Dict.set("category-id", categoryId)
    router.query->Js.Dict.set("label", label)

    //offset 초기화
    router.query->Js.Dict.set("offset", "0")

    router->Next.Router.push(`${router.pathname}?${router.query->makeWithDict->toString}`)

    None
  }

  let form: Form.api = Form.use(
    ~validationStrategy=Form.OnChange,
    ~onSubmit,
    ~initialState=Query_Product_Form_Admin.initialState,
    ~schema={
      open Form.Validation
      Schema([]->Array.concatMany)
    },
    (),
  )

  let handleOnChangeCropOrCultivar = e => {
    FormFields.Std->form.handleChange->ReForm.Helpers.handleChange(e)
    setSelectedCrop(._ => ReactSelect.NotSelected)
  }

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
      if k === "producer-name" {
        FormFields.ProducerName->form.setFieldValue(v, ~shouldValidate=false, ())
      } else if k === "product-name" {
        FormFields.ProductName->form.setFieldValue(v, ~shouldValidate=false, ())
      } else if k === "status" {
        setStatus(._ => v->Select.decodeStatus->Option.getWithDefault(ALL))
      } else if k === "crop-search-std" {
        FormFields.Std->form.setFieldValue(v, ~shouldValidate=false, ())
      }
    })

    Helper.Option.map2(router.query->Js.Dict.get("crop"), router.query->Js.Dict.get("label"), (
      value,
      label,
    ) => {
      if value !== "" && label !== "" {
        setSelectedCrop(._ => ReactSelect.Selected({value: value, label: label}))
      }
    })->ignore

    None
  }, [router.query])

  let handleOnReset = (
    _ => {
      FormFields.ProducerName->form.setFieldValue("", ~shouldValidate=false, ())
      FormFields.ProductName->form.setFieldValue("", ~shouldValidate=false, ())
      FormFields.Std->form.setFieldValue("Crop", ~shouldValidate=false, ())
      setStatus(._ => ALL)
      setSelectedCrop(._ => ReactSelect.NotSelected)
    }
  )->ReactEvents.interceptingHandler

  let handleChangeCrop = selection => {
    setSelectedCrop(._ => selection)
  }

  <div className=%twc("p-7 mt-4 mx-4 bg-white rounded shadow-gl")>
    <form onSubmit={handleOnSubmit}>
      <div className=%twc("py-3 flex flex-col text-sm bg-gray-gl rounded-xl")>
        <div className=%twc("flex")>
          <div className=%twc("w-32 font-bold mt-2 pl-7 whitespace-nowrap")>
            {j`검색`->React.string}
          </div>
          <div className=%twc("flex-1")>
            <div className=%twc("flex")>
              <div
                className=%twc(
                  "flex-1 flex flex-col sm:flex-initial sm:w-64 sm:flex-row sm:items-center mr-16"
                )>
                <label htmlFor="producer-name" className=%twc("whitespace-nowrap mr-2")>
                  {j`생산자명`->React.string}
                </label>
                <Input
                  type_="text"
                  name="producer-name"
                  placeholder=`생산자명 입력`
                  value={form.values->FormFields.get(FormFields.ProducerName)}
                  onChange={FormFields.ProducerName->form.handleChange->ReForm.Helpers.handleChange}
                  error={FormFields.ProducerName->Form.ReSchema.Field->form.getFieldError}
                  tabIndex=1
                />
              </div>
              <div className=%twc("min-w-1/2 flex items-center")>
                <label htmlFor="product-name" className=%twc("whitespace-nowrap mr-2")>
                  {j`상품명`->React.string}
                </label>
                <span className=%twc("flex-1")>
                  <Input
                    type_="text"
                    name="product-name"
                    placeholder=`상품명 입력`
                    value={form.values->FormFields.get(FormFields.ProductName)}
                    onChange={FormFields.ProductName
                    ->form.handleChange
                    ->ReForm.Helpers.handleChange}
                    error={FormFields.ProductName->Form.ReSchema.Field->form.getFieldError}
                    tabIndex=2
                  />
                </span>
              </div>
            </div>
            <div className=%twc("flex mt-3")>
              <div className=%twc("w-64 flex items-center")>
                <label htmlFor="crop-kind" className=%twc("whitespace-nowrap mr-2")>
                  {j`작물품종`->React.string}
                </label>
                <Select_Crop_Std
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
            <div className=%twc("flex mt-3")>
              <div className=%twc("w-64 flex items-center mr-16")>
                <label htmlFor="product-status" className=%twc("whitespace-nowrap mr-2")>
                  {j`판매상태`->React.string}
                </label>
                <Select_Product_Option_Status status onChange=handleOnChageStatus />
              </div>
            </div>
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
