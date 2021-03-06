// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Cx from "rescript-classnames/src/Cx.mjs";
import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as Caml_obj from "rescript/lib/es6/caml_obj.js";
import * as PeriodSelector from "./PeriodSelector.mjs";
import AddDays from "date-fns/addDays";
import GetDate from "date-fns/getDate";
import IsToday from "date-fns/isToday";
import SetDate from "date-fns/setDate";
import SubDays from "date-fns/subDays";
import AddMonths from "date-fns/addMonths";
import IsSameDay from "date-fns/isSameDay";
import SubMonths from "date-fns/subMonths";
import EndOfMonth from "date-fns/endOfMonth";
import IsSameMonth from "date-fns/isSameMonth";
import IsThisMonth from "date-fns/isThisMonth";
import IsLastDayOfMonth from "date-fns/isLastDayOfMonth";

function getPeriod(from, to_) {
  if (IsSameDay(AddDays(from, 7), to_)) {
    return /* Before7Days */0;
  } else if (IsSameDay(from, to_) && IsToday(AddDays(from, 1))) {
    return /* Yesterday */1;
  } else if (GetDate(from) === 1 && IsLastDayOfMonth(to_) && IsSameMonth(from, to_) && IsThisMonth(to_)) {
    return /* ThisMonth */2;
  } else if (GetDate(from) === 1 && IsLastDayOfMonth(to_) && IsThisMonth(AddMonths(from, 1))) {
    return /* LastMonth */3;
  } else {
    return ;
  }
}

function setPeriod(setFn, period, to_) {
  var today = new Date();
  switch (period) {
    case /* Before7Days */0 :
        return Curry._2(setFn, SubDays(to_, 7), to_);
    case /* Yesterday */1 :
        return Curry._2(setFn, SubDays(today, 1), SubDays(today, 1));
    case /* ThisMonth */2 :
        return Curry._2(setFn, SetDate(today, 1), EndOfMonth(today));
    case /* LastMonth */3 :
        return Curry._2(setFn, SetDate(SubMonths(today, 1), 1), EndOfMonth(SubMonths(today, 1)));
    
  }
}

function PeriodSelector_OfflineOrders(Props) {
  var from = Props.from;
  var to_ = Props.to_;
  var onSelect = Props.onSelect;
  var period = getPeriod(from, to_);
  return React.createElement(React.Fragment, undefined, React.createElement("button", {
                  className: Cx.cx([
                        PeriodSelector.defaultStyle,
                        PeriodSelector.styleOnOff(Caml_obj.caml_equal(period, /* Before7Days */0))
                      ]),
                  type: "button",
                  onClick: (function (param) {
                      return setPeriod(onSelect, /* Before7Days */0, to_);
                    })
                }, "?????? 7???"), React.createElement("button", {
                  className: Cx.cx([
                        PeriodSelector.defaultStyle,
                        PeriodSelector.styleOnOff(Caml_obj.caml_equal(period, /* Yesterday */1))
                      ]),
                  type: "button",
                  onClick: (function (param) {
                      return setPeriod(onSelect, /* Yesterday */1, to_);
                    })
                }, "??????"), React.createElement("button", {
                  className: Cx.cx([
                        PeriodSelector.defaultStyle,
                        PeriodSelector.styleOnOff(Caml_obj.caml_equal(period, /* ThisMonth */2))
                      ]),
                  type: "button",
                  onClick: (function (param) {
                      return setPeriod(onSelect, /* ThisMonth */2, to_);
                    })
                }, "?????????"), React.createElement("button", {
                  className: Cx.cx([
                        PeriodSelector.defaultStyle,
                        PeriodSelector.styleOnOff(Caml_obj.caml_equal(period, /* LastMonth */3))
                      ]),
                  type: "button",
                  onClick: (function (param) {
                      return setPeriod(onSelect, /* LastMonth */3, to_);
                    })
                }, "?????????"));
}

var defaultStyle = PeriodSelector.defaultStyle;

var styleOnOff = PeriodSelector.styleOnOff;

var make = PeriodSelector_OfflineOrders;

export {
  defaultStyle ,
  styleOnOff ,
  getPeriod ,
  setPeriod ,
  make ,
  
}
/* react Not a pure module */
