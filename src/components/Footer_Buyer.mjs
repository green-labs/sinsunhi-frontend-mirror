// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import * as IconArrow from "./svgs/IconArrow.mjs";
import * as IconKakao from "./svgs/IconKakao.mjs";
import Link from "next/link";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as ChannelTalk from "../bindings/ChannelTalk.mjs";

function Footer_Buyer$PC(Props) {
  return React.createElement("footer", {
              className: "w-full h-[324px] bg-[#FBFBFB] text-gray-800"
            }, React.createElement("div", {
                  className: "w-[1280px] mx-auto flex justify-between pt-20 pb-10 px-5"
                }, React.createElement("div", {
                      className: "flex"
                    }, React.createElement(Link, {
                          href: "/buyer",
                          children: React.createElement("a", undefined, React.createElement("img", {
                                    className: "w-[104px] h-7 object-contain",
                                    alt: "sinsunhi-logo-footer-pc",
                                    src: "/assets/sinsunhi-logo.svg"
                                  }))
                        }), React.createElement("div", {
                          className: "ml-14"
                        }, React.createElement("ul", {
                              className: "flex items-center gap-2"
                            }, Belt_Array.mapWithIndex([
                                  {
                                    title: "회사소개",
                                    url: "https://greenlabs.co.kr"
                                  },
                                  {
                                    title: "이용약관",
                                    url: "https://greenlabs.notion.site/a9f5ca479dda4a34929c60e1ce1dfbe5"
                                  },
                                  {
                                    title: "개인정보 처리방침",
                                    url: "https://greenlabs.notion.site/7d92008918ba4ca6a806f83ec8f6c335"
                                  },
                                  {
                                    title: "저작권 보호 안내",
                                    url: "https://greenlabs.notion.site/ec15d857fcea4509806fc1a7a645f02d"
                                  }
                                ], (function (idx, param) {
                                    return React.createElement("li", {
                                                key: "footer-link-" + String(idx)
                                              }, React.createElement(Link, {
                                                    href: param.url,
                                                    children: React.createElement("a", {
                                                          className: "font-bold",
                                                          target: "_blank"
                                                        }, param.title)
                                                  }));
                                  }))), React.createElement("div", {
                              className: "mt-10 flex flex-col text-sm"
                            }, React.createElement("span", undefined, "주식회사 그린랩스"), React.createElement("span", undefined, "대표자 : 안동현, 최성우, 신상훈"), React.createElement("span", undefined, "서울시 송파구 정의로 8길 9 AJ 비전타워 3~6층"), React.createElement("div", undefined, React.createElement("span", undefined, "사업자 등록번호 : 320-88-00732"), React.createElement("span", {
                                      className: "ml-3"
                                    }, "통신판매업신고 : 2017-서울송파-1843호")), React.createElement(Link, {
                                  href: "https://www.ftc.go.kr/bizCommPop.do?wrkr_no=3208800732",
                                  children: React.createElement("a", {
                                        className: "flex",
                                        target: "_blank"
                                      }, React.createElement("span", {
                                            className: "text-sm text-gray-800 underline"
                                          }, "사업자 정보 확인"), React.createElement(IconArrow.make, {
                                            height: "16",
                                            width: "16",
                                            fill: "#262626",
                                            className: "mt-[2px]"
                                          }))
                                })))), React.createElement("div", undefined, React.createElement("div", {
                          className: "flex"
                        }, React.createElement("button", {
                              className: "h-12 bg-green-50 border-green-500 border rounded-lg flex items-center px-4",
                              onClick: (function (param) {
                                  return ChannelTalk.showMessenger(undefined);
                                })
                            }, React.createElement("img", {
                                  className: "w-[21px] h-[21px]",
                                  src: "/icons/channeltalk.svg"
                                }), React.createElement("span", {
                                  className: "text-green-500 font-bold ml-2"
                                }, "채널톡 문의")), React.createElement(Link, {
                              href: "https://pf.kakao.com/_JftIs",
                              children: React.createElement("a", {
                                    className: "h-12 ml-3 bg-[#FADE33] rounded-lg flex items-center px-4",
                                    target: "_blank"
                                  }, React.createElement(IconKakao.make, {}), React.createElement("span", {
                                        className: "font-bold ml-2"
                                      }, "카카오톡 문의"))
                            })), React.createElement("div", {
                          className: "flex flex-col mt-5 text-sm"
                        }, React.createElement("span", {
                              className: "font-bold"
                            }, "고객센터"), React.createElement("span", undefined, "출고/배송 문의 및 입점 제안"), React.createElement("span", undefined, "상품 CS 및 취소 문의"), React.createElement("span", {
                              className: "text-sm text-gray-800"
                            }, "월~금 : 10:00~17:00 (Break time 12:00~13:00)"), React.createElement("span", undefined, "tel : 1670-5245")))));
}

