// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Env from "../constants/Env.mjs";
import * as $$Intl from "../bindings/intl.mjs";
import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as DS_Tab from "./common/container/DS_Tab.mjs";
import * as Global from "./Global.mjs";
import * as DS_Icon from "./svgs/DS_Icon.mjs";
import * as DataGtm from "../utils/DataGtm.mjs";
import * as Belt_Int from "rescript/lib/es6/belt_Int.js";
import * as DS_Input from "./common/element/DS_Input.mjs";
import * as DS_Title from "./common/container/DS_Title.mjs";
import * as DS_Button from "./common/element/DS_Button.mjs";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as Belt_Float from "rescript/lib/es6/belt_Float.js";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as DS_ListItem from "./common/container/DS_ListItem.mjs";
import * as Garter_Array from "@greenlabs/garter/src/Garter_Array.mjs";
import * as DS_InputField from "./common/container/DS_InputField.mjs";

function convertNumberInputValue(value) {
  return value.replace(/[^0-9]/g, "").replace(/^[0]/g, "");
}

function numberToComma(n) {
  return Belt_Option.mapWithDefault(Belt_Float.fromString(n), "", (function (x) {
                return $$Intl.Currency.make(x, "ko-KR", undefined, undefined, undefined);
              }));
}

function RfqApplyDetail_Buyer$Grade$List(Props) {
  var edges = Props.edges;
  var madeIn = Props.madeIn;
  var handleOnChangeGrade = Props.handleOnChangeGrade;
  var grade = Props.grade;
  return Belt_Array.map(Belt_Array.keep(edges, (function (x) {
                    return x.node.madeIn === madeIn;
                  })), (function (x) {
                var isSelected = Belt_Option.mapWithDefault(grade, false, (function (grade$p) {
                        return grade$p === x.node.id;
                      }));
                return React.createElement(DS_ListItem.Normal1.Item.make, {
                            children: null,
                            onClick: (function (param) {
                                Curry._1(handleOnChangeGrade, x.node.id);
                              }),
                            key: x.node.id
                          }, React.createElement(DS_ListItem.Normal1.TextGroup.make, {
                                title1: x.node.grade
                              }), React.createElement(DS_ListItem.Normal1.RightGroup.make, {
                                children: isSelected ? React.createElement(DS_Icon.Common.RadioOnLarge1.make, {
                                        height: "24",
                                        width: "24",
                                        fill: "#12B564"
                                      }) : React.createElement(DS_Icon.Common.RadioOffLarge1.make, {
                                        height: "24",
                                        width: "24",
                                        fill: "#B2B2B2"
                                      })
                              }));
              }));
}

var List = {
  make: RfqApplyDetail_Buyer$Grade$List
};

