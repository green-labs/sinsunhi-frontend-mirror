open CustomEvent

type localization_t = {
  buttonLabel: string,
  placeholder: string,
  selectedDateMessage: string,
  prevMonthLabel: string,
  nextMonthLabel: string,
  monthSelectLabel: string,
  yearSelectLabel: string,
  closeLabel: string,
  keyboardInstruction: string,
  calendarHeading: string,
  dayNames: array<string>,
  monthNames: array<string>,
  monthNamesShort: array<string>,
}

type createDate_t = (~year: string, ~month: string, ~day: string) => Js.Date.t

type duetDateParser_t = (~value: string, ~createDate: createDate_t) => option<Js.Date.t>
type duetDateFormatter_t = (~date: Js.Date.t) => string
type dateAdapter_t = {
  parse: duetDateParser_t,
  format: duetDateFormatter_t,
}

module DuetOnChangeDetail = {
  type t = {
    component: string,
    valueAsDate: option<Js.Date.t>,
    value: string,
  }
}

module DuetOnBlurDetail = {
  type t = {component: string}
}

module DuetOnFocusDetail = {
  type t = {component: string}
}

module DuetOnChangeEvent = MakeCustomEvent(DuetOnChangeDetail)
module DuetOnBlurEvent = MakeCustomEvent(DuetOnBlurDetail)
module DuetOnFocusEvent = MakeCustomEvent(DuetOnFocusDetail)

@module("./DuetDatePicker.jsx") @react.component
external make: (
  ~identifier: string=?,
  ~children: React.element=?,
  ~value: string=?,
  ~dateAdapter: dateAdapter_t=?,
  ~localization: localization_t=?,
  ~onChange: DuetOnChangeEvent.t => unit=?,
  ~onBlur: DuetOnBlurEvent.t => unit=?,
  ~onFocus: DuetOnFocusEvent.t => unit=?,
  ~max: string=?,
  ~min: string=?,
  ~firstDayOfWeek: int=?,
  ~direction: string=?,
  ~isDateDisabled: Js.Date.t => bool=?,
  ~disabled: bool=?,
) => React.element = "DatePicker"

let krMonths = Array.range(1, 12)->Array.map(n => j`$n월`)

let krLocalization: localization_t = {
  buttonLabel: "",
  placeholder: "YYYY-MM-DD",
  selectedDateMessage: "",
  prevMonthLabel: "",
  nextMonthLabel: "",
  monthSelectLabel: "",
  yearSelectLabel: "",
  closeLabel: "",
  keyboardInstruction: "",
  calendarHeading: "",
  dayNames: [j`일`, j`월`, j`화`, j`수`, j`목`, j`금`, j`토`],
  monthNames: krMonths,
  monthNamesShort: krMonths,
}
{
  open CssJs
  global(.
    "",
    [
      selector(
        ":root",
        [
          unsafe("--duet-color-primary", "#005fcc"),
          unsafe("--duet-color-text", "#333"),
          unsafe("--duet-color-text-active", "#fff"),
          unsafe("--duet-color-button", "#f55f5"),
          unsafe("--duet-color-surface", "#fff"),
          unsafe("--duet-color-overlay", "rgba(0, 0, 0, 0.8)"),
          unsafe(
            "--duet---duet-font",
            "-apple-system, BlinkMacSystemFont, \"Segoe UI\", Roboto, Helvetica, Arial, sans-serif;",
          ),
          unsafe("--duet-font-normal", "400"),
          unsafe("--duet-font-bold", "600"),
          unsafe("--duet-radius", "4px"),
          unsafe("--duet-z-index", "600"),
        ],
      ),
    ],
  )
}

let today = Js.Date.make()->Js.Date.toISOString->Js.String2.slice(~from=0, ~to_=10)
