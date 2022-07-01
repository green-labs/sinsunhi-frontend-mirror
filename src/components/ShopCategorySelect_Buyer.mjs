// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Cx from "rescript-classnames/src/Cx.mjs";
import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as Js_dict from "rescript/lib/es6/js_dict.js";
import * as Hoverable from "./common/Hoverable.mjs";
import * as IconArrow from "./svgs/IconArrow.mjs";
import * as IconClose from "./svgs/IconClose.mjs";
import Link from "next/link";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_module from "rescript/lib/es6/caml_module.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as ReactEvents from "../utils/ReactEvents.mjs";
import * as Router from "next/router";
import * as IconHamburger from "./svgs/IconHamburger.mjs";
import * as RescriptRelay from "rescript-relay/src/RescriptRelay.mjs";
import * as RelayRuntime from "relay-runtime";
import * as Hooks from "react-relay/hooks";
import * as ReactRemoveScroll from "react-remove-scroll";
import * as RescriptRelay_Internal from "rescript-relay/src/RescriptRelay_Internal.mjs";
import * as ShopCategorySelectBuyerQuery_graphql from "../__generated__/ShopCategorySelectBuyerQuery_graphql.mjs";
import * as ShopCategorySelectBuyerMobileQuery_graphql from "../__generated__/ShopCategorySelectBuyerMobileQuery_graphql.mjs";

var makeVariables = ShopCategorySelectBuyerQuery_graphql.Utils.makeVariables;

function use(variables, fetchPolicy, fetchKey, networkCacheConfig, param) {
  var data = Hooks.useLazyLoadQuery(ShopCategorySelectBuyerQuery_graphql.node, RescriptRelay_Internal.internal_cleanObjectFromUndefinedRaw(ShopCategorySelectBuyerQuery_graphql.Internal.convertVariables(variables)), {
        fetchKey: fetchKey,
        fetchPolicy: RescriptRelay.mapFetchPolicy(fetchPolicy),
        networkCacheConfig: networkCacheConfig
      });
  return RescriptRelay_Internal.internal_useConvertedValue(ShopCategorySelectBuyerQuery_graphql.Internal.convertResponse, data);
}

