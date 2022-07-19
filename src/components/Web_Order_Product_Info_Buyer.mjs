// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import * as Locale from "../utils/Locale.mjs";
import * as Skeleton from "./Skeleton.mjs";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as Js_null_undefined from "rescript/lib/es6/js_null_undefined.js";
import * as Hooks from "react-relay/hooks";
import * as RescriptRelay_Internal from "rescript-relay/src/RescriptRelay_Internal.mjs";
import * as WebOrderProductInfoBuyerFragment_graphql from "../__generated__/WebOrderProductInfoBuyerFragment_graphql.mjs";

function use(fRef) {
  var data = Hooks.useFragment(WebOrderProductInfoBuyerFragment_graphql.node, fRef);
  return RescriptRelay_Internal.internal_useConvertedValue(WebOrderProductInfoBuyerFragment_graphql.Internal.convertFragment, data);
}

function useOpt(opt_fRef) {
  var fr = opt_fRef !== undefined ? Caml_option.some(Caml_option.valFromOption(opt_fRef)) : undefined;
  var nullableFragmentData = Hooks.useFragment(WebOrderProductInfoBuyerFragment_graphql.node, fr !== undefined ? Js_null_undefined.fromOption(Caml_option.some(Caml_option.valFromOption(fr))) : null);
  var data = (nullableFragmentData == null) ? undefined : Caml_option.some(nullableFragmentData);
  return RescriptRelay_Internal.internal_useConvertedValue((function (rawFragment) {
                if (rawFragment !== undefined) {
                  return WebOrderProductInfoBuyerFragment_graphql.Internal.convertFragment(rawFragment);
                }
                
              }), data);
}

var Fragment = {
  Types: undefined,
  use: use,
  useOpt: useOpt
};

function Web_Order_Product_Info_Buyer$PlaceHolder(Props) {
  return React.createElement("section", {
              className: "flex flex-col gap-5 bg-white rounded-sm"
            }, React.createElement("span", {
                  className: "text-lg xl:text-xl text-enabled-L1 font-bold"
                }, "상품 정보"), React.createElement("div", {
                  className: "flex justify-between gap-3 h-18 xl:h-20"
                }, React.createElement(Skeleton.Box.make, {
                      className: "w-18 h-18 xl:w-20 xl:h-20 rounded-lg"
                    }), React.createElement("div", {
                      className: "flex-auto"
                    }, React.createElement(Skeleton.Box.make, {
                          className: "w-32 mb-1"
                        }), React.createElement(Skeleton.Box.make, {
                          className: "w-32 mb-1"
                        }), React.createElement(Skeleton.Box.make, {
                          className: "w-24"
                        })), React.createElement(Skeleton.Box.make, {
                      className: "w-24 hidden xl:flex min-w-fit"
                    })));
}

var PlaceHolder = {
  make: Web_Order_Product_Info_Buyer$PlaceHolder
};

function Web_Order_Product_Info_Buyer(Props) {
  var query = Props.query;
  var quantity = Props.quantity;
  var fragments = use(query);
  var productNode$p = fragments.productNode;
  var match;
  if (productNode$p !== undefined && typeof productNode$p === "object" && productNode$p.NAME === "NormalProduct") {
    var product = productNode$p.VAL;
    match = [
      product.displayName,
      product.image.original
    ];
  } else {
    match = [
      "",
      ""
    ];
  }
  var productOptionNode$p = fragments.productOptionNode;
  var match$1;
  if (productOptionNode$p !== undefined) {
    if (typeof productOptionNode$p === "object" && productOptionNode$p.NAME === "ProductOption") {
      var match$2 = productOptionNode$p.VAL;
      match$1 = [
        match$2.optionName,
        Belt_Option.getWithDefault(match$2.price, 0)
      ];
    } else {
      match$1 = [
        "",
        0
      ];
    }
  } else {
    match$1 = [
      "옵션이름 없음",
      0
    ];
  }
  var price = match$1[1];
  return React.createElement("section", {
              className: "flex flex-col gap-5 bg-white rounded-sm"
            }, React.createElement("span", {
                  className: "text-lg xl:text-xl text-enabled-L1 font-bold"
                }, "상품 정보"), React.createElement("div", {
                  className: "flex justify-between gap-3 h-18 xl:h-20"
                }, React.createElement("img", {
                      className: "w-18 h-18 xl:w-20 xl:h-20 rounded-lg",
                      alt: "product-image",
                      src: match[1]
                    }), React.createElement("div", {
                      className: "flex-auto"
                    }, React.createElement("div", {
                          className: "font-bold text-enabled-L1 mb-1"
                        }, match[0]), React.createElement("div", {
                          className: "text-sm text-text-L2 mb-2 xl:mb-3"
                        }, match$1[0]), React.createElement("div", {
                          className: "text-sm text-text-L2"
                        }, Locale.Int.show(undefined, price) + "원 | 수량 " + String(quantity) + "개")), React.createElement("div", {
                      className: "hidden xl:flex font-bold text-text-L1 min-w-fit"
                    }, "총 " + Locale.Int.show(undefined, Math.imul(price, quantity)) + "원")));
}

var make = Web_Order_Product_Info_Buyer;

export {
  Fragment ,
  PlaceHolder ,
  make ,
  
}
/* react Not a pure module */
