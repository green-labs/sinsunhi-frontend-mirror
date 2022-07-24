// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Env from "../constants/Env.mjs";
import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as Dialog from "./common/Dialog.mjs";
import * as Locale from "../utils/Locale.mjs";
import * as ReactUtil from "../utils/ReactUtil.mjs";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as CustomHooks from "../utils/CustomHooks.mjs";
import * as Garter_Array from "@greenlabs/garter/src/Garter_Array.mjs";
import * as Webapi__Dom__Element from "rescript-webapi/src/Webapi/Dom/Webapi__Dom__Element.mjs";

function formatDate(d) {
  return Locale.DateTime.formatFromUTC(new Date(d), "yyyy/MM/dd");
}

function formatTime(d) {
  return Locale.DateTime.formatFromUTC(new Date(d), "HH:mm");
}

function styleStatus(s) {
  switch (s) {
    case /* WAITING */0 :
        return "text-gray-500 font-bold whitespace-nowrap";
    case /* PROCESSING */1 :
        return "text-gray-700 font-bold whitespace-nowrap";
    case /* SUCCESS */2 :
        return "text-green-gl font-bold whitespace-nowrap";
    case /* FAIL */3 :
        return "text-red-500 font-bold whitespace-nowrap";
    
  }
}

function displayStatus(s) {
  switch (s) {
    case /* WAITING */0 :
        return "대기중...";
    case /* PROCESSING */1 :
        return "처리중...";
    case /* SUCCESS */2 :
        return "성공";
    case /* FAIL */3 :
        return "실패";
    
  }
}

function displayError(errorCode) {
  if (errorCode === undefined) {
    return null;
  }
  switch (errorCode.TAG | 0) {
    case /* Deposit */4 :
        return "주문가능금액 부족";
    case /* ProductId */5 :
        return "상품코드 에러";
    case /* Sku */6 :
        return "옵션코드 에러";
    case /* S3GetObject */0 :
    case /* RequiredColumns */1 :
    case /* ExcelCell */2 :
    case /* EncryptedDocument */3 :
    case /* OrderProductNo */7 :
    case /* OrdererId */8 :
    case /* Etc */9 :
        return "주문서 양식 에러";
    case /* AfterPay */10 :
        return "나중결제 한도 부족";
    
  }
}

function textOnConfirmButton(errorCode) {
  if (errorCode === undefined) {
    return "";
  }
  switch (errorCode.TAG | 0) {
    case /* Deposit */4 :
        return "추가 결제하기";
    case /* ProductId */5 :
    case /* Sku */6 :
        return "운영코드 보기";
    case /* S3GetObject */0 :
    case /* RequiredColumns */1 :
    case /* ExcelCell */2 :
    case /* EncryptedDocument */3 :
    case /* OrderProductNo */7 :
    case /* OrdererId */8 :
    case /* Etc */9 :
        return "발주 메뉴얼 보기";
    case /* AfterPay */10 :
        return "";
    
  }
}

function errorMessage(errorCode) {
  if (errorCode === undefined) {
    return null;
  }
  switch (errorCode.TAG | 0) {
    case /* Deposit */4 :
        return React.createElement(React.Fragment, undefined, "주문가능금액이 부족해\n발주에 실패했습니다.\n추가 결제를 진행해 주시기 바랍니다.\n");
    case /* ProductId */5 :
    case /* Sku */6 :
        break;
    case /* OrderProductNo */7 :
    case /* OrdererId */8 :
    case /* Etc */9 :
        return "" + errorCode._0 + "\n";
    case /* AfterPay */10 :
        return React.createElement(React.Fragment, undefined, "나중결제 잔여 한도 부족으로 발주에 실패했습니다.\n주문 금액을 조정하여 다시 재업로드해주세요.\n");
    default:
      return "양식에 맞지 않은 주문서입니다.\n아래와 같은 이유로 실패할 수 있습니다.\n\n";
  }
  return React.createElement(React.Fragment, undefined, "업로드한 주문서 ", React.createElement("span", {
                  className: "font-bold"
                }, errorCode._0), "\n상품코드를 재확인하신 후 업로드해주세요.");
}

function linkOfGuide(errorCode) {
  if (errorCode === undefined) {
    return Env.buyerUploadGuideUri;
  }
  switch (errorCode.TAG | 0) {
    case /* Deposit */4 :
        return "/buyer/transactions";
    case /* ProductId */5 :
    case /* Sku */6 :
        return "/buyer/products/advanced-search";
    default:
      return Env.buyerUploadGuideUri;
  }
}

function openInNewTab(elementId) {
  var linkToGuide = Belt_Option.flatMap(Caml_option.nullable_to_opt(document.getElementById(elementId)), Webapi__Dom__Element.asHtmlElement);
  if (linkToGuide !== undefined) {
    Caml_option.valFromOption(linkToGuide).click();
    return ;
  }
  
}

