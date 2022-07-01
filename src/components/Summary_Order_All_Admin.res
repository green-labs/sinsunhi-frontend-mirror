/**
 * 수기 주문데이터 관리자 업로드 시연용 컴포넌트
 * TODO: 시연이 끝나면 지워도 된다.
 */

module FormFields = Query_Order_All_Form_Admin.FormFields
module Form = Query_Order_All_Form_Admin.Form

type query = {
  from: Js.Date.t,
  to_: Js.Date.t,
}
type target = From | To

@react.component
let make = () => {
  let router = Next.Router.useRouter()

  let (orderType, setOrderType) = React.Uncurried.useState(_ => None)

  let (query, setQuery) = React.Uncurried.useState(_ => {
    from: Js.Date.make()->DateFns.subDays(7),
    to_: Js.Date.make(),
  })

  let onSubmit = ({state}: Form.onSubmitAPI) => {
    let productName = state.values->FormFields.get(FormFields.ProductName)
    let producerName = state.values->FormFields.get(FormFields.ProducerName)
    let buyerName = state.values->FormFields.get(FormFields.BuyerName)

    let {makeWithDict, toString} = module(Webapi.Url.URLSearchParams)

    router.query->Js.Dict.set("product-name", productName)
    router.query->Js.Dict.set("producer-name", producerName)
    router.query->Js.Dict.set("buyer-name", buyerName)
    router.query->Js.Dict.set(
      "order-type",
      orderType
      ->Option.flatMap(orderType' =>
        orderType'->CustomHooks.OrdersAllAdmin.orderType_encode->Js.Json.decodeString
      )
      ->Option.getWithDefault(``),
    )
    router.query->Js.Dict.set("from", query.from->DateFns.format("yyyyMMdd"))
    router.query->Js.Dict.set("to", query.to_->DateFns.format("yyyyMMdd"))
    router.query->Js.Dict.set("offset", "0")

    router->Next.Router.push(`${router.pathname}?${router.query->makeWithDict->toString}`)

    None
  }

  let form: Form.api = Form.use(
    ~validationStrategy=Form.OnChange,
    ~onSubmit,
    ~initialState=Query_Order_All_Form_Admin.initialState,
    ~schema={
      open Form.Validation
      Schema(
        [
          regExp(
            ProductName,
            ~matches="^(?:.{2,}|)$",
            ~error=`최소 2글자를 입력해주세요.`,
          ),
          regExp(
            ProducerName,
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

  React.useEffect1(_ => {
    form.resetForm()

    router.query
    ->Js.Dict.entries
    ->Garter.Array.forEach(entry => {
      let (k, v) = entry
      if k === "product-name" {
        FormFields.ProductName->form.setFieldValue(v, ~shouldValidate=true, ())
      } else if k === "producer-name" {
        FormFields.ProducerName->form.setFieldValue(v, ~shouldValidate=true, ())
      } else if k === "buyer-name" {
        FormFields.BuyerName->form.setFieldValue(v, ~shouldValidate=true, ())
      } else if k === "order-type" {
        switch v->Js.Json.string->CustomHooks.OrdersAllAdmin.orderType_decode {
        | Ok(v') => setOrderType(._ => Some(v'))
        | Error(_) => setOrderType(._ => None)
        }
      } else if k === "from" {
        setQuery(.prev => {...prev, from: v->DateFns.parse("yyyyMMdd", Js.Date.make())})
      } else if k === "to" {
        setQuery(.prev => {...prev, to_: v->DateFns.parse("yyyyMMdd", Js.Date.make())})
      }
    })

    None
  }, [router.query])

  let handleOnSelect = (setFn, e) => {
    let value = (e->ReactEvent.Synthetic.target)["value"]
    switch value->CustomHooks.OrdersAllAdmin.orderType_decode {
    | Ok(value') => setFn(._ => Some(value'))
    | Error(_) => setFn(._ => None)
    }
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
      FormFields.ProductName->form.setFieldValue("", ~shouldValidate=true, ())
      FormFields.ProducerName->form.setFieldValue("", ~shouldValidate=true, ())
      FormFields.BuyerName->form.setFieldValue("", ~shouldValidate=true, ())
      setQuery(._ => {from: Js.Date.make()->DateFns.subDays(7), to_: Js.Date.make()})
    }
  )->ReactEvents.interceptingHandler

  <div className=%twc("p-7 mt-4 mx-4 shadow-gl bg-white rounded")>
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
                <label
                  htmlFor="product-name"
                  className=%twc("whitespace-nowrap")
                  style={ReactDOM.Style.make(~marginRight="21px", ())}>
                  {j`상품명`->React.string}
                </label>
                <Input
                  type_="text"
                  name="product-name"
                  placeholder=`상품명 입력`
                  value={form.values->FormFields.get(FormFields.ProductName)}
                  onChange={FormFields.ProductName->form.handleChange->ReForm.Helpers.handleChange}
                  error={FormFields.ProductName->Form.ReSchema.Field->form.getFieldError}
                  tabIndex=1
                />
              </div>
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
                  tabIndex=2
                />
              </div>
              <div
                className=%twc(
                  "flex-1 flex flex-col sm:flex-initial sm:w-64 sm:flex-row sm:items-center"
                )>
                <label htmlFor="buyer-name" className=%twc("whitespace-nowrap mr-2")>
                  {j`바이어명`->React.string}
                </label>
                <Input
                  type_="text"
                  name="buyer-name"
                  placeholder=`바이어명 입력`
                  value={form.values->FormFields.get(FormFields.BuyerName)}
                  onChange={FormFields.BuyerName->form.handleChange->ReForm.Helpers.handleChange}
                  error={FormFields.BuyerName->Form.ReSchema.Field->form.getFieldError}
                  tabIndex=3
                />
              </div>
            </div>
            <div className=%twc("flex mt-3")>
              <div className=%twc("w-64 flex items-center mr-16")>
                <label htmlFor="sales-kind" className=%twc("whitespace-nowrap mr-2")>
                  {j`거래유형`->React.string}
                </label>
                <div className=%twc("flex-1 block relative")>
                  <span
                    className=%twc(
                      "flex items-center border border-border-default-L1 rounded-lg py-2 px-3 text-enabled-L1 bg-white leading-4.5"
                    )>
                    {orderType
                    ->Option.map(CustomHooks.OrdersAllAdmin.orderType_encode)
                    ->Option.flatMap(Js.Json.decodeString)
                    ->Option.getWithDefault(`전체`)
                    ->React.string}
                  </span>
                  <span className=%twc("absolute top-1.5 right-2")>
                    <IconArrowSelect height="24" width="24" fill="#121212" />
                  </span>
                  <select
                    id="period"
                    value={orderType
                    ->Option.map(CustomHooks.OrdersAllAdmin.orderType_encode)
                    ->Option.flatMap(Js.Json.decodeString)
                    ->Option.getWithDefault(`전체`)}
                    className=%twc("block w-full h-full absolute top-0 opacity-0")
                    onChange={handleOnSelect(setOrderType)}>
                    <option value=`전체`> {j`전체`->React.string} </option>
                    <option value=`온라인`> {j`온라인`->React.string} </option>
                    <option value=`오프라인`> {j`오프라인`->React.string} </option>
                  </select>
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
