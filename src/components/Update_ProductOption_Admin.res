/*
 *   1. 위치: 상품 내 단품리스트 - 리스트 아이템
 *
 *   2. 역할: 이미 생성 된, 단품의 리스트아이템을 수정할 수 있다 (삭제 불가)
 */

open ReactHookForm
module Select_Unit = Select_Product_Option_Unit
module Fragment = %relay(`
  fragment UpdateProductOptionAdminFragment on ProductOption {
    id
    optionName
    countPerPackageMax
    countPerPackageMin
    grade
    packageType
    perSizeMax
    perSizeMin
    perSizeUnit
    perWeightMax
    perWeightMin
    perWeightUnit
    weight
    weightUnit
    status
    cutOffTime
    memo
    stockSku
    ...UpdateProductOptionAdminAutoGenNameFragment
  }
`)

module DecodeProductOption = {
  let weightUnit = unit => {
    switch unit {
    | #G => Select_Unit.WeightStatus.G
    | #KG => Select_Unit.WeightStatus.KG
    | #T => Select_Unit.WeightStatus.T
    | _ => Select_Unit.WeightStatus.G
    }
  }

  let perWeightUnit = unit => {
    switch unit {
    | #G => Select_Unit.WeightStatus.G
    | #KG => Select_Unit.WeightStatus.KG
    | #T => Select_Unit.WeightStatus.T
    | _ => Select_Unit.WeightStatus.G
    }
  }

  let perSizeUnit = unit => {
    switch unit {
    | #MM => Select_Unit.SizeStatus.MM
    | #CM => Select_Unit.SizeStatus.CM
    | #M => Select_Unit.SizeStatus.M
    | _ => Select_Unit.SizeStatus.MM
    }
  }

  let status = statusFromApi => {
    switch statusFromApi {
    | #SALE => Select_Product_Operation_Status.BaseStatus.SALE
    | #SOLDOUT => Select_Product_Operation_Status.BaseStatus.SOLDOUT
    | #NOSALE => Select_Product_Operation_Status.BaseStatus.NOSALE
    | #HIDDEN_SALE => Select_Product_Operation_Status.BaseStatus.HIDDEN_SALE
    | #RETIRE => Select_Product_Operation_Status.BaseStatus.RETIRE
    | _ => Select_Product_Operation_Status.BaseStatus.SALE
    }
  }

  let stringifyStatus = statusFromApi => {
    switch statusFromApi {
    | #SALE => "SALE"
    | #SOLDOUT => "SOLDOUT"
    | #NOSALE => "NOSALE"
    | #HIDDEN_SALE => "HIDDEN_SALE"
    | #RETIRE => "RETIRE"
    | _ => "SALE"
    }
  }

  let hasEach = (
    ~countPerPackageMax: option<int>,
    ~countPerPackageMin: option<int>,
    ~perSizeMax: option<float>,
    ~perSizeMin: option<float>,
    ~perSizeUnit: option<Select_Unit.Size.status>,
    ~perWeightUnit: option<Select_Unit.Weight.status>,
  ) => {
    //입수 관련 값이 하나라도 있으면 입수 내용을 보여준다.
    switch (
      countPerPackageMax,
      countPerPackageMin,
      perSizeMax,
      perSizeMin,
      perSizeUnit,
      perWeightUnit,
    ) {
    | (None, None, None, None, None, None) => false
    | _ => true
    }
  }
}

