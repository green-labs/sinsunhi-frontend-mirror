// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Env from "../../constants/Env.mjs";
import * as Swr from "swr";
import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as Dialog from "../../components/common/Dialog.mjs";
import Head from "next/head";
import * as CustomHooks from "../../utils/CustomHooks.mjs";
import * as OfflineOrders_Upload_Admin from "../../components/OfflineOrders_Upload_Admin.mjs";
import * as OfflineOrders_UploadStatus_Admin from "../../components/OfflineOrders_UploadStatus_Admin.mjs";

function AddOfflineOrders_Admin(Props) {
  var user = Curry._1(CustomHooks.User.Admin.use, undefined);
  var match = Swr.useSWRConfig();
  var mutate = match.mutate;
  var match$1 = React.useState(function () {
        return /* Hide */1;
      });
  var setShowSuccess = match$1[1];
  var match$2 = React.useState(function () {
        return /* Hide */1;
      });
  var setShowError = match$2[1];
  var handleUploadSuccess = function (param) {
    setShowSuccess(function (param) {
          return /* Show */0;
        });
    return mutate(Env.restApiUrl + "/offline-orders/recent-uploads?upload-type=order", undefined, undefined);
  };
  return React.createElement(React.Fragment, undefined, React.createElement(Head, {
                  children: React.createElement("title", undefined, "관리자 오프라인 주문등록")
                }), typeof user === "number" ? (
                user !== 0 ? React.createElement("div", undefined, "로그인이 필요 합니다.") : React.createElement("div", undefined, "인증 확인 중 입니다.")
              ) : React.createElement(React.Fragment, undefined, React.createElement("div", {
                        className: "py-8 px-4 bg-div-shape-L1 min-h-screen"
                      }, React.createElement("header", {
                            className: "md:flex md:items-baseline pb-0"
                          }, React.createElement("h1", {
                                className: "font-bold text-xl"
                              }, "오프라인 주문서 등록")), React.createElement("div", {
                            className: "flex flex-col bg-white mt-5 p-7"
                          }, React.createElement("h2", {
                                className: "font-bold text-lg"
                              }, "주문 업로드", React.createElement("span", {
                                    className: "ml-2 text-base text-text-L3 font-normal"
                                  }, React.createElement("a", {
                                        className: "underline focus:outline-none",
                                        download: "off_order_sample.xlsx",
                                        href: Env.s3PublicUrl + "/order/off_order_sample.xlsx"
                                      }, "샘플양식 다운로드"))), React.createElement(OfflineOrders_Upload_Admin.make, {
                                onSuccess: handleUploadSuccess,
                                onFailure: (function (param) {
                                    return setShowError(function (param) {
                                                return /* Hide */1;
                                              });
                                  })
                              }), React.createElement("div", {
                                className: "mt-9"
                              }, React.createElement(OfflineOrders_UploadStatus_Admin.make, {})))), React.createElement(Dialog.make, {
                        isShow: match$1[0],
                        children: React.createElement("p", {
                              className: "text-gray-500 text-center whitespace-pre-wrap"
                            }, "주문서 업로드가 실행되었습니다. 성공여부를 꼭 주문서 업로드 결과에서 확인해주세요."),
                        onConfirm: (function (param) {
                            return setShowSuccess(function (param) {
                                        return /* Hide */1;
                                      });
                          })
                      }), React.createElement(Dialog.make, {
                        isShow: match$2[0],
                        children: React.createElement("p", {
                              className: "text-gray-500 text-center whitespace-pre-wrap"
                            }, "파일 업로드에 실패하였습니다."),
                        onConfirm: (function (param) {
                            return setShowError(function (param) {
                                        return /* Hide */1;
                                      });
                          })
                      })));
}

var UploadFile;

var UploadStatus;

var make = AddOfflineOrders_Admin;

export {
  UploadFile ,
  UploadStatus ,
  make ,
  
}
/* Env Not a pure module */
