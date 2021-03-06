// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as Locale from "../../../../utils/Locale.mjs";
import * as Js_dict from "rescript/lib/es6/js_dict.js";
import * as Spinbox from "../../../../components/common/Spinbox.mjs";
import * as IconArrow from "../../../../components/svgs/IconArrow.mjs";
import Link from "next/link";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as ReactEvents from "../../../../utils/ReactEvents.mjs";
import * as Router from "next/router";
import * as RescriptRelay from "rescript-relay/src/RescriptRelay.mjs";
import * as RelayRuntime from "relay-runtime";
import * as PDP_Parser_Buyer from "../../../../utils/PDP_Parser_Buyer.mjs";
import * as Hooks from "react-relay/hooks";
import * as ReactTabs from "@radix-ui/react-tabs";
import * as RescriptRelay_Internal from "rescript-relay/src/RescriptRelay_Internal.mjs";
import * as PDPNormalOrderSpecificationBuyerQuery_graphql from "../../../../__generated__/PDPNormalOrderSpecificationBuyerQuery_graphql.mjs";

var makeVariables = PDPNormalOrderSpecificationBuyerQuery_graphql.Utils.makeVariables;

function use(variables, fetchPolicy, fetchKey, networkCacheConfig, param) {
  var data = Hooks.useLazyLoadQuery(PDPNormalOrderSpecificationBuyerQuery_graphql.node, RescriptRelay_Internal.internal_cleanObjectFromUndefinedRaw(PDPNormalOrderSpecificationBuyerQuery_graphql.Internal.convertVariables(variables)), {
        fetchKey: fetchKey,
        fetchPolicy: RescriptRelay.mapFetchPolicy(fetchPolicy),
        networkCacheConfig: networkCacheConfig
      });
  return RescriptRelay_Internal.internal_useConvertedValue(PDPNormalOrderSpecificationBuyerQuery_graphql.Internal.convertResponse, data);
}

