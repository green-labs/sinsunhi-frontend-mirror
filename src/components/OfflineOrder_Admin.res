open ReactHookForm

let floatFixedNum = 2
let formatDate = (d, format) => d->Js.Date.fromString->Locale.DateTime.formatFromUTC(format)

let cutOffFloatDigits = (str, ~digit: int) =>
  switch str->Js.String2.search(%re("/\./")) {
  | -1 => str
  | d => str->Js.String2.substring(~from=0, ~to_=d + digit + 1)
  }->Js.String2.replaceByRe(%re("/,/g"), "")

module Item = {
  /*
   * Display: 보기
   * Edit: 수정
   * Pending: 수정 전
   */
  type mode = Display | Edit | Pending

  let mode_encode = mode => {
    switch mode {
    | Edit => true
    | Display
    | Pending => false
    }->Js.Json.boolean
  }

  let boolToMode = b => b ? Edit : Display

  module Table = {
    @react.component
    let make = (~order: CustomHooks.OfflineOrders.offlineOrder) => {
      let (mode, setMode) = React.Uncurried.useState(_ => Display)
      let {setValue} = Hooks.Context.use(. ~config=Hooks.Form.config(~mode=#onChange, ()), ())

      let checked = Hooks.WatchValues.use(
        Hooks.WatchValues.Checkbox,
        ~config=Hooks.WatchValues.config(~name=`${order.id->Int.toString}.checkbox`, ()),
        (),
      )
      let watchQuantitiesAndPrice = Hooks.WatchValues.use(
        Hooks.WatchValues.Texts,
        ~config=Hooks.WatchValues.config(
          ~name=[
            `${order.id->Int.toString}.order-quantity`,
            `${order.id->Int.toString}.order-quantity-complete`,
            `${order.id->Int.toString}.buyer-sell-price`,
          ],
          (),
        ),
        (),
      )
      let watchNewReleaseDueDate = Hooks.WatchValues.use(
        Hooks.WatchValues.Text,
        ~config=Hooks.WatchValues.config(~name=`${order.id->Int.toString}.release-due-date`, ()),
        (),
      )
      let watchNewOrderQuantity = Hooks.WatchValues.use(
        Hooks.WatchValues.Text,
        ~config=Hooks.WatchValues.config(~name=`${order.id->Int.toString}.order-quantity`, ()),
        (),
      )

      let quantitiesAndPrice =
        watchQuantitiesAndPrice
        ->Option.getWithDefault([])
        ->Array.map(i => i->Option.flatMap(Float.fromString))
        ->Array.zipBy([
          order.orderQuantity,
          order.confirmedOrderQuantity->Option.getWithDefault(0.),
          order.price,
        ])
        ->(zip => zip((a, default) => a->Option.getWithDefault(default)))

      let (newTotalOrderPrice, newTotalConfirmPrice) = quantitiesAndPrice->(
        arr => {
          switch arr {
          | [oQ, cQ, price] => (oQ *. price, cQ *. price)
          | _ => (0., 0.)
          }
        }
      )

      let newReleaseDueDate = watchNewReleaseDueDate->Option.getWithDefault(order.releaseDueDate)

      let newOrderQuantity =
        watchNewOrderQuantity
        ->Option.flatMap(Float.fromString)
        ->Option.getWithDefault(order.orderQuantity)

      let handleInputFloatChange = (fn, e) => {
        let value = (e->ReactEvent.Synthetic.target)["value"]
        setValue(. `${order.id->Int.toString}.checkbox`, true->Js.Json.boolean)

        fn(
          Controller.OnChangeArg.value(
            cutOffFloatDigits(value, ~digit=floatFixedNum)->Js.Json.string,
          ),
        )
      }

      let handleInputDateChange = (fn, e) => {
        setValue(. `${order.id->Int.toString}.checkbox`, true->Js.Json.boolean)

        fn(Controller.OnChangeArg.event(e))
      }

      let handleInputClick = _ => {
        switch mode {
        | Display => setMode(._ => Pending)
        | Pending
        | Edit => ()
        }
      }

      let isShowInput = mode !== Display

      let localeFloat = (str, ~digits) => {
        let number =
          str->Float.fromString->Option.mapWithDefault("0", x => x->Locale.Float.show(~digits))
        let point = Js.Re.test_(%re("/\.$/"), str) ? "." : ""

        number ++ point
      }

      let validateOnlyEditMode = mode == Pending

      React.useEffect1(() => {
        // submit 성공 후 form.reset 될때 mode도 바꿔주기 위해
        let mode = checked == Some(true) ? Edit : Display

        setMode(._ => mode)
        None
      }, [checked])

      let editStyle = if mode == Edit {
        %twc("bg-primary-light")
      } else {
        %twc("")
      }

      <>
        <li className={cx([%twc("grid grid-cols-12-gl-admin-offline text-text-L1"), editStyle])}>
          <div className=%twc("h-full flex flex-col px-4 py-2")>
            <Controller
              name={`${order.id->Int.toString}.checkbox`}
              defaultValue={Js.Json.boolean(false)}
              shouldUnregister=true
              render={({field: {onChange, value, name}}) =>
                <Checkbox
                  id={name}
                  name
                  onChange={e => {
                    onChange(Controller.OnChangeArg.event(e))
                  }}
                  checked={value->Js.Json.decodeBoolean->Option.getWithDefault(false)}
                />}
            />
          </div>
          <div className=%twc("h-full flex flex-col px-4 py-2")>
            <div> {order.orderProductId->React.string} </div>
            <div className=%twc("text-text-L3")> {order.orderNo->React.string} </div>
          </div>
          <div className=%twc("h-full flex flex-col px-4 py-2")>
            <div className=%twc("w-full relative")>
              <div
                className=%twc(
                  "w-full border border-border-default-L1 rounded-lg py-2 px-3 text-sm h-8 flex items-center"
                )
                onClick={handleInputClick}>
                {order.releaseDueDate->formatDate("yyyy. MM. dd. ")->React.string}
              </div>
              {isShowInput
                ? <Controller
                    name={`${order.id->Int.toString}.release-due-date`}
                    defaultValue={Js.Json.string(order.releaseDueDate->formatDate("yyyy-MM-dd"))}
                    shouldUnregister=true
                    rules={Rules.make(
                      ~validate=Js.Dict.fromArray([
                        (
                          "required",
                          Validation.sync(value => validateOnlyEditMode || value !== ""),
                        ),
                        (
                          "validDate",
                          Validation.sync(value =>
                            value
                            ->Js.Date.fromString
                            ->DateFns.isAfter(order.createdAt->Js.Date.fromString)
                            ->(isValid => validateOnlyEditMode || isValid)
                          ),
                        ),
                      ]),
                      (),
                    )}
                    render={({field: {onChange, value, name, ref}, fieldState: {error}}) =>
                      <span className=%twc("w-full absolute top-0 text-sm")>
                        <Input.InputWithRef
                          name
                          type_="date"
                          className=%twc("h-8")
                          value={value->Js.Json.decodeString->Option.getWithDefault("")}
                          onChange={onChange->handleInputDateChange}
                          min="2021-01-01"
                          error={error->Option.map(err =>
                            switch err.type_ {
                            | "required" => `값을 입력해주세요.`
                            | "validDate" => `발주일 이전으로 수정이 불가능합니다.`
                            | _ => `수정가능 조건을 확인하세요.`
                            }
                          )}
                          inputRef={ref}
                        />
                      </span>}
                  />
                : React.null}
            </div>
            <div className=%twc("w-full relative")>
              <div
                className=%twc(
                  "w-full border mt-1 border-border-default-L1 rounded-lg py-2 px-3 text-sm h-8 flex items-center"
                )
                onClick={handleInputClick}>
                {order.releaseDate
                ->Option.mapWithDefault(`연도. 월. 일. `, d => d->formatDate("yyyy. MM. dd. "))
                ->React.string}
              </div>
              {isShowInput
                ? <Controller
                    name={`${order.id->Int.toString}.release-date`}
                    defaultValue={Js.Json.string(
                      order.releaseDate
                      ->Option.map(d => d->formatDate("yyyy-MM-dd"))
                      ->Option.getWithDefault(""),
                    )}
                    shouldUnregister=true
                    rules={Rules.make(
                      ~validate=Js.Dict.fromArray([
                        (
                          "required",
                          Validation.sync(value => validateOnlyEditMode || value !== ""),
                        ),
                        (
                          "validDate",
                          Validation.sync(value =>
                            value
                            ->Js.Date.fromString
                            ->DateFns.isAfter(order.createdAt->Js.Date.fromString)
                            ->(isValid => validateOnlyEditMode || isValid)
                          ),
                        ),
                        (
                          "isNotBeforeDueDate",
                          Validation.sync(value =>
                            value
                            ->Js.Date.fromString
                            ->DateFns.isBefore(newReleaseDueDate->Js.Date.fromString)
                            ->not
                            ->(isValid => validateOnlyEditMode || isValid)
                          ),
                        ),
                      ]),
                      (),
                    )}
                    render={({field: {onChange, value, name, ref}, fieldState: {error}}) => {
                      <span className=%twc("w-full absolute top-1 text-sm")>
                        <Input.InputWithRef
                          name
                          type_="date"
                          className=%twc("h-8")
                          value={value->Js.Json.decodeString->Option.getWithDefault("")}
                          onChange={onChange->handleInputDateChange}
                          min="2021-01-01"
                          inputRef=ref
                          error={error->Option.map(err =>
                            switch err.type_ {
                            | "required" => `값을 입력해주세요.`
                            | "validDate" => `발주일 이전으로 수정이 불가능합니다.`
                            | "isNotBeforeDueDate" => `출고예정일보다 이전으로 수정이 불가능합니다. `
                            | _ => `수정가능 조건을 확인하세요.`
                            }
                          )}
                        />
                      </span>
                    }}
                  />
                : React.null}
            </div>
          </div>
          <div className=%twc("h-full flex flex-col px-4 py-2")>
            <div> {order.buyerName->React.string} </div>
            <div className=%twc("text-text-L3")> {order.buyerId->Int.toString->React.string} </div>
          </div>
          <div className=%twc("h-full flex flex-col px-4 py-2")>
            <div> {order.producerName->React.string} </div>
            <div className=%twc("text-text-L3")>
              {order.producerId->Int.toString->React.string}
            </div>
          </div>
          <div className=%twc("h-full flex flex-col px-4 py-2")>
            <div> {order.crop->React.string} </div>
            <div className=%twc("text-text-L3")> {order.cultivar->React.string} </div>
          </div>
          <div className=%twc("h-full flex flex-col px-4 py-2")> {order.sku->React.string} </div>
          <div className=%twc("h-full flex flex-col px-4 py-2 ml-2")>
            <div>
              {
                let unit =
                  order.weightUnit
                  ->CustomHooks.Products.weightUnit_encode
                  ->Js.Json.decodeString
                  ->Option.getWithDefault("g")

                order.weight
                ->Option.mapWithDefault("", w => `${w->Float.toString}${unit}`)
                ->React.string
              }
            </div>
            <div> {order.packageType->Option.mapWithDefault("", p => j`/${p}`)->React.string} </div>
          </div>
          <div className=%twc("h-full flex flex-col px-4 py-2 ml-3")>
            {order.grade->Option.getWithDefault("")->React.string}
          </div>
          <div className=%twc("h-full flex flex-col px-4 py-2 ml-3")>
            <div className=%twc("w-full relative")>
              <div
                className=%twc(
                  "w-full border border-border-default-L1 rounded-lg py-2 px-3 text-sm h-8 flex items-center"
                )
                onClick={handleInputClick}>
                {order.orderQuantity->Locale.Float.show(~digits=floatFixedNum)->React.string}
              </div>
              {isShowInput
                ? <Controller
                    name={`${order.id->Int.toString}.order-quantity`}
                    defaultValue={order.orderQuantity->Float.toString->Js.Json.string}
                    shouldUnregister=true
                    rules={Rules.make(
                      ~validate=Js.Dict.fromArray([
                        (
                          "required",
                          Validation.sync(value => validateOnlyEditMode || value !== ""),
                        ),
                      ]),
                      (),
                    )}
                    render={({field: {onChange, value, name, ref}, fieldState: {error}}) => {
                      let value' = value->Js.Json.decodeString->Option.getWithDefault("")

                      <span className=%twc("w-full absolute top-0 text-sm mb-2")>
                        <Input.InputWithRef
                          name
                          type_="text"
                          className=%twc("h-8")
                          value={value'->localeFloat(~digits=floatFixedNum)}
                          onChange={onChange->handleInputFloatChange}
                          error={error->Option.map(err =>
                            switch err.type_ {
                            | "required" => `값을 입력해주세요.`
                            | _ => `수정가능 조건을 확인하세요.`
                            }
                          )}
                          inputRef=ref
                        />
                      </span>
                    }}
                  />
                : React.null}
            </div>
            <div
              className=%twc(
                "mt-1 w-full bg-disabled-L3 border border-border-default-L1 rounded-lg py-2 px-3 text-sm h-8 flex items-center"
              )>
              {newTotalOrderPrice->Locale.Float.show(~digits=floatFixedNum)->React.string}
            </div>
          </div>
          <div className=%twc("h-full flex flex-col px-4 py-2")>
            <div className=%twc("w-full relative")>
              <div
                className=%twc(
                  "w-full border border-border-default-L1 rounded-lg py-2 px-3 text-sm h-8 flex items-center"
                )
                onClick={handleInputClick}>
                {order.confirmedOrderQuantity
                ->Option.getWithDefault(0.)
                ->Locale.Float.show(~digits=floatFixedNum)
                ->React.string}
              </div>
              {isShowInput
                ? <Controller
                    name={`${order.id->Int.toString}.order-quantity-complete`}
                    defaultValue={order.confirmedOrderQuantity
                    ->Option.getWithDefault(0.)
                    ->Float.toString
                    ->Js.Json.string}
                    shouldUnregister=true
                    rules={Rules.make(
                      ~validate=Js.Dict.fromArray([
                        (
                          "required",
                          Validation.sync(value => validateOnlyEditMode || value !== ""),
                        ),
                        (
                          "isNotOverOrderQuantity",
                          Validation.sync(value =>
                            value
                            ->Float.fromString
                            ->Option.map(value' => value' <= newOrderQuantity)
                            ->Option.getWithDefault(true)
                            ->(isValid => validateOnlyEditMode || isValid)
                          ),
                        ),
                      ]),
                      (),
                    )}
                    render={({field: {onChange, value, name, ref}, fieldState: {error}}) => {
                      let value' = value->Js.Json.decodeString->Option.getWithDefault("")

                      <span className=%twc("w-full absolute top-0 text-sm")>
                        <Input.InputWithRef
                          name
                          type_="text"
                          className=%twc("h-8")
                          value={value'->localeFloat(~digits=floatFixedNum)}
                          onChange={onChange->handleInputFloatChange}
                          error={error->Option.map(err =>
                            switch err.type_ {
                            | "required" => `값을 입력해주세요.`
                            | "isNotOverOrderQuantity" => `주문수량을 초과할 수 없습니다.`
                            | _ => `수정가능 조건을 확인하세요.`
                            }
                          )}
                          inputRef=ref
                        />
                      </span>
                    }}
                  />
                : React.null}
            </div>
            <div
              className=%twc(
                "mt-1 w-full bg-disabled-L3 border border-border-default-L1 rounded-lg py-2 px-3 text-sm h-8 flex items-center"
              )>
              {newTotalConfirmPrice->Locale.Float.show(~digits=floatFixedNum)->React.string}
            </div>
          </div>
          <div className=%twc("h-full flex flex-col px-4 py-2")>
            <div className=%twc("w-full relative")>
              <div
                className=%twc(
                  "w-full border border-border-default-L1 rounded-lg py-2 px-3 text-sm h-8 flex items-center"
                )
                onClick={handleInputClick}>
                {order.cost->Locale.Float.show(~digits=0)->React.string}
              </div>
              {isShowInput
                ? <Controller
                    name={`${order.id->Int.toString}.producer-product-cost`}
                    defaultValue={order.cost->Float.toString->Js.Json.string}
                    shouldUnregister=true
                    rules={Rules.make(
                      ~validate=Js.Dict.fromArray([
                        (
                          "required",
                          Validation.sync(value => validateOnlyEditMode || value !== ""),
                        ),
                      ]),
                      (),
                    )}
                    render={({field: {onChange, value, name, ref}, fieldState: {error}}) => {
                      <span className=%twc("w-full absolute top-0 text-sm")>
                        <Input.InputWithRef
                          name
                          type_="text"
                          className=%twc("h-8")
                          value={value
                          ->Js.Json.decodeString
                          ->Option.mapWithDefault("", s => s->localeFloat(~digits=0))}
                          onChange={onChange->handleInputFloatChange}
                          inputRef=ref
                          error={error->Option.map(err =>
                            switch err.type_ {
                            | "required" => `값을 입력해주세요.`
                            | _ => `수정가능 조건을 확인하세요.`
                            }
                          )}
                        />
                      </span>
                    }}
                  />
                : React.null}
            </div>
            <div className=%twc("w-full relative")>
              <div
                className=%twc(
                  "w-full mt-1 border border-border-default-L1 rounded-lg py-2 px-3 text-sm h-8 flex items-center"
                )
                onClick={handleInputClick}>
                {order.price->Locale.Float.show(~digits=0)->React.string}
              </div>
              {isShowInput
                ? <Controller
                    name={`${order.id->Int.toString}.buyer-sell-price`}
                    defaultValue={order.price->Float.toString->Js.Json.string}
                    shouldUnregister=true
                    rules={Rules.make(
                      ~validate=Js.Dict.fromArray([
                        (
                          "required",
                          Validation.sync(value => validateOnlyEditMode || value !== ""),
                        ),
                      ]),
                      (),
                    )}
                    render={({field: {onChange, value, name, ref}, fieldState: {error}}) =>
                      <span className=%twc("w-full absolute top-1 text-sm")>
                        <Input.InputWithRef
                          name
                          type_="text"
                          className=%twc("h-8")
                          value={value
                          ->Js.Json.decodeString
                          ->Option.mapWithDefault("", s => s->localeFloat(~digits=0))}
                          onChange={onChange->handleInputFloatChange}
                          inputRef=ref
                          error={error->Option.map(err =>
                            switch err.type_ {
                            | "required" => `값을 입력해주세요.`
                            | _ => `수정가능 조건을 확인하세요.`
                            }
                          )}
                        />
                      </span>}
                  />
                : React.null}
            </div>
          </div>
        </li>
      </>
    }
  }
}

@react.component
let make = (~order) => {
  <Item.Table order />
}
