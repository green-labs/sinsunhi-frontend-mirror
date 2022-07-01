module FormFields = %lenses(
  type state = {
    sellerName: string,
    buyerName: string,
    std: string,
  }
)

module Form = ReForm.Make(FormFields)

let initialState: FormFields.state = {
  sellerName: "",
  buyerName: "",
  std: `Crop`,
}
