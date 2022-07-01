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
    c1: @spice.codec(ReactSelect.codecSelectOption) ReactSelect.selectOption,
    c2: @spice.codec(ReactSelect.codecSelectOption) ReactSelect.selectOption,
    c3: @spice.codec(ReactSelect.codecSelectOption) ReactSelect.selectOption,
    c4: @spice.codec(ReactSelect.codecSelectOption) ReactSelect.selectOption,
    c5: @spice.codec(ReactSelect.codecSelectOption) ReactSelect.selectOption,
    categoryType: @spice.codec(ReactSelect.codecSelectOption) ReactSelect.selectOption,
  }
}

let encodeQualifiedNameValue = query => {
  let generateForm: array<
    SearchProductAdminCategoriesFragment_graphql.Types.fragment_displayCategoryNode_DisplayCategory_fullyQualifiedName,
  > => Form.submit = categories => {
    categoryType: switch categories->Garter.Array.first->Option.map(({type_}) => type_) {
    | Some(#NORMAL) => ReactSelect.Selected({value: "normal", label: `일반`})
    | Some(#SHOWCASE) => ReactSelect.Selected({value: "showcase", label: `기획전`})
    | _ => ReactSelect.NotSelected
    },
    c1: categories
    ->Array.get(0)
    ->Option.mapWithDefault(ReactSelect.NotSelected, d => {
      ReactSelect.Selected({value: d.id, label: d.name})
    }),
    c2: categories
    ->Array.get(1)
    ->Option.mapWithDefault(ReactSelect.NotSelected, d => {
      ReactSelect.Selected({value: d.id, label: d.name})
    }),
    c3: categories
    ->Array.get(2)
    ->Option.mapWithDefault(ReactSelect.NotSelected, d => {
      ReactSelect.Selected({value: d.id, label: d.name})
    }),
    c4: categories
    ->Array.get(3)
    ->Option.mapWithDefault(ReactSelect.NotSelected, d => {
      ReactSelect.Selected({value: d.id, label: d.name})
    }),
    c5: categories
    ->Array.get(4)
    ->Option.mapWithDefault(ReactSelect.NotSelected, d => {
      ReactSelect.Selected({value: d.id, label: d.name})
    }),
  }
  query->generateForm
}

let categoryTypeOptions = [
  ReactSelect.Selected({value: "normal", label: `일반`}),
  ReactSelect.Selected({value: "showcase", label: `기획전`}),
]

module Select_CategoryType = {
  @react.component
  let make = (~control, ~name) => {
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
            rules={Rules.make(~required={true}, ())}
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
      <Select_Display_Category control name disabled=false required=false isClearable=true />
    </>
  }
}

@react.component
let make = (~control, ~name) => {
  <React.Suspense fallback={<div />}>
    <div className=%twc("flex gap-2 h-9")> <Select_CategoryType control name /> </div>
  </React.Suspense>
}
