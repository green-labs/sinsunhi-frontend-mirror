// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import Format from "date-fns/format";
import AddHours from "date-fns/addHours";

function show(showPlusSign, num) {
  var sign = Belt_Option.mapWithDefault(showPlusSign, "", (function (show) {
          if (show && num > 0) {
            return "+";
          } else {
            return "";
          }
        }));
  var value = num.toLocaleString("ko-KR");
  return sign + value;
}

var Int = {
  show: show
};

function show$1(showPlusSign, num, digits) {
  var sign = Belt_Option.mapWithDefault(showPlusSign, "", (function (show) {
          if (show && num > 0.0) {
            return "+";
          } else {
            return "";
          }
        }));
  var value = num.toLocaleString("ko-KR", {
        minimumFractionDigits: 0,
        maximumFractionDigits: digits
      });
  return sign + value;
}

function round0(num) {
  return Math.round(num);
}

function round1(num) {
  return Math.round(num * 10.0) / 10.0;
}

var Float = {
  show: show$1,
  round0: round0,
  round1: round1
};

function formatFromUTC(dt, formatString) {
  return Format(AddHours(dt, 9), formatString);
}

var DateTime = {
  formatFromUTC: formatFromUTC
};

export {
  Int ,
  Float ,
  DateTime ,
}
/* date-fns/format Not a pure module */
