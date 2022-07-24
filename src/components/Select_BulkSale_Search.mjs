// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as Helper from "../utils/Helper.mjs";
import * as RelayEnv from "../constants/RelayEnv.mjs";
import * as IconCheck from "./svgs/IconCheck.mjs";
import * as IconError from "./svgs/IconError.mjs";
import * as Js_promise from "rescript/lib/es6/js_promise.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as ReactRelay from "react-relay";
import * as Garter_Array from "@greenlabs/garter/src/Garter_Array.mjs";
import * as RescriptRelay from "rescript-relay/src/RescriptRelay.mjs";
import * as RelayRuntime from "relay-runtime";
import Async from "react-select/async";
import * as Select_BulkSale_Crop from "./Select_BulkSale_Crop.mjs";
import * as RescriptRelay_Internal from "rescript-relay/src/RescriptRelay_Internal.mjs";
import * as ReactToastNotifications from "react-toast-notifications";
import * as Select_BulkSale_ProductCategory from "./Select_BulkSale_ProductCategory.mjs";
import * as SelectBulkSaleSearchStaffQuery_graphql from "../__generated__/SelectBulkSaleSearchStaffQuery_graphql.mjs";
import * as SelectBulkSaleSearchStaffMutation_graphql from "../__generated__/SelectBulkSaleSearchStaffMutation_graphql.mjs";

function Select_BulkSale_Search$Crop(Props) {
  var cropId = Props.cropId;
  var onChange = Props.onChange;
  var disabledOpt = Props.disabled;
  var disabled = disabledOpt !== undefined ? disabledOpt : false;
  var handleLoadOptions = function (inputValue) {
    return Js_promise.then_((function (result) {
                  var result$p = Garter_Array.map(result.crops.edges, (function (edge) {
                          return /* Selected */{
                                  value: edge.node.id,
                                  label: edge.node.name
                                };
                        }));
                  return Promise.resolve(result$p);
                }), Select_BulkSale_Crop.Query.fetchPromised(RelayEnv.envFMBridge, {
                    count: 1000,
                    cursor: undefined,
                    nameMatch: inputValue,
                    orderBy: "NAME",
                    orderDirection: "ASC"
                  }, undefined, undefined, undefined));
  };
  return React.createElement("article", {
              className: "w-full"
            }, React.createElement(Async, {
                  value: cropId,
                  cacheOptions: false,
                  defaultOptions: true,
                  loadOptions: Helper.Debounce.make1(handleLoadOptions, 500),
                  onChange: onChange,
                  placeholder: "품목 검색",
                  noOptionsMessage: (function (param) {
                      return "검색 결과가 없습니다.";
                    }),
                  isClearable: true,
                  isDisabled: disabled,
                  styles: {
                    menu: (function (provide, param) {
                        return Object.assign(provide, {
                                    position: "inherit",
                                    "z-index": "999"
                                  });
                      }),
                    control: (function (provide, param) {
                        return Object.assign(provide, {
                                    "min-height": "unset",
                                    height: "2.25rem",
                                    "border-radius": "0.5rem"
                                  });
                      })
                  }
                }));
}

var Crop = {
  Query: undefined,
  make: Select_BulkSale_Search$Crop
};

function Select_BulkSale_Search$ProductCategory(Props) {
  var cropId = Props.cropId;
  var productCategoryId = Props.productCategoryId;
  var onChange = Props.onChange;
  var disabledOpt = Props.disabled;
  var disabled = disabledOpt !== undefined ? disabledOpt : false;
  var handleLoadOptions = function (inputValue) {
    if (cropId) {
      return Js_promise.then_((function (result) {
                    var result$p = Garter_Array.map(result.productCategories.edges, (function (edge) {
                            return /* Selected */{
                                    value: edge.node.id,
                                    label: edge.node.name
                                  };
                          }));
                    return Promise.resolve(result$p);
                  }), Select_BulkSale_ProductCategory.Query.fetchPromised(RelayEnv.envFMBridge, {
                      count: 1000,
                      cropIds: [cropId.value],
                      cursor: undefined,
                      nameMatch: inputValue,
                      orderBy: "NAME",
                      orderDirection: "ASC"
                    }, undefined, undefined, undefined));
    } else {
      return Promise.resolve(undefined);
    }
  };
  return React.createElement("article", {
              className: "w-full"
            }, React.createElement(Async, {
                  value: productCategoryId,
                  cacheOptions: false,
                  defaultOptions: true,
                  loadOptions: Helper.Debounce.make1(handleLoadOptions, 500),
                  onChange: onChange,
                  placeholder: "품종 검색",
                  noOptionsMessage: (function (param) {
                      if (cropId) {
                        return "검색 결과가 없습니다.";
                      } else {
                        return "품목을 검색해 주세요.";
                      }
                    }),
                  isClearable: true,
                  isDisabled: disabled,
                  styles: {
                    menu: (function (provide, param) {
                        return Object.assign(provide, {
                                    position: "inherit",
                                    "z-index": "999"
                                  });
                      }),
                    control: (function (provide, param) {
                        return Object.assign(provide, {
                                    "min-height": "unset",
                                    height: "2.25rem",
                                    "border-radius": "0.5rem"
                                  });
                      })
                  }
                }));
}

