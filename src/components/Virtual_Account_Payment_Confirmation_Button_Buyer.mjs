// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Cx from "rescript-classnames/src/Cx.mjs";
import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as Dialog from "./common/Dialog.mjs";
import * as Locale from "../utils/Locale.mjs";
import * as IconClose from "./svgs/IconClose.mjs";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as Js_promise from "rescript/lib/es6/js_promise.js";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as ReactRelay from "react-relay";
import * as RescriptRelay from "rescript-relay/src/RescriptRelay.mjs";
import * as RelayRuntime from "relay-runtime";
import Format from "date-fns/format";
import * as Webapi__Dom__Element from "rescript-webapi/src/Webapi/Dom/Webapi__Dom__Element.mjs";
import * as ReactDialog from "@radix-ui/react-dialog";
import * as RescriptRelay_Internal from "rescript-relay/src/RescriptRelay_Internal.mjs";
import * as RescriptReactErrorBoundary from "@rescript/react/src/RescriptReactErrorBoundary.mjs";
import * as VirtualAccountPaymentConfirmationButtonBuyerQuery_graphql from "../__generated__/VirtualAccountPaymentConfirmationButtonBuyerQuery_graphql.mjs";

function use(variables, fetchPolicy, fetchKey, networkCacheConfig, param) {
  var data = ReactRelay.useLazyLoadQuery(VirtualAccountPaymentConfirmationButtonBuyerQuery_graphql.node, RescriptRelay_Internal.internal_cleanObjectFromUndefinedRaw(VirtualAccountPaymentConfirmationButtonBuyerQuery_graphql.Internal.convertVariables(variables)), {
        fetchKey: fetchKey,
        fetchPolicy: RescriptRelay.mapFetchPolicy(fetchPolicy),
        networkCacheConfig: networkCacheConfig
      });
  return RescriptRelay_Internal.internal_useConvertedValue(VirtualAccountPaymentConfirmationButtonBuyerQuery_graphql.Internal.convertResponse, data);
}

function useLoader(param) {
  var match = ReactRelay.useQueryLoader(VirtualAccountPaymentConfirmationButtonBuyerQuery_graphql.node);
  var loadQueryFn = match[1];
  var loadQuery = React.useMemo((function () {
          return function (param, param$1, param$2, param$3) {
            return Curry._2(loadQueryFn, VirtualAccountPaymentConfirmationButtonBuyerQuery_graphql.Internal.convertVariables(param), {
                        fetchPolicy: param$1,
                        networkCacheConfig: param$2
                      });
          };
        }), [loadQueryFn]);
  return [
          Caml_option.nullable_to_opt(match[0]),
          loadQuery,
          match[2]
        ];
}

function $$fetch(environment, variables, onResult, networkCacheConfig, fetchPolicy, param) {
  ReactRelay.fetchQuery(environment, VirtualAccountPaymentConfirmationButtonBuyerQuery_graphql.node, VirtualAccountPaymentConfirmationButtonBuyerQuery_graphql.Internal.convertVariables(variables), {
          networkCacheConfig: networkCacheConfig,
          fetchPolicy: RescriptRelay.mapFetchQueryFetchPolicy(fetchPolicy)
        }).subscribe({
        next: (function (res) {
            Curry._1(onResult, {
                  TAG: /* Ok */0,
                  _0: VirtualAccountPaymentConfirmationButtonBuyerQuery_graphql.Internal.convertResponse(res)
                });
          }),
        error: (function (err) {
            Curry._1(onResult, {
                  TAG: /* Error */1,
                  _0: err
                });
          })
      });
}

function fetchPromised(environment, variables, networkCacheConfig, fetchPolicy, param) {
  var __x = ReactRelay.fetchQuery(environment, VirtualAccountPaymentConfirmationButtonBuyerQuery_graphql.node, VirtualAccountPaymentConfirmationButtonBuyerQuery_graphql.Internal.convertVariables(variables), {
          networkCacheConfig: networkCacheConfig,
          fetchPolicy: RescriptRelay.mapFetchQueryFetchPolicy(fetchPolicy)
        }).toPromise();
  return Js_promise.then_((function (res) {
                return Promise.resolve(VirtualAccountPaymentConfirmationButtonBuyerQuery_graphql.Internal.convertResponse(res));
              }), __x);
}

function usePreloaded(queryRef, param) {
  var data = ReactRelay.usePreloadedQuery(VirtualAccountPaymentConfirmationButtonBuyerQuery_graphql.node, queryRef);
  return RescriptRelay_Internal.internal_useConvertedValue(VirtualAccountPaymentConfirmationButtonBuyerQuery_graphql.Internal.convertResponse, data);
}

function retain(environment, variables) {
  var operationDescriptor = RelayRuntime.createOperationDescriptor(VirtualAccountPaymentConfirmationButtonBuyerQuery_graphql.node, VirtualAccountPaymentConfirmationButtonBuyerQuery_graphql.Internal.convertVariables(variables));
  return environment.retain(operationDescriptor);
}

var Query_paymentMethod_decode = VirtualAccountPaymentConfirmationButtonBuyerQuery_graphql.Utils.paymentMethod_decode;

