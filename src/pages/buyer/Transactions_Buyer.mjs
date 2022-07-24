// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Env from "../../constants/Env.mjs";
import * as Swr from "swr";
import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as Dialog from "../../components/common/Dialog.mjs";
import * as Js_dict from "rescript/lib/es6/js_dict.js";
import * as Belt_Int from "rescript/lib/es6/belt_Int.js";
import * as Constants from "../../constants/Constants.mjs";
import * as IconCheck from "../../components/svgs/IconCheck.mjs";
import * as IconError from "../../components/svgs/IconError.mjs";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as ErrorPanel from "../../components/common/ErrorPanel.mjs";
import * as Pagination from "../../components/common/Pagination.mjs";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as CustomHooks from "../../utils/CustomHooks.mjs";
import * as EmptyOrders from "../../components/common/EmptyOrders.mjs";
import * as Router from "next/router";
import * as ReactRelay from "react-relay";
import * as Garter_Array from "@greenlabs/garter/src/Garter_Array.mjs";
import * as Authorization from "../../utils/Authorization.mjs";
import * as RelayRuntime from "relay-runtime";
import * as Transaction_Buyer from "../../components/Transaction_Buyer.mjs";
import * as Select_CountPerPage from "../../components/Select_CountPerPage.mjs";
import * as Cash_Charge_Button_Buyer from "../../components/Cash_Charge_Button_Buyer.mjs";
import * as Select_Transaction_Status from "../../components/Select_Transaction_Status.mjs";
import * as ReactToastNotifications from "react-toast-notifications";
import * as RescriptReactErrorBoundary from "@rescript/react/src/RescriptReactErrorBoundary.mjs";
import * as Excel_Download_Request_Button from "../../components/Excel_Download_Request_Button.mjs";
import * as Webapi__Dom__HtmlInputElement from "rescript-webapi/src/Webapi/Dom/Webapi__Dom__HtmlInputElement.mjs";
import * as Buyer_Deposit_Detail_Button_Admin from "../../components/Buyer_Deposit_Detail_Button_Admin.mjs";
import * as TransactionsBuyerMutation_graphql from "../../__generated__/TransactionsBuyerMutation_graphql.mjs";
import * as Virtual_Account_Payment_Confirmation_Button_Buyer from "../../components/Virtual_Account_Payment_Confirmation_Button_Buyer.mjs";

function commitMutation(environment, variables, optimisticUpdater, optimisticResponse, updater, onCompleted, onError, uploadables, param) {
  return RelayRuntime.commitMutation(environment, {
              mutation: TransactionsBuyerMutation_graphql.node,
              variables: TransactionsBuyerMutation_graphql.Internal.convertVariables(variables),
              onCompleted: (function (res, err) {
                  if (onCompleted !== undefined) {
                    return Curry._2(onCompleted, TransactionsBuyerMutation_graphql.Internal.convertResponse(res), (err == null) ? undefined : Caml_option.some(err));
                  }
                  
                }),
              onError: (function (err) {
                  if (onError !== undefined) {
                    return Curry._1(onError, (err == null) ? undefined : Caml_option.some(err));
                  }
                  
                }),
              optimisticResponse: optimisticResponse !== undefined ? TransactionsBuyerMutation_graphql.Internal.convertWrapRawResponse(optimisticResponse) : undefined,
              optimisticUpdater: optimisticUpdater,
              updater: updater !== undefined ? (function (store, r) {
                    Curry._2(updater, store, TransactionsBuyerMutation_graphql.Internal.convertResponse(r));
                  }) : undefined,
              uploadables: uploadables
            });
}

function use(param) {
  var match = ReactRelay.useMutation(TransactionsBuyerMutation_graphql.node);
  var mutate = match[0];
  return [
          React.useMemo((function () {
                  return function (param, param$1, param$2, param$3, param$4, param$5, param$6, param$7, param$8) {
                    return Curry._1(mutate, {
                                onError: param,
                                onCompleted: param$1 !== undefined ? (function (r, errors) {
                                      Curry._2(param$1, TransactionsBuyerMutation_graphql.Internal.convertResponse(r), (errors == null) ? undefined : Caml_option.some(errors));
                                    }) : undefined,
                                onUnsubscribe: param$2,
                                optimisticResponse: param$3 !== undefined ? TransactionsBuyerMutation_graphql.Internal.convertWrapRawResponse(param$3) : undefined,
                                optimisticUpdater: param$4,
                                updater: param$5 !== undefined ? (function (store, r) {
                                      Curry._2(param$5, store, TransactionsBuyerMutation_graphql.Internal.convertResponse(r));
                                    }) : undefined,
                                variables: TransactionsBuyerMutation_graphql.Internal.convertVariables(param$6),
                                uploadables: param$7
                              });
                  };
                }), [mutate]),
          match[1]
        ];
}

