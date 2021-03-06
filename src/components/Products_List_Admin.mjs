// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import * as Js_dict from "rescript/lib/es6/js_dict.js";
import * as Belt_Int from "rescript/lib/es6/belt_Int.js";
import * as Skeleton from "./Skeleton.mjs";
import * as Constants from "../constants/Constants.mjs";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as Pagination from "./common/Pagination.mjs";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as Router from "next/router";
import * as Product_Admin from "./Product_Admin.mjs";
import * as Js_null_undefined from "rescript/lib/es6/js_null_undefined.js";
import * as Hooks from "react-relay/hooks";
import * as RescriptRelay_Internal from "rescript-relay/src/RescriptRelay_Internal.mjs";
import * as ProductsListAdminFragment_graphql from "../__generated__/ProductsListAdminFragment_graphql.mjs";

function use(fRef) {
  var data = Hooks.useFragment(ProductsListAdminFragment_graphql.node, fRef);
  return RescriptRelay_Internal.internal_useConvertedValue(ProductsListAdminFragment_graphql.Internal.convertFragment, data);
}

function useOpt(opt_fRef) {
  var fr = opt_fRef !== undefined ? Caml_option.some(Caml_option.valFromOption(opt_fRef)) : undefined;
  var nullableFragmentData = Hooks.useFragment(ProductsListAdminFragment_graphql.node, fr !== undefined ? Js_null_undefined.fromOption(Caml_option.some(Caml_option.valFromOption(fr))) : null);
  var data = (nullableFragmentData == null) ? undefined : Caml_option.some(nullableFragmentData);
  return RescriptRelay_Internal.internal_useConvertedValue((function (rawFragment) {
                if (rawFragment !== undefined) {
                  return ProductsListAdminFragment_graphql.Internal.convertFragment(rawFragment);
                }
                
              }), data);
}

var Fragment = {
  Types: undefined,
  use: use,
  useOpt: useOpt
};

function Products_List_Admin$Skeleton(Props) {
  return React.createElement(React.Fragment, undefined, React.createElement("div", {
                  className: "md:flex md:justify-between pb-4"
                }, React.createElement("div", {
                      className: "flex flex-auto items-center justify-between h-8"
                    }, React.createElement("h3", {
                          className: "text-lg font-bold"
                        }, "??????"), React.createElement(Skeleton.Box.make, {
                          className: "w-32"
                        }))), React.createElement("div", {
                  className: "w-full overflow-x-scroll"
                }, React.createElement("div", {
                      className: "min-w-max text-sm"
                    }, React.createElement("div", {
                          className: "bg-gray-50 h-12 divide-y divide-gray-100"
                        }), React.createElement("span", {
                          className: "w-full h-[500px] flex items-center justify-center"
                        }, "?????????.."))));
}

var Skeleton$1 = {
  make: Products_List_Admin$Skeleton
};

function Products_List_Admin(Props) {
  var query = Props.query;
  var router = Router.useRouter();
  var match = use(query);
  var products = match.products;
  var limit = Belt_Option.getWithDefault(Belt_Option.flatMap(Js_dict.get(router.query, "limit"), Belt_Int.fromString), 25);
  return React.createElement(React.Fragment, undefined, React.createElement("div", {
                  className: "w-full overflow-x-scroll"
                }, React.createElement("div", {
                      className: "min-w-max text-sm divide-y divide-gray-100"
                    }, React.createElement("div", {
                          className: "grid grid-cols-9-admin-product bg-gray-100 text-gray-500 h-12"
                        }, React.createElement("div", {
                              className: "h-full px-4 flex items-center whitespace-nowrap"
                            }, "????????????"), React.createElement("div", {
                              className: "h-full px-4 flex items-center whitespace-nowrap"
                            }, "?????? ??????"), React.createElement("div", {
                              className: "h-full px-4 flex items-center whitespace-nowrap"
                            }, "???????????????????????"), React.createElement("div", {
                              className: "h-full px-4 flex items-center whitespace-nowrap"
                            }, "????????????"), React.createElement("div", {
                              className: "h-full px-4 flex items-center whitespace-nowrap"
                            }, "??????????????????????????"), React.createElement("div", {
                              className: "h-full px-4 flex items-center whitespace-nowrap"
                            }, "??????????????????"), React.createElement("div", {
                              className: "h-full px-4 flex items-center whitespace-nowrap"
                            }, "??????????????????"), React.createElement("div", {
                              className: "h-full px-4 flex items-center whitespace-nowrap"
                            }, "??????????????????"), React.createElement("div", {
                              className: "h-full px-4 flex items-center whitespace-nowrap"
                            }, "????????????")), React.createElement("ol", {
                          className: "divide-y divide-gray-100 lg:list-height-admin-buyer lg:overflow-y-scroll"
                        }, Belt_Array.map(products.edges, (function (param) {
                                var product = param.node;
                                return React.createElement(Product_Admin.make, {
                                            query: product.fragmentRefs,
                                            key: product.id
                                          });
                              }))))), React.createElement("div", {
                  className: "flex justify-center pt-5"
                }, null, React.createElement(Pagination.make, {
                      pageDisplySize: Constants.pageDisplySize,
                      itemPerPage: limit,
                      total: products.totalCount
                    })));
}

var make = Products_List_Admin;

export {
  Fragment ,
  Skeleton$1 as Skeleton,
  make ,
  
}
/* react Not a pure module */
