// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import * as DS_TitleList from "../element/DS_TitleList.mjs";

function DS_None$Default(Props) {
  var message = Props.message;
  return React.createElement("section", {
              className: "relative container max-w-3xl mx-auto min-h-screen sm:shadow-gl bg-gray-50"
            }, React.createElement("div", {
                  className: "px-5 pt-8"
                }, React.createElement(DS_TitleList.Left.TitleSubtitle1.make, {
                      title1: message
                    })));
}

var Default = {
  make: DS_None$Default
};

export {
  Default ,
  
}
/* react Not a pure module */