function RfqApplyDetail_Buyer$Grade(Props) {
  var grade = Props.grade;
  var handleOnChangeGrade = Props.handleOnChangeGrade;
  var node = Props.node;
  var species = node.species;
  var isBeef = Belt_Option.mapWithDefault(species, false, (function (x) {
          return x.name === "소고기";
        }));
  var isDomestic = Belt_Option.mapWithDefault(node.part, false, (function (x) {
          return x.isDomestic;
        }));
  var edges = Belt_Option.mapWithDefault(species, [], (function (x) {
          return x.meatGrades.edges;
        }));
  var match = React.useState(function () {
        if (isDomestic) {
          return "KR";
        } else if (isBeef) {
          return "US";
        } else {
          return "OTHER";
        }
      });
  var setMadeIn = match[1];
  var madeIn = match[0];
  return React.createElement("section", {
              className: "pt-7 pb-28"
            }, React.createElement(DS_Title.Normal1.Root.make, {
                  children: React.createElement(DS_Title.Normal1.TextGroup.make, {
                        title1: "찾으시는 상품의",
                        title2: "등급을 선택해주세요"
                      })
                }), React.createElement("article", {
                  className: "px-5"
                }, React.createElement(DS_Tab.LeftTab.Root.make, {
                      children: isDomestic ? React.createElement(DS_Tab.LeftTab.Item.make, {
                              children: React.createElement(DS_Button.Chip.TextSmall1.make, {
                                    label: "국내산",
                                    selected: madeIn === "KR",
                                    className: "text-sm",
                                    onClick: (function (param) {
                                        setMadeIn(function (param) {
                                              return "KR";
                                            });
                                      })
                                  })
                            }) : (
                          isBeef ? React.createElement(React.Fragment, undefined, React.createElement(DS_Tab.LeftTab.Item.make, {
                                      children: React.createElement(DS_Button.Chip.TextSmall1.make, {
                                            label: "미국산",
                                            selected: madeIn === "US",
                                            className: "text-sm",
                                            onClick: (function (param) {
                                                setMadeIn(function (param) {
                                                      return "US";
                                                    });
                                              })
                                          })
                                    }), React.createElement(DS_Tab.LeftTab.Item.make, {
                                      children: React.createElement(DS_Button.Chip.TextSmall1.make, {
                                            label: "호주산",
                                            selected: madeIn === "AU",
                                            className: "text-sm",
                                            onClick: (function (param) {
                                                setMadeIn(function (param) {
                                                      return "AU";
                                                    });
                                              })
                                          })
                                    }), React.createElement(DS_Tab.LeftTab.Item.make, {
                                      children: React.createElement(DS_Button.Chip.TextSmall1.make, {
                                            label: "캐나다산",
                                            selected: madeIn === "CA",
                                            className: "text-sm",
                                            onClick: (function (param) {
                                                setMadeIn(function (param) {
                                                      return "CA";
                                                    });
                                              })
                                          })
                                    }), React.createElement(DS_Tab.LeftTab.Item.make, {
                                      children: React.createElement(DS_Button.Chip.TextSmall1.make, {
                                            label: "뉴질랜드산",
                                            selected: madeIn === "NZ",
                                            className: "text-sm",
                                            onClick: (function (param) {
                                                setMadeIn(function (param) {
                                                      return "NZ";
                                                    });
                                              })
                                          })
                                    })) : React.createElement(DS_Tab.LeftTab.Item.make, {
                                  children: React.createElement(DS_Button.Chip.TextSmall1.make, {
                                        label: "수입산",
                                        selected: madeIn === "OTHER",
                                        className: "text-sm",
                                        onClick: (function (param) {
                                            setMadeIn(function (param) {
                                                  return "OTHER";
                                                });
                                          })
                                      })
                                })
                        ),
                      className: "mt-8 space-x-0"
                    })), React.createElement(DS_ListItem.Normal1.Root.make, {
                  children: React.createElement(RfqApplyDetail_Buyer$Grade$List, {
                        edges: edges,
                        madeIn: madeIn,
                        handleOnChangeGrade: handleOnChangeGrade,
                        grade: grade
                      }),
                  className: "space-y-8 mt-11 tab-highlight-color"
                }));
}

var Grade = {
  List: List,
  make: RfqApplyDetail_Buyer$Grade
};

function RfqApplyDetail_Buyer$OrderAmount(Props) {
  var weightKg = Props.weightKg;
  var handleOnChangeWeightKg = Props.handleOnChangeWeightKg;
  return React.createElement("section", {
              className: "pt-7"
            }, React.createElement(DS_Title.Normal1.Root.make, {
                  children: React.createElement(DS_Title.Normal1.TextGroup.make, {
                        title1: "주문량을",
                        title2: "작성해주세요"
                      })
                }), React.createElement(DS_InputField.Line1.Root.make, {
                  children: React.createElement(DS_InputField.Line1.Input.make, {
                        type_: "text",
                        placeholder: "납품 1회당 배송량",
                        value: Belt_Option.mapWithDefault(weightKg, "", (function (x) {
                                return numberToComma(Garter_Array.firstExn(x.split(".")));
                              })),
                        onChange: (function (e) {
                            var value = e.target.value;
                            Curry._1(handleOnChangeWeightKg, convertNumberInputValue(value));
                          }),
                        autoFocus: true,
                        inputMode: "decimal",
                        isClear: true,
                        fnClear: (function (param) {
                            Curry._1(handleOnChangeWeightKg, "");
                          }),
                        unit: "kg",
                        errorMessage: Belt_Option.mapWithDefault(weightKg, undefined, (function (x) {
                                return Belt_Option.mapWithDefault(Belt_Option.flatMap(Garter_Array.first(x.split(".")), Belt_Int.fromString), undefined, (function (x) {
                                              if (x < 50) {
                                                return "최소 주문량은 " + String(50) + "kg 입니다.";
                                              }
                                              
                                            }));
                              })),
                        underLabel: "최소 주문량 " + String(50) + "kg",
                        underLabelType: "ton",
                        maxLength: 6
                      }),
                  className: "mt-4"
                }));
}

