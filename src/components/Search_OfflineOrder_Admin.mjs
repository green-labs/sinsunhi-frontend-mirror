// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "rescript/lib/es6/curry.js";
import * as Input from "./common/Input.mjs";
import * as React from "react";
import * as Helper from "../utils/Helper.mjs";
import * as Js_dict from "rescript/lib/es6/js_dict.js";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as DatePicker from "./DatePicker.mjs";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as ReactEvents from "../utils/ReactEvents.mjs";
import * as ReactSelect from "./common/ReactSelect.mjs";
import * as Router from "next/router";
import Parse from "date-fns/parse";
import * as ReForm__Helpers from "@rescriptbr/reform/src/ReForm__Helpers.mjs";
import Format from "date-fns/format";
import SetDate from "date-fns/setDate";
import EndOfMonth from "date-fns/endOfMonth";
import * as Search_Crop_Cultivar from "./Search_Crop_Cultivar.mjs";
import * as Select_Crop_Search_Std from "./Select_Crop_Search_Std.mjs";
import * as PeriodSelector_OfflineOrders from "./common/PeriodSelector_OfflineOrders.mjs";
import * as Query_OfflineOrder_Form_Admin from "./Query_OfflineOrder_Form_Admin.mjs";

function getDefaults(dict) {
  return {
          seller: Js_dict.get(dict, "producer-name"),
          buyer: Js_dict.get(dict, "buyer-name"),
          orderFrom: Js_dict.get(dict, "created-at-from"),
          orderTo: Js_dict.get(dict, "created-at-to"),
          shipmentFrom: Js_dict.get(dict, "release-due-date-from"),
          shipmentTo: Js_dict.get(dict, "release-due-date-to"),
          std: Js_dict.get(dict, "std"),
          categoryId: Js_dict.get(dict, "category-id"),
          label: Js_dict.get(dict, "label")
        };
}

