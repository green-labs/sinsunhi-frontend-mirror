module FormFields = %lenses(
  type state = {
    producerName: string,
    productName: string,
    productIdsOrSkus: string,
  }
)

module Form = ReForm.Make(FormFields)

let initialState: FormFields.state = {
  producerName: "",
  productName: "",
  productIdsOrSkus: "",
}
