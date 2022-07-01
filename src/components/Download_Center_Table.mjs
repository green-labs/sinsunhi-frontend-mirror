// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Env from "../constants/Env.mjs";
import * as React from "react";
import * as Dialog from "./common/Dialog.mjs";
import * as Helper from "../utils/Helper.mjs";
import * as Caml_obj from "rescript/lib/es6/caml_obj.js";
import * as Constants from "../constants/Constants.mjs";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as Pagination from "./common/Pagination.mjs";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as CustomHooks from "../utils/CustomHooks.mjs";
import * as FetchHelper from "../utils/FetchHelper.mjs";
import Format from "date-fns/format";
import * as IconNaviDownload from "./svgs/IconNaviDownload.mjs";
import * as Select_CountPerPage from "./Select_CountPerPage.mjs";
import * as Webapi__Dom__Element from "rescript-webapi/src/Webapi/Dom/Webapi__Dom__Element.mjs";
import * as Webapi__Dom__Document from "rescript-webapi/src/Webapi/Dom/Webapi__Dom__Document.mjs";

function Download_Center_Table$DownloadTableHead(Props) {
  return React.createElement("header", undefined, React.createElement("ul", {
                  className: "sm:flex hidden flex-row items-center w-full py-3 px-4 bg-gray-50 rounded mt-4 text-sm text-text-L2"
                }, React.createElement("li", {
                      className: "w-1/5 min-w-[150px]"
                    }, "요청일시"), React.createElement("li", {
                      className: "w-2/5"
                    }, "파일명"), React.createElement("li", {
                      className: "w-2/5"
                    }, "다운로드")));
}

var DownloadTableHead = {
  make: Download_Center_Table$DownloadTableHead
};

function Download_Center_Table$DownloadTableRow(Props) {
  var data = Props.data;
  var match = React.useState(function () {
        return /* Hide */1;
      });
  var setShowDownloadError = match[1];
  var match$1 = React.useState(function () {
        
      });
  var setErrorMessageDownload = match$1[1];
  var handleErr = function (message) {
    setErrorMessageDownload(function (param) {
          return message;
        });
    return setShowDownloadError(function (param) {
                return /* Show */0;
              });
  };
  var isExpired = function (expiredAt) {
    var now = new Date(Date.now());
    if (expiredAt !== undefined) {
      return Caml_obj.caml_lessthan(new Date(expiredAt), now);
    } else {
      return false;
    }
  };
  var statusSplit = function (param) {
    var status = param.status;
    var filename = param.filename;
    var id = param.id;
    if (status !== 2) {
      if (status >= 3) {
        return React.createElement("p", {
                    className: "text-emphasis"
                  }, "생성오류");
      } else {
        return React.createElement("p", {
                    className: "text-primary"
                  }, "생성중...");
      }
    } else if (isExpired(param.expiredAt)) {
      return React.createElement("p", {
                  className: "text-text-L2"
                }, "기한만료");
    } else {
      return React.createElement("p", {
                  className: "flex flex-row items-center"
                }, React.createElement("span", undefined, "생성완료"), React.createElement(IconNaviDownload.make, {
                      width: "1rem",
                      height: "1.2rem",
                      className: "ml-5 cursor-pointer",
                      onClick: (function (param) {
                          var requestId = String(id);
                          FetchHelper.requestWithRetry(FetchHelper.getWithToken, Env.restApiUrl + "/excel-export/" + requestId + "/download-url", "", 3, (function (res) {
                                  var err = CustomHooks.AdminS3PresignedUrl.response_decode(res);
                                  if (err.TAG !== /* Ok */0) {
                                    return handleErr(err._0.message);
                                  }
                                  var downloadUrl = err._0.downloadUrl;
                                  var link = Webapi__Dom__Element.asHtmlElement(document.createElement("a"));
                                  var body = Belt_Option.flatMap(Webapi__Dom__Document.asHtmlDocument(document), (function (prim) {
                                          return Caml_option.nullable_to_opt(prim.body);
                                        }));
                                  Helper.$$Option.map2(link, body, (function (link$p, body$p) {
                                          link$p.setAttribute("href", downloadUrl);
                                          link$p.setAttribute("download", filename);
                                          link$p.setAttribute("style", "{display: none;}");
                                          body$p.appendChild(link$p);
                                          link$p.click();
                                          body$p.removeChild(link$p);
                                          
                                        }));
                                  
                                }), (function (err) {
                                  return handleErr(err.message);
                                }));
                          
                        })
                    }));
    }
  };
  var dateSplit = function (date) {
    var s = date.split("T");
    if (s.length !== 2) {
      return ;
    }
    var a = s[0];
    var b = s[1];
    return [
            a,
            b
          ];
  };
  var match$2 = Belt_Option.getWithDefault(dateSplit(Format(new Date(data.requestAt), "yyyy-MM-dd'T'HH:mm:ss")), [
        "",
        ""
      ]);
  return React.createElement(React.Fragment, undefined, React.createElement("ul", {
                  className: "flex flex-row items-center w-full py-4 border-b border-div-border-L2 flex-wrap sm:py-3 sm:px-4 sm:flex-nowrap"
                }, React.createElement("li", {
                      className: "flex flex-row basis-1/3 sm:w-1/5 order-1 min-w-max sm:basis-1/5"
                    }, React.createElement("span", undefined, match$2[0]), React.createElement("span", {
                          className: "text-text-L2 ml-1"
                        }, match$2[1])), React.createElement("li", {
                      className: "mt-1 w-2/5 basis-full order-3 overflow-x-hidden whitespace-nowrap text-ellipsis sm:basis-2/5 sm:mt-0 sm:order-2"
                    }, data.filename), React.createElement("li", {
                      className: "flex justify-end ml-2.5 sm:ml-0 w-2/5 order-2 min-w-max sm:justify-start sm:order-3"
                    }, statusSplit(data))), React.createElement(Dialog.make, {
                  isShow: match[0],
                  children: React.createElement("p", {
                        className: "text-gray-500 text-center whitespace-pre-wrap"
                      }, Belt_Option.getWithDefault(match$1[0], "다운로드에 실패하였습니다.\n다시 시도하시기 바랍니다.")),
                  onConfirm: (function (param) {
                      return setShowDownloadError(function (param) {
                                  return /* Hide */1;
                                });
                    })
                }));
}

