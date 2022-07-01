module FormFields = Query_Product_Form_Buyer.FormFields
module Form = Query_Product_Form_Buyer.Form
module Select = Select_Product_Status

@react.component
let make = () => {
  let router = Next.Router.useRouter()

  let (status, setStatus) = React.Uncurried.useState(_ => Select.parseStatus(router.query))

  let handleOnChageStatus = e => {
    let newStatus = (e->ReactEvent.Synthetic.target)["value"]
    setStatus(._ => newStatus->Select.decodeStatus->Option.getWithDefault(ALL))
  }

  let onSubmit = ({state}: Form.onSubmitAPI) => {
    let productName = state.values->FormFields.get(FormFields.ProductName)

    let {makeWithDict, toString} = module(Webapi.Url.URLSearchParams)

    router.query->Js.Dict.set("product-name", productName)
    router.query->Js.Dict.set("status", status->Select.encodeStatus)

    router.query->Js.Dict.set("offset", "0")

    router->Next.Router.push(`${router.pathname}?${router.query->makeWithDict->toString}`)

    None
  }

  let form: Form.api = Form.use(
    ~validationStrategy=Form.OnChange,
    ~onSubmit,
    ~initialState=Query_Product_Form_Buyer.initialState,
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

  React.useEffect1(_ => {
    form.resetForm()

    router.query
    ->Js.Dict.entries
    ->Garter.Array.forEach(entry => {
      let (k, v) = entry
      if k === "product-name" {
        FormFields.ProductName->form.setFieldValue(v, ~shouldValidate=false, ())
      } else if k === "status" {
        setStatus(._ => v->Select.decodeStatus->Option.getWithDefault(ALL))
      }
    })

    None
  }, [router.query])

  let handleOnReset = (
    _ => {
      FormFields.ProductName->form.setFieldValue("", ~shouldValidate=false, ())
    }
  )->ReactEvents.interceptingHandler

  <div className=%twc("py-7 px-4 shadow-gl sm:mt-4")>
    <form onSubmit={handleOnSubmit} className=%twc("lg:px-4")>
      <div className=%twc("py-3 flex flex-col text-sm bg-gray-gl rounded-xl")>
        <div className=%twc("flex flex-col lg:flex-row")>
          <div className=%twc("w-32 font-bold pl-3 whitespace-nowrap lg:pl-7 lg:pt-3")>
            {j`검색`->React.string}
          </div>
          <div className=%twc("flex-1 px-3 lg:px-0")>
            <div className=%twc("flex mt-2 flex-col sm:flex-row")>
              <div
                className=%twc(
                  "flex-1 flex flex-col mr-2 mb-2 sm:w-64 sm:flex-initial sm:flex-row sm:items-center sm:mr-16 sm:mb-0"
                )>
                <label
                  htmlFor="product-status" className=%twc("whitespace-nowrap mr-2 mb-1 sm:mb-0")>
                  {j`판매상태`->React.string}
                </label>
                <Select_Product_Status status onChange=handleOnChageStatus />
              </div>
              <div
                className=%twc(
                  "min-w-1/2 flex flex-col sm:flex-initial sm:flex-row sm:items-center sm:mt-0"
                )>
                <label htmlFor="product-name" className=%twc("whitespace-nowrap mr-2 mb-1 sm:mb-0")>
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
          tabIndex=4
        />
        <input
          type_="submit"
          className=%twc(
            "w-20 py-2 bg-green-gl text-white font-bold rounded-xl ml-2 hover:bg-green-gl-dark focus:outline-none focus:ring-2 focus:ring-offset-1 focus:ring-green-gl focus:ring-opacity-100"
          )
          value=`검색`
          tabIndex=3
        />
      </div>
    </form>
  </div>
}
