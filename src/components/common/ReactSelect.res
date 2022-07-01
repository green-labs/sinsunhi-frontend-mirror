@spice
type selectValue = {value: string, label: string}

type selectOption =
  | NotSelected
  | Selected({value: string, label: string})

type stylesOptions

let encoderRule = v => {
  switch v {
  | NotSelected => Js.Json.null
  | Selected({value, label}) =>
    [("value", value->Js.Json.string), ("label", label->Js.Json.string)]
    ->Js.Dict.fromArray
    ->Js.Json.object_
  }
}

//decode 실패일때는 NotSelected
let decoderRule = j =>
  j
  ->selectValue_decode
  ->Result.mapWithDefault(NotSelected, ({value, label}) => Selected({value: value, label: label}))
  ->Result.Ok

let codecSelectOption: Spice.codec<selectOption> = (encoderRule, decoderRule)

let toOption = (t: selectOption) => {
  switch t {
  | NotSelected => None
  | Selected({value, label}) => Some({value: value, label: label})
  }
}

@obj
external stylesOptions: (
  ~menu: ('provide, 'state) => 'result=?,
  ~control: ('provide, 'state) => 'result=?,
  unit,
) => stylesOptions = ""

@module("react-select/async") @react.component
external make: (
  ~value: selectOption,
  ~cacheOptions: bool,
  ~defaultOptions: bool,
  ~loadOptions: string => Js.Promise.t<option<array<selectOption>>>,
  ~onChange: selectOption => unit,
  ~placeholder: string=?,
  ~noOptionsMessage: string => string=?,
  ~onFocus: unit => unit=?,
  ~isClearable: bool=?,
  ~isDisabled: bool=?,
  ~styles: stylesOptions=?,
  ~ref: ReactDOM.domRef=?,
) => React.element = "default"

module Plain = {
  @module("react-select") @react.component
  external make: (
    ~value: selectOption,
    ~options: array<selectOption>,
    ~defaultValue: selectOption=?,
    ~onChange: selectOption => unit,
    ~placeholder: string=?,
    ~noOptionsMessage: string => string=?,
    ~onFocus: unit => unit=?,
    ~isClearable: bool=?,
    ~isDisabled: bool=?,
    ~styles: stylesOptions=?,
    ~ref: ReactDOM.domRef=?,
  ) => React.element = "default"
}
