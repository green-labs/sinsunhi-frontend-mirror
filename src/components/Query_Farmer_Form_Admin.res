module FormFields = %lenses(
  type state = {
    name: string,
    producerCode: string,
  }
)

module Form = ReForm.Make(FormFields)

let initialState: FormFields.state = {
  name: "",
  producerCode: "",
}
