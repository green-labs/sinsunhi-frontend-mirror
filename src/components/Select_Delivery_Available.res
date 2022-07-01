@spice
type status =
  | @spice.as("all") ALL | @spice.as("available") AVAILABLE | @spice.as("unavailable") UNAVAILABLE

@react.component
let make = (~value: status, ~onChange, ~name) => {
  <RadixUI.RadioGroup.Root
    name
    value={value->status_encode->Js.Json.decodeString->Option.getWithDefault("all")}
    onValueChange={onChange}
    className=%twc("flex items-center")>
    //전체
    <RadixUI.RadioGroup.Item value="all" className=%twc("radio-item") id="delivery-all">
      <RadixUI.RadioGroup.Indicator className=%twc("radio-indicator") />
    </RadixUI.RadioGroup.Item>
    <label htmlFor="delivery-all" className=%twc("ml-2 mr-6")> {`전체`->React.string} </label>
    //가능
    <RadixUI.RadioGroup.Item value="available" className=%twc("radio-item") id="delivery-available">
      <RadixUI.RadioGroup.Indicator className=%twc("radio-indicator") />
    </RadixUI.RadioGroup.Item>
    <label htmlFor="delivery-available" className=%twc("ml-2 mr-6")>
      {`가능`->React.string}
    </label>
    //불가능
    <RadixUI.RadioGroup.Item
      value="unavailable" className=%twc("radio-item") id="delivery-unavailable">
      <RadixUI.RadioGroup.Indicator className=%twc("radio-indicator") />
    </RadixUI.RadioGroup.Item>
    <label htmlFor="delivery-unavailable" className=%twc("ml-2 mr-6")>
      {`불가능`->React.string}
    </label>
  </RadixUI.RadioGroup.Root>
}