var ProductCategory = {
  Query: undefined,
  make: Select_BulkSale_Search$ProductCategory
};

function use(variables, fetchPolicy, fetchKey, networkCacheConfig, param) {
  var data = ReactRelay.useLazyLoadQuery(SelectBulkSaleSearchStaffQuery_graphql.node, RescriptRelay_Internal.internal_cleanObjectFromUndefinedRaw(SelectBulkSaleSearchStaffQuery_graphql.Internal.convertVariables(variables)), {
        fetchKey: fetchKey,
        fetchPolicy: RescriptRelay.mapFetchPolicy(fetchPolicy),
        networkCacheConfig: networkCacheConfig
      });
  return RescriptRelay_Internal.internal_useConvertedValue(SelectBulkSaleSearchStaffQuery_graphql.Internal.convertResponse, data);
}

function useLoader(param) {
  var match = ReactRelay.useQueryLoader(SelectBulkSaleSearchStaffQuery_graphql.node);
  var loadQueryFn = match[1];
  var loadQuery = React.useMemo((function () {
          return function (param, param$1, param$2, param$3) {
            return Curry._2(loadQueryFn, SelectBulkSaleSearchStaffQuery_graphql.Internal.convertVariables(param), {
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
  ReactRelay.fetchQuery(environment, SelectBulkSaleSearchStaffQuery_graphql.node, SelectBulkSaleSearchStaffQuery_graphql.Internal.convertVariables(variables), {
          networkCacheConfig: networkCacheConfig,
          fetchPolicy: RescriptRelay.mapFetchQueryFetchPolicy(fetchPolicy)
        }).subscribe({
        next: (function (res) {
            Curry._1(onResult, {
                  TAG: /* Ok */0,
                  _0: SelectBulkSaleSearchStaffQuery_graphql.Internal.convertResponse(res)
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
  var __x = ReactRelay.fetchQuery(environment, SelectBulkSaleSearchStaffQuery_graphql.node, SelectBulkSaleSearchStaffQuery_graphql.Internal.convertVariables(variables), {
          networkCacheConfig: networkCacheConfig,
          fetchPolicy: RescriptRelay.mapFetchQueryFetchPolicy(fetchPolicy)
        }).toPromise();
  return Js_promise.then_((function (res) {
                return Promise.resolve(SelectBulkSaleSearchStaffQuery_graphql.Internal.convertResponse(res));
              }), __x);
}

function usePreloaded(queryRef, param) {
  var data = ReactRelay.usePreloadedQuery(SelectBulkSaleSearchStaffQuery_graphql.node, queryRef);
  return RescriptRelay_Internal.internal_useConvertedValue(SelectBulkSaleSearchStaffQuery_graphql.Internal.convertResponse, data);
}

function retain(environment, variables) {
  var operationDescriptor = RelayRuntime.createOperationDescriptor(SelectBulkSaleSearchStaffQuery_graphql.node, SelectBulkSaleSearchStaffQuery_graphql.Internal.convertVariables(variables));
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

function commitMutation(environment, variables, optimisticUpdater, optimisticResponse, updater, onCompleted, onError, uploadables, param) {
  return RelayRuntime.commitMutation(environment, {
              mutation: SelectBulkSaleSearchStaffMutation_graphql.node,
              variables: SelectBulkSaleSearchStaffMutation_graphql.Internal.convertVariables(variables),
              onCompleted: (function (res, err) {
                  if (onCompleted !== undefined) {
                    return Curry._2(onCompleted, SelectBulkSaleSearchStaffMutation_graphql.Internal.convertResponse(res), (err == null) ? undefined : Caml_option.some(err));
                  }
                  
                }),
              onError: (function (err) {
                  if (onError !== undefined) {
                    return Curry._1(onError, (err == null) ? undefined : Caml_option.some(err));
                  }
                  
                }),
              optimisticResponse: optimisticResponse !== undefined ? SelectBulkSaleSearchStaffMutation_graphql.Internal.convertWrapRawResponse(optimisticResponse) : undefined,
              optimisticUpdater: optimisticUpdater,
              updater: updater !== undefined ? (function (store, r) {
                    Curry._2(updater, store, SelectBulkSaleSearchStaffMutation_graphql.Internal.convertResponse(r));
                  }) : undefined,
              uploadables: uploadables
            });
}

function use$1(param) {
  var match = ReactRelay.useMutation(SelectBulkSaleSearchStaffMutation_graphql.node);
  var mutate = match[0];
  return [
          React.useMemo((function () {
                  return function (param, param$1, param$2, param$3, param$4, param$5, param$6, param$7, param$8) {
                    return Curry._1(mutate, {
                                onError: param,
                                onCompleted: param$1 !== undefined ? (function (r, errors) {
                                      Curry._2(param$1, SelectBulkSaleSearchStaffMutation_graphql.Internal.convertResponse(r), (errors == null) ? undefined : Caml_option.some(errors));
                                    }) : undefined,
                                onUnsubscribe: param$2,
                                optimisticResponse: param$3 !== undefined ? SelectBulkSaleSearchStaffMutation_graphql.Internal.convertWrapRawResponse(param$3) : undefined,
                                optimisticUpdater: param$4,
                                updater: param$5 !== undefined ? (function (store, r) {
                                      Curry._2(param$5, store, SelectBulkSaleSearchStaffMutation_graphql.Internal.convertResponse(r));
                                    }) : undefined,
                                variables: SelectBulkSaleSearchStaffMutation_graphql.Internal.convertVariables(param$6),
                                uploadables: param$7
                              });
                  };
                }), [mutate]),
          match[1]
        ];
}

var Mutation = {
  Operation: undefined,
  Types: undefined,
  commitMutation: commitMutation,
  use: use$1
};

function getEmailId(x) {
  return Garter_Array.firstExn(x.split("@"));
}

function Select_BulkSale_Search$Staff(Props) {
  var applicationId = Props.applicationId;
  var staffInfo = Props.staffInfo;
  var onChange = Props.onChange;
  var match = ReactToastNotifications.useToasts();
  var addToast = match.addToast;
  var match$1 = React.useState(function () {
        return staffInfo;
      });
  var setSelectStaff = match$1[1];
  var match$2 = use$1(undefined);
  var mutate = match$2[0];
  var handleLoadOptions = function (inputValue) {
    return Js_promise.then_((function (result) {
                  var result$p = Garter_Array.map(result.adminUsers.edges, (function (edge) {
                          return /* Selected */{
                                  value: edge.node.id,
                                  label: edge.node.name + "( " + Garter_Array.firstExn(edge.node.emailAddress.split("@")) + " )"
                                };
                        }));
                  return Promise.resolve(result$p);
                }), fetchPromised(RelayEnv.envFMBridge, {
                    name: inputValue
                  }, undefined, undefined, undefined));
  };
  var handleOnChange = function (selectValue) {
    if (onChange !== undefined) {
      setSelectStaff(function (param) {
            return selectValue;
          });
      return Curry._1(onChange, selectValue);
    }
    if (applicationId === undefined) {
      return ;
    }
    var input_input = {
      staffId: selectValue ? selectValue.value : ""
    };
    var input = {
      id: applicationId,
      input: input_input
    };
    Curry.app(mutate, [
          (function (err) {
              console.log(err.message);
              addToast(React.createElement("div", {
                        className: "flex items-center"
                      }, React.createElement(IconError.make, {
                            width: "24",
                            height: "24",
                            className: "mr-2"
                          }), "담당자 변경중 오류가 발생하였습니다. 관리자에게 문의해주세요."), {
                    appearance: "error"
                  });
            }),
          (function (param, param$1) {
              addToast(React.createElement("div", {
                        className: "flex items-center"
                      }, React.createElement(IconCheck.make, {
                            height: "24",
                            width: "24",
                            fill: "#12B564",
                            className: "mr-2"
                          }), "담당자를 수정하였습니다."), {
                    appearance: "success"
                  });
              setSelectStaff(function (param) {
                    return selectValue;
                  });
            }),
          undefined,
          undefined,
          undefined,
          undefined,
          input,
          undefined,
          undefined
        ]);
  };
  return React.createElement("article", {
              className: "w-full"
            }, React.createElement(Async, {
                  value: match$1[0],
                  cacheOptions: false,
                  defaultOptions: true,
                  loadOptions: Helper.Debounce.make1(handleLoadOptions, 500),
                  onChange: handleOnChange,
                  placeholder: "담당자 선택",
                  noOptionsMessage: (function (param) {
                      return "검색 결과가 없습니다.";
                    }),
                  isClearable: true,
                  isDisabled: false,
                  styles: {
                    menu: (function (provide, param) {
                        return Object.assign(Object.assign({}, provide), {
                                    position: "absolute",
                                    "z-index": "999"
                                  });
                      }),
                    control: (function (provide, param) {
                        return Object.assign(Object.assign({}, provide), {
                                    "min-height": "unset",
                                    height: "2.25rem",
                                    "border-radius": "0.5rem"
                                  });
                      })
                  }
                }));
}

var Staff = {
  Query: Query,
  Mutation: Mutation,
  getEmailId: getEmailId,
  make: Select_BulkSale_Search$Staff
};

export {
  Crop ,
  ProductCategory ,
  Staff ,
}
/* react Not a pure module */
