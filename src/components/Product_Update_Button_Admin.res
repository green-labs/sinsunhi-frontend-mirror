open RadixUI
open Webapi
module Select = Select_Product_Update_Admin

@module("../../public/assets/checkbox-checked.svg")
external checkboxCheckedIcon: string = "default"

@module("../../public/assets/checkbox-unchecked.svg")
external checkboxUncheckedIcon: string = "default"

@module("../../public/assets/edit.svg")
external editIcon: string = "default"

module CutOffAndMemo = {
  @react.component
  let make = (~product: CustomHooks.Products.product) => {
    let router = Next.Router.useRouter()
    let {mutate} = Swr.useSwrConfig()
    let {addToast} = ReactToastNotifications.useToasts()

    let (cutOffTime, setCutOffTime) = React.Uncurried.useState(_ => product.cutOffTime)
    let (memo, setMemo) = React.Uncurried.useState(_ => product.memo)
    let (isUpdateByProductId, setIsUpdateByProductId) = React.Uncurried.useState(_ => false)

    let handleOnChange = (setFn, e) => {
      let newValue = (e->ReactEvent.Synthetic.target)["value"]
      setFn(._ => newValue)
    }

    let close = () => {
      let buttonClose = Dom.document->Dom.Document.getElementById("btn-close")
      buttonClose
      ->Option.flatMap(buttonClose' => {
        buttonClose'->Dom.Element.asHtmlElement
      })
      ->Option.forEach(buttonClose' => {
        buttonClose'->Dom.HtmlElement.click
      })
      ->ignore
    }

    let prefill = isOpen =>
      if isOpen {
        setCutOffTime(._ => product.cutOffTime)
        setMemo(._ => product.memo)
        setIsUpdateByProductId(._ => false)
      }

    let save = (
      _ => {
        {
          "memo": memo,
          "cut-off-time": cutOffTime,
          "update-by-product-id": isUpdateByProductId,
        }
        ->Js.Json.stringifyAny
        ->Option.map(body => {
          FetchHelper.requestWithRetry(
            ~fetcher=FetchHelper.putWithToken,
            ~url=`${Env.restApiUrl}/product/${product.productId->Int.toString}/sku/${product.productSku}`,
            ~body,
            ~count=3,
            ~onSuccess={
              _ => {
                close()
                addToast(.
                  <div className=%twc("flex items-center")>
                    <IconCheck height="24" width="24" fill="#12B564" className=%twc("mr-2") />
                    {j`?????????????????????.`->React.string}
                  </div>,
                  {appearance: "success"},
                )
                mutate(.
                  ~url=`${Env.restApiUrl}/product?${router.query
                    ->Webapi.Url.URLSearchParams.makeWithDict
                    ->Webapi.Url.URLSearchParams.toString}`,
                  ~data=None,
                  ~revalidation=Some(true),
                )
              }
            },
            ~onFailure={
              _ =>
                addToast(.
                  <div className=%twc("flex items-center")>
                    <IconError height="24" width="24" className=%twc("mr-2") />
                    {j`????????? ?????????????????????.`->React.string}
                  </div>,
                  {appearance: "error"},
                )
            },
          )
        })
        ->ignore
      }
    )->ReactEvents.interceptingHandler

    /*
     * ?????????????????? ????????? ????????? ????????? ??? ???????????? ?????? ?????????,
     * ????????? ????????? ?????? ?????? ????????? ???????????? ??????, prefill ??????
     */
    <Dialog.Root onOpenChange=prefill>
      <Dialog.Overlay className=%twc("dialog-overlay") />
      <Dialog.Trigger className=%twc("block text-left mb-1 underline focus:outline-none")>
        <img src=editIcon />
      </Dialog.Trigger>
      <Dialog.Content className=%twc("dialog-content overflow-y-auto")>
        <div className=%twc("p-5")>
          <section className=%twc("flex")>
            <h2 className=%twc("text-xl font-bold")>
              {j`?????????????????? ??? ?????? ??????`->React.string}
            </h2>
            <Dialog.Close className=%twc("inline-block p-1 focus:outline-none ml-auto")>
              <IconClose height="24" width="24" fill="#262626" />
            </Dialog.Close>
          </section>
          <section className=%twc("mt-7")>
            <h3> {j`??????????????????`->React.string} </h3>
            <div className=%twc("mt-2")>
              <Input
                type_="text"
                name="cut-off-time"
                value={cutOffTime->Option.getWithDefault("")}
                onChange={handleOnChange(setCutOffTime)}
                placeholder=`?????????????????? ??????(ex. 09??? ???????????? ?????? ??????)`
                error=None
              />
            </div>
          </section>
          <section className=%twc("mt-5")>
            <h3> {j`??????`->React.string} </h3>
            <div className=%twc("mt-2")>
              <Textarea
                type_="text"
                name="cut-off-time"
                value={memo->Option.getWithDefault("")}
                onChange={handleOnChange(setMemo)}
                placeholder=`????????? ?????? ????????? ????????? ??? ???????????? (?????? 200???)
*????????? ??????????????? ?????? 2????????? ???????????? ??? ????????? ????????? ???????????? ?????? ??????????????? ?????? ????????? ????????? ??? ????????????.`
                error=None
                rows=4
                maxLength=200
              />
            </div>
          </section>
          <section className=%twc("mt-5")>
            <div
              className=%twc("flex items-center cursor-pointer w-fit")
              onClick={_ => setIsUpdateByProductId(.prev => !prev)}>
              <img src={isUpdateByProductId ? checkboxCheckedIcon : checkboxUncheckedIcon} />
              <p className=%twc("ml-2")>
                {j`[${product.productName}] ????????? ???????????? ????????????`->React.string}
              </p>
            </div>
          </section>
          <section className=%twc("flex justify-center items-center mt-5")>
            <Dialog.Close className=%twc("flex mr-2")>
              <span id="btn-close" className=%twc("btn-level6 py-3 px-5")>
                {j`??????`->React.string}
              </span>
            </Dialog.Close>
            <span className=%twc("flex mr-2")>
              <button className=%twc("btn-level1 py-3 px-5") onClick=save>
                {j`??????`->React.string}
              </button>
            </span>
          </section>
        </div>
      </Dialog.Content>
    </Dialog.Root>
  }
}

