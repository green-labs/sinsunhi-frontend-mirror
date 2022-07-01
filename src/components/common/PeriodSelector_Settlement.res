type selected = LastWeek | FirstHalfMonth | SecondHalfMonth | OneMonth

let {defaultStyle, styleOnOff} = module(PeriodSelector)

let getPeriod = (from, to_) => {
  if from->DateFns.addDays(7)->DateFns.isSameDay(to_) {
    LastWeek->Some
  } else if (
    from->DateFns.getDate === 1 && to_->DateFns.getDate === 15 && DateFns.isSameMonth(from, to_)
  ) {
    FirstHalfMonth->Some
  } else if (
    from->DateFns.getDate === 16 && to_->DateFns.isLastDayOfMonth && DateFns.isSameMonth(from, to_)
  ) {
    SecondHalfMonth->Some
  } else if from->DateFns.addMonths(1)->DateFns.isSameDay(to_) {
    OneMonth->Some
  } else {
    None
  }
}

let setPeriod = (setFn, period, to_) =>
  switch period {
  | LastWeek => setFn(to_->DateFns.subDays(7), to_)
  | FirstHalfMonth => setFn(to_->DateFns.setDate(1), to_->DateFns.setDate(15))
  | SecondHalfMonth => setFn(to_->DateFns.setDate(16), to_->DateFns.endOfMonth)
  | OneMonth => setFn(to_->DateFns.subMonths(1), to_)
  }

@react.component
let make = (~from, ~to_, ~onSelect) => {
  let period = getPeriod(from, to_)

  <>
    <button
      type_="button"
      className={cx([defaultStyle, styleOnOff(period == Some(LastWeek))])}
      onClick={_ => setPeriod(onSelect, LastWeek, to_)}>
      {j`지난주`->React.string}
    </button>
    <button
      type_="button"
      className={cx([defaultStyle, styleOnOff(period == Some(FirstHalfMonth))])}
      onClick={_ => setPeriod(onSelect, FirstHalfMonth, to_)}>
      {j`1~15일`->React.string}
    </button>
    <button
      type_="button"
      className={cx([defaultStyle, styleOnOff(period == Some(SecondHalfMonth))])}
      onClick={_ => setPeriod(onSelect, SecondHalfMonth, to_)}>
      {j`16~말일`->React.string}
    </button>
    <button
      type_="button"
      className={cx([defaultStyle, styleOnOff(period == Some(OneMonth))])}
      onClick={_ => setPeriod(onSelect, OneMonth, to_)}>
      {j`1개월`->React.string}
    </button>
  </>
}
