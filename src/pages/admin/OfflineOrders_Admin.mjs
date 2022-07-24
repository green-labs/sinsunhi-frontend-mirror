// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Env from "../../constants/Env.mjs";
import * as Swr from "swr";
import * as Curry from "rescript/lib/es6/curry.js";
import * as Spice from "@greenlabs/ppx-spice/src/rescript/Spice.mjs";
import * as React from "react";
import * as Dialog from "../../components/common/Dialog.mjs";
import * as Helper from "../../utils/Helper.mjs";
import * as Locale from "../../utils/Locale.mjs";
import * as Js_dict from "rescript/lib/es6/js_dict.js";
import * as Js_json from "rescript/lib/es6/js_json.js";
import * as IconError from "../../components/svgs/IconError.mjs";
import Head from "next/head";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Belt_Result from "rescript/lib/es6/belt_Result.js";
import * as CustomHooks from "../../utils/CustomHooks.mjs";
import * as FetchHelper from "../../utils/FetchHelper.mjs";
import * as Router from "next/router";
import * as ReactHookForm from "../../bindings/ReactHookForm/ReactHookForm.mjs";
import * as ReactHookForm$1 from "react-hook-form";
import * as Select_CountPerPage from "../../components/Select_CountPerPage.mjs";
import * as OfflineOrder_List_Admin from "../../components/OfflineOrder_List_Admin.mjs";
import * as Search_OfflineOrder_Admin from "../../components/Search_OfflineOrder_Admin.mjs";
import * as ReactToastNotifications from "react-toast-notifications";
import * as Excel_Download_Request_Button from "../../components/Excel_Download_Request_Button.mjs";

function inputs_encode(v) {
  return Js_dict.fromArray([
              [
                "checkbox",
                Spice.boolToJson(v.checkbox)
              ],
              [
                "id",
                Spice.stringToJson(v.id)
              ],
              [
                "order-quantity",
                Spice.stringToJson(v.orderQuantity)
              ],
              [
                "order-quantity-complete",
                Spice.stringToJson(v.confirmedOrderQuantity)
              ],
              [
                "producer-product-cost",
                Spice.stringToJson(v.cost)
              ],
              [
                "buyer-sell-price",
                Spice.stringToJson(v.price)
              ],
              [
                "release-date",
                Spice.stringToJson(v.releaseDate)
              ],
              [
                "release-due-date",
                Spice.stringToJson(v.releaseDueDate)
              ]
            ]);
}

function inputs_decode(v) {
  var dict = Js_json.classify(v);
  if (typeof dict === "number") {
    return Spice.error(undefined, "Not an object", v);
  }
  if (dict.TAG !== /* JSONObject */2) {
    return Spice.error(undefined, "Not an object", v);
  }
  var dict$1 = dict._0;
  var checkbox = Spice.boolFromJson(Belt_Option.getWithDefault(Js_dict.get(dict$1, "checkbox"), null));
  if (checkbox.TAG === /* Ok */0) {
    var id = Spice.stringFromJson(Belt_Option.getWithDefault(Js_dict.get(dict$1, "id"), null));
    if (id.TAG === /* Ok */0) {
      var orderQuantity = Spice.stringFromJson(Belt_Option.getWithDefault(Js_dict.get(dict$1, "order-quantity"), null));
      if (orderQuantity.TAG === /* Ok */0) {
        var confirmedOrderQuantity = Spice.stringFromJson(Belt_Option.getWithDefault(Js_dict.get(dict$1, "order-quantity-complete"), null));
        if (confirmedOrderQuantity.TAG === /* Ok */0) {
          var cost = Spice.stringFromJson(Belt_Option.getWithDefault(Js_dict.get(dict$1, "producer-product-cost"), null));
          if (cost.TAG === /* Ok */0) {
            var price = Spice.stringFromJson(Belt_Option.getWithDefault(Js_dict.get(dict$1, "buyer-sell-price"), null));
            if (price.TAG === /* Ok */0) {
              var releaseDate = Spice.stringFromJson(Belt_Option.getWithDefault(Js_dict.get(dict$1, "release-date"), null));
              if (releaseDate.TAG === /* Ok */0) {
                var releaseDueDate = Spice.stringFromJson(Belt_Option.getWithDefault(Js_dict.get(dict$1, "release-due-date"), null));
                if (releaseDueDate.TAG === /* Ok */0) {
                  return {
                          TAG: /* Ok */0,
                          _0: {
                            checkbox: checkbox._0,
                            id: id._0,
                            orderQuantity: orderQuantity._0,
                            confirmedOrderQuantity: confirmedOrderQuantity._0,
                            cost: cost._0,
                            price: price._0,
                            releaseDate: releaseDate._0,
                            releaseDueDate: releaseDueDate._0
                          }
                        };
                }
                var e = releaseDueDate._0;
                return {
                        TAG: /* Error */1,
                        _0: {
                          path: ".release-due-date" + e.path,
                          message: e.message,
                          value: e.value
                        }
                      };
              }
              var e$1 = releaseDate._0;
              return {
                      TAG: /* Error */1,
                      _0: {
                        path: ".release-date" + e$1.path,
                        message: e$1.message,
                        value: e$1.value
                      }
                    };
            }
            var e$2 = price._0;
            return {
                    TAG: /* Error */1,
                    _0: {
                      path: ".buyer-sell-price" + e$2.path,
                      message: e$2.message,
                      value: e$2.value
                    }
                  };
          }
          var e$3 = cost._0;
          return {
                  TAG: /* Error */1,
                  _0: {
                    path: ".producer-product-cost" + e$3.path,
                    message: e$3.message,
                    value: e$3.value
                  }
                };
        }
        var e$4 = confirmedOrderQuantity._0;
        return {
                TAG: /* Error */1,
                _0: {
                  path: ".order-quantity-complete" + e$4.path,
                  message: e$4.message,
                  value: e$4.value
                }
              };
      }
      var e$5 = orderQuantity._0;
      return {
              TAG: /* Error */1,
              _0: {
                path: ".order-quantity" + e$5.path,
                message: e$5.message,
                value: e$5.value
              }
            };
    }
    var e$6 = id._0;
    return {
            TAG: /* Error */1,
            _0: {
              path: ".id" + e$6.path,
              message: e$6.message,
              value: e$6.value
            }
          };
  }
  var e$7 = checkbox._0;
  return {
          TAG: /* Error */1,
          _0: {
            path: ".checkbox" + e$7.path,
            message: e$7.message,
            value: e$7.value
          }
        };
}