module Each = {
  @react.component
  let make = (
    ~minNum: option<int>,
    ~maxNum: option<int>,
    ~weight: option<float>,
    ~weightUnit: option<Select_Unit.Weight.status>,
    ~perWeightMin: option<float>,
    ~perWeightMax: option<float>,
    ~perWeightUnit: option<Select_Unit.Weight.status>,
    ~minSize: option<float>,
    ~maxSize: option<float>,
    ~sizeUnit: option<Select_Unit.Size.status>,
  ) => {
    <div className=%twc("py-6 flex flex-col gap-2")>
      <div className=%twc("flex gap-2 items-center")>
        <label className=%twc("block")> {`입수 정보`->React.string} </label>
        <div
          className=%twc(
            "px-3 py-2 border border-border-default-L1 rounded-lg h-9 bg-disabled-L3 w-36 leading-4.5"
          )>
          {`${weight->Option.mapWithDefault("", Float.toString)}
          ${weightUnit->Option.mapWithDefault("", Select_Unit.Weight.toString)}`->React.string}
        </div>
        <div>
          <div
            className={%twc(
              "px-3 py-2 border border-border-default-L1 rounded-lg h-9 focus:outline-none bg-disabled-L3 w-36"
            )}>
            {minNum->Option.mapWithDefault("", Int.toString)->React.string}
          </div>
        </div>
        <span> {`~`->React.string} </span>
        <div>
          <div
            className={%twc(
              "px-3 py-2 border border-border-default-L1 rounded-lg h-9 focus:outline-none bg-disabled-L3 w-36"
            )}>
            {maxNum->Option.mapWithDefault("", Int.toString)->React.string}
          </div>
        </div>
      </div>
      <div className=%twc("flex gap-4 flex-wrap")>
        <div className=%twc("flex gap-2 items-center pr-4 border-r border-div-border-L2")>
          <label className=%twc("block shrink-0")> {`개당 무게`->React.string} </label>
          <div
            className=%twc(
              "px-3 py-2 border border-border-default-L1 rounded-lg h-9 bg-disabled-L3 w-36 text-disabled-L1 leading-4.5 focus:outline-none"
            )>
            {perWeightMin->Option.mapWithDefault("", Float.toString)->React.string}
          </div>
          <span> {`~`->React.string} </span>
          <div
            className=%twc(
              "px-3 py-2 border border-border-default-L1 rounded-lg h-9 bg-disabled-L3 w-36 text-disabled-L1 leading-4.5 focus:outline-none"
            )>
            {perWeightMax->Option.mapWithDefault("", Float.toString)->React.string}
          </div>
          <Select_Unit.Weight
            disabled=true
            status={perWeightUnit->Option.getWithDefault(Select_Unit.WeightStatus.G)}
            onChange={_ => ()}
          />
        </div>
        <div className=%twc("flex gap-2 items-center")>
          <label className=%twc("block shrink-0")> {`개당 크기`->React.string} </label>
          <div>
            <div
              className={%twc(
                "px-3 py-2 border border-border-default-L1 rounded-lg h-9 focus:outline-none shrink bg-disabled-L3 w-36"
              )}>
              {minSize->Option.mapWithDefault("", Float.toString)->React.string}
            </div>
          </div>
          <span> {`~`->React.string} </span>
          <div>
            <div
              className={%twc(
                "px-3 py-2 border border-border-default-L1 rounded-lg h-9 focus:outline-none shrink bg-disabled-L3 w-36"
              )}>
              {maxSize->Option.mapWithDefault("", Float.toString)->React.string}
            </div>
          </div>
          <Select_Unit.Size
            disabled=true
            status={sizeUnit->Option.getWithDefault(Select_Unit.SizeStatus.MM)}
            onChange={_ => ()}
          />
        </div>
      </div>
    </div>
  }
}

module Form = {
  @spice
  type submit = {
    id: string,
    name: option<string>,
    @spice.key("operation-status") operationStatus: Select_Product_Operation_Status.Base.status,
    @spice.key("cut-off-time") cutOffTime: option<string>,
    @spice.key("memo") memo: option<string>,
    @spice.key("auto-generated-name") autoGenName: string,
  }

  type inputNames = {
    id: string,
    name: string,
    operationStatus: string,
    cutOffTime: string,
    memo: string,
    autoGenName: string,
  }

  let makeInputNames = prefix => {
    id: `${prefix}.id`,
    name: `${prefix}.name`,
    operationStatus: `${prefix}.operation-status`,
    cutOffTime: `${prefix}.cut-off-time`,
    memo: `${prefix}.memo`,
    autoGenName: `${prefix}.auto-generated-name`,
  }

