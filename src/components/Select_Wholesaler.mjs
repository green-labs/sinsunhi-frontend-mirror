// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as Garter_Array from "@greenlabs/garter/src/Garter_Array.mjs";
import * as RescriptRelay from "rescript-relay/src/RescriptRelay.mjs";
import * as RelayRuntime from "relay-runtime";
import * as IconArrowSelect from "./svgs/IconArrowSelect.mjs";
import * as Hooks from "react-relay/hooks";
import * as RescriptRelay_Internal from "rescript-relay/src/RescriptRelay_Internal.mjs";
import * as SelectWholesalerQuery_graphql from "../__generated__/SelectWholesalerQuery_graphql.mjs";

function use(variables, fetchPolicy, fetchKey, networkCacheConfig, param) {
  var data = Hooks.useLazyLoadQuery(SelectWholesalerQuery_graphql.node, RescriptRelay_Internal.internal_cleanObjectFromUndefinedRaw(SelectWholesalerQuery_graphql.Internal.convertVariables(variables)), {
        fetchKey: fetchKey,
        fetchPolicy: RescriptRelay.mapFetchPolicy(fetchPolicy),
        networkCacheConfig: networkCacheConfig
      });
  return RescriptRelay_Internal.internal_useConvertedValue(SelectWholesalerQuery_graphql.Internal.convertResponse, data);
}

function useLoader(param) {
  var match = Hooks.useQueryLoader(SelectWholesalerQuery_graphql.node);
  var loadQueryFn = match[1];
  var loadQuery = React.useMemo((function () {
          return function (param, param$1, param$2, param$3) {
            return Curry._2(loadQueryFn, SelectWholesalerQuery_graphql.Internal.convertVariables(param), {
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
  Hooks.fetchQuery(environment, SelectWholesalerQuery_graphql.node, SelectWholesalerQuery_graphql.Internal.convertVariables(variables), {
          networkCacheConfig: networkCacheConfig,
          fetchPolicy: RescriptRelay.mapFetchQueryFetchPolicy(fetchPolicy)
        }).subscribe({
        next: (function (res) {
            return Curry._1(onResult, {
                        TAG: /* Ok */0,
                        _0: SelectWholesalerQuery_graphql.Internal.convertResponse(res)
                      });
          }),
        error: (function (err) {
            return Curry._1(onResult, {
                        TAG: /* Error */1,
                        _0: err
                      });
          })
      });
  
}

function fetchPromised(environment, variables, networkCacheConfig, fetchPolicy, param) {
  var __x = Hooks.fetchQuery(environment, SelectWholesalerQuery_graphql.node, SelectWholesalerQuery_graphql.Internal.convertVariables(variables), {
          networkCacheConfig: networkCacheConfig,
          fetchPolicy: RescriptRelay.mapFetchQueryFetchPolicy(fetchPolicy)
        }).toPromise();
  return __x.then(function (res) {
              return Promise.resolve(SelectWholesalerQuery_graphql.Internal.convertResponse(res));
            });
}

function usePreloaded(queryRef, param) {
  var data = Hooks.usePreloadedQuery(SelectWholesalerQuery_graphql.node, queryRef);
  return RescriptRelay_Internal.internal_useConvertedValue(SelectWholesalerQuery_graphql.Internal.convertResponse, data);
}

function retain(environment, variables) {
  var operationDescriptor = RelayRuntime.createOperationDescriptor(SelectWholesalerQuery_graphql.node, SelectWholesalerQuery_graphql.Internal.convertVariables(variables));
  return environment.retain(operationDescriptor);
}

var Query_makeVariables = SelectWholesalerQuery_graphql.Utils.makeVariables;

var Query = {
  makeVariables: Query_makeVariables,
  Types: undefined,
  use: use,
  useLoader: useLoader,
  $$fetch: $$fetch,
  fetchPromised: fetchPromised,
  usePreloaded: usePreloaded,
  retain: retain
};

function Select_Wholesaler$Loading(Props) {
  return React.createElement("article", {
              className: "flex-1"
            }, React.createElement("h3", {
                  className: "text-sm"
                }, "법인명"), React.createElement("label", {
                  className: "block relative mt-2"
                }, React.createElement("span", {
                      className: "flex items-center border border-border-default-L1 rounded-md h-9 px-3 text-enabled-L1"
                    }, "로딩 중"), React.createElement("span", {
                      className: "absolute top-1.5 right-2"
                    }, React.createElement(IconArrowSelect.make, {
                          height: "24",
                          width: "24",
                          fill: "#121212"
                        }))));
}

var Loading = {
  make: Select_Wholesaler$Loading
};

function Select_Wholesaler(Props) {
  var label = Props.label;
  var wholesalerMarketId = Props.wholesalerMarketId;
  var wholesalerId = Props.wholesalerId;
  var onChange = Props.onChange;
  var queryData = use({
        first: 100,
        marketIds: Belt_Option.map(wholesalerMarketId, (function (id) {
                return [id];
              }))
      }, undefined, undefined, undefined, undefined);
  return React.createElement("article", {
              className: "flex-1"
            }, React.createElement("h3", {
                  className: "text-sm"
                }, label), React.createElement("label", {
                  className: "block relative mt-2"
                }, React.createElement("span", {
                      className: "flex items-center border border-border-default-L1 rounded-md h-9 px-3 text-enabled-L1"
                    }, Belt_Option.getWithDefault(Belt_Option.flatMap(wholesalerId, (function (id) {
                                return Garter_Array.first(Belt_Array.map(Belt_Array.keep(queryData.wholesalers.edges, (function (edge) {
                                                      return edge.node.id === id;
                                                    })), (function (edge) {
                                                  return edge.node.name;
                                                })));
                              })), "시장 선택")), React.createElement("span", {
                      className: "absolute top-1.5 right-2"
                    }, React.createElement(IconArrowSelect.make, {
                          height: "24",
                          width: "24",
                          fill: "#121212"
                        })), React.createElement("select", {
                      className: "block w-full h-full absolute top-0 opacity-0",
                      value: Belt_Option.getWithDefault(wholesalerId, ""),
                      onChange: onChange
                    }, React.createElement("option", {
                          value: ""
                        }, "법인선택"), Belt_Array.map(queryData.wholesalers.edges, (function (edge) {
                            return React.createElement("option", {
                                        key: edge.node.id,
                                        value: edge.node.id
                                      }, edge.node.name);
                          })))));
}

var make = Select_Wholesaler;

export {
  Query ,
  Loading ,
  make ,
  
}
/* react Not a pure module */
