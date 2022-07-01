open ReactHookForm

module Fragment = %relay(`
  fragment UpdateNormalProductFormAdminFragment on Product {
    name
    displayName
    productId
    price
    status
    origin
    isCourierAvailable
    isVat
    producer {
      id
      name
      bossName
    }
    status
    notice
    description
    type_: type
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
  }
`)

let getTextInputStyle = disabled => {
  let defaultStyle = %twc(
    "px-3 py-2 border border-border-default-L1 rounded-lg h-9 focus:outline-none min-w-1/2 max-w-2xl"
  )
  disabled ? cx([defaultStyle, %twc("bg-disabled-L3")]) : defaultStyle
}

// Form 에 대한 정보
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

// 생산자
module ReadOnlyProducer = {
  @react.component
  let make = (~value) => {
    <div className=%twc("flex flex-col gap-2")>
      <div>
        <span className=%twc("font-bold")> {`생산자(대표자명)`->React.string} </span>
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
            placeholder={`생산자명으로 찾기`}
            noOptionsMessage={_ => `검색 결과가 없습니다.`}
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

// 표준카테고리
module ReadOnlyCategory = {
  @react.component
  let make = (~name) => {
    let {control} = Hooks.Context.use(. ~config=Hooks.Form.config(~mode=#onChange, ()), ())

    <div className=%twc("flex flex-col gap-2")>
      <div>
        <span className=%twc(" font-bold")> {`표준카테고리`->React.string} </span>
        <span className=%twc("text-notice")> {`*`->React.string} </span>
      </div>
      <Select_Product_Categories control name disabled=true />
    </div>
  }
}

// 전시카테고리
module DisplayCategoryInput = {
  @react.component
  let make = (~name, ~disabled) => {
    let {control} = Hooks.Context.use(. ~config=Hooks.Form.config(~mode=#onChange, ()), ())

    <div className=%twc("flex flex-col gap-2")>
      <div>
        <span className=%twc(" font-bold")> {`전시카테고리`->React.string} </span>
        <span className=%twc("text-notice")> {`*`->React.string} </span>
      </div>
      <Product_Detail_Display_Categories control name disabled />
      <div />
    </div>
  }
}

// 상품명(생산자용, 바어어용)
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
          <span className=%twc("font-bold")> {`생산자용 상품명`->React.string} </span>
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
            placeholder=`생산자용 상품명 입력(최대 100자)`
          />
          <ErrorMessage
            name=producerProductNameInput.name
            errors
            render={_ =>
              <span className=%twc("flex")>
                <IconError width="20" height="20" />
                <span className=%twc("text-sm text-notice ml-1")>
                  {`생산자용 상품명을 입력해주세요.(최대100자)`->React.string}
                </span>
              </span>}
          />
        </div>
      </div>
      // 바이어용 상품명
      <div className=%twc("flex flex-col gap-2")>
        <label className=%twc("block") htmlFor=buyerProductNameInput.name>
          <span className=%twc("font-bold")> {`바이어용 상품명`->React.string} </span>
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
          placeholder=`바이어용 상품명 입력, 상품매장에 노출됨(최대 100자)`
        />
        <ErrorMessage
          name=buyerProductNameInput.name
          errors
          render={_ =>
            <span className=%twc("flex")>
              <IconError width="20" height="20" />
              <span className=%twc("text-sm text-notice ml-1")>
                {`바이어용 상품명을 입력해주세요.(최대100자)`->React.string}
              </span>
            </span>}
        />
      </div>
    </>
  }
}

// 상품번호
module ReadOnlyProductId = {
  @react.component
  let make = (~productId: string) => {
    <div className=%twc("flex flex-col gap-2")>
      <div> <span className=%twc("font-bold")> {`상품번호`->React.string} </span> </div>
      <div
        className=%twc(
          "px-3 py-2 border border-border-default-L1 bg-disabled-L3 text-disabled-L1 rounded-lg h-9 max-w-md w-1/3"
        )>
        <span className=%twc("text-enabled-L1")> {productId->React.string} </span>
      </div>
    </div>
  }
}

// 기준가격
module DisplayPriceInput = {
  @react.component
  let make = (~name, ~defaultValue: int, ~disabled) => {
    let {control, formState: {errors}} = Hooks.Context.use(.
      ~config=Hooks.Form.config(~mode=#onChange, ()),
      (),
    )
    let valueEncode = (value: int) => value->Float.fromInt->Js.Json.number

    // locale format string 을 float로 변환
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
          {`전시매장 노출 기준가격`->React.string}
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
          // value(number)를 locale format으로 변환
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
            placeholder=`가격 입력(단위 원)`
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
              {`전시매장 노출 기준가격을 입력해주세요.`->React.string}
            </span>
          </span>}
      />
    </div>
  }
}

// 운영상태
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
          <span className=%twc("font-bold")> {`운영상태`->React.string} </span>
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
                      {`운영상태를 선택해주세요.`->React.string}
                    </span>
                  </span>}
              />
            </div>}
        />
      </div>
      <Dialog
        isShow=isShowProductOperationNoSale
        textOnConfirm=`확인`
        textOnCancel=`닫기`
        boxStyle=%twc("rounded-2xl text-center")
        kindOfConfirm=Dialog.Negative
        onConfirm={_ => {
          setValue(. name, RETIRE->Select_Product_Operation_Status.Base.status_encode)
          setShowProductOperationNoSale(._ => Dialog.Hide)
        }}
        onCancel={_ => setShowProductOperationNoSale(._ => Dialog.Hide)}>
        <p>
          {`영구판매중지 상태를 선택 후 저장하시면`->React.string}
          <br />
          {`추후 해당 상품을 수정할 수 없습니다.`->React.string}
          <br />
          <br />
          {`영구판매중지 상태로 변경할까요?`->React.string}
        </p>
      </Dialog>
    </>
  }
}

