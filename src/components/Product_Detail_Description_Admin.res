open ReactHookForm

module Form = {
  type formName = {
    notice: string,
    noticeDate: string,
    noticeDateTo: string,
    noticeDateFrom: string,
    thumbnail: string,
    documentURL: string,
    editor: string,
  }

  let formName = {
    notice: "notice",
    noticeDate: "notice-date",
    noticeDateFrom: "notice-date-from",
    noticeDateTo: "notice-date-to",
    thumbnail: "thumbnail",
    documentURL: "document-url",
    editor: "description-html",
  }
}

module NoticeDateInput = {
  @react.component
  let make = (~name, ~defaultValue=?, ~minDate=?, ~disabled=?) => {
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

module ThumbnailUploadInput = {
  @react.component
  let make = (~name, ~defaultValue=?, ~disabled=false) => {
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
          defaultValue={defaultValue
          ->Option.getWithDefault(Upload_Thumbnail_Admin.Form.resetImage)
          ->Upload_Thumbnail_Admin.Form.image_encode}
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

@react.component
let make = (
  ~defaultNotice=?,
  ~defaultDescription=?,
  ~defaultThumbnail=?,
  ~defaultSalesDocument=?,
  ~defaultNoticeStratAt=?,
  ~defaultNoticeEndAt=?,
  ~noticeDisabled=false,
  ~noticeStartAtDisabled=false,
  ~noticeEndAtDisabled=false,
  ~thumbnailDisabled=false,
  ~documentURLDisabled=false,
  ~discriptionDisabled=false,
  ~allFieldsDisabled=false,
) => {
  let {register, control, formState: {errors}} = Hooks.Context.use(.
    ~config=Hooks.Form.config(~mode=#onChange, ()),
    (),
  )

  let noticeDateFrom = Hooks.WatchValues.use(
    Hooks.WatchValues.Text,
    ~config=Hooks.WatchValues.config(~name=Form.formName.noticeDateFrom, ()),
    (),
  )

  let notice = register(. Form.formName.notice, Some(Hooks.Register.config(~maxLength=1000, ())))

  let documentURL = register(. Form.formName.documentURL, None)

  let getDisabled = disabled => allFieldsDisabled || disabled

  <div>
    <h2 className=%twc("text-text-L1 text-lg font-bold")>
      {j`상품상세설명`->React.string}
    </h2>
    <div className=%twc("text-sm py-6 flex flex-col space-y-6")>
      // 공지사항
      <div className=%twc("flex flex-col gap-2")>
        <label htmlFor={notice.name}>
          <span className=%twc("font-bold")> {`공지사항`->React.string} </span>
        </label>
        <textarea
          defaultValue={defaultNotice->Option.getWithDefault("")}
          id=notice.name
          name=notice.name
          onBlur=notice.onBlur
          onChange=notice.onChange
          ref=notice.ref
          disabled={getDisabled(noticeDisabled)}
          className=%twc(
            "px-3 py-2 border border-border-default-L1 rounded-lg h-24 focus:outline-none min-w-1/2 max-w-2xl"
          )
          placeholder=`공지사항 또는 메모 입력(최대 1000자)`
        />
        <ErrorMessage
          errors
          name={Form.formName.notice}
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
          <NoticeDateInput
            name=Form.formName.noticeDateFrom
            defaultValue=?defaultNoticeStratAt
            minDate="2021-01-01"
            disabled={getDisabled(noticeStartAtDisabled)}
          />
          <span className=%twc("flex items-center")> {`~`->React.string} </span>
          <NoticeDateInput
            name=Form.formName.noticeDateTo
            defaultValue=?defaultNoticeEndAt
            minDate={noticeDateFrom->Option.getWithDefault("")}
            disabled={getDisabled(noticeEndAtDisabled)}
          />
        </div>
      </div>
      // 썸네일
      <ThumbnailUploadInput
        name={Form.formName.thumbnail}
        disabled={getDisabled(thumbnailDisabled)}
        defaultValue=?{defaultThumbnail}
      />
      // 판매자료 URL
      <div className=%twc("flex flex-col gap-2")>
        <label className=%twc("block font-bold")> {`판매자료 URL`->React.string} </label>
        <input
          defaultValue={defaultSalesDocument->Option.getWithDefault("")}
          id=documentURL.name
          name=documentURL.name
          className=%twc(
            "py-2 px-3 h-9 border-border-default-L1 border rounded-lg focus:outline-none min-w-1/2 max-w-2xl"
          )
          onChange=documentURL.onChange
          onBlur=documentURL.onBlur
          ref=documentURL.ref
          disabled={getDisabled(documentURLDisabled)}
        />
      </div>
      // 상세설명(에디터)
      <div className=%twc("flex flex-col gap-2")>
        <div className=%twc("flex gap-2")>
          <div>
            <span className=%twc("font-bold")> {`상품설명`->React.string} </span>
            <span className=%twc("text-red-500")> {`*`->React.string} </span>
          </div>
          <ErrorMessage
            errors
            name={Form.formName.editor}
            render={_ =>
              <span className=%twc("flex")>
                <IconError width="20" height="20" />
                <span className=%twc("text-sm text-notice ml-1")>
                  {`상품설명을 추가해주세요.`->React.string}
                </span>
              </span>}
          />
        </div>
        <div>
          <Product_Detail_Editor
            control
            name={Form.formName.editor}
            defaultValue={defaultDescription->Option.getWithDefault("")}
            disabled={getDisabled(discriptionDisabled)}
          />
        </div>
      </div>
    </div>
  </div>
}
