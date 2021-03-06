// Generated by ReScript, PLEASE EDIT WITH CARE

import * as ReForm from "@rescriptbr/reform/src/ReForm.mjs";

function get(values, field) {
  switch (field) {
    case /* Name */0 :
        return values.name;
    case /* Phone */1 :
        return values.phone;
    case /* Email */2 :
        return values.email;
    case /* Password */3 :
        return values.password;
    case /* Address */4 :
        return values.address;
    case /* Zipcode */5 :
        return values["zip-code"];
    case /* Role */6 :
        return values.role;
    case /* BusinessRegistrationNumber */7 :
        return values["business-registration-number"];
    case /* ProducerType */8 :
        return values["producer-type"];
    case /* Terms */9 :
        return values.terms;
    
  }
}

function set(values, field, value) {
  switch (field) {
    case /* Name */0 :
        return {
                name: value,
                phone: values.phone,
                email: values.email,
                password: values.password,
                address: values.address,
                "zip-code": values["zip-code"],
                role: values.role,
                "business-registration-number": values["business-registration-number"],
                "producer-type": values["producer-type"],
                terms: values.terms
              };
    case /* Phone */1 :
        return {
                name: values.name,
                phone: value,
                email: values.email,
                password: values.password,
                address: values.address,
                "zip-code": values["zip-code"],
                role: values.role,
                "business-registration-number": values["business-registration-number"],
                "producer-type": values["producer-type"],
                terms: values.terms
              };
    case /* Email */2 :
        return {
                name: values.name,
                phone: values.phone,
                email: value,
                password: values.password,
                address: values.address,
                "zip-code": values["zip-code"],
                role: values.role,
                "business-registration-number": values["business-registration-number"],
                "producer-type": values["producer-type"],
                terms: values.terms
              };
    case /* Password */3 :
        return {
                name: values.name,
                phone: values.phone,
                email: values.email,
                password: value,
                address: values.address,
                "zip-code": values["zip-code"],
                role: values.role,
                "business-registration-number": values["business-registration-number"],
                "producer-type": values["producer-type"],
                terms: values.terms
              };
    case /* Address */4 :
        return {
                name: values.name,
                phone: values.phone,
                email: values.email,
                password: values.password,
                address: value,
                "zip-code": values["zip-code"],
                role: values.role,
                "business-registration-number": values["business-registration-number"],
                "producer-type": values["producer-type"],
                terms: values.terms
              };
    case /* Zipcode */5 :
        return {
                name: values.name,
                phone: values.phone,
                email: values.email,
                password: values.password,
                address: values.address,
                "zip-code": value,
                role: values.role,
                "business-registration-number": values["business-registration-number"],
                "producer-type": values["producer-type"],
                terms: values.terms
              };
    case /* Role */6 :
        return {
                name: values.name,
                phone: values.phone,
                email: values.email,
                password: values.password,
                address: values.address,
                "zip-code": values["zip-code"],
                role: value,
                "business-registration-number": values["business-registration-number"],
                "producer-type": values["producer-type"],
                terms: values.terms
              };
    case /* BusinessRegistrationNumber */7 :
        return {
                name: values.name,
                phone: values.phone,
                email: values.email,
                password: values.password,
                address: values.address,
                "zip-code": values["zip-code"],
                role: values.role,
                "business-registration-number": value,
                "producer-type": values["producer-type"],
                terms: values.terms
              };
    case /* ProducerType */8 :
        return {
                name: values.name,
                phone: values.phone,
                email: values.email,
                password: values.password,
                address: values.address,
                "zip-code": values["zip-code"],
                role: values.role,
                "business-registration-number": values["business-registration-number"],
                "producer-type": value,
                terms: values.terms
              };
    case /* Terms */9 :
        return {
                name: values.name,
                phone: values.phone,
                email: values.email,
                password: values.password,
                address: values.address,
                "zip-code": values["zip-code"],
                role: values.role,
                "business-registration-number": values["business-registration-number"],
                "producer-type": values["producer-type"],
                terms: value
              };
    
  }
}

var FormFields = {
  get: get,
  set: set
};

var Form = ReForm.Make({
      set: set,
      get: get
    });

var initialState_terms = [];

var initialState = {
  name: "",
  phone: "",
  email: "",
  password: "",
  address: "",
  "zip-code": "",
  role: "farmer",
  "business-registration-number": "",
  "producer-type": "",
  terms: initialState_terms
};

function parseProductType(value) {
  if (value === "?????????") {
    return {
            TAG: /* Farm */0,
            _0: /* Nothing */5
          };
  } else if (value === "?????????") {
    return {
            TAG: /* Livestock */2,
            _0: /* Nothing */5
          };
  } else if (value === "?????????") {
    return {
            TAG: /* Seafood */1,
            _0: /* Nothing */5
          };
  } else {
    return ;
  }
}

function displayProductType(t) {
  switch (t.TAG | 0) {
    case /* Farm */0 :
        return "?????????";
    case /* Seafood */1 :
        return "?????????";
    case /* Livestock */2 :
        return "?????????";
    
  }
}