  // 단품 수정 폼 정보를 이용하여 단품 생성 폼을 만든다
  let makeAddProductOptionDefaultValue = (
    ~values: submit,
    ~grade,
    ~packageType,
    ~countPerPackageMax,
    ~countPerPackageMin,
    ~perSizeMax,
    ~perSizeMin,
    ~perSizeUnit,
    ~perWeightUnit,
    ~weight,
    ~weightUnit,
  ) => {
    let names = Add_ProductOption_Admin.Form.names

    let fields = [
      (names.name, values.name->Option.mapWithDefault(Js.Json.null, Js.Json.string)),
      (names.grade, grade->Option.mapWithDefault(Js.Json.null, Js.Json.string)),
      (names.package, packageType->Option.mapWithDefault(Js.Json.null, Js.Json.string)),
      (names.weight, weight->Option.mapWithDefault(Js.Json.null, Js.Json.number)),
      (
        names.weightUnit,
        weightUnit->Option.mapWithDefault(Js.Json.null, Select_Unit.Weight.status_encode),
      ),
      (
        names.operationStatus,
        values.operationStatus->Select_Product_Operation_Status.Base.status_encode,
      ),
      (names.buyerPrice, Js.Json.null),
      (
        "cost",
        [
          ("effective-date", Js.Date.make()->DateFns.format("yyyy-MM-dd")->Js.Json.string),
          ("raw-cost", Js.Json.null),
          ("working-cost", Js.Json.null),
          ("delivery-cost", Js.Json.null),
          ("buyer-price", Js.Json.null),
        ]
        ->Js.Dict.fromArray
        ->Js.Json.object_,
      ),
      (names.cutOffTime, values.cutOffTime->Option.mapWithDefault(Js.Json.null, Js.Json.string)),
      (names.memo, values.memo->Option.mapWithDefault(Js.Json.null, Js.Json.string)),
    ]

    let each = switch DecodeProductOption.hasEach(
      ~countPerPackageMax,
      ~countPerPackageMin,
      ~perSizeMax,
      ~perSizeMin,
      ~perSizeUnit,
      ~perWeightUnit,
    ) {
    | true => {
        let names = Product_Option_Each_Admin.Form.names
        //입수정보 값 넣어주기
        [
          (Add_ProductOption_Admin.Form.names.showEach, true->Js.Json.boolean),
          (
            "each",
            [
              (
                names.unitWeight,
                perWeightUnit
                ->Option.getWithDefault(Select_Unit.WeightStatus.KG)
                ->Select_Unit.Weight.status_encode,
              ),
              (names.minSize, perSizeMin->Option.mapWithDefault(Js.Json.null, Js.Json.number)),
              (names.maxSize, perSizeMax->Option.mapWithDefault(Js.Json.null, Js.Json.number)),
              (
                names.unitSize,
                perSizeUnit
                ->Option.getWithDefault(Select_Unit.SizeStatus.MM)
                ->Select_Unit.Size.status_encode,
              ),
              (
                names.minNum,
                countPerPackageMin->Option.mapWithDefault(Js.Json.null, i =>
                  i->Int.toFloat->Js.Json.number
                ),
              ),
              (
                names.maxNum,
                countPerPackageMax->Option.mapWithDefault(Js.Json.null, i =>
                  i->Int.toFloat->Js.Json.number
                ),
              ),
            ]
            ->Js.Dict.fromArray
            ->Js.Json.object_,
          ),
        ]
      }
    | false => []
    }

    fields->Array.concat(each)->Js.Dict.fromArray->Js.Json.object_
  }
}

