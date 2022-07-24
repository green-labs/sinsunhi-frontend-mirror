// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import * as Js_dict from "rescript/lib/es6/js_dict.js";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Belt_Result from "rescript/lib/es6/belt_Result.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as Router from "next/router";
import * as Garter_Array from "@greenlabs/garter/src/Garter_Array.mjs";
import * as IconArrowSelect from "./svgs/IconArrowSelect.mjs";

function encodeSorted(sorted) {
  if (sorted) {
    return "created";
  } else {
    return "-created";
  }
}

function decodeSorted(sorted) {
  if (sorted === "-created") {
    return {
            TAG: /* Ok */0,
            _0: /* Newest */0
          };
  } else if (sorted === "created") {
    return {
            TAG: /* Ok */0,
            _0: /* Oldest */1
          };
  } else {
    return {
            TAG: /* Error */1,
            _0: "정의되지 않은 값 입니다."
          };
  }
}

function parseSorted(q) {
  return Belt_Option.mapWithDefault(Js_dict.get(q, "sort"), {
              TAG: /* Ok */0,
              _0: /* Newest */0
            }, decodeSorted);
}

function formatSorted(sorted) {
  if (sorted) {
    return "생성순";
  } else {
    return "최신순";
  }
}

function Select_Sorted(Props) {
  var className = Props.className;
  var router = Router.useRouter();
  var onChange = function (e) {
    var sorted = e.target.value;
    router.query["sort"] = sorted;
    router.query["offset"] = "0";
    router.push("" + router.pathname + "?" + new URLSearchParams(router.query).toString() + "");
  };
  var displaySorted = function (q) {
    return Belt_Result.mapWithDefault(parseSorted(q), "최신순", formatSorted);
  };
  var tmp = {};
  if (className !== undefined) {
    tmp.className = Caml_option.valFromOption(className);
  }
  return React.createElement("span", tmp, React.createElement("label", {
                  className: "block relative"
                }, React.createElement("span", {
                      className: "w-24 flex items-center border border-border-default-L1 rounded-md h-9 px-3 text-enabled-L1"
                    }, displaySorted(router.query)), React.createElement("span", {
                      className: "absolute top-1.5 right-2"
                    }, React.createElement(IconArrowSelect.make, {
                          height: "24",
                          width: "24",
                          fill: "#121212"
                        })), React.createElement("select", {
                      className: "block w-full h-full absolute top-0 opacity-0",
                      value: Belt_Result.mapWithDefault(parseSorted(router.query), "-created", encodeSorted),
                      onChange: onChange
                    }, Garter_Array.map([
                          /* Newest */0,
                          /* Oldest */1
                        ], (function (s) {
                            return React.createElement("option", {
                                        key: s ? "created" : "-created",
                                        value: s ? "created" : "-created"
                                      }, s ? "생성순" : "최신순");
                          })))));
}

var make = Select_Sorted;

export {
  encodeSorted ,
  decodeSorted ,
  parseSorted ,
  formatSorted ,
  make ,
}
/* react Not a pure module */
