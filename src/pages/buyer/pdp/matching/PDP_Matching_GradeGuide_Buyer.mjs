// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import * as Divider from "../../../../components/common/Divider.mjs";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import ReactNl2br from "react-nl2br";
import * as Js_null_undefined from "rescript/lib/es6/js_null_undefined.js";
import * as Hooks from "react-relay/hooks";
import * as ReactTabs from "@radix-ui/react-tabs";
import * as RescriptRelay_Internal from "rescript-relay/src/RescriptRelay_Internal.mjs";
import * as ReactSeparator from "@radix-ui/react-separator";
import * as PDPMatchingGradeGuideBuyer_fragment_graphql from "../../../../__generated__/PDPMatchingGradeGuideBuyer_fragment_graphql.mjs";

function use(fRef) {
  var data = Hooks.useFragment(PDPMatchingGradeGuideBuyer_fragment_graphql.node, fRef);
  return RescriptRelay_Internal.internal_useConvertedValue(PDPMatchingGradeGuideBuyer_fragment_graphql.Internal.convertFragment, data);
}

function useOpt(opt_fRef) {
  var fr = opt_fRef !== undefined ? Caml_option.some(Caml_option.valFromOption(opt_fRef)) : undefined;
  var nullableFragmentData = Hooks.useFragment(PDPMatchingGradeGuideBuyer_fragment_graphql.node, fr !== undefined ? Js_null_undefined.fromOption(Caml_option.some(Caml_option.valFromOption(fr))) : null);
  var data = (nullableFragmentData == null) ? undefined : Caml_option.some(nullableFragmentData);
  return RescriptRelay_Internal.internal_useConvertedValue((function (rawFragment) {
                if (rawFragment !== undefined) {
                  return PDPMatchingGradeGuideBuyer_fragment_graphql.Internal.convertFragment(rawFragment);
                }
                
              }), data);
}

var Fragment = {
  Types: undefined,
  use: use,
  useOpt: useOpt
};

function PDP_Matching_GradeGuide_Buyer$Banner(Props) {
  return React.createElement("section", {
              className: "w-full"
            }, React.createElement("div", {
                  className: "w-full bg-[#F4F9F9] px-4 pt-10 pb-16 "
                }, React.createElement("div", {
                      className: "text-[26px] font-bold text-gray-800"
                    }, React.createElement("h1", undefined, React.createElement("span", {
                              className: "text-primary"
                            }, "신선하이"), " 등급으로"), React.createElement("h1", undefined, "필요한 정보를 한눈에")), React.createElement("div", {
                      className: "mt-3"
                    }, React.createElement("span", {
                          className: "text-gray-800 text-sm"
                        }, ReactNl2br("고객의 구매 목적을 고려한 신선하이 등급을 통해\n상품의 품질별 시세의 흐름을 한눈에 파악할 수 있습니다.")))));
}

var Banner = {
  make: PDP_Matching_GradeGuide_Buyer$Banner
};

function PDP_Matching_GradeGuide_Buyer$Tab(Props) {
  var label = Props.label;
  var value = Props.value;
  var isSelected = Props.isSelected;
  var btnStyle = isSelected ? "text-gray-800 border-b-[2px] border-gray-800 font-bold pt-2 pb-3 whitespace-nowrap flex flex-1 items-center justify-center" : "text-gray-400 border-b-[2px] border-transparent pt-2 pb-3 whitespace-nowrap flex flex-1 items-center justify-center";
  return React.createElement(ReactTabs.Trigger, {
              children: React.createElement("span", undefined, label),
              value: value,
              className: btnStyle
            });
}

var Tab = {
  make: PDP_Matching_GradeGuide_Buyer$Tab
};

