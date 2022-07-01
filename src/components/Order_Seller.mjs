// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Env from "../constants/Env.mjs";
import * as Swr from "swr";
import * as Badge from "./Badge.mjs";
import * as Curry from "rescript/lib/es6/curry.js";
import * as Input from "./common/Input.mjs";
import * as React from "react";
import * as Dialog from "./common/Dialog.mjs";
import * as Helper from "../utils/Helper.mjs";
import * as Locale from "../utils/Locale.mjs";
import * as Period from "../utils/Period.mjs";
import * as Checkbox from "./common/Checkbox.mjs";
import * as IconCheck from "./svgs/IconCheck.mjs";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Belt_Result from "rescript/lib/es6/belt_Result.js";
import * as CustomHooks from "../utils/CustomHooks.mjs";
import * as FetchHelper from "../utils/FetchHelper.mjs";
import * as ReactEvents from "../utils/ReactEvents.mjs";
import * as Router from "next/router";
import * as Select_Courier from "./Select_Courier.mjs";
import * as Tracking_Buyer from "./Tracking_Buyer.mjs";
import * as ReactToastNotifications from "react-toast-notifications";
import * as Order_Detail_Button_Buyer_Seller from "./Order_Detail_Button_Buyer_Seller.mjs";

function formatDate(d) {
  return Locale.DateTime.formatFromUTC(new Date(d), "yyyy/MM/dd");
}

function formatTime(d) {
  return Locale.DateTime.formatFromUTC(new Date(d), "HH:mm");
}

