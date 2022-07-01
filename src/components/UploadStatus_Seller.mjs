// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import * as Dialog from "./common/Dialog.mjs";
import * as Helper from "../utils/Helper.mjs";
import * as Locale from "../utils/Locale.mjs";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as CustomHooks from "../utils/CustomHooks.mjs";
import * as Garter_Array from "@greenlabs/garter/src/Garter_Array.mjs";

function formatDate(d) {
  return Locale.DateTime.formatFromUTC(new Date(d), "yyyy/MM/dd");
}

function formatTime(d) {
  return Locale.DateTime.formatFromUTC(new Date(d), "HH:mm");
}

function styleStatus(s) {
  switch (s) {
    case /* WAITING */0 :
        return "text-gray-500";
    case /* PROCESSING */1 :
        return "text-gray-700";
    case /* SUCCESS */2 :
        return "text-green-gl";
    case /* FAIL */3 :
        return "text-red-500";
    
  }
}

function displayStatus(status, successCount, failCount) {
  switch (status) {
    case /* WAITING */0 :
        return "대기중..";
    case /* PROCESSING */1 :
        return "처리중..";
    case /* SUCCESS */2 :
        return Belt_Option.getWithDefault(Helper.$$Option.map2(successCount, failCount, (function (successCount$p, failCount$p) {
                          if (failCount$p > 0) {
                            return "일부성공(" + String(successCount$p) + "/" + String(successCount$p + failCount$p | 0) + ")";
                          } else {
                            return "성공(" + String(successCount$p) + "/" + String(successCount$p) + ")";
                          }
                        })), "성공");
    case /* FAIL */3 :
        return "실패";
    
  }
}

function UploadStatus_Seller(Props) {
  var kind = Props.kind;
  var match = React.useState(function () {
        return {
                failCodes: undefined,
                isShow: /* Hide */1
              };
      });
  var setFailDetail = match[1];
  var failDetail = match[0];
  var status = CustomHooks.UploadStatus.use(kind, /* Invoice */1);
  var tmp;
  if (typeof status === "number") {
    tmp = React.createElement("div", undefined, "로딩 중..");
  } else if (status.TAG === /* Loaded */0) {
    var data$p = CustomHooks.UploadStatus.response_decode(status._0);
    if (data$p.TAG === /* Ok */0) {
      var data$p$1 = data$p._0;
      tmp = Garter_Array.isEmpty(data$p$1.data) ? React.createElement("div", undefined, "업로드 한 내역이 없습니다.") : Garter_Array.map(data$p$1.data, (function (d) {
                var match = d.failDataJson;
                return React.createElement("div", {
                            key: d.orderNo,
                            className: "table-row w-full"
                          }, React.createElement("span", {
                                className: "table-cell w-24 py-3 pr-2 text-gray-gl border-b border-gray-200"
                              }, React.createElement("span", {
                                    className: "block"
                                  }, formatDate(d.createdAt)), React.createElement("span", {
                                    className: "block"
                                  }, formatTime(d.createdAt))), React.createElement("span", {
                                className: "table-cell w-full py-3 px-2 border-b border-gray-200"
                              }, React.createElement("span", {
                                    className: "block truncate"
                                  }, d.filename), React.createElement("span", {
                                    className: "flex justify-between"
                                  }, React.createElement("span", {
                                        className: styleStatus(d.status)
                                      }, displayStatus(d.status, d.successCount, d.failCount)), React.createElement("span", {
                                        className: "whitespace-nowrap ml-1 text-gray-400 underline",
                                        onClick: (function (param) {
                                            return setFailDetail(function (param) {
                                                        return {
                                                                failCodes: d.failDataJson,
                                                                isShow: /* Show */0
                                                              };
                                                      });
                                          })
                                      }, match !== undefined ? "자세히보기" : null))));
              }));
    } else {
      tmp = null;
    }
  } else {
    tmp = React.createElement("div", undefined, "에러가 발생하였습니다.");
  }
  var failCodes$p = failDetail.failCodes;
  return React.createElement(React.Fragment, undefined, React.createElement("section", {
                  className: "flex flex-col"
                }, React.createElement("div", {
                      className: "table table-fixed pt-5"
                    }, tmp), React.createElement("div", {
                      className: "text-gray-gl"
                    }, React.createElement("span", {
                          className: "block pt-7 font-bold"
                        }, "*주의사항"), React.createElement("ol", {
                          className: "list-decimal list-inside mt-2 text-sm"
                        }, React.createElement("li", undefined, "형식에 맞는 주문서를 업로드 해야만 업로드에 성공합니다."), React.createElement("li", undefined, "택배사명이 형식에 맞아야 업로드에 성공합니다.(우체국x,우체국 택배o)"), React.createElement("li", undefined, "가송장 입력을 지양해주세요. 가송장 입력 경우 “미출고\"로 계속 노출."), React.createElement("li", undefined, "일부 성공했을 경우, [미출고 건 다운로드]를 클릭해 확인 부탁드립니다.")), React.createElement("span", {
                          className: "block mt-6 text-sm"
                        }, "*가장 최근 요청한 3가지 등록건만 노출됩니다."))), React.createElement(Dialog.make, {
                  isShow: failDetail.isShow,
                  children: null,
                  onCancel: (function (param) {
                      return setFailDetail(function (param) {
                                  return {
                                          failCodes: undefined,
                                          isShow: /* Hide */1
                                        };
                                });
                    }),
                  textOnCancel: "확인"
                }, React.createElement("p", {
                      className: "whitespace-pre-wrap text-gray-gl"
                    }, "송장번호 대량 입력 일부 성공"), failCodes$p !== undefined ? React.createElement("div", {
                        className: "mt-4"
                      }, React.createElement("ol", {
                            className: "text-left list-decimal list-inside"
                          }, React.createElement("li", undefined, React.createElement("span", {
                                    className: "font-bold"
                                  }, "택배사명이 형식"), "에 맞아야 합니다."), React.createElement("li", undefined, React.createElement("span", {
                                    className: "font-bold"
                                  }, "송장번호 항목이 빈값"), "이 아니어야 합니다."), React.createElement("li", undefined, React.createElement("span", {
                                    className: "font-bold"
                                  }, "배송이 완료되었을 경우"), " 송장번호 수정이 불가능합니다.")), React.createElement("div", {
                            className: "text-black-gl mt-4"
                          }, React.createElement("div", {
                                className: "grid grid-cols-2-gl-seller-upload-error h-12 bg-gray-gl"
                              }, React.createElement("div", {
                                    className: "h-full px-4 flex justify-center items-center whitespace-nowrap"
                                  }, "행"), React.createElement("div", {
                                    className: "h-full px-4 flex justify-center items-center whitespace-nowrap"
                                  }, "상태값")), React.createElement("ol", {
                                className: "list-height-seller-error overflow-y-auto divide-y divide-gray-100"
                              }, failCodes$p.length !== 0 ? Garter_Array.map(failCodes$p, (function (code) {
                                        return React.createElement("li", {
                                                    className: "grid grid-cols-2-gl-seller-upload-error h-12"
                                                  }, React.createElement("div", {
                                                        className: "h-full px-4 flex justify-center items-center whitespace-nowrap"
                                                      }, String(code.rowNumber)), React.createElement("div", {
                                                        className: "h-full p-3 truncate"
                                                      }, code.failCode._0));
                                      })) : "에러 코드가 없습니다."))) : null));
}

var make = UploadStatus_Seller;

export {
  formatDate ,
  formatTime ,
  styleStatus ,
  displayStatus ,
  make ,
  
}
/* react Not a pure module */
