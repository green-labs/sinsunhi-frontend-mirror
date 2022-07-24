// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import * as Editor from "../../../../components/Editor.mjs";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as Router from "next/router";
import * as ReactRelay from "react-relay";
import * as Footer_Buyer from "../../../../components/Footer_Buyer.mjs";
import * as Header_Buyer from "../../../../components/Header_Buyer.mjs";
import * as PDP_Image_Buyer from "../common/PDP_Image_Buyer.mjs";
import * as PDP_Notice_Buyer from "../common/PDP_Notice_Buyer.mjs";
import * as Js_null_undefined from "rescript/lib/es6/js_null_undefined.js";
import * as PDP_Quoted_Title_Buyer from "./PDP_Quoted_Title_Buyer.mjs";
import * as RescriptRelay_Internal from "rescript-relay/src/RescriptRelay_Internal.mjs";
import * as PDP_Quoted_Modals_Buyer from "./PDP_Quoted_Modals_Buyer.mjs";
import * as PDP_Quoted_Submit_Buyer from "./PDP_Quoted_Submit_Buyer.mjs";
import * as PDP_SalesDocument_Buyer from "../common/PDP_SalesDocument_Buyer.mjs";
import * as PDP_Quoted_Details_Buyer from "./PDP_Quoted_Details_Buyer.mjs";
import * as PDP_Quoted_RequestGuide_Buyer from "./PDP_Quoted_RequestGuide_Buyer.mjs";
import * as PDPQuotedBuyerFragment_graphql from "../../../../__generated__/PDPQuotedBuyerFragment_graphql.mjs";

function use(fRef) {
  var data = ReactRelay.useFragment(PDPQuotedBuyerFragment_graphql.node, fRef);
  return RescriptRelay_Internal.internal_useConvertedValue(PDPQuotedBuyerFragment_graphql.Internal.convertFragment, data);
}

function useOpt(opt_fRef) {
  var fr = opt_fRef !== undefined ? Caml_option.some(Caml_option.valFromOption(opt_fRef)) : undefined;
  var nullableFragmentData = ReactRelay.useFragment(PDPQuotedBuyerFragment_graphql.node, fr !== undefined ? Js_null_undefined.fromOption(Caml_option.some(Caml_option.valFromOption(fr))) : null);
  var data = (nullableFragmentData == null) ? undefined : Caml_option.some(nullableFragmentData);
  return RescriptRelay_Internal.internal_useConvertedValue((function (rawFragment) {
                if (rawFragment !== undefined) {
                  return PDPQuotedBuyerFragment_graphql.Internal.convertFragment(rawFragment);
                }
                
              }), data);
}

var Fragment = {
  Types: undefined,
  Operation: undefined,
  use: use,
  useOpt: useOpt
};

function PDP_Quoted_Buyer$PC(Props) {
  var query = Props.query;
  var router = Router.useRouter();
  var match = use(query);
  var fragmentRefs = match.fragmentRefs;
  var match$1 = React.useState(function () {
        return /* Hide */0;
      });
  var setShowModal = match$1[1];
  return React.createElement(React.Fragment, undefined, React.createElement("div", {
                  className: "w-full min-w-[1280px] min-h-screen"
                }, React.createElement(Header_Buyer.PC.make, {
                      key: router.asPath
                    }), React.createElement("div", {
                      className: "w-[1280px] mx-auto min-h-full"
                    }, React.createElement("div", {
                          className: "w-full pt-16 px-5 divide-y"
                        }, React.createElement("section", {
                              className: "w-full flex pb-12 gap-20"
                            }, React.createElement("div", undefined, React.createElement(PDP_Image_Buyer.PC.make, {
                                      src: match.image.thumb1920x1920
                                    }), Belt_Option.mapWithDefault(match.salesDocument, null, (function (salesDocument$p) {
                                        return React.createElement(PDP_SalesDocument_Buyer.PC.make, {
                                                    salesDocument: salesDocument$p
                                                  });
                                      }))), React.createElement("div", {
                                  className: "w-full"
                                }, React.createElement(PDP_Quoted_Title_Buyer.PC.make, {
                                      displayName: match.displayName
                                    }), React.createElement("section", {
                                      className: "mt-4 border border-gray-200 rounded-xl divide-y"
                                    }, React.createElement("div", {
                                          className: "px-6 py-8 divide-y"
                                        }, React.createElement(PDP_Quoted_Details_Buyer.PC.make, {
                                              query: fragmentRefs
                                            }), React.createElement("div", {
                                              className: "flex flex-col gap-6 pt-6"
                                            }, React.createElement(PDP_Quoted_RequestGuide_Buyer.PC.make, {})))), React.createElement("section", {
                                      className: "w-full mt-4"
                                    }, React.createElement(PDP_Quoted_Submit_Buyer.PC.make, {
                                          setShowModal: setShowModal,
                                          query: fragmentRefs
                                        })))), React.createElement("section", {
                              className: "pt-16"
                            }, React.createElement("span", {
                                  className: "text-2xl font-bold text-gray-800"
                                }, "상세 설명"), React.createElement(PDP_Notice_Buyer.PC.make, {
                                  notice: match.notice,
                                  noticeStartAt: match.noticeStartAt,
                                  noticeEndAt: match.noticeEndAt
                                }), React.createElement("div", {
                                  className: "py-16"
                                }, React.createElement(Editor.Viewer.make, {
                                      value: match.description
                                    }))))), React.createElement(Footer_Buyer.PC.make, {})), React.createElement(PDP_Quoted_Modals_Buyer.PC.make, {
                  show: match$1[0],
                  setShow: setShowModal
                }));
}

