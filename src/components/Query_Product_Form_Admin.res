module FormFields = %lenses(
  type state = {
    producerName: string,
    productName: string,
    std: string,
  }
)

module Form = ReForm.Make(FormFields)

let initialState: FormFields.state = {
  producerName: "",
  productName: "",
  std: "Crop",
}
