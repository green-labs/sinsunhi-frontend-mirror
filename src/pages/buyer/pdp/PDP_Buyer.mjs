// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as Js_dict from "rescript/lib/es6/js_dict.js";
import Head from "next/head";
import * as Js_promise from "rescript/lib/es6/js_promise.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as Router from "next/router";
import * as ReactRelay from "react-relay";
import * as Footer_Buyer from "../../../components/Footer_Buyer.mjs";
import * as Header_Buyer from "../../../components/Header_Buyer.mjs";
import * as PDP_Gtm_Buyer from "./PDP_Gtm_Buyer.mjs";
import * as RescriptRelay from "rescript-relay/src/RescriptRelay.mjs";
import * as RelayRuntime from "relay-runtime";
import * as Product_Parser from "../../../utils/Product_Parser.mjs";
import * as PDP_Normal_Buyer from "./normal/PDP_Normal_Buyer.mjs";
import * as PDP_Quoted_Buyer from "./quoted/PDP_Quoted_Buyer.mjs";
import * as ChannelTalkHelper from "../../../utils/ChannelTalkHelper.mjs";
import * as Js_null_undefined from "rescript/lib/es6/js_null_undefined.js";
import * as PDP_Matching_Buyer from "./matching/PDP_Matching_Buyer.mjs";
import * as PDPBuyerQuery_graphql from "../../../__generated__/PDPBuyerQuery_graphql.mjs";
import * as RescriptRelay_Internal from "rescript-relay/src/RescriptRelay_Internal.mjs";
import * as PDPBuyerFragment_graphql from "../../../__generated__/PDPBuyerFragment_graphql.mjs";
import * as ReactSeparator from "@radix-ui/react-separator";
import * as RescriptReactErrorBoundary from "@rescript/react/src/RescriptReactErrorBoundary.mjs";

function use(variables, fetchPolicy, fetchKey, networkCacheConfig, param) {
  var data = ReactRelay.useLazyLoadQuery(PDPBuyerQuery_graphql.node, RescriptRelay_Internal.internal_cleanObjectFromUndefinedRaw(PDPBuyerQuery_graphql.Internal.convertVariables(variables)), {
        fetchKey: fetchKey,
        fetchPolicy: RescriptRelay.mapFetchPolicy(fetchPolicy),
        networkCacheConfig: networkCacheConfig
      });
  return RescriptRelay_Internal.internal_useConvertedValue(PDPBuyerQuery_graphql.Internal.convertResponse, data);
}