var OrderAmount = {
  make: RfqApplyDetail_Buyer$OrderAmount
};

function RfqApplyDetail_Buyer$Purpose(Props) {
  var usage = Props.usage;
  var setUsage = Props.setUsage;
  var edges = Props.edges;
  return React.createElement("section", {
              className: "pt-7 pb-28"
            }, React.createElement(DS_Title.Normal1.Root.make, {
                  children: React.createElement(DS_Title.Normal1.TextGroup.make, {
                        title1: "사용용도를 알려주세요"
                      })
                }), React.createElement("div", {
                  className: "flex justify-end items-center px-5 mt-1.5"
                }, React.createElement("span", {
                      className: "text-[13px] text-enabled-L2"
                    }, "중복 선택 가능")), React.createElement(DS_ListItem.Normal1.Root.make, {
                  children: Belt_Array.map(edges, (function (param) {
                          var match = param.node;
                          var id = match.id;
                          var isUnChecked = Garter_Array.isEmpty(Belt_Array.keep(usage, (function (x) {
                                      return x === id;
                                    })));
                          return React.createElement(DS_ListItem.Normal1.Item.make, {
                                      children: null,
                                      onClick: (function (param) {
                                          setUsage(function (prev) {
                                                if (isUnChecked) {
                                                  return Belt_Array.concat(prev, [id]);
                                                } else {
                                                  return Belt_Array.keep(prev, (function (x) {
                                                                return x !== id;
                                                              }));
                                                }
                                              });
                                        }),
                                      key: id
                                    }, React.createElement(DS_ListItem.Normal1.TextGroup.make, {
                                          title1: match.name,
                                          titleStyle: "text-lg"
                                        }), React.createElement(DS_ListItem.Normal1.RightGroup.make, {
                                          children: isUnChecked ? React.createElement(DS_Icon.Common.UncheckedLarge1.make, {
                                                  height: "22",
                                                  width: "22"
                                                }) : React.createElement(DS_Icon.Common.CheckedLarge1.make, {
                                                  height: "22",
                                                  width: "22",
                                                  fill: "#12B564"
                                                })
                                        }));
                        })),
                  className: "mt-7 space-y-8 tab-highlight-color"
                }));
}

var Purpose = {
  make: RfqApplyDetail_Buyer$Purpose
};

function RfqApplyDetail_Buyer$StorageMethod$List(Props) {
  var arr = Props.arr;
  var handleOnChangeStorageMethod = Props.handleOnChangeStorageMethod;
  var storageMethod = Props.storageMethod;
  return Belt_Array.map(arr, (function (x) {
                var value = x[1];
                var isSelected = Belt_Option.mapWithDefault(storageMethod, false, (function (storageMethod$p) {
                        return storageMethod$p === value;
                      }));
                return React.createElement(DS_ListItem.Normal1.Item.make, {
                            children: null,
                            onClick: (function (param) {
                                Curry._1(handleOnChangeStorageMethod, value);
                              }),
                            key: value
                          }, React.createElement(DS_ListItem.Normal1.TextGroup.make, {
                                title1: x[0]
                              }), React.createElement(DS_ListItem.Normal1.RightGroup.make, {
                                children: isSelected ? React.createElement(DS_Icon.Common.RadioOnLarge1.make, {
                                        height: "24",
                                        width: "24",
                                        fill: "#12B564"
                                      }) : React.createElement(DS_Icon.Common.RadioOffLarge1.make, {
                                        height: "24",
                                        width: "24",
                                        fill: "#B2B2B2"
                                      })
                              }));
              }));
}

var List$1 = {
  make: RfqApplyDetail_Buyer$StorageMethod$List
};

