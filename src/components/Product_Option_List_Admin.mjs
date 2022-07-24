// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as Js_dict from "rescript/lib/es6/js_dict.js";
import * as Belt_Int from "rescript/lib/es6/belt_Int.js";
import * as Skeleton from "./Skeleton.mjs";
import * as Constants from "../constants/Constants.mjs";
import * as Pagination from "./common/Pagination.mjs";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as Router from "next/router";
import * as ReactRelay from "react-relay";
import * as Garter_Array from "@greenlabs/garter/src/Garter_Array.mjs";
import * as EmptyProducts from "./EmptyProducts.mjs";
import * as RescriptRelay from "rescript-relay/src/RescriptRelay.mjs";
import * as Js_null_undefined from "rescript/lib/es6/js_null_undefined.js";
import * as Product_Option_Admin from "./Product_Option_Admin.mjs";
import * as RescriptRelay_Internal from "rescript-relay/src/RescriptRelay_Internal.mjs";
import * as ProductOptionListAdminFragment_graphql from "../__generated__/ProductOptionListAdminFragment_graphql.mjs";
import * as ProductOptionListAdminFragmentRefetchQuery_graphql from "../__generated__/ProductOptionListAdminFragmentRefetchQuery_graphql.mjs";

function internal_makeRefetchableFnOpts(fetchPolicy, onComplete, param) {
  var tmp = {};
  var tmp$1 = RescriptRelay.mapFetchPolicy(fetchPolicy);
  if (tmp$1 !== undefined) {
    tmp.fetchPolicy = Caml_option.valFromOption(tmp$1);
  }
  var tmp$2 = RescriptRelay_Internal.internal_nullableToOptionalExnHandler(onComplete);
  if (tmp$2 !== undefined) {
    tmp.onComplete = Caml_option.valFromOption(tmp$2);
  }
  return tmp;
}

function useRefetchable(fRef) {
  var match = ReactRelay.useRefetchableFragment(ProductOptionListAdminFragment_graphql.node, fRef);
  var refetchFn = match[1];
  var data = RescriptRelay_Internal.internal_useConvertedValue(ProductOptionListAdminFragment_graphql.Internal.convertFragment, match[0]);
  return [
          data,
          React.useMemo((function () {
                  return function (param, param$1, param$2, param$3) {
                    return Curry._2(refetchFn, RescriptRelay_Internal.internal_removeUndefinedAndConvertNullsRaw(ProductOptionListAdminFragmentRefetchQuery_graphql.Internal.convertVariables(param)), internal_makeRefetchableFnOpts(param$1, param$2, undefined));
                  };
                }), [refetchFn])
        ];
}

function use(fRef) {
  var data = ReactRelay.useFragment(ProductOptionListAdminFragment_graphql.node, fRef);
  return RescriptRelay_Internal.internal_useConvertedValue(ProductOptionListAdminFragment_graphql.Internal.convertFragment, data);
}

function useOpt(opt_fRef) {
  var fr = opt_fRef !== undefined ? Caml_option.some(Caml_option.valFromOption(opt_fRef)) : undefined;
  var nullableFragmentData = ReactRelay.useFragment(ProductOptionListAdminFragment_graphql.node, fr !== undefined ? Js_null_undefined.fromOption(Caml_option.some(Caml_option.valFromOption(fr))) : null);
  var data = (nullableFragmentData == null) ? undefined : Caml_option.some(nullableFragmentData);
  return RescriptRelay_Internal.internal_useConvertedValue((function (rawFragment) {
                if (rawFragment !== undefined) {
                  return ProductOptionListAdminFragment_graphql.Internal.convertFragment(rawFragment);
                }
                
              }), data);
}

var makeRefetchVariables = ProductOptionListAdminFragmentRefetchQuery_graphql.Types.makeRefetchVariables;

var Fragment = {
  Types: undefined,
  internal_makeRefetchableFnOpts: internal_makeRefetchableFnOpts,
  useRefetchable: useRefetchable,
  Operation: undefined,
  use: use,
  useOpt: useOpt,
  makeRefetchVariables: makeRefetchVariables
};

