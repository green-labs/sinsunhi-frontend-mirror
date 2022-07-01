// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as Js_dict from "rescript/lib/es6/js_dict.js";
import * as Belt_Int from "rescript/lib/es6/belt_Int.js";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as Router from "next/router";
import * as Authorization from "../../utils/Authorization.mjs";
import * as RescriptRelay from "rescript-relay/src/RescriptRelay.mjs";
import * as RelayRuntime from "relay-runtime";
import * as Hooks from "react-relay/hooks";
import * as Select_CountPerPage from "../../components/Select_CountPerPage.mjs";
import * as RescriptRelay_Internal from "rescript-relay/src/RescriptRelay_Internal.mjs";
import * as Product_Option_List_Admin from "../../components/Product_Option_List_Admin.mjs";
import * as RescriptReactErrorBoundary from "@rescript/react/src/RescriptReactErrorBoundary.mjs";
import * as Search_Product_Option_Admin from "../../components/Search_Product_Option_Admin.mjs";
import * as Excel_Download_Request_Button from "../../components/Excel_Download_Request_Button.mjs";
import * as ProductOptionsAdminQuery_graphql from "../../__generated__/ProductOptionsAdminQuery_graphql.mjs";

function use(variables, fetchPolicy, fetchKey, networkCacheConfig, param) {
  var data = Hooks.useLazyLoadQuery(ProductOptionsAdminQuery_graphql.node, RescriptRelay_Internal.internal_cleanObjectFromUndefinedRaw(ProductOptionsAdminQuery_graphql.Internal.convertVariables(variables)), {
        fetchKey: fetchKey,
        fetchPolicy: RescriptRelay.mapFetchPolicy(fetchPolicy),
        networkCacheConfig: networkCacheConfig
      });
  return RescriptRelay_Internal.internal_useConvertedValue(ProductOptionsAdminQuery_graphql.Internal.convertResponse, data);
}

