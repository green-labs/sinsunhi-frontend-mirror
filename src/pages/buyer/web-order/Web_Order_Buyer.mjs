// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as Js_dict from "rescript/lib/es6/js_dict.js";
import * as Belt_Int from "rescript/lib/es6/belt_Int.js";
import * as IconError from "../../../components/svgs/IconError.mjs";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as ReactEvents from "../../../utils/ReactEvents.mjs";
import * as Router from "next/router";
import Script from "next/script";
import * as Authorization from "../../../utils/Authorization.mjs";
import * as ReactHookForm from "../../../bindings/ReactHookForm/ReactHookForm.mjs";
import * as RescriptRelay from "rescript-relay/src/RescriptRelay.mjs";
import * as RelayRuntime from "relay-runtime";
import * as ReactHookForm$1 from "react-hook-form";
import * as Hooks from "react-relay/hooks";
import * as Web_Order_Buyer_Form from "../../../components/Web_Order_Buyer_Form.mjs";
import * as Web_Order_Item_Buyer from "../../../components/Web_Order_Item_Buyer.mjs";
import * as ReactDialog from "@radix-ui/react-dialog";
import * as RescriptRelay_Internal from "rescript-relay/src/RescriptRelay_Internal.mjs";
import * as ReactToastNotifications from "react-toast-notifications";
import * as WebOrderBuyerQuery_graphql from "../../../__generated__/WebOrderBuyerQuery_graphql.mjs";
import * as WebOrderBuyerMutation_graphql from "../../../__generated__/WebOrderBuyerMutation_graphql.mjs";

function use(variables, fetchPolicy, fetchKey, networkCacheConfig, param) {
  var data = Hooks.useLazyLoadQuery(WebOrderBuyerQuery_graphql.node, RescriptRelay_Internal.internal_cleanObjectFromUndefinedRaw(WebOrderBuyerQuery_graphql.Internal.convertVariables(variables)), {
        fetchKey: fetchKey,
        fetchPolicy: RescriptRelay.mapFetchPolicy(fetchPolicy),
        networkCacheConfig: networkCacheConfig
      });
  return RescriptRelay_Internal.internal_useConvertedValue(WebOrderBuyerQuery_graphql.Internal.convertResponse, data);
}

