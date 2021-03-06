// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Js_dict from "rescript/lib/es6/js_dict.js";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as ReactDeviceDetect from "react-device-detect";

function detectDeviceFromCtx(ctx) {
  var selector = Belt_Option.map(Belt_Option.mapWithDefault(Belt_Option.mapWithDefault(Belt_Option.mapWithDefault(ctx, undefined, (function (param) {
                      return Js_dict.get(param, "req");
                    })), undefined, (function (param) {
                  return Js_dict.get(param, "headers");
                })), undefined, (function (param) {
              return Js_dict.get(param, "user-agent");
            })), (function (prim) {
          return ReactDeviceDetect.getSelectorsByUserAgent(prim);
        }));
  if (selector === undefined) {
    return /* Unknown */0;
  }
  var isMobile = selector.isMobile;
  if (isMobile === true) {
    return /* Mobile */2;
  } else if (isMobile === false) {
    return /* PC */1;
  } else {
    return /* Unknown */0;
  }
}

function detectDevice(param) {
  if (ReactDeviceDetect.isMobile) {
    return /* Mobile */2;
  } else {
    return /* PC */1;
  }
}

export {
  detectDeviceFromCtx ,
  detectDevice ,
  
}
/* react-device-detect Not a pure module */
