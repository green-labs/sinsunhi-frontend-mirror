// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import * as Router from "next/router";
import * as PLP_DisplayCategory_Buyer from "./plp/PLP_DisplayCategory_Buyer.mjs";

function ShopProducts_Buyer(Props) {
  var router = Router.useRouter();
  React.useEffect((function () {
          router.replace("/buyer/products");
          
        }), []);
  return React.createElement(PLP_DisplayCategory_Buyer.Placeholder.make, {});
}

var make = ShopProducts_Buyer;

export {
  make ,
  
}
/* react Not a pure module */
