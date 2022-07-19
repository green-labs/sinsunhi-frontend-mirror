// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as ReactEvents from "../utils/ReactEvents.mjs";
import * as ReactHookForm from "react-hook-form";
import * as Add_ProductOption_Admin from "./Add_ProductOption_Admin.mjs";
import * as Update_ProductOption_Admin from "./Update_ProductOption_Admin.mjs";

var formName = "product-options";

function Update_ProductOption_List_Admin(Props) {
  var productDisplayName = Props.productDisplayName;
  var isCourierAvailable = Props.isCourierAvailable;
  var options = Props.options;
  var edges = options.edges;
  var match = React.useState(function () {
        return false;
      });
  var setApplyAll = match[1];
  var applyAll = match[0];
  var match$1 = ReactHookForm.useFormContext({
        mode: "onChange"
      }, undefined);
  var setValue = match$1.setValue;
  var match$2 = ReactHookForm.useFieldArray({
        name: formName + ".create",
        control: match$1.control,
        shouldUnregister: true
      });
  var remove = match$2.remove;
  var prepend = match$2.prepend;
  var fields = match$2.fields;
  var listId = match$1.register("product-options.connection-id", undefined);
  var isOnlyOneRemained = (fields.length + edges.length | 0) === 1;
  var handleOnClickAdd = function (param) {
    return ReactEvents.interceptingHandler((function (param) {
                  setApplyAll(function (param) {
                        return false;
                      });
                  return prepend({}, {}, undefined);
                }), param);
  };
  var setTogether = function (fieldName, value) {
    if (fields.length !== 0) {
      Belt_Array.forEachWithIndex(Belt_Array.sliceToEnd(fields, 1), (function (index, param) {
              return setValue(formName + ".create." + String(index + 1 | 0) + "." + fieldName, value);
            }));
      return Belt_Array.forEachWithIndex(edges, (function (index, param) {
                    return setValue(formName + ".edit." + String(index) + "." + fieldName, value);
                  }));
    } else {
      return Belt_Array.forEachWithIndex(Belt_Array.sliceToEnd(edges, 1), (function (index, param) {
                    return setValue(formName + ".edit." + String(index + 1 | 0) + "." + fieldName, value);
                  }));
    }
  };
  var watchFirstCM = fields.length !== 0 ? ReactHookForm.useWatch({
          name: [
            formName + ".create.0.cut-off-time",
            formName + ".create.0.memo"
          ]
        }) : ReactHookForm.useWatch({
          name: [
            formName + ".edit.0.cut-off-time",
            formName + ".edit.0.memo"
          ]
        });
  React.useEffect((function () {
          if (applyAll && watchFirstCM !== undefined && watchFirstCM.length === 2) {
            var cutOffTime = watchFirstCM[0];
            var memo = watchFirstCM[1];
            setTogether("cut-off-time", Belt_Option.mapWithDefault(cutOffTime, null, (function (prim) {
                        return prim;
                      })));
            setTogether("memo", Belt_Option.mapWithDefault(memo, null, (function (prim) {
                        return prim;
                      })));
          }
          
        }), [
        applyAll,
        watchFirstCM
      ]);
  var param = Belt_Array.partition(edges, (function (edge) {
          return edge.node.status !== "RETIRE";
        }));
  return React.createElement(React.Fragment, undefined, React.createElement("div", {
                  className: "flex justify-between items-center"
                }, React.createElement("h2", {
                      className: "text-text-L1 text-lg font-bold"
                    }, "단품 정보", React.createElement("span", {
                          className: "text-sm text-green-gl ml-2 font-normal"
                        }, "단품 " + String(fields.length + edges.length | 0) + "개")), React.createElement("input", {
                      ref: listId.ref,
                      defaultValue: options.__id,
                      id: listId.name,
                      name: listId.name,
                      type: "hidden",
                      onBlur: listId.onBlur,
                      onChange: listId.onChange
                    }), React.createElement("button", {
                      onClick: (function (param) {
                          return ReactEvents.interceptingHandler((function (param) {
                                        
                                      }), param);
                        })
                    }), React.createElement("button", {
                      className: "px-3 py-2 bg-div-shape-L1 rounded-lg focus:outline-none",
                      onClick: handleOnClickAdd
                    }, "단품 추가하기")), React.createElement("div", {
                  className: "flex flex-col mt-7 mb-3 gap-6"
                }, Belt_Array.mapWithIndex(fields, (function (index, field) {
                        return React.createElement(Add_ProductOption_Admin.make, {
                                    prefix: formName + ".create." + String(index),
                                    index: index,
                                    remove: remove,
                                    prepend: prepend,
                                    isOnlyOneRemained: isOnlyOneRemained,
                                    productDisplayName: productDisplayName,
                                    applyAll: applyAll,
                                    setApplyAll: setApplyAll,
                                    isCourierAvailable: isCourierAvailable,
                                    key: field.id
                                  });
                      })), Belt_Array.mapWithIndex(Belt_Array.concat(param[0], param[1]), (function (index, edge) {
                        return React.createElement(Update_ProductOption_Admin.make, {
                                    prefix: formName + ".edit." + String(index),
                                    index: index + fields.length | 0,
                                    prepend: prepend,
                                    productDisplayName: productDisplayName,
                                    applyAll: applyAll,
                                    setApplyAll: setApplyAll,
                                    query: edge.node.fragmentRefs,
                                    key: edge.node.id
                                  });
                      }))));
}

var make = Update_ProductOption_List_Admin;

export {
  formName ,
  make ,
  
}
/* react Not a pure module */