module ReadOnlyOptionId = {
  @react.component
  let make = (~inputName, ~value) => {
    let {register} = Hooks.Context.use(. ~config=Hooks.Form.config(~mode=#onChange, ()), ())
    let {ref, name} = register(. inputName, None)

    // Update 타겟인 단품의 ID를 폼으로 전달하기 위한 Hidden Input
    <input type_="hidden" id=name ref name defaultValue=value />
  }
}

module EditName = {
  @react.component
  let make = (~inputName, ~defaultValue, ~disabled) => {
    let {register} = Hooks.Context.use(. ~config=Hooks.Form.config(~mode=#onChange, ()), ())
    let {ref, name, onChange, onBlur} = register(. inputName, None)

    let disabledStyle = disabled ? %twc("bg-gray-100 focus:outline-none") : %twc("")

    <input
      id=name
      ref
      name
      onChange
      onBlur
      readOnly={disabled}
      className={cx([
        %twc("px-3 py-2 border border-gray-300 rounded-lg h-9 w-1/3 max-w-sm"),
        disabledStyle,
      ])}
      placeholder=`단품명 입력(커스텀)`
      defaultValue
    />
  }
}

module ReadOnlyAutoGenName = {
  module Fragment = %relay(`
  fragment UpdateProductOptionAdminAutoGenNameFragment on ProductOption {
    grade
    packageType
    weight
    weightUnit
    perWeightUnit
    countPerPackageMin
    countPerPackageMax
    perSizeMin
    perSizeMax
    perSizeUnit
  }
`)
  @react.component
  let make = (~inputName, ~query) => {
    let {
      grade,
      packageType,
      weight,
      weightUnit,
      countPerPackageMin,
      countPerPackageMax,
      perWeightUnit,
      perSizeUnit,
      perSizeMin,
      perSizeMax,
    } = Fragment.use(query)

    let {register} = Hooks.Context.use(. ~config=Hooks.Form.config(~mode=#onChange, ()), ())
    let {ref, name} = register(. inputName, None)

    let parsedWeightUnit = weightUnit->Option.map(DecodeProductOption.weightUnit)
    let parsedPerWeightUnit = perWeightUnit->Option.map(DecodeProductOption.perWeightUnit)
    let parsedPerSizeUnit = perSizeUnit->Option.map(DecodeProductOption.perSizeUnit)

    let autoGenName = Add_ProductOption_Admin.makeAutoGeneratedName(
      ~grade,
      ~package={packageType},
      ~weight={weight->Option.map(Float.toString)},
      ~numMin={countPerPackageMin->Option.map(Int.toString)},
      ~numMax={countPerPackageMax->Option.map(Int.toString)},
      ~sizeMin={perSizeMin->Option.map(Float.toString)},
      ~sizeMax={perSizeMax->Option.map(Float.toString)},
      ~weightUnit={parsedWeightUnit->Option.map(Select_Unit.Weight.toString)},
      ~perWeightUnit={parsedPerWeightUnit->Option.map(Select_Unit.Weight.toString)},
      ~sizeUnit={parsedPerSizeUnit->Option.map(Select_Unit.Size.toString)},
      ~showEach={true},
      (),
    )

    <input
      className=%twc(
        "px-3 py-2 border border-gray-300 bg-gray-100 rounded-lg h-9 w-1/3 max-w-sm text-gray-500"
      )
      id=name
      ref
      name
      defaultValue=autoGenName
      readOnly=true
      placeholder=`자동생성 단품명(자동으로 생성)`
    />
  }
}

module ReadOnlyStockSku = {
  @react.component
  let make = (~value) => {
    <div
      className=%twc("h-9 w-1/6 max-w-xs px-3 py-2 border border-gray-300 bg-gray-100 rounded-lg")>
      <span className=%twc("text-gray-500")> {value->React.string} </span>
    </div>
  }
}

module ReadOnlyGrade = {
  @react.component
  let make = (~value) => {
    <div className=%twc("flex flex-col gap-2  w-1/3 max-w-sm")>
      <label className=%twc("font-bold")> {`등급(용도)`->React.string} </label>
      <div
        className=%twc("px-3 py-2 border border-gray-300 text-gray-800 bg-gray-100 rounded-lg h-9")>
        {value->Option.getWithDefault("")->React.string}
      </div>
    </div>
  }
}

module ReadOnlyPackage = {
  @react.component
  let make = (~value) => {
    <div className=%twc("flex flex-col gap-2  w-1/3 max-w-sm")>
      <span className=%twc("font-bold")> {`포장재질`->React.string} </span>
      <div
        className=%twc("px-3 py-2 border border-gray-300 text-gray-800 bg-gray-100 rounded-lg h-9")>
        {value->Option.getWithDefault("")->React.string}
      </div>
    </div>
  }
}

module ReadOnlyWeight = {
  @react.component
  let make = (~value, ~unit, ~showEach) => {
    <div className=%twc("py-6 flex flex-col gap-2")>
      <div>
        <span className=%twc("font-bold")> {`중량`->React.string} </span>
        <span className=%twc("text-red-500")> {`*`->React.string} </span>
      </div>
      <div className=%twc("flex")>
        <div className=%twc("flex-nowrap flex gap-2")>
          <div>
            <div className=%twc("px-3 py-2 border border-gray-300 bg-gray-100 rounded-lg h-9 w-36")>
              {value->Option.mapWithDefault("", Float.toString)->React.string}
            </div>
          </div>
          <Select_Unit.Weight
            disabled=true
            status={unit->Option.mapWithDefault(
              Select_Unit.WeightStatus.G,
              DecodeProductOption.weightUnit,
            )}
            onChange={_ => ()}
          />
          <div className=%twc("flex gap-2 items-center grow")>
            <Checkbox disabled=true checked={showEach} />
            <label> {`입수 정보 확인`->React.string} </label>
          </div>
        </div>
      </div>
    </div>
  }
}

module EditStatus = {
  @react.component
  let make = (~inputName, ~defaultValue, ~disabled) => {
    let {control, formState: {errors}} = Hooks.Context.use(.
      ~config=Hooks.Form.config(~mode=#onChange, ()),
      (),
    )

    let toJson = statusFromApi => {
      statusFromApi->DecodeProductOption.status->Select_Product_Operation_Status.Base.status_encode
    }

    let toStatus = statusFromSelect => {
      statusFromSelect
      ->Select_Product_Operation_Status.Base.status_decode
      ->Result.mapWithDefault(None, v => Some(v))
    }

    <div className=%twc("flex flex-col gap-2 grow")>
      <label className=%twc("block")>
        <span className=%twc("font-bold")> {`운영상태`->React.string} </span>
        <span className=%twc("text-red-500")> {`*`->React.string} </span>
      </label>
      <span className=%twc("w-44 h-9")>
        <Controller
          name=inputName
          control
          defaultValue={defaultValue->toJson}
          rules={Rules.make(~required=true, ())}
          render={({field: {ref, name, value, onChange}}) => {
            <div>
              <Select_Product_Operation_Status.Base
                forwardRef=ref
                status={value->toStatus}
                onChange={selected => {
                  selected
                  ->Select_Product_Operation_Status.Base.status_encode
                  ->Controller.OnChangeArg.value
                  ->onChange
                }}
                disabled
              />
              <ErrorMessage
                errors
                name
                render={_ => {
                  <span className=%twc("flex")>
                    <IconError width="20" height="20" />
                    <span className=%twc("text-sm text-notice ml-1")>
                      {`운영상태를 입력해주세요.`->React.string}
                    </span>
                  </span>
                }}
              />
            </div>
          }}
        />
      </span>
    </div>
  }
}

module EditCutOffTime = {
  @react.component
  let make = (~inputName, ~disabled, ~defaultValue) => {
    let {register, formState: {errors}} = Hooks.Context.use(.
      ~config=Hooks.Form.config(~mode=#onChange, ()),
      (),
    )
    let {ref, name, onChange, onBlur} = register(.
      inputName,
      Some(Hooks.Register.config(~maxLength=100, ())),
    )

    let disabledStyle = disabled ? %twc("bg-gray-100 focus:outline-none") : %twc("")

    <div className=%twc("flex flex-col gap-2 min-w-1/2 max-w-2xl")>
      <label htmlFor=name>
        <span className=%twc("font-bold")> {`출고기준시간`->React.string} </span>
      </label>
      <textarea
        id=name
        ref
        name
        onBlur
        onChange
        readOnly={disabled}
        className={cx([
          %twc("px-3 py-2 border border-gray-300 rounded-lg focus:outline-none h-9"),
          disabledStyle,
        ])}
        placeholder=`출고기준시간 입력(최대 100자)`
        defaultValue={defaultValue->Option.getWithDefault("")}
      />
      <ErrorMessage
        errors
        name
        render={_ => {
          <span className=%twc("flex")>
            <IconError width="20" height="20" />
            <span className=%twc("text-sm text-notice ml-1")>
              {`최대 100자까지 입력가능합니다.`->React.string}
            </span>
          </span>
        }}
      />
    </div>
  }
}

module EditMemo = {
  @react.component
  let make = (~inputName, ~disabled, ~defaultValue) => {
    let {register, formState: {errors}} = Hooks.Context.use(.
      ~config=Hooks.Form.config(~mode=#onChange, ()),
      (),
    )
    let {ref, name, onChange, onBlur} = register(.
      inputName,
      Some(Hooks.Register.config(~maxLength=100, ())),
    )
    let disabledStyle = disabled ? %twc("bg-gray-100 focus:outline-none") : %twc("")

    <div className=%twc("flex flex-col gap-2 min-w-1/2 max-w-2xl")>
      <label htmlFor=name>
        <span className=%twc("font-bold")> {`메모`->React.string} </span>
      </label>
      <textarea
        id=name
        ref
        name
        onChange
        onBlur
        readOnly={disabled}
        className={cx([
          %twc("px-3 py-2 border border-gray-300 rounded-lg focus:outline-none h-9"),
          disabledStyle,
        ])}
        placeholder=`메모사항 입력(최대 100자)`
        defaultValue={defaultValue->Option.getWithDefault("")}
      />
      <ErrorMessage
        errors
        name
        render={_ => {
          <span className=%twc("flex")>
            <IconError width="20" height="20" />
            <span className=%twc("text-sm text-notice ml-1")>
              {`최대 100자까지 입력가능합니다.`->React.string}
            </span>
          </span>
        }}
      />
    </div>
  }
}

@react.component
let make = (
  ~prefix,
  ~index,
  ~prepend: Hooks.FieldArray.prepend,
  ~productDisplayName,
  ~applyAll,
  ~setApplyAll,
  ~query,
) => {
  //prefix 형식 : options.[index]
  let productOption = Fragment.use(query)
  let disabled = productOption.status == #RETIRE

  let {getValues, trigger} = Hooks.Context.use(. ~config=Hooks.Form.config(~mode=#onChange, ()), ())

  let inputNames = Form.makeInputNames(prefix)

  let weightUnit = productOption.weightUnit->Option.map(DecodeProductOption.weightUnit)
  let perWeightUnit = productOption.perWeightUnit->Option.map(DecodeProductOption.perWeightUnit)
  let perSizeUnit = productOption.perSizeUnit->Option.map(DecodeProductOption.perSizeUnit)

  let showEach = DecodeProductOption.hasEach(
    ~countPerPackageMax=productOption.countPerPackageMax,
    ~countPerPackageMin=productOption.countPerPackageMin,
    ~perSizeMax=productOption.perSizeMax,
    ~perSizeMin=productOption.perSizeMin,
    ~perSizeUnit,
    ~perWeightUnit,
  )

  let onClickCopy = ReactEvents.interceptingHandler(_ => {
    setApplyAll(._ => false)

    let values = getValues(. [prefix])->Js.Json.decodeArray->Option.flatMap(Garter.Array.first)
    switch values->Option.map(Form.submit_decode) {
    | Some(Ok(v)) => {
        let {
          grade,
          packageType,
          countPerPackageMin,
          countPerPackageMax,
          perSizeMax,
          perSizeMin,
          weight,
        } = productOption
        prepend(.
          Form.makeAddProductOptionDefaultValue(
            ~values=v,
            ~grade,
            ~packageType,
            ~countPerPackageMax,
            ~countPerPackageMin,
            ~perSizeMax,
            ~perSizeMin,
            ~weight,
            ~perSizeUnit,
            ~perWeightUnit,
            ~weightUnit,
          ),
          ~focusOptions=Hooks.FieldArray.focusOptions(~shouldFocus=true, ()),
          (),
        )->ignore
      }
    | _ => ()
    }->ignore
  })

  let onClickApplyAll = ReactEvents.interceptingHandler(_ => {
    setApplyAll(.prev => !prev)
  })

  React.useLayoutEffect0(_ => {
    // 복사하기 전 폼의 내용을 채우기 위하여 validation을 한번 호출한다.
    // 초기상태에서는 validation 을 호출하지 않는한 폼의 내용이 비어있다.
    trigger(. inputNames.id)
    None
  })

  <RadixUI.Collapsible.Root defaultOpen={true}>
    <div className=%twc("bg-bg-pressed-L1 border border-div-border-L2 px-3 py-7 rounded text-sm")>
      <div className=%twc("flex flex-col gap-6 ")>
        <div className=%twc("flex flex-col gap-2")>
          <div className=%twc("flex justify-between")>
            <div className=%twc("flex items-center")>
              <span className=%twc("block font-bold")> {`단품 기본정보`->React.string} </span>
              <div className=%twc("flex gap-2 ml-2")>
                <button
                  onClick={onClickCopy}
                  className=%twc("px-2 py-1 bg-primary text-white focus:outline-none rounded")>
                  {`복사하기`->React.string}
                </button>
              </div>
            </div>
            <RadixUI.Collapsible.Trigger className=%twc("collabsible-trigger")>
              <div className=%twc("flex items-center cursor-pointer relative gap-1")>
                <span className=%twc("underline")> {`단품정보 접기`->React.string} </span>
                <IconArrow
                  height="15" width="15" fill="#000000" className=%twc("transform -rotate-90")
                />
              </div>
            </RadixUI.Collapsible.Trigger>
          </div>
          <div className=%twc("flex gap-2")>
            <ReadOnlyOptionId inputName=inputNames.id value=productOption.id />
            <EditName
              key=productOption.optionName
              inputName=inputNames.name
              defaultValue=productOption.optionName
              disabled
            />
            <ReadOnlyAutoGenName
              inputName=inputNames.autoGenName query=productOption.fragmentRefs
            />
            <ReadOnlyStockSku value=productOption.stockSku />
          </div>
        </div>
      </div>
      <RadixUI.Collapsible.Content className=%twc("collabsible-content")>
        <div className=%twc("divide-y")>
          <div className=%twc("flex gap-4 py-6")>
            <ReadOnlyGrade value=productOption.grade />
            <ReadOnlyPackage value=productOption.packageType />
          </div>
          <ReadOnlyWeight value=productOption.weight unit=productOption.weightUnit showEach />
          {showEach
            ? <Each
                minNum={productOption.countPerPackageMin}
                maxNum={productOption.countPerPackageMax}
                weight={productOption.weight}
                weightUnit={weightUnit}
                perWeightMin={productOption.perWeightMin}
                perWeightMax={productOption.perWeightMax}
                perWeightUnit={perWeightUnit}
                minSize={productOption.perSizeMin}
                maxSize={productOption.perSizeMax}
                sizeUnit={perSizeUnit}
              />
            : React.null}
          <div className=%twc("flex flex-col gap-6 py-6 w-full")>
            <span className=%twc("text-text-L2")>
              {`*단품 가격정보는 단품 가격관리에서 수정이 가능합니다.`->React.string}
            </span>
            <div className=%twc("flex gap-4 w-2/3 max-w-2xl")>
              <EditStatus
                key={productOption.status->DecodeProductOption.stringifyStatus}
                inputName=inputNames.operationStatus
                defaultValue=productOption.status
                disabled
              />
            </div>
          </div>
          <div className=%twc("flex flex-col gap-6 py-6 w-full")>
            <EditCutOffTime
              key=?productOption.cutOffTime
              inputName=inputNames.cutOffTime
              defaultValue=productOption.cutOffTime
              disabled
            />
            <EditMemo
              key=?productOption.memo
              inputName=inputNames.memo
              defaultValue=productOption.memo
              disabled
            />
            {switch (index, productOption.status !== #RETIRE) {
            | (0, true) =>
              <div className=%twc("flex gap-2 items-center")>
                <button onClick=onClickApplyAll>
                  {applyAll
                    ? <IconCheckBoxChecked width="20" height="20" />
                    : <IconCheckBoxUnChecked width="20" height="20" />}
                </button>
                <span>
                  {`[${productDisplayName}] 전체 단품에 출고기준시간과 메모 동일하게 적용하기`->React.string}
                </span>
              </div>
            | _ => React.null
            }}
          </div>
        </div>
      </RadixUI.Collapsible.Content>
    </div>
  </RadixUI.Collapsible.Root>
}
