// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as Js_dict from "rescript/lib/es6/js_dict.js";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as ChannelTalk from "../../../../bindings/ChannelTalk.mjs";
import * as CustomHooks from "../../../../utils/CustomHooks.mjs";
import * as Router from "next/router";

function PDP_Matching_Submit_Buyer$MO$CTAContainer(Props) {
  var children = Props.children;
  return React.createElement("div", {
              className: "fixed w-full bottom-0 left-0"
            }, React.createElement("div", {
                  className: "w-full max-w-[768px] p-3 mx-auto border-t border-t-gray-100 bg-white"
                }, React.createElement("div", {
                      className: "w-full h-14 flex"
                    }, React.createElement("button", {
                          onClick: (function (param) {
                              return ChannelTalk.showMessenger(undefined);
                            })
                        }, React.createElement("img", {
                              className: "w-14 h-14 mr-2",
                              alt: "cta-cs-btn-mobile",
                              src: "/icons/cs-gray-square.png"
                            })), Belt_Option.getWithDefault(children, null))));
}

var CTAContainer = {
  make: PDP_Matching_Submit_Buyer$MO$CTAContainer
};

function PDP_Matching_Submit_Buyer$MO(Props) {
  var setShowModal = Props.setShowModal;
  var selectedGroup = Props.selectedGroup;
  var buttonText = "최저가 견적받기";
  var router = Router.useRouter();
  var pid = Js_dict.get(router.query, "pid");
  var user = Curry._1(CustomHooks.User.Buyer.use2, undefined);
  var btnStyle = "h-14 w-full rounded-xl bg-primary text-white text-lg font-bold";
  var disabledStyle = "h-14 w-full rounded-xl bg-disabled-L2 text-white text-lg font-bold";
  return React.createElement(PDP_Matching_Submit_Buyer$MO$CTAContainer, {
              children: typeof user === "number" ? (
                  user !== 0 ? React.createElement("button", {
                          className: btnStyle,
                          onClick: (function (param) {
                              return setShowModal(function (param) {
                                          return /* Show */{
                                                  _0: /* Unauthorized */{
                                                    _0: "로그인 후에\n견적을 받으실 수 있습니다."
                                                  }
                                                };
                                        });
                            })
                        }, buttonText) : React.createElement("button", {
                          className: disabledStyle,
                          disabled: true
                        }, buttonText)
                ) : (
                  user._0.role !== 1 ? React.createElement("button", {
                          className: disabledStyle,
                          disabled: true
                        }, buttonText) : React.createElement("button", {
                          className: btnStyle,
                          onClick: (function (param) {
                              Belt_Option.map(pid, (function (pid$p) {
                                      var prim1_pathname = "/buyer/tradematch/ask-to-buy/apply/" + pid$p;
                                      var prim1_query = Js_dict.fromArray([[
                                              "grade",
                                              selectedGroup
                                            ]]);
                                      var prim1 = {
                                        pathname: prim1_pathname,
                                        query: prim1_query
                                      };
                                      router.push(prim1);
                                      
                                    }));
                              
                            })
                        }, buttonText)
                )
            });
}

var MO = {
  CTAContainer: CTAContainer,
  make: PDP_Matching_Submit_Buyer$MO
};

export {
  MO ,
  
}
/* react Not a pure module */
