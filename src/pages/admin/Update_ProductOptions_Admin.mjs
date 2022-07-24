// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "rescript/lib/es6/curry.js";
import * as Spice from "@greenlabs/ppx-spice/src/rescript/Spice.mjs";
import * as React from "react";
import * as Dialog from "../../components/common/Dialog.mjs";
import * as Js_dict from "rescript/lib/es6/js_dict.js";
import * as Js_json from "rescript/lib/es6/js_json.js";
import * as IconError from "../../components/svgs/IconError.mjs";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as Belt_Float from "rescript/lib/es6/belt_Float.js";
import * as Js_promise from "rescript/lib/es6/js_promise.js";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as ReactEvents from "../../utils/ReactEvents.mjs";
import * as Router from "next/router";
import * as ReactRelay from "react-relay";
import * as Authorization from "../../utils/Authorization.mjs";
import * as ReactHookForm from "../../bindings/ReactHookForm/ReactHookForm.mjs";
import * as RescriptRelay from "rescript-relay/src/RescriptRelay.mjs";
import * as RelayRuntime from "relay-runtime";
import * as ReactHookForm$1 from "react-hook-form";
import * as Js_null_undefined from "rescript/lib/es6/js_null_undefined.js";
import * as Product_Summary_Admin from "../../components/Product_Summary_Admin.mjs";
import * as RescriptRelay_Internal from "rescript-relay/src/RescriptRelay_Internal.mjs";
import * as Add_ProductOption_Admin from "../../components/Add_ProductOption_Admin.mjs";
import * as Product_Option_Each_Admin from "../../components/Product_Option_Each_Admin.mjs";
import * as ReactToastNotifications from "react-toast-notifications";
import * as RescriptReactErrorBoundary from "@rescript/react/src/RescriptReactErrorBoundary.mjs";
import * as Select_Product_Option_Unit from "../../components/Select_Product_Option_Unit.mjs";
import * as Update_ProductOption_Admin from "../../components/Update_ProductOption_Admin.mjs";
import * as Update_ProductOption_List_Admin from "../../components/Update_ProductOption_List_Admin.mjs";
import * as UpdateProductOptionsAdminQuery_graphql from "../../__generated__/UpdateProductOptionsAdminQuery_graphql.mjs";
import * as UpdateProductOptionsAdminFragment_graphql from "../../__generated__/UpdateProductOptionsAdminFragment_graphql.mjs";
import * as UpdateProductOptionsAdminMutation_graphql from "../../__generated__/UpdateProductOptionsAdminMutation_graphql.mjs";
import InequalitySignRightSvg from "../../../public/assets/inequality-sign-right.svg";
import * as UpdateProductOptionsAdminProductTypeFragment_graphql from "../../__generated__/UpdateProductOptionsAdminProductTypeFragment_graphql.mjs";

var inequalitySignRightIcon = InequalitySignRightSvg;

function use(variables, fetchPolicy, fetchKey, networkCacheConfig, param) {
  var data = ReactRelay.useLazyLoadQuery(UpdateProductOptionsAdminQuery_graphql.node, RescriptRelay_Internal.internal_cleanObjectFromUndefinedRaw(UpdateProductOptionsAdminQuery_graphql.Internal.convertVariables(variables)), {
        fetchKey: fetchKey,
        fetchPolicy: RescriptRelay.mapFetchPolicy(fetchPolicy),
        networkCacheConfig: networkCacheConfig
      });
  return RescriptRelay_Internal.internal_useConvertedValue(UpdateProductOptionsAdminQuery_graphql.Internal.convertResponse, data);
}

