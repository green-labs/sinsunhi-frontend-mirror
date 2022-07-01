open SignUp_Seller_Types

module FormFields = %lenses(
  type state = {
    name: string,
    phone: string,
    email: string,
    password: string,
    address: string,
    @as("zip-code") zipcode: string,
    role: string, // 'farmer' 'buyer' 'admin'
    @as("business-registration-number") businessRegistrationNumber: string,
    @as("producer-type") producerType: string, // 'farmer' 'farming-association' 'wholesaler' 'vendor' 'others'
    terms: array<string>,
  }
)

module Form = ReForm.Make(FormFields)

let initialState: FormFields.state = {
  name: "",
  phone: "",
  email: "",
  password: "",
  address: "",
  zipcode: "",
  role: "farmer",
  businessRegistrationNumber: "",
  producerType: "",
  terms: [],
}

let parseProductType = value => {
  if value == `농산물` {
    Some(Farm(Nothing))
  } else if value == `축산물` {
    Some(Livestock(Nothing))
  } else if value == `수산물` {
    Some(Seafood(Nothing))
  } else {
    None
  }
}

let displayProductType = t =>
  switch t {
  | Farm(_) => `농산물`
  | Livestock(_) => `축산물`
  | Seafood(_) => `수산물`
  }

let displayProducerType = t =>
  switch t {
  | Farm(Farmer) => `농민`
  | Farm(FarmingAssociation) => `영농조합`
  | Farm(WholeSaler) => `중도매인`
  | Farm(Vendor) => `벤더사`
  | Farm(Others) => `기타`
  | Seafood(Fishermen) => `어민`
  | Seafood(WholeSaler) => `도소매인`
  | Seafood(Vendor) => `벤더사`
  | Seafood(Processed) => `가공제조업`
  | Seafood(Others) => `기타`
  | Livestock(KoreanBeef) => `한우중도매인`
  | Livestock(DirectImport) => `직수입사`
  | Livestock(WholeSaler) => `도소매인`
  | Livestock(Processed) => `가공제조업`
  | Livestock(Others) => `기타`
  | _ => ``
  }

let parseProducerType = (value, producerType) => {
  switch producerType {
  | Some(Farm(_)) if value == `농민` => Some(Farm(Farmer))
  | Some(Farm(_)) if value == `영농조합` => Some(Farm(FarmingAssociation))
  | Some(Farm(_)) if value == `중도매인` => Some(Farm(WholeSaler))
  | Some(Farm(_)) if value == `벤더사` => Some(Farm(Vendor))
  | Some(Farm(_)) if value == `기타` => Some(Farm(Others))
  | Some(Seafood(_)) if value == `어민` => Some(Seafood(Fishermen))
  | Some(Seafood(_)) if value == `도소매인` => Some(Seafood(WholeSaler))
  | Some(Seafood(_)) if value == `벤더사` => Some(Seafood(Vendor))
  | Some(Seafood(_)) if value == `가공제조업` => Some(Seafood(Processed))
  | Some(Seafood(_)) if value == `기타` => Some(Seafood(Others))
  | Some(Livestock(_)) if value == `한우중도매인` => Some(Livestock(KoreanBeef))
  | Some(Livestock(_)) if value == `직수입사` => Some(Livestock(DirectImport))
  | Some(Livestock(_)) if value == `도소매인` => Some(Livestock(WholeSaler))
  | Some(Livestock(_)) if value == `가공제조업` => Some(Livestock(Processed))
  | Some(Livestock(_)) if value == `기타` => Some(Livestock(Others))
  | _ => None
  }
}

let stringifyProducerType = t => {
  switch t {
  | Farm(Farmer) => "farmer"
  | Farm(FarmingAssociation) => "farming-association"
  | Farm(WholeSaler) => "wholesaler"
  | Farm(Vendor) => "vendor"
  | Farm(Others) => "others"
  | Seafood(Fishermen) => "seafood-fishermen"
  | Seafood(WholeSaler) => "seafood-wholesaler"
  | Seafood(Vendor) => "seafood-vendor"
  | Seafood(Processed) => "seafood-processed"
  | Seafood(Others) => "seafood-others"
  | Livestock(KoreanBeef) => "livestock-korean-beef"
  | Livestock(DirectImport) => "livestock-direct-import"
  | Livestock(WholeSaler) => "livestock-wholesaler"
  | Livestock(Processed) => "livestock-processed"
  | Livestock(Others) => "livestock-others"
  | _ => ""
  }
}

let optionValues = t =>
  switch t {
  | Some(Farm(_)) => [`농민`, `영농조합`, `중도매인`, `벤더사`, `기타`]
  | Some(Seafood(_)) => [`어민`, `도소매인`, `벤더사`, `가공제조업`, `기타`]
  | Some(Livestock(_)) => [
      `한우중도매인`,
      `직수입사`,
      `도소매인`,
      `가공제조업`,
      `기타`,
    ]
  | _ => []
  }
