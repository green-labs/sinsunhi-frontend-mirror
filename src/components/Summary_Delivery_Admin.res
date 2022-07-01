module StatusFilter = {
  @react.component
  let make = () => {
    <ol
      className=%twc(
        "grid grid-cols-2 pt-3 sm:grid-cols-4 lg:grid-cols-6 lg:justify-between lg:w-full lg:py-4"
      )>
      <Status.Total />
      <Status.Item kind=CREATE />
      <Status.Item kind=PACKING />
      <Status.Item kind=DEPARTURE />
      // FIXME: 그리드를 사용해서 가로 divider를 추가하기 위한 몸부림
      <div className=%twc("hidden sm:grid sm:grid-row-border-4 lg:hidden") />
      <Status.Item kind=DELIVERING />
      <Status.Item kind=COMPLETE />
      // FIXME: 그리드를 사용해서 가로 divider를 추가하기 위한 몸부림
      <div className=%twc("hidden lg:grid lg:grid-row-border-6") />
      <Status.Item kind=CANCEL />
      <Status.Item kind=REFUND />
      // FIXME: 그리드를 사용해서 가로 divider를 추가하기 위한 몸부림
      <div className=%twc("hidden sm:grid sm:grid-row-border-4 lg:hidden") />
      <Status.Item kind=ERROR />
    </ol>
  }
}

module FormFields = Query_Delivery_Form_Admin.FormFields
module Form = Query_Delivery_Form_Admin.Form

type query = {
  from: Js.Date.t,
  to_: Js.Date.t,
}
type target = From | To

