// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "rescript/lib/es6/curry.js";
import * as $$Image from "../../../components/common/Image.mjs";
import * as React from "react";
import * as Editor from "../../../components/Editor.mjs";
import * as Js_dict from "rescript/lib/es6/js_dict.js";
import Head from "next/head";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as Router from "next/router";
import * as Layout_Buyer from "../../../layouts/Layout_Buyer.mjs";
import * as RescriptRelay from "rescript-relay/src/RescriptRelay.mjs";
import * as RelayRuntime from "relay-runtime";
import * as PDP_Notice_Buyer from "./PDP_Notice_Buyer.mjs";
import * as ChannelTalkHelper from "../../../utils/ChannelTalkHelper.mjs";
import * as Js_null_undefined from "rescript/lib/es6/js_null_undefined.js";
import * as Hooks from "react-relay/hooks";
import * as PDPBuyerQuery_graphql from "../../../__generated__/PDPBuyerQuery_graphql.mjs";
import * as RescriptRelay_Internal from "rescript-relay/src/RescriptRelay_Internal.mjs";
import * as PDP_SalesDocument_Buyer from "./PDP_SalesDocument_Buyer.mjs";
import * as PDPBuyerFragment_graphql from "../../../__generated__/PDPBuyerFragment_graphql.mjs";
import * as PDP_Product_Normal_Buyer from "./PDP_Product_Normal_Buyer.mjs";
import * as PDP_Product_Quoted_Buyer from "./PDP_Product_Quoted_Buyer.mjs";
import * as ReactSeparator from "@radix-ui/react-separator";
import * as RescriptReactErrorBoundary from "@rescript/react/src/RescriptReactErrorBoundary.mjs";

function use(variables, fetchPolicy, fetchKey, networkCacheConfig, param) {
  var data = Hooks.useLazyLoadQuery(PDPBuyerQuery_graphql.node, RescriptRelay_Internal.internal_cleanObjectFromUndefinedRaw(PDPBuyerQuery_graphql.Internal.convertVariables(variables)), {
        fetchKey: fetchKey,
        fetchPolicy: RescriptRelay.mapFetchPolicy(fetchPolicy),
        networkCacheConfig: networkCacheConfig
      });
  return RescriptRelay_Internal.internal_useConvertedValue(PDPBuyerQuery_graphql.Internal.convertResponse, data);
}