function Search_OfflineOrder_Admin(Props) {
  var defaults = Props.defaults;
  var router = Router.useRouter();
  var match = React.useState(function () {
        return Belt_Option.getWithDefault(Helper.$$Option.map2(defaults.categoryId, defaults.label, (function (v, l) {
                          return /* Selected */{
                                  value: v,
                                  label: l
                                };
                        })), /* NotSelected */0);
      });
  var setSelectedCrop = match[1];
  var selectedCrop = match[0];
  var match$1 = React.useState(function () {
        return {
                from: Belt_Option.mapWithDefault(defaults.orderFrom, SetDate(new Date(), 1), (function (d) {
                        return Parse(d, "yyyy-MM-dd", new Date());
                      })),
                to_: Belt_Option.mapWithDefault(defaults.orderTo, new Date(), (function (d) {
                        return Parse(d, "yyyy-MM-dd", new Date());
                      }))
              };
      });
  var setOrderQuery = match$1[1];
  var orderQuery = match$1[0];
  var match$2 = React.useState(function () {
        return {
                from: Belt_Option.mapWithDefault(defaults.shipmentFrom, SetDate(new Date(), 1), (function (d) {
                        return Parse(d, "yyyy-MM-dd", new Date());
                      })),
                to_: Belt_Option.mapWithDefault(defaults.shipmentTo, new Date(), (function (d) {
                        return Parse(d, "yyyy-MM-dd", new Date());
                      }))
              };
      });
  var setShipmentQuery = match$2[1];
  var shipmentQuery = match$2[0];
  var onSubmit = function (param) {
    var state = param.state;
    var sellerName = Query_OfflineOrder_Form_Admin.FormFields.get(state.values, /* SellerName */0);
    var buyerName = Query_OfflineOrder_Form_Admin.FormFields.get(state.values, /* BuyerName */1);
    var std = Query_OfflineOrder_Form_Admin.FormFields.get(state.values, /* Std */2);
    router.query["producer-name"] = sellerName;
    router.query["buyer-name"] = buyerName;
    router.query["std"] = std;
    router.query["created-at-from"] = Format(orderQuery.from, "yyyy-MM-dd");
    router.query["created-at-to"] = Format(orderQuery.to_, "yyyy-MM-dd");
    router.query["release-due-date-from"] = Format(shipmentQuery.from, "yyyy-MM-dd");
    router.query["release-due-date-to"] = Format(shipmentQuery.to_, "yyyy-MM-dd");
    var match = Belt_Option.mapWithDefault(ReactSelect.toOption(selectedCrop), [
          "",
          ""
        ], (function (v) {
            return [
                    v.value,
                    v.label
                  ];
          }));
    router.query["category-id"] = match[0];
    router.query["label"] = match[1];
    router.push(router.pathname + "?" + new URLSearchParams(router.query).toString());
    
  };
  var form = Curry._7(Query_OfflineOrder_Form_Admin.Form.use, {
        sellerName: Belt_Option.getWithDefault(defaults.seller, ""),
        buyerName: Belt_Option.getWithDefault(defaults.buyer, ""),
        std: Belt_Option.getWithDefault(defaults.categoryId, "Crop")
      }, /* Schema */{
        _0: Belt_Array.concatMany([
              Curry._4(Query_OfflineOrder_Form_Admin.Form.ReSchema.Validation.regExp, "?????? 2????????? ??????????????????.", "^(?:.{2,}|)$", undefined, /* SellerName */0),
              Curry._4(Query_OfflineOrder_Form_Admin.Form.ReSchema.Validation.regExp, "?????? 2????????? ??????????????????.", "^(?:.{2,}|)$", undefined, /* BuyerName */1)
            ])
      }, onSubmit, undefined, undefined, /* OnChange */0, undefined);
  var handleOnSubmit = function (param) {
    return ReactEvents.interceptingHandler((function (param) {
                  return Curry._1(form.submit, undefined);
                }), param);
  };
  var handleOnChangeCropOrCultivar = function (e) {
    ReForm__Helpers.handleChange(Curry._1(form.handleChange, /* Std */2), e);
    return setSelectedCrop(function (param) {
                return /* NotSelected */0;
              });
  };
  var handleOnChangeOrderPeriod = function (f, t) {
    return setOrderQuery(function (param) {
                return {
                        from: f,
                        to_: t
                      };
              });
  };
  var handleOnChangeOrderDate = function (t, e) {
    var newDate = e.detail.valueAsDate;
    if (t) {
      if (newDate === undefined) {
        return ;
      }
      var newDate$p = Caml_option.valFromOption(newDate);
      return setOrderQuery(function (prev) {
                  return {
                          from: prev.from,
                          to_: newDate$p
                        };
                });
    }
    if (newDate === undefined) {
      return ;
    }
    var newDate$p$1 = Caml_option.valFromOption(newDate);
    return setOrderQuery(function (prev) {
                return {
                        from: newDate$p$1,
                        to_: prev.to_
                      };
              });
  };
  var handleOnChangeShipmentPeriod = function (f, t) {
    return setShipmentQuery(function (param) {
                return {
                        from: f,
                        to_: t
                      };
              });
  };
  var handleOnChangeShipmentDate = function (t, e) {
    var newDate = e.detail.valueAsDate;
    if (t) {
      if (newDate === undefined) {
        return ;
      }
      var newDate$p = Caml_option.valFromOption(newDate);
      return setShipmentQuery(function (prev) {
                  return {
                          from: prev.from,
                          to_: newDate$p
                        };
                });
    }
    if (newDate === undefined) {
      return ;
    }
    var newDate$p$1 = Caml_option.valFromOption(newDate);
    return setShipmentQuery(function (prev) {
                return {
                        from: newDate$p$1,
                        to_: prev.to_
                      };
              });
  };
  var handleOnReset = function (param) {
    return ReactEvents.interceptingHandler((function (param) {
                  Curry._4(form.setFieldValue, /* SellerName */0, "", false, undefined);
                  Curry._4(form.setFieldValue, /* BuyerName */1, "", false, undefined);
                  Curry._4(form.setFieldValue, /* Std */2, "Crop", false, undefined);
                  var m_from = SetDate(new Date(), 1);
                  var m_to = EndOfMonth(new Date());
                  setOrderQuery(function (param) {
                        return {
                                from: m_from,
                                to_: m_to
                              };
                      });
                  setShipmentQuery(function (param) {
                        return {
                                from: m_from,
                                to_: m_to
                              };
                      });
                  return setSelectedCrop(function (param) {
                              return /* NotSelected */0;
                            });
                }), param);
  };
  var handleChangeCrop = function (selection) {
    return setSelectedCrop(function (param) {
                return selection;
              });
  };
  var partial_arg = Curry._1(form.handleChange, /* SellerName */0);
  var partial_arg$1 = Curry._1(form.handleChange, /* BuyerName */1);
  return React.createElement("div", {
              className: "flex flex-col bg-white mt-5 p-7"
            }, React.createElement("h2", {
                  className: "font-bold text-lg"
                }, "?????? ??????"), React.createElement("form", {
                  onSubmit: handleOnSubmit
                }, React.createElement("div", {
                      className: "mt-6 bg-div-shape-L2 p-7 rounded-lg text-sm"
                    }, React.createElement("div", {
                          className: "flex"
                        }, React.createElement("div", {
                              className: "w-32 font-bold whitespace-nowrap"
                            }, "??????"), React.createElement("div", {
                              className: "flex-1"
                            }, React.createElement("div", {
                                  className: "flex"
                                }, React.createElement("div", {
                                      className: "flex flex-col sm:flex-initial sm:w-64 sm:flex-row sm:items-center mr-16"
                                    }, React.createElement("label", {
                                          className: "whitespace-nowrap mr-2",
                                          htmlFor: "seller-name"
                                        }, "????????????"), React.createElement("span", {
                                          className: "w-48"
                                        }, React.createElement(Input.make, {
                                              type_: "text",
                                              name: "seller-name",
                                              placeholder: "????????????",
                                              value: Query_OfflineOrder_Form_Admin.FormFields.get(form.values, /* SellerName */0),
                                              onChange: (function (param) {
                                                  return ReForm__Helpers.handleChange(partial_arg, param);
                                                }),
                                              error: Curry._1(form.getFieldError, /* Field */{
                                                    _0: /* SellerName */0
                                                  }),
                                              tabIndex: 1
                                            }))), React.createElement("div", {
                                      className: "flex flex-col sm:flex-initial sm:w-64 sm:flex-row sm:items-center mr-16"
                                    }, React.createElement("label", {
                                          className: "whitespace-nowrap mr-2",
                                          htmlFor: "buyer-name"
                                        }, "????????????"), React.createElement("span", {
                                          className: "w-48"
                                        }, React.createElement(Input.make, {
                                              type_: "text",
                                              name: "buyer-name",
                                              placeholder: "????????????",
                                              value: Query_OfflineOrder_Form_Admin.FormFields.get(form.values, /* BuyerName */1),
                                              onChange: (function (param) {
                                                  return ReForm__Helpers.handleChange(partial_arg$1, param);
                                                }),
                                              error: Curry._1(form.getFieldError, /* Field */{
                                                    _0: /* BuyerName */1
                                                  }),
                                              tabIndex: 2
                                            })))), React.createElement("div", {
                                  className: "mt-2 flex flex-col sm:flex-row items-start"
                                }, React.createElement("div", {
                                      className: "w-64 flex items-center"
                                    }, React.createElement("label", {
                                          className: "whitespace-nowrap mr-2",
                                          htmlFor: "crop-kind"
                                        }, "????????????"), React.createElement(Select_Crop_Search_Std.make, {
                                          std: Belt_Option.getWithDefault(Select_Crop_Search_Std.decodeStd(Query_OfflineOrder_Form_Admin.FormFields.get(form.values, /* Std */2)), "Crop"),
                                          onChange: handleOnChangeCropOrCultivar
                                        })), React.createElement("div", {
                                      className: "relative"
                                    }, React.createElement("div", {
                                          className: "absolute w-96"
                                        }, React.createElement(Search_Crop_Cultivar.make, {
                                              type_: Belt_Option.getWithDefault(Select_Crop_Search_Std.decodeStd(Query_OfflineOrder_Form_Admin.FormFields.get(form.values, /* Std */2)), "Crop"),
                                              value: selectedCrop,
                                              onChange: handleChangeCrop
                                            })))))), React.createElement("div", {
                          className: "flex mt-4"
                        }, React.createElement("div", {
                              className: "flex items-center"
                            }, React.createElement("div", {
                                  className: "w-32 font-bold whitespace-nowrap "
                                }, "?????????")), React.createElement("div", {
                              className: "flex mr-2"
                            }, React.createElement(PeriodSelector_OfflineOrders.make, {
                                  from: orderQuery.from,
                                  to_: orderQuery.to_,
                                  onSelect: handleOnChangeOrderPeriod
                                })), React.createElement(DatePicker.make, {
                              id: "order-from",
                              onChange: (function (param) {
                                  return handleOnChangeOrderDate(/* From */0, param);
                                }),
                              date: orderQuery.from,
                              maxDate: Format(orderQuery.to_, "yyyy-MM-dd"),
                              firstDayOfWeek: 0
                            }), React.createElement("span", {
                              className: "flex items-center mr-1"
                            }, "~"), React.createElement(DatePicker.make, {
                              id: "order-to",
                              onChange: (function (param) {
                                  return handleOnChangeOrderDate(/* To */1, param);
                                }),
                              date: orderQuery.to_,
                              minDate: Format(orderQuery.from, "yyyy-MM-dd"),
                              firstDayOfWeek: 0
                            })), React.createElement("div", {
                          className: "flex mt-2 "
                        }, React.createElement("div", {
                              className: "flex items-center"
                            }, React.createElement("div", {
                                  className: "w-32 font-bold whitespace-nowrap"
                                }, "???????????????")), React.createElement("div", {
                              className: "flex mr-2"
                            }, React.createElement(PeriodSelector_OfflineOrders.make, {
                                  from: shipmentQuery.from,
                                  to_: shipmentQuery.to_,
                                  onSelect: handleOnChangeShipmentPeriod
                                })), React.createElement(DatePicker.make, {
                              id: "from",
                              onChange: (function (param) {
                                  return handleOnChangeShipmentDate(/* From */0, param);
                                }),
                              date: shipmentQuery.from,
                              maxDate: Format(shipmentQuery.to_, "yyyy-MM-dd"),
                              firstDayOfWeek: 0
                            }), React.createElement("span", {
                              className: "flex items-center mr-1"
                            }, "~"), React.createElement(DatePicker.make, {
                              id: "to",
                              onChange: (function (param) {
                                  return handleOnChangeShipmentDate(/* To */1, param);
                                }),
                              date: shipmentQuery.to_,
                              minDate: Format(shipmentQuery.from, "yyyy-MM-dd"),
                              firstDayOfWeek: 0
                            }))), React.createElement("div", {
                      className: "flex justify-center mt-5"
                    }, React.createElement("span", {
                          className: "w-20 h-11 flex mr-2"
                        }, React.createElement("input", {
                              className: "btn-level6",
                              tabIndex: 7,
                              type: "button",
                              value: "?????????",
                              onClick: handleOnReset
                            })), React.createElement("span", {
                          className: "w-20 h-11 flex"
                        }, React.createElement("input", {
                              className: "btn-level1",
                              tabIndex: 8,
                              type: "submit",
                              value: "??????"
                            })))));
}

var FormFields;

var Form;

var Select_Crop_Std;

var make = Search_OfflineOrder_Admin;

export {
  FormFields ,
  Form ,
  Select_Crop_Std ,
  getDefaults ,
  make ,
  
}
/* Input Not a pure module */
