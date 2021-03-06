open ReactHookForm

module Fragment = %relay(`
  fragment UpdateNormalProductFormAdminFragment on Product {
    id
    displayCategories {
      fullyQualifiedName {
        type_: type
        id
        name
      }
    }
    category {
      fullyQualifiedName {
        id
        name
      }
    }
    name
    displayName
    productId
    status
    origin
  
    status
    notice
    description
    image {
      original
      thumb1000x1000
      thumb100x100
      thumb1920x1920
      thumb400x400
      thumb800x800
    }
    salesDocument
    noticeStartAt
    noticeEndAt
  
    ... on NormalProduct {
      price
      isCourierAvailable
      isVat
      producer {
        id
        name
        bossName
      }
    }
    ... on QuotableProduct {
      price
      isCourierAvailable
      isVat
      producer {
        id
        name
        bossName
      }
    }
  }
`)

module Mutation = %relay(`
   mutation UpdateNormalProductFormAdminMutation(
     $id: ID!
     $description: String!
     $displayCategoryIds: [ID!]!
     $displayName: String!
     $image: ImageInput!
     $isCourierAvailable: Boolean!
     $name: String!
     $notice: String
     $noticeEndAt: DateTime
     $noticeStartAt: DateTime
     $origin: String!
     $price: Int!
     $salesDocument: String
     $status: ProductStatus!
     $type_: NormalProductType!
   ) {
     updateProduct(
       input: {
         id: $id
         description: $description
         displayCategoryIds: $displayCategoryIds
         displayName: $displayName
         image: $image
         isCourierAvailable: $isCourierAvailable
         name: $name
         notice: $notice
         noticeEndAt: $noticeEndAt
         noticeStartAt: $noticeStartAt
         origin: $origin
         price: $price
         salesDocument: $salesDocument
         status: $status
         type: $type_
       }
     ) {
       ... on UpdateProductResult {
         product {
           id
         }
       }
     }
   } 
`)

let getTextInputStyle = disabled => {
  let defaultStyle = %twc(
    "px-3 py-2 border border-border-default-L1 rounded-lg h-9 focus:outline-none min-w-1/2 max-w-2xl"
  )
  disabled ? cx([defaultStyle, %twc("bg-disabled-L3")]) : defaultStyle
}

// Form ??? ?????? ??????
// names, submit data
module Form = {
  type fromName = {
    producerProductName: string,
    buyerProductName: string,
    basePrice: string,
    origin: string,
    productCategory: string,
    displayCategories: string,
    operationStatus: string,
    delivery: string,
    quotable: string,
    notice: string,
    noticeDateTo: string,
    noticeDateFrom: string,
    thumbnail: string,
    documentURL: string,
    editor: string,
  }

  let formName = {
    producerProductName: "producer-product-name",
    buyerProductName: "buyer-product-name",
    basePrice: "base-price",
    origin: "origin",
    productCategory: "product-category",
    displayCategories: "display-categories",
    operationStatus: "product-operation-status",
    delivery: "product-delivery",
    quotable: "product-quotable",
    notice: "notice",
    noticeDateFrom: "notice-date-from",
    noticeDateTo: "notice-date-to",
    thumbnail: "thumbnail",
    documentURL: "document-url",
    editor: "description-html",
  }

  @spice
  type submit = {
    @spice.key(formName.producerProductName) producerProductName: string,
    @spice.key(formName.buyerProductName) buyerProductName: string,
    @spice.key(formName.basePrice) basePrice: int,
    @spice.key(formName.origin) origin: string,
    @spice.key(formName.productCategory)
    productCategory: Select_Product_Category.Form.submit,
    @spice.key(formName.displayCategories)
    displayCategories: array<Select_Display_Categories.Form.submit>,
    @spice.key(formName.operationStatus)
    operationStatus: Select_Product_Operation_Status.Base.status,
    @spice.key(formName.delivery) delivery: string,
    @spice.key(formName.quotable) quotable: bool,
    @spice.key(formName.notice) notice: option<string>,
    @spice.key(formName.noticeDateFrom) noticeStartAt: option<string>,
    @spice.key(formName.noticeDateTo) noticeEndAt: option<string>,
    @spice.key(formName.thumbnail) thumbnail: Upload_Thumbnail_Admin.Form.image,
    @spice.key(formName.documentURL) documentURL: option<string>,
    @spice.key(formName.editor) editor: string,
  }
}

// ?????????
module ReadOnlyProducer = {
  @react.component
  let make = (~value) => {
    <div className=%twc("flex flex-col gap-2")>
      <div>
        <span className=%twc("font-bold")> {`?????????(????????????)`->React.string} </span>
        <span className=%twc("text-notice")> {`*`->React.string} </span>
      </div>
      <div className=%twc("relative max-w-md w-1/3 h-9")>
        <div className=%twc("absolute w-full")>
          <ReactSelect
            value
            cacheOptions=false
            defaultOptions=false
            //dummy
            loadOptions={_ => Js.Promise.resolve(Some([ReactSelect.NotSelected]))}
            onChange={_ => ()}
            placeholder={`?????????????????? ??????`}
            noOptionsMessage={_ => `?????? ????????? ????????????.`}
            isClearable=true
            isDisabled=true
            styles={ReactSelect.stylesOptions(
              ~menu=(provide, _) => {
                Js.Obj.assign(Js.Obj.empty(), provide)->Js.Obj.assign({
                  "position": "inherit",
                })
              },
              ~control=(provide, _) => {
                Js.Obj.assign(Js.Obj.empty(), provide)->Js.Obj.assign({
                  "minHeight": "unset",
                  "height": "2.25rem",
                })
              },
              (),
            )}
          />
        </div>
      </div>
    </div>
  }
}

