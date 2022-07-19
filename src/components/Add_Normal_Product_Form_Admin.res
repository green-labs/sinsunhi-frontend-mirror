open ReactHookForm
module Mutation = %relay(`
  mutation AddNormalProductFormAdminMutation(
    $categoryId: ID!
    $description: String!
    $displayCategoryIds: [ID!]!
    $displayName: String!
    $image: ImageInput!
    $isCourierAvailable: Boolean!
    $isVat: Boolean!
    $name: String!
    $notice: String
    $noticeEndAt: DateTime
    $noticeStartAt: DateTime
    $origin: String!
    $price: Int!
    $producerId: ID!
    $salesDocument: String
    $status: ProductStatus!
    $type_: NormalProductType!
  ) {
    createProduct(
      input: {
        categoryId: $categoryId
        description: $description
        displayCategoryIds: $displayCategoryIds
        displayName: $displayName
        image: $image
        isCourierAvailable: $isCourierAvailable
        isVat: $isVat
        name: $name
        notice: $notice
        noticeEndAt: $noticeEndAt
        noticeStartAt: $noticeStartAt
        origin: $origin
        price: $price
        producerId: $producerId
        salesDocument: $salesDocument
        status: $status
        type: $type_
      }
    ) {
      ... on CreateProductResult {
        product {
          id
        }
      }
      ... on Error {
        code
        message
      }
    }
  }
`)

