//crop (작물)
//cultivar (품종)

module FormFields = %lenses(type state = {market: string, std: string})

module Form = ReForm.Make(FormFields)

let initialState: FormFields.state = {
  market: ``,
  std: `Crop`,
}