function useLoader(param) {
  var match = Hooks.useQueryLoader(WebOrderBuyerQuery_graphql.node);
  var loadQueryFn = match[1];
  var loadQuery = React.useMemo((function () {
          return function (param, param$1, param$2, param$3) {
            return Curry._2(loadQueryFn, WebOrderBuyerQuery_graphql.Internal.convertVariables(param), {
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
  Hooks.fetchQuery(environment, WebOrderBuyerQuery_graphql.node, WebOrderBuyerQuery_graphql.Internal.convertVariables(variables), {
          networkCacheConfig: networkCacheConfig,
          fetchPolicy: RescriptRelay.mapFetchQueryFetchPolicy(fetchPolicy)
        }).subscribe({
        next: (function (res) {
            return Curry._1(onResult, {
                        TAG: /* Ok */0,
                        _0: WebOrderBuyerQuery_graphql.Internal.convertResponse(res)
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
  var __x = Hooks.fetchQuery(environment, WebOrderBuyerQuery_graphql.node, WebOrderBuyerQuery_graphql.Internal.convertVariables(variables), {
          networkCacheConfig: networkCacheConfig,
          fetchPolicy: RescriptRelay.mapFetchQueryFetchPolicy(fetchPolicy)
        }).toPromise();
  return __x.then(function (res) {
              return Promise.resolve(WebOrderBuyerQuery_graphql.Internal.convertResponse(res));
            });
}

function usePreloaded(queryRef, param) {
  var data = Hooks.usePreloadedQuery(WebOrderBuyerQuery_graphql.node, queryRef);
  return RescriptRelay_Internal.internal_useConvertedValue(WebOrderBuyerQuery_graphql.Internal.convertResponse, data);
}

function retain(environment, variables) {
  var operationDescriptor = RelayRuntime.createOperationDescriptor(WebOrderBuyerQuery_graphql.node, WebOrderBuyerQuery_graphql.Internal.convertVariables(variables));
  return environment.retain(operationDescriptor);
}

var Query_makeVariables = WebOrderBuyerQuery_graphql.Utils.makeVariables;

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

var make_wosProductOptionInput = WebOrderBuyerMutation_graphql.Utils.make_wosProductOptionInput;

function commitMutation(environment, variables, optimisticUpdater, optimisticResponse, updater, onCompleted, onError, uploadables, param) {
  return RelayRuntime.commitMutation(environment, {
              mutation: WebOrderBuyerMutation_graphql.node,
              variables: WebOrderBuyerMutation_graphql.Internal.convertVariables(variables),
              onCompleted: (function (res, err) {
                  if (onCompleted !== undefined) {
                    return Curry._2(onCompleted, WebOrderBuyerMutation_graphql.Internal.convertResponse(res), (err == null) ? undefined : Caml_option.some(err));
                  }
                  
                }),
              onError: (function (err) {
                  if (onError !== undefined) {
                    return Curry._1(onError, (err == null) ? undefined : Caml_option.some(err));
                  }
                  
                }),
              optimisticResponse: optimisticResponse !== undefined ? WebOrderBuyerMutation_graphql.Internal.convertWrapRawResponse(optimisticResponse) : undefined,
              optimisticUpdater: optimisticUpdater,
              updater: updater !== undefined ? (function (store, r) {
                    return Curry._2(updater, store, WebOrderBuyerMutation_graphql.Internal.convertResponse(r));
                  }) : undefined,
              uploadables: uploadables
            });
}

function use$1(param) {
  var match = Hooks.useMutation(WebOrderBuyerMutation_graphql.node);
  var mutate = match[0];
  return [
          React.useMemo((function () {
                  return function (param, param$1, param$2, param$3, param$4, param$5, param$6, param$7, param$8) {
                    return Curry._1(mutate, {
                                onError: param,
                                onCompleted: param$1 !== undefined ? (function (r, errors) {
                                      return Curry._2(param$1, WebOrderBuyerMutation_graphql.Internal.convertResponse(r), (errors == null) ? undefined : Caml_option.some(errors));
                                    }) : undefined,
                                onUnsubscribe: param$2,
                                optimisticResponse: param$3 !== undefined ? WebOrderBuyerMutation_graphql.Internal.convertWrapRawResponse(param$3) : undefined,
                                optimisticUpdater: param$4,
                                updater: param$5 !== undefined ? (function (store, r) {
                                      return Curry._2(param$5, store, WebOrderBuyerMutation_graphql.Internal.convertResponse(r));
                                    }) : undefined,
                                variables: WebOrderBuyerMutation_graphql.Internal.convertVariables(param$6),
                                uploadables: param$7
                              });
                  };
                }), [mutate]),
          match[1]
        ];
}

var Mutation_wosDeliveryType_decode = WebOrderBuyerMutation_graphql.Utils.wosDeliveryType_decode;

var Mutation_wosDeliveryType_fromString = WebOrderBuyerMutation_graphql.Utils.wosDeliveryType_fromString;

var Mutation_wosErrorCode_decode = WebOrderBuyerMutation_graphql.Utils.wosErrorCode_decode;

var Mutation_wosErrorCode_fromString = WebOrderBuyerMutation_graphql.Utils.wosErrorCode_fromString;

var Mutation_makeVariables = WebOrderBuyerMutation_graphql.Utils.makeVariables;

var Mutation = {
  wosDeliveryType_decode: Mutation_wosDeliveryType_decode,
  wosDeliveryType_fromString: Mutation_wosDeliveryType_fromString,
  wosErrorCode_decode: Mutation_wosErrorCode_decode,
  wosErrorCode_fromString: Mutation_wosErrorCode_fromString,
  make_wosProductOptionInput: make_wosProductOptionInput,
  makeVariables: Mutation_makeVariables,
  Types: undefined,
  commitMutation: commitMutation,
  use: use$1
};

function Web_Order_Buyer$Dialog(Props) {
  var show = Props.show;
  var confirmFn = Props.confirmFn;
  var cancel = Props.cancel;
  return React.createElement(ReactDialog.Root, {
              children: React.createElement(ReactDialog.Portal, {
                    children: null
                  }, React.createElement(ReactDialog.Overlay, {
                        className: "dialog-overlay"
                      }), React.createElement(ReactDialog.Content, {
                        children: null,
                        className: "dialog-content p-7 bg-white rounded-xl w-[480px] flex flex-col gap-7 items-center justify-center"
                      }, React.createElement("span", {
                            className: "whitespace-pre text-center text-text-L1 pt-3"
                          }, "??????????????? ?????? ???????????? ??????\n???????????????(?????????)??? ????????? ?????????.\n\n??????MD??? ???????????? ??????????????? ??????\n????????? ????????? ?????? ???????????????.\n\n??? ????????? ??????????????????\n????????? ?????? ?????? ????????? ????????? ?????????."), React.createElement("div", {
                            className: "flex w-full justify-center items-center gap-2"
                          }, React.createElement("button", {
                                className: "w-1/2 rounded-xl h-13 bg-enabled-L5",
                                onClick: cancel
                              }, "??????"), React.createElement("button", {
                                className: "w-1/2 rounded-xl h-13 bg-primary text-inverted font-bold",
                                onClick: (function (param) {
                                    return ReactEvents.interceptingHandler((function (param) {
                                                  return Curry._1(confirmFn, undefined);
                                                }), param);
                                  })
                              }, "??????")))),
              open: show
            });
}

var Dialog = {
  make: Web_Order_Buyer$Dialog
};

function makeProductOption(d) {
  return Curry.app(make_wosProductOptionInput, [
              d.deliveryCost,
              d.deliveryDesiredDate,
              d.deliveryMessage,
              d.deliveryType,
              d.grade,
              d.isTaxFree,
              d.ordererName,
              d.ordererPhone,
              d.price,
              d.productId,
              d.productName,
              d.productOptionName,
              d.quantity,
              Belt_Option.getWithDefault(d.receiverAddress, "") + Belt_Option.mapWithDefault(d.receiverDetailAddress, "", (function (str) {
                      return " " + str;
                    })),
              d.receiverName,
              d.receiverPhone,
              d.receiverZipCode,
              d.stockSku,
              undefined,
              undefined
            ]);
}

function paymentMethodToTossValue(c) {
  if (c === "CREDIT_CARD") {
    return "??????";
  } else if (c === "TRANSFER") {
    return "????????????";
  } else {
    return "????????????";
  }
}

function tossPaymentsValidHours(c) {
  if (c === "VIRTUAL_ACCOUNT") {
    return 24;
  }
  
}

function tossPaymentsCashReceipt(c) {
  if (c === "VIRTUAL_ACCOUNT") {
    return {
            type: "?????????"
          };
  }
  
}

function Web_Order_Buyer$Container(Props) {
  var productId = Props.productId;
  var productOptionId = Props.productOptionId;
  var quantity = Props.quantity;
  var queryData = use({
        productNodeId: productId,
        productOptionNodeId: productOptionId
      }, /* StoreAndNetwork */2, undefined, undefined, undefined);
  var match = use$1(undefined);
  var mutate = match[0];
  var match$1 = Web_Order_Item_Buyer.Mutation.use(undefined);
  var requestPaymentMutate = match$1[0];
  var match$2 = React.useState(function () {
        return false;
      });
  var setFreightDialogShow = match$2[1];
  var match$3 = React.useState(function () {
        return function (prim) {
          
        };
      });
  var setConfirmFn = match$3[1];
  var match$4 = ReactToastNotifications.useToasts();
  var addToast = match$4.addToast;
  var handleOnCancel = function (param) {
    return ReactEvents.interceptingHandler((function (param) {
                  setFreightDialogShow(function (param) {
                        return false;
                      });
                  return setConfirmFn(function (param) {
                              return function (prim) {
                                
                              };
                            });
                }), param);
  };
  var handleError = function (message, param) {
    setConfirmFn(function (param) {
          return function (prim) {
            
          };
        });
    return addToast(React.createElement("div", {
                    className: "flex items-center w-full whitespace-pre-wrap"
                  }, React.createElement(IconError.make, {
                        width: "24",
                        height: "24",
                        className: "mr-2"
                      }), "????????? ?????????????????????. " + Belt_Option.getWithDefault(message, "")), {
                appearance: "error"
              });
  };
  var match$5 = queryData.productNode;
  var methods = ReactHookForm$1.useForm({
        mode: "onSubmit",
        defaultValues: Js_dict.fromArray([[
                Web_Order_Buyer_Form.name,
                Js_dict.fromArray(match$5 !== undefined ? (
                        typeof match$5 === "object" ? (
                            match$5.NAME === "NormalProduct" ? [
                                [
                                  "payment-method",
                                  "card"
                                ],
                                [
                                  "product-options",
                                  [Web_Order_Buyer_Form.defaultValue(match$5.VAL.isCourierAvailable)]
                                ]
                              ] : [[
                                  "web-order",
                                  null
                                ]]
                          ) : [[
                              "web-order",
                              null
                            ]]
                      ) : [[
                          "web-order",
                          null
                        ]])
              ]])
      }, undefined);
  var onSubmit = function (data, param) {
    console.log(data);
    var msg = Web_Order_Buyer_Form.submit_decode(data);
    if (msg.TAG === /* Ok */0) {
      var data$p = msg._0.webOrder;
      var confirm = function (param) {
        setFreightDialogShow(function (param) {
              return false;
            });
        Curry.app(mutate, [
              (function (err) {
                  return handleError(err.message, undefined);
                }),
              (function (param, param$1) {
                  var createWosOrder = param.createWosOrder;
                  if (createWosOrder === undefined) {
                    return handleError("?????? ?????? ?????? ??????", undefined);
                  }
                  if (typeof createWosOrder !== "object") {
                    return handleError("?????? ?????? ??????", undefined);
                  }
                  var variant = createWosOrder.NAME;
                  if (variant === "WosError") {
                    var code = createWosOrder.VAL.code;
                    if (code === "INVALID_DELIVERY") {
                      return handleError("???????????? ?????? ?????? ???????????????.", undefined);
                    } else if (code === "INVALID_PAYMENT_PURPOSE") {
                      return handleError("???????????? ?????? ?????? ???????????????.", undefined);
                    } else if (code === "INVALID_ORDER") {
                      return handleError("???????????? ?????? ?????? ???????????????.", undefined);
                    } else if (code === "INVALID_PRODUCT") {
                      return handleError("???????????? ?????? ?????? ???????????????.", undefined);
                    } else {
                      return handleError(undefined, undefined);
                    }
                  }
                  if (variant !== "CreateWosOrderResult") {
                    if (variant === "Error") {
                      return handleError("?????? ?????? ??????", undefined);
                    } else {
                      return handleError("?????? ?????? ??????", undefined);
                    }
                  }
                  var match = createWosOrder.VAL;
                  var tempOrderId = match.tempOrderId;
                  var orderNo = match.orderNo;
                  var option = Belt_Array.get(data$p.productOptions, 0);
                  var match$1 = option !== undefined ? [
                      option.productName,
                      option.isTaxFree
                    ] : [
                      "",
                      false
                    ];
                  var isTaxFree = match$1[1];
                  var orderName = match$1[0];
                  Curry.app(requestPaymentMutate, [
                        (function (err) {
                            return handleError(err.message, undefined);
                          }),
                        (function (param, param$1) {
                            var requestPayment = param.requestPayment;
                            if (requestPayment === undefined) {
                              return handleError("?????? ????????? ?????????????????????.", undefined);
                            }
                            if (typeof requestPayment !== "object") {
                              return handleError("?????? ????????? ?????????????????????.", undefined);
                            }
                            var variant = requestPayment.NAME;
                            if (variant === "Error") {
                              return Belt_Option.forEach(requestPayment.VAL.message, (function (message) {
                                            return handleError(message, undefined);
                                          }));
                            }
                            if (variant !== "RequestPaymentTossPaymentsResult") {
                              return handleError("?????? ????????? ?????????????????????.", undefined);
                            }
                            var tossPaymentResult = requestPayment.VAL;
                            return window.tossPayments.requestPayment(paymentMethodToTossValue(data$p.paymentMethod), {
                                        amount: data$p.totalOrderPrice,
                                        orderId: orderNo,
                                        orderName: orderName,
                                        customerName: tossPaymentResult.customerName,
                                        successUrl: window.location.origin + "/buyer/toss-payments/success?product-id=" + productId + "&product-option-id=" + productOptionId + "&quantity=" + String(quantity) + "&payment-id=" + String(tossPaymentResult.paymentId) + "&temp-order-id=" + String(tempOrderId),
                                        failUrl: window.location.origin + "/buyer/toss-payments/fail?product-id=" + productId + "&product-option-id=" + productOptionId + "&quantity=" + String(quantity),
                                        taxFreeAmount: isTaxFree ? data$p.totalOrderPrice : 0,
                                        validHours: tossPaymentsValidHours(data$p.paymentMethod),
                                        cashReceipt: tossPaymentsCashReceipt(data$p.paymentMethod)
                                      });
                          }),
                        undefined,
                        undefined,
                        undefined,
                        undefined,
                        {
                          paymentMethod: data$p.paymentMethod,
                          amount: data$p.totalOrderPrice,
                          purpose: "ORDER"
                        },
                        undefined,
                        undefined
                      ]);
                  
                }),
              undefined,
              undefined,
              undefined,
              undefined,
              {
                orderUserId: data$p.orderUserId,
                paymentPurpose: data$p.paymentPurpose,
                productOptions: Belt_Array.map(data$p.productOptions, makeProductOption),
                totalDeliveryCost: data$p.totalDeliveryCost,
                totalOrderPrice: data$p.totalOrderPrice
              },
              undefined,
              undefined
            ]);
        
      };
      var match = Belt_Array.get(data$p.productOptions, 0);
      if (match !== undefined) {
        if (match.deliveryType === "FREIGHT") {
          setConfirmFn(function (param) {
                return confirm;
              });
          return setFreightDialogShow(function (param) {
                      return true;
                    });
        } else {
          return confirm(undefined);
        }
      } else {
        return ;
      }
    }
    var msg$1 = msg._0;
    console.log(msg$1);
    return handleError(msg$1.message, undefined);
  };
  return React.createElement(React.Fragment, undefined, React.createElement(Web_Order_Buyer$Dialog, {
                  show: match$2[0],
                  confirmFn: match$3[0],
                  cancel: handleOnCancel
                }), React.createElement(ReactHookForm.Provider.make, {
                  children: React.createElement("form", {
                        onSubmit: methods.handleSubmit(onSubmit)
                      }, React.createElement(Web_Order_Item_Buyer.make, {
                            query: queryData.fragmentRefs,
                            quantity: quantity
                          })),
                  methods: methods
                }));
}

var Container = {
  make: Web_Order_Buyer$Container
};

function Web_Order_Buyer(Props) {
  var router = Router.useRouter();
  var productId = Js_dict.get(router.query, "pid");
  var productOptionId = Js_dict.get(router.query, "oid");
  var quantity = Belt_Option.flatMap(Js_dict.get(router.query, "quantity"), Belt_Int.fromString);
  var tmp;
  var exit = 0;
  if (productId !== undefined && productOptionId !== undefined && quantity !== undefined) {
    tmp = React.createElement(Web_Order_Buyer$Container, {
          productId: productId,
          productOptionId: productOptionId,
          quantity: quantity
        });
  } else {
    exit = 1;
  }
  if (exit === 1) {
    tmp = React.createElement(Web_Order_Item_Buyer.PlaceHolder.make, {});
  }
  return React.createElement(Authorization.Buyer.make, {
              children: null,
              title: "????????????",
              fallback: React.createElement(Web_Order_Item_Buyer.PlaceHolder.make, {})
            }, React.createElement(Script, {
                  src: "//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"
                }), React.createElement(React.Suspense, {
                  children: tmp,
                  fallback: React.createElement(Web_Order_Item_Buyer.PlaceHolder.make, {})
                }));
}

var Form;

var PlaceHolder;

var make = Web_Order_Buyer;

export {
  Query ,
  Mutation ,
  Dialog ,
  Form ,
  PlaceHolder ,
  makeProductOption ,
  paymentMethodToTossValue ,
  tossPaymentsValidHours ,
  tossPaymentsCashReceipt ,
  Container ,
  make ,
  
}
/* react Not a pure module */