function form_encode(v) {
  return Spice.arrayToJson(inputs_encode, v);
}

function form_decode(v) {
  return Spice.arrayFromJson(inputs_decode, v);
}

function order_encode(v) {
  return Js_dict.fromArray([
              [
                "id",
                Spice.stringToJson(v.id)
              ],
              [
                "order-quantity",
                Spice.stringToJson(v.orderQuantity)
              ],
              [
                "order-quantity-complete",
                Spice.stringToJson(v.confirmedOrderQuantity)
              ],
              [
                "producer-product-cost",
                Spice.stringToJson(v.cost)
              ],
              [
                "buyer-sell-price",
                Spice.stringToJson(v.price)
              ],
              [
                "release-date",
                Spice.stringToJson(v.releaseDate)
              ],
              [
                "release-due-date",
                Spice.stringToJson(v.releaseDueDate)
              ]
            ]);
}

function order_decode(v) {
  var dict = Js_json.classify(v);
  if (typeof dict === "number") {
    return Spice.error(undefined, "Not an object", v);
  }
  if (dict.TAG !== /* JSONObject */2) {
    return Spice.error(undefined, "Not an object", v);
  }
  var dict$1 = dict._0;
  var id = Spice.stringFromJson(Belt_Option.getWithDefault(Js_dict.get(dict$1, "id"), null));
  if (id.TAG === /* Ok */0) {
    var orderQuantity = Spice.stringFromJson(Belt_Option.getWithDefault(Js_dict.get(dict$1, "order-quantity"), null));
    if (orderQuantity.TAG === /* Ok */0) {
      var confirmedOrderQuantity = Spice.stringFromJson(Belt_Option.getWithDefault(Js_dict.get(dict$1, "order-quantity-complete"), null));
      if (confirmedOrderQuantity.TAG === /* Ok */0) {
        var cost = Spice.stringFromJson(Belt_Option.getWithDefault(Js_dict.get(dict$1, "producer-product-cost"), null));
        if (cost.TAG === /* Ok */0) {
          var price = Spice.stringFromJson(Belt_Option.getWithDefault(Js_dict.get(dict$1, "buyer-sell-price"), null));
          if (price.TAG === /* Ok */0) {
            var releaseDate = Spice.stringFromJson(Belt_Option.getWithDefault(Js_dict.get(dict$1, "release-date"), null));
            if (releaseDate.TAG === /* Ok */0) {
              var releaseDueDate = Spice.stringFromJson(Belt_Option.getWithDefault(Js_dict.get(dict$1, "release-due-date"), null));
              if (releaseDueDate.TAG === /* Ok */0) {
                return {
                        TAG: /* Ok */0,
                        _0: {
                          id: id._0,
                          orderQuantity: orderQuantity._0,
                          confirmedOrderQuantity: confirmedOrderQuantity._0,
                          cost: cost._0,
                          price: price._0,
                          releaseDate: releaseDate._0,
                          releaseDueDate: releaseDueDate._0
                        }
                      };
              }
              var e = releaseDueDate._0;
              return {
                      TAG: /* Error */1,
                      _0: {
                        path: ".release-due-date" + e.path,
                        message: e.message,
                        value: e.value
                      }
                    };
            }
            var e$1 = releaseDate._0;
            return {
                    TAG: /* Error */1,
                    _0: {
                      path: ".release-date" + e$1.path,
                      message: e$1.message,
                      value: e$1.value
                    }
                  };
          }
          var e$2 = price._0;
          return {
                  TAG: /* Error */1,
                  _0: {
                    path: ".buyer-sell-price" + e$2.path,
                    message: e$2.message,
                    value: e$2.value
                  }
                };
        }
        var e$3 = cost._0;
        return {
                TAG: /* Error */1,
                _0: {
                  path: ".producer-product-cost" + e$3.path,
                  message: e$3.message,
                  value: e$3.value
                }
              };
      }
      var e$4 = confirmedOrderQuantity._0;
      return {
              TAG: /* Error */1,
              _0: {
                path: ".order-quantity-complete" + e$4.path,
                message: e$4.message,
                value: e$4.value
              }
            };
    }
    var e$5 = orderQuantity._0;
    return {
            TAG: /* Error */1,
            _0: {
              path: ".order-quantity" + e$5.path,
              message: e$5.message,
              value: e$5.value
            }
          };
  }
  var e$6 = id._0;
  return {
          TAG: /* Error */1,
          _0: {
            path: ".id" + e$6.path,
            message: e$6.message,
            value: e$6.value
          }
        };
}

