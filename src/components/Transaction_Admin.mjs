// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import * as Locale from "../utils/Locale.mjs";
import * as Skeleton from "./Skeleton.mjs";
import * as Converter from "../utils/Converter.mjs";
import * as Garter_Array from "@greenlabs/garter/src/Garter_Array.mjs";

function formatDateTime(d) {
  return Locale.DateTime.formatFromUTC(new Date(d), "yyyy/MM/dd HH:mm");
}

function formatDate(d) {
  return Locale.DateTime.formatFromUTC(new Date(d), "yyyy/MM/dd");
}

function formatTime(d) {
  return Locale.DateTime.formatFromUTC(new Date(d), "HH:mm");
}

function Transaction_Admin$Item$Table(Props) {
  var transaction = Props.transaction;
  return React.createElement("li", {
              className: "flex justify-between text-gray-700 p-5"
            }, React.createElement("div", {
                  className: "h-full"
                }, React.createElement("span", {
                      className: "block text-text-L1 font-bold mb-1"
                    }, Converter.displayTransactionKind(transaction.type_)), React.createElement("span", {
                      className: "block text-gray-400 whitespace-nowrap"
                    }, formatDateTime(transaction.createdAt))), React.createElement("div", {
                  className: "h-full text-right"
                }, React.createElement("span", {
                      className: "block"
                    }, Locale.Float.show(undefined, transaction.amount, 0)), React.createElement("span", {
                      className: "block font-bold"
                    }, Locale.Float.show(undefined, transaction.deposit, 0))));
}

function Transaction_Admin$Item$Table$Loading(Props) {
  return Garter_Array.map(Garter_Array.make(7, 0), (function (k) {
                return React.createElement("li", {
                            key: String(k),
                            className: "flex justify-between text-gray-700 p-5"
                          }, React.createElement("div", {
                                className: "h-full"
                              }, React.createElement("span", {
                                    className: "block text-text-L1 font-bold mb-1"
                                  }, React.createElement(Skeleton.Box.make, {
                                        className: "w-20"
                                      })), React.createElement("span", {
                                    className: "block text-gray-400 whitespace-nowrap"
                                  }, React.createElement(Skeleton.Box.make, {
                                        className: "w-24"
                                      }))), React.createElement("div", {
                                className: "h-full text-right"
                              }, React.createElement("span", {
                                    className: "block"
                                  }, React.createElement(Skeleton.Box.make, {
                                        className: "w-20"
                                      })), React.createElement("span", {
                                    className: "block font-bold"
                                  }, React.createElement(Skeleton.Box.make, {
                                        className: "w-32"
                                      }))));
              }));
}

var Loading = {
  make: Transaction_Admin$Item$Table$Loading
};

var Table = {
  make: Transaction_Admin$Item$Table,
  Loading: Loading
};

var Item = {
  Table: Table
};

function Transaction_Admin(Props) {
  var transaction = Props.transaction;
  return React.createElement(Transaction_Admin$Item$Table, {
              transaction: transaction
            });
}

var make = Transaction_Admin;

export {
  formatDateTime ,
  formatDate ,
  formatTime ,
  Item ,
  make ,
}
/* react Not a pure module */