function Order_Seller$Item$Table(Props) {
  var order = Props.order;
  var courierCode = Props.courierCode;
  var setCourier = Props.setCourier;
  var invoice = Props.invoice;
  var onChangeInvoice = Props.onChangeInvoice;
  var onSubmitInvoice = Props.onSubmitInvoice;
  var check = Props.check;
  var onCheckOrder = Props.onCheckOrder;
  var onClickPacking = Props.onClickPacking;
  var match = React.useState(function () {
        return /* Hide */1;
      });
  var setShowPackingConfirm = match[1];
  var status = CustomHooks.Courier.use(undefined);
  var courierName;
  if (typeof status === "number") {
    courierName = "-";
  } else if (status.TAG === /* Loaded */0) {
    var couriers = status._0;
    courierName = Belt_Option.getWithDefault(Belt_Option.map(Belt_Option.flatMap(order.courierCode, (function (courierCode$p) {
                    return Belt_Result.getWithDefault(Belt_Result.map(CustomHooks.Courier.response_decode(couriers), (function (couriers$p) {
                                      return Belt_Array.getBy(couriers$p.data, (function (courier) {
                                                    return courier.code === courierCode$p;
                                                  }));
                                    })), undefined);
                  })), (function (courier) {
                return courier.name;
              })), "-");
  } else {
    courierName = "-";
  }
  var match$1 = order.status;
  var isDisabedCheckbox = match$1 !== 0;
  var isDisabledSubmitButton = courierCode !== undefined && invoice !== undefined ? invoice === "" : true;
  var match$2 = order.status;
  var tmp;
  var exit = 0;
  switch (match$2) {
    case /* CREATE */0 :
        tmp = React.createElement("button", {
              className: "max-w-min p-2 bg-green-gl text-white rounded-md whitespace-nowrap focus:outline-none focus:ring-2 focus:ring-green-gl focus:ring-offset-1 focus:ring-opacity-100",
              onClick: (function (param) {
                  return setShowPackingConfirm(function (param) {
                              return /* Show */0;
                            });
                })
            }, "상품준비중 처리");
        break;
    case /* PACKING */1 :
    case /* DEPARTURE */2 :
    case /* DELIVERING */3 :
    case /* ERROR */6 :
        exit = 1;
        break;
    case /* COMPLETE */4 :
    case /* CANCEL */5 :
    case /* REFUND */7 :
    case /* NEGOTIATING */8 :
        exit = 2;
        break;
    
  }
  switch (exit) {
    case 1 :
        var match$3 = order.invoice;
        tmp = React.createElement(React.Fragment, undefined, React.createElement(Select_Courier.make, {
                  courierCode: courierCode,
                  setCourier: setCourier
                }), React.createElement("div", {
                  className: "flex mt-1"
                }, React.createElement("label", {
                      className: "block flex-auto"
                    }, React.createElement(Input.make, {
                          type_: "text",
                          name: "invoice-number",
                          placeholder: "송장번호입력",
                          value: Belt_Option.getWithDefault(invoice, ""),
                          onChange: onChangeInvoice,
                          size: /* Small */2,
                          error: undefined
                        })), match$3 !== undefined ? React.createElement("button", {
                        className: "py-1 px-2 rounded-md bg-gray-300 text-white ml-1 whitespace-nowrap",
                        type: "button",
                        onClick: onSubmitInvoice
                      }, "수정") : React.createElement("button", {
                        className: isDisabledSubmitButton ? "py-1 px-2 rounded-md bg-gray-button-gl text-gray-gl ml-1 whitespace-nowrap" : "py-1 px-2 rounded-md bg-green-gl text-white ml-1 whitespace-nowrap",
                        disabled: isDisabledSubmitButton,
                        type: "button",
                        onClick: onSubmitInvoice
                      }, "등록")));
        break;
    case 2 :
        tmp = React.createElement(React.Fragment, undefined, React.createElement("span", {
                  className: "block"
                }, courierName), React.createElement("span", {
                  className: "block text-gray-500"
                }, Belt_Option.getWithDefault(order.invoice, "-")), React.createElement(Tracking_Buyer.make, {
                  order: order
                }));
        break;
    
  }
  var match$4 = order.deliveryType;
  var tmp$1;
  var exit$1 = 0;
  if (match$4 === 0) {
    tmp$1 = React.createElement("span", {
          className: "block"
        }, "-");
  } else {
    exit$1 = 1;
  }
  if (exit$1 === 1) {
    tmp$1 = React.createElement(React.Fragment, undefined, React.createElement("span", {
              className: "block"
            }, Belt_Option.getWithDefault(order.receiverName, "-")), React.createElement("span", {
              className: "block text-gray-500"
            }, Belt_Option.getWithDefault(Belt_Option.flatMap(Helper.PhoneNumber.parse(Belt_Option.getWithDefault(order.receiverPhone, "-")), Helper.PhoneNumber.format), Belt_Option.getWithDefault(order.receiverPhone, "-"))));
  }
  var match$5 = order.deliveryType;
  var tmp$2;
  var exit$2 = 0;
  if (match$5 === 0) {
    tmp$2 = React.createElement("span", {
          className: "block"
        }, "-");
  } else {
    exit$2 = 1;
  }
  if (exit$2 === 1) {
    tmp$2 = React.createElement(React.Fragment, undefined, React.createElement("span", {
              className: "block"
            }, Belt_Option.getWithDefault(order.receiverZipcode, "-")));
  }
  return React.createElement(React.Fragment, undefined, React.createElement("li", {
                  className: "hidden lg:grid lg:grid-cols-11-gl-seller text-gray-700"
                }, React.createElement("div", {
                      className: "h-full flex flex-col px-4 py-2"
                    }, React.createElement(Checkbox.make, {
                          id: "checkbox-" + order.orderProductNo,
                          checked: Curry._1(check, order.orderProductNo),
                          onChange: Curry._1(onCheckOrder, order.orderProductNo),
                          disabled: isDisabedCheckbox
                        })), React.createElement("div", {
                      className: "h-full flex flex-col px-4 py-2"
                    }, React.createElement("span", {
                          className: "block font-bold"
                        }, formatDate(order.orderDate)), React.createElement("span", {
                          className: "block font-bold text-gray-400"
                        }, formatTime(order.orderDate))), React.createElement("div", {
                      className: "h-full py-2 pl-4 align-top"
                    }, React.createElement("span", {
                          className: "block mb-2"
                        }, String(order.productId) + " · " + order.productSku), React.createElement("span", {
                          className: "block"
                        }, React.createElement(Badge.make, {
                              status: order.status
                            }))), React.createElement("div", {
                      className: "h-full flex flex-col px-4 py-2"
                    }, React.createElement(Order_Detail_Button_Buyer_Seller.make, {
                          order: order
                        })), React.createElement("div", {
                      className: "h-full flex flex-col px-4 py-2"
                    }, tmp), React.createElement("div", {
                      className: "h-full flex flex-col px-4 py-2"
                    }, React.createElement("span", {
                          className: "block"
                        }, order.productName), React.createElement("span", {
                          className: "block"
                        }, Belt_Option.getWithDefault(order.productOptionName, "")), React.createElement("span", {
                          className: "block text-gray-500"
                        }, String(order.quantity))), React.createElement("div", {
                      className: "h-full flex flex-col px-4 py-2"
                    }, tmp$1), React.createElement("div", {
                      className: "h-full flex flex-col px-4 py-2 whitespace-nowrap"
                    }, Locale.Float.show(undefined, order.productPrice, 0) + "원"), React.createElement("div", {
                      className: "h-full flex flex-col px-4 py-2"
                    }, tmp$2), React.createElement("div", {
                      className: "h-full flex flex-col px-4 py-2 whitespace-nowrap"
                    }, React.createElement("span", {
                          className: "block"
                        }, Belt_Option.getWithDefault(order.ordererName, "")), React.createElement("span", {
                          className: "block"
                        }, Belt_Option.getWithDefault(order.ordererPhone, ""))), React.createElement("div", {
                      className: "h-full flex flex-col px-4 py-2"
                    }, React.createElement("span", {
                          className: "block line-clamp-2"
                        }, Belt_Option.getWithDefault(order.deliveryMessage, "-")))), React.createElement(Dialog.make, {
                  isShow: match[0],
                  children: React.createElement("p", {
                        className: "text-black-gl text-center whitespace-pre-wrap"
                      }, "선택한 주문을 상품준비중으로 변경하시겠습니까?"),
                  onCancel: (function (param) {
                      return setShowPackingConfirm(function (param) {
                                  return /* Hide */1;
                                });
                    }),
                  onConfirm: (function (param) {
                      setShowPackingConfirm(function (param) {
                            return /* Hide */1;
                          });
                      return Curry._1(onClickPacking, [order.orderProductNo]);
                    }),
                  textOnCancel: "취소",
                  textOnConfirm: "확인"
                }));
}

