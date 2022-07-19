let makeCategoryId = form => {
  open ReactSelect
  switch form {
  | Selected({value}) => value
  | NotSelected => ""
  }
}

let makeDisplayCategoryIds = (form: array<Select_Display_Categories.Form.submit>) => {
  form->Array.keepMap(({c1, c2, c3, c4, c5}) =>
    [c1, c2, c3, c4, c5]
    ->Array.keepMap(select =>
      switch select {
      | Selected({value}) => Some(value)
      | NotSelected => None
      }
    )
    ->Garter.Array.last
  )
}

let makeNoticeDate = (dateStr, setTimeFn) => {
  dateStr
  ->Option.keep(str => str != "")
  ->Option.map(dateStr' => {
    dateStr'->Js.Date.fromString->setTimeFn->Js.Date.toISOString
  })
}
