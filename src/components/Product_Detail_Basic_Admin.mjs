// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Cx from "rescript-classnames/src/Cx.mjs";
import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as Dialog from "./common/Dialog.mjs";
import * as Helper from "../utils/Helper.mjs";
import * as Locale from "../utils/Locale.mjs";
import * as Js_json from "rescript/lib/es6/js_json.js";
import * as RelayEnv from "../constants/RelayEnv.mjs";
import * as IconError from "./svgs/IconError.mjs";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as Belt_Float from "rescript/lib/es6/belt_Float.js";
import * as Js_promise from "rescript/lib/es6/js_promise.js";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Belt_Result from "rescript/lib/es6/belt_Result.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as ReactSelect from "./common/ReactSelect.mjs";
import * as ReactRelay from "react-relay";
import * as Garter_Array from "@greenlabs/garter/src/Garter_Array.mjs";
import * as ReactHookForm from "../bindings/ReactHookForm/ReactHookForm.mjs";
import * as RescriptRelay from "rescript-relay/src/RescriptRelay.mjs";
import * as RelayRuntime from "relay-runtime";
import * as Select_Delivery from "./Select_Delivery.mjs";
import * as ReactHookForm$1 from "react-hook-form";
import * as Select_Tax_Status from "./Select_Tax_Status.mjs";
import Async from "react-select/async";
import * as RescriptRelay_Internal from "rescript-relay/src/RescriptRelay_Internal.mjs";
import * as ErrorMessage from "@hookform/error-message";
import * as Select_Product_Categories from "./Select_Product_Categories.mjs";
import * as Select_Product_Operation_Status from "./Select_Product_Operation_Status.mjs";
import * as Product_Detail_Display_Categories from "./Product_Detail_Display_Categories.mjs";
import * as ProductDetailBasicAdminQuery_graphql from "../__generated__/ProductDetailBasicAdminQuery_graphql.mjs";

function use(variables, fetchPolicy, fetchKey, networkCacheConfig, param) {
  var data = ReactRelay.useLazyLoadQuery(ProductDetailBasicAdminQuery_graphql.node, RescriptRelay_Internal.internal_cleanObjectFromUndefinedRaw(ProductDetailBasicAdminQuery_graphql.Internal.convertVariables(variables)), {
        fetchKey: fetchKey,
        fetchPolicy: RescriptRelay.mapFetchPolicy(fetchPolicy),
        networkCacheConfig: networkCacheConfig
      });
  return RescriptRelay_Internal.internal_useConvertedValue(ProductDetailBasicAdminQuery_graphql.Internal.convertResponse, data);
}

function useLoader(param) {
  var match = ReactRelay.useQueryLoader(ProductDetailBasicAdminQuery_graphql.node);
  var loadQueryFn = match[1];
  var loadQuery = React.useMemo((function () {
          return function (param, param$1, param$2, param$3) {
            return Curry._2(loadQueryFn, ProductDetailBasicAdminQuery_graphql.Internal.convertVariables(param), {
                        fetchPolicy: param$1,
                        networkCacheConfig: param$2
                      });
          };
        }), [loadQueryFn]);
  return [
          Caml_option.nullable_to_opt(match[0]),
          loadQuery,
          match[2]
        ];
}

function $$fetch(environment, variables, onResult, networkCacheConfig, fetchPolicy, param) {
  ReactRelay.fetchQuery(environment, ProductDetailBasicAdminQuery_graphql.node, ProductDetailBasicAdminQuery_graphql.Internal.convertVariables(variables), {
          networkCacheConfig: networkCacheConfig,
          fetchPolicy: RescriptRelay.mapFetchQueryFetchPolicy(fetchPolicy)
        }).subscribe({
        next: (function (res) {
            Curry._1(onResult, {
                  TAG: /* Ok */0,
                  _0: ProductDetailBasicAdminQuery_graphql.Internal.convertResponse(res)
                });
          }),
        error: (function (err) {
            Curry._1(onResult, {
                  TAG: /* Error */1,
                  _0: err
                });
          })
      });
}

