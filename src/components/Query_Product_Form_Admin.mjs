// Generated by ReScript, PLEASE EDIT WITH CARE

import * as ReForm from "@rescriptbr/reform/src/ReForm.mjs";

function get(values, field) {
  switch (field) {
    case /* ProducerName */0 :
        return values.producerName;
    case /* ProductName */1 :
        return values.productName;
    case /* Std */2 :
        return values.std;
    
  }
}

function set(values, field, value) {
  switch (field) {
    case /* ProducerName */0 :
        return {
                producerName: value,
                productName: values.productName,
                std: values.std
              };
    case /* ProductName */1 :
        return {
                producerName: values.producerName,
                productName: value,
                std: values.std
              };
    case /* Std */2 :
        return {
                producerName: values.producerName,
                productName: values.productName,
                std: value
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

var initialState = {
  producerName: "",
  productName: "",
  std: "Crop"
};

export {
  FormFields ,
  Form ,
  initialState ,
}
/* Form Not a pure module */