function displayProducerType(t) {
  switch (t.TAG | 0) {
    case /* Farm */0 :
        switch (t._0) {
          case /* Farmer */0 :
              return "??????";
          case /* FarmingAssociation */1 :
              return "????????????";
          case /* WholeSaler */2 :
              return "????????????";
          case /* Vendor */3 :
              return "?????????";
          case /* Others */4 :
              return "??????";
          case /* Nothing */5 :
              return "";
          
        }
    case /* Seafood */1 :
        switch (t._0) {
          case /* Fishermen */0 :
              return "??????";
          case /* WholeSaler */1 :
              return "????????????";
          case /* Vendor */2 :
              return "?????????";
          case /* Processed */3 :
              return "???????????????";
          case /* Others */4 :
              return "??????";
          case /* Nothing */5 :
              return "";
          
        }
    case /* Livestock */2 :
        switch (t._0) {
          case /* KoreanBeef */0 :
              return "??????????????????";
          case /* DirectImport */1 :
              return "????????????";
          case /* WholeSaler */2 :
              return "????????????";
          case /* Processed */3 :
              return "???????????????";
          case /* Others */4 :
              return "??????";
          case /* Nothing */5 :
              return "";
          
        }
    
  }
}

function parseProducerType(value, producerType) {
  if (producerType === undefined) {
    return ;
  }
  switch (producerType.TAG | 0) {
    case /* Farm */0 :
        if (value === "??????") {
          return {
                  TAG: /* Farm */0,
                  _0: /* Farmer */0
                };
        } else if (value === "????????????") {
          return {
                  TAG: /* Farm */0,
                  _0: /* FarmingAssociation */1
                };
        } else if (value === "????????????") {
          return {
                  TAG: /* Farm */0,
                  _0: /* WholeSaler */2
                };
        } else if (value === "?????????") {
          return {
                  TAG: /* Farm */0,
                  _0: /* Vendor */3
                };
        } else if (value === "??????") {
          return {
                  TAG: /* Farm */0,
                  _0: /* Others */4
                };
        } else {
          return ;
        }
    case /* Seafood */1 :
        if (value === "??????") {
          return {
                  TAG: /* Seafood */1,
                  _0: /* Fishermen */0
                };
        } else if (value === "????????????") {
          return {
                  TAG: /* Seafood */1,
                  _0: /* WholeSaler */1
                };
        } else if (value === "?????????") {
          return {
                  TAG: /* Seafood */1,
                  _0: /* Vendor */2
                };
        } else if (value === "???????????????") {
          return {
                  TAG: /* Seafood */1,
                  _0: /* Processed */3
                };
        } else if (value === "??????") {
          return {
                  TAG: /* Seafood */1,
                  _0: /* Others */4
                };
        } else {
          return ;
        }
    case /* Livestock */2 :
        if (value === "??????????????????") {
          return {
                  TAG: /* Livestock */2,
                  _0: /* KoreanBeef */0
                };
        } else if (value === "????????????") {
          return {
                  TAG: /* Livestock */2,
                  _0: /* DirectImport */1
                };
        } else if (value === "????????????") {
          return {
                  TAG: /* Livestock */2,
                  _0: /* WholeSaler */2
                };
        } else if (value === "???????????????") {
          return {
                  TAG: /* Livestock */2,
                  _0: /* Processed */3
                };
        } else if (value === "??????") {
          return {
                  TAG: /* Livestock */2,
                  _0: /* Others */4
                };
        } else {
          return ;
        }
    
  }
}

function stringifyProducerType(t) {
  switch (t.TAG | 0) {
    case /* Farm */0 :
        switch (t._0) {
          case /* Farmer */0 :
              return "farmer";
          case /* FarmingAssociation */1 :
              return "farming-association";
          case /* WholeSaler */2 :
              return "wholesaler";
          case /* Vendor */3 :
              return "vendor";
          case /* Others */4 :
              return "others";
          case /* Nothing */5 :
              return "";
          
        }
    case /* Seafood */1 :
        switch (t._0) {
          case /* Fishermen */0 :
              return "seafood-fishermen";
          case /* WholeSaler */1 :
              return "seafood-wholesaler";
          case /* Vendor */2 :
              return "seafood-vendor";
          case /* Processed */3 :
              return "seafood-processed";
          case /* Others */4 :
              return "seafood-others";
          case /* Nothing */5 :
              return "";
          
        }
    case /* Livestock */2 :
        switch (t._0) {
          case /* KoreanBeef */0 :
              return "livestock-korean-beef";
          case /* DirectImport */1 :
              return "livestock-direct-import";
          case /* WholeSaler */2 :
              return "livestock-wholesaler";
          case /* Processed */3 :
              return "livestock-processed";
          case /* Others */4 :
              return "livestock-others";
          case /* Nothing */5 :
              return "";
          
        }
    
  }
}

function optionValues(t) {
  if (t === undefined) {
    return [];
  }
  switch (t.TAG | 0) {
    case /* Farm */0 :
        return [
                "??????",
                "????????????",
                "????????????",
                "?????????",
                "??????"
              ];
    case /* Seafood */1 :
        return [
                "??????",
                "????????????",
                "?????????",
                "???????????????",
                "??????"
              ];
    case /* Livestock */2 :
        return [
                "??????????????????",
                "????????????",
                "????????????",
                "???????????????",
                "??????"
              ];
    
  }
}

export {
  FormFields ,
  Form ,
  initialState ,
  parseProductType ,
  displayProductType ,
  displayProducerType ,
  parseProducerType ,
  stringifyProducerType ,
  optionValues ,
  
}
/* Form Not a pure module */
