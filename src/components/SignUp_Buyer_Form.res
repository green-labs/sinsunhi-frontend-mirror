module FormFields = %lenses(
  type state = {
    email: string,
    password: string,
    name: string,
    manager: string,
    phone: string,
    @as("business-registration-number") businessRegistrationNumber: string,
    terms: array<string>,
  }
)

module Form = ReForm.Make(FormFields)

let initialState: FormFields.state = {
  email: "",
  password: "",
  name: "",
  manager: "",
  phone: "",
  businessRegistrationNumber: "",
  terms: [],
}