function fetchPromised(environment, variables, networkCacheConfig, fetchPolicy, param) {
  var __x = ReactRelay.fetchQuery(environment, ProductDetailBasicAdminQuery_graphql.node, ProductDetailBasicAdminQuery_graphql.Internal.convertVariables(variables), {
          networkCacheConfig: networkCacheConfig,
          fetchPolicy: RescriptRelay.mapFetchQueryFetchPolicy(fetchPolicy)
        }).toPromise();
  return Js_promise.then_((function (res) {
                return Promise.resolve(ProductDetailBasicAdminQuery_graphql.Internal.convertResponse(res));
              }), __x);
}

function usePreloaded(queryRef, param) {
  var data = ReactRelay.usePreloadedQuery(ProductDetailBasicAdminQuery_graphql.node, queryRef);
  return RescriptRelay_Internal.internal_useConvertedValue(ProductDetailBasicAdminQuery_graphql.Internal.convertResponse, data);
}

function retain(environment, variables) {
  var operationDescriptor = RelayRuntime.createOperationDescriptor(ProductDetailBasicAdminQuery_graphql.node, ProductDetailBasicAdminQuery_graphql.Internal.convertVariables(variables));
  return environment.retain(operationDescriptor);
}

var Query_userRole_decode = ProductDetailBasicAdminQuery_graphql.Utils.userRole_decode;

var Query_userRole_fromString = ProductDetailBasicAdminQuery_graphql.Utils.userRole_fromString;

var Query = {
  userRole_decode: Query_userRole_decode,
  userRole_fromString: Query_userRole_fromString,
  Operation: undefined,
  Types: undefined,
  use: use,
  useLoader: useLoader,
  $$fetch: $$fetch,
  fetchPromised: fetchPromised,
  usePreloaded: usePreloaded,
  retain: retain
};

function getTextInputStyle(disabled) {
  var defaultStyle = "px-3 py-2 border border-border-default-L1 rounded-lg h-9 focus:outline-none min-w-1/2 max-w-2xl";
  if (disabled) {
    return Cx.cx([
                defaultStyle,
                "bg-disabled-L3"
              ]);
  } else {
    return defaultStyle;
  }
}

var Form = {
  formName: {
    producerName: "producer-name",
    producerProductName: "producer-product-name",
    buyerProductName: "buyer-product-name",
    basePrice: "base-price",
    origin: "origin",
    productCategory: "product-category",
    displayCategories: "display-categories",
    operationStatus: "product-operation-status",
    tax: "product-tax",
    delivery: "product-delivery"
  }
};

function Product_Detail_Basic_Admin$SelectProducerInput(Props) {
  var name = Props.name;
  var defaultValue = Props.defaultValue;
  var disabledOpt = Props.disabled;
  var disabled = disabledOpt !== undefined ? disabledOpt : false;
  var match = ReactHookForm$1.useFormContext({
        mode: "onChange"
      }, undefined);
  var handleLoadOptions = function (inputValue) {
    return Js_promise.then_((function (result) {
                  var result$p = Belt_Array.map(result.users.edges, (function (edge) {
                          return /* Selected */{
                                  value: edge.node.id,
                                  label: edge.node.name
                                };
                        }));
                  return Promise.resolve(result$p);
                }), fetchPromised(RelayEnv.envSinsunMarket, {
                    nameMatch: inputValue,
                    role: "PRODUCER"
                  }, undefined, undefined, undefined));
  };
  return React.createElement("div", {
              className: "flex flex-col gap-2"
            }, React.createElement("div", undefined, React.createElement("span", {
                      className: "font-bold"
                    }, "생산자"), React.createElement("span", {
                      className: "text-notice"
                    }, "*")), React.createElement("div", {
                  className: "relative max-w-md w-1/3 h-9"
                }, React.createElement("div", {
                      className: "absolute w-full"
                    }, React.createElement(ReactHookForm$1.Controller, {
                          name: name,
                          control: match.control,
                          render: (function (param) {
                              var match = param.field;
                              var onChange = match.onChange;
                              return React.createElement(React.Fragment, undefined, React.createElement(Async, {
                                              value: Belt_Result.getWithDefault(ReactSelect.decoderRule(match.value), /* NotSelected */0),
                                              cacheOptions: false,
                                              defaultOptions: false,
                                              loadOptions: Helper.Debounce.make1(handleLoadOptions, 500),
                                              onChange: (function (data) {
                                                  Curry._1(onChange, Curry._1(ReactHookForm.Controller.OnChangeArg.value, ReactSelect.encoderRule(data)));
                                                }),
                                              placeholder: "생산자명으로 찾기",
                                              noOptionsMessage: (function (param) {
                                                  return "검색 결과가 없습니다.";
                                                }),
                                              isClearable: true,
                                              isDisabled: disabled,
                                              styles: {
                                                menu: (function (provide, param) {
                                                    return Object.assign(Object.assign({}, provide), {
                                                                position: "inherit"
                                                              });
                                                  }),
                                                control: (function (provide, param) {
                                                    return Object.assign(Object.assign({}, provide), {
                                                                minHeight: "unset",
                                                                height: "2.25rem"
                                                              });
                                                  })
                                              },
                                              ref: match.ref
                                            }));
                            }),
                          defaultValue: Belt_Option.mapWithDefault(defaultValue, null, ReactSelect.encoderRule),
                          rules: ReactHookForm.Rules.make(true, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined)
                        }))), React.createElement(ErrorMessage.ErrorMessage, {
                  name: "producer-name",
                  errors: match.formState.errors,
                  render: (function (param) {
                      return React.createElement("span", {
                                  className: "flex"
                                }, React.createElement(IconError.make, {
                                      width: "20",
                                      height: "20"
                                    }), React.createElement("span", {
                                      className: "text-sm text-notice ml-1"
                                    }, "생산자명을 입력해주세요."));
                    })
                }));
}

