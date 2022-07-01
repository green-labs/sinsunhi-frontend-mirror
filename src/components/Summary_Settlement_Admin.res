module FormFields = Query_Settlement_Form_Admin.FormFields
module Form = Query_Settlement_Form_Admin.Form

type period = Week | HalfMonth | Month

type query = {
  from: Js.Date.t,
  to_: Js.Date.t,
}
type target = From | To

let getSettlementCycle = q => q->Js.Dict.get("settlement-cycle")
let parseSettlementCycle = value =>
  if value === `week` {
    Some(Week)
  } else if value === `half-month` {
    Some(HalfMonth)
  } else if value === `month` {
    Some(Month)
  } else {
    None
  }
let stringifySettlementCycle = settlementCycle =>
  switch settlementCycle {
  | Week => `1주`
  | HalfMonth => `15일`
  | Month => `1개월`
  }

@react.component
let make = (~onReset, ~onQuery) => {
  let router = Next.Router.useRouter()

  let (settlementCycle, setSettlementCycle) = React.Uncurried.useState(_ => Week)

  let handleOnSelectSettlementCycle = (setFn, e) => {
    let value = (e->ReactEvent.Synthetic.target)["value"]
    if value === `1주` {
      setFn(._ => Week)
    } else if value === `15일` {
      setFn(._ => HalfMonth)
    } else if value === `1개월` {
      setFn(._ => Month)
    } else {
      setFn(._ => Week)
    }
  }

  let (query, setQuery) = React.Uncurried.useState(_ => {
    from: Js.Date.make()->DateFns.subDays(7),
    to_: Js.Date.make(),
  })

  let handleOnChangeDate = (t, e) => {
    let newDate = (e->DuetDatePicker.DuetOnChangeEvent.detail).valueAsDate
    switch (t, newDate) {
    | (From, Some(newDate')) => setQuery(.prev => {...prev, from: newDate'})
    | (To, Some(newDate')) => setQuery(.prev => {...prev, to_: newDate'})
    | _ => ()
    }
  }

  let handleOnChangeSettlementCycle = (f, t) => {
    setQuery(._ => {from: f, to_: t})
  }

  let onSubmit = ({state}: Form.onSubmitAPI) => {
    let producerName = state.values->FormFields.get(FormFields.ProducerName)
    let producerCodes = state.values->FormFields.get(FormFields.ProducerCodes)

    let {makeWithDict, toString} = module(Webapi.Url.URLSearchParams)

    router.query->Js.Dict.set("producer-name", producerName)
    router.query->Js.Dict.set("producer-codes", producerCodes)

    router.query->Js.Dict.set(
      "settlement-cycle",
      switch settlementCycle {
      | Week => `week`
      | HalfMonth => `half-month`
      | Month => `month`
      },
    )
    router.query->Js.Dict.set("from", query.from->DateFns.format("yyyyMMdd"))
    router.query->Js.Dict.set("to", query.to_->DateFns.format("yyyyMMdd"))

    router->Next.Router.push(`${router.pathname}?${router.query->makeWithDict->toString}`)

    None
  }

  let form: Form.api = Form.use(
    ~validationStrategy=Form.OnChange,
    ~onSubmit,
    ~initialState=Query_Settlement_Form_Admin.initialState,
    ~schema={
      open Form.Validation
      Schema(
        [
          regExp(
            ProducerCodes,
            ~matches="^(G-[0-9]+([,\n\s]+)?)*$",
            ~error=`숫자(Enter 또는 ","로 구분 가능)만 입력해주세요`,
          ),
        ]->Array.concatMany,
      )
    },
    (),
  )

  let handleOnSubmit = (
    _ => {
      onQuery()

      form.submit()
    }
  )->ReactEvents.interceptingHandler

  React.useEffect1(_ => {
    router.query
    ->Js.Dict.entries
    ->Garter.Array.forEach(entry => {
      let (k, v) = entry
      if k === "producer-name" {
        FormFields.ProducerName->form.setFieldValue(v, ~shouldValidate=true, ())
      } else if k === "producer-codes" {
        FormFields.ProducerCodes->form.setFieldValue(v, ~shouldValidate=true, ())
      } else if k === "settlement-cycle" {
        v
        ->parseSettlementCycle
        ->Option.forEach(settlementCycle' => setSettlementCycle(._ => settlementCycle'))
      } else if k === "from" {
        setQuery(.prev => {...prev, from: v->DateFns.parse("yyyyMMdd", Js.Date.make())})
      } else if k === "to" {
        setQuery(.prev => {...prev, to_: v->DateFns.parse("yyyyMMdd", Js.Date.make())})
      }
    })

    None
  }, [router.query])

  let handleOnReset = (
    _ => {
      onReset()

      FormFields.ProducerName->form.setFieldValue("", ~shouldValidate=true, ())
      FormFields.ProducerCodes->form.setFieldValue("", ~shouldValidate=true, ())
      setSettlementCycle(._ => Week)
      setQuery(._ => {
        from: Js.Date.make()->DateFns.subDays(7),
        to_: Js.Date.make(),
      })
    }
  )->ReactEvents.interceptingHandler

  // <textarea> 에서 엔터를 입력하는 경우 폼 submit으로 처리한다.
  // 줄바꿈은 쉬프트 엔터
  let handleKeyDownEnter = (e: ReactEvent.Keyboard.t) => {
    if e->ReactEvent.Keyboard.keyCode === 13 && e->ReactEvent.Keyboard.shiftKey === false {
      e->ReactEvent.Keyboard.preventDefault

      form.submit()
    }
  }

  <div className=%twc("p-7 m-4 bg-white shadow-gl rounded")>
    <form onSubmit={handleOnSubmit}>
      <h2 className=%twc("text-text-L1 text-lg font-bold mb-5")>
        {j`상품 검색`->React.string}
      </h2>
      <div className=%twc("py-6 flex flex-col text-sm bg-gray-gl rounded-xl")>
        <div className=%twc("flex")>
          <div className=%twc("w-32 font-bold mt-2 pl-7 whitespace-nowrap")>
            {j`검색`->React.string}
          </div>
          <div className=%twc("flex-1")>
            <div className=%twc("flex")>
              <div className=%twc("w-64 flex items-center mr-16")>
                <label htmlFor="buyer-name" className=%twc("whitespace-nowrap w-20 mr-2")>
                  {j`생산자명`->React.string}
                </label>
                <Input
                  type_="text"
                  name="buyer-name"
                  placeholder=`생산자명`
                  value={form.values->FormFields.get(FormFields.ProducerName)}
                  onChange={FormFields.ProducerName->form.handleChange->ReForm.Helpers.handleChange}
                  error=None
                  tabIndex=1
                />
              </div>
              <div className=%twc("min-w-1/2 flex items-center")>
                <label htmlFor="orderer-name" className=%twc("whitespace-nowrap mr-4")>
                  {j`생산자번호`->React.string}
                </label>
                <Textarea
                  type_="text"
                  name="orderer-name"
                  placeholder=`생산자번호 입력(Enter 또는 “,”로 구분 가능, 최대 100개 입력 가능)`
                  className=%twc("flex-1")
                  value={form.values->FormFields.get(FormFields.ProducerCodes)}
                  onChange={FormFields.ProducerCodes
                  ->form.handleChange
                  ->ReForm.Helpers.handleChange}
                  error={FormFields.ProducerCodes->Form.ReSchema.Field->form.getFieldError}
                  rows=1
                  tabIndex=2
                  onKeyDown=handleKeyDownEnter
                />
              </div>
            </div>
            <div className=%twc("flex mt-3")>
              <div className=%twc("w-64 flex items-center mr-2")>
                <label htmlFor="product-identifier" className=%twc("block whitespace-nowrap w-16")>
                  {j`정산주기`->React.string}
                </label>
                <div className=%twc("flex-1 block relative")>
                  <span
                    className=%twc(
                      "flex items-center border border-border-default-L1 rounded-lg py-2 px-3 text-enabled-L1 bg-white leading-4.5"
                    )>
                    {settlementCycle->stringifySettlementCycle->React.string}
                  </span>
                  <span className=%twc("absolute top-1.5 right-2")>
                    <IconArrowSelect height="24" width="24" fill="#121212" />
                  </span>
                  <select
                    id="period"
                    value={stringifySettlementCycle(settlementCycle)}
                    className=%twc("block w-full h-full absolute top-0 opacity-0")
                    onChange={handleOnSelectSettlementCycle(setSettlementCycle)}>
                    <option value=`1주`> {j`1주`->React.string} </option>
                    <option value=`15일`> {j`15일`->React.string} </option>
                    <option value=`1개월`> {j`1개월`->React.string} </option>
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
              <PeriodSelector_Settlement
                from=query.from to_=query.to_ onSelect=handleOnChangeSettlementCycle
              />
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
          <input type_="submit" className=%twc("btn-level1") value=`검색` tabIndex=6 />
        </span>
      </div>
    </form>
  </div>
}