function useLoader(param) {
  var match = Hooks.useQueryLoader(ProductOptionsAdminQuery_graphql.node);
  var loadQueryFn = match[1];
  var loadQuery = React.useMemo((function () {
          return function (param, param$1, param$2, param$3) {
            return Curry._2(loadQueryFn, ProductOptionsAdminQuery_graphql.Internal.convertVariables(param), {
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
  Hooks.fetchQuery(environment, ProductOptionsAdminQuery_graphql.node, ProductOptionsAdminQuery_graphql.Internal.convertVariables(variables), {
          networkCacheConfig: networkCacheConfig,
          fetchPolicy: RescriptRelay.mapFetchQueryFetchPolicy(fetchPolicy)
        }).subscribe({
        next: (function (res) {
            return Curry._1(onResult, {
                        TAG: /* Ok */0,
                        _0: ProductOptionsAdminQuery_graphql.Internal.convertResponse(res)
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
  var __x = Hooks.fetchQuery(environment, ProductOptionsAdminQuery_graphql.node, ProductOptionsAdminQuery_graphql.Internal.convertVariables(variables), {
          networkCacheConfig: networkCacheConfig,
          fetchPolicy: RescriptRelay.mapFetchQueryFetchPolicy(fetchPolicy)
        }).toPromise();
  return __x.then(function (res) {
              return Promise.resolve(ProductOptionsAdminQuery_graphql.Internal.convertResponse(res));
            });
}

function usePreloaded(queryRef, param) {
  var data = Hooks.usePreloadedQuery(ProductOptionsAdminQuery_graphql.node, queryRef);
  return RescriptRelay_Internal.internal_useConvertedValue(ProductOptionsAdminQuery_graphql.Internal.convertResponse, data);
}

function retain(environment, variables) {
  var operationDescriptor = RelayRuntime.createOperationDescriptor(ProductOptionsAdminQuery_graphql.node, ProductOptionsAdminQuery_graphql.Internal.convertVariables(variables));
  return environment.retain(operationDescriptor);
}

var Query_productOptionSort_decode = ProductOptionsAdminQuery_graphql.Utils.productOptionSort_decode;

var Query_productOptionSort_fromString = ProductOptionsAdminQuery_graphql.Utils.productOptionSort_fromString;

var Query_productOptionStatus_decode = ProductOptionsAdminQuery_graphql.Utils.productOptionStatus_decode;

var Query_productOptionStatus_fromString = ProductOptionsAdminQuery_graphql.Utils.productOptionStatus_fromString;

var Query_makeVariables = ProductOptionsAdminQuery_graphql.Utils.makeVariables;

var Query = {
  productOptionSort_decode: Query_productOptionSort_decode,
  productOptionSort_fromString: Query_productOptionSort_fromString,
  productOptionStatus_decode: Query_productOptionStatus_decode,
  productOptionStatus_fromString: Query_productOptionStatus_fromString,
  makeVariables: Query_makeVariables,
  Types: undefined,
  use: use,
  useLoader: useLoader,
  $$fetch: $$fetch,
  fetchPromised: fetchPromised,
  usePreloaded: usePreloaded,
  retain: retain
};

function ProductOptions_Admin$Skeleton(Props) {
  return React.createElement("div", {
              className: "max-w-gnb-panel overflow-auto overflow-x-scroll bg-div-shape-L1 min-h-gnb-admin"
            }, React.createElement("header", {
                  className: "flex items-baseline p-7 pb-0"
                }, React.createElement("h1", {
                      className: "text-text-L1 text-xl font-bold"
                    }, "상품 조회")), React.createElement("div", {
                  className: "p-7 m-4 shadow-gl overflow-auto overflow-x-scroll bg-white rounded"
                }, React.createElement(Product_Option_List_Admin.Skeleton.make, {})));
}

var Skeleton = {
  make: ProductOptions_Admin$Skeleton
};

function ProductOptions_Admin$ProductOptions(Props) {
  var router = Router.useRouter();
  var match = Js_dict.get(router.query, "status");
  var tmp;
  if (match !== undefined) {
    switch (match) {
      case "HIDDEN_SALE" :
          tmp = "HIDDEN_SALE";
          break;
      case "NOSALE" :
          tmp = "NOSALE";
          break;
      case "RETIRE" :
          tmp = "RETIRE";
          break;
      case "SALE" :
          tmp = "SALE";
          break;
      case "SOLDOUT" :
          tmp = "SOLDOUT";
          break;
      default:
        tmp = undefined;
    }
  } else {
    tmp = undefined;
  }
  var queryData = use({
        sort: "SKU_DESC",
        limit: Belt_Option.getWithDefault(Belt_Option.flatMap(Js_dict.get(router.query, "limit"), Belt_Int.fromString), 25),
        offset: Belt_Option.flatMap(Js_dict.get(router.query, "offset"), Belt_Int.fromString),
        producerName: Belt_Option.flatMap(Js_dict.get(router.query, "producer-name"), (function (a) {
                if (a === "") {
                  return ;
                } else {
                  return a;
                }
              })),
        status: tmp,
        productName: Belt_Option.flatMap(Js_dict.get(router.query, "product-name"), (function (a) {
                if (a === "") {
                  return ;
                } else {
                  return a;
                }
              })),
        categoryId: Belt_Option.flatMap(Js_dict.get(router.query, "category-id"), Belt_Int.fromString)
      }, /* StoreAndNetwork */2, undefined, undefined, undefined);
  console.log(router);
  return React.createElement("div", {
              className: "max-w-gnb-panel overflow-auto overflow-x-scroll bg-div-shape-L1 min-h-screen"
            }, React.createElement("header", {
                  className: "flex items-baseline p-7 pb-0"
                }, React.createElement("h1", {
                      className: "text-text-L1 text-xl font-bold"
                    }, "단품 목록 조회")), React.createElement(Search_Product_Option_Admin.make, {}), React.createElement("div", {
                  className: "p-7 m-4 overflow-auto overflow-x-scroll bg-white rounded shadow-gl"
                }, React.createElement("div", {
                      className: "md:flex md:justify-between pb-4"
                    }, React.createElement("div", {
                          className: "flex flex-auto justify-between"
                        }, React.createElement("h3", {
                              className: "font-bold"
                            }, "내역", React.createElement("span", {
                                  className: "ml-1 text-green-gl font-normal"
                                }, String(queryData.productOptions.totalCount) + "건")), React.createElement("div", {
                              className: "flex"
                            }, React.createElement(Select_CountPerPage.make, {
                                  className: "mr-2"
                                }), React.createElement(Excel_Download_Request_Button.make, {
                                  userType: /* Admin */2,
                                  requestUrl: "/product/request-excel"
                                })))), React.createElement(Product_Option_List_Admin.make, {
                      query: queryData.fragmentRefs
                    })));
}

var ProductOptions = {
  make: ProductOptions_Admin$ProductOptions
};

function ProductOptions_Admin(Props) {
  return React.createElement(Authorization.Admin.make, {
              children: React.createElement(RescriptReactErrorBoundary.make, {
                    children: React.createElement(React.Suspense, {
                          children: React.createElement(ProductOptions_Admin$ProductOptions, {}),
                          fallback: React.createElement(ProductOptions_Admin$Skeleton, {})
                        }),
                    fallback: (function (param) {
                        return React.createElement("div", undefined, "에러 발생");
                      })
                  }),
              title: "관리자 상품 조회"
            });
}

var List;

var make = ProductOptions_Admin;

export {
  List ,
  Query ,
  Skeleton ,
  ProductOptions ,
  make ,
  
}
/* react Not a pure module */