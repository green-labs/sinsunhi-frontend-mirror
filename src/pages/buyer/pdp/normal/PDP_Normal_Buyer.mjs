// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import * as Editor from "../../../../components/Editor.mjs";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as Router from "next/router";
import * as Footer_Buyer from "../../../../components/Footer_Buyer.mjs";
import * as Header_Buyer from "../../../../components/Header_Buyer.mjs";
import * as PDP_Image_Buyer from "../common/PDP_Image_Buyer.mjs";
import * as PDP_Notice_Buyer from "../common/PDP_Notice_Buyer.mjs";
import * as Js_null_undefined from "rescript/lib/es6/js_null_undefined.js";
import * as Hooks from "react-relay/hooks";
import * as PDP_Normal_Title_Buyer from "./PDP_Normal_Title_Buyer.mjs";
import * as RescriptRelay_Internal from "rescript-relay/src/RescriptRelay_Internal.mjs";
import * as PDP_Normal_Modals_Buyer from "./PDP_Normal_Modals_Buyer.mjs";
import * as PDP_Normal_Submit_Buyer from "./PDP_Normal_Submit_Buyer.mjs";
import * as PDP_SalesDocument_Buyer from "../common/PDP_SalesDocument_Buyer.mjs";
import * as PDP_Normal_Details_Buyer from "./PDP_Normal_Details_Buyer.mjs";
import * as PDP_Normal_TotalPrice_Buyer from "./PDP_Normal_TotalPrice_Buyer.mjs";
import * as PDP_Normal_SelectOption_Buyer from "./PDP_Normal_SelectOption_Buyer.mjs";
import * as PDPNormalBuyerFragment_graphql from "../../../../__generated__/PDPNormalBuyerFragment_graphql.mjs";
import * as PDP_Normal_DeliveryGuide_Buyer from "./PDP_Normal_DeliveryGuide_Buyer.mjs";
import * as PDP_Normal_QuantityInput_Buyer from "./PDP_Normal_QuantityInput_Buyer.mjs";

function use(fRef) {
  var data = Hooks.useFragment(PDPNormalBuyerFragment_graphql.node, fRef);
  return RescriptRelay_Internal.internal_useConvertedValue(PDPNormalBuyerFragment_graphql.Internal.convertFragment, data);
}

function useOpt(opt_fRef) {
  var fr = opt_fRef !== undefined ? Caml_option.some(Caml_option.valFromOption(opt_fRef)) : undefined;
  var nullableFragmentData = Hooks.useFragment(PDPNormalBuyerFragment_graphql.node, fr !== undefined ? Js_null_undefined.fromOption(Caml_option.some(Caml_option.valFromOption(fr))) : null);
  var data = (nullableFragmentData == null) ? undefined : Caml_option.some(nullableFragmentData);
  return RescriptRelay_Internal.internal_useConvertedValue((function (rawFragment) {
                if (rawFragment !== undefined) {
                  return PDPNormalBuyerFragment_graphql.Internal.convertFragment(rawFragment);
                }
                
              }), data);
}

var Fragment_productStatus_decode = PDPNormalBuyerFragment_graphql.Utils.productStatus_decode;

var Fragment_productStatus_fromString = PDPNormalBuyerFragment_graphql.Utils.productStatus_fromString;

var Fragment = {
  productStatus_decode: Fragment_productStatus_decode,
  productStatus_fromString: Fragment_productStatus_fromString,
  Types: undefined,
  use: use,
  useOpt: useOpt
};