var SelectProducerInput = {
  make: Product_Detail_Basic_Admin$SelectProducerInput
};

function Product_Detail_Basic_Admin$DisplayPriceInput(Props) {
  var name = Props.name;
  var defaultValue = Props.defaultValue;
  var disabledOpt = Props.disabled;
  var disabled = disabledOpt !== undefined ? disabledOpt : false;
  var match = ReactHookForm$1.useFormContext({
        mode: "onChange"
      }, undefined);
  var valueEncode = function (value) {
    return value;
  };
  var localeStringToFloat = function (value) {
    return Belt_Option.flatMap(Belt_Option.map(Belt_Option.flatMap(Belt_Option.flatMap(Belt_Option.map(Caml_option.null_to_opt(/^[\d,]+/.exec(value)), (function (prim) {
                                  return prim;
                                })), Garter_Array.first), (function (prim) {
                          if (prim == null) {
                            return ;
                          } else {
                            return Caml_option.some(prim);
                          }
                        })), (function (__x) {
                      return __x.replace(/,/g, "");
                    })), Belt_Float.fromString);
  };
  return React.createElement("div", {
              className: "flex flex-col gap-2"
            }, React.createElement("label", {
                  className: "block",
                  htmlFor: "base-price"
                }, React.createElement("span", {
                      className: "font-bold"
                    }, "전시매장 노출 기준가격"), React.createElement("span", {
                      className: "text-notice"
                    }, "*")), React.createElement(ReactHookForm$1.Controller, {
                  name: name,
                  control: match.control,
                  render: (function (param) {
                      var match = param.field;
                      var onChange = match.onChange;
                      var func = Locale.Float.show;
                      return React.createElement("input", {
                                  ref: match.ref,
                                  className: getTextInputStyle(disabled),
                                  id: match.name,
                                  disabled: disabled,
                                  placeholder: "가격 입력(단위 원)",
                                  type: "text",
                                  value: Belt_Option.mapWithDefault(Js_json.decodeNumber(match.value), "", (function (eta) {
                                          return Curry._3(func, undefined, eta, 0);
                                        })),
                                  onChange: (function (e) {
                                      var value = e.currentTarget.value;
                                      var validValue = Belt_Option.getWithDefault(Belt_Option.map(localeStringToFloat(value), (function (prim) {
                                                  return prim;
                                                })), "");
                                      Curry._1(onChange, Curry._1(ReactHookForm.Controller.OnChangeArg.value, validValue));
                                    })
                                });
                    }),
                  defaultValue: Belt_Option.mapWithDefault(defaultValue, "", valueEncode),
                  rules: ReactHookForm.Rules.make(true, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined)
                }), React.createElement(ErrorMessage.ErrorMessage, {
                  name: "base-price",
                  errors: match.formState.errors,
                  render: (function (param) {
                      return React.createElement("span", {
                                  className: "flex"
                                }, React.createElement(IconError.make, {
                                      width: "20",
                                      height: "20"
                                    }), React.createElement("span", {
                                      className: "text-sm text-notice ml-1"
                                    }, "전시매장 노출 기준가격을 입력해주세요."));
                    })
                }));
}