function useLoader(param) {
  var match = Hooks.useQueryLoader(PDPBuyerQuery_graphql.node);
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
  Hooks.fetchQuery(environment, PDPBuyerQuery_graphql.node, PDPBuyerQuery_graphql.Internal.convertVariables(variables), {
          networkCacheConfig: networkCacheConfig,
          fetchPolicy: RescriptRelay.mapFetchQueryFetchPolicy(fetchPolicy)
        }).subscribe({
        next: (function (res) {
            return Curry._1(onResult, {
                        TAG: /* Ok */0,
                        _0: PDPBuyerQuery_graphql.Internal.convertResponse(res)
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
  var __x = Hooks.fetchQuery(environment, PDPBuyerQuery_graphql.node, PDPBuyerQuery_graphql.Internal.convertVariables(variables), {
          networkCacheConfig: networkCacheConfig,
          fetchPolicy: RescriptRelay.mapFetchQueryFetchPolicy(fetchPolicy)
        }).toPromise();
  return __x.then(function (res) {
              return Promise.resolve(PDPBuyerQuery_graphql.Internal.convertResponse(res));
            });
}

function usePreloaded(queryRef, param) {
  var data = Hooks.usePreloadedQuery(PDPBuyerQuery_graphql.node, queryRef);
  return RescriptRelay_Internal.internal_useConvertedValue(PDPBuyerQuery_graphql.Internal.convertResponse, data);
}

function retain(environment, variables) {
  var operationDescriptor = RelayRuntime.createOperationDescriptor(PDPBuyerQuery_graphql.node, PDPBuyerQuery_graphql.Internal.convertVariables(variables));
  return environment.retain(operationDescriptor);
}

var Query_makeVariables = PDPBuyerQuery_graphql.Utils.makeVariables;

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

function use$1(fRef) {
  var data = Hooks.useFragment(PDPBuyerFragment_graphql.node, fRef);
  return RescriptRelay_Internal.internal_useConvertedValue(PDPBuyerFragment_graphql.Internal.convertFragment, data);
}

function useOpt(opt_fRef) {
  var fr = opt_fRef !== undefined ? Caml_option.some(Caml_option.valFromOption(opt_fRef)) : undefined;
  var nullableFragmentData = Hooks.useFragment(PDPBuyerFragment_graphql.node, fr !== undefined ? Js_null_undefined.fromOption(Caml_option.some(Caml_option.valFromOption(fr))) : null);
  var data = (nullableFragmentData == null) ? undefined : Caml_option.some(nullableFragmentData);
  return RescriptRelay_Internal.internal_useConvertedValue((function (rawFragment) {
                if (rawFragment !== undefined) {
                  return PDPBuyerFragment_graphql.Internal.convertFragment(rawFragment);
                }
                
              }), data);
}

var Fragment_productType_decode = PDPBuyerFragment_graphql.Utils.productType_decode;

var Fragment_productType_fromString = PDPBuyerFragment_graphql.Utils.productType_fromString;

var Fragment = {
  productType_decode: Fragment_productType_decode,
  productType_fromString: Fragment_productType_fromString,
  Types: undefined,
  use: use$1,
  useOpt: useOpt
};

function PDP_Buyer$PC(Props) {
  var query = Props.query;
  var image = Props.image;
  var description = Props.description;
  var type_ = Props.type_;
  return React.createElement("div", {
              className: "w-[1280px] mx-auto min-h-full"
            }, React.createElement("div", {
                  className: "w-full pt-16 px-5 divide-y"
                }, React.createElement("section", {
                      className: "w-full flex pb-12 gap-20"
                    }, React.createElement("div", undefined, React.createElement("div", {
                              className: "relative w-[664px] aspect-square rounded-2xl overflow-hidden"
                            }, React.createElement($$Image.make, {
                                  src: image.thumb1920x1920,
                                  placeholder: $$Image.Placeholder.lg,
                                  className: "w-full h-full object-cover",
                                  alt: "product-detail-thumbnail"
                                }), React.createElement("div", {
                                  className: "w-full h-full absolute top-0 left-0 bg-black/[.03] rounded-2xl"
                                })), React.createElement(PDP_SalesDocument_Buyer.PC.make, {
                              query: query
                            })), type_ === "QUOTABLE" || type_ === "NORMAL" ? React.createElement(PDP_Product_Normal_Buyer.PC.make, {
                            query: query
                          }) : (
                        type_ === "QUOTED" ? React.createElement(PDP_Product_Quoted_Buyer.PC.make, {
                                query: query
                              }) : null
                      )), React.createElement("section", {
                      className: "pt-16"
                    }, React.createElement("span", {
                          className: "text-2xl font-bold text-gray-800"
                        }, "상세 설명"), React.createElement(PDP_Notice_Buyer.PC.make, {
                          query: query
                        }), React.createElement("div", {
                          className: "py-16"
                        }, React.createElement(Editor.Viewer.make, {
                              value: description
                            }))), type_ === "QUOTABLE" || type_ === "NORMAL" ? React.createElement("section", {
                        className: "w-full py-16 flex justify-center"
                      }, React.createElement("div", {
                            className: "w-full max-w-[600px] aspect-[209/1361]"
                          }, React.createElement("img", {
                                className: "w-full h-full object-cover",
                                alt: "pdp-delivery-guide-mo",
                                src: "https://public.sinsunhi.com/images/20220616/f15dcb82-7b3e-482d-a32a-ab56791617da/%E1%84%89%E1%85%A1%E1%86%BC%E1%84%89%E1%85%A6%20CS%E1%84%80%E1%85%A9%E1%86%BC%E1%84%90%E1%85%A9%E1%86%BC%E1%84%8B%E1%85%A7%E1%86%BC%E1%84%8B%E1%85%A7%E1%86%A8%20%E1%84%8E%E1%85%AC%E1%84%8E%E1%85%AC%E1%84%8C%E1%85%A9%E1%86%BC.jpg"
                              }))) : null));
}

var PC = {
  make: PDP_Buyer$PC
};

function PDP_Buyer$MO(Props) {
  var query = Props.query;
  var image = Props.image;
  var description = Props.description;
  var type_ = Props.type_;
  return React.createElement("div", {
              className: "w-full"
            }, React.createElement("section", {
                  className: "flex flex-col gap-5"
                }, React.createElement("div", {
                      className: "w-full pt-[100%] relative overflow-hidden"
                    }, React.createElement($$Image.make, {
                          src: image.thumb1000x1000,
                          placeholder: $$Image.Placeholder.lg,
                          className: "absolute top-0 left-0 w-full h-full object-cover",
                          alt: "product-detail-thumbnail"
                        }), React.createElement("div", {
                          className: "w-full h-full absolute top-0 left-0 bg-black/[.03]"
                        }))), React.createElement("section", {
                  className: "px-5 divide-y"
                }, type_ === "QUOTABLE" || type_ === "NORMAL" ? React.createElement(PDP_Product_Normal_Buyer.MO.make, {
                        query: query
                      }) : (
                    type_ === "QUOTED" ? React.createElement(PDP_Product_Quoted_Buyer.MO.make, {
                            query: query
                          }) : null
                  ), React.createElement(PDP_SalesDocument_Buyer.MO.make, {
                      query: query
                    }), React.createElement("div", {
                      className: "flex flex-col gap-5 py-8"
                    }, React.createElement("h1", {
                          className: "text-text-L1 text-base font-bold"
                        }, "상세설명"), React.createElement(PDP_Notice_Buyer.MO.make, {
                          query: query
                        }), React.createElement("div", {
                          className: "w-full overflow-x-scroll"
                        }, React.createElement(Editor.Viewer.make, {
                              value: description
                            })))), type_ === "QUOTABLE" || type_ === "NORMAL" ? React.createElement("section", {
                    className: "px-5 py-8"
                  }, React.createElement("div", {
                        className: "w-full aspect-[209/1361]"
                      }, React.createElement("img", {
                            className: "w-full h-full object-cover",
                            alt: "pdp-delivery-guide-mo",
                            src: "https://public.sinsunhi.com/images/20220616/f15dcb82-7b3e-482d-a32a-ab56791617da/%E1%84%89%E1%85%A1%E1%86%BC%E1%84%89%E1%85%A6%20CS%E1%84%80%E1%85%A9%E1%86%BC%E1%84%90%E1%85%A9%E1%86%BC%E1%84%8B%E1%85%A7%E1%86%BC%E1%84%8B%E1%85%A7%E1%86%A8%20%E1%84%8E%E1%85%AC%E1%84%8E%E1%85%AC%E1%84%8C%E1%85%A9%E1%86%BC.jpg"
                          }))) : null);
}

var MO = {
  make: PDP_Buyer$MO
};

function PDP_Buyer$Placeholder(Props) {
  return React.createElement(Layout_Buyer.Responsive.make, {
              pc: React.createElement("div", {
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
                              })))),
              mobile: React.createElement("div", {
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
                          })))
            });
}

var Placeholder = {
  make: PDP_Buyer$Placeholder
};

function PDP_Buyer$NotFound(Props) {
  return React.createElement(Layout_Buyer.Responsive.make, {
              pc: React.createElement("div", {
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
                              }, "상품이 없을 경우 다른 카테고리의 상품을 선택해주세요.")))),
              mobile: React.createElement("div", {
                    className: "w-full px-5 pt-[126px]"
                  }, React.createElement("div", {
                        className: "flex flex-col items-center text-base text-text-L2"
                      }, React.createElement("span", {
                            className: "mb-2 text-xl text-text-L1"
                          }, "상품이 존재하지 않습니다"), React.createElement("span", undefined, "상품 URL이 정확한지 확인해주세요."), React.createElement("span", undefined, "상품이 없을 경우 다른 카테고리의 상품을 선택해주세요.")))
            });
}