function PDP_Normal_Buyer$PC(Props) {
  var query = Props.query;
  var router = Router.useRouter();
  var match = use(query);
  var fragmentRefs = match.fragmentRefs;
  var match$1 = React.useState(function () {
        return 1;
      });
  var setQuantity = match$1[1];
  var quantity = match$1[0];
  var match$2 = React.useState(function () {
        
      });
  var selectedOptionId = match$2[0];
  var match$3 = React.useState(function () {
        return /* Hide */0;
      });
  var setShowModal = match$3[1];
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
                                }, React.createElement(PDP_Normal_Title_Buyer.PC.make, {
                                      displayName: match.displayName,
                                      price: match.price,
                                      isSoldout: match.status === "SOLDOUT"
                                    }), React.createElement("section", {
                                      className: "border border-gray-200 rounded-xl divide-y"
                                    }, React.createElement("div", {
                                          className: "px-6 py-8 divide-y"
                                        }, React.createElement(PDP_Normal_Details_Buyer.PC.make, {
                                              query: fragmentRefs
                                            }), React.createElement("div", {
                                              className: "flex flex-col gap-6 py-6"
                                            }, React.createElement(PDP_Normal_DeliveryGuide_Buyer.PC.make, {}), React.createElement(PDP_Normal_SelectOption_Buyer.PC.make, {
                                                  query: fragmentRefs,
                                                  onSelect: match$2[1],
                                                  setShowModal: setShowModal
                                                })), React.createElement(PDP_Normal_QuantityInput_Buyer.PC.make, {
                                              query: fragmentRefs,
                                              selectedOptionId: selectedOptionId,
                                              quantity: quantity,
                                              setQuantity: setQuantity
                                            })), React.createElement(PDP_Normal_TotalPrice_Buyer.PC.make, {
                                          query: fragmentRefs,
                                          selectedOptionId: selectedOptionId,
                                          quantity: quantity
                                        })), React.createElement("section", {
                                      className: "w-full mt-4"
                                    }, React.createElement(PDP_Normal_Submit_Buyer.PC.make, {
                                          query: fragmentRefs,
                                          selectedOptionId: selectedOptionId,
                                          setShowModal: setShowModal,
                                          quantity: quantity
                                        })))), React.createElement("section", {
                              className: "pt-16"
                            }, React.createElement("span", {
                                  className: "text-2xl font-bold text-gray-800"
                                }, "?????? ??????"), React.createElement(PDP_Notice_Buyer.PC.make, {
                                  notice: match.notice,
                                  noticeStartAt: match.noticeStartAt,
                                  noticeEndAt: match.noticeEndAt
                                }), React.createElement("div", {
                                  className: "py-16"
                                }, React.createElement(Editor.Viewer.make, {
                                      value: match.description
                                    }))), React.createElement("section", {
                              className: "w-full py-16 flex justify-center"
                            }, React.createElement("div", {
                                  className: "w-full max-w-[600px] aspect-[209/1361]"
                                }, React.createElement("img", {
                                      className: "w-full h-full object-cover",
                                      alt: "pdp-delivery-guide-mo",
                                      src: "https://public.sinsunhi.com/images/20220616/f15dcb82-7b3e-482d-a32a-ab56791617da/%E1%84%89%E1%85%A1%E1%86%BC%E1%84%89%E1%85%A6%20CS%E1%84%80%E1%85%A9%E1%86%BC%E1%84%90%E1%85%A9%E1%86%BC%E1%84%8B%E1%85%A7%E1%86%BC%E1%84%8B%E1%85%A7%E1%86%A8%20%E1%84%8E%E1%85%AC%E1%84%8E%E1%85%AC%E1%84%8C%E1%85%A9%E1%86%BC.jpg"
                                    }))))), React.createElement(Footer_Buyer.PC.make, {})), React.createElement(PDP_Normal_Modals_Buyer.PC.make, {
                  show: match$3[0],
                  setShow: setShowModal,
                  selectedOptionId: selectedOptionId,
                  quantity: quantity,
                  setQuantity: setQuantity
                }));
}

var PC = {
  make: PDP_Normal_Buyer$PC
};

