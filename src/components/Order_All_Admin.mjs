// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import * as Locale from "../utils/Locale.mjs";
import * as Js_json from "rescript/lib/es6/js_json.js";
import * as Checkbox from "./common/Checkbox.mjs";
import * as Skeleton from "./Skeleton.mjs";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as CustomHooks from "../utils/CustomHooks.mjs";

function formatDate(d) {
  return Locale.DateTime.formatFromUTC(new Date(d), "yyyy/MM/dd");
}

function Order_All_Admin$Item$Table(Props) {
  var order = Props.order;
  return React.createElement(React.Fragment, undefined, React.createElement("li", {
                  className: "grid grid-cols-9-admin-orders-all text-gray-700"
                }, React.createElement("div", {
                      className: "h-full flex flex-col px-4 py-2"
                    }, React.createElement("span", {
                          className: "block text-gray-400 mb-1"
                        }, String(order.no))), React.createElement("div", {
                      className: "h-full flex flex-col px-4 py-2"
                    }, React.createElement("span", {
                          className: "block text-gray-400 mb-1"
                        }, formatDate(order.orderDate))), React.createElement("div", {
                      className: "h-full flex flex-col px-4 py-2"
                    }, React.createElement("span", {
                          className: "block mb-1"
                        }, Belt_Option.getWithDefault(Js_json.decodeString(CustomHooks.OrdersAllAdmin.orderType_encode(order.orderType)), "-"))), React.createElement("div", {
                      className: "h-full flex flex-col px-4 py-2"
                    }, React.createElement("span", {
                          className: "block mb-1"
                        }, Belt_Option.getWithDefault(order.producerName, "-"))), React.createElement("div", {
                      className: "h-full flex flex-col px-4 py-2"
                    }, React.createElement("span", {
                          className: "block mb-1"
                        }, Belt_Option.getWithDefault(order.buyerName, "-"))), React.createElement("div", {
                      className: "h-full flex flex-col px-4 py-2"
                    }, React.createElement("span", {
                          className: "block mb-1"
                        }, order.productCategory)), React.createElement("div", undefined, React.createElement("span", {
                          className: "whitespace-nowrap"
                        }, Locale.Float.show(undefined, order.totalPrice, 0) + "원")), React.createElement("div", {
                      className: "h-full flex flex-col px-4 py-2"
                    }, React.createElement("span", {
                          className: "block text-gray-400 mb-1"
                        }, Belt_Option.getWithDefault(order.orderNo, "-"))), React.createElement("div", {
                      className: "h-full flex flex-col px-4 py-2"
                    }, React.createElement("span", {
                          className: "block"
                        }, order.productName), React.createElement("span", {
                          className: "block"
                        }, Belt_Option.getWithDefault(order.productOptionName, "")))));
}

function Order_All_Admin$Item$Table$Loading(Props) {
  return React.createElement("li", {
              className: "grid grid-cols-10-gl-admin"
            }, React.createElement("div", {
                  className: "h-full flex flex-col px-4 py-2"
                }, React.createElement(Checkbox.make, {})), React.createElement("div", {
                  className: "h-full flex flex-col px-4 py-2"
                }, React.createElement(Skeleton.Box.make, {
                      className: "w-20"
                    }), React.createElement(Skeleton.Box.make, {}), React.createElement(Skeleton.Box.make, {
                      className: "w-12"
                    })), React.createElement("div", {
                  className: "h-full flex flex-col px-4 py-2"
                }, React.createElement(Skeleton.Box.make, {}), React.createElement(Skeleton.Box.make, {})), React.createElement("div", {
                  className: "h-full flex flex-col px-4 py-2"
                }, React.createElement(Skeleton.Box.make, {}), React.createElement(Skeleton.Box.make, {
                      className: "w-2/3"
                    }), React.createElement(Skeleton.Box.make, {
                      className: "w-8"
                    })), React.createElement("div", {
                  className: "h-full flex flex-col px-4 py-2"
                }, React.createElement(Skeleton.Box.make, {})), React.createElement("div", {
                  className: "h-full flex flex-col px-4 py-2"
                }, React.createElement(Skeleton.Box.make, {})), React.createElement("div", {
                  className: "h-full flex flex-col px-4 py-2"
                }, React.createElement(Skeleton.Box.make, {}), React.createElement(Skeleton.Box.make, {})), React.createElement("div", {
                  className: "h-full flex flex-col px-4 py-2"
                }, React.createElement(Skeleton.Box.make, {}), React.createElement(Skeleton.Box.make, {
                      className: "w-2/3"
                    }), React.createElement(Skeleton.Box.make, {
                      className: "w-1/3"
                    })), React.createElement("div", {
                  className: "p-2 pr-4 align-top"
                }, React.createElement(Skeleton.Box.make, {
                      className: "w-1/2"
                    }), React.createElement(Skeleton.Box.make, {})), React.createElement("div", {
                  className: "h-full flex flex-col px-4 py-2"
                }, React.createElement(Skeleton.Box.make, {})));
}

var Loading = {
  make: Order_All_Admin$Item$Table$Loading
};

var Table = {
  make: Order_All_Admin$Item$Table,
  Loading: Loading
};

var Item = {
  Table: Table
};

function Order_All_Admin(Props) {
  var order = Props.order;
  return React.createElement(Order_All_Admin$Item$Table, {
              order: order
            });
}

var make = Order_All_Admin;

export {
  formatDate ,
  Item ,
  make ,
  
}
/* react Not a pure module */