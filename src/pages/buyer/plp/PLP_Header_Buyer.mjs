// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as Js_dict from "rescript/lib/es6/js_dict.js";
import * as IconHome from "../../../components/svgs/IconHome.mjs";
import * as Js_promise from "rescript/lib/es6/js_promise.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as Router from "next/router";
import * as ReactRelay from "react-relay";
import * as RescriptRelay from "rescript-relay/src/RescriptRelay.mjs";
import * as RelayRuntime from "relay-runtime";
import * as RescriptRelay_Internal from "rescript-relay/src/RescriptRelay_Internal.mjs";
import * as RescriptReactErrorBoundary from "@rescript/react/src/RescriptReactErrorBoundary.mjs";
import * as PLPHeaderBuyerQuery_graphql from "../../../__generated__/PLPHeaderBuyerQuery_graphql.mjs";

function use(variables, fetchPolicy, fetchKey, networkCacheConfig, param) {
  var data = ReactRelay.useLazyLoadQuery(PLPHeaderBuyerQuery_graphql.node, RescriptRelay_Internal.internal_cleanObjectFromUndefinedRaw(PLPHeaderBuyerQuery_graphql.Internal.convertVariables(variables)), {
        fetchKey: fetchKey,
        fetchPolicy: RescriptRelay.mapFetchPolicy(fetchPolicy),
        networkCacheConfig: networkCacheConfig
      });
  return RescriptRelay_Internal.internal_useConvertedValue(PLPHeaderBuyerQuery_graphql.Internal.convertResponse, data);
}

function useLoader(param) {
  var match = ReactRelay.useQueryLoader(PLPHeaderBuyerQuery_graphql.node);
  var loadQueryFn = match[1];
  var loadQuery = React.useMemo((function () {
          return function (param, param$1, param$2, param$3) {
            return Curry._2(loadQueryFn, PLPHeaderBuyerQuery_graphql.Internal.convertVariables(param), {
                        fetchPolicy: param$1,
                        networkCacheConfig: param$2
                      });
          };
        }), [loadQueryFn]);
  return [
          Caml_option.nullable_to_opt(match[0]),
          loadQuery,
          match[2]
        ];
}

function $$fetch(environment, variables, onResult, networkCacheConfig, fetchPolicy, param) {
  ReactRelay.fetchQuery(environment, PLPHeaderBuyerQuery_graphql.node, PLPHeaderBuyerQuery_graphql.Internal.convertVariables(variables), {
          networkCacheConfig: networkCacheConfig,
          fetchPolicy: RescriptRelay.mapFetchQueryFetchPolicy(fetchPolicy)
        }).subscribe({
        next: (function (res) {
            Curry._1(onResult, {
                  TAG: /* Ok */0,
                  _0: PLPHeaderBuyerQuery_graphql.Internal.convertResponse(res)
                });
          }),
        error: (function (err) {
            Curry._1(onResult, {
                  TAG: /* Error */1,
                  _0: err
                });
          })
      });
}

function fetchPromised(environment, variables, networkCacheConfig, fetchPolicy, param) {
  var __x = ReactRelay.fetchQuery(environment, PLPHeaderBuyerQuery_graphql.node, PLPHeaderBuyerQuery_graphql.Internal.convertVariables(variables), {
          networkCacheConfig: networkCacheConfig,
          fetchPolicy: RescriptRelay.mapFetchQueryFetchPolicy(fetchPolicy)
        }).toPromise();
  return Js_promise.then_((function (res) {
                return Promise.resolve(PLPHeaderBuyerQuery_graphql.Internal.convertResponse(res));
              }), __x);
}

function usePreloaded(queryRef, param) {
  var data = ReactRelay.usePreloadedQuery(PLPHeaderBuyerQuery_graphql.node, queryRef);
  return RescriptRelay_Internal.internal_useConvertedValue(PLPHeaderBuyerQuery_graphql.Internal.convertResponse, data);
}

function retain(environment, variables) {
  var operationDescriptor = RelayRuntime.createOperationDescriptor(PLPHeaderBuyerQuery_graphql.node, PLPHeaderBuyerQuery_graphql.Internal.convertVariables(variables));
  return environment.retain(operationDescriptor);
}

var Query = {
  Operation: undefined,
  Types: undefined,
  use: use,
  useLoader: useLoader,
  $$fetch: $$fetch,
  fetchPromised: fetchPromised,
  usePreloaded: usePreloaded,
  retain: retain
};

function PLP_Header_Buyer$DisplayCategoryName(Props) {
  var displayCategoryId = Props.displayCategoryId;
  var match = use({
        displayCategoryId: displayCategoryId
      }, undefined, undefined, undefined, undefined);
  var node = match.node;
  if (node !== undefined) {
    return React.createElement("span", {
                className: "font-bold text-xl"
              }, node.name);
  } else {
    return React.createElement("span", undefined);
  }
}

var DisplayCategoryName = {
  Query: Query,
  make: PLP_Header_Buyer$DisplayCategoryName
};

function PLP_Header_Buyer(Props) {
  var router = Router.useRouter();
  var displayCategoryId = Js_dict.get(router.query, "category-id");
  var match = React.useState(function () {
        return false;
      });
  var setIsCsr = match[1];
  React.useEffect((function () {
          setIsCsr(function (param) {
                return true;
              });
        }), []);
  return React.createElement(React.Fragment, undefined, React.createElement("div", {
                  className: "w-full fixed top-0 left-0 z-10 bg-white"
                }, React.createElement("header", {
                      className: "w-full max-w-3xl mx-auto h-14 bg-white"
                    }, React.createElement("div", {
                          className: "px-5 py-4 flex justify-between"
                        }, React.createElement("button", {
                              onClick: (function (param) {
                                  router.back();
                                })
                            }, React.createElement("img", {
                                  className: "w-6 h-6 rotate-180",
                                  src: "/assets/arrow-right.svg"
                                })), React.createElement("div", undefined, match[0] ? (
                                displayCategoryId !== undefined ? React.createElement(RescriptReactErrorBoundary.make, {
                                        children: React.createElement(React.Suspense, {
                                              children: React.createElement(PLP_Header_Buyer$DisplayCategoryName, {
                                                    displayCategoryId: displayCategoryId
                                                  }),
                                              fallback: React.createElement("span", undefined)
                                            }),
                                        fallback: (function (param) {
                                            return React.createElement("span", undefined);
                                          })
                                      }) : React.createElement("span", {
                                        className: "font-bold text-xl"
                                      }, "전체 상품")
                              ) : React.createElement("span", undefined)), React.createElement("button", {
                              onClick: (function (param) {
                                  router.push("/buyer");
                                })
                            }, React.createElement(IconHome.make, {
                                  width: "24",
                                  height: "24",
                                  fill: "#262626"
                                }))))), React.createElement("div", {
                  className: "w-full h-14"
                }));
}

var make = PLP_Header_Buyer;

export {
  DisplayCategoryName ,
  make ,
}
/* react Not a pure module */