var Query_paymentMethod_fromString = VirtualAccountPaymentConfirmationButtonBuyerQuery_graphql.Utils.paymentMethod_fromString;

var Query_paymentStatus_decode = VirtualAccountPaymentConfirmationButtonBuyerQuery_graphql.Utils.paymentStatus_decode;

var Query_paymentStatus_fromString = VirtualAccountPaymentConfirmationButtonBuyerQuery_graphql.Utils.paymentStatus_fromString;

var Query = {
  paymentMethod_decode: Query_paymentMethod_decode,
  paymentMethod_fromString: Query_paymentMethod_fromString,
  paymentStatus_decode: Query_paymentStatus_decode,
  paymentStatus_fromString: Query_paymentStatus_fromString,
  Operation: undefined,
  Types: undefined,
  use: use,
  useLoader: useLoader,
  $$fetch: $$fetch,
  fetchPromised: fetchPromised,
  usePreloaded: usePreloaded,
  retain: retain
};

var columnsWithWidth = [
  [
    "요청일시",
    "w-20"
  ],
  [
    "입금 은행·계좌번호",
    "w-32"
  ],
  [
    "금액",
    "w-32"
  ],
  [
    "기한",
    "w-20"
  ],
  [
    "입금상태",
    "w-20"
  ]
];

function formatDate(d) {
  return Format(new Date(d), "yyyy-MM-dd");
}

function formatTime(d) {
  return Format(new Date(d), "HH:mm:ss");
}

function Virtual_Account_Payment_Confirmation_Button_Buyer$TitleAndCloseButton(Props) {
  var close = Props.close;
  return React.createElement("div", {
              className: "flex mb-5 md:mb-10 justify-between items-center"
            }, React.createElement("h3", {
                  className: "font-bold text-xl"
                }, "가상계좌 결제 확인"), React.createElement("button", {
                  className: "cursor-pointer border-none",
                  onClick: (function (param) {
                      Curry._1(close, undefined);
                    })
                }, React.createElement(IconClose.make, {
                      height: "1.5rem",
                      width: "1.5rem",
                      fill: "#262626"
                    })));
}

var TitleAndCloseButton = {
  make: Virtual_Account_Payment_Confirmation_Button_Buyer$TitleAndCloseButton
};

function Virtual_Account_Payment_Confirmation_Button_Buyer$TableHead(Props) {
  return React.createElement("div", {
              className: "hidden md:flex md:bg-div-shape-L2 md:text-text-L2 md:rounded min-w-max"
            }, Belt_Array.map(columnsWithWidth, (function (param) {
                    var column = param[0];
                    return React.createElement("div", {
                                key: "head-" + column + "",
                                className: Cx.cx([
                                      "mr-5 first:ml-5 last:mr-0 py-1 md:py-2 text-center break-all",
                                      param[1]
                                    ])
                              }, column);
                  })));
}

var TableHead = {
  make: Virtual_Account_Payment_Confirmation_Button_Buyer$TableHead
};

function Virtual_Account_Payment_Confirmation_Button_Buyer$TableRow(Props) {
  var rowData = Props.rowData;
  var virtualAccount = rowData.virtualAccount;
  var id = rowData.id;
  var statusToString = function (status) {
    if (status === "COMPLETE") {
      return "완료";
    } else if (status === "FAILURE") {
      return "만료";
    } else {
      return "대기";
    }
  };
  var tmp;
  if (virtualAccount !== undefined) {
    var expiredAt = virtualAccount.expiredAt;
    var createdAt = virtualAccount.createdAt;
    tmp = React.createElement("div", {
          className: "flex flex-col md:flex-row md:justify-center md:items-center whitespace-pre md:h-16"
        }, React.createElement("div", {
              className: "mr-5 md:ml-5 md:text-center md:w-20 py-1 md:py-2"
            }, React.createElement("div", {
                  className: "flex md:flex-col"
                }, React.createElement("p", undefined, Format(new Date(createdAt), "yyyy-MM-dd")), React.createElement("p", {
                      className: "text-text-L2 ml-1 md:ml-0"
                    }, Format(new Date(createdAt), "HH:mm:ss")))), React.createElement("div", {
              className: "flex md:flex-col mr-5 md:text-center md:w-32 py-1 md:py-2"
            }, React.createElement("p", undefined, virtualAccount.bank.name), React.createElement("p", {
                  className: "ml-1 md:ml-0"
                }, virtualAccount.accountNo)), React.createElement("div", {
              className: "mr-5 md:text-right md:w-32 py-1 md:py-2"
            }, React.createElement("p", undefined, "" + Locale.Int.show(undefined, Belt_Option.getWithDefault(rowData.amount, 0)) + " 원")), React.createElement("div", {
              className: "mr-5 md:text-center md:w-20 py-1 md:py-2"
            }, React.createElement("div", {
                  className: "flex md:flex-col"
                }, React.createElement("p", undefined, Format(new Date(expiredAt), "yyyy-MM-dd")), React.createElement("p", {
                      className: "text-text-L2 ml-1 md:ml-0"
                    }, Format(new Date(expiredAt), "HH:mm:ss")))), React.createElement("div", {
              className: "mr-0 md:text-center md:w-20 py-1 md:py-2"
            }, React.createElement("p", undefined, statusToString(rowData.status))));
  } else {
    tmp = null;
  }
  return React.createElement("li", {
              className: "flex border-b py-2 border-div-border-L2"
            }, React.createElement("div", {
                  className: "md:hidden w-2/6 text-text-L2 min-w-max mr-3"
                }, Belt_Array.map(columnsWithWidth, (function (param) {
                        var column = param[0];
                        return React.createElement("p", {
                                    key: "" + id + "-" + column + "",
                                    className: "py-1 md:py-2"
                                  }, column);
                      }))), tmp);
}

