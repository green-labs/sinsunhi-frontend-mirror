module FormFields = %lenses(
  type state = {
    phone: string,
    password: string,
  }
)

module Form = ReForm.Make(FormFields)

let initialState: FormFields.state = {
  phone: "",
  password: "",
}
