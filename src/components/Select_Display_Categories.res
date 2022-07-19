open ReactHookForm

module Form = {
  type displayCategory = {
    c5: string,
    c4: string,
    c3: string,
    c2: string,
    c1: string,
    categoryType: string,
  }

  let formName = {
    c5: "c5",
    c4: "c4",
    c3: "c3",
    c2: "c2",
    c1: "c1",
    categoryType: "categoryType",
  }

  type categoryType = Normal | ShowCase

  let defaultDisplayCategory = categoryType => {
    let displayCategory = [
      (formName.c1, NotSelected->ReactSelect.encoderRule),
      (formName.c2, NotSelected->ReactSelect.encoderRule),
      (formName.c3, NotSelected->ReactSelect.encoderRule),
      (formName.c4, NotSelected->ReactSelect.encoderRule),
      (formName.c5, NotSelected->ReactSelect.encoderRule),
    ]

    let defaultCategoryType = switch categoryType {
    | Normal => (
        formName.categoryType,
        ReactSelect.Selected({value: "normal", label: `일반`})->ReactSelect.encoderRule,
      )
    | ShowCase => (
        formName.categoryType,
        ReactSelect.Selected({value: "showcase", label: `기획전`})->ReactSelect.encoderRule,
      )
    }

    displayCategory->Array.concat([defaultCategoryType])->Js.Dict.fromArray->Js.Json.object_
  }

  @spice
  type submit = {
    c5: @spice.codec(ReactSelect.codecSelectOption) ReactSelect.selectOption,
    c4: @spice.codec(ReactSelect.codecSelectOption) ReactSelect.selectOption,
    c3: @spice.codec(ReactSelect.codecSelectOption) ReactSelect.selectOption,
    c2: @spice.codec(ReactSelect.codecSelectOption) ReactSelect.selectOption,
    c1: @spice.codec(ReactSelect.codecSelectOption) ReactSelect.selectOption,
    categoryType: @spice.codec(ReactSelect.codecSelectOption) ReactSelect.selectOption,
  }
}

let categoryTypeOptions = [
  ReactSelect.Selected({value: "normal", label: `일반`}),
  ReactSelect.Selected({value: "showcase", label: `기획전`}),
]

module Select_CategoryType = {
  @react.component
  let make = (~control, ~name, ~disabled, ~required) => {
    let handleOnChange = (changeFn, data) => {
      changeFn(Controller.OnChangeArg.value(data->ReactSelect.encoderRule))
    }

    <>
      <div className=%twc("relative w-48")>
        <div className=%twc("absolute w-full")>
          <Controller
            name={`${name}.categoryType`}
            control
            shouldUnregister=true
            rules={Rules.make(~required, ())}
            render={({field: {onChange, value, ref}}) => {
              <ReactSelect.Plain
                value={value
                ->ReactSelect.decoderRule
                ->Result.getWithDefault(ReactSelect.NotSelected)}
                options={categoryTypeOptions}
                ref
                onChange={handleOnChange(onChange)}
                placeholder=`부류선택`
                noOptionsMessage={_ => `검색 결과가 없습니다.`}
                isDisabled={disabled}
                styles={ReactSelect.stylesOptions(~control=(provide, _) => {
                  Js.Obj.assign(Js.Obj.empty(), provide)->Js.Obj.assign({
                    "minHeight": "unset",
                    "height": "2.25rem",
                  })
                }, ())}
              />
            }}
          />
        </div>
      </div>
      <Select_Display_Category control name disabled required />
    </>
  }
}

@react.component
let make = (~control, ~name, ~disabled=false, ~required=true) => {
  let {errors} = Hooks.FormState.use(. ~config=Hooks.FormState.config(~control))

  <React.Suspense fallback={<div />}>
    <div className=%twc("flex gap-2 h-9")>
      <Select_CategoryType control name disabled required />
    </div>
    <ErrorMessage
      name
      errors
      render={_ =>
        <span className=%twc("flex")>
          <IconError width="20" height="20" />
          <span className=%twc("text-sm text-notice ml-1")>
            {`전시카테고리를 입력해주세요.`->React.string}
          </span>
        </span>}
    />
  </React.Suspense>
}
