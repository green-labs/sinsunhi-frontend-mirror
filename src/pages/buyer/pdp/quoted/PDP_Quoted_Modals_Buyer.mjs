// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as Js_dict from "rescript/lib/es6/js_dict.js";
import * as Router from "next/router";
import * as ShopDialog_Buyer from "../../ShopDialog_Buyer.mjs";

function PDP_Quoted_Modals_Buyer$Unauthorized$PC(Props) {
  var show = Props.show;
  var closeFn = Props.closeFn;
  var router = Router.useRouter();
  var isShow = show ? /* Show */0 : /* Hide */1;
  return React.createElement(ShopDialog_Buyer.make, {
              isShow: isShow,
              confirmText: "로그인",
              cancelText: "취소",
              onConfirm: (function (param) {
                  var redirect = Js_dict.get(router.query, "redirect");
                  var redirectUrl = redirect !== undefined ? new URLSearchParams(Js_dict.fromArray([[
                                  "redirect",
                                  redirect
                                ]])).toString() : new URLSearchParams(Js_dict.fromArray([[
                                  "redirect",
                                  router.asPath
                                ]])).toString();
                  router.push("/buyer/signin?" + redirectUrl);
                  
                }),
              onCancel: (function (param) {
                  return Curry._1(closeFn, undefined);
                }),
              children: React.createElement("div", {
                    className: "h-18 mt-8 px-8 py-6 flex flex-col items-center justify-center text-lg text-text-L1"
                  }, React.createElement("span", undefined, "로그인 후에"), React.createElement("span", undefined, "견적을 받으실 수 있습니다."))
            });
}

var PC = {
  make: PDP_Quoted_Modals_Buyer$Unauthorized$PC
};

function PDP_Quoted_Modals_Buyer$Unauthorized$MO(Props) {
  var show = Props.show;
  var closeFn = Props.closeFn;
  var router = Router.useRouter();
  var isShow = show ? /* Show */0 : /* Hide */1;
  return React.createElement(ShopDialog_Buyer.Mo.make, {
              isShow: isShow,
              confirmText: "로그인",
              cancelText: "취소",
              onConfirm: (function (param) {
                  var redirect = Js_dict.get(router.query, "redirect");
                  var redirectUrl = redirect !== undefined ? new URLSearchParams(Js_dict.fromArray([[
                                  "redirect",
                                  redirect
                                ]])).toString() : new URLSearchParams(Js_dict.fromArray([[
                                  "redirect",
                                  router.asPath
                                ]])).toString();
                  router.push("/buyer/signin?" + redirectUrl);
                  
                }),
              onCancel: (function (param) {
                  return Curry._1(closeFn, undefined);
                }),
              children: React.createElement("div", {
                    className: "h-18 mt-8 px-8 py-6 flex flex-col items-center justify-center text-lg text-text-L1"
                  }, React.createElement("span", undefined, "로그인 후에"), React.createElement("span", undefined, "견적을 받으실 수 있습니다."))
            });
}

var MO = {
  make: PDP_Quoted_Modals_Buyer$Unauthorized$MO
};

var Unauthorized = {
  PC: PC,
  MO: MO
};

function PDP_Quoted_Modals_Buyer$PC(Props) {
  var show = Props.show;
  var setShow = Props.setShow;
  var closeFn = function (param) {
    return setShow(function (param) {
                return /* Hide */0;
              });
  };
  return React.createElement(React.Fragment, undefined, React.createElement(PDP_Quoted_Modals_Buyer$Unauthorized$PC, {
                  show: show,
                  closeFn: closeFn
                }));
}

var PC$1 = {
  make: PDP_Quoted_Modals_Buyer$PC
};

function PDP_Quoted_Modals_Buyer$MO(Props) {
  var show = Props.show;
  var setShow = Props.setShow;
  var closeFn = function (param) {
    return setShow(function (param) {
                return /* Hide */0;
              });
  };
  return React.createElement(React.Fragment, undefined, React.createElement(PDP_Quoted_Modals_Buyer$Unauthorized$MO, {
                  show: show,
                  closeFn: closeFn
                }));
}

var MO$1 = {
  make: PDP_Quoted_Modals_Buyer$MO
};

export {
  Unauthorized ,
  PC$1 as PC,
  MO$1 as MO,
  
}
/* react Not a pure module */