function UploadStatus_Buyer(Props) {
  var kind = Props.kind;
  var onChangeLatestUpload = Props.onChangeLatestUpload;
  var uploadType = Props.uploadType;
  var prevUploadedDateTime = React.useRef(undefined);
  var match = React.useState(function () {
        return {
                errorCode: undefined,
                isShow: /* Hide */1
              };
      });
  var setErrorDetail = match[1];
  var errorDetail = match[0];
  var status = CustomHooks.UploadStatus.use(kind, uploadType);
  React.useEffect((function () {
          if (typeof status !== "number" && status.TAG === /* Loaded */0) {
            var data$p = CustomHooks.UploadStatus.response_decode(status._0);
            if (data$p.TAG === /* Ok */0) {
              var latestUpload = Garter_Array.first(data$p._0.data);
              var match = prevUploadedDateTime.current;
              if (match !== undefined) {
                if (latestUpload !== undefined && latestUpload.status === /* SUCCESS */2 && match !== latestUpload.createdAt) {
                  Curry._1(onChangeLatestUpload, undefined);
                  prevUploadedDateTime.current = latestUpload.createdAt;
                }
                
              } else if (latestUpload !== undefined) {
                prevUploadedDateTime.current = latestUpload.createdAt;
              }
              
            }
            
          }
          
        }), [status]);
  var tmp;
  if (typeof status === "number") {
    tmp = React.createElement("div", undefined, "로딩 중..");
  } else if (status.TAG === /* Loaded */0) {
    var data$p = CustomHooks.UploadStatus.response_decode(status._0);
    if (data$p.TAG === /* Ok */0) {
      var data$p$1 = data$p._0;
      tmp = React.createElement(React.Fragment, undefined, Garter_Array.isEmpty(data$p$1.data) ? React.createElement("div", undefined, "업로드 한 내역이 없습니다.") : Garter_Array.map(data$p$1.data, (function (d) {
                    var match = d.errorCode;
                    var dataGtm = match !== undefined ? "btn-recent-order-error-show-detail" : "btn-recent-order-success-show-detail";
                    var match$1 = d.status;
                    var match$2 = d.errorCode;
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
                                        className: "flex"
                                      }, React.createElement("span", {
                                            className: styleStatus(d.status)
                                          }, displayStatus(d.status)), React.createElement("span", {
                                            className: "flex-auto ml-2 text-red-500 truncate"
                                          }, displayError(d.errorCode)), React.createElement(ReactUtil.SpreadProps.make, {
                                            children: React.createElement("span", {
                                                  className: "whitespace-nowrap ml-1 text-gray-400 underline",
                                                  onClick: (function (param) {
                                                      setErrorDetail(function (param) {
                                                            return {
                                                                    errorCode: d.errorCode,
                                                                    isShow: /* Show */0
                                                                  };
                                                          });
                                                    })
                                                }, uploadType >= 3 ? (
                                                    match$1 !== 2 ? (
                                                        match$2 !== undefined ? "자세히보기" : null
                                                      ) : (
                                                        match$2 !== undefined && match$2 === undefined ? null : "자세히보기"
                                                      )
                                                  ) : (
                                                    match$2 !== undefined ? "자세히보기" : null
                                                  )),
                                            props: {
                                              "data-gtm": dataGtm
                                            }
                                          }))));
                  })));
    } else {
      console.log("error: ", data$p._0);
      tmp = null;
    }
  } else {
    tmp = React.createElement("div", undefined, "에러가 발생하였습니다.");
  }
  var match$1 = errorDetail.errorCode;
  var tmp$1;
  var exit = 0;
  if (match$1 !== undefined) {
    switch (match$1.TAG | 0) {
      case /* S3GetObject */0 :
      case /* RequiredColumns */1 :
      case /* ExcelCell */2 :
      case /* EncryptedDocument */3 :
          exit = 1;
          break;
      default:
        tmp$1 = null;
    }
  } else {
    tmp$1 = null;
  }
  if (exit === 1) {
    tmp$1 = React.createElement("p", {
          className: "whitespace-pre-wrap text-left text-black-gl font-bold"
        }, "1.[주문서 양식]에서 행(2~3행)을 삭제하지 않고\n업로드했을 경우\n2.엑셀 (xlsx,xls) 형식이 아닌 경우\n3. 필수 값에 빈 값이 있을 경우\n4. 엑셀에 비밀번호가 걸려있을 경우");
  }
  var match$2 = errorDetail.errorCode;
  return React.createElement(React.Fragment, undefined, React.createElement("section", {
                  className: "table table-fixed w-full"
                }, tmp), React.createElement(Dialog.make, {
                  isShow: errorDetail.isShow,
                  children: null,
                  onCancel: (function (param) {
                      setErrorDetail(function (param) {
                            return {
                                    errorCode: undefined,
                                    isShow: /* Hide */1
                                  };
                          });
                    }),
                  onConfirm: (function (param) {
                      setErrorDetail(function (param) {
                            return {
                                    errorCode: undefined,
                                    isShow: /* Hide */1
                                  };
                          });
                      var match = errorDetail.errorCode;
                      if (match !== undefined) {
                        return openInNewTab("link-of-guide");
                      }
                      
                    }),
                  textOnCancel: "닫기",
                  textOnConfirm: textOnConfirmButton(errorDetail.errorCode)
                }, React.createElement("a", {
                      className: "hidden",
                      id: "link-of-guide",
                      href: linkOfGuide(errorDetail.errorCode),
                      target: "_blank"
                    }), React.createElement("p", {
                      className: "whitespace-pre-wrap text-text-L1 text-center"
                    }, errorMessage(errorDetail.errorCode)), tmp$1, uploadType >= 3 && match$2 === undefined ? "나중결제로 주문을 등록했어요. 맨 상단 [내역보기]를 눌러 만기일 및 상환필요금액을 확인하세요." : null));
}

var make = UploadStatus_Buyer;

export {
  formatDate ,
  formatTime ,
  styleStatus ,
  displayStatus ,
  displayError ,
  textOnConfirmButton ,
  errorMessage ,
  linkOfGuide ,
  openInNewTab ,
  make ,
}
/* Env Not a pure module */