function useLoader(param) {
  var match = Hooks.useQueryLoader(ShopCategorySelectBuyerQuery_graphql.node);
  var loadQueryFn = match[1];
  var loadQuery = React.useMemo((function () {
          return function (param, param$1, param$2, param$3) {
            return Curry._2(loadQueryFn, ShopCategorySelectBuyerQuery_graphql.Internal.convertVariables(param), {
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
  Hooks.fetchQuery(environment, ShopCategorySelectBuyerQuery_graphql.node, ShopCategorySelectBuyerQuery_graphql.Internal.convertVariables(variables), {
          networkCacheConfig: networkCacheConfig,
          fetchPolicy: RescriptRelay.mapFetchQueryFetchPolicy(fetchPolicy)
        }).subscribe({
        next: (function (res) {
            return Curry._1(onResult, {
                        TAG: /* Ok */0,
                        _0: ShopCategorySelectBuyerQuery_graphql.Internal.convertResponse(res)
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
  var __x = Hooks.fetchQuery(environment, ShopCategorySelectBuyerQuery_graphql.node, ShopCategorySelectBuyerQuery_graphql.Internal.convertVariables(variables), {
          networkCacheConfig: networkCacheConfig,
          fetchPolicy: RescriptRelay.mapFetchQueryFetchPolicy(fetchPolicy)
        }).toPromise();
  return __x.then(function (res) {
              return Promise.resolve(ShopCategorySelectBuyerQuery_graphql.Internal.convertResponse(res));
            });
}

function usePreloaded(queryRef, param) {
  var data = Hooks.usePreloadedQuery(ShopCategorySelectBuyerQuery_graphql.node, queryRef);
  return RescriptRelay_Internal.internal_useConvertedValue(ShopCategorySelectBuyerQuery_graphql.Internal.convertResponse, data);
}

function retain(environment, variables) {
  var operationDescriptor = RelayRuntime.createOperationDescriptor(ShopCategorySelectBuyerQuery_graphql.node, ShopCategorySelectBuyerQuery_graphql.Internal.convertVariables(variables));
  return environment.retain(operationDescriptor);
}

var Query_displayCategoryType_decode = ShopCategorySelectBuyerQuery_graphql.Utils.displayCategoryType_decode;

var Query_displayCategoryType_fromString = ShopCategorySelectBuyerQuery_graphql.Utils.displayCategoryType_fromString;

var Query = {
  displayCategoryType_decode: Query_displayCategoryType_decode,
  displayCategoryType_fromString: Query_displayCategoryType_fromString,
  makeVariables: makeVariables,
  Types: undefined,
  use: use,
  useLoader: useLoader,
  $$fetch: $$fetch,
  fetchPromised: fetchPromised,
  usePreloaded: usePreloaded,
  retain: retain
};

var makeVariables$1 = ShopCategorySelectBuyerMobileQuery_graphql.Utils.makeVariables;

function use$1(variables, fetchPolicy, fetchKey, networkCacheConfig, param) {
  var data = Hooks.useLazyLoadQuery(ShopCategorySelectBuyerMobileQuery_graphql.node, RescriptRelay_Internal.internal_cleanObjectFromUndefinedRaw(ShopCategorySelectBuyerMobileQuery_graphql.Internal.convertVariables(variables)), {
        fetchKey: fetchKey,
        fetchPolicy: RescriptRelay.mapFetchPolicy(fetchPolicy),
        networkCacheConfig: networkCacheConfig
      });
  return RescriptRelay_Internal.internal_useConvertedValue(ShopCategorySelectBuyerMobileQuery_graphql.Internal.convertResponse, data);
}

function useLoader$1(param) {
  var match = Hooks.useQueryLoader(ShopCategorySelectBuyerMobileQuery_graphql.node);
  var loadQueryFn = match[1];
  var loadQuery = React.useMemo((function () {
          return function (param, param$1, param$2, param$3) {
            return Curry._2(loadQueryFn, ShopCategorySelectBuyerMobileQuery_graphql.Internal.convertVariables(param), {
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

function $$fetch$1(environment, variables, onResult, networkCacheConfig, fetchPolicy, param) {
  Hooks.fetchQuery(environment, ShopCategorySelectBuyerMobileQuery_graphql.node, ShopCategorySelectBuyerMobileQuery_graphql.Internal.convertVariables(variables), {
          networkCacheConfig: networkCacheConfig,
          fetchPolicy: RescriptRelay.mapFetchQueryFetchPolicy(fetchPolicy)
        }).subscribe({
        next: (function (res) {
            return Curry._1(onResult, {
                        TAG: /* Ok */0,
                        _0: ShopCategorySelectBuyerMobileQuery_graphql.Internal.convertResponse(res)
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

function fetchPromised$1(environment, variables, networkCacheConfig, fetchPolicy, param) {
  var __x = Hooks.fetchQuery(environment, ShopCategorySelectBuyerMobileQuery_graphql.node, ShopCategorySelectBuyerMobileQuery_graphql.Internal.convertVariables(variables), {
          networkCacheConfig: networkCacheConfig,
          fetchPolicy: RescriptRelay.mapFetchQueryFetchPolicy(fetchPolicy)
        }).toPromise();
  return __x.then(function (res) {
              return Promise.resolve(ShopCategorySelectBuyerMobileQuery_graphql.Internal.convertResponse(res));
            });
}

function usePreloaded$1(queryRef, param) {
  var data = Hooks.usePreloadedQuery(ShopCategorySelectBuyerMobileQuery_graphql.node, queryRef);
  return RescriptRelay_Internal.internal_useConvertedValue(ShopCategorySelectBuyerMobileQuery_graphql.Internal.convertResponse, data);
}

function retain$1(environment, variables) {
  var operationDescriptor = RelayRuntime.createOperationDescriptor(ShopCategorySelectBuyerMobileQuery_graphql.node, ShopCategorySelectBuyerMobileQuery_graphql.Internal.convertVariables(variables));
  return environment.retain(operationDescriptor);
}

var Query_displayCategoryType_decode$1 = ShopCategorySelectBuyerMobileQuery_graphql.Utils.displayCategoryType_decode;

var Query_displayCategoryType_fromString$1 = ShopCategorySelectBuyerMobileQuery_graphql.Utils.displayCategoryType_fromString;

var Query$1 = {
  displayCategoryType_decode: Query_displayCategoryType_decode$1,
  displayCategoryType_fromString: Query_displayCategoryType_fromString$1,
  makeVariables: makeVariables$1,
  Types: undefined,
  use: use$1,
  useLoader: useLoader$1,
  $$fetch: $$fetch$1,
  fetchPromised: fetchPromised$1,
  usePreloaded: usePreloaded$1,
  retain: retain$1
};

function ShopCategorySelect_Buyer$Mobile$Sub(Props) {
  var parentId = Props.parentId;
  var parentName = Props.parentName;
  var match = use$1(Curry._4(makeVariables$1, parentId, ["NORMAL"], true, undefined), undefined, undefined, undefined, undefined);
  var parentQueryStr = new URLSearchParams([
          [
            "category-id",
            parentId
          ],
          [
            "category-name",
            parentName
          ]
        ]).toString();
  return React.createElement(React.Fragment, undefined, React.createElement(Link, {
                  href: "/buyer/products?" + parentQueryStr,
                  children: React.createElement("button", {
                        className: "text-left px-5 py-3 bg-white flex justify-between items-center active:bg-bg-pressed-L2"
                      }, React.createElement("span", {
                            className: "font-bold"
                          }, "전체보기"), React.createElement(IconArrow.make, {
                            height: "16",
                            width: "16",
                            fill: "#B2B2B2"
                          }))
                }), Belt_Array.map(match.displayCategories, (function (param) {
                    var name = param.name;
                    var id = param.id;
                    var queryStr = new URLSearchParams([
                            [
                              "category-id",
                              id
                            ],
                            [
                              "category-name",
                              encodeURIComponent(name)
                            ]
                          ]).toString();
                    return React.createElement(Link, {
                                href: "/buyer/products?" + queryStr,
                                children: React.createElement("button", {
                                      className: "text-left px-5 py-3 bg-white flex justify-between items-center active:bg-bg-pressed-L2"
                                    }, name, React.createElement(IconArrow.make, {
                                          height: "16",
                                          width: "16",
                                          fill: "#B2B2B2"
                                        })),
                                key: id
                              });
                  })));
}

var Sub = {
  make: ShopCategorySelect_Buyer$Mobile$Sub
};

function ShopCategorySelect_Buyer$Mobile(Props) {
  var match = React.useState(function () {
        return false;
      });
  var setOpen = match[1];
  var match$1 = use$1(Curry._4(makeVariables$1, undefined, ["NORMAL"], true, undefined), undefined, undefined, undefined, undefined);
  var displayCategories = match$1.displayCategories;
  var defaultParentId = Belt_Option.map(Belt_Array.get(displayCategories, 0), (function (param) {
          return param.id;
        }));
  var match$2 = React.useState(function () {
        return defaultParentId;
      });
  var setParentId = match$2[1];
  var parentId = match$2[0];
  var parent = Belt_Option.flatMap(parentId, (function (parentId$p) {
          return Belt_Array.getBy(displayCategories, (function (param) {
                        return param.id === parentId$p;
                      }));
        }));
  var clickedStyle = function (id) {
    if (parentId !== undefined && parentId === id) {
      return "bg-white text-primary font-bold";
    } else {
      return "";
    }
  };
  var makeOnClick = function (id) {
    return function (param) {
      return ReactEvents.interceptingHandler((function (param) {
                    return setParentId(function (param) {
                                return id;
                              });
                  }), param);
    };
  };
  return React.createElement(React.Fragment, undefined, React.createElement("button", {
                  onClick: (function (param) {
                      return setOpen(function (param) {
                                  return true;
                                });
                    })
                }, React.createElement(IconHamburger.make, {
                      width: "28",
                      height: "28",
                      fill: "#12B564"
                    })), match[0] ? React.createElement(ReactRemoveScroll.RemoveScroll, {
                    children: React.createElement("div", {
                          className: Cx.cx(["w-full h-full fixed top-0 left-0 bg-gray-50 z-20 overflow-y-auto"])
                        }, React.createElement("div", {
                              className: "w-full max-w-3xl mx-auto bg-white min-h-full"
                            }, React.createElement("div", {
                                  className: "relative overflow-auto"
                                }, React.createElement("div", {
                                      className: "h-14 text-center py-4 px-5"
                                    }, React.createElement("span", {
                                          className: "font-bold text-xl"
                                        }, "카테고리"), React.createElement("button", {
                                          className: "float-right",
                                          onClick: (function (param) {
                                              return setOpen(function (param) {
                                                          return false;
                                                        });
                                            })
                                        }, React.createElement(IconClose.make, {
                                              height: "24",
                                              width: "24",
                                              fill: "#262626"
                                            }))), React.createElement("div", {
                                      className: "flex flex-col"
                                    }, React.createElement("div", {
                                          className: "grid grid-cols-10 border-y min-h-[432px] text-[15px]"
                                        }, React.createElement("div", {
                                              className: "col-span-4 flex flex-col bg-surface"
                                            }, Belt_Array.map(displayCategories, (function (param) {
                                                    var id = param.id;
                                                    return React.createElement("button", {
                                                                key: id,
                                                                className: Cx.cx([
                                                                      "text-left px-5 py-3 border-b last:border-none active:bg-bg-pressed-L2",
                                                                      clickedStyle(id)
                                                                    ]),
                                                                onClick: makeOnClick(id)
                                                              }, param.name);
                                                  }))), React.createElement("div", {
                                              className: "col-span-6 flex flex-col border-none"
                                            }, React.createElement(React.Suspense, {
                                                  children: Belt_Option.mapWithDefault(parent, null, (function (param) {
                                                          return React.createElement(ShopCategorySelect_Buyer$Mobile$Sub, {
                                                                      parentId: param.id,
                                                                      parentName: param.name
                                                                    });
                                                        })),
                                                  fallback: React.createElement("div", undefined)
                                                }))), Belt_Array.map(match$1.gnbBanners, (function (param) {
                                            return React.createElement(Link, {
                                                        href: param.landingUrl,
                                                        children: React.createElement("a", {
                                                              className: "py-4 px-5 flex justify-between active:bg-bg-pressed-L2",
                                                              rel: "noopener noreferer",
                                                              target: param.isNewTabMobile ? "_blank" : ""
                                                            }, React.createElement("div", undefined, param.title), React.createElement(IconArrow.make, {
                                                                  height: "24",
                                                                  width: "24",
                                                                  fill: "#B2B2B2"
                                                                })),
                                                        key: param.id
                                                      });
                                          }))))))
                  }) : null);
}

var Mobile = {
  Query: Query$1,
  Sub: Sub,
  make: ShopCategorySelect_Buyer$Mobile
};

var RecursiveCategories = Caml_module.init_mod([
      "ShopCategorySelect_Buyer.res",
      212,
      56
    ], {
      TAG: /* Module */0,
      _0: [[
          /* Function */0,
          "make"
        ]]
    });

function ShopCategorySelect_Buyer$PC$RecursiveCategories(Props) {
  var parentId = Props.parentId;
  var router = Router.useRouter();
  var match = use(Curry._4(makeVariables, parentId, ["NORMAL"], true, undefined), undefined, undefined, undefined, undefined);
  var displayCategories = match.displayCategories;
  var match$1 = React.useState(function () {
        
      });
  var setHoveredId = match$1[1];
  var makeOnClick = function (id, name) {
    return function (param) {
      return ReactEvents.interceptingHandler((function (param) {
                    var prim1_pathname = "/buyer/products";
                    var prim1_query = Js_dict.fromArray([
                          [
                            "category-id",
                            id
                          ],
                          [
                            "category-name",
                            encodeURIComponent(name)
                          ]
                        ]);
                    var prim1 = {
                      pathname: prim1_pathname,
                      query: prim1_query
                    };
                    router.push(prim1);
                    
                  }), param);
    };
  };
  if (displayCategories.length !== 0) {
    return React.createElement(React.Fragment, undefined, React.createElement("div", {
                    className: "w-[222px] px-8 py-5 flex flex-col"
                  }, Belt_Array.map(displayCategories, (function (param) {
                          var children = param.children;
                          var name = param.name;
                          var id = param.id;
                          return React.createElement(Hoverable.make, {
                                      className: "mt-3",
                                      children: React.createElement("div", {
                                            className: "w-full flex items-center justify-between group cursor-pointer group",
                                            onClick: makeOnClick(id, name)
                                          }, React.createElement("span", {
                                                className: "text-[15px] text-gray-800 group-hover:text-green-600 group-hover:font-bold"
                                              }, name), React.createElement("span", {
                                                className: "w-4 h-4"
                                              }, React.createElement(IconArrow.make, {
                                                    height: "16",
                                                    width: "16",
                                                    fill: "#12B564",
                                                    className: "hidden group-hover:block"
                                                  }))),
                                      onHoverChange: (function (param) {
                                          if (children.length !== 0) {
                                            return setHoveredId(function (param) {
                                                        return id;
                                                      });
                                          } else {
                                            return setHoveredId(function (param) {
                                                        
                                                      });
                                          }
                                        }),
                                      key: id
                                    });
                        }))), Belt_Option.mapWithDefault(match$1[0], null, (function (hoveredId$p) {
                      return React.createElement(React.Suspense, {
                                  children: React.createElement(RecursiveCategories.make, {
                                        parentId: hoveredId$p,
                                        key: hoveredId$p
                                      }),
                                  fallback: React.createElement("div", {
                                        className: "w-[222px]"
                                      })
                                });
                    })));
  } else {
    return null;
  }
}

Caml_module.update_mod({
      TAG: /* Module */0,
      _0: [[
          /* Function */0,
          "make"
        ]]
    }, RecursiveCategories, {
      make: ShopCategorySelect_Buyer$PC$RecursiveCategories
    });

function ShopCategorySelect_Buyer$PC(Props) {
  var match = React.useState(function () {
        return false;
      });
  var setIsHovered = match[1];
  return React.createElement("div", undefined, React.createElement(Hoverable.make, {
                  children: match[0] ? React.createElement(React.Fragment, undefined, React.createElement("div", {
                              className: "flex items-center w-56 h-[54px] px-7 border-t border-x border-primary"
                            }, React.createElement(IconHamburger.make, {
                                  width: "24",
                                  height: "18"
                                }), React.createElement("span", {
                                  className: "mx-2 text-lg font-bold text-primary"
                                }, "전체 카테고리"), React.createElement(IconArrow.make, {
                                  height: "20",
                                  width: "20",
                                  fill: "#12B564",
                                  className: "-rotate-90"
                                })), React.createElement("div", {
                              className: "relative"
                            }, React.createElement("div", {
                                  className: "h-[434px] bg-white absolute top-0 border border-green-500 flex divide-x"
                                }, React.createElement(React.Suspense, {
                                      children: React.createElement(RecursiveCategories.make, {
                                            parentId: undefined
                                          }),
                                      fallback: React.createElement("div", {
                                            className: "w-[222px]"
                                          })
                                    })), React.createElement("div", {
                                  className: "w-[222px] bg-white absolute top-0 left-[1px] h-1"
                                }))) : React.createElement("div", {
                          className: "flex items-center w-56 h-[54px] px-7 border-t border-x border-transparent"
                        }, React.createElement(IconHamburger.make, {
                              width: "24",
                              height: "18"
                            }), React.createElement("span", {
                              className: "mx-2 text-lg font-bold text-text-L1"
                            }, "전체 카테고리"), React.createElement(IconArrow.make, {
                              height: "20",
                              width: "20",
                              fill: "#B2B2B2",
                              className: "rotate-90"
                            })),
                  onHoverChange: (function (to_) {
                      return setIsHovered(function (param) {
                                  return to_;
                                });
                    })
                }));
}

var PC = {
  RecursiveCategories: RecursiveCategories,
  make: ShopCategorySelect_Buyer$PC
};

export {
  Query ,
  Mobile ,
  PC ,
  
}
/* RecursiveCategories Not a pure module */