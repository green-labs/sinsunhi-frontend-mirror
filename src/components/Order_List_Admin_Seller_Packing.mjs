// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import * as Constants from "../constants/Constants.mjs";
import * as ErrorPanel from "./common/ErrorPanel.mjs";
import * as Pagination from "./common/Pagination.mjs";
import * as CustomHooks from "../utils/CustomHooks.mjs";
import * as EmptyOrders from "./common/EmptyOrders.mjs";
import * as Garter_Array from "@greenlabs/garter/src/Garter_Array.mjs";
import * as Order_Admin_Seller_Packing from "./Order_Admin_Seller_Packing.mjs";

function Order_List_Admin_Seller_Packing$Header(Props) {
  return React.createElement("div", {
              className: "grid grid-cols-11-gl-admin bg-gray-100 text-gray-500 h-12"
            }, React.createElement("div", {
                  className: "h-full px-4 flex items-center whitespace-nowrap"
                }, "생산자명·바이어명"), React.createElement("div", {
                  className: "h-full px-4 flex items-center whitespace-nowrap"
                }, "요청일"), React.createElement("div", {
                  className: "h-full px-4 flex items-center whitespace-nowrap"
                }, "상품번호"), React.createElement("div", {
                  className: "h-full px-4 flex items-center whitespace-nowrap"
                }, "주문번호"), React.createElement("div", {
                  className: "h-full px-4 flex items-center whitespace-nowrap"
                }, "택배사명·송장번호"), React.createElement("div", {
                  className: "h-full px-4 flex items-center whitespace-nowrap"
                }, "상품명·옵션·수량"), React.createElement("div", {
                  className: "h-full px-4 flex items-center whitespace-nowrap"
                }, "수취인·연락처"), React.createElement("div", {
                  className: "h-full px-4 flex items-center whitespace-nowrap"
                }, "가격정보"), React.createElement("div", {
                  className: "h-full px-4 flex items-center pr-4 whitespace-nowrap"
                }, "주소·우편번호"), React.createElement("div", {
                  className: "h-full px-4 flex items-center pr-4 whitespace-nowrap"
                }, "주문자명·연락처"), React.createElement("div", {
                  className: "h-full px-4 flex items-center whitespace-nowrap"
                }, "배송메세지"));
}

var Header = {
  make: Order_List_Admin_Seller_Packing$Header
};

function Order_List_Admin_Seller_Packing$Loading(Props) {
  return React.createElement("div", {
              className: "w-full overflow-x-scroll"
            }, React.createElement("div", {
                  className: "min-w-max text-sm divide-y divide-gray-100"
                }, React.createElement(Order_List_Admin_Seller_Packing$Header, {}), React.createElement("ol", {
                      className: "divide-y divide-gray-100 lg:list-height-admin-seller lg:overflow-y-scroll"
                    }, Garter_Array.map(Garter_Array.make(5, 0), (function (param) {
                            return React.createElement(Order_Admin_Seller_Packing.Item.Loading.make, {});
                          })))));
}

var Loading = {
  make: Order_List_Admin_Seller_Packing$Loading
};

function Order_List_Admin_Seller_Packing(Props) {
  var status = Props.status;
  if (typeof status === "number") {
    return React.createElement(Order_List_Admin_Seller_Packing$Loading, {});
  }
  if (status.TAG !== /* Loaded */0) {
    return React.createElement(ErrorPanel.make, {
                error: status._0,
                renderOnRetry: React.createElement(Order_List_Admin_Seller_Packing$Loading, {})
              });
  }
  var orders$p = CustomHooks.OrdersAdmin.orders_decode(status._0);
  var tmp;
  if (orders$p.TAG === /* Ok */0) {
    var orders$p$1 = orders$p._0;
    tmp = React.createElement("ol", {
          className: "divide-y divide-gray-100 lg:list-height-admin-seller lg:overflow-y-scroll"
        }, orders$p$1.data.length !== 0 ? Garter_Array.map(orders$p$1.data, (function (order) {
                  return React.createElement(Order_Admin_Seller_Packing.make, {
                              order: order,
                              key: order.orderProductNo
                            });
                })) : React.createElement(EmptyOrders.make, {}));
  } else {
    console.log(orders$p._0);
    tmp = null;
  }
  var tmp$1;
  if (typeof status === "number" || status.TAG !== /* Loaded */0) {
    tmp$1 = null;
  } else {
    var orders$p$2 = CustomHooks.OrdersAdmin.orders_decode(status._0);
    if (orders$p$2.TAG === /* Ok */0) {
      var orders$p$3 = orders$p$2._0;
      tmp$1 = React.createElement("div", {
            className: "flex justify-center pt-5"
          }, React.createElement(Pagination.make, {
                pageDisplySize: Constants.pageDisplySize,
                itemPerPage: orders$p$3.limit,
                total: orders$p$3.count
              }));
    } else {
      tmp$1 = null;
    }
  }
  return React.createElement(React.Fragment, undefined, React.createElement("div", {
                  className: "w-full overflow-x-scroll"
                }, React.createElement("div", {
                      className: "min-w-max text-sm divide-y divide-gray-100"
                    }, React.createElement(Order_List_Admin_Seller_Packing$Header, {}), tmp)), tmp$1);
}

var make = Order_List_Admin_Seller_Packing;

export {
  Header ,
  Loading ,
  make ,
  
}
/* react Not a pure module */