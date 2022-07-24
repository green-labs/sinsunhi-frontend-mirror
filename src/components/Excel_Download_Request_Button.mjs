// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Env from "../constants/Env.mjs";
import * as React from "react";
import * as Dialog from "./common/Dialog.mjs";
import * as IconCheck from "./svgs/IconCheck.mjs";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as FetchHelper from "../utils/FetchHelper.mjs";
import * as Router from "next/router";
import * as ReactToastNotifications from "react-toast-notifications";
import DownloadSvg from "../../public/assets/download.svg";

var downloadIcon = DownloadSvg;

function Excel_Download_Request_Button(Props) {
  var userType = Props.userType;
  var requestUrl = Props.requestUrl;
  var buttonText = Props.buttonText;
  var bodyOption = Props.bodyOption;
  var router = Router.useRouter();
  var match = ReactToastNotifications.useToasts();
  var addToast = match.addToast;
  var match$1 = React.useState(function () {
        return /* Hide */1;
      });
  var setIsShowRequest = match$1[1];
  var match$2 = React.useState(function () {
        return /* Hide */1;
      });
  var setIsShowMoveToDownloadCenter = match$2[1];
  var match$3 = React.useState(function () {
        
      });
  var setErrorMessageDownload = match$3[1];
  var match$4 = React.useState(function () {
        return /* Hide */1;
      });
  var setShowDownloadError = match$4[1];
  var downloadCenterPath;
  switch (userType) {
    case /* Seller */0 :
        downloadCenterPath = "/seller/download-center";
        break;
    case /* Buyer */1 :
        downloadCenterPath = "/buyer/download-center";
        break;
    case /* Admin */2 :
        downloadCenterPath = "/admin/download-center";
        break;
    
  }
  var menuLocation = userType >= 2 ? "좌측" : "우측 상단";
  var download = function (param) {
    Belt_Option.map(JSON.stringify(Belt_Option.getWithDefault(bodyOption, router.query)), (function (body) {
            return FetchHelper.requestWithRetry(FetchHelper.postWithTokenForExcel, "" + Env.restApiUrl + "" + requestUrl + "", body, 3, (function (param) {
                          setIsShowMoveToDownloadCenter(function (param) {
                                return /* Show */0;
                              });
                        }), (function (err) {
                          setErrorMessageDownload(function (param) {
                                return err.message;
                              });
                          setShowDownloadError(function (param) {
                                return /* Show */0;
                              });
                        }));
          }));
  };
  return React.createElement(React.Fragment, undefined, React.createElement("button", {
                  className: "h-9 px-3 text-black-gl bg-gray-button-gl rounded-lg flex items-center min-w-max",
                  onClick: (function (param) {
                      setIsShowRequest(function (param) {
                            return /* Show */0;
                          });
                    })
                }, React.createElement("img", {
                      className: "relative mr-1",
                      src: downloadIcon
                    }), Belt_Option.getWithDefault(buttonText, "엑셀 다운로드 요청")), React.createElement(Dialog.make, {
                  isShow: match$1[0],
                  children: React.createElement("span", {
                        className: "flex items-center justify-center w-full py-10"
                      }, React.createElement("strong", undefined, "엑셀 다운로드"), React.createElement("span", undefined, "를 요청하시겠어요?")),
                  onCancel: (function (param) {
                      setIsShowRequest(function (param) {
                            return /* Hide */1;
                          });
                    }),
                  onConfirm: (function (param) {
                      download(undefined);
                      setIsShowRequest(function (param) {
                            return /* Hide */1;
                          });
                      addToast(React.createElement("div", {
                                className: "flex items-center"
                              }, React.createElement(IconCheck.make, {
                                    height: "24",
                                    width: "24",
                                    fill: "#12B564",
                                    className: "mr-2"
                                  }), "다운로드 파일 생성을 요청합니다."), {
                            appearance: "success"
                          });
                    }),
                  textOnCancel: "닫기"
                }), React.createElement(Dialog.make, {
                  isShow: match$2[0],
                  children: React.createElement("span", {
                        className: "flex flex-col items-center justify-center w-full py-5"
                      }, React.createElement("span", {
                            className: "flex"
                          }, React.createElement("strong", undefined, "엑셀 다운로드 요청"), React.createElement("span", undefined, "이 완료되었어요.")), React.createElement("span", undefined, React.createElement("strong", undefined, "다운로드 센터"), React.createElement("span", undefined, "로 이동하시겠어요?")), React.createElement("span", {
                            className: "mt-10 whitespace-pre-wrap"
                          }, "*다운로드 파일 생성 진행은 " + menuLocation + "\n 다운로드 센터에서 확인하실 수 있어요.")),
                  onCancel: (function (param) {
                      setIsShowMoveToDownloadCenter(function (param) {
                            return /* Hide */1;
                          });
                    }),
                  onConfirm: (function (param) {
                      router.push(downloadCenterPath);
                    }),
                  textOnCancel: "닫기"
                }), React.createElement(Dialog.make, {
                  isShow: match$4[0],
                  children: React.createElement("p", {
                        className: "text-gray-500 text-center whitespace-pre-wrap"
                      }, Belt_Option.getWithDefault(match$3[0], "다운로드에 실패하였습니다.\n다시 시도하시기 바랍니다.")),
                  onConfirm: (function (param) {
                      setShowDownloadError(function (param) {
                            return /* Hide */1;
                          });
                    })
                }));
}

var make = Excel_Download_Request_Button;

export {
  downloadIcon ,
  make ,
}
/* downloadIcon Not a pure module */
