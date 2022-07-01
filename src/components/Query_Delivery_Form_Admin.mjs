// Generated by ReScript, PLEASE EDIT WITH CARE

import * as ReForm from "@rescriptbr/reform/src/ReForm.mjs";

function get(values, field) {
  switch (field) {
    case /* FarmerName */0 :
        return values.farmerName;
    case /* OrderProductNo */1 :
        return values.orderProductNo;
    case /* ProductId */2 :
        return values.productId;
    case /* OrdererName */3 :
        return values.ordererName;
    case /* ReceiverName */4 :
        return values.receiverName;
    case /* Sku */5 :
        return values.sku;
    
  }
}

function set(values, field, value) {
  switch (field) {
    case /* FarmerName */0 :
        return {
                farmerName: value,
                orderProductNo: values.orderProductNo,
                productId: values.productId,
                ordererName: values.ordererName,
                receiverName: values.receiverName,
                sku: values.sku
              };
    case /* OrderProductNo */1 :
        return {
                farmerName: values.farmerName,
                orderProductNo: value,
                productId: values.productId,
                ordererName: values.ordererName,
                receiverName: values.receiverName,
                sku: values.sku
              };
    case /* ProductId */2 :
        return {
                farmerName: values.farmerName,
                orderProductNo: values.orderProductNo,
                productId: value,
                ordererName: values.ordererName,
                receiverName: values.receiverName,
                sku: values.sku
              };
    case /* OrdererName */3 :
        return {
                farmerName: values.farmerName,
                orderProductNo: values.orderProductNo,
                productId: values.productId,
                ordererName: value,
                receiverName: values.receiverName,
                sku: values.sku
              };
    case /* ReceiverName */4 :
        return {
                farmerName: values.farmerName,
                orderProductNo: values.orderProductNo,
                productId: values.productId,
                ordererName: values.ordererName,
                receiverName: value,
                sku: values.sku
              };
    case /* Sku */5 :
        return {
                farmerName: values.farmerName,
                orderProductNo: values.orderProductNo,
                productId: values.productId,
                ordererName: values.ordererName,
                receiverName: values.receiverName,
                sku: value
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
  farmerName: "",
  orderProductNo: "",
  productId: "",
  ordererName: "",
  receiverName: "",
  sku: ""
};

export {
  FormFields ,
  Form ,
  initialState ,
  
}
/* Form Not a pure module */