module Crop = {
  @react.component
  let make = (~product: CustomHooks.Products.product) => {
    let router = Next.Router.useRouter()
    let {mutate} = Swr.useSwrConfig()
    let {addToast} = ReactToastNotifications.useToasts()

    let (selectedCrop, setSelectedCrop) = React.Uncurried.useState(_ => ReactSelect.NotSelected)

    let close = () => {
      let buttonClose = Dom.document->Dom.Document.getElementById("btn-close")
      buttonClose
      ->Option.flatMap(buttonClose' => {
        buttonClose'->Dom.Element.asHtmlElement
      })
      ->Option.forEach(buttonClose' => {
        buttonClose'->Dom.HtmlElement.click
      })
      ->ignore
    }

    let save = (
      _ => {
        switch selectedCrop {
        | ReactSelect.NotSelected => close()
        | ReactSelect.Selected({value, _}) =>
          value
          ->Int.fromString
          ->Option.map(value' =>
            {
              "category-id": value',
            }
            ->Js.Json.stringifyAny
            ->Option.map(body => {
              FetchHelper.requestWithRetry(
                ~fetcher=FetchHelper.putWithToken,
                ~url=`${Env.restApiUrl}/product/${product.productId->Int.toString}/category-id`,
                ~body,
                ~count=3,
                ~onSuccess={
                  _ => {
                    close()
                    addToast(.
                      <div className=%twc("flex items-center")>
                        <IconCheck height="24" width="24" fill="#12B564" className=%twc("mr-2") />
                        {j`?????????????????????.`->React.string}
                      </div>,
                      {appearance: "success"},
                    )
                    mutate(.
                      ~url=`${Env.restApiUrl}/product?${router.query
                        ->Webapi.Url.URLSearchParams.makeWithDict
                        ->Webapi.Url.URLSearchParams.toString}`,
                      ~data=None,
                      ~revalidation=Some(true),
                    )
                  }
                },
                ~onFailure={
                  _ =>
                    addToast(.
                      <div className=%twc("flex items-center")>
                        <IconError height="24" width="24" className=%twc("mr-2") />
                        {j`????????? ?????????????????????.`->React.string}
                      </div>,
                      {appearance: "error"},
                    )
                },
              )
            })
          )
          ->ignore
        }
      }
    )->ReactEvents.interceptingHandler

    let handleChangeCrop = selection => {
      setSelectedCrop(._ => selection)
    }

    let init = isOpen => {
      if isOpen {
        setSelectedCrop(._ => ReactSelect.NotSelected)
      }
    }

    <Dialog.Root onOpenChange=init>
      <Dialog.Overlay className=%twc("dialog-overlay") />
      <Dialog.Trigger className=%twc("block text-left mb-1 underline focus:outline-none")>
        <img src=editIcon />
      </Dialog.Trigger>
      <Dialog.Content className=%twc("dialog-content overflow-y-auto text-sm")>
        <div className=%twc("p-5")>
          <section className=%twc("flex")>
            <h2 className=%twc("text-xl font-bold")> {j`?????? ?????? ??????`->React.string} </h2>
            <Dialog.Close className=%twc("inline-block p-1 focus:outline-none ml-auto")>
              <IconClose height="24" width="24" fill="#262626" />
            </Dialog.Close>
          </section>
          <section className=%twc("mt-7")>
            <h3> {j`??????`->React.string} </h3>
            <div className=%twc("mt-2")>
              <Search_Crop_Cultivar type_=#All value=selectedCrop onChange=handleChangeCrop />
            </div>
          </section>
          <section className=%twc("flex justify-center items-center mt-5")>
            <Dialog.Close className=%twc("flex mr-2")>
              <span id="btn-close" className=%twc("btn-level6 py-3 px-5")>
                {j`??????`->React.string}
              </span>
            </Dialog.Close>
            <span className=%twc("flex mr-2")>
              <button className=%twc("btn-level1 py-3 px-5") onClick={save}>
                {j`??????`->React.string}
              </button>
            </span>
          </section>
        </div>
      </Dialog.Content>
    </Dialog.Root>
  }
}