var Mutation_errorCode_decode = TransactionsBuyerMutation_graphql.Utils.errorCode_decode;

var Mutation_errorCode_fromString = TransactionsBuyerMutation_graphql.Utils.errorCode_fromString;

var Mutation = {
  errorCode_decode: Mutation_errorCode_decode,
  errorCode_fromString: Mutation_errorCode_fromString,
  Operation: undefined,
  Types: undefined,
  commitMutation: commitMutation,
  use: use
};

function Transactions_Buyer$Summary(Props) {
  return React.createElement("div", {
              className: "mt-4 p-5 lg:px-7 shadow-gl bg-white rounded"
            }, React.createElement("div", {
                  className: "flex flex-col lg:flex-row justify-between items-center"
                }, React.createElement("span", {
                      className: "w-full flex items-center gap-3 lg:text-xl font-bold"
                    }, React.createElement("h2", undefined, "주문가능 잔액"), React.createElement(Buyer_Deposit_Detail_Button_Admin.Summary.Amount.make, {
                          kind: /* Deposit */6,
                          className: "text-primary"
                        })), React.createElement("span", {
                      className: "flex flex-col lg:flex-row w-full mt-7 lg:mt-0 lg:justify-end"
                    }, React.createElement("div", {
                          className: "flex gap-3 mr-3"
                        }, React.createElement(Virtual_Account_Payment_Confirmation_Button_Buyer.make, {}), React.createElement(Buyer_Deposit_Detail_Button_Admin.make, {})), React.createElement(Cash_Charge_Button_Buyer.make, {
                          hasRequireTerms: false,
                          buttonClassName: "px-3 mt-2 lg:mt-0 h-9 max-w-fit rounded-lg text-white whitespace-nowrap focus:outline-none focus:ring-2 focus:ring-gray-150 focus:ring-offset-1 bg-primary",
                          buttonText: "결제하기"
                        }))));
}

var Summary = {
  make: Transactions_Buyer$Summary
};

function Transactions_Buyer$List(Props) {
  var status = Props.status;
  if (typeof status === "number") {
    return React.createElement("div", undefined, "로딩 중..");
  }
  if (status.TAG !== /* Loaded */0) {
    return React.createElement(ErrorPanel.make, {
                error: status._0
              });
  }
  var transactions$p = CustomHooks.Transaction.response_decode(status._0);
  var tmp;
  if (transactions$p.TAG === /* Ok */0) {
    var transactions$p$1 = transactions$p._0;
    tmp = React.createElement("ol", {
          className: "divide-y divide-gray-300 lg:divide-gray-100 lg:list-height-buyer lg:overflow-y-scroll"
        }, transactions$p$1.data.length !== 0 ? Garter_Array.map(transactions$p$1.data, (function (transaction) {
                  return React.createElement(Transaction_Buyer.make, {
                              transaction: transaction,
                              key: String(transaction.id)
                            });
                })) : React.createElement(EmptyOrders.make, {}));
  } else {
    tmp = React.createElement(EmptyOrders.make, {});
  }
  var tmp$1;
  if (typeof status === "number" || status.TAG !== /* Loaded */0) {
    tmp$1 = null;
  } else {
    var transactions$p$2 = CustomHooks.Transaction.response_decode(status._0);
    if (transactions$p$2.TAG === /* Ok */0) {
      var transactions$p$3 = transactions$p$2._0;
      tmp$1 = React.createElement("div", {
            className: "flex justify-center py-5"
          }, React.createElement(Pagination.make, {
                pageDisplySize: Constants.pageDisplySize,
                itemPerPage: transactions$p$3.limit,
                total: transactions$p$3.count
              }));
    } else {
      tmp$1 = null;
    }
  }
  return React.createElement(React.Fragment, undefined, React.createElement("div", {
                  className: "w-full overflow-x-scroll"
                }, React.createElement("div", {
                      className: "text-sm lg:min-w-max"
                    }, React.createElement("div", {
                          className: "hidden lg:grid lg:grid-cols-4-buyer-transaction bg-gray-100 text-gray-500 h-12"
                        }, React.createElement("div", {
                              className: "h-full px-4 flex items-center whitespace-nowrap"
                            }, "정산유형"), React.createElement("div", {
                              className: "h-full px-4 flex items-center whitespace-nowrap"
                            }, "날짜"), React.createElement("div", {
                              className: "h-full px-4 flex items-center text-center whitespace-nowrap"
                            }, "해당금액"), React.createElement("div", {
                              className: "h-full px-4 flex items-center text-center whitespace-nowrap"
                            }, "잔액")), tmp)), tmp$1);
}

