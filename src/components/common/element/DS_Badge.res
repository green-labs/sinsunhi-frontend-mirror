type colorType = [#primary | #secondary]

let colorStyle = colorType =>
  switch colorType {
  | #primary => %twc("bg-primary text-white")
  | #secondary => %twc("bg-primary bg-opacity-10 text-primary")
  }

module Medium = {
  @react.component
  let make = (~text, ~colorType=#primary) => {
    <label className={Cn.make([colorStyle(colorType), %twc("px-2 py-1 rounded-[4px] text-sm")])}>
      {text->React.string}
    </label>
  }
}