function PDP_Normal_Buyer$MO(Props) {
  var query = Props.query;
  var router = Router.useRouter();
  var match = use(query);
  var fragmentRefs = match.fragmentRefs;
  var match$1 = React.useState(function () {
        return 1;
      });
  var setQuantity = match$1[1];
  var quantity = match$1[0];
  var match$2 = React.useState(function () {
        
      });
  var selectedOptionId = match$2[0];
  var match$3 = React.useState(function () {
        return /* Hide */0;
      });
  var setShowModal = match$3[1];
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
                                    }, React.createElement(PDP_Normal_Title_Buyer.MO.make, {
                                          displayName: match.displayName,
                                          price: match.price,
                                          isSoldout: match.status === "SOLDOUT"
                                        }), React.createElement("div", {
                                          className: "pt-4"
                                        }, React.createElement(PDP_Normal_SelectOption_Buyer.MO.make, {
                                              query: fragmentRefs,
                                              onSelect: match$2[1],
                                              setShowModal: setShowModal
                                            }))), React.createElement(PDP_Normal_QuantityInput_Buyer.MO.make, {
                                      query: fragmentRefs,
                                      selectedOptionId: selectedOptionId,
                                      quantity: quantity,
                                      setQuantity: setQuantity
                                    }), React.createElement("section", {
                                      className: "py-8 flex flex-col gap-6"
                                    }, React.createElement(PDP_Normal_TotalPrice_Buyer.MO.make, {
                                          query: fragmentRefs,
                                          selectedOptionId: selectedOptionId,
                                          quantity: quantity
                                        }), React.createElement(PDP_Normal_Submit_Buyer.MO.make, {
                                          query: fragmentRefs,
                                          selectedOptionId: selectedOptionId,
                                          setShowModal: setShowModal,
                                          quantity: quantity
                                        })), React.createElement("section", {
                                      className: "py-8"
                                    }, React.createElement(PDP_Normal_Details_Buyer.MO.make, {
                                          query: fragmentRefs
                                        })), React.createElement("section", {
                                      className: "py-8"
                                    }, React.createElement(PDP_Normal_DeliveryGuide_Buyer.MO.make, {}))), Belt_Option.mapWithDefault(match.salesDocument, null, (function (salesDocument$p) {
                                    return React.createElement(PDP_SalesDocument_Buyer.MO.make, {
                                                salesDocument: salesDocument$p
                                              });
                                  })), React.createElement("div", {
                                  className: "flex flex-col gap-5 py-8"
                                }, React.createElement("h1", {
                                      className: "text-text-L1 text-base font-bold"
                                    }, "????????????"), React.createElement(PDP_Notice_Buyer.MO.make, {
                                      notice: match.notice,
                                      noticeStartAt: match.noticeStartAt,
                                      noticeEndAt: match.noticeEndAt
                                    }), React.createElement("div", {
                                      className: "w-full overflow-x-scroll"
                                    }, React.createElement(Editor.Viewer.make, {
                                          value: match.description
                                        })))), React.createElement("section", {
                              className: "px-5 py-8"
                            }, React.createElement("div", {
                                  className: "w-full aspect-[209/1361]"
                                }, React.createElement("img", {
                                      className: "w-full h-full object-cover",
                                      alt: "pdp-delivery-guide-mo",
                                      src: "https://public.sinsunhi.com/images/20220616/f15dcb82-7b3e-482d-a32a-ab56791617da/%E1%84%89%E1%85%A1%E1%86%BC%E1%84%89%E1%85%A6%20CS%E1%84%80%E1%85%A9%E1%86%BC%E1%84%90%E1%85%A9%E1%86%BC%E1%84%8B%E1%85%A7%E1%86%BC%E1%84%8B%E1%85%A7%E1%86%A8%20%E1%84%8E%E1%85%AC%E1%84%8E%E1%85%AC%E1%84%8C%E1%85%A9%E1%86%BC.jpg"
                                    }))), React.createElement(Footer_Buyer.MO.make, {})))), React.createElement(PDP_Normal_Modals_Buyer.MO.make, {
                  show: match$3[0],
                  setShow: setShowModal,
                  selectedOptionId: selectedOptionId,
                  quantity: quantity,
                  setQuantity: setQuantity
                }));
}

var MO = {
  make: PDP_Normal_Buyer$MO
};

function PDP_Normal_Buyer(Props) {
  var deviceType = Props.deviceType;
  var query = Props.query;
  switch (deviceType) {
    case /* Unknown */0 :
        return null;
    case /* PC */1 :
        return React.createElement(PDP_Normal_Buyer$PC, {
                    query: query
                  });
    case /* Mobile */2 :
        return React.createElement(PDP_Normal_Buyer$MO, {
                    query: query
                  });
    
  }
}

var make = PDP_Normal_Buyer;

export {
  Fragment ,
  PC ,
  MO ,
  make ,
  
}
/* react Not a pure module */
