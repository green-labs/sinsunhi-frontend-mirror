open ReactHookForm

module Query = %relay(`
  query SelectProductCategoryQuery($parentId: ID) {
    categories(parentId: $parentId) {
      id
      name
    }
  }
`)

module Form = {
  @spice
  type submit = {
    c1: @spice.codec(ReactSelect.codecSelectOption) ReactSelect.selectOption,
    c2: @spice.codec(ReactSelect.codecSelectOption) ReactSelect.selectOption,
    c3: @spice.codec(ReactSelect.codecSelectOption) ReactSelect.selectOption,
    c4: @spice.codec(ReactSelect.codecSelectOption) ReactSelect.selectOption,
    c5: @spice.codec(ReactSelect.codecSelectOption) ReactSelect.selectOption,
  }
}

module type Skeleton = {
  @react.component
  let make: (~placeholders: array<string>) => React.element
}

module rec Skeleton: Skeleton = {
  @react.component
  let make = (~placeholders) => {
    let placeholder' = placeholders->Garter.Array.first
    switch (placeholder', placeholders) {
    | (Some(placeholder'), _) => <>
        <div className=%twc("relative w-48")>
          <div className=%twc("absolute w-full")>
            <ReactSelect.Plain
              value={ReactSelect.NotSelected}
              options=[]
              placeholder={placeholder'}
              onChange={_ => ()}
              isDisabled={true}
              noOptionsMessage={_ => `검색 결과가 없습니다.`}
              styles={ReactSelect.stylesOptions(~control=(provide, _) => {
                Js.Obj.assign(Js.Obj.empty(), provide)->Js.Obj.assign({
                  "minHeight": "unset",
                  "height": "2.25rem",
                })
              }, ())}
            />
          </div>
        </div>
        <Skeleton placeholders={placeholders->Garter.Array.sliceToEnd(1)} />
      </>
    | _ => React.null
    }
  }
}

module type Category = {
  @react.component
  let make: (
    ~parentId: option<string>,
    ~control: Control.t,
    ~name: string,
    ~categoryNamePrefixes: array<string>,
    ~placeholders: array<string>,
    ~disabled: bool,
    ~required: bool,
  ) => React.element
}

module type Selection = {
  @react.component
  let make: (
    ~parentId: option<string>,
    ~control: Control.t,
    ~name: string,
    ~prefix: string,
    ~placeholder: string,
    ~categoryNamePrefixes: array<string>,
    ~placeholders: array<string>,
    ~disabled: bool,
    ~required: bool,
  ) => React.element
}

module rec Category: Category = {
  @react.component
  let make = (
    ~parentId,
    ~control,
    ~name,
    ~categoryNamePrefixes,
    ~placeholders,
    ~disabled,
    ~required,
  ) => {
    let prefix = categoryNamePrefixes->Garter.Array.first
    let placeholder = placeholders->Garter.Array.first

    switch (prefix, placeholder) {
    | (Some(prefix'), Some(placeholder)) =>
      //표준 카테고리 최상위의 경우 parentId 없이 그린다.
      <React.Suspense fallback={<Skeleton placeholders />}>
        <Selection
          parentId
          control
          name
          prefix=prefix'
          placeholder
          categoryNamePrefixes
          placeholders
          disabled
          required
        />
      </React.Suspense>
    | _ => React.null
    }
  }
}
and Selection: Selection = {
  @react.component
  let make = (
    ~parentId,
    ~control,
    ~name,
    ~prefix,
    ~placeholder,
    ~categoryNamePrefixes,
    ~placeholders,
    ~disabled,
    ~required,
  ) => {
    let {categories} = Query.use(~variables={parentId: parentId}, ())

    let selectedId = Hooks.WatchValues.use(
      Hooks.WatchValues.NullableText,
      ~config=Hooks.WatchValues.config(~control, ~name=`${name}.${prefix}.value`, ()),
      (),
    )

    let handleOnChange = (changeFn, data) => {
      changeFn(Controller.OnChangeArg.value(data->ReactSelect.encoderRule))
    }

    let {setValue} = Hooks.Context.use(. ~config=Hooks.Form.config(~mode=#onChange, ()), ())

    // parentId 가 변경되면 리액트 훅 폼의 해당 값을 초기화 한다.
    React.useEffect1(_ => {
      let isStillSameCategory =
        selectedId->Option.flatMap(selectedIdNull =>
          selectedIdNull
          ->Js.Nullable.toOption
          ->Option.map(selectedId' => categories->Array.some(d => d.id == selectedId'))
        )

      switch isStillSameCategory {
      // 부모 카테고리의 선택 값이 변경되는 경우
      // -> categories의 데이터가 달라지면
      // -> ReactSelect 컴포넌트에 선택된 값을 제거한다.
      | Some(true) => ()
      | _ => setValue(. `${name}.${prefix}`, ReactSelect.NotSelected->ReactSelect.encoderRule)
      }

      None
    }, [parentId])

    switch categories {
    | [] => React.null
    | _ => <>
        <div className=%twc("relative w-48")>
          <div className=%twc("absolute w-full")>
            <Controller
              name={`${name}.${prefix}`}
              control
              shouldUnregister=true
              defaultValue={ReactSelect.NotSelected->ReactSelect.encoderRule}
              rules={Rules.make(~required, ())}
              render={({field: {onChange, value, ref}}) => {
                <ReactSelect.Plain
                  value={value
                  ->ReactSelect.decoderRule
                  ->Result.getWithDefault(ReactSelect.NotSelected)}
                  options={categories->Array.map(o => {
                    ReactSelect.Selected({value: o.id, label: o.name})
                  })}
                  ref
                  onChange={handleOnChange(onChange)}
                  placeholder
                  isDisabled={disabled || (prefix !== "c1" && parentId->Option.isNone)}
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
        //하위 카테고리 셀렉션
        <Category
          parentId={selectedId->Option.flatMap(Js.Nullable.toOption)}
          control
          name
          categoryNamePrefixes={categoryNamePrefixes->Garter.Array.sliceToEnd(1)}
          placeholders={placeholders->Garter.Array.sliceToEnd(1)}
          disabled
          required
        />
      </>
    }
  }
}

@react.component
let make = (~control, ~name, ~disabled=false, ~required=true) => {
  // 5단계의 표준카테고리 선택 셀렉트를 가진다.
  let categoryNamePrefixes = ["c1", "c2", "c3", "c4", "c5"]
  let placeholders = [
    `카테고리 선택`,
    `대분류선택`,
    `부류선택`,
    `품목선택`,
    `품종선택`,
  ]

  <Category parentId=None control name categoryNamePrefixes placeholders disabled required />
}
