type selected = Today | OneWeek | OneMonth | ThreeMonth

let defaultStyle = %twc(
  "w-16 py-1 justify-center items-center border first:rounded-l-lg first:ml-0 last:rounded-r-lg bg-white focus:outline-none -ml-0.5"
)
let styleOnOff = on =>
  on ? %twc("border-green-gl text-green-gl z-[2]") : %twc("border-gray-button-gl text-black-gl")

let getPeriod = (from, to_) => {
  if from->DateFns.isSameDay(to_) {
    Today->Some
  } else if from->DateFns.addDays(7)->DateFns.isSameDay(to_) {
    OneWeek->Some
  } else if from->DateFns.addMonths(1)->DateFns.isSameDay(to_) {
    OneMonth->Some
  } else if from->DateFns.addMonths(3)->DateFns.isSameDay(to_) {
    ThreeMonth->Some
  } else {
    None
  }
}

@react.component
let make = (~from, ~to_, ~onSelect) => {
  let period = getPeriod(from, to_)

  let handleOnSelect = s =>
    (
      _ => {
        switch s {
        | Today => onSelect(to_)
        | OneWeek => onSelect(to_->DateFns.subDays(7))
        | OneMonth => onSelect(to_->DateFns.subMonths(1))
        | ThreeMonth => onSelect(to_->DateFns.subMonths(3))
        }
      }
    )->ReactEvents.interceptingHandler

  <>
    <button
      type_="button"
      className={cx([defaultStyle, styleOnOff(period == Some(Today))])}
      onClick={handleOnSelect(Today)}>
      {j`오늘`->React.string}
    </button>
    <button
      type_="button"
      className={cx([defaultStyle, styleOnOff(period == Some(OneWeek))])}
      onClick={handleOnSelect(OneWeek)}>
      {j`1주일`->React.string}
    </button>
    <button
      type_="button"
      className={cx([defaultStyle, styleOnOff(period == Some(OneMonth))])}
      onClick={handleOnSelect(OneMonth)}>
      {j`1개월`->React.string}
    </button>
    <button
      type_="button"
      className={cx([defaultStyle, styleOnOff(period == Some(ThreeMonth))])}
      onClick={handleOnSelect(ThreeMonth)}>
      {j`3개월`->React.string}
    </button>
  </>
}