// 원산지
module OriginInput = {
  @react.component
  let make = (~name, ~defaultValue, ~disabled) => {
    let {register, formState: {errors}} = Hooks.Context.use(.
      ~config=Hooks.Form.config(~mode=#onChange, ()),
      (),
    )
    let productOrigin = register(. name, Some(Hooks.Register.config(~required=true, ())))

    // 원산지
    <div className=%twc("flex flex-col gap-2 max-w-md w-1/3")>
      <label className=%twc("block") htmlFor=productOrigin.name>
        <span className=%twc("font-bold")> {`원산지`->React.string} </span>
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
        placeholder=`원산지 입력`
        disabled
      />
      <ErrorMessage
        errors
        name
        render={_ =>
          <span className=%twc("flex")>
            <IconError width="20" height="20" />
            <span className=%twc("text-sm text-notice ml-1")>
              {`원산지를 입력해주세요.`->React.string}
            </span>
          </span>}
      />
    </div>
  }
}

// 과세여부
module ReadOnlyIsVat = {
  @react.component
  let make = (~status) => {
    <div className=%twc("flex flex-col gap-2 max-w-md w-1/3")>
      <div>
        <span className=%twc("font-bold")> {`과세여부`->React.string} </span>
        <span className=%twc("text-notice")> {`*`->React.string} </span>
      </div>
      <Select_Tax_Status status={Some(status)} onChange={_ => ()} disabled={true} />
    </div>
  }
}

// 택배가능여부
module IsCourierAvailableInput = {
  @react.component
  let make = (~name, ~defaultValue, ~disabled) => {
    let {control, formState: {errors}} = Hooks.Context.use(.
      ~config=Hooks.Form.config(~mode=#onChange, ()),
      (),
    )

    <div className=%twc("flex flex-col gap-2 max-w-md w-1/3")>
      <div>
        <span className=%twc("font-bold")> {`택배가능여부`->React.string} </span>
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
                    {`택배가능여부를 선택해주세요.`->React.string}
                  </span>
                </span>}
            />
          </div>}
      />
    </div>
  }
}

