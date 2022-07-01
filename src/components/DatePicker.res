type align = Left | Right

module Styles = {
  open CssJs
  let wrapper = style(. [
    selector(".duet-date__input-wrapper", [width(pct(100.0))]),
    selector(
      ".duet-date__input",
      [
        height(2.25->rem),
        border(px(1), #solid, hex("D5D5DD")),
        padding2(~h=1.0->rem, ~v=0.25->rem),
        textAlign(#left),
        borderRadius(px(8)),
      ],
    ),
    selector("input::placeholder", [color(hex("808080"))]),
    selector(".duet-date__toggle", [width(100.0->pct), opacity(0.0)]),
    selector(
      `.duet-date__day.is-today.is-month`,
      [
        color(hex("262626")),
        background(hex("ebfded")),
        boxShadow(Shadow.box(~x=px(0), ~y=px(0), ~blur=px(0), ~spread=px(1), hex("12b564"))),
      ],
    ),
    selector(
      `.duet-date__day.is-today.is-month[aria-pressed=true]`,
      [color(white), background(hex("12b564"))],
    ),
    selector(`.duet-date__day.is-month[aria-pressed=true]`, [background(hex("12b564"))]),
    selector(
      `.duet-date__day:focus`,
      [
        color(white),
        background(hex("12b564")),
        boxShadow(Shadow.box(~x=px(0), ~y=px(0), ~blur=px(5), ~spread=px(1), hex("12b564"))),
      ],
    ),
    marginRight(px(4)),
    [marginRight(px(0))]->lastOfType,
    display(#block),
    position(#relative),
  ])
}

@react.component
let make = (
  ~id,
  ~onChange,
  ~date=?,
  ~maxDate=?,
  ~minDate=?,
  ~firstDayOfWeek=?,
  ~align=?,
  ~isDateDisabled=?,
  ~onFocus=?,
  ~disabled=?,
) => {
  let dateRe = %re("/^(\d{4})\-(\d{1,2})\-(\d{1,2})$/")
  let max = maxDate
  let min = minDate

  // FIXME: option<string>인 minDate와 DuetDatePicker에서 바인딩한 minDate=?와
  // 타입이 맞지 않는다.
  <label className=Styles.wrapper>
    <DuetDatePicker
      identifier=id
      dateAdapter={
        parse: (~value, ~createDate) =>
          dateRe
          ->Js.Re.exec_(value)
          ->Option.flatMap(result =>
            switch (
              result->Js.Re.captures->Array.get(1)->Option.flatMap(Js.Nullable.toOption), // year
              result->Js.Re.captures->Array.get(2)->Option.flatMap(Js.Nullable.toOption), // month
              result->Js.Re.captures->Array.get(3)->Option.flatMap(Js.Nullable.toOption), // day
            ) {
            | (Some(year), Some(m), Some(day)) =>
              m
              ->Int.fromString
              ->Option.map(month => createDate(~year, ~month=(month + 1)->Int.toString, ~day))
            | (_, _, _) => None
            }
          ),
        format: (~date) => date->DateFns.format("yyyy-MM-dd"),
      }
      value=?{date->Option.map(date' => date'->DateFns.format("yyyy-MM-dd"))}
      localization=DuetDatePicker.krLocalization
      onChange
      ?max
      ?min
      ?firstDayOfWeek
      ?isDateDisabled
      ?onFocus
      ?disabled
      direction={switch align {
      | Some(Left) => "left"
      | Some(Right)
      | None => "right"
      }}
    />
    <IconCalendar height="20" width="20" fill="#262626" className=%twc("absolute top-2 right-3") />
  </label>
}
