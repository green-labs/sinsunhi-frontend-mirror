// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "rescript/lib/es6/curry.js";
import * as Spice from "@greenlabs/ppx-spice/src/rescript/Spice.mjs";
import * as React from "react";
import * as Js_dict from "rescript/lib/es6/js_dict.js";
import * as Js_json from "rescript/lib/es6/js_json.js";
import * as IconError from "./svgs/IconError.mjs";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Belt_Result from "rescript/lib/es6/belt_Result.js";
import * as ReactSelect from "./common/ReactSelect.mjs";
import * as Garter_Array from "@greenlabs/garter/src/Garter_Array.mjs";
import ReactSelect$1 from "react-select";
import * as ReactHookForm from "../bindings/ReactHookForm/ReactHookForm.mjs";
import * as ReactHookForm$1 from "react-hook-form";
import * as ErrorMessage from "@hookform/error-message";
import * as Select_Display_Category from "./Select_Display_Category.mjs";

function defaultDisplayCategory(categoryType) {
  var displayCategory = [
    [
      "c1",
      ReactSelect.encoderRule(/* NotSelected */0)
    ],
    [
      "c2",
      ReactSelect.encoderRule(/* NotSelected */0)
    ],
    [
      "c3",
      ReactSelect.encoderRule(/* NotSelected */0)
    ],
    [
      "c4",
      ReactSelect.encoderRule(/* NotSelected */0)
    ],
    [
      "c5",
      ReactSelect.encoderRule(/* NotSelected */0)
    ]
  ];
  var defaultCategoryType = categoryType ? [
      "categoryType",
      ReactSelect.encoderRule(/* Selected */{
            value: "showcase",
            label: "기획전"
          })
    ] : [
      "categoryType",
      ReactSelect.encoderRule(/* Selected */{
            value: "normal",
            label: "일반"
          })
    ];
  return Js_dict.fromArray(Belt_Array.concat(displayCategory, [defaultCategoryType]));
}

function submit_encode(v) {
  return Js_dict.fromArray([
              [
                "c5",
                Curry._1(ReactSelect.codecSelectOption[0], v.c5)
              ],
              [
                "c4",
                Curry._1(ReactSelect.codecSelectOption[0], v.c4)
              ],
              [
                "c3",
                Curry._1(ReactSelect.codecSelectOption[0], v.c3)
              ],
              [
                "c2",
                Curry._1(ReactSelect.codecSelectOption[0], v.c2)
              ],
              [
                "c1",
                Curry._1(ReactSelect.codecSelectOption[0], v.c1)
              ],
              [
                "categoryType",
                Curry._1(ReactSelect.codecSelectOption[0], v.categoryType)
              ]
            ]);
}

function submit_decode(v) {
  var dict = Js_json.classify(v);
  if (typeof dict === "number") {
    return Spice.error(undefined, "Not an object", v);
  }
  if (dict.TAG !== /* JSONObject */2) {
    return Spice.error(undefined, "Not an object", v);
  }
  var dict$1 = dict._0;
  var c5 = Curry._1(ReactSelect.codecSelectOption[1], Belt_Option.getWithDefault(Js_dict.get(dict$1, "c5"), null));
  if (c5.TAG === /* Ok */0) {
    var c4 = Curry._1(ReactSelect.codecSelectOption[1], Belt_Option.getWithDefault(Js_dict.get(dict$1, "c4"), null));
    if (c4.TAG === /* Ok */0) {
      var c3 = Curry._1(ReactSelect.codecSelectOption[1], Belt_Option.getWithDefault(Js_dict.get(dict$1, "c3"), null));
      if (c3.TAG === /* Ok */0) {
        var c2 = Curry._1(ReactSelect.codecSelectOption[1], Belt_Option.getWithDefault(Js_dict.get(dict$1, "c2"), null));
        if (c2.TAG === /* Ok */0) {
          var c1 = Curry._1(ReactSelect.codecSelectOption[1], Belt_Option.getWithDefault(Js_dict.get(dict$1, "c1"), null));
          if (c1.TAG === /* Ok */0) {
            var categoryType = Curry._1(ReactSelect.codecSelectOption[1], Belt_Option.getWithDefault(Js_dict.get(dict$1, "categoryType"), null));
            if (categoryType.TAG === /* Ok */0) {
              return {
                      TAG: /* Ok */0,
                      _0: {
                        c5: c5._0,
                        c4: c4._0,
                        c3: c3._0,
                        c2: c2._0,
                        c1: c1._0,
                        categoryType: categoryType._0
                      }
                    };
            }
            var e = categoryType._0;
            return {
                    TAG: /* Error */1,
                    _0: {
                      path: ".categoryType" + e.path,
                      message: e.message,
                      value: e.value
                    }
                  };
          }
          var e$1 = c1._0;
          return {
                  TAG: /* Error */1,
                  _0: {
                    path: ".c1" + e$1.path,
                    message: e$1.message,
                    value: e$1.value
                  }
                };
        }
        var e$2 = c2._0;
        return {
                TAG: /* Error */1,
                _0: {
                  path: ".c2" + e$2.path,
                  message: e$2.message,
                  value: e$2.value
                }
              };
      }
      var e$3 = c3._0;
      return {
              TAG: /* Error */1,
              _0: {
                path: ".c3" + e$3.path,
                message: e$3.message,
                value: e$3.value
              }
            };
    }
    var e$4 = c4._0;
    return {
            TAG: /* Error */1,
            _0: {
              path: ".c4" + e$4.path,
              message: e$4.message,
              value: e$4.value
            }
          };
  }
  var e$5 = c5._0;
  return {
          TAG: /* Error */1,
          _0: {
            path: ".c5" + e$5.path,
            message: e$5.message,
            value: e$5.value
          }
        };
}

