open ReactHookForm

module Query = %relay(`
query ProductDetailBasicAdminQuery($nameMatch: String, $role: UserRole!) {
  users(name: $nameMatch, roles: [$role]) {
    edges {
      cursor
      node {
        id
        name
      }
    }
  }
}
`)

let getTextInputStyle = disabled => {
  let defaultStyle = %twc(
    "px-3 py-2 border border-border-default-L1 rounded-lg h-9 focus:outline-none min-w-1/2 max-w-2xl"
  )
  disabled ? cx([defaultStyle, %twc("bg-disabled-L3")]) : defaultStyle
}

module Form = {
  type formName = {
    producerName: string,
    producerProductName: string,
    buyerProductName: string,
    basePrice: string,
    origin: string,
    productCategory: string,
    displayCategories: string,
    operationStatus: string,
    tax: string,
    delivery: string,
  }

  let formName = {
    producerName: "producer-name",
    producerProductName: "producer-product-name",
    buyerProductName: "buyer-product-name",
    basePrice: "base-price",
    origin: "origin",
    productCategory: "product-category",
    displayCategories: "display-categories",
    operationStatus: "product-operation-status",
    tax: "product-tax",
    delivery: "product-delivery",
  }
}

module SelectProducerInput = {
  @react.component
  let make = (~name, ~defaultValue: option<ReactSelect.selectOption>, ~disabled=false) => {
    let {control, formState: {errors}} = Hooks.Context.use(.
      ~config=Hooks.Form.config(~mode=#onChange, ()),
      (),
    )

    let handleLoadOptions = inputValue => {
      Query.fetchPromised(
        ~environment=RelayEnv.envSinsunMarket,
        ~variables={
          nameMatch: Some(inputValue),
          role: #PRODUCER,
        },
        (),
      ) |> Js.Promise.then_((result: ProductDetailBasicAdminQuery_graphql.Types.rawResponse) => {
        let result' = result.users.edges->Array.map(edge => ReactSelect.Selected({
          value: edge.node.id,
          label: edge.node.name,
        }))

        Js.Promise.resolve(Some(result'))
      })
    }

    <div className=%twc("flex flex-col gap-2")>
      <div>
        <span className=%twc("font-bold")> {`생산자`->React.string} </span>
        <span className=%twc("text-notice")> {`*`->React.string} </span>
      </div>
      <div className=%twc("relative max-w-md w-1/3 h-9")>
        <div className=%twc("absolute w-full")>
          <Controller
            name
            control
            defaultValue={defaultValue->Option.mapWithDefault(
              Js.Json.null,
              ReactSelect.encoderRule,
            )}
            rules={Rules.make(~required=true, ())}
            render={({field: {onChange, value, ref}}) => <>
              <ReactSelect
                value={value
                ->ReactSelect.decoderRule
                ->Result.getWithDefault(ReactSelect.NotSelected)}
                loadOptions={Helper.Debounce.make1(handleLoadOptions, 500)}
                ref
                cacheOptions=false
                defaultOptions=false
                onChange={data =>
                  onChange(Controller.OnChangeArg.value(data->ReactSelect.encoderRule))}
                placeholder={`생산자명으로 찾기`}
                noOptionsMessage={_ => `검색 결과가 없습니다.`}
                isClearable=true
                isDisabled=disabled
                styles={ReactSelect.stylesOptions(
                  ~menu=(provide, _) => {
                    Js.Obj.assign(Js.Obj.empty(), provide)->Js.Obj.assign({
                      "position": "inherit",
                    })
                  },
                  ~control=(provide, _) => {
                    Js.Obj.assign(Js.Obj.empty(), provide)->Js.Obj.assign({
                      "minHeight": "unset",
                      "height": "2.25rem",
                    })
                  },
                  (),
                )}
              />
            </>}
          />
        </div>
      </div>
      <ErrorMessage
        name=Form.formName.producerName
        errors
        render={_ =>
          <span className=%twc("flex")>
            <IconError width="20" height="20" />
            <span className=%twc("text-sm text-notice ml-1")>
              {`생산자명을 입력해주세요.`->React.string}
            </span>
          </span>}
      />
    </div>
  }
}

