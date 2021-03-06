// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import ReactSlick from "react-slick";
import * as Js_null_undefined from "rescript/lib/es6/js_null_undefined.js";
import * as Hooks from "react-relay/hooks";
import * as RescriptRelay_Internal from "rescript-relay/src/RescriptRelay_Internal.mjs";
import * as ShopMainMainBannerBuyerFragment_graphql from "../__generated__/ShopMainMainBannerBuyerFragment_graphql.mjs";
import ArrowWhiteLeftSvg from "../../public/assets/arrow-white-left.svg";

var arrowWhiteLeftIcon = ArrowWhiteLeftSvg;

function use(fRef) {
  var data = Hooks.useFragment(ShopMainMainBannerBuyerFragment_graphql.node, fRef);
  return RescriptRelay_Internal.internal_useConvertedValue(ShopMainMainBannerBuyerFragment_graphql.Internal.convertFragment, data);
}

function useOpt(opt_fRef) {
  var fr = opt_fRef !== undefined ? Caml_option.some(Caml_option.valFromOption(opt_fRef)) : undefined;
  var nullableFragmentData = Hooks.useFragment(ShopMainMainBannerBuyerFragment_graphql.node, fr !== undefined ? Js_null_undefined.fromOption(Caml_option.some(Caml_option.valFromOption(fr))) : null);
  var data = (nullableFragmentData == null) ? undefined : Caml_option.some(nullableFragmentData);
  return RescriptRelay_Internal.internal_useConvertedValue((function (rawFragment) {
                if (rawFragment !== undefined) {
                  return ShopMainMainBannerBuyerFragment_graphql.Internal.convertFragment(rawFragment);
                }
                
              }), data);
}

var Fragment = {
  Types: undefined,
  use: use,
  useOpt: useOpt
};

function ShopMain_MainBanner_Buyer$PC$PrevBtn(Props) {
  var onClick = Props.onClick;
  var handleClick = function (param) {
    Belt_Option.map(onClick, (function (onClick$p) {
            return Curry._1(onClick$p, undefined);
          }));
    
  };
  return React.createElement("button", {
              className: "absolute z-[5] left-3 top-1/2 translate-y-[-50%]",
              onClick: handleClick
            }, React.createElement("img", {
                  src: arrowWhiteLeftIcon
                }));
}

var PrevBtn = {
  make: ShopMain_MainBanner_Buyer$PC$PrevBtn
};

function ShopMain_MainBanner_Buyer$PC$NextBtn(Props) {
  var onClick = Props.onClick;
  var handleClick = function (param) {
    Belt_Option.map(onClick, (function (onClick$p) {
            return Curry._1(onClick$p, undefined);
          }));
    
  };
  return React.createElement("button", {
              className: "absolute rotate-180 z-[5] right-3 top-1/2 translate-y-[-50%]",
              onClick: handleClick
            }, React.createElement("img", {
                  src: arrowWhiteLeftIcon
                }));
}

var NextBtn = {
  make: ShopMain_MainBanner_Buyer$PC$NextBtn
};

function ShopMain_MainBanner_Buyer$PC$PageIndex(Props) {
  var total = Props.total;
  var current = Props.current;
  return React.createElement("div", {
              className: "absolute bottom-3 right-3 rounded-full bg-gray-800 bg-opacity-20 px-4 py-1 flex items-center justify-center"
            }, React.createElement("span", {
                  className: "text-white text-2xs"
                }, String(current + 1 | 0) + " / " + String(total)));
}

var PageIndex = {
  make: ShopMain_MainBanner_Buyer$PC$PageIndex
};

function ShopMain_MainBanner_Buyer$PC$Dots(Props) {
  var total = Props.total;
  var current = Props.current;
  return React.createElement("div", {
              className: "absolute left-1/2 bottom-5 translate-x-[-50%] flex items-center gap-2"
            }, Belt_Array.map(Belt_Array.range(0, total - 1 | 0), (function (idx) {
                    var style = current === idx ? "w-2 h-2 rounded-full bg-white bg-opacity-70" : "w-2 h-2 rounded-full bg-white bg-opacity-50";
                    return React.createElement("div", {
                                key: "banner-dot-" + String(idx),
                                className: style
                              });
                  })));
}

var Dots = {
  make: ShopMain_MainBanner_Buyer$PC$Dots
};

function ShopMain_MainBanner_Buyer$PC$Placeholder(Props) {
  return React.createElement("div", {
              className: "w-[920px] aspect-[920/396] animate-pulse rounded-lg bg-gray-150"
            });
}

var Placeholder = {
  make: ShopMain_MainBanner_Buyer$PC$Placeholder
};