function useLoader(param) {
  var match = Hooks.useQueryLoader(PDPNormalOrderSpecificationBuyerQuery_graphql.node);
  var loadQueryFn = match[1];
  var loadQuery = React.useMemo((function () {
          return function (param, param$1, param$2, param$3) {
            return Curry._2(loadQueryFn, PDPNormalOrderSpecificationBuyerQuery_graphql.Internal.convertVariables(param), {
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
  Hooks.fetchQuery(environment, PDPNormalOrderSpecificationBuyerQuery_graphql.node, PDPNormalOrderSpecificationBuyerQuery_graphql.Internal.convertVariables(variables), {
          networkCacheConfig: networkCacheConfig,
          fetchPolicy: RescriptRelay.mapFetchQueryFetchPolicy(fetchPolicy)
        }).subscribe({
        next: (function (res) {
            return Curry._1(onResult, {
                        TAG: /* Ok */0,
                        _0: PDPNormalOrderSpecificationBuyerQuery_graphql.Internal.convertResponse(res)
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
  var __x = Hooks.fetchQuery(environment, PDPNormalOrderSpecificationBuyerQuery_graphql.node, PDPNormalOrderSpecificationBuyerQuery_graphql.Internal.convertVariables(variables), {
          networkCacheConfig: networkCacheConfig,
          fetchPolicy: RescriptRelay.mapFetchQueryFetchPolicy(fetchPolicy)
        }).toPromise();
  return __x.then(function (res) {
              return Promise.resolve(PDPNormalOrderSpecificationBuyerQuery_graphql.Internal.convertResponse(res));
            });
}

function usePreloaded(queryRef, param) {
  var data = Hooks.usePreloadedQuery(PDPNormalOrderSpecificationBuyerQuery_graphql.node, queryRef);
  return RescriptRelay_Internal.internal_useConvertedValue(PDPNormalOrderSpecificationBuyerQuery_graphql.Internal.convertResponse, data);
}

function retain(environment, variables) {
  var operationDescriptor = RelayRuntime.createOperationDescriptor(PDPNormalOrderSpecificationBuyerQuery_graphql.node, PDPNormalOrderSpecificationBuyerQuery_graphql.Internal.convertVariables(variables));
  return environment.retain(operationDescriptor);
}

var Query = {
  makeVariables: makeVariables,
  Types: undefined,
  use: use,
  useLoader: useLoader,
  $$fetch: $$fetch,
  fetchPromised: fetchPromised,
  usePreloaded: usePreloaded,
  retain: retain
};

function PDP_Normal_OrderSpecification_Buyer$Placeholder(Props) {
  return React.createElement("div", {
              className: "w-full h-[497px]"
            });
}

var Placeholder = {
  make: PDP_Normal_OrderSpecification_Buyer$Placeholder
};

function PDP_Normal_OrderSpecification_Buyer$Tab(Props) {
  var label = Props.label;
  var value = Props.value;
  var isSelected = Props.isSelected;
  var btnStyle = isSelected ? "bg-green-50 text-green-500 border-green-500" : "text-gray-800 border-gray-250";
  return React.createElement(ReactTabs.Trigger, {
              children: React.createElement("span", undefined, label),
              value: value,
              className: "flex flex-1 items-center justify-center border " + btnStyle
            });
}

var Tab = {
  make: PDP_Normal_OrderSpecification_Buyer$Tab
};

function PDP_Normal_OrderSpecification_Buyer(Props) {
  var selectedSkuId = Props.selectedSkuId;
  var quantity = Props.quantity;
  var setQuantity = Props.setQuantity;
  var router = Router.useRouter();
  var match = use(Curry._1(makeVariables, selectedSkuId), /* StoreOrNetwork */1, undefined, undefined, undefined);
  var node = match.node;
  var match$1 = React.useState(function () {
        return "dropShipping";
      });
  var setSelectedMethod = match$1[1];
  var selectedMethod = match$1[0];
  var tmp;
  if (node !== undefined) {
    var match$2 = node.productOptionCost;
    var isFreeShipping = match$2.isFreeShipping;
    var deliveryCost = match$2.deliveryCost;
    var match$3 = node.product;
    var productNodeId = match$3.id;
    var productOptionNodeId = node.id;
    var productNoLabel = String(match$3.productId);
    var optionPrice = PDP_Parser_Buyer.ProductOption.makeOptionPrice(node.price, deliveryCost, isFreeShipping);
    var priceLabel = Belt_Option.mapWithDefault(optionPrice, "", (function (optionPrice$p) {
            return Locale.Float.show(undefined, Math.imul(optionPrice$p, quantity), 0) + "???";
          }));
    var optionDeliveryCost = PDP_Parser_Buyer.ProductOption.makeOptionDeliveryCost(deliveryCost, isFreeShipping);
    var totalDeliveryCost = Math.imul(optionDeliveryCost, quantity);
    var deliveryCostLabel = totalDeliveryCost !== 0 ? Locale.Float.show(undefined, totalDeliveryCost, 0) + "???" : "??????";
    var quantityLabel = String(quantity);
    tmp = React.createElement(React.Fragment, undefined, React.createElement("div", {
              className: "my-4 w-full flex items-center justify-between"
            }, React.createElement("span", {
                  className: "w-full text-lg"
                }, node.optionName), React.createElement(Spinbox.make, {
                  value: quantity,
                  setValue: setQuantity
                })), React.createElement(ReactTabs.Content, {
              children: null,
              value: "dropShipping"
            }, React.createElement("div", {
                  className: "w-full h-[273px]"
                }, React.createElement("section", {
                      className: "w-full bg-gray-50 p-4 text-text-L1 flex flex-col"
                    }, React.createElement("span", {
                          className: "font-bold"
                        }, "???????????? : " + productNoLabel), React.createElement("span", {
                          className: "mt-2"
                        }, "???????????? : " + node.stockSku), React.createElement("span", {
                          className: "mt-2"
                        }, "?????? : " + quantityLabel), React.createElement("span", {
                          className: "mt-2"
                        }, "????????? : " + priceLabel), React.createElement("span", {
                          className: "mt-2"
                        }, "????????? : " + deliveryCostLabel)), React.createElement("section", {
                      className: "mt-2 flex flex-col"
                    }, React.createElement("span", {
                          className: "text-sm text-gray-600"
                        }, "?????? ????????? ????????? ???????????? ??????????????? ??????????????????."), React.createElement(Link, {
                          href: "https://drive.google.com/file/d/1hz3Y2U9JlGR4fgiqNdrNFEdKAiL74BOw/view",
                          children: React.createElement("a", {
                                className: "flex items-center mt-4",
                                rel: "noopener noreferer",
                                target: "_blank"
                              }, React.createElement("span", {
                                    className: "text-primary text-[17px] font-bold mr-1"
                                  }, "?????? ?????? ?????? ?????? ??????"), React.createElement(IconArrow.make, {
                                    height: "20",
                                    width: "20",
                                    stroke: "#12B564"
                                  }))
                        }))), React.createElement("section", {
                  className: "w-full py-5"
                }, React.createElement("button", {
                      className: "w-full h-16 bg-primary text-white font-bold flex items-center justify-center rounded-xl",
                      onClick: (function (param) {
                          return ReactEvents.interceptingHandler((function (param) {
                                        router.push("/buyer/upload");
                                        
                                      }), param);
                        })
                    }, "????????? ???????????????"))), React.createElement(ReactTabs.Content, {
              children: null,
              value: "deliverying"
            }, React.createElement("div", {
                  className: "w-full h-[273px]"
                }, React.createElement("section", {
                      className: "w-full bg-gray-50 p-4 text-text-L1 flex flex-col"
                    }, React.createElement("span", undefined, "?????? : " + quantityLabel), React.createElement("span", {
                          className: "mt-2"
                        }, "????????? : " + priceLabel), React.createElement("span", {
                          className: "mt-2"
                        }, "????????? : ???????????? ?????? ??? ?????? ??????"))), React.createElement("section", {
                  className: "w-full py-5"
                }, React.createElement("button", {
                      className: "w-full h-16 bg-primary text-white font-bold flex items-center justify-center rounded-xl",
                      onClick: (function (param) {
                          return ReactEvents.interceptingHandler((function (param) {
                                        var prim1_pathname = "/buyer/web-order/" + productNodeId + "/" + productOptionNodeId;
                                        var prim1_query = Js_dict.fromArray([[
                                                "quantity",
                                                String(quantity)
                                              ]]);
                                        var prim1 = {
                                          pathname: prim1_pathname,
                                          query: prim1_query
                                        };
                                        router.push(prim1);
                                        
                                      }), param);
                        })
                    }, "?????? ????????????"))));
  } else {
    tmp = null;
  }
  return React.createElement(ReactTabs.Root, {
              children: null,
              defaultValue: "dropShipping",
              onValueChange: (function (selected) {
                  return setSelectedMethod(function (param) {
                              return selected;
                            });
                })
            }, React.createElement(ReactTabs.List, {
                  children: null,
                  className: "w-full h-12 flex"
                }, React.createElement(PDP_Normal_OrderSpecification_Buyer$Tab, {
                      label: "2??? ?????? ?????????",
                      value: "dropShipping",
                      isSelected: selectedMethod === "dropShipping"
                    }), React.createElement(PDP_Normal_OrderSpecification_Buyer$Tab, {
                      label: "1??? ?????????",
                      value: "deliverying",
                      isSelected: selectedMethod === "deliverying"
                    })), tmp);
}

var make = PDP_Normal_OrderSpecification_Buyer;

export {
  Query ,
  Placeholder ,
  Tab ,
  make ,
  
}
/* react Not a pure module */