// ??????????????????
module ReadOnlyCategory = {
  @react.component
  let make = (~name) => {
    let {control} = Hooks.Context.use(. ~config=Hooks.Form.config(~mode=#onChange, ()), ())

    <div className=%twc("flex flex-col gap-2")>
      <div>
        <span className=%twc(" font-bold")> {`??????????????????`->React.string} </span>
        <span className=%twc("text-notice")> {`*`->React.string} </span>
      </div>
      <Select_Product_Categories control name disabled=true />
    </div>
  }
}

// ??????????????????
module DisplayCategoryInput = {
  @react.component
  let make = (~name, ~disabled) => {
    let {control} = Hooks.Context.use(. ~config=Hooks.Form.config(~mode=#onChange, ()), ())

    <div className=%twc("flex flex-col gap-2")>
      <div>
        <span className=%twc(" font-bold")> {`??????????????????`->React.string} </span>
        <span className=%twc("text-notice")> {`*`->React.string} </span>
      </div>
      <Product_Detail_Display_Categories control name disabled />
      <div />
    </div>
  }
}

// ?????????(????????????, ????????????)
module ProductNameInputs = {
  @react.component
  let make = (
    ~producerProductName,
    ~producerProductNameDefaultValue: string,
    ~buyerProductName,
    ~buyerProductNameDefaultValue: string,
    ~disabled,
  ) => {
    let {formState: {errors}, register} = Hooks.Context.use(.
      ~config=Hooks.Form.config(~mode=#onChange, ()),
      (),
    )

    let producerProductNameInput = register(.
      producerProductName,
      Some(Hooks.Register.config(~required=true, ~maxLength=100, ())),
    )

    let buyerProductNameInput = register(.
      buyerProductName,
      Some(Hooks.Register.config(~required=true, ~maxLength=100, ())),
    )

    <>
      <div className=%twc("flex flex-col gap-2")>
        <label className=%twc("block") htmlFor=producerProductNameInput.name>
          <span className=%twc("font-bold")> {`???????????? ?????????`->React.string} </span>
          <span className=%twc("text-notice")> {`*`->React.string} </span>
        </label>
        <div>
          <input
            id=producerProductNameInput.name
            defaultValue={producerProductNameDefaultValue}
            name=producerProductNameInput.name
            onChange=producerProductNameInput.onChange
            onBlur=producerProductNameInput.onBlur
            ref=producerProductNameInput.ref
            className={getTextInputStyle(disabled)}
            disabled
            placeholder=`???????????? ????????? ??????(?????? 100???)`
          />
          <ErrorMessage
            name=producerProductNameInput.name
            errors
            render={_ =>
              <span className=%twc("flex")>
                <IconError width="20" height="20" />
                <span className=%twc("text-sm text-notice ml-1")>
                  {`???????????? ???????????? ??????????????????.(??????100???)`->React.string}
                </span>
              </span>}
          />
        </div>
      </div>
      // ???????????? ?????????
      <div className=%twc("flex flex-col gap-2")>
        <label className=%twc("block") htmlFor=buyerProductNameInput.name>
          <span className=%twc("font-bold")> {`???????????? ?????????`->React.string} </span>
          <span className=%twc("text-notice")> {`*`->React.string} </span>
        </label>
        <input
          id=buyerProductNameInput.name
          defaultValue={buyerProductNameDefaultValue}
          name=buyerProductNameInput.name
          onChange=buyerProductNameInput.onChange
          onBlur=buyerProductNameInput.onBlur
          ref=buyerProductNameInput.ref
          className={getTextInputStyle(disabled)}
          disabled
          placeholder=`???????????? ????????? ??????, ??????????????? ?????????(?????? 100???)`
        />
        <ErrorMessage
          name=buyerProductNameInput.name
          errors
          render={_ =>
            <span className=%twc("flex")>
              <IconError width="20" height="20" />
              <span className=%twc("text-sm text-notice ml-1")>
                {`???????????? ???????????? ??????????????????.(??????100???)`->React.string}
              </span>
            </span>}
        />
      </div>
    </>
  }
}

// ????????????
module ReadOnlyProductId = {
  @react.component
  let make = (~productId: string) => {
    <div className=%twc("flex flex-col gap-2")>
      <div> <span className=%twc("font-bold")> {`????????????`->React.string} </span> </div>
      <div
        className=%twc(
          "px-3 py-2 border border-border-default-L1 bg-disabled-L3 text-disabled-L1 rounded-lg h-9 max-w-md w-1/3"
        )>
        <span className=%twc("text-enabled-L1")> {productId->React.string} </span>
      </div>
    </div>
  }
}

// ????????????
module DisplayPriceInput = {
  @react.component
  let make = (~name, ~defaultValue: int, ~disabled) => {
    let {control, formState: {errors}} = Hooks.Context.use(.
      ~config=Hooks.Form.config(~mode=#onChange, ()),
      (),
    )
    let valueEncode = (value: int) => value->Float.fromInt->Js.Json.number

    // locale format string ??? float??? ??????
    let localeStringToFloat = (value: string) =>
      value
      ->Js.Re.exec_(%re("/^[\d,]+/"), _)
      ->Option.map(Js.Re.captures)
      ->Option.flatMap(Garter.Array.first)
      ->Option.flatMap(Js.Nullable.toOption)
      ->Option.map(Js.String2.replaceByRe(_, %re("/,/g"), ""))
      ->Option.flatMap(Float.fromString)

    <div className=%twc("flex flex-col gap-2")>
      <label className=%twc("block") htmlFor=name>
        <span className=%twc("font-bold")>
          {`???????????? ?????? ????????????`->React.string}
        </span>
        <span className=%twc("text-notice")> {`*`->React.string} </span>
      </label>
      <Controller
        name
        control
        defaultValue={defaultValue->valueEncode}
        rules={Rules.make(~required=true, ())}
        render={({field: {onChange, value, name, ref}}) => {
          <input
          // value(number)??? locale format?????? ??????
            value={value
            ->Js.Json.decodeNumber
            ->Option.mapWithDefault("", Locale.Float.show(~digits=0))}
            type_="text"
            id=name
            onChange={e => {
              let value = (e->ReactEvent.Synthetic.currentTarget)["value"]

              let validValue =
                value
                ->localeStringToFloat
                ->Option.map(Js.Json.number)
                ->Option.getWithDefault(Js.Json.string(""))

              onChange(Controller.OnChangeArg.value(validValue))
            }}
            ref
            disabled
            className={getTextInputStyle(disabled)}
            placeholder=`?????? ??????(?????? ???)`
          />
        }}
      />
      <ErrorMessage
        name
        errors
        render={_ =>
          <span className=%twc("flex")>
            <IconError width="20" height="20" />
            <span className=%twc("text-sm text-notice ml-1")>
              {`???????????? ?????? ??????????????? ??????????????????.`->React.string}
            </span>
          </span>}
      />
    </div>
  }
}

// ????????????
module OperationStatusInput = {
  @react.component
  let make = (~name, ~defaultValue, ~disabled) => {
    let {control, formState: {errors}, setValue} = Hooks.Context.use(.
      ~config=Hooks.Form.config(~mode=#onChange, ()),
      (),
    )
    let (
      isShowProductOperationNoSale,
      setShowProductOperationNoSale,
    ) = React.Uncurried.useState(_ => Dialog.Hide)

    let handleProductOperation = (
      changeFn,
      status: Select_Product_Operation_Status.Base.status,
    ) => {
      switch status {
      | RETIRE => setShowProductOperationNoSale(._ => Dialog.Show)
      | _ =>
        changeFn(
          Controller.OnChangeArg.value(status->Select_Product_Operation_Status.Base.status_encode),
        )
      }
    }

    <>
      <div className=%twc("flex flex-col gap-2 max-w-md w-1/3")>
        <div>
          <span className=%twc("font-bold")> {`????????????`->React.string} </span>
          <span className=%twc("text-notice")> {`*`->React.string} </span>
        </div>
        <Controller
          name
          control
          defaultValue=?{defaultValue->Option.map(
            Select_Product_Operation_Status.Base.status_encode,
          )}
          rules={Rules.make(~required=true, ())}
          render={({field: {onChange, value, ref}}) =>
            <div>
              <Select_Product_Operation_Status.Base
                status={value
                ->Select_Product_Operation_Status.Base.status_decode
                ->Result.mapWithDefault(None, status => Some(status))}
                onChange={handleProductOperation(onChange)}
                forwardRef={ref}
                disabled
              />
              <ErrorMessage
                errors
                name
                render={_ =>
                  <span className=%twc("flex")>
                    <IconError width="20" height="20" />
                    <span className=%twc("text-sm text-notice ml-1")>
                      {`??????????????? ??????????????????.`->React.string}
                    </span>
                  </span>}
              />
            </div>}
        />
      </div>
      <Dialog
        isShow=isShowProductOperationNoSale
        textOnConfirm=`??????`
        textOnCancel=`??????`
        boxStyle=%twc("rounded-2xl text-center")
        kindOfConfirm=Dialog.Negative
        onConfirm={_ => {
          setValue(. name, RETIRE->Select_Product_Operation_Status.Base.status_encode)
          setShowProductOperationNoSale(._ => Dialog.Hide)
        }}
        onCancel={_ => setShowProductOperationNoSale(._ => Dialog.Hide)}>
        <p>
          {`?????????????????? ????????? ?????? ??? ???????????????`->React.string}
          <br />
          {`?????? ?????? ????????? ????????? ??? ????????????.`->React.string}
          <br />
          <br />
          {`?????????????????? ????????? ????????????????`->React.string}
        </p>
      </Dialog>
    </>
  }
}

// ?????????
module OriginInput = {
  @react.component
  let make = (~name, ~defaultValue, ~disabled) => {
    let {register, formState: {errors}} = Hooks.Context.use(.
      ~config=Hooks.Form.config(~mode=#onChange, ()),
      (),
    )
    let productOrigin = register(. name, Some(Hooks.Register.config(~required=true, ())))

    // ?????????
    <div className=%twc("flex flex-col gap-2 max-w-md w-1/3")>
      <label className=%twc("block") htmlFor=productOrigin.name>
        <span className=%twc("font-bold")> {`?????????`->React.string} </span>
        <span className=%twc("text-notice")> {`*`->React.string} </span>
      </label>
      <input
        id=productOrigin.name
        name=productOrigin.name
        defaultValue=?{defaultValue}
        onChange=productOrigin.onChange
        onBlur=productOrigin.onBlur
        ref=productOrigin.ref
        className={getTextInputStyle(disabled)}
        placeholder=`????????? ??????`
        disabled
      />
      <ErrorMessage
        errors
        name
        render={_ =>
          <span className=%twc("flex")>
            <IconError width="20" height="20" />
            <span className=%twc("text-sm text-notice ml-1")>
              {`???????????? ??????????????????.`->React.string}
            </span>
          </span>}
      />
    </div>
  }
}

// ????????????
module ReadOnlyIsVat = {
  @react.component
  let make = (~status) => {
    <div className=%twc("flex flex-col gap-2 max-w-md w-1/3")>
      <div>
        <span className=%twc("font-bold")> {`????????????`->React.string} </span>
        <span className=%twc("text-notice")> {`*`->React.string} </span>
      </div>
      <Select_Tax_Status status={Some(status)} onChange={_ => ()} disabled={true} />
    </div>
  }
}

// ??????????????????
module IsCourierAvailableInput = {
  @react.component
  let make = (~name, ~defaultValue, ~disabled) => {
    let {control, formState: {errors}} = Hooks.Context.use(.
      ~config=Hooks.Form.config(~mode=#onChange, ()),
      (),
    )

    <div className=%twc("flex flex-col gap-2 max-w-md w-1/3")>
      <div>
        <span className=%twc("font-bold")> {`??????????????????`->React.string} </span>
        <span className=%twc("text-notice")> {`*`->React.string} </span>
      </div>
      <Controller
        name
        control
        defaultValue={defaultValue->Select_Delivery.status_encode}
        rules={Rules.make(~required=true, ())}
        render={({field: {onChange, value, ref}}) =>
          <div>
            <Select_Delivery
              status={value
              ->Select_Delivery.status_decode
              ->Result.mapWithDefault(None, status => Some(status))}
              onChange={e => onChange(Controller.OnChangeArg.event(e))}
              forwardRef={ref}
              disabled
            />
            <ErrorMessage
              errors
              name
              render={_ =>
                <span className=%twc("flex")>
                  <IconError width="20" height="20" />
                  <span className=%twc("text-sm text-notice ml-1")>
                    {`????????????????????? ??????????????????.`->React.string}
                  </span>
                </span>}
            />
          </div>}
      />
    </div>
  }
}

// ??????????????????
module QuotableCheckbox = {
  @react.component
  let make = (~name, ~defaultValue, ~disabled) => {
    let {register} = Hooks.Context.use(. ~config=Hooks.Form.config(~mode=#onChange, ()), ())
    let quotable = register(. name, None)

    <div className=%twc("flex flex-col gap-2 max-w-md w-1/3")>
      <div className=%twc("block")>
        <span className=%twc("font-bold")> {`?????? ?????? ??????`->React.string} </span>
      </div>
      <div className=%twc("flex gap-2 items-center")>
        <Checkbox.Uncontrolled
          defaultChecked={defaultValue}
          id=quotable.name
          name=quotable.name
          onChange=quotable.onChange
          onBlur=quotable.onBlur
          inputRef=quotable.ref
          disabled
        />
        <label htmlFor=quotable.name className=%twc("cursor-pointer")>
          {`?????? ??????(?????? ????????????) ?????? ????????????`->React.string}
        </label>
      </div>
    </div>
  }
}

// ????????????, ?????? ??????
module NoticeAndDateInput = {
  module DateInput = {
    @react.component
    let make = (~name, ~minDate=?, ~defaultValue=?, ~disabled=?) => {
      let {control} = Hooks.Context.use(. ~config=Hooks.Form.config(~mode=#onChange, ()), ())

      let strToJson = dateStr => {
        dateStr->Js.Date.fromString->DateFns.format("yyyy-MM-dd")->Js.Json.string
      }

      let jsonToStr = jsonStr => {
        jsonStr->Js.Json.decodeString->Option.keep(str => str != "")->Option.map(Js.Date.fromString)
      }

      <Controller
        name
        control
        defaultValue={defaultValue->Option.mapWithDefault(Js.Json.string(""), strToJson)}
        render={({field: {name, value, onChange}}) => {
          <DatePicker
            id=name
            date=?{value->jsonToStr}
            onChange={e => {
              (e->DuetDatePicker.DuetOnChangeEvent.detail).value
              ->Js.Json.string
              ->Controller.OnChangeArg.value
              ->onChange
            }}
            ?minDate
            firstDayOfWeek=0
            ?disabled
          />
        }}
      />
    }
  }

  @react.component
  let make = (
    ~noticeName,
    ~defaultNotice,
    ~noticeFromName,
    ~defaultNoticeFrom,
    ~noticeToName,
    ~defaultNoticeTo,
    ~disabled,
  ) => {
    let {register, formState: {errors}} = Hooks.Context.use(.
      ~config=Hooks.Form.config(~mode=#onChange, ()),
      (),
    )

    let noticeDateFrom = Hooks.WatchValues.use(
      Hooks.WatchValues.Text,
      ~config=Hooks.WatchValues.config(~name=noticeFromName, ()),
      (),
    )

    let notice = register(. noticeName, Some(Hooks.Register.config(~maxLength=1000, ())))

    <>
      // ????????????
      <div className=%twc("flex flex-col gap-2")>
        <label htmlFor={notice.name}>
          <span className=%twc("font-bold")> {`????????????`->React.string} </span>
        </label>
        <textarea
          id=notice.name
          name=notice.name
          defaultValue=?{defaultNotice}
          onBlur=notice.onBlur
          onChange=notice.onChange
          ref=notice.ref
          className=%twc(
            "px-3 py-2 border border-border-default-L1 rounded-lg h-24 focus:outline-none min-w-1/2 max-w-2xl"
          )
          placeholder=`???????????? ?????? ?????? ??????(?????? 1000???)`
          disabled
        />
        <ErrorMessage
          errors
          name={notice.name}
          render={_ =>
            <span className=%twc("flex")>
              <IconError width="20" height="20" />
              <span className=%twc("text-sm text-notice ml-1")>
                {`??????????????? ?????? 1000????????? ?????? ???????????????.`->React.string}
              </span>
            </span>}
        />
      </div>
      // ???????????? ????????????
      <div className=%twc("flex flex-col gap-2")>
        <span className=%twc("font-bold")> {`???????????? ????????????`->React.string} </span>
        <div className=%twc("flex gap-1")>
          <DateInput
            name=noticeFromName minDate="2021-01-01" defaultValue=?{defaultNoticeFrom} disabled
          />
          <span className=%twc("flex items-center")> {`~`->React.string} </span>
          <DateInput
            name=noticeToName
            minDate={noticeDateFrom->Option.getWithDefault("")}
            defaultValue=?{defaultNoticeTo}
            disabled
          />
        </div>
      </div>
    </>
  }
}

// ?????? ????????? ?????????
module ThumbnailUploadInput = {
  @react.component
  let make = (~name, ~defaultValue, ~disabled) => {
    let {control, formState: {errors}} = Hooks.Context.use(.
      ~config=Hooks.Form.config(~mode=#onChange, ()),
      (),
    )

    <div className=%twc("flex flex-col gap-2")>
      <div>
        <span className=%twc("font-bold")> {`???????????????(?????????)`->React.string} </span>
        <span className=%twc("text-red-500")> {`*`->React.string} </span>
        <span className=%twc("text-text-L2 ml-2")>
          {`*????????? ?????? ?????? ?????? ??????`->React.string}
        </span>
      </div>
      <div>
        <Controller
          name
          control
          defaultValue={defaultValue->Upload_Thumbnail_Admin.Form.image_encode}
          rules={Rules.make(
            ~required=true,
            ~validate=Js.Dict.fromArray([
              (
                "required",
                Validation.sync(value =>
                  value
                  ->Upload_Thumbnail_Admin.Form.image_decode
                  ->Result.mapWithDefault(false, image => image.original !== "")
                ),
              ),
            ]),
            (),
          )}
          render={({field: {value, onChange, name}}) =>
            <Upload_Thumbnail_Admin
              name
              updateFn={imageUrls =>
                onChange(
                  Controller.OnChangeArg.value(imageUrls->Upload_Thumbnail_Admin.Form.image_encode),
                )}
              value={value
              ->Upload_Thumbnail_Admin.Form.image_decode
              ->Result.getWithDefault(Upload_Thumbnail_Admin.Form.resetImage)}
              disabled
            />}
        />
        <ErrorMessage
          errors
          name
          render={_ =>
            <span className=%twc("flex")>
              <IconError width="20" height="20" />
              <span className=%twc("text-sm text-notice ml-1")>
                {`???????????????(?????????)??? ??????????????????.`->React.string}
              </span>
            </span>}
        />
      </div>
    </div>
  }
}

// ???????????? URL
module SalesDocumentURLInput = {
  @react.component
  let make = (~name, ~defaultValue, ~disabled) => {
    let {register} = Hooks.Context.use(. ~config=Hooks.Form.config(~mode=#onChange, ()), ())
    let documentURL = register(. name, None)

    <div className=%twc("flex flex-col gap-2")>
      <label className=%twc("block font-bold")> {`???????????? URL`->React.string} </label>
      <input
        id=documentURL.name
        name=documentURL.name
        ?defaultValue
        className=%twc(
          "py-2 px-3 h-9 border-border-default-L1 border rounded-lg focus:outline-none min-w-1/2 max-w-2xl"
        )
        onChange=documentURL.onChange
        onBlur=documentURL.onBlur
        ref=documentURL.ref
        disabled
      />
    </div>
  }
}

// ?????????
module EditorInput = {
  @react.component
  let make = (~name, ~defaultValue, ~disabled) => {
    let {control, formState: {errors}} = Hooks.Context.use(.
      ~config=Hooks.Form.config(~mode=#onChange, ()),
      (),
    )

    <div className=%twc("flex flex-col gap-2")>
      <div className=%twc("flex gap-2")>
        <div>
          <span className=%twc("font-bold")> {`????????????`->React.string} </span>
          <span className=%twc("text-red-500")> {`*`->React.string} </span>
        </div>
        <ErrorMessage
          errors
          name
          render={_ =>
            <span className=%twc("flex")>
              <IconError width="20" height="20" />
              <span className=%twc("text-sm text-notice ml-1")>
                {`??????????????? ??????????????????.`->React.string}
              </span>
            </span>}
        />
      </div>
      <div> <Product_Detail_Editor control name defaultValue disabled /> </div>
    </div>
  }
}

let deliveryDecode = (s: bool): Select_Delivery.status => {
  switch s {
  | true => AVAILABLE
  | false => UNAVAILABLE
  }
}

let isVatDecode = (s: bool): Select_Tax_Status.status => {
  switch s {
  | true => TAX
  | false => FREE
  }
}

let producerToReactSelected = (
  p: UpdateNormalProductFormAdminFragment_graphql.Types.fragment_producer,
) => {
  ReactSelect.Selected({
    value: p.id,
    label: p.bossName->Option.mapWithDefault(p.name, bn => `${p.name}(${bn})`),
  })
}

let toDisplayCategory = query => {
  let generateForm: array<
    UpdateNormalProductFormAdminFragment_graphql.Types.fragment_displayCategories_fullyQualifiedName,
  > => Select_Display_Categories.Form.submit = categories => {
    categoryType: switch categories->Garter.Array.first->Option.map(({type_}) => type_) {
    | Some(#NORMAL) => ReactSelect.Selected({value: "normal", label: `??????`})
    | Some(#SHOWCASE) => ReactSelect.Selected({value: "showcase", label: `?????????`})
    | _ => ReactSelect.NotSelected
    },
    c1: categories
    ->Array.get(0)
    ->Option.mapWithDefault(ReactSelect.NotSelected, d => {
      ReactSelect.Selected({value: d.id, label: d.name})
    }),
    c2: categories
    ->Array.get(1)
    ->Option.mapWithDefault(ReactSelect.NotSelected, d => {
      ReactSelect.Selected({value: d.id, label: d.name})
    }),
    c3: categories
    ->Array.get(2)
    ->Option.mapWithDefault(ReactSelect.NotSelected, d => {
      ReactSelect.Selected({value: d.id, label: d.name})
    }),
    c4: categories
    ->Array.get(3)
    ->Option.mapWithDefault(ReactSelect.NotSelected, d => {
      ReactSelect.Selected({value: d.id, label: d.name})
    }),
    c5: categories
    ->Array.get(4)
    ->Option.mapWithDefault(ReactSelect.NotSelected, d => {
      ReactSelect.Selected({value: d.id, label: d.name})
    }),
  }
  query->generateForm
}

let toProductCategory = query => {
  let generateForm: array<
    UpdateNormalProductFormAdminFragment_graphql.Types.fragment_category_fullyQualifiedName,
  > => Select_Product_Category.Form.submit = categories => {
    c1: categories
    ->Array.get(0)
    ->Option.mapWithDefault(ReactSelect.NotSelected, d => {
      ReactSelect.Selected({value: d.id, label: d.name})
    }),
    c2: categories
    ->Array.get(1)
    ->Option.mapWithDefault(ReactSelect.NotSelected, d => {
      ReactSelect.Selected({value: d.id, label: d.name})
    }),
    c3: categories
    ->Array.get(2)
    ->Option.mapWithDefault(ReactSelect.NotSelected, d => {
      ReactSelect.Selected({value: d.id, label: d.name})
    }),
    c4: categories
    ->Array.get(3)
    ->Option.mapWithDefault(ReactSelect.NotSelected, d => {
      ReactSelect.Selected({value: d.id, label: d.name})
    }),
    c5: categories
    ->Array.get(4)
    ->Option.mapWithDefault(ReactSelect.NotSelected, d => {
      ReactSelect.Selected({value: d.id, label: d.name})
    }),
  }

  query->generateForm
}

let toImage: UpdateNormalProductFormAdminFragment_graphql.Types.fragment_image => Upload_Thumbnail_Admin.Form.image = image => {
  original: image.original,
  thumb1000x1000: image.thumb1000x1000,
  thumb100x100: image.thumb100x100,
  thumb1920x1920: image.thumb1920x1920,
  thumb400x400: image.thumb400x400,
  thumb800x800: image.thumb800x800,
}

let encodeStatus = (status: Select_Product_Operation_Status.Base.status) => {
  switch status {
  | SALE => #SALE
  | SOLDOUT => #SOLDOUT
  | HIDDEN_SALE => #HIDDEN_SALE
  | NOSALE => #NOSALE
  | RETIRE => #RETIRE
  }
}

let decodeStatus = (s): option<Select_Product_Operation_Status.Base.status> => {
  switch s {
  | #SALE => SALE->Some
  | #SOLDOUT => SOLDOUT->Some
  | #HIDDEN_SALE => HIDDEN_SALE->Some
  | #NOSALE => NOSALE->Some
  | #RETIRE => RETIRE->Some
  | _ => None
  }
}

let makeNormalProductVariables = (productId, form: Form.submit) =>
  Mutation.makeVariables(
    ~id=productId,
    ~displayCategoryIds=form.displayCategories->ProductForm.makeDisplayCategoryIds,
    ~displayName=form.buyerProductName,
    ~image={
      original: form.thumbnail.original,
      thumb1000x1000: form.thumbnail.thumb1000x1000,
      thumb100x100: form.thumbnail.thumb100x100,
      thumb1920x1920: form.thumbnail.thumb1920x1920,
      thumb400x400: form.thumbnail.thumb400x400,
      thumb800x800: form.thumbnail.thumb800x800,
    },
    ~description=form.editor,
    ~isCourierAvailable=form.delivery->Select_Delivery.toBool,
    ~name=form.producerProductName,
    ~notice=?{form.notice->Option.keep(str => str != "")},
    ~noticeStartAt=?{form.noticeStartAt->ProductForm.makeNoticeDate(DateFns.startOfDay)},
    ~noticeEndAt=?{form.noticeEndAt->ProductForm.makeNoticeDate(DateFns.endOfDay)},
    ~origin=form.origin,
    ~price=form.basePrice,
    ~salesDocument=?{form.documentURL->Option.keep(str => str != "")},
    ~status=form.operationStatus->encodeStatus,
    ~type_=switch form.quotable {
    | true => #QUOTABLE
    | false => #NORMAL
    },
    (),
  )

@react.component
let make = (~query, ~isQuotable) => {
  let router = Next.Router.useRouter()
  let product = Fragment.use(query)
  let (normalMutate, isNormalMutating) = Mutation.use()
  let {addToast} = ReactToastNotifications.useToasts()

  let (isShowUpdateSuccess, setShowUpdateSuccess) = React.Uncurried.useState(_ => Dialog.Hide)
  let (isShowInitalize, setShowInitialize) = React.Uncurried.useState(_ => Dialog.Hide)

  let disabled = product.status == #RETIRE

  let methods = Hooks.Form.use(.
    ~config=Hooks.Form.config(
      ~mode=#onChange,
      ~defaultValues=[
        //?????????????????? ???????????? Field array ????????? defaultValue??? Form?????? ?????? ????????? ????????? ??? ?????? ????????? ????????? ?????? ??????????????? ??????.
        (
          Product_Detail_Basic_Admin.Form.formName.displayCategories,
          product.displayCategories
          ->Array.map(d => d.fullyQualifiedName)
          ->Array.map(toDisplayCategory)
          ->Array.map(Select_Display_Categories.Form.submit_encode)
          ->Js.Json.array,
        ),
        (
          Product_Detail_Basic_Admin.Form.formName.productCategory,
          product.category.fullyQualifiedName
          ->toProductCategory
          ->Select_Product_Category.Form.submit_encode,
        ),
      ]
      ->Js.Dict.fromArray
      ->Js.Json.object_,
      (),
    ),
    (),
  )
  let {handleSubmit} = methods

  let {
    producerProductName,
    buyerProductName,
    basePrice,
    origin,
    productCategory,
    displayCategories,
    operationStatus,
    delivery,
    quotable,
    notice,
    noticeDateFrom,
    noticeDateTo,
    thumbnail,
    documentURL,
    editor,
  } = Form.formName

  let onSubmit = (data: Js.Json.t, _) => {
    let result =
      data
      ->Form.submit_decode
      ->Result.map(data' =>
        normalMutate(
          ~variables=makeNormalProductVariables(product.id, data'),
          ~onCompleted={(_, _) => setShowUpdateSuccess(._ => Dialog.Show)},
          (),
        )->ignore
      )

    switch result {
    | Error(e) => {
        Js.log(e)
        addToast(.
          <div className=%twc("flex items-center")>
            <IconError height="24" width="24" className=%twc("mr-2") />
            {j`????????? ?????????????????????. ??????????????? ???????????????.`->React.string}
          </div>,
          {appearance: "error"},
        )
      }
    | _ => ()
    }
  }

  let handleReset = ReactEvents.interceptingHandler(_ => {
    setShowInitialize(._ => Dialog.Show)
  })

  <ReactHookForm.Provider methods>
    <form onSubmit={handleSubmit(. onSubmit)}>
      <section className=%twc("p-7 mx-4 bg-white rounded-b-md")>
        <h2 className=%twc("text-text-L1 text-lg font-bold")> {j`????????????`->React.string} </h2>
        <div className=%twc("divide-y text-sm")>
          <div className=%twc("flex flex-col space-y-6 py-6")>
            {switch product.producer {
            | Some(producer') => <ReadOnlyProducer value={producer'->producerToReactSelected} />
            | None => React.null
            }}
            <ReadOnlyCategory name=productCategory />
            <DisplayCategoryInput name=displayCategories disabled />
          </div>
          <div className=%twc("flex flex-col space-y-6 py-6")>
            <ProductNameInputs
              producerProductName
              buyerProductName
              producerProductNameDefaultValue={product.name}
              buyerProductNameDefaultValue={product.displayName}
              disabled
            />
            <ReadOnlyProductId productId={product.productId->Int.toString} />
            <DisplayPriceInput
              name=basePrice defaultValue={product.price->Option.getWithDefault(-1)} disabled
            />
          </div>
          <div className=%twc("py-6 flex flex-col space-y-6")>
            <div className=%twc("flex gap-2")>
              <OperationStatusInput
                name=operationStatus defaultValue={product.status->decodeStatus} disabled
              />
              <OriginInput name=origin defaultValue={product.origin} disabled />
            </div>
            <div className=%twc("flex gap-2 text-sm")>
              <ReadOnlyIsVat status={product.isVat->Option.getWithDefault(false)->isVatDecode} />
              <IsCourierAvailableInput
                name=delivery
                defaultValue={product.isCourierAvailable
                ->Option.getWithDefault(false)
                ->deliveryDecode}
                disabled
              />
            </div>
          </div>
          <div className=%twc("py-6 flex flex-col space-y-6")>
            <QuotableCheckbox name={quotable} defaultValue={isQuotable} disabled />
          </div>
        </div>
      </section>
      <section className=%twc("p-7 mt-4 mx-4 mb-7 bg-white rounded shadow-gl")>
        <h2 className=%twc("text-text-L1 text-lg font-bold")>
          {j`??????????????????`->React.string}
        </h2>
        <div className=%twc("text-sm py-6 flex flex-col space-y-6")>
          <NoticeAndDateInput
            noticeName=notice
            noticeFromName=noticeDateFrom
            noticeToName=noticeDateTo
            defaultNotice={product.notice}
            defaultNoticeFrom={product.noticeStartAt}
            defaultNoticeTo={product.noticeEndAt}
            disabled
          />
          <ThumbnailUploadInput name=thumbnail defaultValue={product.image->toImage} disabled />
          <SalesDocumentURLInput name=documentURL defaultValue={product.salesDocument} disabled />
          <EditorInput name=editor defaultValue={product.description} disabled />
        </div>
      </section>
      <div
        className=%twc(
          "fixed bottom-0 h-16 max-w-gnb-panel bg-white flex items-center gap-2 justify-end pr-10 w-full z-50"
        )>
        {switch product.status {
        | #RETIRE =>
          <button
            type_="submit"
            disabled=true
            className=%twc("px-3 py-2 bg-disabled-L2 text-white rounded-lg focus:outline-none")>
            {`????????? ????????? ??? ????????????.`->React.string}
          </button>
        | _ => <>
            <button
              type_="reset"
              className=%twc("px-3 py-2 bg-div-shape-L1 rounded-lg focus:outline-none")
              onClick={handleReset}
              disabled={isNormalMutating}>
              {`???????????? ?????????`->React.string}
            </button>
            <button
              type_="submit"
              disabled={isNormalMutating}
              className=%twc(
                "px-3 py-2 bg-green-gl text-white rounded-lg hover:bg-green-gl-dark focus:outline-none"
              )>
              {`?????? ??????`->React.string}
            </button>
          </>
        }}
      </div>
    </form>
    <Dialog
      boxStyle=%twc("text-center rounded-2xl")
      isShow={isShowInitalize}
      textOnCancel=`??????`
      textOnConfirm=`?????????`
      kindOfConfirm=Dialog.Negative
      onConfirm={_ => {
        router->Next.Router.reload(router.pathname)
        setShowInitialize(._ => Dialog.Hide)
      }}
      onCancel={_ => setShowInitialize(._ => Dialog.Hide)}>
      <p> {`????????? ?????? ????????? ????????? ????????????????`->React.string} </p>
    </Dialog>
    <Dialog
      boxStyle=%twc("text-center rounded-2xl")
      isShow={isShowUpdateSuccess}
      textOnCancel=`??????`
      onCancel={_ => {
        setShowUpdateSuccess(._ => Dialog.Hide)
        router->Next.Router.reload(router.pathname)
      }}>
      <p className=%twc("text-gray-500 text-center whitespace-pre-wrap")>
        {`??????????????? ?????????????????????.`->React.string}
      </p>
    </Dialog>
  </ReactHookForm.Provider>
}