var TableRow = {
  make: Virtual_Account_Payment_Confirmation_Button_Buyer$TableRow
};

function Virtual_Account_Payment_Confirmation_Button_Buyer$ContentsSkeleton(Props) {
  var children = Props.children;
  return React.createElement("div", {
              className: "flex items-center justify-center md:h-[30vh] h-[60vh] font-bold"
            }, children);
}

var ContentsSkeleton = {
  make: Virtual_Account_Payment_Confirmation_Button_Buyer$ContentsSkeleton
};

function Virtual_Account_Payment_Confirmation_Button_Buyer$List(Props) {
  var queryData = use({
        paymentMethod: "VIRTUAL_ACCOUNT",
        status: "PENDING"
      }, /* NetworkOnly */3, undefined, undefined, undefined);
  var charges$p = queryData.payments;
  if (charges$p.length !== 0) {
    return React.createElement("ul", {
                className: "md:min-h-[30vh] min-h-[60vh]"
              }, Belt_Array.map(charges$p, (function (rowData) {
                      return React.createElement(Virtual_Account_Payment_Confirmation_Button_Buyer$TableRow, {
                                  rowData: rowData,
                                  key: rowData.id
                                });
                    })));
  } else {
    return React.createElement(Virtual_Account_Payment_Confirmation_Button_Buyer$ContentsSkeleton, {
                children: React.createElement("p", {
                      className: "text-text-L3"
                    }, "가상계좌 결제 확인 내역이 없습니다.")
              });
  }
}

var List = {
  make: Virtual_Account_Payment_Confirmation_Button_Buyer$List
};

function Virtual_Account_Payment_Confirmation_Button_Buyer(Props) {
  var close = function (param) {
    var buttonClose = document.getElementById("btn-close");
    Belt_Option.forEach(Belt_Option.flatMap((buttonClose == null) ? undefined : Caml_option.some(buttonClose), Webapi__Dom__Element.asHtmlElement), (function (buttonClose$p) {
            buttonClose$p.click();
          }));
  };
  return React.createElement(ReactDialog.Root, {
              children: null
            }, React.createElement(ReactDialog.Overlay, {
                  className: "dialog-overlay"
                }), React.createElement(ReactDialog.Trigger, {
                  children: React.createElement("span", undefined, "가상계좌 결제 확인"),
                  className: "px-3 h-9 rounded-lg text-enabled-L1 bg-div-shape-L1 whitespace-nowrap focus:outline-none focus:ring-2 focus:ring-gray-150 focus:ring-offset-1"
                }), React.createElement(ReactDialog.Content, {
                  children: null,
                  className: "dialog-content-fix p-5 overflow-y-auto text-sm text-text-L1 rounded-2xl min-w-max"
                }, React.createElement(Virtual_Account_Payment_Confirmation_Button_Buyer$TitleAndCloseButton, {
                      close: close
                    }), React.createElement(Virtual_Account_Payment_Confirmation_Button_Buyer$TableHead, {}), React.createElement(RescriptReactErrorBoundary.make, {
                      children: React.createElement(React.Suspense, {
                            children: React.createElement(Virtual_Account_Payment_Confirmation_Button_Buyer$List, {}),
                            fallback: React.createElement(Virtual_Account_Payment_Confirmation_Button_Buyer$ContentsSkeleton, {
                                  children: React.createElement("p", {
                                        className: "text-text-L3"
                                      }, "로딩 중..")
                                })
                          }),
                      fallback: (function (param) {
                          return React.createElement(Virtual_Account_Payment_Confirmation_Button_Buyer$ContentsSkeleton, {
                                      children: React.createElement("p", {
                                            className: "text-notice"
                                          }, "에러 발생")
                                    });
                        })
                    }), React.createElement(ReactDialog.Close, {
                      children: "",
                      className: "hidden",
                      id: "btn-close"
                    }), React.createElement("span", {
                      className: "md:hidden"
                    }, React.createElement(Dialog.ButtonBox.make, {
                          onCancel: (function (param) {
                              close(undefined);
                            }),
                          textOnCancel: "닫기"
                        }))));
}

var make = Virtual_Account_Payment_Confirmation_Button_Buyer;

export {
  Query ,
  columnsWithWidth ,
  formatDate ,
  formatTime ,
  TitleAndCloseButton ,
  TableHead ,
  TableRow ,
  ContentsSkeleton ,
  List ,
  make ,
}
/* react Not a pure module */
