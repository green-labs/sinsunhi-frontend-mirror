module FormFields = %lenses(
  type state = {
    name: string,
    email: string,
  }
)

module Form = ReForm.Make(FormFields)

let initialState: FormFields.state = {
  name: "",
  email: "",
}