@react.component
let make = () => {
  let router = Next.Router.useRouter()

  let (query, setQuery) = React.Uncurried.useState(_ => {
    from: Js.Date.make()->DateFns.subDays(7),
    to_: Js.Date.make(),
  })

  let onSubmit = ({state}: Form.onSubmitAPI) => {
    let farmerName = state.values->FormFields.get(FormFields.FarmerName)
    let orderProductNo = state.values->FormFields.get(FormFields.OrderProductNo)
    let productId = state.values->FormFields.get(FormFields.ProductId)
    let sku = state.values->FormFields.get(FormFields.Sku)
    let ordererName = state.values->FormFields.get(FormFields.OrdererName)
    let receiverName = state.values->FormFields.get(FormFields.ReceiverName)

    let {makeWithDict, toString} = module(Webapi.Url.URLSearchParams)

    router.query->Js.Dict.set("farmer-name", farmerName)
    router.query->Js.Dict.set("orderer-name", ordererName)
    router.query->Js.Dict.set("receiver-name", receiverName)
    router.query->Js.Dict.set("order-product-no", orderProductNo)
    router.query->Js.Dict.set("product-id", productId)
    router.query->Js.Dict.set("sku", sku)
    router.query->Js.Dict.set("from", query.from->DateFns.format("yyyyMMdd"))
    router.query->Js.Dict.set("to", query.to_->DateFns.format("yyyyMMdd"))

    router->Next.Router.push(`${router.pathname}?${router.query->makeWithDict->toString}`)

    None
  }

  let form: Form.api = Form.use(
    ~validationStrategy=Form.OnChange,
    ~onSubmit,
    ~initialState=Query_Delivery_Form_Admin.initialState,
    ~schema={
      open Form.Validation
      Schema(
        [
          regExp(
            OrdererName,
            ~matches="^(?:.{2,}|)$",
            ~error=`최소 2글자를 입력해주세요.`,
          ),
          regExp(
            ReceiverName,
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
      if k === "farmer-name" {
        FormFields.FarmerName->form.setFieldValue(v, ~shouldValidate=true, ())
      } else if k === "order-product-no" {
        FormFields.OrderProductNo->form.setFieldValue(v, ~shouldValidate=true, ())
      } else if k === "product-id" {
        FormFields.ProductId->form.setFieldValue(v, ~shouldValidate=true, ())
      } else if k === "orderer-name" {
        FormFields.OrdererName->form.setFieldValue(v, ~shouldValidate=true, ())
      } else if k === "receiver-name" {
        FormFields.ReceiverName->form.setFieldValue(v, ~shouldValidate=true, ())
      } else if k === "sku" {
        FormFields.Sku->form.setFieldValue(v, ~shouldValidate=true, ())
      } else if k === "from" {
        setQuery(.prev => {...prev, from: v->DateFns.parse("yyyyMMdd", Js.Date.make())})
      } else if k === "to" {
        setQuery(.prev => {...prev, to_: v->DateFns.parse("yyyyMMdd", Js.Date.make())})
      }
    })

    None
  }, [router.query])

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
      FormFields.FarmerName->form.setFieldValue("", ~shouldValidate=true, ())
      FormFields.OrderProductNo->form.setFieldValue("", ~shouldValidate=true, ())
      FormFields.ProductId->form.setFieldValue("", ~shouldValidate=true, ())
      FormFields.OrdererName->form.setFieldValue("", ~shouldValidate=true, ())
      FormFields.ReceiverName->form.setFieldValue("", ~shouldValidate=true, ())
      FormFields.Sku->form.setFieldValue("", ~shouldValidate=true, ())
      setQuery(._ => {from: Js.Date.make()->DateFns.subDays(7), to_: Js.Date.make()})
    }
  )->ReactEvents.interceptingHandler

  <div className=%twc("py-3 px-7 mt-4 mx-4 shadow-gl bg-white rounded")>
    <StatusFilter />
    <form onSubmit=handleOnSubmit>
      <div className=%twc("py-6 flex flex-col text-sm bg-gray-gl rounded-xl")>
        <div className=%twc("flex")>
          <div className=%twc("w-32 font-bold mt-2 pl-7")> {j`검색`->React.string} </div>
          <div className=%twc("flex-1")>
            <div className=%twc("flex")>
              <div className=%twc("w-64 flex items-center mr-16")>
                <label htmlFor="farmer-name" className=%twc("whitespace-nowrap mr-2")>
                  {j`생산자명`->React.string}
                </label>
                <Input
                  type_="text"
                  name="farmer-name"
                  placeholder=`생산자명 입력`
                  value={form.values->FormFields.get(FormFields.FarmerName)}
                  onChange={FormFields.FarmerName->form.handleChange->ReForm.Helpers.handleChange}
                  error={FormFields.FarmerName->Form.ReSchema.Field->form.getFieldError}
                  tabIndex=1
                />
              </div>
              <div className=%twc("w-64 flex items-center mr-16")>
                <label htmlFor="orderer-name" className=%twc("whitespace-nowrap mr-2")>
                  {j`주문자명`->React.string}
                </label>
                <Input
                  type_="text"
                  name="orderer-name"
                  placeholder=`주문자명 입력`
                  value={form.values->FormFields.get(FormFields.OrdererName)}
                  onChange={FormFields.OrdererName->form.handleChange->ReForm.Helpers.handleChange}
                  error={FormFields.OrdererName->Form.ReSchema.Field->form.getFieldError}
                  tabIndex=2
                />
              </div>
              <div className=%twc("w-64 flex items-center mr-16")>
                <label htmlFor="receiver-name" className=%twc("whitespace-nowrap mr-2")>
                  {j`수취인명`->React.string}
                </label>
                <Input
                  type_="text"
                  name="receiver-name"
                  placeholder=`수취인명 입력`
                  value={form.values->FormFields.get(FormFields.ReceiverName)}
                  onChange={FormFields.ReceiverName->form.handleChange->ReForm.Helpers.handleChange}
                  error={FormFields.ReceiverName->Form.ReSchema.Field->form.getFieldError}
                  tabIndex=3
                />
              </div>
            </div>
            <div className=%twc("flex mt-3")>
              <div className=%twc("w-64 flex items-center mr-16")>
                <label htmlFor="order-product-no" className=%twc("whitespace-nowrap mr-2")>
                  {j`주문번호`->React.string}
                </label>
                <Input
                  type_="text"
                  name="order-product-no"
                  placeholder=`주문번호 입력`
                  value={form.values->FormFields.get(FormFields.OrderProductNo)}
                  onChange={FormFields.OrderProductNo
                  ->form.handleChange
                  ->ReForm.Helpers.handleChange}
                  error={FormFields.OrderProductNo->Form.ReSchema.Field->form.getFieldError}
                  tabIndex=4
                />
              </div>
              <div className=%twc("w-64 flex items-center mr-16")>
                <label htmlFor="product-id" className=%twc("whitespace-nowrap mr-2")>
                  {j`상품번호`->React.string}
                </label>
                <Input
                  type_="text"
                  name="product-id"
                  placeholder=`상품번호 입력`
                  value={form.values->FormFields.get(FormFields.ProductId)}
                  onChange={FormFields.ProductId->form.handleChange->ReForm.Helpers.handleChange}
                  error={FormFields.ProductId->Form.ReSchema.Field->form.getFieldError}
                  tabIndex=5
                />
              </div>
              <div className=%twc("w-64 flex items-center")>
                <label htmlFor="sku" className=%twc("whitespace-nowrap mr-2")>
                  {j`단품번호`->React.string}
                </label>
                <Input
                  type_="text"
                  name="sku"
                  placeholder=`단품번호 입력`
                  value={form.values->FormFields.get(FormFields.Sku)}
                  onChange={FormFields.Sku->form.handleChange->ReForm.Helpers.handleChange}
                  error={FormFields.Sku->Form.ReSchema.Field->form.getFieldError}
                  tabIndex=6
                />
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
          tabIndex=7
        />
        <input
          type_="submit"
          className=%twc(
            "w-20 py-2 bg-green-gl text-white font-bold rounded-xl ml-2 hover:bg-green-gl-dark focus:outline-none focus:ring-2 focus:ring-offset-1 focus:ring-green-gl focus:ring-opacity-100"
          )
          value=`검색`
          tabIndex=6
        />
      </div>
    </form>
  </div>
}
