// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import * as Dialog from "../../components/common/Dialog.mjs";
import * as Js_dict from "rescript/lib/es6/js_dict.js";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as CustomHooks from "../../utils/CustomHooks.mjs";
import * as Router from "next/router";
import * as Authorization from "../../utils/Authorization.mjs";
import Format from "date-fns/format";
import SubDays from "date-fns/subDays";
import * as Select_CountPerPage from "../../components/Select_CountPerPage.mjs";
import * as Settlements_List_Admin from "../../components/Settlements_List_Admin.mjs";
import * as Summary_Settlement_Admin from "../../components/Summary_Settlement_Admin.mjs";
import * as Excel_Download_Request_Button from "../../components/Excel_Download_Request_Button.mjs";

function Settlements_Admin$Settlements(Props) {
  var router = Router.useRouter();
  var status = CustomHooks.Settlements.use(new URLSearchParams(router.query).toString());
  var match = React.useState(function () {
        
      });
  var setProducerCodeToDownload = match[1];
  var producerCodeToDownload = match[0];
  var match$1 = React.useState(function () {
        return /* Hide */1;
      });
  var setShowErrorForDownload = match$1[1];
  var match$2 = React.useState(function () {
        return /* Hide */1;
      });
  var setShowErrorForNothingToDownload = match$2[1];
  var count;
  if (typeof status === "number" || status.TAG !== /* Loaded */0) {
    count = "-";
  } else {
    var settlements$p = CustomHooks.Settlements.settlements_decode(status._0);
    count = settlements$p.TAG === /* Ok */0 ? String(settlements$p._0.count) : "-";
  }
  var handleOnCheckSettlement = function (producerCode) {
    setProducerCodeToDownload(function (param) {
          return producerCode;
        });
  };
  var removeCheckedSettlement = function (param) {
    setProducerCodeToDownload(function (param) {
          
        });
  };
  var from = Belt_Option.getWithDefault(Js_dict.get(router.query, "from"), Format(SubDays(new Date(), 7), "yyyyMMdd"));
  var to_ = Belt_Option.getWithDefault(Js_dict.get(router.query, "to"), Format(new Date(), "yyyyMMdd"));
  var bodyOption = Js_dict.fromArray([
        [
          "from",
          from
        ],
        [
          "to",
          to_
        ],
        [
          "producer-codes",
          Belt_Option.getWithDefault(producerCodeToDownload, "")
        ]
      ]);
  return React.createElement(React.Fragment, undefined, React.createElement("div", {
                  className: "max-w-gnb-panel overflow-auto overflow-x-scroll bg-div-shape-L1 min-h-screen"
                }, React.createElement("header", {
                      className: "flex items-baseline p-7 pb-0"
                    }, React.createElement("h1", {
                          className: "text-text-L1 text-xl font-bold"
                        }, "생산자별 정산기초금액 조회")), React.createElement(Summary_Settlement_Admin.make, {
                      onReset: removeCheckedSettlement,
                      onQuery: removeCheckedSettlement
                    }), React.createElement("div", {
                      className: "p-7 m-4 bg-white rounded shadow-gl overflow-auto overflow-x-scroll"
                    }, React.createElement("div", undefined, React.createElement("div", {
                              className: "flex flex-auto justify-between pb-3"
                            }, React.createElement("h3", {
                                  className: "text-lg font-bold"
                                }, "내역", React.createElement("span", {
                                      className: "text-base text-primary font-normal ml-1"
                                    }, "" + count + "건")), React.createElement("div", {
                                  className: "flex"
                                }, React.createElement(Select_CountPerPage.make, {
                                      className: "mr-2"
                                    }), React.createElement(Excel_Download_Request_Button.make, {
                                      userType: /* Admin */2,
                                      requestUrl: "/settlement/request-excel",
                                      buttonText: "주문서 원본 엑셀 다운로드 요청",
                                      bodyOption: bodyOption
                                    })))), React.createElement(Settlements_List_Admin.make, {
                          status: status,
                          producerCodeToDownload: producerCodeToDownload,
                          onCheckSettlement: handleOnCheckSettlement
                        }))), React.createElement(Dialog.make, {
                  isShow: match$1[0],
                  children: React.createElement("p", {
                        className: "text-gray-500 text-center whitespace-pre-wrap"
                      }, "다운로드에 실패하였습니다.\n다시 시도하시기 바랍니다."),
                  onCancel: (function (param) {
                      setShowErrorForDownload(function (param) {
                            return /* Hide */1;
                          });
                    }),
                  textOnCancel: "확인"
                }), React.createElement(Dialog.make, {
                  isShow: match$2[0],
                  children: React.createElement("p", {
                        className: "text-gray-500 text-center whitespace-pre-wrap"
                      }, "다운로드할 항목을 선택해주세요"),
                  onCancel: (function (param) {
                      setShowErrorForNothingToDownload(function (param) {
                            return /* Hide */1;
                          });
                    }),
                  textOnCancel: "확인"
                }));
}

var Settlements = {
  make: Settlements_Admin$Settlements
};

function Settlements_Admin(Props) {
  return React.createElement(Authorization.Admin.make, {
              children: React.createElement(Settlements_Admin$Settlements, {}),
              title: "관리자 정산기초금액 조회"
            });
}

var List;

var make = Settlements_Admin;

export {
  List ,
  Settlements ,
  make ,
}
/* react Not a pure module */
