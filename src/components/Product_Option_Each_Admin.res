open ReactHookForm
module Select_Unit = Select_Product_Option_Unit

module Form = {
  @spice
  type each = {
    numMin: float,
    numMax: float,
    sizeMin: float,
    sizeMax: float,
    sizeUnit: Select_Unit.Size.status,
    weightUnit: Select_Unit.Weight.status,
  }

  type inputNames = {
    unitWeight: string,
    minSize: string,
    maxSize: string,
    unitSize: string,
    minNum: string,
    maxNum: string,
    values: string,
  }

  let getNamesWithPrefix = prefix => {
    unitWeight: `${prefix}.each.weightUnit`,
    minSize: `${prefix}.each.sizeMin`,
    maxSize: `${prefix}.each.sizeMax`,
    unitSize: `${prefix}.each.sizeUnit`,
    minNum: `${prefix}.each.numMin`,
    maxNum: `${prefix}.each.numMax`,
    values: `${prefix}.each`,
  }

  let names = {
    unitWeight: "weightUnit",
    minSize: "sizeMin",
    maxSize: "sizeMax",
    unitSize: "sizeUnit",
    minNum: "numMin",
    maxNum: "numMax",
    values: "",
  }
}

let divideNum = (baseUnit, currentUnit) =>
  switch (baseUnit, currentUnit) {
  | (Select_Unit.WeightStatus.G, Select_Unit.WeightStatus.G) => 1.
  | (Select_Unit.WeightStatus.G, Select_Unit.WeightStatus.KG) => 1000.
  | (Select_Unit.WeightStatus.G, Select_Unit.WeightStatus.T) => 1000000.
  | (Select_Unit.WeightStatus.KG, Select_Unit.WeightStatus.G) => 1. /. 1000.
  | (Select_Unit.WeightStatus.KG, Select_Unit.WeightStatus.KG) => 1.
  | (Select_Unit.WeightStatus.KG, Select_Unit.WeightStatus.T) => 1000.
  | (Select_Unit.WeightStatus.T, Select_Unit.WeightStatus.G) => 1. /. 1000000.
  | (Select_Unit.WeightStatus.T, Select_Unit.WeightStatus.KG) => 1. /. 1000.
  | (Select_Unit.WeightStatus.T, Select_Unit.WeightStatus.T) => 1.
  }

let getPerWeight = (weight, weightUnit, perNum, unitWeight) => {
  let decodeUnit = unitWeight->Option.getWithDefault(Select_Unit.WeightStatus.KG)

  let baseWeight = weight /. divideNum(weightUnit, decodeUnit)

  //FIXED 는 항상 소숫점 n 자리를 유지 -> 이를 최대 n 자리로 바꿈
  (baseWeight /. perNum)
  ->Js.Float.toFixedWithPrecision(~digits=2)
  ->Float.fromString
  ->Option.mapWithDefault("", Float.toString)
}

