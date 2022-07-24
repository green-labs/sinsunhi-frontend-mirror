// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Cx from "rescript-classnames/src/Cx.mjs";
import * as React from "react";
import * as IconError from "../svgs/IconError.mjs";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as ReactTooltip from "@radix-ui/react-tooltip";

var normalStyle = "border border-border-default-L1 focus:outline-none focus:ring-1-gl focus:border-border-active focus:ring-opacity-100 remove-spin-button ";

var errorStyle = "border outline-none ring-2 ring-opacity-100 ring-notice remove-spin-button";

var disabledStyle = "bg-disabled-L3 border border-border-default-L1 focus:outline-none focus:ring-1-gl remove-spin-button focus:border-border-active";

function style(error, disabled) {
  if (disabled !== undefined) {
    if (disabled) {
      return disabledStyle;
    } else if (error !== undefined) {
      return errorStyle;
    } else {
      return normalStyle;
    }
  } else if (error !== undefined) {
    return errorStyle;
  } else {
    return normalStyle;
  }
}

function inputStyleBySize(style, size) {
  if (size === undefined) {
    return Cx.cx([
                "w-full flex-1 rounded-lg h-10 px-3",
                style
              ]);
  }
  switch (size) {
    case /* Large */0 :
        return Cx.cx([
                    "w-full flex-1 rounded-xl px-3 h-13",
                    style
                  ]);
    case /* Medium */1 :
        return Cx.cx([
                    "w-full flex-1 rounded-lg h-10 px-3",
                    style
                  ]);
    case /* Small */2 :
        return Cx.cx([
                    "w-full flex-1 rounded-md px-3 h-8",
                    style
                  ]);
    
  }
}

function styleByTextAlign(style, textAlign) {
  if (textAlign === undefined) {
    return style;
  }
  switch (textAlign) {
    case /* Left */0 :
        return Cx.cx([
                    "text-left",
                    style
                  ]);
    case /* Center */1 :
        return Cx.cx([
                    "text-center",
                    style
                  ]);
    case /* Right */2 :
        return Cx.cx([
                    "text-right",
                    style
                  ]);
    
  }
}

function Input(Props) {
  var id = Props.id;
  var type_ = Props.type_;
  var name = Props.name;
  var placeholder = Props.placeholder;
  var className = Props.className;
  var value = Props.value;
  var onChange = Props.onChange;
  var defaultValue = Props.defaultValue;
  var size = Props.size;
  var error = Props.error;
  var disabled = Props.disabled;
  var tabIndex = Props.tabIndex;
  var min = Props.min;
  var step = Props.step;
  var textAlign = Props.textAlign;
  var ref = Props.inputRef;
  var tmp = {
    className: Cx.cx([
          styleByTextAlign(inputStyleBySize(style(error, disabled), size), textAlign),
          Belt_Option.getWithDefault(className, "")
        ]),
    name: name,
    type: type_
  };
  if (ref !== undefined) {
    tmp.ref = Caml_option.valFromOption(ref);
  }
  if (defaultValue !== undefined) {
    tmp.defaultValue = Caml_option.valFromOption(defaultValue);
  }
  if (id !== undefined) {
    tmp.id = Caml_option.valFromOption(id);
  }
  if (tabIndex !== undefined) {
    tmp.tabIndex = Caml_option.valFromOption(tabIndex);
  }
  if (disabled !== undefined) {
    tmp.disabled = Caml_option.valFromOption(disabled);
  }
  if (min !== undefined) {
    tmp.min = Caml_option.valFromOption(min);
  }
  if (placeholder !== undefined) {
    tmp.placeholder = Caml_option.valFromOption(placeholder);
  }
  if (step !== undefined) {
    tmp.step = Caml_option.valFromOption(step);
  }
  if (value !== undefined) {
    tmp.value = Caml_option.valFromOption(value);
  }
  if (onChange !== undefined) {
    tmp.onChange = Caml_option.valFromOption(onChange);
  }
  return React.createElement("div", {
              className: "flex-1"
            }, React.createElement("label", undefined, React.createElement("input", tmp)), Belt_Option.getWithDefault(Belt_Option.map(error, (function (err) {
                        return React.createElement("span", {
                                    className: "flex mt-2"
                                  }, React.createElement(IconError.make, {
                                        width: "20",
                                        height: "20"
                                      }), React.createElement("span", {
                                        className: "text-sm text-notice ml-1"
                                      }, err));
                      })), null));
}

function Input$InputWithRef(Props) {
  var type_ = Props.type_;
  var name = Props.name;
  var placeholder = Props.placeholder;
  var className = Props.className;
  var value = Props.value;
  var onChange = Props.onChange;
  var defaultValue = Props.defaultValue;
  var size = Props.size;
  var error = Props.error;
  var disabled = Props.disabled;
  var tabIndex = Props.tabIndex;
  var min = Props.min;
  var step = Props.step;
  var inputRef = Props.inputRef;
  var tmp = {
    ref: inputRef,
    className: inputStyleBySize(style(error, disabled), size),
    name: name,
    type: type_
  };
  if (defaultValue !== undefined) {
    tmp.defaultValue = Caml_option.valFromOption(defaultValue);
  }
  if (tabIndex !== undefined) {
    tmp.tabIndex = Caml_option.valFromOption(tabIndex);
  }
  if (disabled !== undefined) {
    tmp.disabled = Caml_option.valFromOption(disabled);
  }
  if (min !== undefined) {
    tmp.min = Caml_option.valFromOption(min);
  }
  if (placeholder !== undefined) {
    tmp.placeholder = Caml_option.valFromOption(placeholder);
  }
  if (step !== undefined) {
    tmp.step = Caml_option.valFromOption(step);
  }
  if (value !== undefined) {
    tmp.value = Caml_option.valFromOption(value);
  }
  if (onChange !== undefined) {
    tmp.onChange = Caml_option.valFromOption(onChange);
  }
  return React.createElement("label", {
              className: Belt_Option.mapWithDefault(className, "flex flex-col min-w-0 relative", (function (className$p) {
                      return Cx.cx([
                                  "flex flex-col min-w-0 relative",
                                  className$p
                                ]);
                    }))
            }, React.createElement("input", tmp), Belt_Option.getWithDefault(Belt_Option.map(error, (function (err) {
                        return React.createElement(ReactTooltip.Root, {
                                    children: null,
                                    delayDuration: 300
                                  }, React.createElement(ReactTooltip.Trigger, {
                                        children: React.createElement("span", {
                                              className: "absolute top-1/2 right-2 transform -translate-y-1/2"
                                            }, React.createElement(IconError.make, {
                                                  width: "16",
                                                  height: "16"
                                                })),
                                        asChild: true
                                      }), React.createElement(ReactTooltip.Content, {
                                        children: React.createElement("div", {
                                              className: "block min-w-max relative"
                                            }, React.createElement("div", {
                                                  className: "flex flex-col justify-center"
                                                }, React.createElement("h5", {
                                                      className: "bg-white border border-notice text-notice text-sm text-center py-1 rounded-xl shadow-tooltip px-2"
                                                    }, err))),
                                        side: "top",
                                        sideOffset: 4,
                                        avoidCollisions: false
                                      }));
                      })), null));
}

var InputWithRef = {
  make: Input$InputWithRef
};

var make = Input;

export {
  normalStyle ,
  errorStyle ,
  disabledStyle ,
  style ,
  inputStyleBySize ,
  styleByTextAlign ,
  make ,
  InputWithRef ,
}
/* react Not a pure module */
