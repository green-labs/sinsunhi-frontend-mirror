// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as DS_None from "../../../components/common/container/DS_None.mjs";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as Router from "next/router";
import * as Authorization from "../../../utils/Authorization.mjs";
import * as RescriptRelay from "rescript-relay/src/RescriptRelay.mjs";
import * as RelayRuntime from "relay-runtime";
import * as Hooks from "react-relay/hooks";
import * as RescriptRelay_Internal from "rescript-relay/src/RescriptRelay_Internal.mjs";
import * as RfqConfirmSeller_RfqQuotatinoMeatNode_Query_graphql from "../../../__generated__/RfqConfirmSeller_RfqQuotatinoMeatNode_Query_graphql.mjs";

function use(variables, fetchPolicy, fetchKey, networkCacheConfig, param) {
  var data = Hooks.useLazyLoadQuery(RfqConfirmSeller_RfqQuotatinoMeatNode_Query_graphql.node, RescriptRelay_Internal.internal_cleanObjectFromUndefinedRaw(RfqConfirmSeller_RfqQuotatinoMeatNode_Query_graphql.Internal.convertVariables(variables)), {
        fetchKey: fetchKey,
        fetchPolicy: RescriptRelay.mapFetchPolicy(fetchPolicy),
        networkCacheConfig: networkCacheConfig
      });
  return RescriptRelay_Internal.internal_useConvertedValue(RfqConfirmSeller_RfqQuotatinoMeatNode_Query_graphql.Internal.convertResponse, data);
}

function useLoader(param) {
  var match = Hooks.useQueryLoader(RfqConfirmSeller_RfqQuotatinoMeatNode_Query_graphql.node);
  var loadQueryFn = match[1];
  var loadQuery = React.useMemo((function () {
          return function (param, param$1, param$2, param$3) {
            return Curry._2(loadQueryFn, RfqConfirmSeller_RfqQuotatinoMeatNode_Query_graphql.Internal.convertVariables(param), {
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
  Hooks.fetchQuery(environment, RfqConfirmSeller_RfqQuotatinoMeatNode_Query_graphql.node, RfqConfirmSeller_RfqQuotatinoMeatNode_Query_graphql.Internal.convertVariables(variables), {
          networkCacheConfig: networkCacheConfig,
          fetchPolicy: RescriptRelay.mapFetchQueryFetchPolicy(fetchPolicy)
        }).subscribe({
        next: (function (res) {
            return Curry._1(onResult, {
                        TAG: /* Ok */0,
                        _0: RfqConfirmSeller_RfqQuotatinoMeatNode_Query_graphql.Internal.convertResponse(res)
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
  var __x = Hooks.fetchQuery(environment, RfqConfirmSeller_RfqQuotatinoMeatNode_Query_graphql.node, RfqConfirmSeller_RfqQuotatinoMeatNode_Query_graphql.Internal.convertVariables(variables), {
          networkCacheConfig: networkCacheConfig,
          fetchPolicy: RescriptRelay.mapFetchQueryFetchPolicy(fetchPolicy)
        }).toPromise();
  return __x.then(function (res) {
              return Promise.resolve(RfqConfirmSeller_RfqQuotatinoMeatNode_Query_graphql.Internal.convertResponse(res));
            });
}

function usePreloaded(queryRef, param) {
  var data = Hooks.usePreloadedQuery(RfqConfirmSeller_RfqQuotatinoMeatNode_Query_graphql.node, queryRef);
  return RescriptRelay_Internal.internal_useConvertedValue(RfqConfirmSeller_RfqQuotatinoMeatNode_Query_graphql.Internal.convertResponse, data);
}

function retain(environment, variables) {
  var operationDescriptor = RelayRuntime.createOperationDescriptor(RfqConfirmSeller_RfqQuotatinoMeatNode_Query_graphql.node, RfqConfirmSeller_RfqQuotatinoMeatNode_Query_graphql.Internal.convertVariables(variables));
  return environment.retain(operationDescriptor);
}

var Query_makeVariables = RfqConfirmSeller_RfqQuotatinoMeatNode_Query_graphql.Utils.makeVariables;

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

function RfqConfirm_Seller$ConfirmPageRouter(Props) {
  var quotationId = Props.quotationId;
  var match = use({
        id: quotationId
      }, undefined, undefined, undefined, undefined);
  var node = match.node;
  var router = Router.useRouter();
  if (node !== undefined) {
    router.replace("/seller/rfq/request/" + node.requestItem.id);
    return null;
  } else {
    return React.createElement(DS_None.Default.make, {
                message: "????????? ????????? ????????????."
              });
  }
}

var ConfirmPageRouter = {
  make: RfqConfirm_Seller$ConfirmPageRouter
};

function RfqConfirm_Seller(Props) {
  var quotationId = Props.quotationId;
  return React.createElement(Authorization.Seller.make, {
              children: React.createElement(React.Suspense, {
                    children: quotationId !== undefined ? React.createElement(RfqConfirm_Seller$ConfirmPageRouter, {
                            quotationId: quotationId
                          }) : React.createElement(DS_None.Default.make, {
                            message: "??????????????? ????????? ????????? ??? ????????????. ??????????????? ??????????????????."
                          })
                  }),
              title: "?????? ??????",
              fallback: null
            });
}

var make = RfqConfirm_Seller;

export {
  Query ,
  ConfirmPageRouter ,
  make ,
  
}
/* react Not a pure module */