function PDP_Matching_GradeGuide_Buyer$Content(Props) {
  var value = Props.value;
  var description = Props.description;
  var sugar = Props.sugar;
  var perSize = Props.perSize;
  var perRegularity = Props.perRegularity;
  var color = Props.color;
  var freshness = Props.freshness;
  var fault = Props.fault;
  var length = Props.length;
  var foreignMatter = Props.foreignMatter;
  var shape = Props.shape;
  var trimming = Props.trimming;
  return React.createElement(ReactTabs.Content, {
              children: null,
              value: value
            }, React.createElement("section", {
                  className: "w-full px-4 py-8"
                }, React.createElement("span", {
                      className: "text-base text-black"
                    }, description)), React.createElement("section", {
                  className: "px-4"
                }, React.createElement(Divider.make, {
                      className: "h-[2px] bg-gray-100"
                    })), React.createElement("section", {
                  className: "w-full px-4 divide-y divide-dashed pb-14"
                }, Belt_Option.mapWithDefault(sugar, null, (function (sugar$p) {
                        return React.createElement("div", {
                                    className: "w-full flex py-4"
                                  }, React.createElement("div", {
                                        className: "w-16"
                                      }, "당도"), React.createElement("div", {
                                        className: "ml-5 w-full"
                                      }, ReactNl2br(sugar$p)));
                      })), Belt_Option.mapWithDefault(perSize, null, (function (perSize$p) {
                        return React.createElement("div", {
                                    className: "w-full flex py-4"
                                  }, React.createElement("div", {
                                        className: "w-16"
                                      }, "낱개 크기"), React.createElement("div", {
                                        className: "ml-5 w-full"
                                      }, ReactNl2br(perSize$p)));
                      })), Belt_Option.mapWithDefault(perRegularity, null, (function (perRegularity$p) {
                        return React.createElement("div", {
                                    className: "w-full flex py-4"
                                  }, React.createElement("div", {
                                        className: "w-16"
                                      }, "낱개 고르기"), React.createElement("div", {
                                        className: "ml-5 w-full"
                                      }, ReactNl2br(perRegularity$p)));
                      })), Belt_Option.mapWithDefault(length, null, (function (length$p) {
                        return React.createElement("div", {
                                    className: "w-full flex py-4"
                                  }, React.createElement("div", {
                                        className: "w-16"
                                      }, "길이"), React.createElement("div", {
                                        className: "ml-5 w-full"
                                      }, ReactNl2br(length$p)));
                      })), Belt_Option.mapWithDefault(shape, null, (function (shape$p) {
                        return React.createElement("div", {
                                    className: "w-full flex py-4"
                                  }, React.createElement("div", {
                                        className: "w-16"
                                      }, "모양"), React.createElement("div", {
                                        className: "ml-5 w-full"
                                      }, ReactNl2br(shape$p)));
                      })), Belt_Option.mapWithDefault(trimming, null, (function (trimming$p) {
                        return React.createElement("div", {
                                    className: "w-full flex py-4"
                                  }, React.createElement("div", {
                                        className: "w-16"
                                      }, "손질"), React.createElement("div", {
                                        className: "ml-5 w-full"
                                      }, ReactNl2br(trimming$p)));
                      })), Belt_Option.mapWithDefault(color, null, (function (color$p) {
                        return React.createElement("div", {
                                    className: "w-full flex py-4"
                                  }, React.createElement("div", {
                                        className: "w-16"
                                      }, "색택"), React.createElement("div", {
                                        className: "ml-5 w-full"
                                      }, ReactNl2br(color$p)));
                      })), Belt_Option.mapWithDefault(freshness, null, (function (freshness$p) {
                        return React.createElement("div", {
                                    className: "w-full flex py-4"
                                  }, React.createElement("div", {
                                        className: "w-16"
                                      }, "신선도"), React.createElement("div", {
                                        className: "ml-5 w-full"
                                      }, ReactNl2br(freshness$p)));
                      })), Belt_Option.mapWithDefault(fault, null, (function (fault$p) {
                        return React.createElement("div", {
                                    className: "w-full flex py-4"
                                  }, React.createElement("div", {
                                        className: "w-16"
                                      }, "결점"), React.createElement("div", {
                                        className: "ml-5 w-full"
                                      }, ReactNl2br(fault$p)));
                      })), Belt_Option.mapWithDefault(foreignMatter, null, (function (foreignMatter$p) {
                        return React.createElement("div", {
                                    className: "w-full flex py-4"
                                  }, React.createElement("div", {
                                        className: "w-16"
                                      }, "이물"), React.createElement("div", {
                                        className: "ml-5 w-full"
                                      }, ReactNl2br(foreignMatter$p)));
                      }))));
}

