// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as ReactRelay from "react-relay";
import * as PDP_Parser_Buyer from "../../../../utils/PDP_Parser_Buyer.mjs";
import * as Js_null_undefined from "rescript/lib/es6/js_null_undefined.js";
import * as RescriptRelay_Internal from "rescript-relay/src/RescriptRelay_Internal.mjs";
import * as PDPQuotedDetailsBuyerFragment_graphql from "../../../../__generated__/PDPQuotedDetailsBuyerFragment_graphql.mjs";

function use(fRef) {
  var data = ReactRelay.useFragment(PDPQuotedDetailsBuyerFragment_graphql.node, fRef);
  return RescriptRelay_Internal.internal_useConvertedValue(PDPQuotedDetailsBuyerFragment_graphql.Internal.convertFragment, data);
}

function useOpt(opt_fRef) {
  var fr = opt_fRef !== undefined ? Caml_option.some(Caml_option.valFromOption(opt_fRef)) : undefined;
  var nullableFragmentData = ReactRelay.useFragment(PDPQuotedDetailsBuyerFragment_graphql.node, fr !== undefined ? Js_null_undefined.fromOption(Caml_option.some(Caml_option.valFromOption(fr))) : null);
  var data = (nullableFragmentData == null) ? undefined : Caml_option.some(nullableFragmentData);
  return RescriptRelay_Internal.internal_useConvertedValue((function (rawFragment) {
                if (rawFragment !== undefined) {
                  return PDPQuotedDetailsBuyerFragment_graphql.Internal.convertFragment(rawFragment);
                }
                
              }), data);
}

var Fragment = {
  Types: undefined,
  Operation: undefined,
  use: use,
  useOpt: useOpt
};

function PDP_Quoted_Details_Buyer$PC(Props) {
  var query = Props.query;
  var match = use(query);
  var category = match.category;
  var categoryLabel = Curry._2(PDP_Parser_Buyer.Product.Normal.makeCategoryLabel, category.item, category.kind);
  return React.createElement("div", {
              className: "pb-5"
            }, React.createElement("h2", {
                  className: "font-bold text-lg text-gray-800"
                }, "상품 정보"), React.createElement("div", {
                  className: "mt-5 flex items-center justify-between"
                }, React.createElement("span", {
                      className: "text-gray-500"
                    }, "작물/품종"), React.createElement("span", {
                      className: "text-gray-800"
                    }, categoryLabel)), React.createElement("div", {
                  className: "mt-2 flex items-center justify-between"
                }, React.createElement("span", {
                      className: "text-gray-500"
                    }, "등급/용도명"), React.createElement("span", {
                      className: "text-gray-800"
                    }, match.grade)), Belt_Option.mapWithDefault(match.origin, null, (function (origin$p) {
                    return React.createElement("div", {
                                className: "mt-2 flex items-center justify-between"
                              }, React.createElement("span", {
                                    className: "text-gray-500"
                                  }, "산지"), React.createElement("span", {
                                    className: "text-gray-800"
                                  }, origin$p));
                  })));
}

var PC = {
  make: PDP_Quoted_Details_Buyer$PC
};

function PDP_Quoted_Details_Buyer$MO(Props) {
  var query = Props.query;
  var match = use(query);
  var category = match.category;
  var categoryLabel = Curry._2(PDP_Parser_Buyer.Product.Normal.makeCategoryLabel, category.item, category.kind);
  return React.createElement("div", undefined, React.createElement("h2", {
                  className: "font-bold text-lg text-text-L1"
                }, "상품 정보"), React.createElement("div", {
                  className: "mt-5 flex items-center justify-between"
                }, React.createElement("span", {
                      className: "text-text-L2"
                    }, "작물/품종"), React.createElement("span", {
                      className: "text-text-L1"
                    }, categoryLabel)), React.createElement("div", {
                  className: "mt-2 flex items-center justify-between"
                }, React.createElement("span", {
                      className: "text-text-L2"
                    }, "등급/용도명"), React.createElement("span", {
                      className: "text-text-L1"
                    }, match.grade)), Belt_Option.mapWithDefault(match.origin, null, (function (origin$p) {
                    return React.createElement("div", {
                                className: "mt-2 flex items-center justify-between"
                              }, React.createElement("span", {
                                    className: "text-text-L2"
                                  }, "산지"), React.createElement("span", {
                                    className: "text-text-L1"
                                  }, origin$p));
                  })));
}

var MO = {
  make: PDP_Quoted_Details_Buyer$MO
};

export {
  Fragment ,
  PC ,
  MO ,
}
/* react Not a pure module */
