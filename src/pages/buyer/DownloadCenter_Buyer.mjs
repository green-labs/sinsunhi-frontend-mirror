// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Authorization from "../../utils/Authorization.mjs";
import * as DownloadCenter_Render from "../../components/DownloadCenter_Render.mjs";

function DownloadCenter_Buyer$Layout(Props) {
  var children = Props.children;
  return React.createElement("div", {
              className: "sm:px-20 py-4"
            }, Belt_Option.getWithDefault(children, null), React.createElement("footer", {
                  className: "w-full flex flex-row items-center justify-center py-7 text-text-L3 "
                }, "ⓒ Copyright Greenlabs All Reserved. (주)그린랩스"));
}

var Layout = {
  make: DownloadCenter_Buyer$Layout
};

function DownloadCenter_Buyer(Props) {
  return React.createElement(Authorization.Buyer.make, {
              children: React.createElement(DownloadCenter_Render.make, {
                    children: React.createElement(DownloadCenter_Buyer$Layout, {})
                  }),
              title: "다운로드 센터"
            });
}

var make = DownloadCenter_Buyer;

export {
  Layout ,
  make ,
  
}
/* react Not a pure module */
