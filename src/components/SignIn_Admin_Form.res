module FormFields = %lenses(
  type state = {
    email: string,
    password: string,
  }
)

module Form = ReForm.Make(FormFields)

let initialState: FormFields.state = {
  email: "",
  password: "",
}