function ShopMain_MainBanner_Buyer$PC(Props) {
  var query = Props.query;
  var match = use(query);
  var mainBanners = match.mainBanners;
  var total = mainBanners.length;
  var match$1 = React.useState(function () {
        return 0;
      });
  var setCurrent = match$1[1];
  var current = match$1[0];
  var afterChange = function (changedTo) {
    return setCurrent(function (param) {
                return changedTo;
              });
  };
  return React.createElement("div", {
              className: "relative"
            }, React.createElement(ReactSlick, {
                  dots: false,
                  infinite: true,
                  slidesToShow: 1,
                  slidesToScroll: 1,
                  autoplay: true,
                  autoplaySpeed: 5000,
                  arrows: true,
                  nextArrow: React.createElement(ShopMain_MainBanner_Buyer$PC$NextBtn, {}),
                  prevArrow: React.createElement(ShopMain_MainBanner_Buyer$PC$PrevBtn, {}),
                  children: mainBanners.length !== 0 ? Belt_Array.map(mainBanners, (function (param) {
                            var key = "main-banner-" + param.id;
                            var target = param.isNewTabPc ? "_blank" : "_self";
                            return React.createElement("a", {
                                        key: key,
                                        href: param.landingUrl,
                                        target: target
                                      }, React.createElement("img", {
                                            className: "w-full aspect-[920/396] mb-[-7px] object-cover",
                                            alt: key,
                                            src: param.imageUrlPc
                                          }));
                          })) : React.createElement(ShopMain_MainBanner_Buyer$PC$Placeholder, {}),
                  afterChange: afterChange
                }), React.createElement(ShopMain_MainBanner_Buyer$PC$PageIndex, {
                  total: total,
                  current: current
                }), React.createElement(ShopMain_MainBanner_Buyer$PC$Dots, {
                  total: total,
                  current: current
                }));
}

var PC = {
  PrevBtn: PrevBtn,
  NextBtn: NextBtn,
  PageIndex: PageIndex,
  Dots: Dots,
  Placeholder: Placeholder,
  make: ShopMain_MainBanner_Buyer$PC
};

function ShopMain_MainBanner_Buyer$MO$Placeholder(Props) {
  return React.createElement("div", {
              className: "w-full aspect-[320/164] animate-pulse rounded-lg bg-gray-150"
            });
}

var Placeholder$1 = {
  make: ShopMain_MainBanner_Buyer$MO$Placeholder
};

function ShopMain_MainBanner_Buyer$MO$PageIndex(Props) {
  var total = Props.total;
  var current = Props.current;
  return React.createElement("div", {
              className: "absolute bottom-3 right-3 rounded-full bg-gray-800 bg-opacity-20 px-2 py-0.5 flex items-center justify-center"
            }, React.createElement("span", {
                  className: "text-white text-2xs"
                }, String(current + 1 | 0) + " / " + String(total)));
}

var PageIndex$1 = {
  make: ShopMain_MainBanner_Buyer$MO$PageIndex
};

function ShopMain_MainBanner_Buyer$MO$Dots(Props) {
  var total = Props.total;
  var current = Props.current;
  return React.createElement("div", {
              className: "absolute left-1/2 bottom-3 translate-x-[-50%] flex items-center gap-[6px]"
            }, Belt_Array.map(Belt_Array.range(0, total - 1 | 0), (function (idx) {
                    var style = current === idx ? "w-[6px] h-[6px] rounded-full bg-white bg-opacity-70" : "w-[6px] h-[6px] rounded-full bg-white bg-opacity-50";
                    return React.createElement("div", {
                                key: "banner-dot-" + String(idx),
                                className: style
                              });
                  })));
}

var Dots$1 = {
  make: ShopMain_MainBanner_Buyer$MO$Dots
};

function ShopMain_MainBanner_Buyer$MO(Props) {
  var query = Props.query;
  var match = use(query);
  var mainBanners = match.mainBanners;
  var total = mainBanners.length;
  var match$1 = React.useState(function () {
        return 0;
      });
  var setCurrent = match$1[1];
  var current = match$1[0];
  var afterChange = function (changedTo) {
    return setCurrent(function (param) {
                return changedTo;
              });
  };
  return React.createElement("div", {
              className: "relative"
            }, React.createElement(ReactSlick, {
                  dots: false,
                  infinite: true,
                  slidesToShow: 1,
                  slidesToScroll: 1,
                  autoplay: true,
                  autoplaySpeed: 5000,
                  arrows: false,
                  children: mainBanners.length !== 0 ? Belt_Array.map(mainBanners, (function (param) {
                            var key = "main-banner-" + param.id;
                            var target = param.isNewTabMobile ? "_blank" : "_self";
                            return React.createElement("a", {
                                        key: key,
                                        href: param.landingUrl,
                                        target: target
                                      }, React.createElement("img", {
                                            className: "w-full aspect-[320/164] mb-[-7px] object-cover",
                                            alt: key,
                                            src: param.imageUrlMobile
                                          }));
                          })) : React.createElement(ShopMain_MainBanner_Buyer$MO$Placeholder, {}),
                  afterChange: afterChange
                }), React.createElement(ShopMain_MainBanner_Buyer$MO$PageIndex, {
                  total: total,
                  current: current
                }), React.createElement(ShopMain_MainBanner_Buyer$MO$Dots, {
                  total: total,
                  current: current
                }));
}

var MO = {
  Placeholder: Placeholder$1,
  PageIndex: PageIndex$1,
  Dots: Dots$1,
  make: ShopMain_MainBanner_Buyer$MO
};

export {
  arrowWhiteLeftIcon ,
  Fragment ,
  PC ,
  MO ,
  
}
/* arrowWhiteLeftIcon Not a pure module */
