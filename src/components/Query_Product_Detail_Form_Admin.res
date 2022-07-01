module FormFields = %lenses(
  type state = {
    weight: string,
    weightUnit: string,
    unitWeightMin: string,
    unitWeightMax: string,
    unitWeightUnit: string,
    unitSizeMin: string,
    unitSizeMax: string,
    unitSizeUnit: string,
    cntPerPackage: string,
    grade: string,
    packageType: string,
  }
)

module Form = ReForm.Make(FormFields)

let initialState: FormFields.state = {
  weight: "",
  weightUnit: "",
  unitWeightMin: "",
  unitWeightMax: "",
  unitWeightUnit: "",
  unitSizeMin: "",
  unitSizeMax: "",
  unitSizeUnit: "",
  cntPerPackage: "",
  grade: "",
  packageType: "",
}
