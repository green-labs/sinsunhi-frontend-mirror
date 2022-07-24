// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as DataGtm from "../../../../utils/DataGtm.mjs";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as Js_promise from "rescript/lib/es6/js_promise.js";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as ReactRelay from "react-relay";
import * as RescriptRelay from "rescript-relay/src/RescriptRelay.mjs";
import * as RelayRuntime from "relay-runtime";
import * as Js_null_undefined from "rescript/lib/es6/js_null_undefined.js";
import * as RescriptRelay_Internal from "rescript-relay/src/RescriptRelay_Internal.mjs";
import * as PDPNormalGtmBuyer_ClickBuy_Query_graphql from "../../../../__generated__/PDPNormalGtmBuyer_ClickBuy_Query_graphql.mjs";
import * as PDPNormalGtmBuyer_ClickBuy_Fragment_graphql from "../../../../__generated__/PDPNormalGtmBuyer_ClickBuy_Fragment_graphql.mjs";

function use(variables, fetchPolicy, fetchKey, networkCacheConfig, param) {
  var data = ReactRelay.useLazyLoadQuery(PDPNormalGtmBuyer_ClickBuy_Query_graphql.node, RescriptRelay_Internal.internal_cleanObjectFromUndefinedRaw(PDPNormalGtmBuyer_ClickBuy_Query_graphql.Internal.convertVariables(variables)), {
        fetchKey: fetchKey,
        fetchPolicy: RescriptRelay.mapFetchPolicy(fetchPolicy),
        networkCacheConfig: networkCacheConfig
      });
  return RescriptRelay_Internal.internal_useConvertedValue(PDPNormalGtmBuyer_ClickBuy_Query_graphql.Internal.convertResponse, data);
}

function useLoader(param) {
  var match = ReactRelay.useQueryLoader(PDPNormalGtmBuyer_ClickBuy_Query_graphql.node);
  var loadQueryFn = match[1];
  var loadQuery = React.useMemo((function () {
          return function (param, param$1, param$2, param$3) {
            return Curry._2(loadQueryFn, PDPNormalGtmBuyer_ClickBuy_Query_graphql.Internal.convertVariables(param), {
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
  ReactRelay.fetchQuery(environment, PDPNormalGtmBuyer_ClickBuy_Query_graphql.node, PDPNormalGtmBuyer_ClickBuy_Query_graphql.Internal.convertVariables(variables), {
          networkCacheConfig: networkCacheConfig,
          fetchPolicy: RescriptRelay.mapFetchQueryFetchPolicy(fetchPolicy)
        }).subscribe({
        next: (function (res) {
            Curry._1(onResult, {
                  TAG: /* Ok */0,
                  _0: PDPNormalGtmBuyer_ClickBuy_Query_graphql.Internal.convertResponse(res)
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
  var __x = ReactRelay.fetchQuery(environment, PDPNormalGtmBuyer_ClickBuy_Query_graphql.node, PDPNormalGtmBuyer_ClickBuy_Query_graphql.Internal.convertVariables(variables), {
          networkCacheConfig: networkCacheConfig,
          fetchPolicy: RescriptRelay.mapFetchQueryFetchPolicy(fetchPolicy)
        }).toPromise();
  return Js_promise.then_((function (res) {
                return Promise.resolve(PDPNormalGtmBuyer_ClickBuy_Query_graphql.Internal.convertResponse(res));
              }), __x);
}

function usePreloaded(queryRef, param) {
  var data = ReactRelay.usePreloadedQuery(PDPNormalGtmBuyer_ClickBuy_Query_graphql.node, queryRef);
  return RescriptRelay_Internal.internal_useConvertedValue(PDPNormalGtmBuyer_ClickBuy_Query_graphql.Internal.convertResponse, data);
}

function retain(environment, variables) {
  var operationDescriptor = RelayRuntime.createOperationDescriptor(PDPNormalGtmBuyer_ClickBuy_Query_graphql.node, PDPNormalGtmBuyer_ClickBuy_Query_graphql.Internal.convertVariables(variables));
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

function use$1(fRef) {
  var data = ReactRelay.useFragment(PDPNormalGtmBuyer_ClickBuy_Fragment_graphql.node, fRef);
  return RescriptRelay_Internal.internal_useConvertedValue(PDPNormalGtmBuyer_ClickBuy_Fragment_graphql.Internal.convertFragment, data);
}

function useOpt(opt_fRef) {
  var fr = opt_fRef !== undefined ? Caml_option.some(Caml_option.valFromOption(opt_fRef)) : undefined;
  var nullableFragmentData = ReactRelay.useFragment(PDPNormalGtmBuyer_ClickBuy_Fragment_graphql.node, fr !== undefined ? Js_null_undefined.fromOption(Caml_option.some(Caml_option.valFromOption(fr))) : null);
  var data = (nullableFragmentData == null) ? undefined : Caml_option.some(nullableFragmentData);
  return RescriptRelay_Internal.internal_useConvertedValue((function (rawFragment) {
                if (rawFragment !== undefined) {
                  return PDPNormalGtmBuyer_ClickBuy_Fragment_graphql.Internal.convertFragment(rawFragment);
                }
                
              }), data);
}

var Fragment = {
  Types: undefined,
  Operation: undefined,
  use: use$1,
  useOpt: useOpt
};

function use$2(query, selectedOptionId, quantity) {
  var match = use({
        id: selectedOptionId
      }, /* StoreOrNetwork */1, undefined, undefined, undefined);
  var node = match.node;
  var match$1 = use$1(query);
  var productId = match$1.productId;
  var displayName = match$1.displayName;
  var categoryNames = Belt_Array.map(match$1.category.fullyQualifiedName, (function (param) {
          return param.name;
        }));
  var producerCode = Belt_Option.map(match$1.producer, (function (param) {
          return param.producerCode;
        }));
  var stockSku = Belt_Option.map(node, (function (param) {
          return param.stockSku;
        }));
  var price = Belt_Option.map(node, (function (param) {
          return param.price;
        }));
  return function (param) {
    DataGtm.push({
          event: "click_purchase",
          items: [{
              currency: "KRW",
              item_id: String(productId),
              item_name: displayName,
              item_brand: Js_null_undefined.fromOption(producerCode),
              item_variant: Js_null_undefined.fromOption(stockSku),
              price: Js_null_undefined.fromOption(price),
              quantity: quantity,
              item_category: Js_null_undefined.fromOption(Belt_Array.get(categoryNames, 0)),
              item_category2: Js_null_undefined.fromOption(Belt_Array.get(categoryNames, 1)),
              item_category3: Js_null_undefined.fromOption(Belt_Array.get(categoryNames, 2)),
              item_category4: Js_null_undefined.fromOption(Belt_Array.get(categoryNames, 3)),
              item_category5: Js_null_undefined.fromOption(Belt_Array.get(categoryNames, 4))
            }]
        });
  };
}

var ClickBuy = {
  Query: Query,
  Fragment: Fragment,
  use: use$2
};

export {
  ClickBuy ,
}
/* react Not a pure module */