var List = {
  make: Transactions_Buyer$List
};

function getHtmlInputElementValue(id) {
  return Belt_Option.map(Belt_Option.flatMap(Caml_option.nullable_to_opt(document.getElementById(id)), Webapi__Dom__HtmlInputElement.ofElement), (function (prim) {
                return prim.value;
              }));
}

function Transactions_Buyer$Transactions(Props) {
  var match = ReactToastNotifications.useToasts();
  var addToast = match.addToast;
  var swr = Swr.useSWRConfig();
  var router = Router.useRouter();
  var match$1 = use(undefined);
  var mutate = match$1[0];
  var status = CustomHooks.Transaction.use(new URLSearchParams(router.query).toString());
  var match$2 = React.useState(function () {
        return /* Hide */1;
      });
  var setShowErrorForDownload = match$2[1];
  var count;
  if (typeof status === "number" || status.TAG !== /* Loaded */0) {
    count = "-";
  } else {
    var transactions$p = CustomHooks.Transaction.response_decode(status._0);
    if (transactions$p.TAG === /* Ok */0) {
      count = String(transactions$p._0.count);
    } else {
      console.log(transactions$p._0);
      count = "-";
    }
  }
  var type_ = Belt_Option.getWithDefault(Js_dict.get(router.query, "type"), "");
  var bodyOption = Js_dict.fromArray([[
          "type",
          type_
        ]]);
  var handleError = function (message, param) {
    addToast(React.createElement("div", {
              className: "flex items-center"
            }, React.createElement(IconError.make, {
                  width: "24",
                  height: "24",
                  className: "mr-2"
                }), "결제가 실패하였습니다. " + Belt_Option.getWithDefault(message, "") + ""), {
          appearance: "error"
        });
  };
  var notices = [
    "1. 주문(발주)를 등록하기 위해서는 먼저 주문가능잔액(신선캐시) 충전이 필요합니다.",
    "2. 주문가능금액(신선캐시) 충전은 아래 [결제하기] 버튼을 눌러 충전창을 통해 진행해주세요.",
    "3. 충전금액과 결제수단을 선택하신 후에 NHN KCP의 결제창에서 결제를 정상적으로 수행해주셔야 충전이 완료됩니다.",
    "4. 충전을 위한 결제수단은 가상계좌(무통장입금)과 신용카드 결제가 지원됩니다.",
    "5. 가상계좌는 결제신청으로부터 만 24시간 후에는 무효화 됩니다.",
    "\t 새로 충전(결제요청) 해 주세요. 정해진 계좌에 신청한 금액만 정상적으로 입금처리가 됩니다.",
    "\t 간혹 ATM기기에서는 정상 처리되지 않는 경우가 있으니 창구입금이나 계좌이체 부탁드립니다.",
    "6. 신용카드 결제는 각 카드(개인 또는 사업자)의 한도에 따라서 최대 결제할 수 있는 금액이 정해져 있습니다. 이 금액을 초과한 경우 결제가 실패하게 되오니 양해부탁드립니다."
  ];
  React.useEffect((function () {
          var window$p = typeof window === "undefined" ? undefined : window;
          if (window$p !== undefined) {
            window$p.mutate_completepayment = (function (param) {
                var encData = getHtmlInputElementValue("enc_data");
                var encInfo = getHtmlInputElementValue("enc_info");
                var paymentId = Belt_Option.flatMap(getHtmlInputElementValue("ordr_idxx"), Belt_Int.fromString);
                var ordrMony = Belt_Option.flatMap(getHtmlInputElementValue("good_mny"), Belt_Int.fromString);
                var siteCd = getHtmlInputElementValue("site_cd");
                var siteKey = getHtmlInputElementValue("site_key");
                var tranCd = getHtmlInputElementValue("tran_cd");
                if (encData !== undefined && encInfo !== undefined && paymentId !== undefined && ordrMony !== undefined && siteCd !== undefined && siteKey !== undefined && tranCd !== undefined) {
                  Curry.app(mutate, [
                        (function (error) {
                            window.closeEventKCP();
                            handleError(error.message, undefined);
                          }),
                        (function (param, _error) {
                            var requestPaymentApprovalKCP = param.requestPaymentApprovalKCP;
                            if (requestPaymentApprovalKCP === undefined) {
                              return ;
                            }
                            if (typeof requestPaymentApprovalKCP === "object") {
                              var variant = requestPaymentApprovalKCP.NAME;
                              if (variant === "RequestPaymentApprovalKCPResult") {
                                window.closeEventKCP();
                                addToast(React.createElement("div", {
                                          className: "flex items-center"
                                        }, React.createElement(IconCheck.make, {
                                              height: "24",
                                              width: "24",
                                              fill: "#12B564",
                                              className: "mr-2"
                                            }), "결제가 완료되었습니다."), {
                                      appearance: "success"
                                    });
                                swr.mutate("" + Env.restApiUrl + "/transaction/summary?" + new URLSearchParams(router.query).toString() + "", undefined, true);
                                return swr.mutate("" + Env.restApiUrl + "/transaction?" + new URLSearchParams(router.query).toString() + "", undefined, true);
                              } else if (variant === "Error") {
                                window.closeEventKCP();
                                return handleError(Belt_Option.getWithDefault(requestPaymentApprovalKCP.VAL.message, ""), undefined);
                              } else {
                                window.closeEventKCP();
                                return handleError("", undefined);
                              }
                            }
                            window.closeEventKCP();
                            handleError("", undefined);
                          }),
                        undefined,
                        undefined,
                        undefined,
                        undefined,
                        {
                          encData: encData,
                          encInfo: encInfo,
                          ordrMony: ordrMony,
                          paymentId: paymentId,
                          siteCd: siteCd,
                          siteKey: siteKey,
                          tranCd: tranCd
                        },
                        undefined,
                        undefined
                      ]);
                  return ;
                } else {
                  return handleError("결제 인증에 실패하였습니다.", undefined);
                }
              });
          }
          
        }), []);
  return React.createElement(React.Fragment, undefined, React.createElement("div", {
                  className: "sm:px-10 md:px-20 text-enabled-L1"
                }, React.createElement("div", {
                      className: "flex flex-col mx-4 lg:flex-row sm:mx-0 py-4 px-5 bg-red-gl rounded-lg text-red-500 mt-4"
                    }, React.createElement("span", {
                          className: "block font-bold mr-4 min-w-max"
                        }, "[주의사항]"), React.createElement("span", {
                          className: "whitespace-pre-wrap"
                        }, Belt_Array.map(notices, (function (notice) {
                                return React.createElement("p", {
                                            key: notice
                                          }, notice);
                              })))), React.createElement(Transactions_Buyer$Summary, {}), React.createElement("div", {
                      className: "px-5 lg:px-7 mt-4 shadow-gl"
                    }, React.createElement("div", {
                          className: "md:flex md:justify-between pb-4 text-base"
                        }, React.createElement("div", {
                              className: "pt-10 flex flex-col lg:flex-row sm:flex-auto sm:justify-between"
                            }, React.createElement("h3", {
                                  className: "font-bold"
                                }, "결제내역", React.createElement("span", {
                                      className: "ml-1 text-green-gl font-normal"
                                    }, "" + count + "건")), React.createElement("div", {
                                  className: "flex flex-col lg:flex-row mt-4 lg:mt-0"
                                }, React.createElement("div", {
                                      className: "flex items-center"
                                    }, React.createElement(Select_CountPerPage.make, {
                                          className: "mr-2"
                                        }), React.createElement(Select_Transaction_Status.make, {
                                          className: "mr-2"
                                        })), React.createElement("div", {
                                      className: "flex mt-2 lg:mt-0"
                                    }, React.createElement(Excel_Download_Request_Button.make, {
                                          userType: /* Buyer */1,
                                          requestUrl: "/transaction/request-excel",
                                          bodyOption: bodyOption
                                        }))))), React.createElement(Transactions_Buyer$List, {
                          status: status
                        }))), React.createElement("form", {
                  id: "order_info",
                  action: "",
                  method: "post",
                  name: "order_info"
                }, React.createElement("input", {
                      id: "ordr_idxx",
                      maxLength: 40,
                      name: "ordr_idxx",
                      type: "hidden",
                      value: "TEST12345"
                    }), React.createElement("input", {
                      id: "good_name",
                      name: "good_name",
                      type: "hidden",
                      value: "신선하이"
                    }), React.createElement("input", {
                      id: "good_mny",
                      maxLength: 12,
                      name: "good_mny",
                      type: "hidden",
                      value: "0"
                    }), React.createElement("input", {
                      id: "currency",
                      maxLength: 9,
                      name: "currency",
                      type: "hidden",
                      value: "0"
                    }), React.createElement("input", {
                      id: "shop_user_id",
                      name: "shop_user_id",
                      type: "hidden",
                      value: ""
                    }), React.createElement("input", {
                      id: "buyr_name",
                      name: "buyr_name",
                      type: "hidden",
                      value: ""
                    }), React.createElement("input", {
                      name: "quotaopt",
                      type: "hidden",
                      value: "0"
                    }), React.createElement("input", {
                      id: "pay_method",
                      name: "pay_method",
                      type: "hidden",
                      value: "101000000000"
                    }), React.createElement("input", {
                      id: "site_cd",
                      name: "site_cd",
                      type: "hidden",
                      value: "T0000"
                    }), React.createElement("input", {
                      id: "site_name",
                      name: "site_name",
                      type: "hidden",
                      value: "Sinsun Market"
                    }), React.createElement("input", {
                      id: "site_key",
                      name: "site_key",
                      type: "hidden",
                      value: ""
                    }), React.createElement("input", {
                      id: "site_logo",
                      name: "site_logo",
                      type: "hidden",
                      value: Env.logo150x50
                    }), React.createElement("input", {
                      id: "res_cd",
                      name: "res_cd",
                      type: "hidden",
                      value: ""
                    }), React.createElement("input", {
                      id: "res_msg",
                      name: "res_msg",
                      type: "hidden",
                      value: ""
                    }), React.createElement("input", {
                      id: "enc_info",
                      name: "enc_info",
                      type: "hidden",
                      value: ""
                    }), React.createElement("input", {
                      id: "enc_data",
                      name: "enc_data",
                      type: "hidden",
                      value: ""
                    }), React.createElement("input", {
                      id: "ret_pay_method",
                      name: "ret_pay_method",
                      type: "hidden",
                      value: ""
                    }), React.createElement("input", {
                      id: "tran_cd",
                      name: "tran_cd",
                      type: "hidden",
                      value: ""
                    }), React.createElement("input", {
                      id: "use_pay_method",
                      name: "use_pay_method",
                      type: "hidden",
                      value: ""
                    })), React.createElement(Dialog.make, {
                  isShow: match$2[0],
                  children: React.createElement("p", {
                        className: "text-gray-500 text-center whitespace-pre-wrap"
                      }, "다운로드에 실패하였습니다.\n다시 시도하시기 바랍니다."),
                  onConfirm: (function (param) {
                      setShowErrorForDownload(function (param) {
                            return /* Hide */1;
                          });
                    })
                }));
}

var Transactions = {
  make: Transactions_Buyer$Transactions
};

function Transactions_Buyer(Props) {
  return React.createElement(Authorization.Buyer.make, {
              children: React.createElement(RescriptReactErrorBoundary.make, {
                    children: React.createElement(React.Suspense, {
                          children: React.createElement(Transactions_Buyer$Transactions, {}),
                          fallback: React.createElement("div", undefined, "로딩중..")
                        }),
                    fallback: (function (param) {
                        return React.createElement("div", undefined, "에러 발생");
                      })
                  }),
              title: "결제내역"
            });
}

var make = Transactions_Buyer;

export {
  Mutation ,
  Summary ,
  List ,
  getHtmlInputElementValue ,
  Transactions ,
  make ,
}
/* Env Not a pure module */
