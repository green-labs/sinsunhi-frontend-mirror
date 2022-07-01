open ReactHookForm

@react.component
let make = (~control, ~name, ~disabled) => {
  let {fields, remove, append} = Hooks.FieldArray.use(.
    ~config=Hooks.FieldArray.config(~control, ~name, ~shouldUnregister=true, ()),
  )

  fields
  ->Array.mapWithIndex((index, field) => {
    <div className=%twc("flex gap-2") key={field.id}>
      <div>
        <Select_Display_Categories
          control key={field.id} name={`${name}.${index->Int.toString}`} disabled
        />
      </div>
      {switch (disabled, index) {
      | (true, _) => React.null
      | (false, 0) =>
        <button
          type_="button"
          className=%twc("px-3 py-2 bg-div-shape-L1 text-enabled-L1 rounded-lg h-9")
          onClick={ReactEvents.interceptingHandler(_ => {
            append(.
              Select_Display_Categories.Form.defaultDisplayCategory(
                Select_Display_Categories.Form.ShowCase,
              ),
              ~focusOptions=Hooks.FieldArray.focusOptions(),
              (),
            )
          })}>
          {`전시카테고리 추가`->React.string}
        </button>
      | (false, _) =>
        <button type_="button" onClick={ReactEvents.interceptingHandler(_ => remove(. index))}>
          <IconCloseInput height="28" width="28" fill="#B2B2B2" />
        </button>
      }}
    </div>
  })
  ->React.array
}