function RfqApplyDetail_Buyer$StorageMethod(Props) {
  var storageMethod = Props.storageMethod;
  var handleOnChangeStorageMethod = Props.handleOnChangeStorageMethod;
  return React.createElement("section", {
              className: "pt-7"
            }, React.createElement(DS_Title.Normal1.Root.make, {
                  children: React.createElement(DS_Title.Normal1.TextGroup.make, {
                        title1: "원하시는 보관상태를",
                        title2: "선택해주세요"
                      })
                }), React.createElement(DS_ListItem.Normal1.Root.make, {
                  children: React.createElement(RfqApplyDetail_Buyer$StorageMethod$List, {
                        arr: [
                          [
                            "냉동",
                            "FROZEN"
                          ],
                          [
                            "냉장",
                            "CHILLED"
                          ],
                          [
                            "동결",
                            "FREEZE_DRIED"
                          ]
                        ],
                        handleOnChangeStorageMethod: handleOnChangeStorageMethod,
                        storageMethod: storageMethod
                      }),
                  className: "space-y-8 text-lg mt-11 tab-highlight-color"
                }));
}

var StorageMethod = {
  List: List$1,
  make: RfqApplyDetail_Buyer$StorageMethod
};

function RfqApplyDetail_Buyer$PackageMethod(Props) {
  var packageMethod = Props.packageMethod;
  var handleOnChangePackageMethod = Props.handleOnChangePackageMethod;
  return React.createElement("section", {
              className: "pt-7"
            }, React.createElement(DS_Title.Normal1.Root.make, {
                  children: React.createElement(DS_Title.Normal1.TextGroup.make, {
                        title1: "원하시는 포장상태를",
                        title2: "선택해주세요"
                      })
                }), React.createElement(DS_ListItem.Normal1.Root.make, {
                  children: React.createElement(DS_ListItem.Normal1.Item.make, {
                        children: null,
                        onClick: (function (param) {
                            Curry._1(handleOnChangePackageMethod, Belt_Option.isNone(packageMethod) ? "RAW" : "");
                          })
                      }, React.createElement(DS_ListItem.Normal1.TextGroup.make, {
                            title1: "원료육(박스육)"
                          }), React.createElement(DS_ListItem.Normal1.RightGroup.make, {
                            children: Belt_Option.mapWithDefault(packageMethod, React.createElement(DS_Icon.Common.UncheckedLarge1.make, {
                                      height: "22",
                                      width: "22"
                                    }), (function (param) {
                                    return React.createElement(DS_Icon.Common.CheckedLarge1.make, {
                                                height: "22",
                                                width: "22",
                                                fill: "#12B564"
                                              });
                                  }))
                          })),
                  className: "space-y-8 text-lg mt-9 tab-highlight-color"
                }), React.createElement("div", {
                  className: "absolute w-full bottom-[108px] px-5 flex justify-between"
                }, React.createElement("div", {
                      className: "leading-6 tracking-tight"
                    }, React.createElement("h5", undefined, "세절/분쇄가 필요한 경우,"), React.createElement("h5", undefined, "담당자에게 문의 부탁드립니다.")), React.createElement(DataGtm.make, {
                      children: React.createElement("button", {
                            className: "text-[15px] leading-6 tracking-tight font-bold rounded-lg px-3.5 py-3 border border-border-default-L1 bg-surface",
                            onClick: (function (param) {
                                if (Global.$$window !== undefined) {
                                  Caml_option.valFromOption(Global.$$window).open("" + Env.customerServiceUrl + "" + Env.customerServicePaths.rfqMeatProcess + "", undefined, "");
                                  return ;
                                }
                                
                              })
                          }, "문의하기"),
                      dataGtm: "Contact_RFQ_Livestock_PackageMethod"
                    })));
}

var PackageMethod = {
  make: RfqApplyDetail_Buyer$PackageMethod
};

