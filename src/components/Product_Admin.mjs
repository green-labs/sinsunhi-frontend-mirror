// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Cx from "rescript-classnames/src/Cx.mjs";
import * as React from "react";
import * as Locale from "../utils/Locale.mjs";
import Link from "next/link";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as Garter_Array from "@greenlabs/garter/src/Garter_Array.mjs";
import * as Js_null_undefined from "rescript/lib/es6/js_null_undefined.js";
import * as Hooks from "react-relay/hooks";
import * as RescriptRelay_Internal from "rescript-relay/src/RescriptRelay_Internal.mjs";
import * as ProductAdminFragment_graphql from "../__generated__/ProductAdminFragment_graphql.mjs";
import * as Product_Operation_Status_Badge from "./Product_Operation_Status_Badge.mjs";
import * as ProductAdminTypedProductFragment_graphql from "../__generated__/ProductAdminTypedProductFragment_graphql.mjs";

function use(fRef) {
  var data = Hooks.useFragment(ProductAdminFragment_graphql.node, fRef);
  return RescriptRelay_Internal.internal_useConvertedValue(ProductAdminFragment_graphql.Internal.convertFragment, data);
}

function useOpt(opt_fRef) {
  var fr = opt_fRef !== undefined ? Caml_option.some(Caml_option.valFromOption(opt_fRef)) : undefined;
  var nullableFragmentData = Hooks.useFragment(ProductAdminFragment_graphql.node, fr !== undefined ? Js_null_undefined.fromOption(Caml_option.some(Caml_option.valFromOption(fr))) : null);
  var data = (nullableFragmentData == null) ? undefined : Caml_option.some(nullableFragmentData);
  return RescriptRelay_Internal.internal_useConvertedValue((function (rawFragment) {
                if (rawFragment !== undefined) {
                  return ProductAdminFragment_graphql.Internal.convertFragment(rawFragment);
                }
                
              }), data);
}

var Fragment = {
  Types: undefined,
  use: use,
  useOpt: useOpt
};

function use$1(fRef) {
  var data = Hooks.useFragment(ProductAdminTypedProductFragment_graphql.node, fRef);
  return RescriptRelay_Internal.internal_useConvertedValue(ProductAdminTypedProductFragment_graphql.Internal.convertFragment, data);
}

function useOpt$1(opt_fRef) {
  var fr = opt_fRef !== undefined ? Caml_option.some(Caml_option.valFromOption(opt_fRef)) : undefined;
  var nullableFragmentData = Hooks.useFragment(ProductAdminTypedProductFragment_graphql.node, fr !== undefined ? Js_null_undefined.fromOption(Caml_option.some(Caml_option.valFromOption(fr))) : null);
  var data = (nullableFragmentData == null) ? undefined : Caml_option.some(nullableFragmentData);
  return RescriptRelay_Internal.internal_useConvertedValue((function (rawFragment) {
                if (rawFragment !== undefined) {
                  return ProductAdminTypedProductFragment_graphql.Internal.convertFragment(rawFragment);
                }
                
              }), data);
}

var TypedProductFragment = {
  Types: undefined,
  use: use$1,
  useOpt: useOpt$1
};

function Product_Admin$Product_Option_Link_Button$Link_Button(Props) {
  var productId = Props.productId;
  var isOptionEmpty = Props.isOptionEmpty;
  var defaultStyle = "max-w-min  py-0.5 px-2 rounded mr-2 whitespace-nowrap";
  if (isOptionEmpty) {
    return React.createElement(Link, {
                href: "/admin/products/" + productId + "/create-options",
                children: React.createElement("button", {
                      className: Cx.cx([
                            defaultStyle,
                            "text-gray-gl bg-gray-gl"
                          ])
                    }, "추가하기")
              });
  } else {
    return React.createElement(Link, {
                href: "/admin/products/" + productId + "/options",
                children: React.createElement("button", {
                      className: Cx.cx([
                            defaultStyle,
                            "bg-green-gl-light text-green-gl"
                          ])
                    }, "조회하기")
              });
  }
}

var Link_Button = {
  make: Product_Admin$Product_Option_Link_Button$Link_Button
};

function Product_Admin$Product_Option_Link_Button(Props) {
  var typedProduct = Props.typedProduct;
  var variant = typedProduct.NAME;
  if (variant === "MatchingProduct" || variant === "QuotedProduct") {
    return React.createElement("button", {
                className: Cx.cx(["max-w-min  py-0.5 px-2 rounded mr-2 whitespace-nowrap text-disabled-L2 bg-gray-gl"])
              }, "추가하기");
  }
  if (variant === "UnselectedUnionMember") {
    return null;
  }
  var normalProduct = typedProduct.VAL;
  return React.createElement(Product_Admin$Product_Option_Link_Button$Link_Button, {
              productId: normalProduct.id,
              isOptionEmpty: Garter_Array.isEmpty(normalProduct.productOptions.edges)
            });
}

