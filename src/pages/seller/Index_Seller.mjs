// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import Head from "next/head";
import * as Router from "next/router";

function Index_Seller(Props) {
  var router = Router.useRouter();
  React.useEffect(function () {
        router.replace("/seller/orders?status=CREATE&sort=created");
        
      });
  return React.createElement(React.Fragment, undefined, React.createElement(Head, {
                  children: React.createElement("title", undefined, "생산자 - 신선하이")
                }), React.createElement("div", {
                  className: "container mx-auto flex justify-center items-center h-screen"
                }, "페이지 전환 중 입니다."));
}

var make = Index_Seller;

export {
  make ,
  
}
/* react Not a pure module */