// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as Js_dict from "rescript/lib/es6/js_dict.js";
import * as IconClose from "../../../../components/svgs/IconClose.mjs";
import * as Router from "next/router";
import ReactNl2br from "react-nl2br";
import * as ShopDialog_Buyer from "../../ShopDialog_Buyer.mjs";
import * as ReactDialog from "@radix-ui/react-dialog";
import * as ReactScrollArea from "@radix-ui/react-scroll-area";
import * as PDP_Matching_GradeGuide_Buyer from "./PDP_Matching_GradeGuide_Buyer.mjs";

function PDP_Matching_Modals_Buyer$GradeGuide$Scroll(Props) {
  var children = Props.children;
  return React.createElement(ReactScrollArea.Root, {
              children: null,
              className: "h-screen flex flex-col overflow-hidden"
            }, React.createElement(ReactScrollArea.Viewport, {
                  children: children,
                  className: "w-full h-full"
                }), React.createElement(ReactScrollArea.Scrollbar, {
                  children: React.createElement(ReactScrollArea.Thumb, {})
                }));
}

var Scroll = {
  make: PDP_Matching_Modals_Buyer$GradeGuide$Scroll
};

function PDP_Matching_Modals_Buyer$GradeGuide$GredeGuideHeader(Props) {
  var closeFn = Props.closeFn;
  return React.createElement("section", {
              className: "w-full h-14 flex items-center px-4"
            }, React.createElement("div", {
                  className: "w-10 h-10"
                }), React.createElement("div", {
                  className: "flex flex-1 items-center justify-center"
                }, React.createElement("h1", {
                      className: "font-bold text-black"
                    }, "신선하이 등급")), React.createElement("button", {
                  className: "w-10 h-10 flex items-center justify-center ",
                  onClick: closeFn
                }, React.createElement(IconClose.make, {
                      height: "24",
                      width: "24",
                      fill: "#262626"
                    })));
}

var GredeGuideHeader = {
  make: PDP_Matching_Modals_Buyer$GradeGuide$GredeGuideHeader
};

function PDP_Matching_Modals_Buyer$GradeGuide(Props) {
  var show = Props.show;
  var closeFn = Props.closeFn;
  var query = Props.query;
  var _open = show && !show._0 ? true : false;
  return React.createElement(ReactDialog.Root, {
              children: React.createElement(ReactDialog.Portal, {
                    children: null
                  }, React.createElement(ReactDialog.Overlay, {
                        className: "dialog-overlay"
                      }), React.createElement(ReactDialog.Content, {
                        children: React.createElement(PDP_Matching_Modals_Buyer$GradeGuide$Scroll, {
                              children: null
                            }, React.createElement(PDP_Matching_Modals_Buyer$GradeGuide$GredeGuideHeader, {
                                  closeFn: closeFn
                                }), React.createElement(PDP_Matching_GradeGuide_Buyer.make, {
                                  query: query
                                })),
                        className: "dialog-content-base w-full max-w-[768px] min-h-screen"
                      })),
              open: _open
            });
}

var GradeGuide = {
  Scroll: Scroll,
  GredeGuideHeader: GredeGuideHeader,
  make: PDP_Matching_Modals_Buyer$GradeGuide
};

function PDP_Matching_Modals_Buyer$Unauthorized(Props) {
  var show = Props.show;
  var closeFn = Props.closeFn;
  var router = Router.useRouter();
  var match;
  if (show) {
    var message = show._0;
    match = message ? [
        /* Show */0,
        message._0
      ] : [
        /* Hide */1,
        ""
      ];
  } else {
    match = [
      /* Hide */1,
      ""
    ];
  }
  return React.createElement(ShopDialog_Buyer.Mo.make, {
              isShow: match[0],
              confirmText: "로그인",
              cancelText: "취소",
              onConfirm: (function (param) {
                  var redirectUrl = new URLSearchParams(Js_dict.fromArray([[
                                "redirect",
                                router.asPath
                              ]])).toString();
                  router.push("/buyer/signin?" + redirectUrl);
                  
                }),
              onCancel: (function (param) {
                  return Curry._1(closeFn, undefined);
                }),
              children: React.createElement("div", {
                    className: "h-18 mt-8 px-8 py-6 flex flex-col items-center justify-center text-lg text-text-L1"
                  }, React.createElement("span", {
                        className: "text-center"
                      }, ReactNl2br(match[1])))
            });
}

var Unauthorized = {
  make: PDP_Matching_Modals_Buyer$Unauthorized
};

function PDP_Matching_Modals_Buyer$MO(Props) {
  var show = Props.show;
  var setShow = Props.setShow;
  var query = Props.query;
  var closeFn = function (param) {
    return setShow(function (param) {
                return /* Hide */0;
              });
  };
  return React.createElement(React.Fragment, undefined, React.createElement(PDP_Matching_Modals_Buyer$GradeGuide, {
                  show: show,
                  closeFn: closeFn,
                  query: query
                }), React.createElement(PDP_Matching_Modals_Buyer$Unauthorized, {
                  show: show,
                  closeFn: closeFn
                }));
}

var MO = {
  make: PDP_Matching_Modals_Buyer$MO
};

export {
  GradeGuide ,
  Unauthorized ,
  MO ,
  
}
/* react Not a pure module */
