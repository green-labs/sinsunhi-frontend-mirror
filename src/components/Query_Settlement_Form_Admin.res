module FormFields = %lenses(
  type state = {
    producerName: string,
    producerCodes: string,
  }
)

module Form = ReForm.Make(FormFields)

let initialState: FormFields.state = {
  producerName: "",
  producerCodes: "",
}
