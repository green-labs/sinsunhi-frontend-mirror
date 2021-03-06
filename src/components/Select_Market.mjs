// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import * as Js_dict from "rescript/lib/es6/js_dict.js";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as CustomHooks from "../utils/CustomHooks.mjs";
import * as Garter_Array from "@greenlabs/garter/src/Garter_Array.mjs";
import * as IconArrowSelect from "./svgs/IconArrowSelect.mjs";

var markets_encode = CustomHooks.Shipments.marketType_encode;

var markets_decode = CustomHooks.Shipments.marketType_decode;

function toOption(r) {
  if (r.TAG === /* Ok */0) {
    return Caml_option.some(r._0);
  }
  
}

function encodeMarkets(market) {
  return JSON.stringify(markets_encode(market)).replace(/"/g, "");
}

function decodeMarket(str) {
  return toOption(markets_decode(str));
}

function parseMarket(q) {
  return Belt_Option.flatMap(Js_dict.get(q, "market"), decodeMarket);
}

function display(market) {
  switch (market) {
    case /* ONLINE */0 :
        return "온라인 택배";
    case /* WHOLESALE */1 :
        return "도매출하";
    case /* OFFLINE */2 :
        return "오프라인";
    
  }
}

function Select_Market(Props) {
  var market = Props.market;
  var onChange = Props.onChange;
  return React.createElement("span", undefined, React.createElement("label", {
                  className: "block relative"
                }, React.createElement("span", {
                      className: "sm:w-44 flex items-center border border-border-default-L1 bg-white rounded-md px-3 py-2 text-enabled-L1 leading-4.5"
                    }, Belt_Option.mapWithDefault(market, "전체 거래유형", display)), React.createElement("span", {
                      className: "absolute top-1.5 right-2"
                    }, React.createElement(IconArrowSelect.make, {
                          height: "24",
                          width: "24",
                          fill: "#121212"
                        })), React.createElement("select", {
                      className: "block w-full h-full absolute top-0 opacity-0",
                      value: Belt_Option.mapWithDefault(market, "", encodeMarkets),
                      onChange: onChange
                    }, React.createElement("option", {
                          value: ""
                        }, "전체 거래유형"), Garter_Array.map([
                          /* ONLINE */0,
                          /* OFFLINE */2,
                          /* WHOLESALE */1
                        ], (function (s) {
                            return React.createElement("option", {
                                        key: encodeMarkets(s),
                                        value: encodeMarkets(s)
                                      }, display(s));
                          })))));
}

var make = Select_Market;

export {
  markets_encode ,
  markets_decode ,
  toOption ,
  encodeMarkets ,
  decodeMarket ,
  parseMarket ,
  display ,
  make ,
  
}
/* react Not a pure module */