var DownloadTableRow = {
  make: Download_Center_Table$DownloadTableRow
};

function Download_Center_Table(Props) {
  var downloads$p = Props["downloads'"];
  var count = downloads$p.count;
  return React.createElement("div", {
              className: "mt-5 p-5 bg-white rounded w-full min-h-[50vh] sm:min-h-[75vh] sm:p-7 sm:shadow-gl"
            }, React.createElement("p", {
                  className: "flex items-center mb-3"
                }, React.createElement("h3", {
                      className: "font-bold"
                    }, "다운로드 요청내역"), React.createElement("span", {
                      className: "ml-2 text-primary"
                    }, String(count) + "건")), React.createElement("div", {
                  className: "flex flex-col sm:flex-row sm:justify-between sm:items-center"
                }, React.createElement("span", {
                      className: "sm:text-sm"
                    }, "생성완료 후 7일간 다운로드 가능합니다."), count !== 0 ? React.createElement(Select_CountPerPage.make, {
                        className: "my-5 sm:my-0 w-fit"
                      }) : null), count !== 0 ? React.createElement(React.Fragment, undefined, React.createElement(Download_Center_Table$DownloadTableHead, {}), React.createElement("main", undefined, Belt_Array.map(downloads$p.data, (function (data) {
                              return React.createElement(Download_Center_Table$DownloadTableRow, {
                                          data: data,
                                          key: data.filename + data.requestAt
                                        });
                            })), React.createElement("div", {
                            className: "flex flex-row items-center my-7 w-full justify-center"
                          }, React.createElement(Pagination.make, {
                                pageDisplySize: Constants.pageDisplySize,
                                itemPerPage: downloads$p.limit,
                                total: count
                              })))) : React.createElement("main", {
                    className: "flex flex-row justify-center items-center w-full min-h-screen text-sm text-text-L2"
                  }, "요청하신 다운로드가 없습니다."));
}

var make = Download_Center_Table;

export {
  DownloadTableHead ,
  DownloadTableRow ,
  make ,
  
}
/* Env Not a pure module */