// 견적가능여부
module QuotableChackbox = {
  @react.component
  let make = (~name, ~defaultValue, ~disabled) => {
    let {register} = Hooks.Context.use(. ~config=Hooks.Form.config(~mode=#onChange, ()), ())
    let quotable = register(. name, None)

    <div className=%twc("flex flex-col gap-2 max-w-md w-1/3")>
      <div className=%twc("block")>
        <span className=%twc("font-bold")> {`견적 문의 버튼`->React.string} </span>
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
          {`견적 문의(가격 문의하기) 버튼 노출하기`->React.string}
        </label>
      </div>
    </div>
  }
}

// 공지사항, 적용 날짜
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
      // 공지사항
      <div className=%twc("flex flex-col gap-2")>
        <label htmlFor={notice.name}>
          <span className=%twc("font-bold")> {`공지사항`->React.string} </span>
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
          placeholder=`공지사항 또는 메모 입력(최대 1000자)`
          disabled
        />
        <ErrorMessage
          errors
          name={notice.name}
          render={_ =>
            <span className=%twc("flex")>
              <IconError width="20" height="20" />
              <span className=%twc("text-sm text-notice ml-1")>
                {`공지사항은 최대 1000자까지 입력 가능합니다.`->React.string}
              </span>
            </span>}
        />
      </div>
      // 공지사항 적용기간
      <div className=%twc("flex flex-col gap-2")>
        <span className=%twc("font-bold")> {`공지사항 적용기간`->React.string} </span>
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

// 대표 이미지 썸네일
module ThumbnailUploadInput = {
  @react.component
  let make = (~name, ~defaultValue, ~disabled) => {
    let {control, formState: {errors}} = Hooks.Context.use(.
      ~config=Hooks.Form.config(~mode=#onChange, ()),
      (),
    )

    <div className=%twc("flex flex-col gap-2")>
      <div>
        <span className=%twc("font-bold")> {`대표이미지(썸네일)`->React.string} </span>
        <span className=%twc("text-red-500")> {`*`->React.string} </span>
        <span className=%twc("text-text-L2 ml-2")>
          {`*이미지 파일 형식 등록 가능`->React.string}
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
                {`대표이미지(썸네일)을 선택해주세요.`->React.string}
              </span>
            </span>}
        />
      </div>
    </div>
  }
}

// 판매자료 URL
module SalesDocumentURLInput = {
  @react.component
  let make = (~name, ~defaultValue, ~disabled) => {
    let {register} = Hooks.Context.use(. ~config=Hooks.Form.config(~mode=#onChange, ()), ())
    let documentURL = register(. name, None)

    <div className=%twc("flex flex-col gap-2")>
      <label className=%twc("block font-bold")> {`판매자료 URL`->React.string} </label>
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

// 에디터
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
          <span className=%twc("font-bold")> {`상품설명`->React.string} </span>
          <span className=%twc("text-red-500")> {`*`->React.string} </span>
        </div>
        <ErrorMessage
          errors
          name
          render={_ =>
            <span className=%twc("flex")>
              <IconError width="20" height="20" />
              <span className=%twc("text-sm text-notice ml-1")>
                {`상품설명을 추가해주세요.`->React.string}
              </span>
            </span>}
        />
      </div>
      <div> <Product_Detail_Editor control name defaultValue disabled /> </div>
    </div>
  }
}

let statusDecode = (
  s: UpdateNormalProductFormAdminFragment_graphql.Types.enum_ProductStatus,
): option<Select_Product_Operation_Status.Base.status> => {
  switch s {
  | #SALE => SALE->Some
  | #SOLDOUT => SOLDOUT->Some
  | #HIDDEN_SALE => HIDDEN_SALE->Some
  | #NOSALE => NOSALE->Some
  | #RETIRE => RETIRE->Some
  | _ => None
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

let isQuatable = (s: UpdateNormalProductFormAdminFragment_graphql.Types.enum_ProductType): bool => {
  switch s {
  | #NORMAL => false
  | #QUOTABLE => true
  | _ => false
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

let queryImageToFormImage: UpdateNormalProductFormAdminFragment_graphql.Types.fragment_image => Upload_Thumbnail_Admin.Form.image = image => {
  original: image.original,
  thumb1000x1000: image.thumb1000x1000,
  thumb100x100: image.thumb100x100,
  thumb1920x1920: image.thumb1920x1920,
  thumb400x400: image.thumb400x400,
  thumb800x800: image.thumb800x800,
}

@react.component
let make = (~query) => {
  let data = Fragment.use(query)

  let disabled = data.status == #RETIRE

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

  <>
    <section className=%twc("p-7 mx-4 bg-white rounded-b-md")>
      <h2 className=%twc("text-text-L1 text-lg font-bold")> {j`기본정보`->React.string} </h2>
      <div className=%twc("divide-y text-sm")>
        <div className=%twc("flex flex-col space-y-6 py-6")>
          <ReadOnlyProducer value={data.producer->producerToReactSelected} />
          <ReadOnlyCategory name=productCategory />
          <DisplayCategoryInput name=displayCategories disabled />
        </div>
        <div className=%twc("flex flex-col space-y-6 py-6")>
          <ProductNameInputs
            producerProductName
            buyerProductName
            producerProductNameDefaultValue={data.name}
            buyerProductNameDefaultValue={data.displayName}
            disabled
          />
          <ReadOnlyProductId productId={data.productId->Int.toString} />
          <DisplayPriceInput
            name=basePrice defaultValue={data.price->Option.getWithDefault(-1)} disabled
          />
        </div>
        <div className=%twc("py-6 flex flex-col space-y-6")>
          <div className=%twc("flex gap-2")>
            <OperationStatusInput
              name=operationStatus defaultValue={data.status->statusDecode} disabled
            />
            <OriginInput name=origin defaultValue={data.origin} disabled />
          </div>
          <div className=%twc("flex gap-2 text-sm")>
            <ReadOnlyIsVat status={data.isVat->isVatDecode} />
            <IsCourierAvailableInput
              name=delivery defaultValue={data.isCourierAvailable->deliveryDecode} disabled
            />
          </div>
        </div>
        <div className=%twc("py-6 flex flex-col space-y-6")>
          <QuotableChackbox name={quotable} defaultValue={data.type_->isQuatable} disabled />
        </div>
      </div>
    </section>
    <section className=%twc("p-7 mt-4 mx-4 mb-7 bg-white rounded shadow-gl")>
      <h2 className=%twc("text-text-L1 text-lg font-bold")>
        {j`상품상세설명`->React.string}
      </h2>
      <div className=%twc("text-sm py-6 flex flex-col space-y-6")>
        <NoticeAndDateInput
          noticeName=notice
          noticeFromName=noticeDateFrom
          noticeToName=noticeDateTo
          defaultNotice={data.notice}
          defaultNoticeFrom={data.noticeStartAt}
          defaultNoticeTo={data.noticeEndAt}
          disabled
        />
        <ThumbnailUploadInput
          name=thumbnail defaultValue={data.image->queryImageToFormImage} disabled
        />
        <SalesDocumentURLInput name=documentURL defaultValue={data.salesDocument} disabled />
        <EditorInput name=editor defaultValue={data.description} disabled />
      </div>
    </section>
  </>
}
