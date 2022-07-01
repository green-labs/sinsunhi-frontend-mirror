external unsafeAsHtmlInputElement: Dom.element => Dom.htmlInputElement = "%identity"

@react.component
let make = (~onSuccess, ~onFailure) => {
  let (files, setFiles) = React.Uncurried.useState(_ => None)
  let file = files->Option.flatMap(Garter.Array.first)
  let (isShowDelete, setShowDelete) = React.Uncurried.useState(_ => Dialog.Hide)
  let (isShowRequired, setShowRequired) = React.Uncurried.useState(_ => Dialog.Hide)

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
        ~kind=UploadFileToS3PresignedUrl.Admin,
        ~file=file',
        ~onSuccess=onSuccessWithReset(handleResetFile, onSuccess),
        ~onFailure=onFailureWithClose(onFailure),
        (),
      )->ignore
    | None => setShowRequired(._ => Dialog.Show)
    }
  }

  <>
    <div className=%twc("flex flex-row w-full mt-6 pb-5 border-b border-border-default-L2")>
      <div className=%twc("flex-1")>
        <h3 className=%twc("font-bold")>
          {j`1. 파일선택`->React.string}
          <span className=%twc("text-sm text-text-L2 ml-2 font-normal")>
            {j`*.xls, xlsx 확장자만 업로드 가능`->React.string}
          </span>
        </h3>
        <div
          className=%twc(
            "flex justify-between items-center mt-2 pr-6 border-r border-border-default-L1"
          )>
          <div
            className={switch file {
            | Some(_) =>
              %twc(
                "relative w-full flex py-2 px-3 items-center rounded-xl border border-gray-200 text-text-L1 h-9"
              )
            | None =>
              %twc(
                "relative w-full flex py-2 px-3 items-center rounded-xl border border-gray-200 text-gray-400 bg-gray-100 h-9"
              )
            }}>
            <span className=%twc("text-sm")>
              {file
              ->Option.map(file' => file'->Webapi.File.name)
              ->Option.getWithDefault(`파일명.xlsx`)
              ->React.string}
            </span>
            {file
            ->Option.map(_ =>
              <span
                className=%twc("absolute p-2 right-0")
                onClick={_ => setShowDelete(._ => Dialog.Show)}>
                <IconCloseInput height="28" width="28" fill="#B2B2B2" />
              </span>
            )
            ->Option.getWithDefault(React.null)}
          </div>
          <label
            className=%twc(
              "ml-2 py-2 px-3 h-9 text-sm text-center whitespace-nowrap bg-gray-200 text-text-L1 rounded-lg cursor-pointer focus:outline-none focus-within:bg-primary focus-within:text-white focus-within:outline-none"
            )>
            <span> {j`파일선택`->React.string} </span>
            <input
              id="input-file"
              type_="file"
              accept=`.xls,.xlsx`
              className=%twc("sr-only")
              onChange=handleOnChangeFiles
            />
          </label>
        </div>
      </div>
      <div className=%twc("flex-1 ml-6")>
        <h3 className=%twc("font-bold")> {j`2. 업로드`->React.string} </h3>
        <button
          className={file->Option.isSome
            ? %twc("py-2 px-4 mt-2 text-sm h-9 text-white bg-primary rounded-lg")
            : %twc(
                "py-2 px-4 mt-2 text-sm h-9 text-disabled-L3 bg-gray-300 rounded-lg focus:outline-none"
              )}
          disabled={file->Option.isNone}
          onClick={_ => handleUpload()}>
          {j`업로드`->React.string}
        </button>
      </div>
    </div>
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
    <Dialog isShow=isShowRequired onConfirm={_ => setShowRequired(._ => Dialog.Hide)}>
      <p className=%twc("text-gray-500 text-center whitespace-pre-wrap")>
        {`파일을 선택해주세요.`->React.string}
      </p>
    </Dialog>
  </>
}
