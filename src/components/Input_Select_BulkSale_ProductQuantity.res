let decodePackageUnit = s =>
  if s == "kg" {
    Ok(#KG)
  } else if s == "g" {
    Ok(#G)
  } else if s == "mg" {
    Ok(#MG)
  } else {
    Error()
  }

let stringifyPackageUnit = s =>
  switch s {
  | #KG => "kg"
  | #G => "g"
  | #MG => "mg"
  }

@react.component
let make = (~quantityAmount, ~quantityUnit, ~onChangeAmount, ~onChangeUnit, ~error) => {
  <div className=%twc("flex-1 flex gap-2 mt-2")>
    <Input
      type_="number"
      name="product-package-amount"
      className=%twc("flex-1 h-9")
      size=Input.Small
      placeholder="0"
      value={quantityAmount->Option.getWithDefault("")}
      onChange={onChangeAmount}
      error
      textAlign=Input.Right
    />
    <label className=%twc("w-24 relative")>
      <span
        className=%twc(
          "flex items-center border border-border-default-L1 rounded-lg h-9 px-3 text-enabled-L1 bg-white"
        )>
        {quantityUnit->stringifyPackageUnit->React.string}
      </span>
      <span className=%twc("absolute top-1.5 right-2")>
        <IconArrowSelect height="24" width="24" fill="#121212" />
      </span>
      <select
        value={quantityUnit->stringifyPackageUnit}
        className=%twc("block w-full h-full absolute top-0 opacity-0")
        onChange=onChangeUnit>
        {[#KG, #G, #MG]
        ->Array.map(unit =>
          <option key={unit->stringifyPackageUnit} value={unit->stringifyPackageUnit}>
            {unit->stringifyPackageUnit->React.string}
          </option>
        )
        ->React.array}
      </select>
    </label>
  </div>
}
