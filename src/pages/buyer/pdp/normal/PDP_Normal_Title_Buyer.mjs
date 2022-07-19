// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as Locale from "../../../../utils/Locale.mjs";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as CustomHooks from "../../../../utils/CustomHooks.mjs";

function PDP_Normal_Title_Buyer$PC(Props) {
  var displayName = Props.displayName;
  var price = Props.price;
  var isSoldout = Props.isSoldout;
  var user = Curry._1(CustomHooks.User.Buyer.use2, undefined);
  var priceLabel = Belt_Option.mapWithDefault(price, "", (function (price$p) {
          return Locale.Float.show(undefined, price$p, 0);
        }));
  var tmp;
  if (typeof user === "number") {
    tmp = user !== 0 ? React.createElement("h1", {
            className: "mt-5 text-[28px] text-green-500 font-bold"
          }, "공급가 회원공개") : null;
  } else {
    var textColor = isSoldout ? "text-gray-600" : "text-gray-800";
    tmp = React.createElement("h1", {
          className: "mt-5 text-[32px] font-bold" + textColor
        }, priceLabel, React.createElement("span", {
              className: "text-lg"
            }, "원"));
  }
  return React.createElement("section", undefined, React.createElement("h1", {
                  className: "text-[32px] text-gray-800"
                }, displayName), tmp, React.createElement("div", {
                  className: "w-full h-16 my-4 px-6 flex items-center rounded-xl bg-[#FFF1EE]"
                }, React.createElement("span", {
                      className: "text-orange-500"
                    }, "시세에 따라 가격이 변동될 수 있습니다")));
}

var PC = {
  make: PDP_Normal_Title_Buyer$PC
};

function PDP_Normal_Title_Buyer$MO(Props) {
  var displayName = Props.displayName;
  var price = Props.price;
  var isSoldout = Props.isSoldout;
  var user = Curry._1(CustomHooks.User.Buyer.use2, undefined);
  var priceLabel = Belt_Option.mapWithDefault(price, "", (function (price$p) {
          return Locale.Float.show(undefined, price$p, 0);
        }));
  var tmp;
  if (typeof user === "number") {
    tmp = user !== 0 ? React.createElement("h1", {
            className: "text-xl text-green-500 font-bold"
          }, "공급가 회원공개") : null;
  } else {
    var textColor = isSoldout ? "text-gray-600" : "text-gray-800";
    tmp = React.createElement("h1", {
          className: "text-xl font-bold " + textColor
        }, priceLabel, React.createElement("span", {
              className: "text-lg"
            }, "원"));
  }
  return React.createElement("section", undefined, React.createElement("h1", {
                  className: "text-lg text-gray-800"
                }, displayName), tmp);
}

var MO = {
  make: PDP_Normal_Title_Buyer$MO
};

export {
  PC ,
  MO ,
  
}
/* react Not a pure module */
