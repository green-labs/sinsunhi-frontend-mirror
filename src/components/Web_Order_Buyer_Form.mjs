// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Spice from "@greenlabs/ppx-spice/src/rescript/Spice.mjs";
import * as Js_dict from "rescript/lib/es6/js_dict.js";
import * as Js_json from "rescript/lib/es6/js_json.js";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";

var name = "web-order";

function deliveryType_encode(v) {
  if (v === "PARCEL") {
    return "parcel";
  } else if (v === "SELF") {
    return "self";
  } else {
    return "freight";
  }
}

function deliveryType_decode(v) {
  var str = Js_json.classify(v);
  if (typeof str === "number") {
    return Spice.error(undefined, "Not a JSONString", v);
  }
  if (str.TAG !== /* JSONString */0) {
    return Spice.error(undefined, "Not a JSONString", v);
  }
  var str$1 = str._0;
  if ("parcel" === str$1) {
    return {
            TAG: /* Ok */0,
            _0: "PARCEL"
          };
  } else if ("freight" === str$1) {
    return {
            TAG: /* Ok */0,
            _0: "FREIGHT"
          };
  } else if ("self" === str$1) {
    return {
            TAG: /* Ok */0,
            _0: "SELF"
          };
  } else {
    return Spice.error(undefined, "Not matched", v);
  }
}

function paymentMethod_encode(v) {
  if (v === "CREDIT_CARD") {
    return "card";
  } else if (v === "TRANSFER") {
    return "transfer";
  } else {
    return "virtual";
  }
}

function paymentMethod_decode(v) {
  var str = Js_json.classify(v);
  if (typeof str === "number") {
    return Spice.error(undefined, "Not a JSONString", v);
  }
  if (str.TAG !== /* JSONString */0) {
    return Spice.error(undefined, "Not a JSONString", v);
  }
  var str$1 = str._0;
  if ("card" === str$1) {
    return {
            TAG: /* Ok */0,
            _0: "CREDIT_CARD"
          };
  } else if ("virtual" === str$1) {
    return {
            TAG: /* Ok */0,
            _0: "VIRTUAL_ACCOUNT"
          };
  } else if ("transfer" === str$1) {
    return {
            TAG: /* Ok */0,
            _0: "TRANSFER"
          };
  } else {
    return Spice.error(undefined, "Not matched", v);
  }
}

function productOptions_encode(v) {
  return Js_dict.fromArray([
              [
                "delivery-cost",
                Spice.optionToJson(Spice.intToJson, v.deliveryCost)
              ],
              [
                "delivery-desired-date",
                Spice.optionToJson(Spice.stringToJson, v.deliveryDesiredDate)
              ],
              [
                "delivery-message",
                Spice.optionToJson(Spice.stringToJson, v.deliveryMessage)
              ],
              [
                "delivery-type",
                deliveryType_encode(v.deliveryType)
              ],
              [
                "grade",
                Spice.optionToJson(Spice.stringToJson, v.grade)
              ],
              [
                "is-tax-free",
                Spice.boolToJson(v.isTaxFree)
              ],
              [
                "orderer-name",
                Spice.stringToJson(v.ordererName)
              ],
              [
                "orderer-phone",
                Spice.stringToJson(v.ordererPhone)
              ],
              [
                "price",
                Spice.intToJson(v.price)
              ],
              [
                "product-id",
                Spice.intToJson(v.productId)
              ],
              [
                "product-name",
                Spice.stringToJson(v.productName)
              ],
              [
                "product-option-name",
                Spice.stringToJson(v.productOptionName)
              ],
              [
                "quantity",
                Spice.intToJson(v.quantity)
              ],
              [
                "receiver-address",
                Spice.optionToJson(Spice.stringToJson, v.receiverAddress)
              ],
              [
                "receiver-name",
                Spice.optionToJson(Spice.stringToJson, v.receiverName)
              ],
              [
                "receiver-phone",
                Spice.optionToJson(Spice.stringToJson, v.receiverPhone)
              ],
              [
                "receiver-zipcode",
                Spice.optionToJson(Spice.stringToJson, v.receiverZipCode)
              ],
              [
                "receiver-detail-address",
                Spice.optionToJson(Spice.stringToJson, v.receiverDetailAddress)
              ],
              [
                "stock-sku",
                Spice.stringToJson(v.stockSku)
              ]
            ]);
}