function useLoader(param) {
  var match = ReactRelay.useQueryLoader(UpdateProductOptionsAdminQuery_graphql.node);
  var loadQueryFn = match[1];
  var loadQuery = React.useMemo((function () {
          return function (param, param$1, param$2, param$3) {
            return Curry._2(loadQueryFn, UpdateProductOptionsAdminQuery_graphql.Internal.convertVariables(param), {
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
  ReactRelay.fetchQuery(environment, UpdateProductOptionsAdminQuery_graphql.node, UpdateProductOptionsAdminQuery_graphql.Internal.convertVariables(variables), {
          networkCacheConfig: networkCacheConfig,
          fetchPolicy: RescriptRelay.mapFetchQueryFetchPolicy(fetchPolicy)
        }).subscribe({
        next: (function (res) {
            Curry._1(onResult, {
                  TAG: /* Ok */0,
                  _0: UpdateProductOptionsAdminQuery_graphql.Internal.convertResponse(res)
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
  var __x = ReactRelay.fetchQuery(environment, UpdateProductOptionsAdminQuery_graphql.node, UpdateProductOptionsAdminQuery_graphql.Internal.convertVariables(variables), {
          networkCacheConfig: networkCacheConfig,
          fetchPolicy: RescriptRelay.mapFetchQueryFetchPolicy(fetchPolicy)
        }).toPromise();
  return Js_promise.then_((function (res) {
                return Promise.resolve(UpdateProductOptionsAdminQuery_graphql.Internal.convertResponse(res));
              }), __x);
}

function usePreloaded(queryRef, param) {
  var data = ReactRelay.usePreloadedQuery(UpdateProductOptionsAdminQuery_graphql.node, queryRef);
  return RescriptRelay_Internal.internal_useConvertedValue(UpdateProductOptionsAdminQuery_graphql.Internal.convertResponse, data);
}

function retain(environment, variables) {
  var operationDescriptor = RelayRuntime.createOperationDescriptor(UpdateProductOptionsAdminQuery_graphql.node, UpdateProductOptionsAdminQuery_graphql.Internal.convertVariables(variables));
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
  var data = ReactRelay.useFragment(UpdateProductOptionsAdminFragment_graphql.node, fRef);
  return RescriptRelay_Internal.internal_useConvertedValue(UpdateProductOptionsAdminFragment_graphql.Internal.convertFragment, data);
}

function useOpt(opt_fRef) {
  var fr = opt_fRef !== undefined ? Caml_option.some(Caml_option.valFromOption(opt_fRef)) : undefined;
  var nullableFragmentData = ReactRelay.useFragment(UpdateProductOptionsAdminFragment_graphql.node, fr !== undefined ? Js_null_undefined.fromOption(Caml_option.some(Caml_option.valFromOption(fr))) : null);
  var data = (nullableFragmentData == null) ? undefined : Caml_option.some(nullableFragmentData);
  return RescriptRelay_Internal.internal_useConvertedValue((function (rawFragment) {
                if (rawFragment !== undefined) {
                  return UpdateProductOptionsAdminFragment_graphql.Internal.convertFragment(rawFragment);
                }
                
              }), data);
}

var Fragment_productOptionStatus_decode = UpdateProductOptionsAdminFragment_graphql.Utils.productOptionStatus_decode;

var Fragment_productOptionStatus_fromString = UpdateProductOptionsAdminFragment_graphql.Utils.productOptionStatus_fromString;

var Fragment = {
  productOptionStatus_decode: Fragment_productOptionStatus_decode,
  productOptionStatus_fromString: Fragment_productOptionStatus_fromString,
  Types: undefined,
  Operation: undefined,
  use: use$1,
  useOpt: useOpt
};

function use$2(fRef) {
  var data = ReactRelay.useFragment(UpdateProductOptionsAdminProductTypeFragment_graphql.node, fRef);
  return RescriptRelay_Internal.internal_useConvertedValue(UpdateProductOptionsAdminProductTypeFragment_graphql.Internal.convertFragment, data);
}

function useOpt$1(opt_fRef) {
  var fr = opt_fRef !== undefined ? Caml_option.some(Caml_option.valFromOption(opt_fRef)) : undefined;
  var nullableFragmentData = ReactRelay.useFragment(UpdateProductOptionsAdminProductTypeFragment_graphql.node, fr !== undefined ? Js_null_undefined.fromOption(Caml_option.some(Caml_option.valFromOption(fr))) : null);
  var data = (nullableFragmentData == null) ? undefined : Caml_option.some(nullableFragmentData);
  return RescriptRelay_Internal.internal_useConvertedValue((function (rawFragment) {
                if (rawFragment !== undefined) {
                  return UpdateProductOptionsAdminProductTypeFragment_graphql.Internal.convertFragment(rawFragment);
                }
                
              }), data);
}

var ProductTypeFragment = {
  Types: undefined,
  Operation: undefined,
  use: use$2,
  useOpt: useOpt$1
};

function commitMutation(environment, variables, optimisticUpdater, optimisticResponse, updater, onCompleted, onError, uploadables, param) {
  return RelayRuntime.commitMutation(environment, {
              mutation: UpdateProductOptionsAdminMutation_graphql.node,
              variables: UpdateProductOptionsAdminMutation_graphql.Internal.convertVariables(variables),
              onCompleted: (function (res, err) {
                  if (onCompleted !== undefined) {
                    return Curry._2(onCompleted, UpdateProductOptionsAdminMutation_graphql.Internal.convertResponse(res), (err == null) ? undefined : Caml_option.some(err));
                  }
                  
                }),
              onError: (function (err) {
                  if (onError !== undefined) {
                    return Curry._1(onError, (err == null) ? undefined : Caml_option.some(err));
                  }
                  
                }),
              optimisticResponse: optimisticResponse !== undefined ? UpdateProductOptionsAdminMutation_graphql.Internal.convertWrapRawResponse(optimisticResponse) : undefined,
              optimisticUpdater: optimisticUpdater,
              updater: updater !== undefined ? (function (store, r) {
                    Curry._2(updater, store, UpdateProductOptionsAdminMutation_graphql.Internal.convertResponse(r));
                  }) : undefined,
              uploadables: uploadables
            });
}

function use$3(param) {
  var match = ReactRelay.useMutation(UpdateProductOptionsAdminMutation_graphql.node);
  var mutate = match[0];
  return [
          React.useMemo((function () {
                  return function (param, param$1, param$2, param$3, param$4, param$5, param$6, param$7, param$8) {
                    return Curry._1(mutate, {
                                onError: param,
                                onCompleted: param$1 !== undefined ? (function (r, errors) {
                                      Curry._2(param$1, UpdateProductOptionsAdminMutation_graphql.Internal.convertResponse(r), (errors == null) ? undefined : Caml_option.some(errors));
                                    }) : undefined,
                                onUnsubscribe: param$2,
                                optimisticResponse: param$3 !== undefined ? UpdateProductOptionsAdminMutation_graphql.Internal.convertWrapRawResponse(param$3) : undefined,
                                optimisticUpdater: param$4,
                                updater: param$5 !== undefined ? (function (store, r) {
                                      Curry._2(param$5, store, UpdateProductOptionsAdminMutation_graphql.Internal.convertResponse(r));
                                    }) : undefined,
                                variables: UpdateProductOptionsAdminMutation_graphql.Internal.convertVariables(param$6),
                                uploadables: param$7
                              });
                  };
                }), [mutate]),
          match[1]
        ];
}

var Mutation_errorCode_decode = UpdateProductOptionsAdminMutation_graphql.Utils.errorCode_decode;

var Mutation_errorCode_fromString = UpdateProductOptionsAdminMutation_graphql.Utils.errorCode_fromString;

var Mutation_productOptionContractType_decode = UpdateProductOptionsAdminMutation_graphql.Utils.productOptionContractType_decode;

var Mutation_productOptionContractType_fromString = UpdateProductOptionsAdminMutation_graphql.Utils.productOptionContractType_fromString;

var Mutation_productOptionStatus_decode = UpdateProductOptionsAdminMutation_graphql.Utils.productOptionStatus_decode;

var Mutation_productOptionStatus_fromString = UpdateProductOptionsAdminMutation_graphql.Utils.productOptionStatus_fromString;

var Mutation_sizeUnit_decode = UpdateProductOptionsAdminMutation_graphql.Utils.sizeUnit_decode;

var Mutation_sizeUnit_fromString = UpdateProductOptionsAdminMutation_graphql.Utils.sizeUnit_fromString;

var Mutation_weightUnit_decode = UpdateProductOptionsAdminMutation_graphql.Utils.weightUnit_decode;

var Mutation_weightUnit_fromString = UpdateProductOptionsAdminMutation_graphql.Utils.weightUnit_fromString;

var Mutation = {
  errorCode_decode: Mutation_errorCode_decode,
  errorCode_fromString: Mutation_errorCode_fromString,
  productOptionContractType_decode: Mutation_productOptionContractType_decode,
  productOptionContractType_fromString: Mutation_productOptionContractType_fromString,
  productOptionStatus_decode: Mutation_productOptionStatus_decode,
  productOptionStatus_fromString: Mutation_productOptionStatus_fromString,
  sizeUnit_decode: Mutation_sizeUnit_decode,
  sizeUnit_fromString: Mutation_sizeUnit_fromString,
  weightUnit_decode: Mutation_weightUnit_decode,
  weightUnit_fromString: Mutation_weightUnit_fromString,
  Operation: undefined,
  Types: undefined,
  commitMutation: commitMutation,
  use: use$3
};

function submit_encode(v) {
  return Js_dict.fromArray([
              [
                "connection-id",
                Spice.stringToJson(v.connectionId)
              ],
              [
                "create",
                Spice.optionToJson((function (param) {
                        return Spice.arrayToJson(Add_ProductOption_Admin.Form.submit_encode, param);
                      }), v.create)
              ],
              [
                "edit",
                Spice.arrayToJson(Update_ProductOption_Admin.Form.submit_encode, v.edit)
              ]
            ]);
}

function submit_decode(v) {
  var dict = Js_json.classify(v);
  if (typeof dict === "number") {
    return Spice.error(undefined, "Not an object", v);
  }
  if (dict.TAG !== /* JSONObject */2) {
    return Spice.error(undefined, "Not an object", v);
  }
  var dict$1 = dict._0;
  var connectionId = Spice.stringFromJson(Belt_Option.getWithDefault(Js_dict.get(dict$1, "connection-id"), null));
  if (connectionId.TAG === /* Ok */0) {
    var create = Spice.optionFromJson((function (param) {
            return Spice.arrayFromJson(Add_ProductOption_Admin.Form.submit_decode, param);
          }), Belt_Option.getWithDefault(Js_dict.get(dict$1, "create"), null));
    if (create.TAG === /* Ok */0) {
      var edit = Spice.arrayFromJson(Update_ProductOption_Admin.Form.submit_decode, Belt_Option.getWithDefault(Js_dict.get(dict$1, "edit"), null));
      if (edit.TAG === /* Ok */0) {
        return {
                TAG: /* Ok */0,
                _0: {
                  connectionId: connectionId._0,
                  create: create._0,
                  edit: edit._0
                }
              };
      }
      var e = edit._0;
      return {
              TAG: /* Error */1,
              _0: {
                path: ".edit" + e.path,
                message: e.message,
                value: e.value
              }
            };
    }
    var e$1 = create._0;
    return {
            TAG: /* Error */1,
            _0: {
              path: ".create" + e$1.path,
              message: e$1.message,
              value: e$1.value
            }
          };
  }
  var e$2 = connectionId._0;
  return {
          TAG: /* Error */1,
          _0: {
            path: ".connection-id" + e$2.path,
            message: e$2.message,
            value: e$2.value
          }
        };
}

function productOption_encode(v) {
  return Js_dict.fromArray([[
                "product-options",
                submit_encode(v.productOption)
              ]]);
}

function productOption_decode(v) {
  var dict = Js_json.classify(v);
  if (typeof dict === "number") {
    return Spice.error(undefined, "Not an object", v);
  }
  if (dict.TAG !== /* JSONObject */2) {
    return Spice.error(undefined, "Not an object", v);
  }
  var productOption = submit_decode(Belt_Option.getWithDefault(Js_dict.get(dict._0, "product-options"), null));
  if (productOption.TAG === /* Ok */0) {
    return {
            TAG: /* Ok */0,
            _0: {
              productOption: productOption._0
            }
          };
  }
  var e = productOption._0;
  return {
          TAG: /* Error */1,
          _0: {
            path: ".product-options" + e.path,
            message: e.message,
            value: e.value
          }
        };
}

var Form = {
  submit_encode: submit_encode,
  submit_decode: submit_decode,
  productOption_encode: productOption_encode,
  productOption_decode: productOption_decode
};

function contractTypeEncode(str) {
  if (str === "온라인택배" || str !== "전량판매") {
    return "ONLINE";
  } else {
    return "BULKSALE";
  }
}

function statusEncode(str) {
  if (str === "SALE") {
    return "SALE";
  } else if (str === "SOLDOUT") {
    return "SOLDOUT";
  } else if (str === "HIDDEN_SALE") {
    return "HIDDEN_SALE";
  } else if (str === "NOSALE") {
    return "NOSALE";
  } else if (str === "RETIRE") {
    return "RETIRE";
  } else {
    return "SALE";
  }
}

function weightUnitEncode(weightUnit) {
  switch (weightUnit) {
    case /* G */0 :
        return "G";
    case /* KG */1 :
        return "KG";
    case /* T */2 :
        return "T";
    
  }
}

function sizeUnitEncode(sizeUnit) {
  switch (sizeUnit) {
    case /* MM */0 :
        return "MM";
    case /* CM */1 :
        return "CM";
    case /* M */2 :
        return "M";
    
  }
}

function noneToDefaultCutOffTime(cutOffTime) {
  return Belt_Option.mapWithDefault(cutOffTime, "10시 이전 발주 완료건에 한해 당일 출고(단, 산지 상황에 따라 출고 일정은 변경 될 수 있습니다.)", (function (str) {
                return str;
              }));
}

function nonEmptyString(str) {
  return str !== "";
}

function makeUpdateOption(option) {
  var name$p = option.name;
  var match = option.isFreeShipping;
  var match$1 = option.operationStatus;
  var tmp;
  switch (match$1) {
    case /* SALE */0 :
        tmp = "SALE";
        break;
    case /* SOLDOUT */1 :
        tmp = "SOLDOUT";
        break;
    case /* NOSALE */2 :
        tmp = "NOSALE";
        break;
    case /* RETIRE */3 :
        tmp = "RETIRE";
        break;
    case /* HIDDEN_SALE */4 :
        tmp = "HIDDEN_SALE";
        break;
    
  }
  return {
          cutOffTime: noneToDefaultCutOffTime(Belt_Option.keep(option.cutOffTime, nonEmptyString)),
          id: option.id,
          memo: Belt_Option.keep(option.memo, nonEmptyString),
          optionName: name$p !== undefined && name$p !== "" ? name$p : option.autoGenName,
          productOptionCost: {
            isFreeShipping: match ? true : false
          },
          status: tmp
        };
}

function makeCreateOption(productNodeId, option) {
  var name$p = Belt_Option.keep(option.name, (function (str) {
          return str !== "";
        }));
  var tmp;
  if (name$p !== undefined) {
    tmp = name$p;
  } else {
    var match = Belt_Option.getWithDefault(Belt_Option.map(option.each, (function (param) {
                return [
                        param.numMin,
                        param.numMax,
                        param.weightUnit,
                        param.sizeMin,
                        param.sizeMax,
                        param.sizeUnit
                      ];
              })), [
          undefined,
          undefined,
          undefined,
          undefined,
          undefined,
          undefined
        ]);
    tmp = Add_ProductOption_Admin.makeAutoGeneratedName(option.grade, option.package, String(option.weight), Select_Product_Option_Unit.Weight.toString(option.weightUnit), Belt_Option.map(match[0], (function (prim) {
                return String(prim);
              })), Belt_Option.map(match[1], (function (prim) {
                return String(prim);
              })), Belt_Option.map(match[2], Select_Product_Option_Unit.Weight.toString), Belt_Option.map(match[3], (function (prim) {
                return String(prim);
              })), Belt_Option.map(match[4], (function (prim) {
                return String(prim);
              })), Belt_Option.map(match[5], Select_Product_Option_Unit.Size.toString), true, undefined);
  }
  var match$1 = option.isFreeShipping;
  return {
          countPerPackageMax: Belt_Option.map(Belt_Option.keep(option.each, (function (param) {
                      return option.showEach;
                    })), (function (each) {
                  return each.numMax | 0;
                })),
          countPerPackageMin: Belt_Option.map(Belt_Option.keep(option.each, (function (param) {
                      return option.showEach;
                    })), (function (each) {
                  return each.numMin | 0;
                })),
          cutOffTime: noneToDefaultCutOffTime(Belt_Option.keep(option.cutOffTime, nonEmptyString)),
          grade: Belt_Option.keep(option.grade, nonEmptyString),
          memo: Belt_Option.keep(option.memo, nonEmptyString),
          optionName: tmp,
          packageType: Belt_Option.keep(option.package, nonEmptyString),
          perSizeMax: Belt_Option.map(Belt_Option.keep(option.each, (function (param) {
                      return option.showEach;
                    })), (function (each) {
                  return each.sizeMin;
                })),
          perSizeMin: Belt_Option.map(Belt_Option.keep(option.each, (function (param) {
                      return option.showEach;
                    })), (function (each) {
                  return each.sizeMax;
                })),
          perSizeUnit: Belt_Option.map(Belt_Option.keep(option.each, (function (param) {
                      return option.showEach;
                    })), (function (each) {
                  return sizeUnitEncode(each.sizeUnit);
                })),
          perWeightMax: Belt_Option.flatMap(Belt_Option.map(Belt_Option.keep(option.each, (function (param) {
                          return option.showEach;
                        })), (function (each) {
                      return Product_Option_Each_Admin.getPerWeight(option.weight, option.weightUnit, each.numMin, each.weightUnit);
                    })), Belt_Float.fromString),
          perWeightMin: Belt_Option.flatMap(Belt_Option.map(Belt_Option.keep(option.each, (function (param) {
                          return option.showEach;
                        })), (function (each) {
                      return Product_Option_Each_Admin.getPerWeight(option.weight, option.weightUnit, each.numMax, each.weightUnit);
                    })), Belt_Float.fromString),
          perWeightUnit: Belt_Option.map(Belt_Option.keep(option.each, (function (param) {
                      return option.showEach;
                    })), (function (each) {
                  return weightUnitEncode(each.weightUnit);
                })),
          price: option.cost.buyerPrice,
          productId: productNodeId,
          productOptionCost: {
            contractType: contractTypeEncode(option.cost.costType),
            deliveryCost: Belt_Option.getWithDefault(option.cost.deliveryCost, 0),
            isFreeShipping: match$1 ? true : false,
            rawCost: option.cost.rawCost,
            workingCost: option.cost.workingCost
          },
          status: statusEncode(option.operationStatus),
          weight: option.weight,
          weightUnit: weightUnitEncode(option.weightUnit)
        };
}

function Update_ProductOptions_Admin$Title(Props) {
  var productDisplayName = Props.productDisplayName;
  return React.createElement("header", {
              className: "flex flex-col items-baseline px-5 py-4 pb-0 gap-1"
            }, React.createElement("div", {
                  className: "flex items-center gap-1 text-text-L1 text-sm"
                }, React.createElement("span", {
                      className: "font-bold"
                    }, "상품 조회·수정"), React.createElement("img", {
                      src: inequalitySignRightIcon
                    }), React.createElement("span", undefined, "단품 수정")), React.createElement("h1", {
                  className: "text-text-L1 text-xl font-bold"
                }, "[" + productDisplayName + "] 상품의 단품 수정"));
}

var Title = {
  make: Update_ProductOptions_Admin$Title
};

function Update_ProductOptions_Admin$Bottom(Props) {
  var onReset = Props.onReset;
  return React.createElement("div", {
              className: "fixed bottom-0 w-[calc(100vw-300px)] bg-white h-16 flex items-center gap-2 justify-end pr-10"
            }, React.createElement("button", {
                  className: "px-3 py-2 bg-div-shape-L1 rounded-lg focus:outline-none",
                  onClick: onReset
                }, "초기화"), React.createElement("button", {
                  className: "px-3 py-2 bg-green-gl text-white rounded-lg hover:bg-green-gl-dark focus:outline-none",
                  type: "submit"
                }, "단품 수정"));
}

var Bottom = {
  make: Update_ProductOptions_Admin$Bottom
};

function Update_ProductOptions_Admin$Presenter(Props) {
  var query = Props.query;
  var queryData = use$1(query);
  var productType = use$2(query);
  var router = Router.useRouter();
  var productOptions = queryData.productOptions;
  var productNodeId = queryData.id;
  var productDisplayName = queryData.displayName;
  var match = ReactToastNotifications.useToasts();
  var addToast = match.addToast;
  var match$1 = React.useState(function () {
        return /* Hide */1;
      });
  var setShowUpdateSuccess = match$1[1];
  var match$2 = React.useState(function () {
        return /* Hide */1;
      });
  var setShowInitialize = match$2[1];
  var match$3 = use$3(undefined);
  var mutate = match$3[0];
  var methods = ReactHookForm$1.useForm({
        mode: "onChange"
      }, undefined);
  var trigger = methods.trigger;
  var reset = methods.reset;
  var onSubmit = function (data, param) {
    var err = productOption_decode(data);
    if (err.TAG === /* Ok */0) {
      var match = err._0.productOption;
      var createProductOptions = Belt_Option.map(match.create, (function (arr) {
              return Belt_Array.map(arr, (function (param) {
                            return makeCreateOption(productNodeId, param);
                          }));
            }));
      var updateProductOptions = Belt_Array.map(match.edit, makeUpdateOption);
      Curry.app(mutate, [
            (function (err) {
                console.log(err);
                addToast(React.createElement("span", {
                          className: "flex items-center"
                        }, React.createElement(IconError.make, {
                              width: "24",
                              height: "24",
                              className: "mr-2"
                            }), err.message), {
                      appearance: "error"
                    });
              }),
            (function (param, param$1) {
                setShowUpdateSuccess(function (param) {
                      return /* Show */0;
                    });
              }),
            undefined,
            undefined,
            undefined,
            undefined,
            {
              connections: [match.connectionId],
              input: {
                createProductOptions: createProductOptions,
                updateProductOptions: updateProductOptions
              }
            },
            undefined,
            undefined
          ]);
      return ;
    }
    var err$1 = err._0;
    console.log("decode error", err$1);
    addToast(React.createElement("span", {
              className: "flex items-center"
            }, React.createElement(IconError.make, {
                  width: "24",
                  height: "24",
                  className: "mr-2"
                }), err$1.message), {
          appearance: "error"
        });
  };
  var handleReset = function (param) {
    return ReactEvents.interceptingHandler((function (param) {
                  setShowInitialize(function (param) {
                        return /* Show */0;
                      });
                }), param);
  };
  if (productType.NAME === "UnselectedUnionMember") {
    return React.createElement("div", undefined, "지원하지 않은 상품 타입 입니다");
  } else if (productOptions !== undefined) {
    return React.createElement(ReactHookForm.Provider.make, {
                children: null,
                methods: methods
              }, React.createElement("form", {
                    onSubmit: methods.handleSubmit(onSubmit)
                  }, React.createElement("div", {
                        className: "max-w-gnb-panel overflow-auto bg-div-shape-L1 min-h-screen"
                      }, React.createElement(Update_ProductOptions_Admin$Title, {
                            productDisplayName: productDisplayName
                          }), React.createElement(Product_Summary_Admin.make, {
                            query: queryData.fragmentRefs
                          }), React.createElement("section", {
                            className: "p-7 mt-4 mx-4 mb-20 bg-white rounded shadow-gl"
                          }, React.createElement(Update_ProductOption_List_Admin.make, {
                                productDisplayName: productDisplayName,
                                isCourierAvailable: Belt_Option.getWithDefault(queryData.isCourierAvailable, false),
                                options: productOptions
                              }))), React.createElement(Update_ProductOptions_Admin$Bottom, {
                        onReset: handleReset
                      })), React.createElement(Dialog.make, {
                    isShow: match$2[0],
                    children: React.createElement("p", {
                          className: "text-gray-500 text-center whitespace-pre-wrap"
                        }, "단품 등록 페이지를", React.createElement("br", undefined), "초기화 하시겠습니까?"),
                    onCancel: (function (param) {
                        setShowInitialize(function (param) {
                              return /* Hide */1;
                            });
                      }),
                    onConfirm: (function (param) {
                        reset(undefined);
                        trigger("");
                        setShowInitialize(function (param) {
                              return /* Hide */1;
                            });
                      }),
                    textOnCancel: "닫기",
                    textOnConfirm: "초기화",
                    kindOfConfirm: /* Negative */1,
                    boxStyle: "text-center rounded-2xl"
                  }), React.createElement(Dialog.make, {
                    isShow: match$1[0],
                    children: React.createElement("p", {
                          className: "text-gray-500 text-center whitespace-pre-wrap"
                        }, "단품정보가 수정되었습니다."),
                    onCancel: (function (param) {
                        setShowUpdateSuccess(function (param) {
                              return /* Hide */1;
                            });
                        router.reload(router.pathname);
                      }),
                    textOnCancel: "확인",
                    boxStyle: "text-center rounded-2xl"
                  }));
  } else {
    return null;
  }
}

var Presenter = {
  make: Update_ProductOptions_Admin$Presenter
};

function Update_ProductOptions_Admin$Container(Props) {
  var productId = Props.productId;
  var queryData = use({
        id: productId
      }, /* StoreAndNetwork */2, undefined, undefined, undefined);
  var node$p = queryData.node;
  if (node$p !== undefined) {
    return React.createElement(Update_ProductOptions_Admin$Presenter, {
                query: node$p.fragmentRefs
              });
  } else {
    return React.createElement("div", undefined, "상품이 존재하지 않습니다");
  }
}

var Container = {
  make: Update_ProductOptions_Admin$Container
};

function Update_ProductOptions_Admin(Props) {
  var router = Router.useRouter();
  var id = Js_dict.get(router.query, "pid");
  return React.createElement(RescriptReactErrorBoundary.make, {
              children: React.createElement(Authorization.Admin.make, {
                    children: React.createElement(React.Suspense, {
                          children: id !== undefined ? React.createElement(Update_ProductOptions_Admin$Container, {
                                  productId: id
                                }) : React.createElement("div", undefined, "상품이 존재하지 않습니다."),
                          fallback: React.createElement("div", undefined, "로딩 중..")
                        }),
                    title: "관리자 단품 관리"
                  }),
              fallback: (function (param) {
                  return React.createElement("div", undefined, "에러 발생");
                })
            });
}

var make = Update_ProductOptions_Admin;

export {
  inequalitySignRightIcon ,
  Query ,
  Fragment ,
  ProductTypeFragment ,
  Mutation ,
  Form ,
  contractTypeEncode ,
  statusEncode ,
  weightUnitEncode ,
  sizeUnitEncode ,
  noneToDefaultCutOffTime ,
  nonEmptyString ,
  makeUpdateOption ,
  makeCreateOption ,
  Title ,
  Bottom ,
  Presenter ,
  Container ,
  make ,
}
/* inequalitySignRightIcon Not a pure module */
