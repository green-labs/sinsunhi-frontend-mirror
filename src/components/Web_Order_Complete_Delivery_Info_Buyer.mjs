// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import * as Skeleton from "./Skeleton.mjs";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import Format from "date-fns/format";
import * as Js_null_undefined from "rescript/lib/es6/js_null_undefined.js";
import * as Hooks from "react-relay/hooks";
import SubMinutes from "date-fns/subMinutes";
import * as RescriptRelay_Internal from "rescript-relay/src/RescriptRelay_Internal.mjs";
import * as WebOrderCompleteDeliveryInfoBuyerFragment_graphql from "../__generated__/WebOrderCompleteDeliveryInfoBuyerFragment_graphql.mjs";

function use(fRef) {
  var data = Hooks.useFragment(WebOrderCompleteDeliveryInfoBuyerFragment_graphql.node, fRef);
  return RescriptRelay_Internal.internal_useConvertedValue(WebOrderCompleteDeliveryInfoBuyerFragment_graphql.Internal.convertFragment, data);
}

function useOpt(opt_fRef) {
  var fr = opt_fRef !== undefined ? Caml_option.some(Caml_option.valFromOption(opt_fRef)) : undefined;
  var nullableFragmentData = Hooks.useFragment(WebOrderCompleteDeliveryInfoBuyerFragment_graphql.node, fr !== undefined ? Js_null_undefined.fromOption(Caml_option.some(Caml_option.valFromOption(fr))) : null);
  var data = (nullableFragmentData == null) ? undefined : Caml_option.some(nullableFragmentData);
  return RescriptRelay_Internal.internal_useConvertedValue((function (rawFragment) {
                if (rawFragment !== undefined) {
                  return WebOrderCompleteDeliveryInfoBuyerFragment_graphql.Internal.convertFragment(rawFragment);
                }
                
              }), data);
}

var Fragment_wosDeliveryType_decode = WebOrderCompleteDeliveryInfoBuyerFragment_graphql.Utils.wosDeliveryType_decode;

var Fragment_wosDeliveryType_fromString = WebOrderCompleteDeliveryInfoBuyerFragment_graphql.Utils.wosDeliveryType_fromString;

var Fragment = {
  wosDeliveryType_decode: Fragment_wosDeliveryType_decode,
  wosDeliveryType_fromString: Fragment_wosDeliveryType_fromString,
  Types: undefined,
  use: use,
  useOpt: useOpt
};

function deliveryTypetoString(d) {
  if (d === "FREIGHT") {
    return "화물배송";
  } else if (d === "PARCEL") {
    return "택배배송";
  } else if (d === "SELF") {
    return "직접수령";
  } else {
    return "-";
  }
}

function Web_Order_Complete_Delivery_Info_Buyer$Placeholder(Props) {
  return React.createElement("section", {
              className: "flex flex-col gap-5 bg-white rounded-sm"
            }, React.createElement("span", {
                  className: "text-lg xl:text-xl text-enabled-L1 font-bold"
                }, "배송 정보"), React.createElement("ul", {
                  className: "flex flex-col"
                }, React.createElement("li", {
                      className: "flex gap-5"
                    }, React.createElement(Skeleton.Box.make, {
                          className: "w-18"
                        }), React.createElement(Skeleton.Box.make, {
                          className: "w-32"
                        })), React.createElement("li", {
                      className: "flex gap-5"
                    }, React.createElement(Skeleton.Box.make, {
                          className: "w-18"
                        }), React.createElement(Skeleton.Box.make, {
                          className: "w-32"
                        })), React.createElement("li", {
                      className: "flex gap-5"
                    }, React.createElement(Skeleton.Box.make, {
                          className: "w-18"
                        }), React.createElement(Skeleton.Box.make, {
                          className: "w-32"
                        })), React.createElement("li", {
                      className: "flex gap-5"
                    }, React.createElement(Skeleton.Box.make, {
                          className: "w-18"
                        }), React.createElement(Skeleton.Box.make, {
                          className: "w-32"
                        })), React.createElement("li", {
                      className: "flex gap-5"
                    }, React.createElement(Skeleton.Box.make, {
                          className: "w-18"
                        }), React.createElement(Skeleton.Box.make, {
                          className: "w-32"
                        })), React.createElement("li", {
                      className: "flex gap-5"
                    }, React.createElement(Skeleton.Box.make, {
                          className: "w-18"
                        }), React.createElement(Skeleton.Box.make, {
                          className: "w-32"
                        }))));
}

