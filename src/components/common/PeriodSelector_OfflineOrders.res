type selected = Before7Days | Yesterday | ThisMonth | LastMonth

let {defaultStyle, styleOnOff} = module(PeriodSelector)

let getPeriod = (from, to_) => {
  if from->DateFns.addDays(7)->DateFns.isSameDay(to_) {
    Before7Days->Some
  } else if from->DateFns.isSameDay(to_) && from->DateFns.addDays(1)->DateFns.isToday {
    Yesterday->Some
  } else if (
    from->DateFns.getDate === 1 &&
    to_->DateFns.isLastDayOfMonth &&
    DateFns.isSameMonth(from, to_) &&
    to_->DateFns.isThisMonth
  ) {
    ThisMonth->Some
  } else if (
    from->DateFns.getDate === 1 &&
    to_->DateFns.isLastDayOfMonth &&
    from->DateFns.addMonths(1)->DateFns.isThisMonth
  ) {
    LastMonth->Some
  } else {
    None
  }
}

let setPeriod = (setFn, period, to_) => {
  let today = Js.Date.make()
  switch period {
  | Before7Days => setFn(to_->DateFns.subDays(7), to_)
  | Yesterday => setFn(today->DateFns.subDays(1), today->DateFns.subDays(1))
  | ThisMonth => setFn(today->DateFns.setDate(1), today->DateFns.endOfMonth)
  | LastMonth =>
    setFn(
      today->DateFns.subMonths(1)->DateFns.setDate(1),
      today->DateFns.subMonths(1)->DateFns.endOfMonth,
    )
  }
}

@react.component
let make = (~from, ~to_, ~onSelect) => {
  let period = getPeriod(from, to_)

  <>
    <button
      type_="button"
      className={cx([defaultStyle, styleOnOff(period == Some(Before7Days))])}
      onClick={_ => setPeriod(onSelect, Before7Days, to_)}>
      {j`직전 7일`->React.string}
    </button>
    <button
      type_="button"
      className={cx([defaultStyle, styleOnOff(period == Some(Yesterday))])}
      onClick={_ => setPeriod(onSelect, Yesterday, to_)}>
      {j`어제`->React.string}
    </button>
    <button
      type_="button"
      className={cx([defaultStyle, styleOnOff(period == Some(ThisMonth))])}
      onClick={_ => setPeriod(onSelect, ThisMonth, to_)}>
      {j`이번달`->React.string}
    </button>
    <button
      type_="button"
      className={cx([defaultStyle, styleOnOff(period == Some(LastMonth))])}
      onClick={_ => setPeriod(onSelect, LastMonth, to_)}>
      {j`지난달`->React.string}
    </button>
  </>
}
