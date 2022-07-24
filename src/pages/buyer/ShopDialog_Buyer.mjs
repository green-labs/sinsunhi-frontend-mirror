// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as ReactDialog from "@radix-ui/react-dialog";

function ShopDialog_Buyer$BtnSection(Props) {
  var confirmText = Props.confirmText;
  var cancelText = Props.cancelText;
  var onConfirm = Props.onConfirm;
  var onCancel = Props.onCancel;
  if (onConfirm !== undefined) {
    return React.createElement("div", {
                className: "grid grid-cols-2 gap-2 px-5 pb-5 mt-4"
              }, React.createElement("button", {
                    className: "h-13 bg-gray-100 rounded-xl text-gray-800 focus:outline-none",
                    onClick: onCancel
                  }, cancelText), React.createElement("button", {
                    className: "h-13 bg-green-500 hover:bg-green-600 rounded-xl text-white font-bold focus:outline-none",
                    onClick: onConfirm
                  }, confirmText));
  } else {
    return React.createElement("div", {
                className: "w-full flex px-5 pb-5 mt-4"
              }, React.createElement("button", {
                    className: "h-13 bg-gray-100 rounded-xl text-gray-800 flex flex-1 items-center justify-center",
                    onClick: onCancel
                  }, cancelText));
  }
}

var BtnSection = {
  make: ShopDialog_Buyer$BtnSection
};

function ShopDialog_Buyer$Mo(Props) {
  var isShow = Props.isShow;
  var confirmTextOpt = Props.confirmText;
  var cancelTextOpt = Props.cancelText;
  var onConfirm = Props.onConfirm;
  var onCancel = Props.onCancel;
  var children = Props.children;
  var confirmText = confirmTextOpt !== undefined ? confirmTextOpt : "확인";
  var cancelText = cancelTextOpt !== undefined ? cancelTextOpt : "취소";
  var _open = isShow ? false : true;
  var tmp = {
    confirmText: confirmText,
    cancelText: cancelText,
    onCancel: onCancel
  };
  if (onConfirm !== undefined) {
    tmp.onConfirm = Caml_option.valFromOption(onConfirm);
  }
  return React.createElement(ReactDialog.Root, {
              children: React.createElement(ReactDialog.Portal, {
                    children: null
                  }, React.createElement(ReactDialog.Overlay, {
                        className: "dialog-overlay"
                      }), React.createElement(ReactDialog.Content, {
                        children: null,
                        className: "dialog-content-base bg-white rounded-xl w-[calc(100vw-40px)] max-w-[calc(768px-40px)]",
                        onPointerDownOutside: onCancel
                      }, Belt_Option.getWithDefault(children, null), React.createElement(ShopDialog_Buyer$BtnSection, tmp))),
              open: _open
            });
}

var Mo = {
  make: ShopDialog_Buyer$Mo
};

function ShopDialog_Buyer(Props) {
  var isShow = Props.isShow;
  var confirmTextOpt = Props.confirmText;
  var cancelTextOpt = Props.cancelText;
  var onConfirm = Props.onConfirm;
  var onCancel = Props.onCancel;
  var children = Props.children;
  var confirmText = confirmTextOpt !== undefined ? confirmTextOpt : "확인";
  var cancelText = cancelTextOpt !== undefined ? cancelTextOpt : "취소";
  var _open = isShow ? false : true;
  var tmp = {
    confirmText: confirmText,
    cancelText: cancelText,
    onCancel: onCancel
  };
  if (onConfirm !== undefined) {
    tmp.onConfirm = Caml_option.valFromOption(onConfirm);
  }
  return React.createElement(ReactDialog.Root, {
              children: React.createElement(ReactDialog.Portal, {
                    children: null
                  }, React.createElement(ReactDialog.Overlay, {
                        className: "dialog-overlay"
                      }), React.createElement(ReactDialog.Content, {
                        children: null,
                        className: "dialog-content-base bg-white rounded-xl w-[480px]",
                        onPointerDownOutside: onCancel
                      }, Belt_Option.getWithDefault(children, null), React.createElement(ShopDialog_Buyer$BtnSection, tmp))),
              open: _open
            });
}

var make = ShopDialog_Buyer;

export {
  BtnSection ,
  Mo ,
  make ,
}
/* react Not a pure module */