module Detail = {
  module FormFields = Query_Product_Detail_Form_Admin.FormFields
  module Form = Query_Product_Detail_Form_Admin.Form

  @react.component
  let make = (~product: CustomHooks.Products.product) => {
    let router = Next.Router.useRouter()
    let {mutate} = Swr.useSwrConfig()
    let {addToast} = ReactToastNotifications.useToasts()

    let close = () => {
      let buttonClose = Dom.document->Dom.Document.getElementById("btn-close")
      buttonClose
      ->Option.flatMap(buttonClose' => {
        buttonClose'->Dom.Element.asHtmlElement
      })
      ->Option.forEach(buttonClose' => {
        buttonClose'->Dom.HtmlElement.click
      })
      ->ignore
    }

    let onSubmit = ({state}: Form.onSubmitAPI) => {
      let weight = state.values->FormFields.get(FormFields.Weight)
      let weightUnit = state.values->FormFields.get(FormFields.WeightUnit)
      let unitWieghtMin = state.values->FormFields.get(FormFields.UnitWeightMin)
      let unitWeightMax = state.values->FormFields.get(FormFields.UnitWeightMax)
      let unitWeightUnit = state.values->FormFields.get(FormFields.UnitWeightUnit)
      let unitSizeMin = state.values->FormFields.get(FormFields.UnitSizeMin)
      let unitSizeMax = state.values->FormFields.get(FormFields.UnitSizeMax)
      let unitSizeUnit = state.values->FormFields.get(FormFields.UnitSizeUnit)
      let cntPerPackage = state.values->FormFields.get(FormFields.CntPerPackage)
      let grade = state.values->FormFields.get(FormFields.Grade)
      let packageType = state.values->FormFields.get(FormFields.PackageType)

      {
        "weight": weight->Float.fromString->Js.Null.fromOption,
        "weight-unit": weightUnit,
        "count-per-package": cntPerPackage,
        "grade": grade,
        "per-weight-max": unitWeightMax->Float.fromString->Js.Null.fromOption,
        "per-weight-min": unitWieghtMin->Float.fromString->Js.Null.fromOption,
        "per-weight-unit": unitWeightUnit,
        "per-size-max": unitSizeMax->Float.fromString->Js.Null.fromOption,
        "per-size-min": unitSizeMin->Float.fromString->Js.Null.fromOption,
        "per-size-unit": unitSizeUnit,
        "package-type": packageType,
      }
      ->Js.Json.stringifyAny
      ->Option.map(body => {
        FetchHelper.requestWithRetry(
          ~fetcher=FetchHelper.putWithToken,
          ~url=`${Env.restApiUrl}/product/${product.productId->Int.toString}/sku/${product.productSku}/detail`,
          ~body,
          ~count=3,
          ~onSuccess={
            _ => {
              close()
              addToast(.
                <div className=%twc("flex items-center")>
                  <IconCheck height="24" width="24" fill="#12B564" className=%twc("mr-2") />
                  {j`?????????????????????.`->React.string}
                </div>,
                {appearance: "success"},
              )
              mutate(.
                ~url=`${Env.restApiUrl}/product?${router.query
                  ->Webapi.Url.URLSearchParams.makeWithDict
                  ->Webapi.Url.URLSearchParams.toString}`,
                ~data=None,
                ~revalidation=Some(true),
              )
            }
          },
          ~onFailure={
            _ =>
              addToast(.
                <div className=%twc("flex items-center")>
                  <IconError height="24" width="24" className=%twc("mr-2") />
                  {j`????????? ?????????????????????.`->React.string}
                </div>,
                {appearance: "error"},
              )
          },
        )
      })
      ->ignore

      None
    }

    let form: Form.api = Form.use(
      ~validationStrategy=Form.OnChange,
      ~onSubmit,
      ~initialState=Query_Product_Detail_Form_Admin.initialState,
      ~schema={
        open Form.Validation
        Schema([]->Array.concatMany)
      },
      (),
    )

    let handleOnSubmit = (
      _ => {
        form.submit()
      }
    )->ReactEvents.interceptingHandler

    let prefill = isOpen =>
      if isOpen {
        FormFields.Weight->form.setFieldValue(
          product.weight->Option.mapWithDefault("", Float.toString),
          ~shouldValidate=false,
          (),
        )
        FormFields.WeightUnit->form.setFieldValue(
          product.weightUnit
          ->CustomHooks.Products.weightUnit_encode
          ->Js.Json.decodeString
          ->Option.getWithDefault("g"),
          ~shouldValidate=false,
          (),
        )
        FormFields.UnitWeightMin->form.setFieldValue(
          product.unitWeightMin->Option.mapWithDefault("", Float.toString),
          ~shouldValidate=false,
          (),
        )
        FormFields.UnitWeightMax->form.setFieldValue(
          product.unitWeightMax->Option.mapWithDefault("", Float.toString),
          ~shouldValidate=false,
          (),
        )
        FormFields.UnitWeightUnit->form.setFieldValue(
          product.unitWieghtUnit
          ->CustomHooks.Products.weightUnit_encode
          ->Js.Json.decodeString
          ->Option.getWithDefault("g"),
          ~shouldValidate=false,
          (),
        )
        FormFields.UnitSizeMin->form.setFieldValue(
          product.unitSizeMin->Option.mapWithDefault("", Float.toString),
          ~shouldValidate=false,
          (),
        )
        FormFields.UnitSizeMax->form.setFieldValue(
          product.unitSizeMax->Option.mapWithDefault("", Float.toString),
          ~shouldValidate=false,
          (),
        )
        FormFields.UnitSizeUnit->form.setFieldValue(
          product.unitSizeUnit
          ->CustomHooks.Products.sizeUnit_encode
          ->Js.Json.decodeString
          ->Option.getWithDefault("cm"),
          ~shouldValidate=false,
          (),
        )
        FormFields.CntPerPackage->form.setFieldValue(
          product.cntPerPackage->Option.getWithDefault(""),
          ~shouldValidate=false,
          (),
        )
        FormFields.Grade->form.setFieldValue(
          product.grade->Option.getWithDefault(""),
          ~shouldValidate=false,
          (),
        )
        FormFields.PackageType->form.setFieldValue(
          product.packageType->Option.getWithDefault(""),
          ~shouldValidate=false,
          (),
        )
      }

    <Dialog.Root onOpenChange=prefill>
      <Dialog.Overlay className=%twc("dialog-overlay") />
      <Dialog.Trigger className=%twc("block text-left mb-1 underline focus:outline-none")>
        <img src=editIcon />
      </Dialog.Trigger>
      <Dialog.Content className=%twc("dialog-content overflow-y-auto text-sm")>
        <div className=%twc("p-5")>
          <section className=%twc("flex")>
            <h2 className=%twc("text-xl font-bold")>
              {j`?????? ?????? ?????? ??????`->React.string}
            </h2>
            <Dialog.Close className=%twc("inline-block p-1 focus:outline-none ml-auto")>
              <IconClose height="24" width="24" fill="#262626" />
            </Dialog.Close>
          </section>
          <div className=%twc("flex-col mt-7")>
            <form onSubmit={handleOnSubmit}>
              <div className=%twc("mt-7")>
                <label htmlFor="weight"> {j`??????`->React.string} </label>
                <div className=%twc("mt-2 flex items-center")>
                  <span className=%twc("w-full")>
                    <Input
                      type_="number"
                      step=0.1
                      name="weight"
                      value={form.values->FormFields.get(FormFields.Weight)}
                      onChange={FormFields.Weight->form.handleChange->ReForm.Helpers.handleChange}
                      placeholder=`????????? ??????????????????`
                      error={FormFields.Weight->Form.ReSchema.Field->form.getFieldError}
                    />
                  </span>
                  <span className=%twc("ml-2")>
                    <Select.Weight
                      unit={form.values
                      ->FormFields.get(FormFields.WeightUnit)
                      ->Select.decodeWeightUnit
                      ->Option.getWithDefault(CustomHooks.Products.Kg)}
                      onChange={FormFields.WeightUnit
                      ->form.handleChange
                      ->ReForm.Helpers.handleChange}
                    />
                  </span>
                </div>
              </div>
              <div className=%twc("mt-7")>
                <label htmlFor="box-unit-num"> {j`1???????????????`->React.string} </label>
                <div className=%twc("mt-2")>
                  <Input
                    type_="text"
                    name="box-unit-num"
                    value={form.values->FormFields.get(FormFields.CntPerPackage)}
                    onChange={FormFields.CntPerPackage
                    ->form.handleChange
                    ->ReForm.Helpers.handleChange}
                    placeholder=`1?????? ??? ????????? ??????????????????  (ex. 4,10)`
                    error={FormFields.CntPerPackage->Form.ReSchema.Field->form.getFieldError}
                  />
                </div>
              </div>
              <div className=%twc("mt-7")>
                <label htmlFor="unit-weight-min"> {j`?????? ??????`->React.string} </label>
                <div className=%twc("mt-2 flex items-center")>
                  <Input
                    type_="number"
                    name="unit-weight-min"
                    value={form.values->FormFields.get(FormFields.UnitWeightMin)}
                    onChange={FormFields.UnitWeightMin
                    ->form.handleChange
                    ->ReForm.Helpers.handleChange}
                    placeholder=`??????`
                    error={FormFields.UnitWeightMin->Form.ReSchema.Field->form.getFieldError}
                  />
                  <span className=%twc("mx-2")> {j`~`->React.string} </span>
                  <Input
                    type_="number"
                    step=0.1
                    name="unit-weight-max"
                    value={form.values->FormFields.get(FormFields.UnitWeightMax)}
                    onChange={FormFields.UnitWeightMax
                    ->form.handleChange
                    ->ReForm.Helpers.handleChange}
                    placeholder=`??????`
                    error={FormFields.UnitWeightMax->Form.ReSchema.Field->form.getFieldError}
                  />
                  <span className=%twc("ml-2")>
                    <Select.Weight
                      unit={form.values
                      ->FormFields.get(FormFields.UnitWeightUnit)
                      ->Select.decodeWeightUnit
                      ->Option.getWithDefault(CustomHooks.Products.G)}
                      onChange={FormFields.UnitWeightUnit
                      ->form.handleChange
                      ->ReForm.Helpers.handleChange}
                    />
                  </span>
                </div>
              </div>
              <div className=%twc("mt-7")>
                <label htmlFor="unit-size-min"> {j`?????? ??????`->React.string} </label>
                <div className=%twc("mt-2 flex items-center")>
                  <Input
                    type_="number"
                    step=0.1
                    name="unit-size-min"
                    value={form.values->FormFields.get(FormFields.UnitSizeMin)}
                    onChange={FormFields.UnitSizeMin
                    ->form.handleChange
                    ->ReForm.Helpers.handleChange}
                    placeholder=`??????`
                    error={FormFields.UnitSizeMin->Form.ReSchema.Field->form.getFieldError}
                  />
                  <span className=%twc("mx-2")> {j`~`->React.string} </span>
                  <Input
                    type_="number"
                    step=0.1
                    name="unit-size-max"
                    value={form.values->FormFields.get(FormFields.UnitSizeMax)}
                    onChange={FormFields.UnitSizeMax
                    ->form.handleChange
                    ->ReForm.Helpers.handleChange}
                    placeholder=`??????`
                    error={FormFields.UnitSizeMax->Form.ReSchema.Field->form.getFieldError}
                  />
                  <span className=%twc("ml-2")>
                    <Select.Size
                      unit={form.values
                      ->FormFields.get(FormFields.UnitSizeUnit)
                      ->Select.decodeSizeUnit
                      ->Option.getWithDefault(CustomHooks.Products.Cm)}
                      onChange={FormFields.UnitSizeUnit
                      ->form.handleChange
                      ->ReForm.Helpers.handleChange}
                    />
                  </span>
                </div>
              </div>
              <div className=%twc("flex mt-7 gap-2")>
                <div className=%twc("flex-1 min-w-0")>
                  <label htmlFor="grade"> {j`??????`->React.string} </label>
                  <div className=%twc("mt-2")>
                    <Input
                      type_="text"
                      name="grade"
                      value={form.values->FormFields.get(FormFields.Grade)}
                      onChange={FormFields.Grade->form.handleChange->ReForm.Helpers.handleChange}
                      placeholder=`(ex. ???, ???)`
                      error={FormFields.Grade->Form.ReSchema.Field->form.getFieldError}
                    />
                  </div>
                </div>
                <div className=%twc("flex-1 min-w-0")>
                  <label htmlFor="packageType"> {j`????????????`->React.string} </label>
                  <div className=%twc("mt-2")>
                    <Input
                      type_="text"
                      name="packageType"
                      value={form.values->FormFields.get(FormFields.PackageType)}
                      onChange={FormFields.PackageType
                      ->form.handleChange
                      ->ReForm.Helpers.handleChange}
                      placeholder=`(ex. ???????????? ???)`
                      error={FormFields.PackageType->Form.ReSchema.Field->form.getFieldError}
                    />
                  </div>
                </div>
              </div>
              <div className=%twc("flex justify-center items-center mt-5")>
                <Dialog.Close className=%twc("flex mr-2")>
                  <span id="btn-close" className=%twc("btn-level6 py-3 px-5")>
                    {j`??????`->React.string}
                  </span>
                </Dialog.Close>
                <span className=%twc("flex mr-2")>
                  <button type_="submit" className=%twc("btn-level1 py-3 px-5")>
                    {j`??????`->React.string}
                  </button>
                </span>
              </div>
            </form>
          </div>
        </div>
      </Dialog.Content>
    </Dialog.Root>
  }
}