var PC = {
  make: Footer_Buyer$PC
};

function Footer_Buyer$MO(Props) {
  return React.createElement("div", {
              className: "w-full bg-[#FBFBFB]"
            }, React.createElement("footer", {
                  className: "w-full max-w-3xl mx-auto bg-[#FBFBFB] pt-10 pb-[100px] px-5 text-gray-800"
                }, React.createElement("section", {
                      className: "w-full"
                    }, React.createElement("ol", {
                          className: "w-full flex flex-wrap gap-5 items-center"
                        }, Belt_Array.mapWithIndex([
                              {
                                title: "회사소개",
                                url: "https://greenlabs.co.kr"
                              },
                              {
                                title: "이용약관",
                                url: "https://greenlabs.notion.site/a9f5ca479dda4a34929c60e1ce1dfbe5"
                              },
                              {
                                title: "개인정보 처리방침",
                                url: "https://greenlabs.notion.site/7d92008918ba4ca6a806f83ec8f6c335"
                              },
                              {
                                title: "저작권 보호 안내",
                                url: "https://greenlabs.notion.site/ec15d857fcea4509806fc1a7a645f02d"
                              }
                            ], (function (idx, param) {
                                return React.createElement("li", {
                                            key: "footer-link-" + String(idx)
                                          }, React.createElement(Link, {
                                                href: param.url,
                                                children: React.createElement("a", {
                                                      className: "font-bold",
                                                      target: "_blank"
                                                    }, param.title)
                                              }));
                              })))), React.createElement("section", {
                      className: "mt-5"
                    }, React.createElement("div", {
                          className: "flex flex-col text-sm"
                        }, React.createElement("span", undefined, "주식회사 그린랩스"), React.createElement("span", undefined, "대표자 : 안동현, 최성우, 신상훈"), React.createElement("span", undefined, "서울시 송파구 정의로 8길 9 AJ 비전타워 3~6층"), React.createElement("div", undefined, React.createElement("span", undefined, "사업자 등록번호 : 320-88-00732"), React.createElement("span", {
                                  className: "ml-3"
                                }, "통신판매업신고 : 2017-서울송파-1843호")), React.createElement(Link, {
                              href: "https://www.ftc.go.kr/bizCommPop.do?wrkr_no=3208800732",
                              children: React.createElement("a", {
                                    className: "flex",
                                    target: "_blank"
                                  }, React.createElement("span", {
                                        className: "underline"
                                      }, "사업자 정보 확인"), React.createElement(IconArrow.make, {
                                        height: "12",
                                        width: "12",
                                        fill: "#262626",
                                        className: "mt-1"
                                      }))
                            }))), React.createElement("section", {
                      className: "mt-6"
                    }, React.createElement("span", {
                          className: "text-sm font-bold"
                        }, "고객센터"), React.createElement("div", {
                          className: "mt-2 flex flex-col text-sm"
                        }, React.createElement("span", undefined, "출고/배송 문의 및 입점 제안"), React.createElement("span", undefined, "상품 CS 및 취소 문의"), React.createElement("span", undefined, "월~금 : 10:00~17:00 (Break time 12:00~13:00)"), React.createElement("span", undefined, "tel : 1670-5245"))), React.createElement("section", {
                      className: "mt-5"
                    }, React.createElement("div", {
                          className: "w-full h-12 flex gap-3"
                        }, React.createElement("button", {
                              className: "px-4 flex flex-1 bg-green-50 border-green-500 border rounded-lg items-center justify-center",
                              onClick: (function (param) {
                                  return ChannelTalk.showMessenger(undefined);
                                })
                            }, React.createElement("img", {
                                  className: "w-[21px] h-[21px]",
                                  src: "/icons/channeltalk.svg"
                                }), React.createElement("span", {
                                  className: "text-green-500 font-bold ml-2"
                                }, "채널톡 문의")), React.createElement(Link, {
                              href: "https://pf.kakao.com/_JftIs",
                              children: React.createElement("a", {
                                    className: "px-4 flex flex-1 bg-[#FADE33] rounded-lg items-center justify-center",
                                    target: "_blank"
                                  }, React.createElement(IconKakao.make, {}), React.createElement("span", {
                                        className: "font-bold ml-2"
                                      }, "카카오톡 문의"))
                            })))));
}

var MO = {
  make: Footer_Buyer$MO
};

export {
  PC ,
  MO ,
  
}
/* react Not a pure module */