@react.component
let make = (
  ~prefix,
  ~weightFormName,
  ~wieghtUnitFormName,
  ~readOnly=false,
  ~defaultMinNum=?,
  ~defaultMaxNum=?,
  ~defaultMinWeight=?,
  ~defaultMaxWeight=?,
  ~defaultEachWeightUnit=?,
  ~defaultMinSize=?,
  ~defaultMaxSize=?,
  ~defaultUnitSize=?,
) => {
  let {register, control, formState: {errors}, setValue} = Hooks.Context.use(.
    ~config=Hooks.Form.config(~mode=#onChange, ()),
    (),
  )

  let weightAndUnit = Hooks.WatchValues.use(
    Hooks.WatchValues.NullableTexts,
    ~config=Hooks.WatchValues.config(~name=[weightFormName, wieghtUnitFormName], ()),
    (),
  )

  let (weight, weightUnit) =
    weightAndUnit
    ->Option.map(a => a->Array.map(Js.Nullable.toOption))
    ->Option.flatMap(v => v->Helper.Option.sequence)
    ->Option.flatMap(v =>
      switch v {
      | [weight, unit] => (weight, unit)->Some
      | _ => None
      }
    )
    ->Option.map(((w, u)) => (
      w->Float.fromString,
      u->Select_Unit.Weight.fromString->Result.getWithDefault(Select_Unit.WeightStatus.G),
    ))
    ->Option.getWithDefault((None, Select_Unit.WeightStatus.G))

  let inputNames = Form.getNamesWithPrefix(prefix)

  let eachValues = Hooks.WatchValues.use(
    Hooks.WatchValues.Object,
    ~config=Hooks.WatchValues.config(~name=inputNames.values, ()),
    (),
  )

  let (watchMinNum, watchMaxNum, watchMinSize, watchWeightUnit) = switch eachValues->Option.map(
    Form.each_decode,
  ) {
  | Some(Ok({numMin, numMax, sizeMin, weightUnit})) => (
      Some(numMin),
      Some(numMax),
      Some(sizeMin),
      Some(weightUnit),
    )
  | _ => (None, None, None, None)
  }

  let eachMinNum = register(.
    inputNames.minNum,
    Some(Hooks.Register.config(~required=true, ~valueAsNumber=true, ~min=1, ())),
  )

  let eachMaxNum = register(.
    inputNames.maxNum,
    Some(
      Hooks.Register.config(
        ~required=true,
        ~valueAsNumber=true,
        ~min=watchMinNum->Option.map(Float.toInt)->Option.getWithDefault(1),
        (),
      ),
    ),
  )
  let eachMinSize = register(.
    inputNames.minSize,
    Some(Hooks.Register.config(~required=true, ~valueAsNumber=true, ~min=0, ())),
  )

  let eachMaxSize = register(.
    inputNames.maxSize,
    Some(
      Hooks.Register.config(
        ~required=true,
        ~valueAsNumber=true,
        ~min=watchMinSize->Option.map(Float.toInt)->Option.getWithDefault(0),
        (),
      ),
    ),
  )

  React.useEffect0(() => {
    //폼에서 디폴트 단위 값 설정
    setValue(.
      inputNames.unitSize,
      defaultUnitSize
      ->Option.getWithDefault(Select_Unit.SizeStatus.MM)
      ->Select_Unit.Size.status_encode,
    )
    setValue(.
      inputNames.unitWeight,
      defaultEachWeightUnit
      ->Option.getWithDefault(Select_Unit.WeightStatus.KG)
      ->Select_Unit.Weight.status_encode,
    )

    None
  })

  <div className=%twc("py-6 flex flex-col gap-2")>
    <div className=%twc("flex gap-2 items-center")>
      <label className=%twc("block")> {`입수 정보`->React.string} </label>
      <div
        className=%twc(
          "px-3 py-2 border border-border-default-L1 rounded-lg h-9 bg-disabled-L3 w-36 leading-4.5"
        )>
        {`${weight->Option.mapWithDefault("", Float.toString)}
          ${weightUnit->Select_Unit.Weight.toString}`->React.string}
      </div>
      {<div>
        <input
          readOnly
          type_="number"
          id=eachMinNum.name
          name=eachMinNum.name
          defaultValue={defaultMinNum->Option.mapWithDefault("0", Float.toString)}
          onChange={eachMinNum.onChange}
          ref=eachMinNum.ref
          onBlur=eachMinNum.onBlur
          className={cx([
            %twc("px-3 py-2 border border-border-default-L1 rounded-lg h-9 focus:outline-none"),
            readOnly ? %twc("bg-disabled-L3") : %twc("bg-white"),
          ])}
          placeholder=`입수 입력`
        />
        <ErrorMessage
          errors
          name={eachMinNum.name}
          render={_ =>
            <span className=%twc("flex")>
              <IconError width="20" height="20" />
              <span className=%twc("text-sm text-notice ml-1")>
                {`입수(최소)를 입력해주세요.`->React.string}
              </span>
            </span>}
        />
      </div>}
      <span> {`~`->React.string} </span>
      <div>
        <input
          readOnly
          type_="number"
          defaultValue={defaultMaxNum->Option.mapWithDefault("0", Float.toString)}
          id=eachMaxNum.name
          name=eachMaxNum.name
          onChange={eachMaxNum.onChange}
          ref=eachMaxNum.ref
          onBlur=eachMaxNum.onBlur
          className={cx([
            %twc("px-3 py-2 border border-border-default-L1 rounded-lg h-9 focus:outline-none"),
            readOnly ? %twc("bg-disabled-L3") : %twc("bg-white"),
          ])}
          placeholder=`입수 입력`
        />
        <ErrorMessage
          errors
          name={eachMaxNum.name}
          render={_ =>
            <span className=%twc("flex")>
              <IconError width="20" height="20" />
              <span className=%twc("text-sm text-notice ml-1")>
                {`입수(최대)를 입력해주세요.`->React.string}
              </span>
            </span>}
        />
      </div>
    </div>
    <div className=%twc("flex gap-4 flex-wrap")>
      <div className=%twc("flex gap-2 items-center pr-4 border-r border-div-border-L2")>
        <label className=%twc("block shrink-0")> {`개당 무게`->React.string} </label>
        <div
          className=%twc(
            "px-3 py-2 border border-border-default-L1 rounded-lg h-9 bg-disabled-L3 w-36 text-disabled-L1 leading-4.5 focus:outline-none"
          )>
          {defaultMinWeight
          ->Option.map(Float.toString)
          ->Option.getWithDefault(
            switch (weight, weightUnit, watchMaxNum, watchWeightUnit) {
            | (Some(weight'), _, Some(watchMaxNum'), _) =>
              getPerWeight(weight', weightUnit, watchMaxNum', watchWeightUnit)
            | _ => `자동계산`
            },
          )
          ->React.string}
        </div>
        <span> {`~`->React.string} </span>
        <div
          className=%twc(
            "px-3 py-2 border border-border-default-L1 rounded-lg h-9 bg-disabled-L3 w-36 text-disabled-L1 leading-4.5 focus:outline-none"
          )>
          {defaultMaxWeight
          ->Option.map(Float.toString)
          ->Option.getWithDefault(
            switch (weight, weightUnit, watchMinNum, watchWeightUnit) {
            | (Some(weight'), _, Some(watchMinNum'), _) =>
              getPerWeight(weight', weightUnit, watchMinNum', watchWeightUnit)
            | _ => `자동계산`
            },
          )
          ->React.string}
        </div>
        <Controller
          name={inputNames.unitWeight}
          control
          render={({field: {onChange, value, ref}}) =>
            <Select_Unit.Weight
              disabled=readOnly
              status={value
              ->Select_Unit.Weight.status_decode
              ->Result.getWithDefault(Select_Unit.WeightStatus.KG)}
              onChange={status => {
                onChange(Controller.OnChangeArg.value(status->Select_Unit.Weight.status_encode))
              }}
              forwardRef={ref}
            />}
        />
      </div>
      <div className=%twc("flex gap-2 items-center")>
        <label className=%twc("block shrink-0")> {`개당 크기`->React.string} </label>
        <div>
          <input
            readOnly
            id=eachMinSize.name
            name=eachMinSize.name
            type_="number"
            onChange=eachMinSize.onChange
            onBlur=eachMinSize.onBlur
            ref=eachMinSize.ref
            className={cx([
              %twc(
                "px-3 py-2 border border-border-default-L1 rounded-lg h-9 focus:outline-none shrink"
              ),
              readOnly ? %twc("bg-disabled-L3") : %twc("bg-white"),
            ])}
            placeholder=`최소 크기`
            defaultValue={defaultMinSize->Option.mapWithDefault("0", Float.toString)}
          />
          <ErrorMessage
            errors
            name={eachMinSize.name}
            render={_ =>
              <span className=%twc("flex")>
                <IconError width="20" height="20" />
                <span className=%twc("text-sm text-notice ml-1")>
                  {`개당 최소 크기를 입력해주세요.`->React.string}
                </span>
              </span>}
          />
        </div>
        <span> {`~`->React.string} </span>
        <div>
          <input
            readOnly
            id=eachMaxSize.name
            name=eachMaxSize.name
            type_="number"
            onChange=eachMaxSize.onChange
            onBlur=eachMaxSize.onBlur
            ref=eachMaxSize.ref
            className={cx([
              %twc(
                "px-3 py-2 border border-border-default-L1 rounded-lg h-9 focus:outline-none shrink"
              ),
              readOnly ? %twc("bg-disabled-L3") : %twc("bg-white"),
            ])}
            placeholder=`최대 크기`
            defaultValue={defaultMaxSize->Option.mapWithDefault("0", Float.toString)}
          />
          <ErrorMessage
            errors
            name={eachMaxSize.name}
            render={_ =>
              <span className=%twc("flex")>
                <IconError width="20" height="20" />
                <span className=%twc("text-sm text-notice ml-1")>
                  {`개당 최대 크기를 입력해주세요.`->React.string}
                </span>
              </span>}
          />
        </div>
        <Controller
          name={inputNames.unitSize}
          control
          render={({field: {onChange, value, ref}}) =>
            <Select_Unit.Size
              disabled=readOnly
              status={value
              ->Select_Unit.Size.status_decode
              ->Result.getWithDefault(Select_Unit.SizeStatus.MM)}
              onChange={status => {
                onChange(Controller.OnChangeArg.value(status->Select_Unit.Size.status_encode))
              }}
              forwardRef=ref
            />}
        />
      </div>
    </div>
  </div>
}