var PC = {
  make: PDP_Quoted_Buyer$PC
};

function PDP_Quoted_Buyer$MO(Props) {
  var query = Props.query;
  var router = Router.useRouter();
  var match = use(query);
  var fragmentRefs = match.fragmentRefs;
  var match$1 = React.useState(function () {
        return /* Hide */0;
      });
  var setShowModal = match$1[1];
  return React.createElement(React.Fragment, undefined, React.createElement("div", {
                  className: "w-full min-h-screen"
                }, React.createElement("div", {
                      className: "w-full bg-white"
                    }, React.createElement("div", {
                          className: "w-full max-w-3xl mx-auto bg-white min-h-screen"
                        }, React.createElement(Header_Buyer.Mobile.make, {
                              key: router.asPath
                            }), React.createElement("section", {
                              className: "flex flex-col gap-5"
                            }, React.createElement(PDP_Image_Buyer.MO.make, {
                                  src: match.image.thumb1000x1000
                                })), React.createElement("section", {
                              className: "px-5 divide-y"
                            }, React.createElement("div", {
                                  className: "w-full divide-y"
                                }, React.createElement("section", {
                                      className: "pt-5 pb-8"
                                    }, React.createElement(PDP_Quoted_Title_Buyer.MO.make, {
                                          displayName: match.displayName
                                        })), React.createElement("section", {
                                      className: "py-8"
                                    }, React.createElement(PDP_Quoted_Details_Buyer.MO.make, {
                                          query: fragmentRefs
                                        })), React.createElement("section", {
                                      className: "py-8 flex flex-col gap-5"
                                    }, React.createElement(PDP_Quoted_RequestGuide_Buyer.MO.make, {}), React.createElement(PDP_Quoted_Submit_Buyer.MO.make, {
                                          setShowModal: setShowModal,
                                          query: fragmentRefs
                                        }))), Belt_Option.mapWithDefault(match.salesDocument, null, (function (salesDocument$p) {
                                    return React.createElement(PDP_SalesDocument_Buyer.MO.make, {
                                                salesDocument: salesDocument$p
                                              });
                                  })), React.createElement("div", {
                                  className: "flex flex-col gap-5 py-8"
                                }, React.createElement("h1", {
                                      className: "text-text-L1 text-base font-bold"
                                    }, "상세설명"), React.createElement(PDP_Notice_Buyer.MO.make, {
                                      notice: match.notice,
                                      noticeStartAt: match.noticeStartAt,
                                      noticeEndAt: match.noticeEndAt
                                    }), React.createElement("div", {
                                      className: "w-full overflow-x-scroll"
                                    }, React.createElement(Editor.Viewer.make, {
                                          value: match.description
                                        })))), React.createElement(Footer_Buyer.MO.make, {})))), React.createElement(PDP_Quoted_Modals_Buyer.MO.make, {
                  show: match$1[0],
                  setShow: setShowModal
                }));
}

var MO = {
  make: PDP_Quoted_Buyer$MO
};

function PDP_Quoted_Buyer(Props) {
  var deviceType = Props.deviceType;
  var query = Props.query;
  switch (deviceType) {
    case /* Unknown */0 :
        return null;
    case /* PC */1 :
        return React.createElement(PDP_Quoted_Buyer$PC, {
                    query: query
                  });
    case /* Mobile */2 :
        return React.createElement(PDP_Quoted_Buyer$MO, {
                    query: query
                  });
    
  }
}

var make = PDP_Quoted_Buyer;

export {
  Fragment ,
  PC ,
  MO ,
  make ,
}
/* react Not a pure module */
