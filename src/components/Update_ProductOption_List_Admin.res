/*
 *   1. 위치: 상품 내 단품리스트
 *
 *   2. 역할: 이미 생성 된, 단품의 리스트를 수정할 수 있고(삭제불가), 단품을 추가할 수 있다
 */

open ReactHookForm
let formName = "product-options"

@react.component
let make = (
  ~productDisplayName,
  ~isCourierAvailable,
  ~options: UpdateProductOptionsAdminFragment_graphql.Types.fragment_productOptions,
) => {
  let {edges, __id: connectionId} = options

  let (applyAll, setApplyAll) = React.Uncurried.useState(_ => false)

  let {control, setValue, register} = Hooks.Context.use(.
    ~config=Hooks.Form.config(~mode=#onChange, ()),
    (),
  )
  let {fields, remove, prepend} = Hooks.FieldArray.use(.
    ~config=Hooks.FieldArray.config(
      ~control,
      ~name=`${formName}.create`,
      ~shouldUnregister=true,
      (),
    ),
  )
  let listId = register(. "product-options.connection-id", None)

  let isOnlyOneRemained = {
    fields->Array.length + edges->Array.length == 1
  }

  let handleOnClickAdd = ReactEvents.interceptingHandler(_ => {
    setApplyAll(._ => false)
    prepend(. Js.Dict.empty()->Js.Json.object_, ~focusOptions=Hooks.FieldArray.focusOptions(), ())
  })

  let setTogether = (fieldName, value) => {
    switch fields {
    | [] =>
      edges
      ->Array.sliceToEnd(1)
      ->Array.forEachWithIndex((index, _) =>
        setValue(. `${formName}.edit.${(index + 1)->Int.toString}.${fieldName}`, value)
      )
    | _ => {
        fields
        ->Array.sliceToEnd(1)
        ->Array.forEachWithIndex((index, _) =>
          setValue(. `${formName}.create.${(index + 1)->Int.toString}.${fieldName}`, value)
        )
        edges->Array.forEachWithIndex((index, _) =>
          setValue(. `${formName}.edit.${index->Int.toString}.${fieldName}`, value)
        )
      }
    }
  }

  let watchFirstCM = switch fields {
  | [] =>
    Hooks.WatchValues.use(
      Hooks.WatchValues.Texts,
      ~config=Hooks.WatchValues.config(
        ~name=[`${formName}.edit.0.cut-off-time`, `${formName}.edit.0.memo`],
        (),
      ),
      (),
    )
  | _ =>
    Hooks.WatchValues.use(
      Hooks.WatchValues.Texts,
      ~config=Hooks.WatchValues.config(
        ~name=[`${formName}.create.0.cut-off-time`, `${formName}.create.0.memo`],
        (),
      ),
      (),
    )
  }

  React.useEffect2(_ => {
    switch (applyAll, watchFirstCM) {
    | (true, Some([cutOffTime, memo])) =>
      setTogether("cut-off-time", cutOffTime->Option.mapWithDefault(Js.Json.null, Js.Json.string))
      setTogether("memo", memo->Option.mapWithDefault(Js.Json.null, Js.Json.string))
    | _ => ()
    }
    None
  }, (applyAll, watchFirstCM))

  <>
    <div className=%twc("flex justify-between items-center")>
      <h2 className=%twc("text-text-L1 text-lg font-bold")>
        {j`단품 정보`->React.string}
        <span className=%twc("text-sm text-green-gl ml-2 font-normal")>
          {`단품 ${(fields->Array.length + edges->Array.length)->Int.toString}개`->React.string}
        </span>
      </h2>
      //prevent input enter key propagation
      <input
        defaultValue={connectionId->RescriptRelay.dataIdToString}
        type_="hidden"
        name=listId.name
        id=listId.name
        onChange=listId.onChange
        onBlur=listId.onBlur
        ref=listId.ref
      />
      <button onClick={ReactEvents.interceptingHandler(_ => ())} />
      <button
        className=%twc("px-3 py-2 bg-div-shape-L1 rounded-lg focus:outline-none")
        onClick={handleOnClickAdd}>
        {`단품 추가하기`->React.string}
      </button>
    </div>
    <div className=%twc("flex flex-col mt-7 mb-3 gap-6")>
      {
        // 추가할 단품
        fields
        ->Array.mapWithIndex((index, field) =>
          <Add_ProductOption_Admin
            isOnlyOneRemained
            key={field.id}
            prefix={`${formName}.create.${index->Int.toString}`}
            index
            remove
            prepend
            productDisplayName
            applyAll
            setApplyAll
            isCourierAvailable
          />
        )
        ->React.array
      }
      {
        // 수정할 단품
        edges
        ->Array.partition(edge => edge.node.status !== #RETIRE)
        ->(((sale, nosale)) => Array.concat(sale, nosale))
        ->Array.mapWithIndex((index, edge) =>
          <Update_ProductOption_Admin
            key={edge.node.id}
            prefix={`${formName}.edit.${index->Int.toString}`}
            index={index + fields->Array.length}
            prepend
            query={edge.node.fragmentRefs}
            productDisplayName
            applyAll
            setApplyAll
          />
        )
        ->React.array
      }
    </div>
  </>
}
