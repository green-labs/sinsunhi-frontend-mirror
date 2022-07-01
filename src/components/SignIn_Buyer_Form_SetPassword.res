module FormFields = %lenses(
  type state = {
    @as("redirect-token") redirectToken: string,
    password: string,
  }
)

module Form = ReForm.Make(FormFields)

let initialState: FormFields.state = {
  redirectToken: "",
  password: "",
}
