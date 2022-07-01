external unsafeAsHtmlInputElement: Dom.element => Dom.htmlInputElement = "%identity"

@react.component
let make = (~onSuccess, ~onFailure) => {
  let (files, setFiles) = React.Uncurried.useState(_ => None)
  let file = files->Option.flatMap(Garter.Array.first)
  let (isShowDelete, setShowDelete) = React.Uncurried.useState(_ => Dialog.Hide)
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
        ~kind=UploadFileToS3PresignedUrl.Seller,
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
      <div className=%twc("flex justify-between")>
        <h4 className=%twc("font-semibold")>
          {j`2. 송장번호 엑셀 파일 선택 `->React.string}
          <span className=%twc("block text-gray-400 text-sm")>
            {j`*.xls, xlsx 확장자만 업로드 가능`->React.string}
          </span>
        </h4>
        <label
          className=%twc(
            "p-3 w-28 text-white font-bold text-center whitespace-nowrap bg-green-gl rounded-xl cursor-pointer focus:outline-none hover:bg-green-gl-dark focus-within:bg-green-gl-dark focus-within:outline-none"
          )>
          <span> {j`파일 선택`->React.string} </span>
          <input
            id="input-file"
            type_="file"
            accept=`.xls,.xlsx`
            className=%twc("sr-only")
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
        <div className=%twc("flex-1 flex justify-between")>
          <h4 className=%twc("font-semibold")>
            {j`3. 송장번호 파일 업로드`->React.string}
          </h4>
          <button
            className={file->Option.isSome
              ? %twc(
                  "text-white font-bold p-3 w-28 bg-green-gl rounded-xl focus:outline-none hover:bg-green-gl-dark"
                )
              : %twc("text-white font-bold p-3 w-28 bg-gray-300 rounded-xl focus:outline-none")}
            onClick={_ => handleUpload()}
            disabled={file->Option.isNone}>
            {j`업로드`->React.string}
          </button>
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