var DisplayPriceInput = {
  make: Product_Detail_Basic_Admin$DisplayPriceInput
};

function Product_Detail_Basic_Admin$ReadOnlyProductId(Props) {
  var productId = Props.productId;
  return React.createElement("div", {
              className: "flex flex-col gap-2"
            }, React.createElement("div", undefined, React.createElement("span", {
                      className: "font-bold"
                    }, "상품번호")), React.createElement("div", {
                  className: "px-3 py-2 border border-border-default-L1 bg-disabled-L3 text-disabled-L1 rounded-lg h-9 max-w-md w-1/3"
                }, productId !== undefined ? React.createElement("span", {
                        className: "text-enabled-L1"
                      }, productId) : React.createElement("span", {
                        className: "text-disabled-L1"
                      }, "저장 후 자동생성됩니다.")));
}

var ReadOnlyProductId = {
  make: Product_Detail_Basic_Admin$ReadOnlyProductId
};

function Product_Detail_Basic_Admin(Props) {
  var productId = Props.productId;
  var defaultProducer = Props.defaultProducer;
  var defaultProducerName = Props.defaultProducerName;
  var defaultBuyerName = Props.defaultBuyerName;
  var defaultBasePrice = Props.defaultBasePrice;
  var defaultOperationstatus = Props.defaultOperationstatus;
  var defaultOrigin = Props.defaultOrigin;
  var defaultDeliveryMethod = Props.defaultDeliveryMethod;
  var defaultIsVat = Props.defaultIsVat;
  var producerNameDisabledOpt = Props.producerNameDisabled;
  var productCategoryDisabledOpt = Props.productCategoryDisabled;
  var vatDisabledOpt = Props.vatDisabled;
  var displayCategoriesDisabledOpt = Props.displayCategoriesDisabled;
  var producerProductNameDisabledOpt = Props.producerProductNameDisabled;
  var buyerProductNameDisabledOpt = Props.buyerProductNameDisabled;
  var basePriceDisabledOpt = Props.basePriceDisabled;
  var operationStatusDisalbedOpt = Props.operationStatusDisalbed;
  var originDisabledOpt = Props.originDisabled;
  var deliveryDisabledOpt = Props.deliveryDisabled;
  var allFieldsDisabledOpt = Props.allFieldsDisabled;
  var producerNameDisabled = producerNameDisabledOpt !== undefined ? producerNameDisabledOpt : false;
  var productCategoryDisabled = productCategoryDisabledOpt !== undefined ? productCategoryDisabledOpt : false;
  var vatDisabled = vatDisabledOpt !== undefined ? vatDisabledOpt : false;
  var displayCategoriesDisabled = displayCategoriesDisabledOpt !== undefined ? displayCategoriesDisabledOpt : false;
  var producerProductNameDisabled = producerProductNameDisabledOpt !== undefined ? producerProductNameDisabledOpt : false;
  var buyerProductNameDisabled = buyerProductNameDisabledOpt !== undefined ? buyerProductNameDisabledOpt : false;
  var basePriceDisabled = basePriceDisabledOpt !== undefined ? basePriceDisabledOpt : false;
  var operationStatusDisalbed = operationStatusDisalbedOpt !== undefined ? operationStatusDisalbedOpt : false;
  var originDisabled = originDisabledOpt !== undefined ? originDisabledOpt : false;
  var deliveryDisabled = deliveryDisabledOpt !== undefined ? deliveryDisabledOpt : false;
  var allFieldsDisabled = allFieldsDisabledOpt !== undefined ? allFieldsDisabledOpt : false;
  var match = ReactHookForm$1.useFormContext({
        mode: "onChange"
      }, undefined);
  var register = match.register;
  var setValue = match.setValue;
  var errors = match.formState.errors;
  var control = match.control;
  var match$1 = React.useState(function () {
        return /* Hide */1;
      });
  var setShowProductOperationNoSale = match$1[1];
  var producerProductName = register("producer-product-name", {
        required: true,
        maxLength: 100
      });
  var buyerProductName = register("buyer-product-name", {
        required: true,
        maxLength: 100
      });
  var productOrigin = register("origin", undefined);
  var tmp = {
    name: "product-operation-status",
    control: control,
    render: (function (param) {
        var match = param.field;
        var onChange = match.onChange;
        return React.createElement("div", undefined, React.createElement(Select_Product_Operation_Status.Base.make, {
                        status: Belt_Result.mapWithDefault(Select_Product_Operation_Status.Base.status_decode(match.value), undefined, (function (status) {
                                return status;
                              })),
                        onChange: (function (param) {
                            if (param !== 2) {
                              return Curry._1(onChange, Curry._1(ReactHookForm.Controller.OnChangeArg.value, Select_Product_Operation_Status.Base.status_encode(param)));
                            } else {
                              return setShowProductOperationNoSale(function (param) {
                                          return /* Show */0;
                                        });
                            }
                          }),
                        forwardRef: match.ref,
                        disabled: allFieldsDisabled || operationStatusDisalbed
                      }), React.createElement(ErrorMessage.ErrorMessage, {
                        name: "product-operation-status",
                        errors: errors,
                        render: (function (param) {
                            return React.createElement("span", {
                                        className: "flex"
                                      }, React.createElement(IconError.make, {
                                            width: "20",
                                            height: "20"
                                          }), React.createElement("span", {
                                            className: "text-sm text-notice ml-1"
                                          }, "운영상태를 선택해주세요."));
                          })
                      }));
      }),
    rules: ReactHookForm.Rules.make(true, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined)
  };
  var tmp$1 = Belt_Option.map(defaultOperationstatus, Select_Product_Operation_Status.Base.status_encode);
  if (tmp$1 !== undefined) {
    tmp.defaultValue = Caml_option.valFromOption(tmp$1);
  }
  var tmp$2 = {
    name: "product-tax",
    control: control,
    render: (function (param) {
        var match = param.field;
        var onChange = match.onChange;
        return React.createElement("div", undefined, React.createElement(Select_Tax_Status.make, {
                        status: Belt_Result.mapWithDefault(Select_Tax_Status.status_decode(match.value), undefined, (function (status) {
                                return status;
                              })),
                        onChange: (function (e) {
                            Curry._1(onChange, Curry._1(ReactHookForm.Controller.OnChangeArg.$$event, e));
                          }),
                        forwardRef: match.ref,
                        disabled: allFieldsDisabled || vatDisabled
                      }), React.createElement(ErrorMessage.ErrorMessage, {
                        name: "product-tax",
                        errors: errors,
                        render: (function (param) {
                            return React.createElement("span", {
                                        className: "flex"
                                      }, React.createElement(IconError.make, {
                                            width: "20",
                                            height: "20"
                                          }), React.createElement("span", {
                                            className: "text-sm text-notice ml-1"
                                          }, "과면세여부를 선택해주세요."));
                          })
                      }));
      }),
    rules: ReactHookForm.Rules.make(true, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined)
  };
  var tmp$3 = Belt_Option.map(defaultIsVat, Select_Tax_Status.status_encode);
  if (tmp$3 !== undefined) {
    tmp$2.defaultValue = Caml_option.valFromOption(tmp$3);
  }
  var tmp$4 = {
    name: "product-delivery",
    control: control,
    render: (function (param) {
        var match = param.field;
        var onChange = match.onChange;
        return React.createElement("div", undefined, React.createElement(Select_Delivery.make, {
                        status: Belt_Result.mapWithDefault(Select_Delivery.status_decode(match.value), undefined, (function (status) {
                                return status;
                              })),
                        onChange: (function (e) {
                            Curry._1(onChange, Curry._1(ReactHookForm.Controller.OnChangeArg.$$event, e));
                          }),
                        forwardRef: match.ref,
                        disabled: allFieldsDisabled || deliveryDisabled
                      }), React.createElement(ErrorMessage.ErrorMessage, {
                        name: "product-delivery",
                        errors: errors,
                        render: (function (param) {
                            return React.createElement("span", {
                                        className: "flex"
                                      }, React.createElement(IconError.make, {
                                            width: "20",
                                            height: "20"
                                          }), React.createElement("span", {
                                            className: "text-sm text-notice ml-1"
                                          }, "택배가능여부를 선택해주세요."));
                          })
                      }));
      }),
    rules: ReactHookForm.Rules.make(true, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined)
  };
  var tmp$5 = Belt_Option.map(defaultDeliveryMethod, Select_Delivery.status_encode);
  if (tmp$5 !== undefined) {
    tmp$4.defaultValue = Caml_option.valFromOption(tmp$5);
  }
  return React.createElement(React.Fragment, undefined, React.createElement("div", undefined, React.createElement("h2", {
                      className: "text-text-L1 text-lg font-bold"
                    }, "기본정보"), React.createElement("div", {
                      className: "divide-y text-sm"
                    }, React.createElement("div", {
                          className: "py-6 flex flex-col space-y-6"
                        }, React.createElement("div", {
                              className: "flex flex-col gap-2"
                            }, React.createElement("div", undefined, React.createElement("span", {
                                      className: " font-bold"
                                    }, "상품유형"), React.createElement("span", {
                                      className: "text-notice"
                                    }, "*"))), React.createElement(Product_Detail_Basic_Admin$SelectProducerInput, {
                              name: "producer-name",
                              defaultValue: defaultProducer,
                              disabled: allFieldsDisabled || producerNameDisabled
                            }), React.createElement("div", {
                              className: "flex flex-col gap-2"
                            }, React.createElement("div", undefined, React.createElement("span", {
                                      className: " font-bold"
                                    }, "표준카테고리"), React.createElement("span", {
                                      className: "text-notice"
                                    }, "*")), React.createElement(Select_Product_Categories.make, {
                                  control: control,
                                  name: "product-category",
                                  disabled: allFieldsDisabled || productCategoryDisabled
                                })), React.createElement("div", {
                              className: "flex flex-col gap-2"
                            }, React.createElement("div", undefined, React.createElement("span", {
                                      className: " font-bold"
                                    }, "전시카테고리"), React.createElement("span", {
                                      className: "text-notice"
                                    }, "*")), React.createElement(Product_Detail_Display_Categories.make, {
                                  control: control,
                                  name: "display-categories",
                                  disabled: allFieldsDisabled || displayCategoriesDisabled
                                }), React.createElement("div", undefined))), React.createElement("div", {
                          className: "py-6 flex flex-col space-y-6"
                        }, React.createElement("div", {
                              className: "flex flex-col gap-2"
                            }, React.createElement("label", {
                                  className: "block",
                                  htmlFor: producerProductName.name
                                }, React.createElement("span", {
                                      className: "font-bold"
                                    }, "생산자용 상품명"), React.createElement("span", {
                                      className: "text-notice"
                                    }, "*")), React.createElement("div", undefined, React.createElement("input", {
                                      ref: producerProductName.ref,
                                      defaultValue: Belt_Option.getWithDefault(defaultProducerName, ""),
                                      className: getTextInputStyle(allFieldsDisabled || producerProductNameDisabled),
                                      id: producerProductName.name,
                                      disabled: allFieldsDisabled || producerProductNameDisabled,
                                      name: producerProductName.name,
                                      placeholder: "생산자용 상품명 입력(최대 100자)",
                                      onBlur: producerProductName.onBlur,
                                      onChange: producerProductName.onChange
                                    }), React.createElement(ErrorMessage.ErrorMessage, {
                                      name: "producer-product-name",
                                      errors: errors,
                                      render: (function (param) {
                                          return React.createElement("span", {
                                                      className: "flex"
                                                    }, React.createElement(IconError.make, {
                                                          width: "20",
                                                          height: "20"
                                                        }), React.createElement("span", {
                                                          className: "text-sm text-notice ml-1"
                                                        }, "생산자용 상품명을 입력해주세요.(최대100자)"));
                                        })
                                    }))), React.createElement("div", {
                              className: "flex flex-col gap-2"
                            }, React.createElement("label", {
                                  className: "block",
                                  htmlFor: buyerProductName.name
                                }, React.createElement("span", {
                                      className: "font-bold"
                                    }, "바이어용 상품명"), React.createElement("span", {
                                      className: "text-notice"
                                    }, "*")), React.createElement("input", {
                                  ref: buyerProductName.ref,
                                  defaultValue: Belt_Option.getWithDefault(defaultBuyerName, ""),
                                  className: getTextInputStyle(allFieldsDisabled || buyerProductNameDisabled),
                                  id: buyerProductName.name,
                                  disabled: allFieldsDisabled || buyerProductNameDisabled,
                                  name: buyerProductName.name,
                                  placeholder: "바이어용 상품명 입력, 상품매장에 노출됨(최대 100자)",
                                  onBlur: buyerProductName.onBlur,
                                  onChange: buyerProductName.onChange
                                }), React.createElement(ErrorMessage.ErrorMessage, {
                                  name: "buyer-product-name",
                                  errors: errors,
                                  render: (function (param) {
                                      return React.createElement("span", {
                                                  className: "flex"
                                                }, React.createElement(IconError.make, {
                                                      width: "20",
                                                      height: "20"
                                                    }), React.createElement("span", {
                                                      className: "text-sm text-notice ml-1"
                                                    }, "바이어용 상품명을 입력해주세요.(최대100자)"));
                                    })
                                })), React.createElement(Product_Detail_Basic_Admin$ReadOnlyProductId, {
                              productId: productId
                            }), React.createElement(Product_Detail_Basic_Admin$DisplayPriceInput, {
                              name: "base-price",
                              defaultValue: defaultBasePrice,
                              disabled: allFieldsDisabled || basePriceDisabled
                            })), React.createElement("div", {
                          className: "py-6 flex flex-col space-y-6"
                        }, React.createElement("div", {
                              className: "flex gap-2 w-full"
                            }, React.createElement("div", {
                                  className: "flex flex-col gap-2 max-w-md w-1/3"
                                }, React.createElement("div", undefined, React.createElement("span", {
                                          className: "font-bold"
                                        }, "운영상태"), React.createElement("span", {
                                          className: "text-notice"
                                        }, "*")), React.createElement(ReactHookForm$1.Controller, tmp)), React.createElement("div", {
                                  className: "flex flex-col gap-2 max-w-md w-1/3"
                                }, React.createElement("label", {
                                      className: "block",
                                      htmlFor: productOrigin.name
                                    }, React.createElement("span", {
                                          className: "font-bold"
                                        }, "원산지")), React.createElement("input", {
                                      ref: productOrigin.ref,
                                      defaultValue: Belt_Option.getWithDefault(defaultOrigin, ""),
                                      className: getTextInputStyle(allFieldsDisabled || originDisabled),
                                      id: productOrigin.name,
                                      disabled: allFieldsDisabled || originDisabled,
                                      name: productOrigin.name,
                                      placeholder: "원산지 입력(선택사항)",
                                      onBlur: productOrigin.onBlur,
                                      onChange: productOrigin.onChange
                                    }))), React.createElement("div", {
                              className: "flex gap-2"
                            }, React.createElement("div", {
                                  className: "flex gap-2 w-full"
                                }, React.createElement("div", {
                                      className: "flex flex-col gap-2 max-w-md w-1/3"
                                    }, React.createElement("div", undefined, React.createElement("span", {
                                              className: "font-bold"
                                            }, "과세여부"), React.createElement("span", {
                                              className: "text-notice"
                                            }, "*")), React.createElement(ReactHookForm$1.Controller, tmp$2)), React.createElement("div", {
                                      className: "flex flex-col gap-2 max-w-md w-1/3"
                                    }, React.createElement("div", undefined, React.createElement("span", {
                                              className: "font-bold"
                                            }, "택배가능여부"), React.createElement("span", {
                                              className: "text-notice"
                                            }, "*")), React.createElement(ReactHookForm$1.Controller, tmp$4))))))), React.createElement(Dialog.make, {
                  isShow: match$1[0],
                  children: React.createElement("p", undefined, "영구판매중지 상태를 선택 후 저장하시면", React.createElement("br", undefined), "추후 해당 상품을 수정할 수 없습니다.", React.createElement("br", undefined), React.createElement("br", undefined), "영구판매중지 상태로 변경할까요?"),
                  onCancel: (function (param) {
                      setShowProductOperationNoSale(function (param) {
                            return /* Hide */1;
                          });
                    }),
                  onConfirm: (function (param) {
                      setValue("product-operation-status", Select_Product_Operation_Status.Base.status_encode(/* NOSALE */2));
                      setShowProductOperationNoSale(function (param) {
                            return /* Hide */1;
                          });
                    }),
                  textOnCancel: "닫기",
                  textOnConfirm: "확인",
                  kindOfConfirm: /* Negative */1,
                  boxStyle: "rounded-2xl text-center"
                }));
}

var make = Product_Detail_Basic_Admin;

export {
  Query ,
  getTextInputStyle ,
  Form ,
  SelectProducerInput ,
  DisplayPriceInput ,
  ReadOnlyProductId ,
  make ,
}
/* react Not a pure module */
