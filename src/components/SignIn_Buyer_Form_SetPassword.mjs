// Generated by ReScript, PLEASE EDIT WITH CARE

import * as ReForm from "@rescriptbr/reform/src/ReForm.mjs";

function get(values, field) {
  if (field) {
    return values.password;
  } else {
    return values["redirect-token"];
  }
}

function set(values, field, value) {
  if (field) {
    return {
            "redirect-token": values["redirect-token"],
            password: value
          };
  } else {
    return {
            "redirect-token": value,
            password: values.password
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
  "redirect-token": "",
  password: ""
};

export {
  FormFields ,
  Form ,
  initialState ,
  
}
/* Form Not a pure module */