function Product_Option_List_Admin$Skeleton(Props) {
  return React.createElement(React.Fragment, undefined, React.createElement("div", {
                  className: "md:flex md:justify-between pb-4"
                }, React.createElement("div", {
                      className: "flex flex-auto items-center justify-between h-8"
                    }, React.createElement("h3", {
                          className: "text-lg font-bold"
                        }, "내역"), React.createElement(Skeleton.Box.make, {
                          className: "w-32"
                        }))), React.createElement("div", {
                  className: "w-full overflow-x-scroll"
                }, React.createElement("div", {
                      className: "min-w-max text-sm"
                    }, React.createElement("div", {
                          className: "bg-gray-50 h-12 divide-y divide-gray-100"
                        }), React.createElement("span", {
                          className: "w-full h-[500px] flex items-center justify-center"
                        }, "로딩중.."))));
}

var Skeleton$1 = {
  make: Product_Option_List_Admin$Skeleton
};

function Product_Option_List_Admin(Props) {
  var query = Props.query;
  var match = use(query);
  var productOptions = match.productOptions;
  var router = Router.useRouter();
  var limit = Belt_Option.getWithDefault(Belt_Option.flatMap(Js_dict.get(router.query, "limit"), Belt_Int.fromString), 25);
  return React.createElement(React.Fragment, undefined, React.createElement("div", {
                  className: "w-full overflow-x-scroll"
                }, React.createElement("div", {
                      className: "min-w-max text-sm divide-y divide-gray-100"
                    }, React.createElement("div", {
                          className: "grid grid-cols-15-admin-product bg-gray-100 text-gray-500 h-12"
                        }, React.createElement("div", {
                              className: "h-full px-4 flex items-center whitespace-nowrap"
                            }, "판매상태"), React.createElement("div", {
                              className: "h-full px-4 flex items-center whitespace-nowrap"
                            }, "생산자명"), React.createElement("div", {
                              className: "h-full px-4 flex items-center whitespace-nowrap"
                            }, "상품번호·단품번호"), React.createElement("div", {
                              className: "h-full px-4 flex items-center whitespace-nowrap"
                            }, "상품명·단품명"), React.createElement("div", {
                              className: "h-full px-4 flex items-center whitespace-nowrap"
                            }, "현재 판매가"), React.createElement("div", {
                              className: "h-full px-4 flex items-center whitespace-nowrap"
                            }, "작물명·품종명"), React.createElement("div", {
                              className: "h-full px-4 flex items-center whitespace-nowrap"
                            }, "중량·입수(박스당)"), React.createElement("div", {
                              className: "h-full px-4 flex items-center whitespace-nowrap"
                            }, "개당 무게·크기"), React.createElement("div", {
                              className: "h-full px-4 flex items-center whitespace-nowrap"
                            }, "등급·포장규격"), React.createElement("div", {
                              className: "h-full px-4 flex items-center whitespace-nowrap"
                            }, "담당소싱MD"), React.createElement("div", {
                              className: "h-full px-4 flex items-center whitespace-nowrap"
                            }, "출고기준시간"), React.createElement("div", {
                              className: "h-full px-4 flex items-center whitespace-nowrap"
                            }, "메모")), React.createElement("ol", {
                          className: "divide-y divide-gray-100 lg:list-height-admin-buyer lg:overflow-y-scroll"
                        }, Garter_Array.isEmpty(productOptions.edges) ? React.createElement(EmptyProducts.make, {}) : Garter_Array.map(productOptions.edges, (function (edge) {
                                  return React.createElement(Product_Option_Admin.make, {
                                              query: edge.node.fragmentRefs,
                                              key: edge.node.id
                                            });
                                }))))), React.createElement("div", {
                  className: "flex justify-center pt-5"
                }, null, React.createElement(Pagination.make, {
                      pageDisplySize: Constants.pageDisplySize,
                      itemPerPage: limit,
                      total: productOptions.totalCount
                    })));
}

var make = Product_Option_List_Admin;

export {
  Fragment ,
  Skeleton$1 as Skeleton,
  make ,
}
/* react Not a pure module */