function productOptions_decode(v) {
  var dict = Js_json.classify(v);
  if (typeof dict === "number") {
    return Spice.error(undefined, "Not an object", v);
  }
  if (dict.TAG !== /* JSONObject */2) {
    return Spice.error(undefined, "Not an object", v);
  }
  var dict$1 = dict._0;
  var deliveryCost = Spice.optionFromJson(Spice.intFromJson, Belt_Option.getWithDefault(Js_dict.get(dict$1, "delivery-cost"), null));
  if (deliveryCost.TAG === /* Ok */0) {
    var deliveryDesiredDate = Spice.optionFromJson(Spice.stringFromJson, Belt_Option.getWithDefault(Js_dict.get(dict$1, "delivery-desired-date"), null));
    if (deliveryDesiredDate.TAG === /* Ok */0) {
      var deliveryMessage = Spice.optionFromJson(Spice.stringFromJson, Belt_Option.getWithDefault(Js_dict.get(dict$1, "delivery-message"), null));
      if (deliveryMessage.TAG === /* Ok */0) {
        var deliveryType = deliveryType_decode(Belt_Option.getWithDefault(Js_dict.get(dict$1, "delivery-type"), null));
        if (deliveryType.TAG === /* Ok */0) {
          var grade = Spice.optionFromJson(Spice.stringFromJson, Belt_Option.getWithDefault(Js_dict.get(dict$1, "grade"), null));
          if (grade.TAG === /* Ok */0) {
            var isTaxFree = Spice.boolFromJson(Belt_Option.getWithDefault(Js_dict.get(dict$1, "is-tax-free"), null));
            if (isTaxFree.TAG === /* Ok */0) {
              var ordererName = Spice.stringFromJson(Belt_Option.getWithDefault(Js_dict.get(dict$1, "orderer-name"), null));
              if (ordererName.TAG === /* Ok */0) {
                var ordererPhone = Spice.stringFromJson(Belt_Option.getWithDefault(Js_dict.get(dict$1, "orderer-phone"), null));
                if (ordererPhone.TAG === /* Ok */0) {
                  var price = Spice.intFromJson(Belt_Option.getWithDefault(Js_dict.get(dict$1, "price"), null));
                  if (price.TAG === /* Ok */0) {
                    var productId = Spice.intFromJson(Belt_Option.getWithDefault(Js_dict.get(dict$1, "product-id"), null));
                    if (productId.TAG === /* Ok */0) {
                      var productName = Spice.stringFromJson(Belt_Option.getWithDefault(Js_dict.get(dict$1, "product-name"), null));
                      if (productName.TAG === /* Ok */0) {
                        var productOptionName = Spice.stringFromJson(Belt_Option.getWithDefault(Js_dict.get(dict$1, "product-option-name"), null));
                        if (productOptionName.TAG === /* Ok */0) {
                          var quantity = Spice.intFromJson(Belt_Option.getWithDefault(Js_dict.get(dict$1, "quantity"), null));
                          if (quantity.TAG === /* Ok */0) {
                            var receiverAddress = Spice.optionFromJson(Spice.stringFromJson, Belt_Option.getWithDefault(Js_dict.get(dict$1, "receiver-address"), null));
                            if (receiverAddress.TAG === /* Ok */0) {
                              var receiverName = Spice.optionFromJson(Spice.stringFromJson, Belt_Option.getWithDefault(Js_dict.get(dict$1, "receiver-name"), null));
                              if (receiverName.TAG === /* Ok */0) {
                                var receiverPhone = Spice.optionFromJson(Spice.stringFromJson, Belt_Option.getWithDefault(Js_dict.get(dict$1, "receiver-phone"), null));
                                if (receiverPhone.TAG === /* Ok */0) {
                                  var receiverZipCode = Spice.optionFromJson(Spice.stringFromJson, Belt_Option.getWithDefault(Js_dict.get(dict$1, "receiver-zipcode"), null));
                                  if (receiverZipCode.TAG === /* Ok */0) {
                                    var receiverDetailAddress = Spice.optionFromJson(Spice.stringFromJson, Belt_Option.getWithDefault(Js_dict.get(dict$1, "receiver-detail-address"), null));
                                    if (receiverDetailAddress.TAG === /* Ok */0) {
                                      var stockSku = Spice.stringFromJson(Belt_Option.getWithDefault(Js_dict.get(dict$1, "stock-sku"), null));
                                      if (stockSku.TAG === /* Ok */0) {
                                        return {
                                                TAG: /* Ok */0,
                                                _0: {
                                                  deliveryCost: deliveryCost._0,
                                                  deliveryDesiredDate: deliveryDesiredDate._0,
                                                  deliveryMessage: deliveryMessage._0,
                                                  deliveryType: deliveryType._0,
                                                  grade: grade._0,
                                                  isTaxFree: isTaxFree._0,
                                                  ordererName: ordererName._0,
                                                  ordererPhone: ordererPhone._0,
                                                  price: price._0,
                                                  productId: productId._0,
                                                  productName: productName._0,
                                                  productOptionName: productOptionName._0,
                                                  quantity: quantity._0,
                                                  receiverAddress: receiverAddress._0,
                                                  receiverName: receiverName._0,
                                                  receiverPhone: receiverPhone._0,
                                                  receiverZipCode: receiverZipCode._0,
                                                  receiverDetailAddress: receiverDetailAddress._0,
                                                  stockSku: stockSku._0
                                                }
                                              };
                                      }
                                      var e = stockSku._0;
                                      return {
                                              TAG: /* Error */1,
                                              _0: {
                                                path: ".stock-sku" + e.path,
                                                message: e.message,
                                                value: e.value
                                              }
                                            };
                                    }
                                    var e$1 = receiverDetailAddress._0;
                                    return {
                                            TAG: /* Error */1,
                                            _0: {
                                              path: ".receiver-detail-address" + e$1.path,
                                              message: e$1.message,
                                              value: e$1.value
                                            }
                                          };
                                  }
                                  var e$2 = receiverZipCode._0;
                                  return {
                                          TAG: /* Error */1,
                                          _0: {
                                            path: ".receiver-zipcode" + e$2.path,
                                            message: e$2.message,
                                            value: e$2.value
                                          }
                                        };
                                }
                                var e$3 = receiverPhone._0;
                                return {
                                        TAG: /* Error */1,
                                        _0: {
                                          path: ".receiver-phone" + e$3.path,
                                          message: e$3.message,
                                          value: e$3.value
                                        }
                                      };
                              }
                              var e$4 = receiverName._0;
                              return {
                                      TAG: /* Error */1,
                                      _0: {
                                        path: ".receiver-name" + e$4.path,
                                        message: e$4.message,
                                        value: e$4.value
                                      }
                                    };
                            }
                            var e$5 = receiverAddress._0;
                            return {
                                    TAG: /* Error */1,
                                    _0: {
                                      path: ".receiver-address" + e$5.path,
                                      message: e$5.message,
                                      value: e$5.value
                                    }
                                  };
                          }
                          var e$6 = quantity._0;
                          return {
                                  TAG: /* Error */1,
                                  _0: {
                                    path: ".quantity" + e$6.path,
                                    message: e$6.message,
                                    value: e$6.value
                                  }
                                };
                        }
                        var e$7 = productOptionName._0;
                        return {
                                TAG: /* Error */1,
                                _0: {
                                  path: ".product-option-name" + e$7.path,
                                  message: e$7.message,
                                  value: e$7.value
                                }
                              };
                      }
                      var e$8 = productName._0;
                      return {
                              TAG: /* Error */1,
                              _0: {
                                path: ".product-name" + e$8.path,
                                message: e$8.message,
                                value: e$8.value
                              }
                            };
                    }
                    var e$9 = productId._0;
                    return {
                            TAG: /* Error */1,
                            _0: {
                              path: ".product-id" + e$9.path,
                              message: e$9.message,
                              value: e$9.value
                            }
                          };
                  }
                  var e$10 = price._0;
                  return {
                          TAG: /* Error */1,
                          _0: {
                            path: ".price" + e$10.path,
                            message: e$10.message,
                            value: e$10.value
                          }
                        };
                }
                var e$11 = ordererPhone._0;
                return {
                        TAG: /* Error */1,
                        _0: {
                          path: ".orderer-phone" + e$11.path,
                          message: e$11.message,
                          value: e$11.value
                        }
                      };
              }
              var e$12 = ordererName._0;
              return {
                      TAG: /* Error */1,
                      _0: {
                        path: ".orderer-name" + e$12.path,
                        message: e$12.message,
                        value: e$12.value
                      }
                    };
            }
            var e$13 = isTaxFree._0;
            return {
                    TAG: /* Error */1,
                    _0: {
                      path: ".is-tax-free" + e$13.path,
                      message: e$13.message,
                      value: e$13.value
                    }
                  };
          }
          var e$14 = grade._0;
          return {
                  TAG: /* Error */1,
                  _0: {
                    path: ".grade" + e$14.path,
                    message: e$14.message,
                    value: e$14.value
                  }
                };
        }
        var e$15 = deliveryType._0;
        return {
                TAG: /* Error */1,
                _0: {
                  path: ".delivery-type" + e$15.path,
                  message: e$15.message,
                  value: e$15.value
                }
              };
      }
      var e$16 = deliveryMessage._0;
      return {
              TAG: /* Error */1,
              _0: {
                path: ".delivery-message" + e$16.path,
                message: e$16.message,
                value: e$16.value
              }
            };
    }
    var e$17 = deliveryDesiredDate._0;
    return {
            TAG: /* Error */1,
            _0: {
              path: ".delivery-desired-date" + e$17.path,
              message: e$17.message,
              value: e$17.value
            }
          };
  }
  var e$18 = deliveryCost._0;
  return {
          TAG: /* Error */1,
          _0: {
            path: ".delivery-cost" + e$18.path,
            message: e$18.message,
            value: e$18.value
          }
        };
}

