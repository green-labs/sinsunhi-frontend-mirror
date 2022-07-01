module FormFields = %lenses(
  type state = {
    productName: string,
  }
)

module Form = ReForm.Make(FormFields)

let initialState: FormFields.state = {
  productName: "",
}
