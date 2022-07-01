type intl

type intlOptions = {
  minimumFractionDigits: option<int>,
  style: [#decimal | #currency],
  currency: option<string>,
}

@new @scope("Intl")
external numberFormat: (option<string>, intlOptions) => intl = "NumberFormat"

@send external format: (intl, float) => string = "format"

module Currency = {
  let make = (~value: float, ~locale=None, ~currency=None, ~minimumFractionDigits=Some(0), ()) => {
    locale
    ->numberFormat({
      style: #decimal,
      currency: currency,
      minimumFractionDigits: minimumFractionDigits,
    })
    ->format(value)
  }
}