function body_encode(v) {
  return Spice.arrayToJson(order_encode, v);
}

function body_decode(v) {
  return Spice.arrayFromJson(order_decode, v);
}

function OfflineOrders_Admin$OfflineOrders(Props) {
  var router = Router.useRouter();
  var match = Swr.useSWRConfig();
  var mutate = match.mutate;
  var match$1 = ReactToastNotifications.useToasts();
  var addToast = match$1.addToast;
  var queryParms = new URLSearchParams(router.query).toString();
  var status = CustomHooks.OfflineOrders.use(queryParms);
  var methods = ReactHookForm$1.useForm({
        mode: "onChange"
      }, undefined);
  var match$2 = React.useState(function () {
        return /* Hide */1;
      });
  var setShowSuccessToSave = match$2[1];
  var match$3 = React.useState(function () {
        return /* Hide */1;
      });
  var setShowError = match$3[1];
  var match$4 = React.useState(function () {
        return "저장 실패";
      });
  var setErrorMessage = match$4[1];
  var onSubmit = function (data, param) {
    var toJsonArray = function (data) {
      var dict = Belt_Option.getWithDefault(Js_json.decodeObject(data), {});
      return Belt_Option.getWithDefault(Belt_Option.map(Belt_Option.map(Helper.$$Option.sequence(Belt_Array.map(Object.keys(dict), (function (k) {
                                    return Belt_Option.flatMap(Js_dict.get(dict, k), (function (v) {
                                                  var input = Js_json.decodeObject(v);
                                                  Belt_Option.forEach(input, (function (v$p) {
                                                          v$p["id"] = k;
                                                        }));
                                                  return input;
                                                }));
                                  }))), (function (arr) {
                            return Belt_Array.map(arr, (function (prim) {
                                          return prim;
                                        }));
                          })), (function (arr) {
                        return arr;
                      })), null);
    };
    var r = Belt_Result.flatMap(Belt_Result.map(Belt_Result.map(Helper.Result.sequence(Belt_Array.keep(Belt_Array.map(Belt_Option.getWithDefault(Js_json.decodeArray(toJsonArray(data)), []), inputs_decode), Belt_Result.isOk)), (function (arr) {
                    return Belt_Array.keep(arr, (function (order) {
                                  return order.checkbox;
                                }));
                  })), form_encode), body_decode);
    var orders;
    if (r.TAG === /* Ok */0) {
      var orders$p = r._0;
      orders = orders$p.length !== 0 ? orders$p : undefined;
    } else {
      console.log(r._0);
      orders = undefined;
    }
    Belt_Option.map(Belt_Option.flatMap(Belt_Option.map(orders, body_encode), (function (prim) {
                return JSON.stringify(prim);
              })), (function (body) {
            return FetchHelper.requestWithRetry(FetchHelper.putWithToken, "" + Env.restApiUrl + "/offline-order", body, 3, (function (res) {
                          console.log("success");
                          mutate("" + Env.restApiUrl + "/offline-order?" + new URLSearchParams(router.query).toString() + "", undefined, undefined);
                          methods.reset(undefined);
                          setShowSuccessToSave(function (param) {
                                return /* Show */0;
                              });
                        }), (function (error) {
                          setErrorMessage(function (param) {
                                return Belt_Option.getWithDefault(error.message, "요청에 실패했습니다.");
                              });
                          setShowError(function (param) {
                                return /* Show */0;
                              });
                          addToast(React.createElement("div", {
                                    className: "flex items-center"
                                  }, React.createElement(IconError.make, {
                                        width: "24",
                                        height: "24",
                                        className: "mr-2"
                                      }), "저장 실패"), {
                                appearance: "error"
                              });
                        }));
          }));
  };
  var tmp;
  if (typeof status === "number" || status.TAG !== /* Loaded */0) {
    tmp = null;
  } else {
    var data$p = CustomHooks.OfflineOrders.offlineOrders_decode(status._0);
    if (data$p.TAG === /* Ok */0) {
      tmp = React.createElement(React.Fragment, undefined, React.createElement("div", {
                className: "md:flex md:justify-between pb-4"
              }, React.createElement("div", {
                    className: "flex flex-auto justify-between"
                  }, React.createElement("h2", {
                        className: "font-bold text-lg"
                      }, "내역", React.createElement("span", {
                            className: "ml-2 text-base text-primary font-normal"
                          }, "" + Locale.Float.show(undefined, data$p._0.count, 0) + "개")), React.createElement("div", {
                        className: "flex"
                      }, React.createElement(Select_CountPerPage.make, {
                            className: "mr-2"
                          }), React.createElement("button", {
                            className: "hidden",
                            disabled: true,
                            type: "submit"
                          }), React.createElement(Excel_Download_Request_Button.make, {
                            userType: /* Admin */2,
                            requestUrl: "/offline-order/excel"
                          }), React.createElement("button", {
                            className: "px-3 py-1 ml-3 rounded-lg bg-primary text-white",
                            type: "submit"
                          }, "저장")))), React.createElement(OfflineOrder_List_Admin.make, {
                status: status
              }));
    } else {
      console.log(data$p._0);
      tmp = null;
    }
  }
  return React.createElement("div", {
              className: "py-8 px-4 bg-div-shape-L1 min-h-screen"
            }, React.createElement("header", {
                  className: "md:flex md:items-baseline pb-0"
                }, React.createElement("h1", {
                      className: "font-bold text-xl"
                    }, "오프라인 주문관리")), React.createElement(Search_OfflineOrder_Admin.make, {
                  defaults: Search_OfflineOrder_Admin.getDefaults(router.query),
                  key: queryParms
                }), React.createElement(ReactHookForm.Provider.make, {
                  children: React.createElement("form", {
                        onSubmit: methods.handleSubmit(onSubmit)
                      }, React.createElement("div", {
                            className: "px-7 py-6 mt-2 shadow-gl overflow-auto overflow-x-scroll bg-white rounded"
                          }, tmp)),
                  methods: methods
                }), React.createElement(Dialog.make, {
                  isShow: match$3[0],
                  children: React.createElement("p", {
                        className: "text-gray-500 text-center whitespace-pre-wrap"
                      }, match$4[0]),
                  onCancel: (function (param) {
                      setShowError(function (param) {
                            return /* Hide */1;
                          });
                    }),
                  textOnCancel: "확인"
                }), React.createElement(Dialog.make, {
                  isShow: match$2[0],
                  children: React.createElement("p", {
                        className: "text-gray-500 text-center whitespace-pre-wrap"
                      }, "선택한 오프라인주문 정보가 저장되었습니다."),
                  onCancel: (function (param) {
                      setShowSuccessToSave(function (param) {
                            return /* Hide */1;
                          });
                    }),
                  textOnCancel: "확인"
                }));
}

var OfflineOrders = {
  make: OfflineOrders_Admin$OfflineOrders
};

function OfflineOrders_Admin(Props) {
  var user = Curry._1(CustomHooks.User.Admin.use, undefined);
  return React.createElement(React.Fragment, undefined, React.createElement(Head, {
                  children: React.createElement("title", undefined, "관리자 오프라인 주문관리")
                }), typeof user === "number" ? (
                user !== 0 ? React.createElement("div", undefined, "로그인이 필요 합니다.") : React.createElement("div", undefined, "인증 확인 중 입니다.")
              ) : React.createElement(OfflineOrders_Admin$OfflineOrders, {}));
}

var List;

var make = OfflineOrders_Admin;

export {
  List ,
  inputs_encode ,
  inputs_decode ,
  form_encode ,
  form_decode ,
  order_encode ,
  order_decode ,
  body_encode ,
  body_decode ,
  OfflineOrders ,
  make ,
}
/* Env Not a pure module */
