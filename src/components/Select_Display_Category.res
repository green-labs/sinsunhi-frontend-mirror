open ReactHookForm

module Query = %relay(`
  query SelectDisplayCategoryQuery(
    $parentId: ID
    $types: [DisplayCategoryType!]
  ) {
    displayCategories(parentId: $parentId, types: $types) {
      id
      name
    }
  }
`)

module type Category = {
  @react.component
  let make: (
    ~parentId: option<string>,
    ~control: Control.t,
    ~name: string,
    ~categoryNamePrefixes: array<string>,
    ~disabled: bool,
    ~required: bool,
    ~isClearable: bool,
  ) => React.element
}

module type Selection = {
  @react.component
  let make: (
    ~parentId: option<string>,
    ~control: Control.t,
    ~name: string,
    ~prefix: string,
    ~categoryNamePrefixes: array<string>,
    ~disabled: bool,
    ~required: bool,
    ~isClearable: bool,
  ) => React.element
}

module rec Category: Category = {
  @react.component
  let make = (
    ~parentId,
    ~control,
    ~name,
    ~categoryNamePrefixes,
    ~disabled,
    ~required,
    ~isClearable,
  ) => {
    let prefix = categoryNamePrefixes->Garter.Array.first

    switch (prefix, parentId) {
    | (Some(prefix'), None) if prefix' == "c1" =>
      // 전시카테고리 일반/기획전 선택 제외 최상위("c1")의 경우 parentId 없이 그린다.
      <React.Suspense fallback={<div />}>
        <Selection
          parentId=None
          control
          name
          prefix=prefix'
          categoryNamePrefixes
          disabled
          required
          isClearable
        />
      </React.Suspense>
    | (Some(prefix'), Some(_)) =>
      // 그 이하("c2"~"c5")의 경우 parentId가 있어야 그린다.
      <React.Suspense fallback={<div />}>
        <Selection
          parentId control name prefix=prefix' categoryNamePrefixes disabled required isClearable
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
    ~categoryNamePrefixes,
    ~disabled,
    ~required,
    ~isClearable,
  ) => {
    let categoryType =
      Hooks.WatchValues.use(
        Hooks.WatchValues.Text,
        ~config=Hooks.WatchValues.config(~control, ~name=`${name}.categoryType.value`, ()),
        (),
      )->Option.getWithDefault("")

    let {displayCategories} = Query.use(
      ~variables={
        parentId: parentId,
        types: switch categoryType {
        | "normal" => [#NORMAL]
        | "showcase" => [#SHOWCASE]
        | _ => [#NORMAL, #SHOWCASE]
        }->Some,
      },
      (),
    )

    let selectedId = Hooks.WatchValues.use(
      Hooks.WatchValues.NullableText,
      ~config=Hooks.WatchValues.config(~control, ~name=`${name}.${prefix}.value`, ()),
      (),
    )

    let handleOnChange = (changeFn, data) => {
      changeFn(Controller.OnChangeArg.value(data->ReactSelect.encoderRule))
    }

    let {setValue, unregister} = Hooks.Context.use(.
      ~config=Hooks.Form.config(~mode=#onChange, ()),
      (),
    )
    // parentId와 categoryType이 변경되면 리액트 훅 폼의 해당 값을 초기화한다.
    React.useEffect2(_ => {
      let isStillSameCategory =
        selectedId->Option.flatMap(selectedIdNull =>
          selectedIdNull
          ->Js.Nullable.toOption
          ->Option.map(selectedId' => displayCategories->Array.some(d => d.id == selectedId'))
        )

      switch isStillSameCategory {
      // parentId, categoryType이 달라져서
      // (즉, 부모 전시 카테고리의 선택 값이 변경되는 경우)
      // -> displayCategories의 데이터가 달라지면
      // -> ReactSelect 컴포넌트에 선택된 값을 제거한다.
      | Some(true) => ()
      | _ => setValue(. `${name}.${prefix}`, ReactSelect.NotSelected->ReactSelect.encoderRule)
      }

      // 언마운트 될 때 선택된 값을 제거합니다.
      // shouldUnregister 를 안쓰는 이유는 form 에 있는 값을 물리적으로 지우기만 하고, hook에 알리지 않기 때문입니다.
      // 이는 hook 에서 접근하려고 시도할때 런타임 에러가 발생할 수 있습니다.
      //unregister 를 사용하여 등록을 직접 해제합니다. https://react-hook-form.com/api/useform#shouldUnregister
      Some(
        () => {
          unregister(. `${name}.${prefix}`)
        },
      )
    }, (parentId, categoryType))

    switch displayCategories {
    | [] => React.null
    | _ => <>
        <div className=%twc("relative w-48")>
          <div className=%twc("absolute w-full")>
            <Controller
              name={`${name}.${prefix}`}
              control
              defaultValue={ReactSelect.NotSelected->ReactSelect.encoderRule}
              rules={Rules.make(~required, ())}
              render={({field: {onChange, value, ref}}) => {
                <ReactSelect.Plain
                  value={value
                  ->ReactSelect.decoderRule
                  ->Result.getWithDefault(ReactSelect.NotSelected)}
                  options={displayCategories->Array.map(o => {
                    ReactSelect.Selected({value: o.id, label: o.name})
                  })}
                  ref
                  isClearable
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
        //하위 카테고리 셀렉션
        <Category
          parentId={selectedId->Option.flatMap(Js.Nullable.toOption)}
          control
          name
          categoryNamePrefixes={categoryNamePrefixes->Garter.Array.sliceToEnd(1)}
          disabled
          required
          isClearable
        />
      </>
    }
  }
}

@react.component
let make = (~control, ~name, ~disabled, ~required, ~isClearable=false) => {
  // 최대 5단계의 전시카테고리 선택 셀렉트를 가진다.
  let categoryNamePrefixes = ["c1", "c2", "c3", "c4", "c5"]
  <Category parentId=None control name categoryNamePrefixes disabled required isClearable />
}