//Form 에 대한 정보
// names, submit data
module Form = {
  type fromName = {
    producerName: string,
    producerProductName: string,
    buyerProductName: string,
    basePrice: string,
    origin: string,
    productCategory: string,
    displayCategories: string,
    operationStatus: string,
    tax: string,
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
    producerName: "producer-name",
    producerProductName: "producer-product-name",
    buyerProductName: "buyer-product-name",
    basePrice: "base-price",
    origin: "origin",
    productCategory: "product-category",
    displayCategories: "display-categories",
    operationStatus: "product-operation-status",
    tax: "product-tax",
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
    @spice.key(formName.producerName) producerName: ReactSelect.selectValue,
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
    @spice.key(formName.tax) tax: string,
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

let getTextInputStyle = (~disabled) => {
  let defaultStyle = %twc(
    "px-3 py-2 border border-border-default-L1 rounded-lg h-9 focus:outline-none min-w-1/2 max-w-2xl"
  )
  disabled ? cx([defaultStyle, %twc("bg-disabled-L3")]) : defaultStyle
}

// 생산자 정보
module SelectProducerInput = {
  module Query = %relay(`
  query AddNormalProductFormAdminSelectProducerInputQuery(
    $nameMatch: String
    $role: UserRole!
  ) {
    users(name: $nameMatch, roles: [$role]) {
      edges {
        cursor
        node {
          id
          name
          bossName
        }
      }
    }
  }
  `)

  @react.component
  let make = (~name) => {
    let {control, formState: {errors}} = Hooks.Context.use(.
      ~config=Hooks.Form.config(~mode=#onChange, ()),
      (),
    )

    let handleLoadOptions = inputValue => {
      Query.fetchPromised(
        ~environment=RelayEnv.envSinsunMarket,
        ~variables={
          nameMatch: Some(inputValue),
          role: #PRODUCER,
        },
        (),
      ) |> Js.Promise.then_((
        result: AddNormalProductFormAdminSelectProducerInputQuery_graphql.Types.rawResponse,
      ) => {
        let result' = result.users.edges->Array.map(edge => ReactSelect.Selected({
          value: edge.node.id,
          label: edge.node.bossName->Option.mapWithDefault(edge.node.name, boss =>
            `${edge.node.name}(${boss})`
          ),
        }))

        Js.Promise.resolve(Some(result'))
      })
    }

    <div className=%twc("flex flex-col gap-2")>
      <div>
        <span className=%twc("font-bold")> {`생산자(대표자명)`->React.string} </span>
        <span className=%twc("text-notice")> {`*`->React.string} </span>
      </div>
      <div className=%twc("relative max-w-md w-1/3 h-9")>
        <div className=%twc("absolute w-full")>
          <Controller
            name
            control
            rules={Rules.make(~required=true, ())}
            defaultValue={ReactSelect.NotSelected->ReactSelect.encoderRule}
            render={({field: {onChange, value, ref}}) => <>
              <ReactSelect
                value={value
                ->ReactSelect.decoderRule
                ->Result.getWithDefault(ReactSelect.NotSelected)}
                loadOptions={Helper.Debounce.make1(handleLoadOptions, 500)}
                ref
                cacheOptions=false
                defaultOptions=false
                onChange={data =>
                  onChange(Controller.OnChangeArg.value(data->ReactSelect.encoderRule))}
                placeholder={`생산자명으로 찾기`}
                noOptionsMessage={_ => `검색 결과가 없습니다.`}
                isClearable=true
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
            </>}
          />
        </div>
      </div>
      <ErrorMessage
        name
        errors
        render={_ =>
          <span className=%twc("flex")>
            <IconError width="20" height="20" />
            <span className=%twc("text-sm text-notice ml-1")>
              {`생산자명을 입력해주세요.`->React.string}
            </span>
          </span>}
      />
    </div>
  }
}

// 상품명(생산자용, 바어어용)
module ProductNameInputs = {
  @react.component
  let make = (~producerProductName, ~buyerProductName) => {
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
            name=producerProductNameInput.name
            onChange=producerProductNameInput.onChange
            onBlur=producerProductNameInput.onBlur
            ref=producerProductNameInput.ref
            className={getTextInputStyle(~disabled=false)}
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
          name=buyerProductNameInput.name
          onChange=buyerProductNameInput.onChange
          onBlur=buyerProductNameInput.onBlur
          ref=buyerProductNameInput.ref
          className={getTextInputStyle(~disabled=false)}
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

// 표준카테테고리
module Category = {
  @react.component
  let make = (~name) => {
    let {control} = Hooks.Context.use(. ~config=Hooks.Form.config(~mode=#onChange, ()), ())

    <div className=%twc("flex flex-col gap-2")>
      <div>
        <span className=%twc(" font-bold")> {`표준카테고리`->React.string} </span>
        <span className=%twc("text-notice")> {`*`->React.string} </span>
      </div>
      <Select_Product_Categories control name disabled=false />
    </div>
  }
}

// 전시카테고리
module DisplayCategory = {
  @react.component
  let make = (~name) => {
    let {control} = Hooks.Context.use(. ~config=Hooks.Form.config(~mode=#onChange, ()), ())

    <div className=%twc("flex flex-col gap-2")>
      <div>
        <span className=%twc(" font-bold")> {`전시카테고리`->React.string} </span>
        <span className=%twc("text-notice")> {`*`->React.string} </span>
      </div>
      <Product_Detail_Display_Categories control name disabled={false} />
      <div />
    </div>
  }
}

// 상품번호
module ReadOnlyProductId = {
  @react.component
  let make = () => {
    <div className=%twc("flex flex-col gap-2")>
      <div> <span className=%twc("font-bold")> {`상품번호`->React.string} </span> </div>
      <div
        className=%twc(
          "px-3 py-2 border border-border-default-L1 bg-disabled-L3 text-disabled-L1 rounded-lg h-9 max-w-md w-1/3"
        )>
        <span className=%twc("text-disabled-L1")>
          {`저장 후 자동생성됩니다.`->React.string}
        </span>
      </div>
    </div>
  }
}

// 전시 기준가격
module DisplayPriceInput = {
  @react.component
  let make = (~name) => {
    let {control, formState: {errors}} = Hooks.Context.use(.
      ~config=Hooks.Form.config(~mode=#onChange, ()),
      (),
    )

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
            className={getTextInputStyle(~disabled=false)}
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
  let make = (~name) => {
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
          rules={Rules.make(~required=true, ())}
          render={({field: {onChange, value, ref}}) =>
            <div>
              <Select_Product_Operation_Status.Base
                status={value
                ->Select_Product_Operation_Status.Base.status_decode
                ->Result.mapWithDefault(None, status => Some(status))}
                onChange={handleProductOperation(onChange)}
                forwardRef={ref}
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
  let make = (~name) => {
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
        onChange=productOrigin.onChange
        onBlur=productOrigin.onBlur
        ref=productOrigin.ref
        className={getTextInputStyle(~disabled=false)}
        placeholder=`원산지 입력`
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
module IsVatInput = {
  @react.component
  let make = (~name) => {
    let {control, formState: {errors}} = Hooks.Context.use(.
      ~config=Hooks.Form.config(~mode=#onChange, ()),
      (),
    )

    <div className=%twc("flex flex-col gap-2 max-w-md w-1/3")>
      <div>
        <span className=%twc("font-bold")> {`과세여부`->React.string} </span>
        <span className=%twc("text-notice")> {`*`->React.string} </span>
      </div>
      <Controller
        name
        control
        rules={Rules.make(~required=true, ())}
        render={({field: {onChange, value, ref}}) =>
          <div>
            <Select_Tax_Status
              status={value
              ->Select_Tax_Status.status_decode
              ->Result.mapWithDefault(None, status => Some(status))}
              onChange={e => onChange(Controller.OnChangeArg.event(e))}
              forwardRef={ref}
            />
            <ErrorMessage
              errors
              name
              render={_ =>
                <span className=%twc("flex")>
                  <IconError width="20" height="20" />
                  <span className=%twc("text-sm text-notice ml-1")>
                    {`과면세여부를 선택해주세요.`->React.string}
                  </span>
                </span>}
            />
          </div>}
      />
    </div>
  }
}

// 택배가능여부
module IsCourierAvailableInput = {
  @react.component
  let make = (~name) => {
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
        rules={Rules.make(~required=true, ())}
        render={({field: {onChange, value, ref}}) =>
          <div>
            <Select_Delivery
              status={value
              ->Select_Delivery.status_decode
              ->Result.mapWithDefault(None, status => Some(status))}
              onChange={e => onChange(Controller.OnChangeArg.event(e))}
              forwardRef={ref}
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
  let make = (~name) => {
    let {register} = Hooks.Context.use(. ~config=Hooks.Form.config(~mode=#onChange, ()), ())
    let quotable = register(. name, None)

    <div className=%twc("flex flex-col gap-2 max-w-md w-1/3")>
      <div className=%twc("block")>
        <span className=%twc("font-bold")> {`견적 문의 버튼`->React.string} </span>
      </div>
      <div className=%twc("flex gap-2 items-center")>
        <Checkbox.Uncontrolled
          defaultChecked={false}
          id=quotable.name
          name=quotable.name
          onChange=quotable.onChange
          onBlur=quotable.onBlur
          inputRef=quotable.ref
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
    let make = (~name, ~minDate=?) => {
      let {control} = Hooks.Context.use(. ~config=Hooks.Form.config(~mode=#onChange, ()), ())

      let jsonToStr = jsonStr => {
        jsonStr->Js.Json.decodeString->Option.keep(str => str != "")->Option.map(Js.Date.fromString)
      }

      <Controller
        name
        control
        defaultValue={Js.Json.string("")}
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
          />
        }}
      />
    }
  }

  @react.component
  let make = (~noticeName, ~noticeFromName, ~noticeToName) => {
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
          onBlur=notice.onBlur
          onChange=notice.onChange
          ref=notice.ref
          className=%twc(
            "px-3 py-2 border border-border-default-L1 rounded-lg h-24 focus:outline-none min-w-1/2 max-w-2xl"
          )
          placeholder=`공지사항 또는 메모 입력(최대 1000자)`
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
          <DateInput name=noticeFromName minDate="2021-01-01" />
          <span className=%twc("flex items-center")> {`~`->React.string} </span>
          <DateInput name=noticeToName minDate={noticeDateFrom->Option.getWithDefault("")} />
        </div>
      </div>
    </>
  }
}

// 대표 이미지 썸네일
module ThumbnailUploadInput = {
  @react.component
  let make = (~name) => {
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
          defaultValue={Upload_Thumbnail_Admin.Form.resetImage->Upload_Thumbnail_Admin.Form.image_encode}
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
  let make = (~name) => {
    let {register} = Hooks.Context.use(. ~config=Hooks.Form.config(~mode=#onChange, ()), ())
    let documentURL = register(. name, None)

    <div className=%twc("flex flex-col gap-2")>
      <label className=%twc("block font-bold")> {`판매자료 URL`->React.string} </label>
      <input
        id=documentURL.name
        name=documentURL.name
        className=%twc(
          "py-2 px-3 h-9 border-border-default-L1 border rounded-lg focus:outline-none min-w-1/2 max-w-2xl"
        )
        onChange=documentURL.onChange
        onBlur=documentURL.onBlur
        ref=documentURL.ref
      />
    </div>
  }
}

// 에디터
module EditorInput = {
  @react.component
  let make = (~name) => {
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
      <div> <Product_Detail_Editor control name /> </div>
    </div>
  }
}

module NormalSuccessDialog = {
  type showWithId = Show(string) | Hide
  @react.component
  let make = (~showWithId) => {
    let router = Next.Router.useRouter()

    let (isShow, id) = {
      switch showWithId {
      | Show(id) => (Dialog.Show, Some(id))
      | Hide => (Dialog.Hide, None)
      }
    }

    <Dialog
      boxStyle=%twc("text-center rounded-2xl")
      isShow
      textOnCancel=`아니오(목록으로)`
      textOnConfirm=`네`
      kindOfConfirm=Dialog.Positive
      onCancel={_ => router->Next.Router.push("/admin/products")}
      onConfirm={_ =>
        id
        ->Option.map(id' => router->Next.Router.push(`/admin/products/${id'}/create-options`))
        ->ignore}>
      <div className=%twc("flex flex-col")>
        <span> {`상품등록이 완료되었습니다.`->React.string} </span>
        <span> {`이어서 상품의 단품을 등록하시겠어요?`->React.string} </span>
      </div>
    </Dialog>
  }
}

let makeNormalProductVariables = (form: Form.submit) =>
  Mutation.makeVariables(
    ~categoryId=form.productCategory.c5->ProductForm.makeCategoryId,
    ~displayCategoryIds=form.displayCategories->ProductForm.makeDisplayCategoryIds,
    ~description=form.editor,
    ~displayName=form.buyerProductName,
    ~image={
      original: form.thumbnail.original,
      thumb1000x1000: form.thumbnail.thumb1000x1000,
      thumb100x100: form.thumbnail.thumb100x100,
      thumb1920x1920: form.thumbnail.thumb1920x1920,
      thumb400x400: form.thumbnail.thumb400x400,
      thumb800x800: form.thumbnail.thumb800x800,
    },
    ~isVat={form.tax->Select_Tax_Status.toBool},
    ~isCourierAvailable={form.delivery->Select_Delivery.toBool},
    ~name=form.producerProductName,
    ~notice=?{form.notice->Option.keep(str => str != "")},
    ~noticeEndAt=?{form.noticeEndAt->ProductForm.makeNoticeDate(DateFns.endOfDay)},
    ~noticeStartAt=?{form.noticeStartAt->ProductForm.makeNoticeDate(DateFns.startOfDay)},
    ~origin=form.origin,
    ~price=form.basePrice,
    ~producerId=form.producerName.value,
    ~salesDocument=?{form.documentURL->Option.keep(str => str != "")},
    ~status=switch form.operationStatus {
    | SALE => #SALE
    | SOLDOUT => #SOLDOUT
    | HIDDEN_SALE => #HIDDEN_SALE
    | NOSALE => #NOSALE
    | RETIRE => #RETIRE
    },
    ~type_=switch form.quotable {
    | true => #QUOTABLE
    | false => #NORMAL
    },
    (),
  )

@react.component
let make = () => {
  let (normalMutate, isNormalMutating) = Mutation.use()
  let {addToast} = ReactToastNotifications.useToasts()

  let methods = Hooks.Form.use(.
    ~config=Hooks.Form.config(
      ~mode=#onChange,
      ~defaultValues=[
        (
          Product_Detail_Basic_Admin.Form.formName.displayCategories,
          [
            Select_Display_Categories.Form.defaultDisplayCategory(
              Select_Display_Categories.Form.Normal,
            ),
          ]->Js.Json.array,
        ),
        (Product_Detail_Description_Admin.Form.formName.thumbnail, ""->Js.Json.string),
      ]
      ->Js.Dict.fromArray
      ->Js.Json.object_,
      (),
    ),
    (),
  )

  let {handleSubmit, reset} = methods

  let (isShowReset, setShowReset) = React.Uncurried.useState(_ => Dialog.Hide)
  let (isShowNormalSuccess, setShowNormalSucess) = React.Uncurried.useState(_ =>
    NormalSuccessDialog.Hide
  )

  let handleReset = ReactEvents.interceptingHandler(_ => {
    setShowReset(._ => Dialog.Show)
  })

  let onSubmit = (data: Js.Json.t, _) => {
    Js.log(data)

    let result =
      data
      ->Form.submit_decode
      ->Result.map(data' =>
        normalMutate(
          ~variables=makeNormalProductVariables(data'),
          ~onCompleted=({createProduct}, _) => {
            switch createProduct {
            | #CreateProductResult({product}) => setShowNormalSucess(._ => Show(product.id))
            | _ => ()
            }
          },
          (),
        )->ignore
      )

    switch result {
    | Error(e) => {
        Js.log(e)
        addToast(.
          <div className=%twc("flex items-center")>
            <IconError height="24" width="24" className=%twc("mr-2") />
            {j`오류가 발생하였습니다. 등록내용을 확인하세요.`->React.string}
          </div>,
          {appearance: "error"},
        )
      }
    | _ => ()
    }
  }

  let {
    producerName,
    producerProductName,
    buyerProductName,
    basePrice,
    origin,
    productCategory,
    displayCategories,
    operationStatus,
    tax,
    delivery,
    quotable,
    notice,
    noticeDateFrom,
    noticeDateTo,
    thumbnail,
    documentURL,
    editor,
  } = Form.formName

  <ReactHookForm.Provider methods>
    <form onSubmit={handleSubmit(. onSubmit)}>
      <section className=%twc("p-7 mx-4 bg-white rounded-b-md")>
        <h2 className=%twc("text-text-L1 text-lg font-bold")> {j`기본정보`->React.string} </h2>
        <div className=%twc("divide-y text-sm")>
          <div className=%twc("flex flex-col space-y-6 py-6")>
            <SelectProducerInput name=producerName />
            <Category name=productCategory />
            <DisplayCategory name=displayCategories />
          </div>
          <div className=%twc("flex flex-col space-y-6 py-6")>
            <ProductNameInputs producerProductName buyerProductName />
            <ReadOnlyProductId />
            <DisplayPriceInput name=basePrice />
          </div>
          <div className=%twc("py-6 flex flex-col space-y-6")>
            <div className=%twc("flex gap-2")>
              <OperationStatusInput name=operationStatus /> <OriginInput name=origin />
            </div>
            <div className=%twc("flex gap-2")>
              <IsVatInput name=tax /> <IsCourierAvailableInput name=delivery />
            </div>
          </div>
          <div className=%twc("py-6 flex flex-col space-y-6")>
            <QuotableChackbox name={quotable} />
          </div>
        </div>
      </section>
      <section className=%twc("p-7 mt-4 mx-4 mb-7 bg-white rounded shadow-gl")>
        <h2 className=%twc("text-text-L1 text-lg font-bold")>
          {j`상품상세설명`->React.string}
        </h2>
        <div className=%twc("text-sm py-6 flex flex-col space-y-6")>
          <NoticeAndDateInput
            noticeName=notice noticeFromName=noticeDateFrom noticeToName=noticeDateTo
          />
          <ThumbnailUploadInput name=thumbnail />
          <SalesDocumentURLInput name=documentURL />
          <EditorInput name=editor />
        </div>
      </section>
      <div
        className=%twc(
          "relative h-16 max-w-gnb-panel bg-white flex items-center gap-2 justify-end pr-5"
        )>
        <button
          type_="reset"
          className=%twc("px-3 py-2 bg-div-shape-L1 rounded-lg focus:outline-none")
          onClick={handleReset}
          disabled={isNormalMutating}>
          {`초기화`->React.string}
        </button>
        <button
          type_="submit"
          className=%twc(
            "px-3 py-2 bg-green-gl text-white rounded-lg hover:bg-green-gl-dark focus:outline-none"
          )
          disabled={isNormalMutating}>
          {`상품 등록`->React.string}
        </button>
      </div>
      <Dialog
        boxStyle=%twc("text-center rounded-2xl")
        isShow={isShowReset}
        textOnCancel=`닫기`
        textOnConfirm=`초기화`
        kindOfConfirm=Dialog.Negative
        onConfirm={_ => {
          reset(. None)
          setShowReset(._ => Dialog.Hide)
        }}
        onCancel={_ => setShowReset(._ => Dialog.Hide)}>
        <p> {`모든 내용을 초기화 하시겠어요?`->React.string} </p>
      </Dialog>
      <NormalSuccessDialog showWithId={isShowNormalSuccess} />
    </form>
  </ReactHookForm.Provider>
}