function webOrder_encode(v) {
  return Js_dict.fromArray([
              [
                "order-user-id",
                Spice.intToJson(v.orderUserId)
              ],
              [
                "payment-purpose",
                Spice.stringToJson(v.paymentPurpose)
              ],
              [
                "total-delivery-cost",
                Spice.intToJson(v.totalDeliveryCost)
              ],
              [
                "total-order-price",
                Spice.intToJson(v.totalOrderPrice)
              ],
              [
                "product-options",
                Spice.arrayToJson(productOptions_encode, v.productOptions)
              ],
              [
                "payment-method",
                paymentMethod_encode(v.paymentMethod)
              ]
            ]);
}

function webOrder_decode(v) {
  var dict = Js_json.classify(v);
  if (typeof dict === "number") {
    return Spice.error(undefined, "Not an object", v);
  }
  if (dict.TAG !== /* JSONObject */2) {
    return Spice.error(undefined, "Not an object", v);
  }
  var dict$1 = dict._0;
  var orderUserId = Spice.intFromJson(Belt_Option.getWithDefault(Js_dict.get(dict$1, "order-user-id"), null));
  if (orderUserId.TAG === /* Ok */0) {
    var paymentPurpose = Spice.stringFromJson(Belt_Option.getWithDefault(Js_dict.get(dict$1, "payment-purpose"), null));
    if (paymentPurpose.TAG === /* Ok */0) {
      var totalDeliveryCost = Spice.intFromJson(Belt_Option.getWithDefault(Js_dict.get(dict$1, "total-delivery-cost"), null));
      if (totalDeliveryCost.TAG === /* Ok */0) {
        var totalOrderPrice = Spice.intFromJson(Belt_Option.getWithDefault(Js_dict.get(dict$1, "total-order-price"), null));
        if (totalOrderPrice.TAG === /* Ok */0) {
          var productOptions = Spice.arrayFromJson(productOptions_decode, Belt_Option.getWithDefault(Js_dict.get(dict$1, "product-options"), null));
          if (productOptions.TAG === /* Ok */0) {
            var paymentMethod = paymentMethod_decode(Belt_Option.getWithDefault(Js_dict.get(dict$1, "payment-method"), null));
            if (paymentMethod.TAG === /* Ok */0) {
              return {
                      TAG: /* Ok */0,
                      _0: {
                        orderUserId: orderUserId._0,
                        paymentPurpose: paymentPurpose._0,
                        totalDeliveryCost: totalDeliveryCost._0,
                        totalOrderPrice: totalOrderPrice._0,
                        productOptions: productOptions._0,
                        paymentMethod: paymentMethod._0
                      }
                    };
            }
            var e = paymentMethod._0;
            return {
                    TAG: /* Error */1,
                    _0: {
                      path: ".payment-method" + e.path,
                      message: e.message,
                      value: e.value
                    }
                  };
          }
          var e$1 = productOptions._0;
          return {
                  TAG: /* Error */1,
                  _0: {
                    path: ".product-options" + e$1.path,
                    message: e$1.message,
                    value: e$1.value
                  }
                };
        }
        var e$2 = totalOrderPrice._0;
        return {
                TAG: /* Error */1,
                _0: {
                  path: ".total-order-price" + e$2.path,
                  message: e$2.message,
                  value: e$2.value
                }
              };
      }
      var e$3 = totalDeliveryCost._0;
      return {
              TAG: /* Error */1,
              _0: {
                path: ".total-delivery-cost" + e$3.path,
                message: e$3.message,
                value: e$3.value
              }
            };
    }
    var e$4 = paymentPurpose._0;
    return {
            TAG: /* Error */1,
            _0: {
              path: ".payment-purpose" + e$4.path,
              message: e$4.message,
              value: e$4.value
            }
          };
  }
  var e$5 = orderUserId._0;
  return {
          TAG: /* Error */1,
          _0: {
            path: ".order-user-id" + e$5.path,
            message: e$5.message,
            value: e$5.value
          }
        };
}

