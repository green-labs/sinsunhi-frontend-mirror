// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Cx from "rescript-classnames/src/Cx.mjs";
import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as Dialog from "./common/Dialog.mjs";
import * as Locale from "../utils/Locale.mjs";
import * as Belt_List from "rescript/lib/es6/belt_List.js";
import * as IconClose from "./svgs/IconClose.mjs";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as Belt_MapString from "rescript/lib/es6/belt_MapString.js";
import * as IconArrowSelect from "./svgs/IconArrowSelect.mjs";
import * as Webapi__Dom__Element from "rescript-webapi/src/Webapi/Dom/Webapi__Dom__Element.mjs";
import * as ReactDialog from "@radix-ui/react-dialog";
import * as Freight_Delivery_Cost_Table_Data from "../data/Freight_Delivery_Cost_Table_Data.mjs";

function FreightDeliveryCost_Table_Buyer$Select(Props) {
  var t = Props.t;
  var values = Props.values;
  var onChange = Props.onChange;
  return React.createElement("div", undefined, React.createElement("label", {
                  className: "block text-sm font-medium text-gray-700",
                  id: "select-occupation"
                }), React.createElement("div", {
                  className: "relative"
                }, React.createElement("button", {
                      className: "relative w-48 bg-white border border-border-default-L1 rounded-lg py-2 px-3 focus:outline-none focus:ring-1-gl remove-spin-button focus:border-gray-gl",
                      type: "button"
                    }, React.createElement("span", {
                          className: "flex items-center text-text-L1"
                        }, React.createElement("span", {
                              className: "block truncate"
                            }, t)), React.createElement("span", {
                          className: "absolute top-1 right-3"
                        }, React.createElement(IconArrowSelect.make, {
                              height: "28",
                              width: "28",
                              fill: "#121212"
                            }))), React.createElement("select", {
                      className: "absolute left-0 w-full py-3 opacity-0",
                      value: t,
                      onChange: onChange
                    }, Belt_Array.map(values, (function (value) {
                            return React.createElement("option", {
                                        key: value,
                                        value: value
                                      }, value);
                          })))));
}

var Select = {
  make: FreightDeliveryCost_Table_Buyer$Select
};

function FreightDeliveryCost_Table_Buyer$TitleAndCloseButton(Props) {
  var close = Props.close;
  return React.createElement("div", {
              className: "flex mb-5 md:mb-10 justify-between items-center"
            }, React.createElement("h3", {
                  className: "font-bold text-xl"
                }, "???????????? ???????????? ???"), React.createElement("button", {
                  className: "cursor-pointer border-none",
                  onClick: (function (param) {
                      return Curry._1(close, undefined);
                    })
                }, React.createElement(IconClose.make, {
                      height: "1.5rem",
                      width: "1.5rem",
                      fill: "#262626"
                    })));
}

var TitleAndCloseButton = {
  make: FreightDeliveryCost_Table_Buyer$TitleAndCloseButton
};

function render(l, isLeft) {
  if (l === undefined) {
    return null;
  }
  var l$p$p = Belt_List.head(l);
  if (l$p$p === undefined) {
    return null;
  }
  var price = l$p$p[1];
  var distance = l$p$p[0];
  return React.createElement(React.Fragment, undefined, React.createElement("div", {
                  key: String(distance) + "-" + String(price),
                  className: Cx.cx([
                        "flex w-full xl:w-1/2 justify-between items-center px-4 py-3 text-sm border-t-0 border-div-border-L2",
                        isLeft ? "border border-x-0 xl:border-r-[1px]" : "border border-x-0"
                      ])
                }, React.createElement("span", undefined, String(distance) + "km??????"), React.createElement("span", undefined, Locale.Int.show(undefined, price) + " ???")), render(Belt_List.tail(l), !isLeft));
}

var TableRow = {
  render: render
};

function FreightDeliveryCost_Table_Buyer(Props) {
  var match = React.useState(function () {
        return Freight_Delivery_Cost_Table_Data.defaultOptionName;
      });
  var setWeight = match[1];
  var weight = match[0];
  var selectOptions = Belt_MapString.keysToArray(Freight_Delivery_Cost_Table_Data.freightDeliveryCostData);
  var selectedValues = Belt_MapString.get(Freight_Delivery_Cost_Table_Data.freightDeliveryCostData, weight);
  var close = function (param) {
    var buttonClose = document.getElementById("btn-close");
    Belt_Option.forEach(Belt_Option.flatMap((buttonClose == null) ? undefined : Caml_option.some(buttonClose), Webapi__Dom__Element.asHtmlElement), (function (buttonClose$p) {
            buttonClose$p.click();
            
          }));
    
  };
  var handleOnChangeWeight = function (e) {
    var value = e.currentTarget.value;
    return setWeight(function (param) {
                return value;
              });
  };
  return React.createElement(ReactDialog.Root, {
              children: null
            }, React.createElement(ReactDialog.Overlay, {
                  className: "dialog-overlay"
                }), React.createElement(ReactDialog.Trigger, {
                  children: React.createElement("span", {
                        className: "w-28 h-9 flex justify-center items-center bg-background border border-div-border-L1 rounded-lg text-enabled-L2 text-[15px]"
                      }, "????????? ??? ??????")
                }), React.createElement(ReactDialog.Content, {
                  children: null,
                  className: "dialog-content-fix p-5 overflow-y-auto text-sm text-text-L1 rounded-2xl min-w-max"
                }, React.createElement(FreightDeliveryCost_Table_Buyer$TitleAndCloseButton, {
                      close: close
                    }), React.createElement("div", {
                      className: "flex items-center gap-4"
                    }, React.createElement("span", {
                          className: "text-sm font-bold text-text-L1 min-w-fit"
                        }, "?????? ??????"), React.createElement(FreightDeliveryCost_Table_Buyer$Select, {
                          t: weight,
                          values: selectOptions,
                          onChange: handleOnChangeWeight
                        })), React.createElement("div", {
                      className: "flex mt-4 w-full h-9 bg-div-shape-L2"
                    }, React.createElement("div", {
                          className: "flex flex-1 px-4 items-center justify-between border-div-border-L2 border border-y-0 border-x-0 xl:border-r-[1px]"
                        }, React.createElement("span", undefined, "??????"), React.createElement("span", undefined, "??????")), React.createElement("div", {
                          className: "hidden xl:flex flex-1 px-4 items-center justify-between"
                        }, React.createElement("span", undefined, "??????"), React.createElement("span", undefined, "??????"))), React.createElement("div", {
                      className: "flex flex-wrap"
                    }, render(selectedValues, true)), React.createElement(ReactDialog.Close, {
                      children: "",
                      className: "hidden",
                      id: "btn-close"
                    }), React.createElement("span", {
                      className: "md:hidden"
                    }, React.createElement(Dialog.ButtonBox.make, {
                          onCancel: (function (param) {
                              return close(undefined);
                            }),
                          textOnCancel: "??????"
                        }))));
}

var make = FreightDeliveryCost_Table_Buyer;

export {
  Select ,
  TitleAndCloseButton ,
  TableRow ,
  make ,
  
}
/* react Not a pure module */