var Table = {
  make: Order_Seller$Item$Table
};

function Order_Seller$Item$Card(Props) {
  var order = Props.order;
  var courierCode = Props.courierCode;
  var setCourier = Props.setCourier;
  var invoice = Props.invoice;
  var onChangeInvoice = Props.onChangeInvoice;
  var onSubmitInvoice = Props.onSubmitInvoice;
  var onClickPacking = Props.onClickPacking;
  var match = React.useState(function () {
        return /* Hide */1;
      });
  var setShowPackingConfirm = match[1];
  var status = CustomHooks.Courier.use(undefined);
  var courierName;
  if (typeof status === "number") {
    courierName = "-";
  } else if (status.TAG === /* Loaded */0) {
    var couriers = status._0;
    courierName = Belt_Option.getWithDefault(Belt_Option.map(Belt_Option.flatMap(order.courierCode, (function (courierCode$p) {
                    return Belt_Result.getWithDefault(Belt_Result.map(CustomHooks.Courier.response_decode(couriers), (function (couriers$p) {
                                      return Belt_Array.getBy(couriers$p.data, (function (courier) {
                                                    return courier.code === courierCode$p;
                                                  }));
                                    })), undefined);
                  })), (function (courier) {
                return courier.name;
              })), "-");
  } else {
    courierName = "-";
  }
  var isDisabledSubmitButton = courierCode !== undefined && invoice !== undefined ? invoice === "" : true;
  var match$1 = order.status;
  var tmp;
  if (match$1 !== 0) {
    var match$2 = order.invoice;
    tmp = React.createElement(React.Fragment, undefined, React.createElement("div", {
              className: "flex"
            }, React.createElement("span", {
                  className: "w-20 text-gray-gl"
                }, "택배사명"), React.createElement("span", {
                  className: "flex-1"
                }, React.createElement(Select_Courier.make, {
                      courierCode: courierCode,
                      setCourier: setCourier
                    }))), React.createElement("div", {
              className: "flex-1 flex mt-1"
            }, React.createElement("span", {
                  className: "w-20 text-gray-gl"
                }, "송장번호"), React.createElement("div", {
                  className: "flex-1 flex"
                }, React.createElement("label", {
                      className: "block flex-auto"
                    }, React.createElement(Input.make, {
                          type_: "text",
                          name: "invoice-number",
                          placeholder: "송장번호입력",
                          value: Belt_Option.getWithDefault(invoice, ""),
                          onChange: onChangeInvoice,
                          size: /* Large */0,
                          error: undefined
                        })), match$2 !== undefined ? React.createElement("button", {
                        className: "h-full px-4 rounded-xl bg-gray-300 text-white font-bold ml-1 whitespace-nowrap",
                        type: "button",
                        onClick: onSubmitInvoice
                      }, "수정") : React.createElement("button", {
                        className: isDisabledSubmitButton ? "h-full px-4 rounded-xl bg-gray-gl text-gray-gl font-bold ml-1 whitespace-nowrap" : "h-full px-4 rounded-xl bg-green-gl text-white font-bold ml-1 whitespace-nowrap",
                        disabled: isDisabledSubmitButton,
                        type: "button",
                        onClick: onSubmitInvoice
                      }, "등록"))));
  } else {
    tmp = React.createElement(React.Fragment, undefined, React.createElement("div", {
              className: "flex"
            }, React.createElement("span", {
                  className: "w-20 text-gray-gl"
                }, "택배사명"), React.createElement("span", {
                  className: "ml-2"
                }, courierName)), React.createElement("div", {
              className: "flex-1 flex mt-1"
            }, React.createElement("span", {
                  className: "w-20 text-gray-gl"
                }, "송장번호"), React.createElement("button", {
                  className: "flex-1 py-3 px-3 bg-green-gl text-white rounded-lg whitespace-nowrap text-base font-bold",
                  type: "button",
                  onClick: (function (param) {
                      return setShowPackingConfirm(function (param) {
                                  return /* Show */0;
                                });
                    })
                }, "상품준비중 처리")));
  }
  var match$3 = order.deliveryType;
  var tmp$1;
  var exit = 0;
  if (match$3 === 0) {
    tmp$1 = React.createElement(React.Fragment, undefined, React.createElement("div", {
              className: "flex"
            }, React.createElement("span", {
                  className: "w-20 text-gray-gl"
                }, "수취인"), React.createElement("span", {
                  className: "ml-2"
                }, "-")), React.createElement("div", {
              className: "flex mt-2"
            }, React.createElement("span", {
                  className: "w-20 text-gray-gl"
                }, "연락처"), React.createElement("span", {
                  className: "ml-2"
                }, "-")), React.createElement("div", {
              className: "flex mt-2"
            }, React.createElement("span", {
                  className: "w-20 text-gray-gl"
                }, "주소"), React.createElement("span", {
                  className: "flex-1 ml-2"
                }, "-")), React.createElement("div", {
              className: "flex mt-2"
            }, React.createElement("span", {
                  className: "w-20 text-gray-gl"
                }, "우편번호"), React.createElement("span", {
                  className: "ml-2"
                }, "-")));
  } else {
    exit = 1;
  }
  if (exit === 1) {
    tmp$1 = React.createElement(React.Fragment, undefined, React.createElement("div", {
              className: "flex"
            }, React.createElement("span", {
                  className: "w-20 text-gray-gl"
                }, "수취인"), React.createElement("span", {
                  className: "ml-2"
                }, Belt_Option.getWithDefault(order.receiverName, "-"))), React.createElement("div", {
              className: "flex mt-2"
            }, React.createElement("span", {
                  className: "w-20 text-gray-gl"
                }, "연락처"), React.createElement("span", {
                  className: "ml-2"
                }, Belt_Option.getWithDefault(order.receiverPhone, "-"))), React.createElement("div", {
              className: "flex mt-2"
            }, React.createElement("span", {
                  className: "w-20 text-gray-gl"
                }, "주소"), React.createElement("span", {
                  className: "flex-1 ml-2"
                }, Belt_Option.getWithDefault(order.receiverAddress, "-"))), React.createElement("div", {
              className: "flex mt-2"
            }, React.createElement("span", {
                  className: "w-20 text-gray-gl"
                }, "우편번호"), React.createElement("span", {
                  className: "ml-2"
                }, Belt_Option.getWithDefault(order.receiverZipcode, "-"))));
  }
  return React.createElement(React.Fragment, undefined, React.createElement("li", {
                  className: "py-7 px-5 lg:hidden text-black-gl"
                }, React.createElement("section", {
                      className: "flex justify-between items-start text-base"
                    }, React.createElement("div", undefined, React.createElement("span", {
                              className: "font-bold mr-1"
                            }, formatDate(order.orderDate)), formatTime(order.orderDate)), React.createElement(Badge.make, {
                          status: order.status
                        })), React.createElement("section", {
                      className: "divide-y divide-gray-100"
                    }, React.createElement("div", {
                          className: "py-3"
                        }, React.createElement("div", {
                              className: "flex"
                            }, React.createElement("span", {
                                  className: "w-20 text-gray-gl"
                                }, "상품번호"), React.createElement("span", {
                                  className: "ml-2"
                                }, String(order.productId))), React.createElement("div", {
                              className: "flex mt-2"
                            }, React.createElement("span", {
                                  className: "w-20 text-gray-gl"
                                }, "옵션번호"), React.createElement("span", {
                                  className: "ml-2"
                                }, order.productSku)), React.createElement("div", {
                              className: "flex mt-2"
                            }, React.createElement("span", {
                                  className: "w-20 text-gray-gl"
                                }, "주문번호"), React.createElement("span", {
                                  className: "ml-2"
                                }, React.createElement(Order_Detail_Button_Buyer_Seller.make, {
                                      order: order
                                    })))), React.createElement("div", {
                          className: "py-3"
                        }, tmp), React.createElement("div", {
                          className: "py-3"
                        }, React.createElement("div", {
                              className: "flex"
                            }, React.createElement("span", {
                                  className: "w-20 text-gray-gl"
                                }, "상품명"), React.createElement("span", {
                                  className: "ml-2"
                                }, order.productName)), React.createElement("div", {
                              className: "flex mt-2"
                            }, React.createElement("span", {
                                  className: "w-20 text-gray-gl"
                                }, "옵션"), React.createElement("span", {
                                  className: "ml-2"
                                }, Belt_Option.getWithDefault(order.productOptionName, "-"))), React.createElement("div", {
                              className: "flex mt-2"
                            }, React.createElement("span", {
                                  className: "w-20 text-gray-gl"
                                }, "수량"), React.createElement("span", {
                                  className: "ml-2"
                                }, String(order.quantity))), React.createElement("div", {
                              className: "flex mt-2"
                            }, React.createElement("span", {
                                  className: "w-20 text-gray-gl"
                                }, "가격정보"), React.createElement("span", {
                                  className: "ml-2"
                                }, Locale.Float.show(undefined, order.productPrice, 0) + "원"))), React.createElement("div", {
                          className: "py-3"
                        }, tmp$1), React.createElement("div", {
                          className: "py-3"
                        }, React.createElement("div", {
                              className: "flex"
                            }, React.createElement("span", {
                                  className: "w-20 text-gray-gl"
                                }, "배송메세지"), React.createElement("span", {
                                  className: "ml-2"
                                }, Belt_Option.getWithDefault(order.deliveryMessage, ""))), React.createElement("div", {
                              className: "flex mt-2"
                            }, React.createElement("span", {
                                  className: "w-20 text-gray-gl"
                                }, "주문자명"), React.createElement("span", {
                                  className: "ml-2"
                                }, Belt_Option.getWithDefault(order.ordererName, ""))), React.createElement("div", {
                              className: "flex mt-2"
                            }, React.createElement("span", {
                                  className: "w-20 text-gray-gl"
                                }, "연락처"), React.createElement("span", {
                                  className: "flex-1 ml-2"
                                }, Belt_Option.getWithDefault(order.ordererPhone, "")))))), React.createElement(Dialog.make, {
                  isShow: match[0],
                  children: React.createElement("p", {
                        className: "text-black-gl text-center whitespace-pre-wrap"
                      }, "선택한 주문을 상품준비중으로 변경하시겠습니까?"),
                  onCancel: (function (param) {
                      return setShowPackingConfirm(function (param) {
                                  return /* Hide */1;
                                });
                    }),
                  onConfirm: (function (param) {
                      setShowPackingConfirm(function (param) {
                            return /* Hide */1;
                          });
                      return Curry._1(onClickPacking, [order.orderProductNo]);
                    }),
                  textOnCancel: "취소",
                  textOnConfirm: "확인"
                }));
}

