// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import Head from "next/head";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Router from "next/router";
import * as Header_Buyer from "../components/Header_Buyer.mjs";
import * as IconNotFound from "../components/svgs/IconNotFound.mjs";

function parsePath(path) {
  switch (path) {
    case "admin" :
        return /* Admin */2;
    case "buyer" :
        return /* Buyer */1;
    case "seller" :
        return /* Seller */0;
    default:
      return ;
  }
}

function getFirstPath(pathname) {
  return Belt_Array.get(pathname.split("/"), 1);
}

function NotFound$Buyer(Props) {
  return React.createElement("div", {
              className: "w-screen h-screen flex flex-col items-center justify-start"
            }, React.createElement(Header_Buyer.PC.make, {}), React.createElement("div", {
                  className: "flex flex-col h-full items-center justify-center"
                }, React.createElement(IconNotFound.make, {
                      width: "160",
                      height: "160"
                    }), React.createElement("h1", {
                      className: "mt-7 text-3xl text-gray-800"
                    }, "페이지를 찾을 수 없습니다."), React.createElement("span", {
                      className: "mt-7 text-gray-800"
                    }, "페이지가 존재하지 않거나 사용할 수 없는 페이지입니다."), React.createElement("span", {
                      className: "text-gray-800"
                    }, "입력하신 주소가 정확한지 다시 한 번 확인해주세요.")));
}

var Buyer = {
  make: NotFound$Buyer
};

function NotFound$Default(Props) {
  return React.createElement("div", {
              className: "w-screen h-screen flex items-center justify-center"
            }, React.createElement("div", {
                  className: "flex flex-col items-center justify-center"
                }, React.createElement(IconNotFound.make, {
                      width: "160",
                      height: "160"
                    }), React.createElement("h1", {
                      className: "mt-7 text-3xl text-gray-800"
                    }, "페이지를 찾을 수 없습니다."), React.createElement("span", {
                      className: "mt-7 text-gray-800"
                    }, "페이지가 존재하지 않거나 사용할 수 없는 페이지입니다."), React.createElement("span", {
                      className: "text-gray-800"
                    }, "입력하신 주소가 정확한지 다시 한 번 확인해주세요.")));
}

var Default = {
  make: NotFound$Default
};

function NotFound$Container(Props) {
  var router = Router.useRouter();
  var service = Belt_Option.flatMap(getFirstPath(router.asPath), parsePath);
  if (service !== undefined) {
    if (service !== 1) {
      return React.createElement(NotFound$Default, {});
    } else {
      return React.createElement(NotFound$Buyer, {});
    }
  } else {
    return React.createElement(NotFound$Default, {});
  }
}

var Container = {
  make: NotFound$Container
};

function NotFound(Props) {
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
                }), match[0] ? React.createElement(NotFound$Container, {}) : null);
}

var make = NotFound;

export {
  parsePath ,
  getFirstPath ,
  Buyer ,
  Default ,
  Container ,
  make ,
}
/* react Not a pure module */