var NotFound = {
  make: PDP_Buyer$NotFound
};

function PDP_Buyer$Common(Props) {
  var id = Props.id;
  var query = Props.query;
  var match = use$1(query);
  var fragmentRefs = match.fragmentRefs;
  var description = match.description;
  var image = match.image;
  var type_ = match.type_;
  ChannelTalkHelper.Hook.use(/* PcOnly */1, {
        eventName: "최근 본 상품",
        eventProperty: {
          productId: id,
          productName: match.name
        }
      }, undefined);
  return React.createElement(Layout_Buyer.Responsive.make, {
              pc: React.createElement(PDP_Buyer$PC, {
                    query: fragmentRefs,
                    image: image,
                    description: description,
                    type_: type_
                  }),
              mobile: React.createElement(PDP_Buyer$MO, {
                    query: fragmentRefs,
                    image: image,
                    description: description,
                    type_: type_
                  })
            });
}

var Common = {
  make: PDP_Buyer$Common
};

function PDP_Buyer$Container(Props) {
  var nodeId = Props.nodeId;
  var match = use({
        id: nodeId
      }, /* StoreAndNetwork */2, undefined, undefined, undefined);
  var node = match.node;
  if (node !== undefined) {
    return React.createElement(PDP_Buyer$Common, {
                id: nodeId,
                query: node.fragmentRefs
              });
  } else {
    return React.createElement(PDP_Buyer$NotFound, {});
  }
}

var Container = {
  make: PDP_Buyer$Container
};

function PDP_Buyer(Props) {
  var router = Router.useRouter();
  var pid = Js_dict.get(router.query, "pid");
  return React.createElement(React.Fragment, undefined, React.createElement(Head, {
                  children: React.createElement("title", undefined, "신선하이")
                }), React.createElement(RescriptReactErrorBoundary.make, {
                  children: React.createElement(React.Suspense, {
                        children: pid !== undefined ? React.createElement(PDP_Buyer$Container, {
                                nodeId: pid
                              }) : React.createElement(PDP_Buyer$Placeholder, {}),
                        fallback: React.createElement(PDP_Buyer$Placeholder, {})
                      }),
                  fallback: (function (param) {
                      return React.createElement(PDP_Buyer$NotFound, {});
                    })
                }));
}

var make = PDP_Buyer;

export {
  Query ,
  Fragment ,
  PC ,
  MO ,
  Placeholder ,
  NotFound ,
  Common ,
  Container ,
  make ,
  
}
/* Image Not a pure module */