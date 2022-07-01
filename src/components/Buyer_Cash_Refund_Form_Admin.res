module FormFields = %lenses(
  type state = {
    tid: string,
    amount: string,
    reason: string,
  }
)

module Form = ReForm.Make(FormFields)

let initialState: FormFields.state = {
  tid: "",
  amount: "",
  reason: "",
}
