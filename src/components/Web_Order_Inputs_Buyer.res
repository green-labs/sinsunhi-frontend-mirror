open ReactHookForm
open Web_Order_Util_Component
module Form = Web_Order_Buyer_Form

module ReceiverNameInput = {
  @react.component
  let make = () => {
    let {register, formState: {errors}} = Hooks.Context.use(.
      ~config=Hooks.Form.config(~mode=#onChange, ()),
      (),
    )
    let {ref, name, onChange, onBlur} = register(.
      Form.names.receiverName,
      Some(Hooks.Register.config(~required=true, ~maxLength=50, ())),
    )

    <div className=%twc("flex flex-col gap-2 xl:gap-0 xl:flex-row xl:items-baseline")>
      <label htmlFor=name className=%twc("xl:w-1/4 block font-bold text-text-L1")>
        {`이름`->React.string}
      </label>
      <div>
        <input
          id=name
          ref
          name
          onChange
          onBlur
          className=%twc("w-80 h-13 xl:h-9 px-3 border border-gray-300 rounded-lg")
          placeholder=`배송 받으실 분의 이름을 입력해주세요`
        />
        <ErrorMessage
          name
          errors
          render={_ =>
            <span className=%twc("flex mt-1")>
              <IconError width="20" height="20" />
              <span className=%twc("text-sm text-notice ml-1")>
                {`배송 받으실 분의 이름을 입력해주세요`->React.string}
              </span>
            </span>}
        />
      </div>
    </div>
  }
}

module ReceiverPhoneInput = {
  @react.component
  let make = () => {
    let {control, formState: {errors}} = Hooks.Context.use(.
      ~config=Hooks.Form.config(~mode=#onChange, ()),
      (),
    )

    let newValue = e =>
      (e->ReactEvent.Synthetic.currentTarget)["value"]
      ->Js.String2.slice(~from=0, ~to_=14)
      ->Js.String2.replaceByRe(%re("/[^0-9]/g"), "")
      ->(str =>
        switch str->Js.String.length == 12 {
        // length == 12는 안심번호로 간주 예시) 0502-0772-8543
        | true => str->Js.String2.replaceByRe(%re("/([0-9]{4})([0-9]{4})([0-9]{4})/"), "$1-$2-$3")
        | false =>
          str->Js.String2.replaceByRe(
            %re("/(^02.{0}|^01.{1}|[0-9]{3})([0-9]+)([0-9]{4})/"),
            "$1-$2-$3",
          )
        })
      ->Js.String2.replace("--", "-")

    let toPhoneFormat = (fn, e) => fn(Controller.OnChangeArg.value(e->newValue->Js.Json.string))

    <div className=%twc("flex flex-col gap-2 xl:gap-0 xl:flex-row xl:items-baseline")>
      <label
        htmlFor=Form.names.receiverPhone className=%twc("xl:w-1/4 block font-bold text-text-L1")>
        {`연락처`->React.string}
      </label>
      <div>
        <Controller
          name=Form.names.receiverPhone
          defaultValue={Js.Json.string("")}
          rules={Rules.make(~required=true, ~minLength=10, ())}
          control
          render={({field: {name, ref, value, onChange}}) => <>
            <input
              ref
              value={value->Js.Json.decodeString->Option.getWithDefault("")}
              className=%twc("w-80 h-13 xl:h-9 px-3 border border-gray-300 rounded-lg")
              placeholder=`배송 받으실 분의 연락처를 입력해주세요`
              onChange={toPhoneFormat(onChange)}
            />
            <ErrorMessage
              name
              errors
              render={_ =>
                <span className=%twc("flex mt-1")>
                  <IconError width="20" height="20" />
                  <span className=%twc("text-sm text-notice ml-1")>
                    {`배송 받으실 분의 연락처를 입력해주세요`->React.string}
                  </span>
                </span>}
            />
          </>}
        />
      </div>
    </div>
  }
}

module ReceiverAddressInput = {
  @react.component
  let make = () => {
    let {register, setValue, control, formState: {errors}} = Hooks.Context.use(.
      ~config=Hooks.Form.config(~mode=#all, ()),
      (),
    )
    let zipcodeRegister = register(.
      Form.names.receiverZipCode,
      Some(Hooks.Register.config(~required=true, ())),
    )
    let addressRegister = register(. Form.names.receiverAddress, None)

    let detailAdressRegister = register(.
      Form.names.receiverDetailAddress,
      Some(Hooks.Register.config(~required=true, ~maxLength=50, ())),
    )

    let handleOnClickSearchAddress = changeFn =>
      {
        _ => {
          open DaumPostCode
          let option = makeOption(~oncomplete=data => {
            changeFn(Controller.OnChangeArg.value(Js.Json.string(data.zonecode)))
            setValue(. Form.names.receiverAddress, Js.Json.string(data.address))
          }, ())
          let daumPostCode = option->make

          let openOption = makeOpenOption(~popupName="우편번호 검색", ())
          daumPostCode->openPostCode(openOption)
        }
      }->ReactEvents.interceptingHandler

    <div className=%twc("flex flex-col gap-2 xl:flex-row xl:gap-0 xl:items-baseline")>
      <label className=%twc("block font-bold text-text-L1 xl:w-1/4")>
        {`주소`->React.string}
      </label>
      <div className=%twc("flex flex-col gap-2 w-full xl:w-3/4 max-w-[320px] xl:max-w-full")>
        <div className=%twc("flex flex-col gap-1")>
          <Controller
            name=zipcodeRegister.name
            control
            defaultValue={Js.Json.string("")}
            rules={Rules.make(~required=true, ())}
            render={({field: {onChange, value, name, ref}}) => <>
              <div className=%twc("flex gap-1")>
                <input
                  readOnly=true
                  id=name
                  ref
                  value={value->Js.Json.decodeString->Option.getWithDefault("")}
                  name
                  onBlur=zipcodeRegister.onBlur
                  className=%twc(
                    "w-full xl:w-40 h-13 xl:h-9 px-3 border border-gray-300 rounded-lg bg-disabled-L3 text-disabled-L1"
                  )
                  placeholder=`우편번호`
                />
                <button
                  type_="button"
                  className=%twc(
                    "px-3 min-w-max py-1.5 h-13 xl:h-9 text-white bg-blue-gray-700 rounded-lg"
                  )
                  onClick={handleOnClickSearchAddress(onChange)}>
                  {`주소검색`->React.string}
                </button>
              </div>
              <ErrorMessage
                name=Form.names.receiverZipCode
                errors
                render={_ =>
                  <span className=%twc("flex")>
                    <IconError width="20" height="20" />
                    <span className=%twc("text-sm text-notice ml-1")>
                      {`'주소검색'을 통해 우편번호를 입력해주세요`->React.string}
                    </span>
                  </span>}
              />
            </>}
          />
        </div>
        <input
          readOnly=true
          id=addressRegister.name
          ref=addressRegister.ref
          name=addressRegister.name
          onChange=addressRegister.onChange
          onBlur=addressRegister.onBlur
          className=%twc(
            "w-full xl:w-3/4 xl:min-w-[20rem] h-13 xl:h-9 px-3 border border-gray-300 rounded-lg bg-disabled-L3 text-disabled-L1"
          )
          placeholder=`우편번호 찾기를 통해 주소입력이 가능합니다.`
        />
        <input
          id=detailAdressRegister.name
          ref=detailAdressRegister.ref
          name=detailAdressRegister.name
          onChange=detailAdressRegister.onChange
          onBlur=detailAdressRegister.onBlur
          className=%twc(
            "w-full xl:w-3/4 xl:min-w-[20rem] h-13 xl:h-9 px-3 border border-gray-300 rounded-lg "
          )
          placeholder=`상세주소를 입력해주세요.`
        />
        <ErrorMessage
          name=detailAdressRegister.name
          errors
          render={_ =>
            <span className=%twc("flex mt-1")>
              <IconError width="20" height="20" />
              <span className=%twc("text-sm text-notice ml-1")>
                {`상세주소를 입력해주세요`->React.string}
              </span>
            </span>}
        />
      </div>
    </div>
  }
}

module DeliveryMessageInput = {
  @react.component
  let make = (~selfMode=false) => {
    let {register, formState: {errors}} = Hooks.Context.use(.
      ~config=Hooks.Form.config(~mode=#onChange, ()),
      (),
    )
    let {ref, name, onChange, onBlur} = register(.
      Form.names.deliveryMessage,
      Some(Hooks.Register.config(~maxLength=100, ())),
    )

    <div
      className=%twc(
        "flex flex-col gap-2 xl:gap-0 max-w-[320px] xl:max-w-full xl:flex-row text-text-L1 xl:items-baseline"
      )>
      <label htmlFor=name className=%twc("xl:w-1/4 block font-bold")>
        {`${selfMode ? `수령시` : `배송`} 요청사항`->React.string}
      </label>
      <div className=%twc("w-full xl:w-3/4")>
        <input
          id=name
          ref
          name
          onChange
          onBlur
          className=%twc(
            "w-full xl:w-3/4 xl:min-w-[20rem] h-13 xl:h-9 px-3 border border-gray-300 rounded-lg"
          )
          placeholder={`${selfMode
              ? `수령`
              : `배송`}시 요청사항을 입력해주세요 (최대 100자)`}
        />
        <ErrorMessage
          name
          errors
          render={_ =>
            <span className=%twc("flex mt-1")>
              <IconError width="20" height="20" />
              <span className=%twc("text-sm text-notice ml-1")>
                {`최대 100자 까지 입력해주세요`->React.string}
              </span>
            </span>}
        />
      </div>
    </div>
  }
}

module DeliveryDesiredDateSelection = {
  @react.component
  let make = (~selfMode=false) => {
    let {control} = Hooks.Context.use(. ~config=Hooks.Form.config(~mode=#onChange, ()), ())

    let handleOnChangeDate = (fn, e) => {
      let newDate = (e->DuetDatePicker.DuetOnChangeEvent.detail).value
      newDate->Js.Json.string->Controller.OnChangeArg.value->fn
    }

    // 현재 시각 < 09시 => D+1(내일)
    // 현재 시각 > 09시 => D+2(모레)
    // 주말 선택 불가
    let minDate =
      Js.Date.make()
      ->DateFns.addHours(39)
      ->(
        t =>
          switch t->Js.Date.getDay {
          | 0. => t->DateFns.addDays(1)
          | 6. => t->DateFns.addDays(2)
          | _ => t
          }
      )

    <div
      className=%twc("flex flex-col xl:flex-row gap-2 xl:gap-0 w-80 xl:w-full xl:items-baseline")>
      <label className=%twc("xl:w-1/4 block font-bold")>
        {`${selfMode ? `수령` : `배송`} 희망일`->React.string}
      </label>
      <div className=%twc("flex flex-col gap-1 xl:w-3/4")>
        <div className=%twc("flex gap-2")>
          <Controller
            name={Form.names.deliveryDesiredDate}
            control
            shouldUnregister=true
            defaultValue={Js.Json.string(minDate->DateFns.format("yyy-MM-dd"))}
            render={({field: {onChange}}) => {
              <DatePicker
                id="from"
                isDateDisabled={d => d->Js.Date.getDay == 0. || d->Js.Date.getDay == 6.}
                date={minDate}
                onChange={handleOnChangeDate(onChange)}
                minDate={minDate->DateFns.format("yyyy-MM-dd")}
                firstDayOfWeek=0
              />
            }}
          />
          {switch selfMode {
          | true => React.null
          | false => <FreightDeliveryCost_Table_Buyer />
          }}
        </div>
        <span className=%twc("text-sm text-text-L2")>
          {`* 원하시는 날짜에 맞춰 물량 확보 및 ${selfMode
              ? `수령`
              : `배송`}이 가능한지 확인 후 연락 드립니다.`->React.string}
        </span>
      </div>
    </div>
  }
}

module PaymentMethodSelection = {
  @react.component
  let make = () => {
    let {register, formState: {errors}} = Hooks.Context.use(.
      ~config=Hooks.Form.config(~mode=#onChange, ()),
      (),
    )
    let {ref, name, onChange, onBlur} = register(.
      Form.names.paymentMethod,
      Some(Hooks.Register.config(~required=true, ())),
    )

    let watchValue = Hooks.WatchValues.use(
      Hooks.WatchValues.Text,
      ~config=Hooks.WatchValues.config(~name=Form.names.paymentMethod, ()),
      (),
    )

    <section className=%twc("flex flex-col gap-5 bg-white text-enabled-L1")>
      <span className=%twc("text-lg xl:text-xl font-bold")>
        {`결제 수단 선택`->React.string}
      </span>
      <div className=%twc("flex gap-2")>
        {[("card", `카드결제`), ("transfer", `계좌이체`)]
        ->Array.map(((value, n)) =>
          <label
            key=n
            className=%twc(
              "focus:outline-none focus-within:bg-primary-light focus-within:outline-none focus-within:rounded-xl"
            )>
            <input className=%twc("sr-only") type_="radio" id=name ref name onChange onBlur value />
            <RadioButton watchValue name=n value />
          </label>
        )
        ->React.array}
      </div>
      <ErrorMessage
        name
        errors
        render={_ =>
          <span className=%twc("flex")>
            <IconError width="20" height="20" />
            <span className=%twc("text-sm text-notice ml-1")>
              {`결제 수단을 선택해주세요`->React.string}
            </span>
          </span>}
      />
    </section>
  }
}