function useLoader(param) {
  var match = ReactRelay.useQueryLoader(PDPBuyerQuery_graphql.node);
  var loadQueryFn = match[1];
  var loadQuery = React.useMemo((function () {
          return function (param, param$1, param$2, param$3) {
            return Curry._2(loadQueryFn, PDPBuyerQuery_graphql.Internal.convertVariables(param), {
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
  ReactRelay.fetchQuery(environment, PDPBuyerQuery_graphql.node, PDPBuyerQuery_graphql.Internal.convertVariables(variables), {
          networkCacheConfig: networkCacheConfig,
          fetchPolicy: RescriptRelay.mapFetchQueryFetchPolicy(fetchPolicy)
        }).subscribe({
        next: (function (res) {
            Curry._1(onResult, {
                  TAG: /* Ok */0,
                  _0: PDPBuyerQuery_graphql.Internal.convertResponse(res)
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
  var __x = ReactRelay.fetchQuery(environment, PDPBuyerQuery_graphql.node, PDPBuyerQuery_graphql.Internal.convertVariables(variables), {
          networkCacheConfig: networkCacheConfig,
          fetchPolicy: RescriptRelay.mapFetchQueryFetchPolicy(fetchPolicy)
        }).toPromise();
  return Js_promise.then_((function (res) {
                return Promise.resolve(PDPBuyerQuery_graphql.Internal.convertResponse(res));
              }), __x);
}

function usePreloaded(queryRef, param) {
  var data = ReactRelay.usePreloadedQuery(PDPBuyerQuery_graphql.node, queryRef);
  return RescriptRelay_Internal.internal_useConvertedValue(PDPBuyerQuery_graphql.Internal.convertResponse, data);
}

function retain(environment, variables) {
  var operationDescriptor = RelayRuntime.createOperationDescriptor(PDPBuyerQuery_graphql.node, PDPBuyerQuery_graphql.Internal.convertVariables(variables));
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
  var data = ReactRelay.useFragment(PDPBuyerFragment_graphql.node, fRef);
  return RescriptRelay_Internal.internal_useConvertedValue(PDPBuyerFragment_graphql.Internal.convertFragment, data);
}

function useOpt(opt_fRef) {
  var fr = opt_fRef !== undefined ? Caml_option.some(Caml_option.valFromOption(opt_fRef)) : undefined;
  var nullableFragmentData = ReactRelay.useFragment(PDPBuyerFragment_graphql.node, fr !== undefined ? Js_null_undefined.fromOption(Caml_option.some(Caml_option.valFromOption(fr))) : null);
  var data = (nullableFragmentData == null) ? undefined : Caml_option.some(nullableFragmentData);
  return RescriptRelay_Internal.internal_useConvertedValue((function (rawFragment) {
                if (rawFragment !== undefined) {
                  return PDPBuyerFragment_graphql.Internal.convertFragment(rawFragment);
                }
                
              }), data);
}

var Fragment = {
  Types: undefined,
  Operation: undefined,
  use: use$1,
  useOpt: useOpt
};

function PDP_Buyer$Placeholder(Props) {
  var deviceType = Props.deviceType;
  var router = Router.useRouter();
  switch (deviceType) {
    case /* Unknown */0 :
        return null;
    case /* PC */1 :
        return React.createElement("div", {
                    className: "w-full min-w-[1280px] min-h-screen"
                  }, React.createElement(Header_Buyer.PC.make, {
                        key: router.asPath
                      }), React.createElement("div", {
                        className: "w-[1280px] mx-auto min-h-full"
                      }, React.createElement("div", {
                            className: "w-full pt-16 px-5"
                          }, React.createElement("section", {
                                className: "w-full flex justify-between"
                              }, React.createElement("div", undefined, React.createElement("div", {
                                        className: "w-[664px] aspect-square rounded-xl bg-gray-150 animate-pulse"
                                      }), React.createElement("div", {
                                        className: "mt-12 w-[664px] h-[92px] rounded-xl bg-gray-150 animate-pulse"
                                      }), React.createElement("div", {
                                        className: "mt-4 w-[563px] h-[23px] rounded-lg bg-gray-150 animate-pulse"
                                      })), React.createElement("div", undefined, React.createElement("div", {
                                        className: "w-[496px] h-[44px] rounded-lg bg-gray-150 animate-pulse"
                                      }), React.createElement("div", {
                                        className: "mt-4 w-[123px] h-[44px] rounded-lg bg-gray-150 animate-pulse"
                                      }), React.createElement("div", {
                                        className: "mt-4 w-[496px] h-[56px] rounded-xl bg-gray-150 animate-pulse"
                                      }), React.createElement("div", {
                                        className: "mt-4 w-[496px] rounded-xl border border-gray-200 px-6 py-8"
                                      }, React.createElement("div", {
                                            className: "w-[80px] h-[26px] rounded-md bg-gray-150 animate-pulse"
                                          }), React.createElement("div", {
                                            className: "mt-5 flex items-center justify-between"
                                          }, React.createElement("div", {
                                                className: "w-[88px] h-[24px] rounded-md bg-gray-150 animate-pulse"
                                              }), React.createElement("div", {
                                                className: "w-[68px] h-[24px] rounded-md bg-gray-150 animate-pulse"
                                              })), React.createElement("div", {
                                            className: "mt-1 flex items-center justify-between"
                                          }, React.createElement("div", {
                                                className: "w-[56px] h-[24px] rounded-md bg-gray-150 animate-pulse"
                                              }), React.createElement("div", {
                                                className: "w-[48px] h-[24px] rounded-md bg-gray-150 animate-pulse"
                                              })), React.createElement("div", {
                                            className: "mt-1 flex items-center justify-between"
                                          }, React.createElement("div", {
                                                className: "w-[72px] h-[24px] rounded-md bg-gray-150 animate-pulse"
                                              }), React.createElement("div", {
                                                className: "w-[56px] h-[24px] rounded-md bg-gray-150 animate-pulse"
                                              })), React.createElement("div", {
                                            className: "mt-1 flex items-center justify-between"
                                          }, React.createElement("div", {
                                                className: "w-[64px] h-[24px] rounded-md bg-gray-150 animate-pulse"
                                              }), React.createElement("div", {
                                                className: "w-[48px] h-[24px] rounded-md bg-gray-150 animate-pulse"
                                              })), React.createElement(ReactSeparator.Root, {
                                            className: "h-px bg-gray-100 my-4"
                                          }), React.createElement("div", {
                                            className: "mt-6 w-[40px] h-[24px] rounded-md bg-gray-150 animate-pulse"
                                          }), React.createElement("div", {
                                            className: "mt-4 w-[440px] h-[80px] rounded-md bg-gray-150 animate-pulse"
                                          }), React.createElement("div", {
                                            className: "mt-6 w-[40px] h-[24px] rounded-md bg-gray-150 animate-pulse"
                                          }), React.createElement("div", {
                                            className: "mt-4 w-[440px] h-[80px] rounded-md bg-gray-150 animate-pulse"
                                          }), React.createElement("div", {
                                            className: "mt-12 flex items-center justify-between"
                                          }, React.createElement("div", {
                                                className: "w-[86px] h-[26px] rounded-md bg-gray-150 animate-pulse"
                                              }), React.createElement("div", {
                                                className: "w-[117px] h-[38px] rounded-md bg-gray-150 animate-pulse"
                                              }))))), React.createElement(ReactSeparator.Root, {
                                className: "h-px bg-gray-100 my-12"
                              }), React.createElement("section", undefined, React.createElement("div", {
                                    className: "mt-4 w-[144px] h-[38px] rounded-md bg-gray-150 animate-pulse"
                                  }), React.createElement("div", {
                                    className: "mt-14 w-[1240px] h-[176px] rounded-lg bg-gray-150 animate-pulse"
                                  }), React.createElement("div", {
                                    className: "mt-14 flex flex-col items-center justify-center"
                                  }, React.createElement("div", {
                                        className: "w-[640px] h-[44px] rounded-md bg-gray-150 animate-pulse"
                                      }), React.createElement("div", {
                                        className: "mt-[10px] w-[440px] h-[24px] rounded-md bg-gray-150 animate-pulse"
                                      })), React.createElement("div", {
                                    className: "mt-14 w-[1240px] h-[640px] rounded-lg bg-gray-150 animate-pulse"
                                  })))), React.createElement(Footer_Buyer.PC.make, {}));
    case /* Mobile */2 :
        return React.createElement("div", {
                    className: "w-full min-h-screen"
                  }, React.createElement("div", {
                        className: "w-full bg-white"
                      }, React.createElement("div", {
                            className: "w-full max-w-3xl mx-auto bg-white min-h-screen"
                          }, React.createElement(Header_Buyer.Mobile.make, {
                                key: router.asPath
                              }), React.createElement("div", {
                                className: "w-full"
                              }, React.createElement("div", {
                                    className: "w-full aspect-square bg-gray-150 animate-pulse"
                                  }), React.createElement("section", {
                                    className: "px-5 flex flex-col gap-2"
                                  }, React.createElement("div", {
                                        className: "w-full mt-5 bg-gray-150 rounded-lg animate-pulse"
                                      }), React.createElement("div", {
                                        className: "w-20 h-6 bg-gray-150 rounded-lg animate-pulse"
                                      }), React.createElement("div", {
                                        className: "w-full bg-gray-150 rounded-lg animate-pulse"
                                      }), React.createElement("div", {
                                        className: "w-full bg-gray-150 rounded-lg animate-pulse"
                                      }), React.createElement("div", {
                                        className: "w-full h-[100px] bg-gray-150 rounded-lg animate-pulse"
                                      }))), React.createElement(Footer_Buyer.MO.make, {}))));
    
  }
}

var Placeholder = {
  make: PDP_Buyer$Placeholder
};

function PDP_Buyer$NotFound(Props) {
  var deviceType = Props.deviceType;
  var router = Router.useRouter();
  switch (deviceType) {
    case /* Unknown */0 :
        return null;
    case /* PC */1 :
        return React.createElement("div", {
                    className: "w-full min-w-[1280px] min-h-screen"
                  }, React.createElement(Header_Buyer.PC.make, {
                        key: router.asPath
                      }), React.createElement("div", {
                        className: "w-[1280px] px-5 py-16 mx-auto"
                      }, React.createElement("div", {
                            className: "mt-14"
                          }, React.createElement("div", {
                                className: "w-full flex items-center justify-center"
                              }, React.createElement("span", {
                                    className: "text-3xl text-gray-800"
                                  }, "상품이 존재하지 않습니다")), React.createElement("div", {
                                className: "mt-7 w-full flex flex-col items-center justify-center"
                              }, React.createElement("span", {
                                    className: "text-gray-800"
                                  }, "상품 URL이 정확한지 확인해주세요."), React.createElement("span", {
                                    className: "text-gray-800"
                                  }, "상품이 없을 경우 다른 카테고리의 상품을 선택해주세요.")))), React.createElement(Footer_Buyer.PC.make, {}));
    case /* Mobile */2 :
        return React.createElement("div", {
                    className: "w-full min-h-screen"
                  }, React.createElement("div", {
                        className: "w-full bg-white"
                      }, React.createElement("div", {
                            className: "w-full max-w-3xl mx-auto bg-white min-h-screen"
                          }, React.createElement(Header_Buyer.Mobile.make, {
                                key: router.asPath
                              }), React.createElement("div", {
                                className: "w-full px-5 pt-[126px]"
                              }, React.createElement("div", {
                                    className: "flex flex-col items-center text-base text-text-L2"
                                  }, React.createElement("span", {
                                        className: "mb-2 text-xl text-text-L1"
                                      }, "상품이 존재하지 않습니다"), React.createElement("span", undefined, "상품 URL이 정확한지 확인해주세요."), React.createElement("span", undefined, "상품이 없을 경우 다른 카테고리의 상품을 선택해주세요."))), React.createElement(Footer_Buyer.MO.make, {}))));
    
  }
}

var NotFound = {
  make: PDP_Buyer$NotFound
};

function PDP_Buyer$Error(Props) {
  var deviceType = Props.deviceType;
  var router = Router.useRouter();
  switch (deviceType) {
    case /* Unknown */0 :
        return null;
    case /* PC */1 :
        return React.createElement("div", {
                    className: "w-full min-w-[1280px] min-h-screen"
                  }, React.createElement(Header_Buyer.PC.make, {
                        key: router.asPath
                      }), React.createElement("div", {
                        className: "w-[1280px] px-5 py-16 mx-auto"
                      }, React.createElement("div", {
                            className: "mt-14"
                          }, React.createElement("div", {
                                className: "w-full flex items-center justify-center"
                              }, React.createElement("span", {
                                    className: "text-3xl text-gray-800"
                                  }, "상품을 가져오는데 실패하였습니다")), React.createElement("div", {
                                className: "mt-7 w-full flex flex-col items-center justify-center"
                              }, React.createElement("span", {
                                    className: "text-gray-800"
                                  }, "상품 URL이 정확한지 확인해주세요."), React.createElement("span", {
                                    className: "text-gray-800"
                                  }, "상품이 없을 경우 다른 카테고리의 상품을 선택해주세요.")))), React.createElement(Footer_Buyer.PC.make, {}));
    case /* Mobile */2 :
        return React.createElement("div", {
                    className: "w-full min-h-screen"
                  }, React.createElement("div", {
                        className: "w-full bg-white"
                      }, React.createElement("div", {
                            className: "w-full max-w-3xl mx-auto bg-white min-h-screen"
                          }, React.createElement(Header_Buyer.Mobile.make, {
                                key: router.asPath
                              }), React.createElement("div", {
                                className: "w-full px-5 pt-[126px]"
                              }, React.createElement("div", {
                                    className: "flex flex-col items-center text-base text-text-L2"
                                  }, React.createElement("span", {
                                        className: "mb-2 text-xl text-text-L1"
                                      }, "상품을 가져오는데 실패하였습니다"), React.createElement("span", undefined, "상품 URL이 정확한지 확인해주세요."), React.createElement("span", undefined, "상품이 없을 경우 다른 카테고리의 상품을 선택해주세요."))), React.createElement(Footer_Buyer.MO.make, {}))));
    
  }
}

var $$Error = {
  make: PDP_Buyer$Error
};

function PDP_Buyer$Presenter(Props) {
  var deviceType = Props.deviceType;
  var query = Props.query;
  var match = use$1(query);
  var fragmentRefs = match.fragmentRefs;
  var pushGtmPageView = PDP_Gtm_Buyer.PageView.use(query);
  ChannelTalkHelper.Hook.use(/* PcOnly */1, {
        eventName: "최근 본 상품",
        eventProperty: {
          productId: match.id,
          productName: match.name
        }
      }, undefined);
  React.useEffect((function () {
          Curry._1(pushGtmPageView, undefined);
        }), []);
  var match$1 = Product_Parser.Type.decode(match.__typename);
  if (match$1 !== undefined) {
    if (match$1 !== 2) {
      if (match$1 >= 3) {
        return React.createElement(PDP_Matching_Buyer.make, {
                    deviceType: deviceType,
                    query: fragmentRefs
                  });
      } else {
        return React.createElement(PDP_Normal_Buyer.make, {
                    deviceType: deviceType,
                    query: fragmentRefs
                  });
      }
    } else {
      return React.createElement(PDP_Quoted_Buyer.make, {
                  deviceType: deviceType,
                  query: fragmentRefs
                });
    }
  } else {
    return null;
  }
}

var Presenter = {
  make: PDP_Buyer$Presenter
};

function PDP_Buyer$Container(Props) {
  var deviceType = Props.deviceType;
  var nodeId = Props.nodeId;
  var match = use({
        id: nodeId
      }, /* StoreAndNetwork */2, undefined, undefined, undefined);
  var node = match.node;
  if (node !== undefined) {
    return React.createElement(PDP_Buyer$Presenter, {
                deviceType: deviceType,
                query: node.fragmentRefs
              });
  } else {
    return React.createElement(PDP_Buyer$NotFound, {
                deviceType: deviceType
              });
  }
}

var Container = {
  make: PDP_Buyer$Container
};

function PDP_Buyer(Props) {
  var deviceType = Props.deviceType;
  var router = Router.useRouter();
  var pid = Js_dict.get(router.query, "pid");
  var match = React.useState(function () {
        return false;
      });
  var setIsCsr = match[1];
  React.useEffect((function () {
          setIsCsr(function (param) {
                return true;
              });
        }), []);
  return React.createElement(React.Fragment, undefined, React.createElement(Head, {
                  children: React.createElement("title", undefined, "신선하이")
                }), React.createElement(RescriptReactErrorBoundary.make, {
                  children: React.createElement(React.Suspense, {
                        children: match[0] && pid !== undefined ? React.createElement(PDP_Buyer$Container, {
                                deviceType: deviceType,
                                nodeId: pid
                              }) : null,
                        fallback: null
                      }),
                  fallback: (function (param) {
                      return React.createElement(PDP_Buyer$Error, {
                                  deviceType: deviceType
                                });
                    })
                }));
}

var make = PDP_Buyer;

export {
  Query ,
  Fragment ,
  Placeholder ,
  NotFound ,
  $$Error ,
  Presenter ,
  Container ,
  make ,
}
/* react Not a pure module */
