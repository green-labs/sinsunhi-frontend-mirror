open ReactHookForm

@react.component
let make = (~productDisplayName, ~isCourierAvailable, ~formName) => {
  let (applyAll, setApplyAll) = React.Uncurried.useState(_ => false)
  let {control, setValue} = Hooks.Context.use(. ~config=Hooks.Form.config(~mode=#onChange, ()), ())

  let {fields, remove, prepend} = Hooks.FieldArray.use(.
    ~config=Hooks.FieldArray.config(~control, ~name=formName, ~shouldUnregister=true, ()),
  )

  let isOnlyOneRemained = fields->Array.length == 1

  let handleOnClickAdd = (
    _ => {
      setApplyAll(._ => false)
      prepend(. formName->Js.Json.string, ~focusOptions=Hooks.FieldArray.focusOptions(), ())
    }
  )->ReactEvents.interceptingHandler

  let setTogether = (fieldName, value) => {
    fields
    ->Array.sliceToEnd(1)
    ->Array.forEachWithIndex((index, _) =>
      setValue(. `${formName}.${(index + 1)->Int.toString}.${fieldName}`, value)
    )
  }

  let watchFirstCM = Hooks.WatchValues.use(
    Hooks.WatchValues.Texts,
    ~config=Hooks.WatchValues.config(
      ~name=[`${formName}.0.cut-off-time`, `${formName}.0.memo`],
      (),
    ),
    (),
  )

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
          {`단품 ${fields->Array.length->Int.toString}개`->React.string}
        </span>
      </h2>
      //prevent input enter key propagation
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
            prefix={`${formName}.${index->Int.toString}`}
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
    </div>
  </>
}
