// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import * as Constants from "../constants/Constants.mjs";
import * as ErrorPanel from "./common/ErrorPanel.mjs";
import * as Pagination from "./common/Pagination.mjs";
import * as CustomHooks from "../utils/CustomHooks.mjs";
import * as EmptyOrders from "./common/EmptyOrders.mjs";
import * as Order_Admin from "./Order_Admin.mjs";
import * as Garter_Array from "@greenlabs/garter/src/Garter_Array.mjs";
import * as Order_All_Admin from "./Order_All_Admin.mjs";

function Order_All_List_Admin_Buyer$Header(Props) {
  return React.createElement("div", {
              className: "grid grid-cols-9-admin-orders-all bg-gray-100 text-gray-500 h-12"
            }, React.createElement("div", {
                  className: "h-full px-4 flex items-center whitespace-nowrap"
                }, "번호"), React.createElement("div", {
                  className: "h-full px-4 flex items-center whitespace-nowrap"
                }, "주문일자"), React.createElement("div", {
                  className: "h-full px-4 flex items-center whitespace-nowrap"
                }, "거래유형"), React.createElement("div", {
                  className: "h-full px-4 flex items-center whitespace-nowrap"
                }, "생산자명"), React.createElement("div", {
                  className: "h-full px-4 flex items-center whitespace-nowrap"
                }, "바이어명"), React.createElement("div", {
                  className: "h-full px-4 flex items-center whitespace-nowrap"
                }, "품목"), React.createElement("div", {
                  className: "h-full px-4 flex items-center whitespace-nowrap"
                }, "판매금액"), React.createElement("div", {
                  className: "h-full px-4 flex items-center whitespace-nowrap"
                }, "주문번호"), React.createElement("div", {
                  className: "h-full px-4 flex items-center whitespace-nowrap"
                }, "주문상품"));
}

var Header = {
  make: Order_All_List_Admin_Buyer$Header
};

function Order_All_List_Admin_Buyer$Loading(Props) {
  return React.createElement("div", {
              className: "w-full overflow-x-scroll"
            }, React.createElement("div", {
                  className: "min-w-max text-sm divide-y divide-gray-100"
                }, React.createElement(Order_All_List_Admin_Buyer$Header, {}), React.createElement("ol", {
                      className: "divide-y divide-gray-100 lg:list-height-admin-buyer lg:overflow-y-scroll"
                    }, Garter_Array.map(Garter_Array.make(5, 0), (function (param) {
                            return React.createElement(Order_Admin.Item.Table.Loading.make, {});
                          })))));
}

var Loading = {
  make: Order_All_List_Admin_Buyer$Loading
};

function Order_All_List_Admin_Buyer(Props) {
  var status = Props.status;
  if (typeof status === "number") {
    return React.createElement(Order_All_List_Admin_Buyer$Loading, {});
  }
  if (status.TAG !== /* Loaded */0) {
    return React.createElement(ErrorPanel.make, {
                error: status._0,
                renderOnRetry: React.createElement(Order_All_List_Admin_Buyer$Loading, {})
              });
  }
  var orders$p = CustomHooks.OrdersAllAdmin.orders_decode(status._0);
  var tmp;
  if (orders$p.TAG === /* Ok */0) {
    var orders$p$1 = orders$p._0;
    tmp = React.createElement("ol", {
          className: "divide-y divide-gray-100 lg:list-height-admin-buyer lg:overflow-y-scroll"
        }, orders$p$1.data.length !== 0 ? Garter_Array.map(orders$p$1.data, (function (order) {
                  return React.createElement(Order_All_Admin.make, {
                              order: order,
                              key: String(order.no)
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
    var orders$p$2 = CustomHooks.OrdersAllAdmin.orders_decode(status._0);
    if (orders$p$2.TAG === /* Ok */0) {
      var orders$p$3 = orders$p$2._0;
      tmp$1 = React.createElement("div", {
            className: "flex justify-center pt-5"
          }, null, React.createElement(Pagination.make, {
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
                    }, React.createElement(Order_All_List_Admin_Buyer$Header, {}), tmp)), tmp$1);
}

var make = Order_All_List_Admin_Buyer;

export {
  Header ,
  Loading ,
  make ,
  
}
/* react Not a pure module */