var Product_Option_Link_Button = {
  Link_Button: Link_Button,
  make: Product_Admin$Product_Option_Link_Button
};

function Product_Admin(Props) {
  var query = Props.query;
  var product = use(query);
  var typedProduct = use$1(product.fragmentRefs);
  var displayCategoriesToTextes = function (categories) {
    return Belt_Array.map(categories, (function (param) {
                  return [
                          param.id,
                          Garter_Array.joinWith(param.fullyQualifiedName, " > ", (function (f) {
                                  return f.name;
                                }))
                        ];
                }));
  };
  var productCategoryText = function (category) {
    return Garter_Array.joinWith(category.fullyQualifiedName, " > ", (function (f) {
                  return f.name;
                }));
  };
  var variant = typedProduct.NAME;
  var variant$1 = typedProduct.NAME;
  var variant$2 = typedProduct.NAME;
  return React.createElement(React.Fragment, undefined, React.createElement("li", {
                  className: "grid grid-cols-9-admin-product text-gray-700"
                }, React.createElement("div", {
                      className: "h-full flex flex-col px-4 py-2"
                    }, React.createElement(Product_Operation_Status_Badge.make, {
                          query: product.fragmentRefs
                        })), React.createElement("div", {
                      className: "h-full flex flex-col px-4 py-2"
                    }, variant === "QuotableProduct" ? "일반+견적 상품" : (
                        variant === "QuotedProduct" ? "견적 상품" : (
                            variant === "UnselectedUnionMember" ? "" : (
                                variant === "MatchingProduct" ? "매칭 상품" : "일반 상품"
                              )
                          )
                      )), React.createElement("div", {
                      className: "h-full flex flex-col px-4 py-2"
                    }, React.createElement(Link, {
                          href: "/admin/products/" + product.id,
                          children: React.createElement("a", {
                                className: "underline"
                              }, product.displayName + "(" + String(product.productId) + ")")
                        })), React.createElement("div", {
                      className: "h-full flex flex-col px-4 py-2"
                    }, React.createElement(Product_Admin$Product_Option_Link_Button, {
                          typedProduct: typedProduct
                        })), React.createElement("div", {
                      className: "h-full flex flex-col px-4 py-2"
                    }, React.createElement("span", {
                          className: "block"
                        }, Belt_Option.mapWithDefault(product.producer, "-", (function (param) {
                                return param.name + "(" + Belt_Option.getWithDefault(param.producerCode, "") + ")";
                              })))), React.createElement("div", {
                      className: "h-full flex flex-col px-4 py-2"
                    }, React.createElement("span", {
                          className: "block"
                        }, productCategoryText(product.category))), React.createElement("div", {
                      className: "h-full flex flex-col px-4 py-2"
                    }, React.createElement("span", {
                          className: "block"
                        }, Belt_Array.map(displayCategoriesToTextes(product.displayCategories), (function (param) {
                                return React.createElement("p", {
                                            key: param[0]
                                          }, param[1]);
                              })))), React.createElement("div", {
                      className: "h-full flex flex-col px-4 pl-8 py-2"
                    }, React.createElement("span", {
                          className: "block"
                        }, Belt_Option.getWithDefault(variant$1 === "QuotableProduct" ? Belt_Option.map(typedProduct.VAL.price, (function (p$p) {
                                      return Locale.Float.show(undefined, p$p, 0) + "원";
                                    })) : (
                                variant$1 === "MatchingProduct" || variant$1 === "UnselectedUnionMember" || variant$1 === "QuotedProduct" ? undefined : Belt_Option.map(typedProduct.VAL.price, (function (p$p) {
                                          return Locale.Float.show(undefined, p$p, 0) + "원";
                                        }))
                              ), "-"))), React.createElement("div", {
                      className: "h-full flex flex-col px-4 pl-9 py-2"
                    }, React.createElement("span", {
                          className: "block"
                        }, variant$2 === "QuotableProduct" ? (
                            typedProduct.VAL.isCourierAvailable ? "가능" : "불가능"
                          ) : (
                            variant$2 === "MatchingProduct" || variant$2 === "UnselectedUnionMember" || variant$2 === "QuotedProduct" ? "-" : (
                                typedProduct.VAL.isCourierAvailable ? "가능" : "불가능"
                              )
                          )))));
}

var make = Product_Admin;

export {
  Fragment ,
  TypedProductFragment ,
  Product_Option_Link_Button ,
  make ,
  
}
/* react Not a pure module */