function RfqApplyDetail_Buyer$SupplyPrice(Props) {
  var prevTradeSellerName = Props.prevTradeSellerName;
  var handleOnChangePrevTradeSellerName = Props.handleOnChangePrevTradeSellerName;
  var prevTradePricePerKg = Props.prevTradePricePerKg;
  var handleOnChangePrevTradePricePerKg = Props.handleOnChangePrevTradePricePerKg;
  return React.createElement("section", {
              className: "pt-7"
            }, React.createElement(DS_Title.Normal1.Root.make, {
                  children: React.createElement(DS_Title.Normal1.TextGroup.make, {
                        title1: "기존 거래 단가를",
                        title2: "알려주세요"
                      })
                }), React.createElement(DS_InputField.Line1.Root.make, {
                  children: React.createElement(DS_InputField.Line1.Input.make, {
                        type_: "text",
                        placeholder: "기존 거래 단가",
                        value: numberToComma(Belt_Option.getWithDefault(prevTradePricePerKg, "")),
                        onChange: (function (e) {
                            var value = e.target.value;
                            Curry._1(handleOnChangePrevTradePricePerKg, convertNumberInputValue(value));
                          }),
                        inputMode: "decimal",
                        isClear: true,
                        fnClear: (function (param) {
                            Curry._1(handleOnChangePrevTradePricePerKg, "");
                          }),
                        unit: "원/kg",
                        errorMessage: Belt_Option.mapWithDefault(prevTradePricePerKg, undefined, (function (x) {
                                return Belt_Option.mapWithDefault(Belt_Option.flatMap(Garter_Array.first(x.split(".")), Belt_Int.fromString), undefined, (function (x) {
                                              if (x < 100) {
                                                return "최소 거래 단가는 100원/kg 입니다.";
                                              }
                                              
                                            }));
                              })),
                        underLabelType: "won",
                        maxLength: 7
                      }),
                  className: "mt-10"
                }), React.createElement(DS_InputField.Line1.Root.make, {
                  children: React.createElement(DS_InputField.Line1.Input.make, {
                        type_: "text",
                        placeholder: "기존 거래처명",
                        value: Belt_Option.getWithDefault(prevTradeSellerName, ""),
                        onChange: (function (e) {
                            Curry._1(handleOnChangePrevTradeSellerName, e.target.value);
                          }),
                        isClear: true,
                        fnClear: (function (param) {
                            Curry._1(handleOnChangePrevTradeSellerName, "");
                          }),
                        maxLength: 30
                      }),
                  className: "mt-5"
                }));
}

var SupplyPrice = {
  make: RfqApplyDetail_Buyer$SupplyPrice
};

function RfqApplyDetail_Buyer$Brand(Props) {
  var preferredBrand = Props.preferredBrand;
  var handleOnChangePreferredBrand = Props.handleOnChangePreferredBrand;
  return React.createElement("section", {
              className: "pt-7"
            }, React.createElement(DS_Title.Normal1.Root.make, {
                  children: React.createElement(DS_Title.Normal1.TextGroup.make, {
                        title1: "선호 브랜드를",
                        title2: "작성해주세요"
                      })
                }), React.createElement(DS_InputField.Line1.Root.make, {
                  children: React.createElement(DS_InputField.Line1.Input.make, {
                        type_: "text",
                        placeholder: "예: Excel",
                        value: Belt_Option.getWithDefault(preferredBrand, ""),
                        onChange: (function (e) {
                            Curry._1(handleOnChangePreferredBrand, e.target.value);
                          }),
                        isClear: true,
                        fnClear: (function (param) {
                            Curry._1(handleOnChangePreferredBrand, "");
                          }),
                        maxLength: 100
                      }),
                  className: "mt-4"
                }));
}

var Brand = {
  make: RfqApplyDetail_Buyer$Brand
};

function RfqApplyDetail_Buyer$Etc(Props) {
  var etc = Props.etc;
  var handleOnChangeEtc = Props.handleOnChangeEtc;
  return React.createElement("section", {
              className: "pt-7"
            }, React.createElement(DS_Title.Normal1.Root.make, {
                  children: React.createElement(DS_Title.Normal1.TextGroup.make, {
                        title1: "기타 요청사항을",
                        title2: "남겨주세요"
                      })
                }), React.createElement("div", {
                  className: "px-5"
                }, React.createElement(DS_Input.InputText1.make, {
                      type_: "text",
                      className: "mt-7",
                      placeholder: "예: 무항생제 찾습니다",
                      value: Belt_Option.getWithDefault(etc, ""),
                      onChange: (function (e) {
                          Curry._1(handleOnChangeEtc, e.target.value);
                        }),
                      autoFocus: true,
                      maxLength: 300
                    })));
}

var Etc = {
  make: RfqApplyDetail_Buyer$Etc
};

export {
  convertNumberInputValue ,
  numberToComma ,
  Grade ,
  OrderAmount ,
  Purpose ,
  StorageMethod ,
  PackageMethod ,
  SupplyPrice ,
  Brand ,
  Etc ,
}
/* Env Not a pure module */