var Form_formName = {
  c5: "c5",
  c4: "c4",
  c3: "c3",
  c2: "c2",
  c1: "c1",
  categoryType: "categoryType"
};

var Form = {
  formName: Form_formName,
  defaultDisplayCategory: defaultDisplayCategory,
  submit_encode: submit_encode,
  submit_decode: submit_decode
};

function encodeQualifiedNameValue(query) {
  var match = Belt_Option.map(Garter_Array.first(query), (function (param) {
          return param.type_;
        }));
  return {
          c5: Belt_Option.mapWithDefault(Belt_Array.get(query, 4), /* NotSelected */0, (function (d) {
                  return /* Selected */{
                          value: d.id,
                          label: d.name
                        };
                })),
          c4: Belt_Option.mapWithDefault(Belt_Array.get(query, 3), /* NotSelected */0, (function (d) {
                  return /* Selected */{
                          value: d.id,
                          label: d.name
                        };
                })),
          c3: Belt_Option.mapWithDefault(Belt_Array.get(query, 2), /* NotSelected */0, (function (d) {
                  return /* Selected */{
                          value: d.id,
                          label: d.name
                        };
                })),
          c2: Belt_Option.mapWithDefault(Belt_Array.get(query, 1), /* NotSelected */0, (function (d) {
                  return /* Selected */{
                          value: d.id,
                          label: d.name
                        };
                })),
          c1: Belt_Option.mapWithDefault(Belt_Array.get(query, 0), /* NotSelected */0, (function (d) {
                  return /* Selected */{
                          value: d.id,
                          label: d.name
                        };
                })),
          categoryType: match !== undefined ? (
              match === "NORMAL" ? /* Selected */({
                    value: "normal",
                    label: "일반"
                  }) : (
                  match === "SHOWCASE" ? /* Selected */({
                        value: "showcase",
                        label: "기획전"
                      }) : /* NotSelected */0
                )
            ) : /* NotSelected */0
        };
}

var categoryTypeOptions = [
  /* Selected */{
    value: "normal",
    label: "일반"
  },
  /* Selected */{
    value: "showcase",
    label: "기획전"
  }
];

function Select_Display_Categories$Select_CategoryType(Props) {
  var control = Props.control;
  var name = Props.name;
  var disabled = Props.disabled;
  var required = Props.required;
  return React.createElement(React.Fragment, undefined, React.createElement("div", {
                  className: "relative w-48"
                }, React.createElement("div", {
                      className: "absolute w-full"
                    }, React.createElement(ReactHookForm$1.Controller, {
                          name: name + ".categoryType",
                          control: control,
                          render: (function (param) {
                              var match = param.field;
                              var onChange = match.onChange;
                              return React.createElement(ReactSelect$1, {
                                          value: Belt_Result.getWithDefault(ReactSelect.decoderRule(match.value), /* NotSelected */0),
                                          options: categoryTypeOptions,
                                          onChange: (function (param) {
                                              return Curry._1(onChange, Curry._1(ReactHookForm.Controller.OnChangeArg.value, ReactSelect.encoderRule(param)));
                                            }),
                                          placeholder: "부류선택",
                                          noOptionsMessage: (function (param) {
                                              return "검색 결과가 없습니다.";
                                            }),
                                          isDisabled: disabled,
                                          styles: {
                                            control: (function (provide, param) {
                                                return Object.assign(Object.assign({}, provide), {
                                                            minHeight: "unset",
                                                            height: "2.25rem"
                                                          });
                                              })
                                          },
                                          ref: match.ref
                                        });
                            }),
                          rules: ReactHookForm.Rules.make(required, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined),
                          shouldUnregister: true
                        }))), React.createElement(Select_Display_Category.make, {
                  control: control,
                  name: name,
                  disabled: disabled,
                  required: required
                }));
}

var Select_CategoryType = {
  make: Select_Display_Categories$Select_CategoryType
};

function Select_Display_Categories(Props) {
  var control = Props.control;
  var name = Props.name;
  var disabledOpt = Props.disabled;
  var requiredOpt = Props.required;
  var disabled = disabledOpt !== undefined ? disabledOpt : false;
  var required = requiredOpt !== undefined ? requiredOpt : true;
  var match = ReactHookForm$1.useFormState({
        control: control
      });
  return React.createElement(React.Suspense, {
              children: null,
              fallback: React.createElement("div", undefined)
            }, React.createElement("div", {
                  className: "flex gap-2 h-9"
                }, React.createElement(Select_Display_Categories$Select_CategoryType, {
                      control: control,
                      name: name,
                      disabled: disabled,
                      required: required
                    })), React.createElement(ErrorMessage.ErrorMessage, {
                  name: name,
                  errors: match.errors,
                  render: (function (param) {
                      return React.createElement("span", {
                                  className: "flex"
                                }, React.createElement(IconError.make, {
                                      width: "20",
                                      height: "20"
                                    }), React.createElement("span", {
                                      className: "text-sm text-notice ml-1"
                                    }, "전시카테고리를 입력해주세요."));
                    })
                }));
}

var make = Select_Display_Categories;

export {
  Form ,
  encodeQualifiedNameValue ,
  categoryTypeOptions ,
  Select_CategoryType ,
  make ,
  
}
/* react Not a pure module */