module DisplayPriceInput = {
  @react.component
  let make = (~name, ~defaultValue: option<int>, ~disabled=false) => {
    let {control, formState: {errors}} = Hooks.Context.use(.
      ~config=Hooks.Form.config(~mode=#onChange, ()),
      (),
    )
    let valueEncode = (value: int) => value->Float.fromInt->Js.Json.number

    // locale format string 을 float로 변환
    let localeStringToFloat = (value: string) =>
      value
      ->Js.Re.exec_(%re("/^[\d,]+/"), _)
      ->Option.map(Js.Re.captures)
      ->Option.flatMap(Garter.Array.first)
      ->Option.flatMap(Js.Nullable.toOption)
      ->Option.map(Js.String2.replaceByRe(_, %re("/,/g"), ""))
      ->Option.flatMap(Float.fromString)

    <div className=%twc("flex flex-col gap-2")>
      <label className=%twc("block") htmlFor=Form.formName.basePrice>
        <span className=%twc("font-bold")>
          {`전시매장 노출 기준가격`->React.string}
        </span>
        <span className=%twc("text-notice")> {`*`->React.string} </span>
      </label>
      <Controller
        name
        control
        defaultValue={defaultValue->Option.mapWithDefault(Js.Json.string(""), valueEncode)}
        rules={Rules.make(~required=true, ())}
        render={({field: {onChange, value, name, ref}}) => {
          <input
          // value(number)를 locale format으로 변환
            value={value
            ->Js.Json.decodeNumber
            ->Option.mapWithDefault("", Locale.Float.show(~digits=0))}
            type_="text"
            id=name
            onChange={e => {
              let value = (e->ReactEvent.Synthetic.currentTarget)["value"]

              let validValue =
                value
                ->localeStringToFloat
                ->Option.map(Js.Json.number)
                ->Option.getWithDefault(Js.Json.string(""))

              onChange(Controller.OnChangeArg.value(validValue))
            }}
            ref
            disabled
            className={getTextInputStyle(disabled)}
            placeholder=`가격 입력(단위 원)`
          />
        }}
      />
      <ErrorMessage
        name=Form.formName.basePrice
        errors
        render={_ =>
          <span className=%twc("flex")>
            <IconError width="20" height="20" />
            <span className=%twc("text-sm text-notice ml-1")>
              {`전시매장 노출 기준가격을 입력해주세요.`->React.string}
            </span>
          </span>}
      />
    </div>
  }
}

module ReadOnlyProductId = {
  @react.component
  let make = (~productId) => {
    <div className=%twc("flex flex-col gap-2")>
      <div> <span className=%twc("font-bold")> {`상품번호`->React.string} </span> </div>
      <div
        className=%twc(
          "px-3 py-2 border border-border-default-L1 bg-disabled-L3 text-disabled-L1 rounded-lg h-9 max-w-md w-1/3"
        )>
        {switch productId {
        | Some(id) => <span className=%twc("text-enabled-L1")> {id->React.string} </span>
        | None =>
          <span className=%twc("text-disabled-L1")>
            {`저장 후 자동생성됩니다.`->React.string}
          </span>
        }}
      </div>
    </div>
  }
}

@react.component
let make = (
  ~productId=?,
  ~defaultProducer=?,
  ~defaultProducerName=?,
  ~defaultBuyerName=?,
  ~defaultBasePrice=?,
  ~defaultOperationstatus=?,
  ~defaultOrigin=?,
  ~defaultDeliveryMethod=?,
  ~defaultIsVat=?,
  ~producerNameDisabled=false,
  ~productCategoryDisabled=false,
  ~vatDisabled=false,
  ~displayCategoriesDisabled=false,
  ~producerProductNameDisabled=false,
  ~buyerProductNameDisabled=false,
  ~basePriceDisabled=false,
  ~operationStatusDisalbed=false,
  ~originDisabled=false,
  ~deliveryDisabled=false,
  ~allFieldsDisabled=false,
) => {
  let {register, control, formState: {errors}, setValue} = Hooks.Context.use(.
    ~config=Hooks.Form.config(~mode=#onChange, ()),
    (),
  )

  let (isShowProductOperationNoSale, setShowProductOperationNoSale) = React.Uncurried.useState(_ =>
    Dialog.Hide
  )

  let producerProductName = register(.
    Form.formName.producerProductName,
    Some(Hooks.Register.config(~required=true, ~maxLength=100, ())),
  )
  let buyerProductName = register(.
    Form.formName.buyerProductName,
    Some(Hooks.Register.config(~required=true, ~maxLength=100, ())),
  )

  let productOrigin = register(. Form.formName.origin, None)

  let getDisabled = disabled => allFieldsDisabled || disabled

  let handleProductOperation = (changeFn, status: Select_Product_Operation_Status.Base.status) => {
    switch status {
    | NOSALE => setShowProductOperationNoSale(._ => Dialog.Show)
    | _ =>
      changeFn(
        Controller.OnChangeArg.value(status->Select_Product_Operation_Status.Base.status_encode),
      )
    }
  }

  <>
    <div>
      <h2 className=%twc("text-text-L1 text-lg font-bold")> {j`기본정보`->React.string} </h2>
      <div className=%twc("divide-y text-sm")>
        <div className=%twc("py-6 flex flex-col space-y-6")>
          //상품유형
          <div className=%twc("flex flex-col gap-2")>
            <div>
              <span className=%twc(" font-bold")> {`상품유형`->React.string} </span>
              <span className=%twc("text-notice")> {`*`->React.string} </span>
            </div>
          </div>
          // 생산자
          <SelectProducerInput
            name={Form.formName.producerName}
            disabled={getDisabled(producerNameDisabled)}
            defaultValue={defaultProducer}
          />
          // 표준카테고리
          <div className=%twc("flex flex-col gap-2")>
            <div>
              <span className=%twc(" font-bold")> {`표준카테고리`->React.string} </span>
              <span className=%twc("text-notice")> {`*`->React.string} </span>
            </div>
            <Select_Product_Categories
              control
              name=Form.formName.productCategory
              disabled={getDisabled(productCategoryDisabled)}
            />
          </div>
          // 전시카테고리
          <div className=%twc("flex flex-col gap-2")>
            <div>
              <span className=%twc(" font-bold")> {`전시카테고리`->React.string} </span>
              <span className=%twc("text-notice")> {`*`->React.string} </span>
            </div>
            <Product_Detail_Display_Categories
              control
              name={Form.formName.displayCategories}
              disabled={getDisabled(displayCategoriesDisabled)}
            />
            <div />
          </div>
        </div>
        // 생산자용 상품명
        <div className=%twc("py-6 flex flex-col space-y-6")>
          <div className=%twc("flex flex-col gap-2")>
            <label className=%twc("block") htmlFor=producerProductName.name>
              <span className=%twc("font-bold")> {`생산자용 상품명`->React.string} </span>
              <span className=%twc("text-notice")> {`*`->React.string} </span>
            </label>
            <div>
              <input
                defaultValue={defaultProducerName->Option.getWithDefault("")}
                id=producerProductName.name
                name=producerProductName.name
                onChange=producerProductName.onChange
                onBlur=producerProductName.onBlur
                ref=producerProductName.ref
                className={getTextInputStyle(getDisabled(producerProductNameDisabled))}
                disabled={getDisabled(producerProductNameDisabled)}
                placeholder=`생산자용 상품명 입력(최대 100자)`
              />
              <ErrorMessage
                name=Form.formName.producerProductName
                errors
                render={_ =>
                  <span className=%twc("flex")>
                    <IconError width="20" height="20" />
                    <span className=%twc("text-sm text-notice ml-1")>
                      {`생산자용 상품명을 입력해주세요.(최대100자)`->React.string}
                    </span>
                  </span>}
              />
            </div>
          </div>
          // 바이어용 상품명
          <div className=%twc("flex flex-col gap-2")>
            <label className=%twc("block") htmlFor=buyerProductName.name>
              <span className=%twc("font-bold")> {`바이어용 상품명`->React.string} </span>
              <span className=%twc("text-notice")> {`*`->React.string} </span>
            </label>
            <input
              defaultValue={defaultBuyerName->Option.getWithDefault("")}
              id=buyerProductName.name
              name=buyerProductName.name
              onChange=buyerProductName.onChange
              onBlur=buyerProductName.onBlur
              ref=buyerProductName.ref
              className={getTextInputStyle(getDisabled(buyerProductNameDisabled))}
              disabled={getDisabled(buyerProductNameDisabled)}
              placeholder=`바이어용 상품명 입력, 상품매장에 노출됨(최대 100자)`
            />
            <ErrorMessage
              name=Form.formName.buyerProductName
              errors
              render={_ =>
                <span className=%twc("flex")>
                  <IconError width="20" height="20" />
                  <span className=%twc("text-sm text-notice ml-1")>
                    {`바이어용 상품명을 입력해주세요.(최대100자)`->React.string}
                  </span>
                </span>}
            />
          </div>
          //상품번호
          <ReadOnlyProductId productId />
          //기준가격
          <DisplayPriceInput
            name={Form.formName.basePrice}
            disabled={getDisabled(basePriceDisabled)}
            defaultValue={defaultBasePrice}
          />
        </div>
        <div className=%twc("py-6 flex flex-col space-y-6")>
          //운영상태
          <div className=%twc("flex gap-2 w-full")>
            <div className=%twc("flex flex-col gap-2 max-w-md w-1/3")>
              <div>
                <span className=%twc("font-bold")> {`운영상태`->React.string} </span>
                <span className=%twc("text-notice")> {`*`->React.string} </span>
              </div>
              <Controller
                name={Form.formName.operationStatus}
                control
                defaultValue=?{defaultOperationstatus->Option.map(
                  Select_Product_Operation_Status.Base.status_encode,
                )}
                rules={Rules.make(~required=true, ())}
                render={({field: {onChange, value, ref}}) =>
                  <div>
                    <Select_Product_Operation_Status.Base
                      status={value
                      ->Select_Product_Operation_Status.Base.status_decode
                      ->Result.mapWithDefault(None, status => Some(status))}
                      onChange={handleProductOperation(onChange)}
                      forwardRef={ref}
                      disabled={getDisabled(operationStatusDisalbed)}
                    />
                    <ErrorMessage
                      errors
                      name={Form.formName.operationStatus}
                      render={_ =>
                        <span className=%twc("flex")>
                          <IconError width="20" height="20" />
                          <span className=%twc("text-sm text-notice ml-1")>
                            {`운영상태를 선택해주세요.`->React.string}
                          </span>
                        </span>}
                    />
                  </div>}
              />
            </div>
            // 원산지
            <div className=%twc("flex flex-col gap-2 max-w-md w-1/3")>
              <label className=%twc("block") htmlFor=productOrigin.name>
                <span className=%twc("font-bold")> {`원산지`->React.string} </span>
              </label>
              <input
                defaultValue={defaultOrigin->Option.getWithDefault("")}
                id=productOrigin.name
                name=productOrigin.name
                onChange=productOrigin.onChange
                onBlur=productOrigin.onBlur
                ref=productOrigin.ref
                className={getTextInputStyle(getDisabled(originDisabled))}
                disabled={getDisabled(originDisabled)}
                placeholder=`원산지 입력(선택사항)`
              />
            </div>
          </div>
          // 과세여부
          <div className=%twc("flex gap-2")>
            <div className=%twc("flex gap-2 w-full")>
              <div className=%twc("flex flex-col gap-2 max-w-md w-1/3")>
                <div>
                  <span className=%twc("font-bold")> {`과세여부`->React.string} </span>
                  <span className=%twc("text-notice")> {`*`->React.string} </span>
                </div>
                <Controller
                  name={Form.formName.tax}
                  control
                  defaultValue=?{defaultIsVat->Option.map(Select_Tax_Status.status_encode)}
                  rules={Rules.make(~required=true, ())}
                  render={({field: {onChange, value, ref}}) =>
                    <div>
                      <Select_Tax_Status
                        status={value
                        ->Select_Tax_Status.status_decode
                        ->Result.mapWithDefault(None, status => Some(status))}
                        onChange={e => onChange(Controller.OnChangeArg.event(e))}
                        forwardRef={ref}
                        disabled={getDisabled(vatDisabled)}
                      />
                      <ErrorMessage
                        errors
                        name={Form.formName.tax}
                        render={_ =>
                          <span className=%twc("flex")>
                            <IconError width="20" height="20" />
                            <span className=%twc("text-sm text-notice ml-1")>
                              {`과면세여부를 선택해주세요.`->React.string}
                            </span>
                          </span>}
                      />
                    </div>}
                />
              </div>
              // 택배가능여부
              <div className=%twc("flex flex-col gap-2 max-w-md w-1/3")>
                <div>
                  <span className=%twc("font-bold")> {`택배가능여부`->React.string} </span>
                  <span className=%twc("text-notice")> {`*`->React.string} </span>
                </div>
                <Controller
                  name={Form.formName.delivery}
                  control
                  defaultValue=?{defaultDeliveryMethod->Option.map(Select_Delivery.status_encode)}
                  rules={Rules.make(~required=true, ())}
                  render={({field: {onChange, value, ref}}) =>
                    <div>
                      <Select_Delivery
                        status={value
                        ->Select_Delivery.status_decode
                        ->Result.mapWithDefault(None, status => Some(status))}
                        onChange={e => onChange(Controller.OnChangeArg.event(e))}
                        forwardRef={ref}
                        disabled={getDisabled(deliveryDisabled)}
                      />
                      <ErrorMessage
                        errors
                        name={Form.formName.delivery}
                        render={_ =>
                          <span className=%twc("flex")>
                            <IconError width="20" height="20" />
                            <span className=%twc("text-sm text-notice ml-1")>
                              {`택배가능여부를 선택해주세요.`->React.string}
                            </span>
                          </span>}
                      />
                    </div>}
                />
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <Dialog
      isShow=isShowProductOperationNoSale
      textOnConfirm=`확인`
      textOnCancel=`닫기`
      boxStyle=%twc("rounded-2xl text-center")
      kindOfConfirm=Dialog.Negative
      onConfirm={_ => {
        setValue(.
          Form.formName.operationStatus,
          NOSALE->Select_Product_Operation_Status.Base.status_encode,
        )
        setShowProductOperationNoSale(._ => Dialog.Hide)
      }}
      onCancel={_ => setShowProductOperationNoSale(._ => Dialog.Hide)}>
      <p>
        {`영구판매중지 상태를 선택 후 저장하시면`->React.string}
        <br />
        {`추후 해당 상품을 수정할 수 없습니다.`->React.string}
        <br />
        <br />
        {`영구판매중지 상태로 변경할까요?`->React.string}
      </p>
    </Dialog>
  </>
}