var Card = {
  make: Order_Seller$Item$Card
};

var Item = {
  Table: Table,
  Card: Card
};

function Order_Seller(Props) {
  var order = Props.order;
  var check = Props.check;
  var onCheckOrder = Props.onCheckOrder;
  var onClickPacking = Props.onClickPacking;
  var router = Router.useRouter();
  var match = Swr.useSWRConfig();
  var mutate = match.mutate;
  var match$1 = ReactToastNotifications.useToasts();
  var addToast = match$1.addToast;
  var match$2 = CustomHooks.useInvoice(order.invoice);
  var handleOnChangeInvoice = match$2[1];
  var invoice = match$2[0];
  var match$3 = React.useState(function () {
        return order.courierCode;
      });
  var setCourier = match$3[1];
  var courierCode = match$3[0];
  var match$4 = React.useState(function () {
        return /* Hide */1;
      });
  var setShowErrorPostCourierInvoiceNo = match$4[1];
  var postCourierInvoiceNo = function (param) {
    return ReactEvents.interceptingHandler((function (param) {
                  Helper.$$Option.map2(courierCode, invoice, (function (courierCode$p, invoice$p) {
                          return Belt_Option.map(JSON.stringify({
                                          list: [{
                                              "order-product-number": order.orderProductNo,
                                              invoice: invoice$p,
                                              "courier-code": courierCode$p
                                            }]
                                        }), (function (body) {
                                        return FetchHelper.requestWithRetry(FetchHelper.postWithToken, Env.restApiUrl + "/order/invoices", body, 3, (function (param) {
                                                      addToast(React.createElement("div", {
                                                                className: "flex items-center"
                                                              }, React.createElement(IconCheck.make, {
                                                                    height: "24",
                                                                    width: "24",
                                                                    fill: "#12B564",
                                                                    className: "mr-2"
                                                                  }), "송장번호가 입력되었습니다"), {
                                                            appearance: "success"
                                                          });
                                                      mutate(Env.restApiUrl + "/order?" + new URLSearchParams(router.query).toString(), undefined, undefined);
                                                      return mutate(Env.restApiUrl + "/order/summary?" + Period.currentPeriod(router), undefined, undefined);
                                                    }), (function (param) {
                                                      return setShowErrorPostCourierInvoiceNo(function (param) {
                                                                  return /* Show */0;
                                                                });
                                                    }));
                                      }));
                        }));
                  
                }), param);
  };
  return React.createElement(React.Fragment, undefined, React.createElement(Order_Seller$Item$Table, {
                  order: order,
                  courierCode: courierCode,
                  setCourier: setCourier,
                  invoice: invoice,
                  onChangeInvoice: handleOnChangeInvoice,
                  onSubmitInvoice: postCourierInvoiceNo,
                  check: check,
                  onCheckOrder: onCheckOrder,
                  onClickPacking: onClickPacking
                }), React.createElement(Order_Seller$Item$Card, {
                  order: order,
                  courierCode: courierCode,
                  setCourier: setCourier,
                  invoice: invoice,
                  onChangeInvoice: handleOnChangeInvoice,
                  onSubmitInvoice: postCourierInvoiceNo,
                  onClickPacking: onClickPacking
                }), React.createElement(Dialog.make, {
                  isShow: match$4[0],
                  children: React.createElement("p", {
                        className: "text-gray-500 text-center whitespace-pre-wrap"
                      }, "송장번호 저장에 실패하였습니다."),
                  onConfirm: (function (param) {
                      return setShowErrorPostCourierInvoiceNo(function (param) {
                                  return /* Hide */1;
                                });
                    })
                }));
}

var make = Order_Seller;

export {
  formatDate ,
  formatTime ,
  Item ,
  make ,
  
}
/* Env Not a pure module */