var Placeholder = {
  make: Web_Order_Complete_Delivery_Info_Buyer$Placeholder
};

function Web_Order_Complete_Delivery_Info_Buyer(Props) {
  var query = Props.query;
  var match = use(query);
  var toPhoneNumberForm = function (s) {
    return s.replace(/[^0-9]/g, "").replace(/(^1[0-9]{3}|^0[0-9]{2})([0-9]+)?([0-9]{4})$/, "$1-$2-$3").replace("--", "-");
  };
  var match$1 = Belt_Option.flatMap(match.wosOrder, (function (wosOrder$p) {
          return Belt_Array.get(wosOrder$p.orderProducts, 0);
        }));
  if (match$1 === undefined) {
    return React.createElement(Web_Order_Complete_Delivery_Info_Buyer$Placeholder, {});
  }
  var match$2 = Caml_option.valFromOption(match$1);
  if (match$2 === undefined) {
    return React.createElement(Web_Order_Complete_Delivery_Info_Buyer$Placeholder, {});
  }
  var deliveryMessage = match$2.deliveryMessage;
  var receiverAddress = match$2.receiverAddress;
  var receiverPhone = match$2.receiverPhone;
  var receiverName = match$2.receiverName;
  var deliveryDesiredDate = match$2.deliveryDesiredDate;
  var deliveryType = match$2.deliveryType;
  var tmp;
  if (deliveryType === "PARCEL" || deliveryDesiredDate === undefined) {
    tmp = null;
  } else {
    var timezone = new Date(Date.now()).getTimezoneOffset();
    tmp = React.createElement("li", {
          className: "flex"
        }, React.createElement("span", {
              className: "w-23 font-bold"
            }, "배송희망일"), React.createElement("span", undefined, Format(SubMinutes(new Date(deliveryDesiredDate), timezone), "yyyy-MM-dd")));
  }
  return React.createElement("section", {
              className: "flex flex-col gap-5 bg-white rounded-sm"
            }, React.createElement("span", {
                  className: "text-lg xl:text-xl text-enabled-L1 font-bold"
                }, "배송 정보"), React.createElement("ul", {
                  className: "flex flex-col text-sm gap-2"
                }, React.createElement("li", {
                      className: "flex"
                    }, React.createElement("span", {
                          className: "w-23 font-bold"
                        }, "배송방법"), React.createElement("span", undefined, deliveryTypetoString(deliveryType))), tmp, deliveryType === "SELF" || receiverName === undefined ? null : React.createElement("li", {
                        className: "flex"
                      }, React.createElement("span", {
                            className: "w-23 font-bold"
                          }, "이름"), React.createElement("span", {
                            className: "whitespace-pre-wrap"
                          }, receiverName)), deliveryType === "SELF" || receiverPhone === undefined ? null : React.createElement("li", {
                        className: "flex"
                      }, React.createElement("span", {
                            className: "w-23 font-bold"
                          }, "배송지 연락처"), React.createElement("span", undefined, toPhoneNumberForm(receiverPhone))), deliveryType === "SELF" || receiverAddress === undefined ? null : React.createElement("li", {
                        className: "flex"
                      }, React.createElement("span", {
                            className: "w-23 font-bold"
                          }, "배송지 주소"), React.createElement("span", {
                            className: "xl:w-64 w-56 whitespace-pre-wrap"
                          }, receiverAddress)), deliveryMessage !== undefined ? React.createElement("li", {
                        className: "flex"
                      }, React.createElement("span", {
                            className: "w-23 font-bold"
                          }, "배송 요청사항"), React.createElement("span", {
                            className: "xl:w-64 w-56 whitespace-pre-wrap"
                          }, deliveryMessage)) : null));
}

var make = Web_Order_Complete_Delivery_Info_Buyer;

export {
  Fragment ,
  deliveryTypetoString ,
  Placeholder ,
  make ,
  
}
/* react Not a pure module */