function submit_encode(v) {
  return Js_dict.fromArray([[
                "web-order",
                webOrder_encode(v.webOrder)
              ]]);
}

function submit_decode(v) {
  var dict = Js_json.classify(v);
  if (typeof dict === "number") {
    return Spice.error(undefined, "Not an object", v);
  }
  if (dict.TAG !== /* JSONObject */2) {
    return Spice.error(undefined, "Not an object", v);
  }
  var webOrder = webOrder_decode(Belt_Option.getWithDefault(Js_dict.get(dict._0, "web-order"), null));
  if (webOrder.TAG === /* Ok */0) {
    return {
            TAG: /* Ok */0,
            _0: {
              webOrder: webOrder._0
            }
          };
  }
  var e = webOrder._0;
  return {
          TAG: /* Error */1,
          _0: {
            path: ".web-order" + e.path,
            message: e.message,
            value: e.value
          }
        };
}

var names_orderUserId = name + ".order-user-id";

var names_paymentPurpose = name + ".payment-purpose";

var names_totalDeliveryCost = name + ".total-delivery-cost";

var names_totalOrderPrice = name + ".total-order-price";

var names_paymentMethod = name + ".payment-method";

var names_deliveryCost = name + ".product-options.0.delivery-cost";

var names_deliveryDesiredDate = name + ".product-options.0.delivery-desired-date";

