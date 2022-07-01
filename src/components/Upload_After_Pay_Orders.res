external unsafeAsHtmlInputElement: Dom.element => Dom.htmlInputElement = "%identity"

@react.component
let make = (~onSuccess, ~onFailure, ~startIndex) => {
  let agreements = CustomHooks.AfterPayAgreement.use()
  let canUpload = switch agreements {
  | Loaded({terms: []})
  | Loading
  | NotRegistered
  | Error(_) => false
  | Loaded(_) => true
  }

  let (files, setFiles) = React.Uncurried.useState(_ => None)
  let file = files->Option.flatMap(Garter.Array.first)
  let (isShowDelete, setShowDelete) = React.Uncurried.useState(_ => Dialog.Hide)
  let (didAgree, setAgree) = React.Uncurried.useState(_ => false)

  let (isShowFileRequired, setShowFileRequired) = React.Uncurried.useState(_ => Dialog.Hide)

  let handleOnChangeFiles = e => {
    let values = (e->ReactEvent.Synthetic.target)["files"]
    setFiles(._ => Some(values))
  }

  let handleResetFile = () => {
    open Webapi
    let inputFile = Dom.document->Dom.Document.getElementById("input-file")
    inputFile
    ->Option.map(inputFile' => {
      inputFile'->unsafeAsHtmlInputElement->Dom.HtmlInputElement.setValue("")
    })
    ->ignore
    setFiles(._ => None)
  }

  let handleDeleteFiles = () => {
    handleResetFile()
    setShowDelete(._ => Dialog.Hide)
  }

  let onSuccessWithReset = (resetFn, successFn, _) => {
    resetFn()
    successFn()
  }

  let onFailureWithClose = (failureFn, _) => {
    failureFn()
  }

  let handleUpload = () => {
    switch file {
    | Some(file') =>
      UploadFileToS3PresignedUrl.upload(
        ~kind=UploadFileToS3PresignedUrl.AfterPay,
        ~file=file',
        ~onSuccess=onSuccessWithReset(handleResetFile, onSuccess),
        ~onFailure=onFailureWithClose(onFailure),
        (),
      )->ignore
    | None => setShowFileRequired(._ => Dialog.Show)
    }
  }

  <>
    <section className=%twc("py-5")>
      <h3 className=%twc("font-bold text-lg w-full sm:w-9/12 pt-5 pb-1")>
        {j`나중결제로 주문할 주문서를 업로드해주세요`->React.string}
      </h3>
      <div className=%twc("text-sm text-gray-600 pb-10")>
        {`*나중결제 가능 금액 이하로 주문서 총 발주금액을 조정해주세요`->React.string}
        <br />
        {`*초과시, 주문 실패`->React.string}
      </div>
      <div className=%twc("flex justify-between")>
        <h4 className=%twc("font-semibold")>
          {j`${startIndex->Int.toString}. 주문서 선택`->React.string}
          <span className=%twc("block text-gray-400 text-sm")>
            {j`*.xls, xlsx 확장자만 업로드 가능`->React.string}
          </span>
        </h4>
        <label
          className={%twc(
            "p-3 w-28 text-white text-center whitespace-nowrap font-bold rounded-xl cursor-pointer focus:outline-none focus-within:bg-green-gl-dark focus-within:outline-none"
          ) ++ {
            canUpload ? %twc(" bg-green-gl hover:bg-green-gl-dark") : %twc(" bg-gray-300")
          }}>
          <span> {j`파일 선택`->React.string} </span>
          <input
            id="input-file"
            type_="file"
            accept=`.xls,.xlsx`
            className={%twc("sr-only")}
            disabled={!canUpload}
            onChange=handleOnChangeFiles
          />
        </label>
      </div>
      <div
        className={switch file {
        | Some(_) =>
          %twc(
            "p-3 relative w-full flex items-center rounded-xl mt-4 border border-gray-200 text-gray-400"
          )
        | None =>
          %twc(
            "p-3 relative w-full flex items-center rounded-xl mt-4 border border-gray-200 text-gray-400 bg-gray-100"
          )
        }}>
        <span>
          {file
          ->Option.map(file' => file'->Webapi.File.name)
          ->Option.getWithDefault(`파일명.xlsx`)
          ->React.string}
        </span>
        {file
        ->Option.map(_ =>
          <span
            className=%twc("absolute p-2 right-0") onClick={_ => setShowDelete(._ => Dialog.Show)}>
            <IconCloseInput height="28" width="28" fill="#B2B2B2" />
          </span>
        )
        ->Option.getWithDefault(React.null)}
      </div>
    </section>
    <section className=%twc("py-5")>
      <div className=%twc("flex justify-between items-center")>
        <div className=%twc("flex flex-col gap-3")>
          <h4 className=%twc("font-semibold")>
            {j`${(startIndex + 1)
                ->Int.toString}. 이용 동의 후 주문서 업로드`->React.string}
          </h4>
          <div className=%twc("flex items-center gap-1")>
            <div className=%twc("mr-1")>
              <Checkbox
                id={`checkbox-upload-agreement`}
                checked=didAgree
                disabled={!canUpload}
                onChange={_ => setAgree(.prev => !prev)}
              />
            </div>
            <label htmlFor={`checkbox-upload-agreement`} className=%twc("text-sm text-gray-800")>
              {`나중결제 이용약관을 확인했어요`->React.string}
            </label>
            <a
              href="https://afterpay-terms.oopy.io/695e9bce-bc97-40d8-8f2a-c88b4611e057"
              className=%twc("text-sm text-gray-500 underline")>
              {`약관보기`->React.string}
            </a>
          </div>
        </div>
        <div>
          {
            let disabled = !(didAgree && file->Option.isSome)
            <ReactUtil.SpreadProps props={"data-gtm": `btn-after-pay-xlsx-upload`}>
              <button
                className={%twc(
                  "ml-auto text-white font-bold p-3 w-28 rounded-xl focus:outline-none "
                ) ++
                %twc("bg-green-gl  hover:bg-green-gl-dark disabled:bg-gray-300")}
                onClick={_ => handleUpload()}
                disabled>
                {j`업로드`->React.string}
              </button>
            </ReactUtil.SpreadProps>
          }
        </div>
      </div>
    </section>
    // 다이얼로그
    <Dialog isShow=isShowFileRequired onConfirm={_ => setShowFileRequired(._ => Dialog.Hide)}>
      <p className=%twc("text-gray-500 text-center whitespace-pre-wrap")>
        {`파일을 선택해주세요.`->React.string}
      </p>
    </Dialog>
    <Dialog
      isShow=isShowDelete
      onConfirm={_ => handleDeleteFiles()}
      textOnConfirm=`삭제`
      onCancel={_ => setShowDelete(._ => Dialog.Hide)}
      textOnCancel=`닫기`>
      <p className=%twc("text-gray-500 text-center whitespace-pre-wrap")>
        {`파일을 삭제하시겠어요?`->React.string}
      </p>
    </Dialog>
  </>
}