var Content = {
  make: PDP_Matching_GradeGuide_Buyer$Content
};

function PDP_Matching_GradeGuide_Buyer$Divider(Props) {
  var className = Props.className;
  var tmp = {};
  if (className !== undefined) {
    tmp.className = className;
  }
  return React.createElement(ReactSeparator.Root, tmp);
}

var Divider$1 = {
  make: PDP_Matching_GradeGuide_Buyer$Divider
};

function PDP_Matching_GradeGuide_Buyer(Props) {
  var query = Props.query;
  var match = use(query);
  var match$1 = match.qualityStandard;
  var low = match$1.low;
  var medium = match$1.medium;
  var high = match$1.high;
  var match$2 = React.useState(function () {
        return "high";
      });
  var setSelectedTab = match$2[1];
  var selectedTab = match$2[0];
  return React.createElement(React.Fragment, undefined, React.createElement(PDP_Matching_GradeGuide_Buyer$Banner, {}), React.createElement(ReactTabs.Root, {
                  children: null,
                  defaultValue: "high",
                  onValueChange: (function (selected) {
                      return setSelectedTab(function (param) {
                                  return selected;
                                });
                    })
                }, React.createElement(ReactTabs.List, {
                      children: null,
                      className: "mt-6 w-full h-11 flex items-center justify-between px-4"
                    }, React.createElement(PDP_Matching_GradeGuide_Buyer$Tab, {
                          label: "가격 상위 그룹",
                          value: "high",
                          isSelected: selectedTab === "high"
                        }), React.createElement(PDP_Matching_GradeGuide_Buyer$Tab, {
                          label: "가격 중위 그룹",
                          value: "medium",
                          isSelected: selectedTab === "medium"
                        }), React.createElement(PDP_Matching_GradeGuide_Buyer$Tab, {
                          label: "가격 하위 그룹",
                          value: "low",
                          isSelected: selectedTab === "low"
                        })), React.createElement(PDP_Matching_GradeGuide_Buyer$Divider, {
                      className: "h-[1px] bg-gray-50 m-0"
                    }), React.createElement(PDP_Matching_GradeGuide_Buyer$Content, {
                      value: "high",
                      description: high.description,
                      sugar: high.sugar,
                      perSize: high.perSize,
                      perRegularity: high.perRegularity,
                      color: high.color,
                      freshness: high.freshness,
                      fault: high.fault,
                      length: high.length,
                      foreignMatter: high.foreignMatter,
                      shape: high.shape,
                      trimming: high.trimming
                    }), React.createElement(PDP_Matching_GradeGuide_Buyer$Content, {
                      value: "medium",
                      description: medium.description,
                      sugar: medium.sugar,
                      perSize: medium.perSize,
                      perRegularity: medium.perRegularity,
                      color: medium.color,
                      freshness: medium.freshness,
                      fault: medium.fault,
                      length: medium.length,
                      foreignMatter: medium.foreignMatter,
                      shape: medium.shape,
                      trimming: medium.trimming
                    }), React.createElement(PDP_Matching_GradeGuide_Buyer$Content, {
                      value: "low",
                      description: low.description,
                      sugar: low.sugar,
                      perSize: low.perSize,
                      perRegularity: low.perRegularity,
                      color: low.color,
                      freshness: low.freshness,
                      fault: low.fault,
                      length: low.length,
                      foreignMatter: low.foreignMatter,
                      shape: low.shape,
                      trimming: low.trimming
                    })));
}

var make = PDP_Matching_GradeGuide_Buyer;

export {
  Fragment ,
  Banner ,
  Tab ,
  Content ,
  Divider$1 as Divider,
  make ,
  
}
/* react Not a pure module */