var names_deliveryMessage = name + ".product-options.0.delivery-message";

var names_deliveryType = name + ".product-options.0.delivery-type";

var names_grade = name + ".product-options.0.grade";

var names_isTaxFree = name + ".product-options.0.is-tax-free";

var names_ordererName = name + ".product-options.0.orderer-name";

var names_ordererPhone = name + ".product-options.0.orderer-phone";

var names_price = name + ".product-options.0.price";

var names_productId = name + ".product-options.0.product-id";

var names_productName = name + ".product-options.0.product-name";

var names_productOptionName = name + ".product-options.0.product-option-name";

var names_quantity = name + ".product-options.0.quantity";

var names_receiverAddress = name + ".product-options.0.receiver-address";

var names_receiverName = name + ".product-options.0.receiver-name";

var names_receiverPhone = name + ".product-options.0.receiver-phone";

var names_receiverZipCode = name + ".product-options.0.receiver-zipcode";

var names_receiverDetailAddress = name + ".product-options.0.receiver-detail-address";

var names_stockSku = name + ".product-options.0.stock-sku";

var names = {
  orderUserId: names_orderUserId,
  paymentPurpose: names_paymentPurpose,
  totalDeliveryCost: names_totalDeliveryCost,
  totalOrderPrice: names_totalOrderPrice,
  paymentMethod: names_paymentMethod,
  deliveryCost: names_deliveryCost,
  deliveryDesiredDate: names_deliveryDesiredDate,
  deliveryMessage: names_deliveryMessage,
  deliveryType: names_deliveryType,
  grade: names_grade,
  isTaxFree: names_isTaxFree,
  ordererName: names_ordererName,
  ordererPhone: names_ordererPhone,
  price: names_price,
  productId: names_productId,
  productName: names_productName,
  productOptionName: names_productOptionName,
  quantity: names_quantity,
  receiverAddress: names_receiverAddress,
  receiverName: names_receiverName,
  receiverPhone: names_receiverPhone,
  receiverZipCode: names_receiverZipCode,
  receiverDetailAddress: names_receiverDetailAddress,
  stockSku: names_stockSku
};

function defaultValue(isCourierAvailable) {
  return Js_dict.fromArray([[
                "delivery-type",
                isCourierAvailable ? "parcel" : "freight"
              ]]);
}

export {
  name ,
  deliveryType_encode ,
  deliveryType_decode ,
  paymentMethod_encode ,
  paymentMethod_decode ,
  productOptions_encode ,
  productOptions_decode ,
  webOrder_encode ,
  webOrder_decode ,
  submit_encode ,
  submit_decode ,
  names ,
  defaultValue ,
  
}
/* No side effect */