external unsafeAsHtmlInputElement: Dom.element => Dom.htmlInputElement = "%identity"

@react.component
let make = (~userId, ~onSuccess, ~onFailure) => {
  let (files, setFiles) = React.Uncurried.useState(_ => None)
  let file = files->Option.flatMap(Garter.Array.first)
  let (isShowDelete, setShowDelete) = React.Uncurried.useState(_ => Dialog.Hide)
  let (isShowRequired, setShowRequired) = React.Uncurried.useState(_ => Dialog.Hide)
  let (isShowUserRequired, setShowUserRequired) = React.Uncurried.useState(_ => Dialog.Hide)
  let (isShowFileRequired, setShowFileRequired) = React.Uncurried.useState(_ => Dialog.Hide)

  let isUserSelected = userId->Option.isSome

  let handleOnChangeFiles = e => {
    let values = (e->ReactEvent.Synthetic.target)["files"]
    setFiles(._ => Some(values))
    switch userId {
    | Some(_) => ()
    | None => setShowUserRequired(._ => Dialog.Show)
    }
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
    switch (userId, file) {
    | (Some(userId'), Some(file')) =>
      UploadFileToS3PresignedUrl.upload(
        ~kind=UploadFileToS3PresignedUrl.Buyer,
        ~userId=userId',
        ~file=file',
        ~onSuccess=onSuccessWithReset(handleResetFile, onSuccess),
        ~onFailure=onFailureWithClose(onFailure),
        (),
      )->ignore
    | (None, Some(_)) => setShowFileRequired(._ => Dialog.Show)
    | (Some(_), None) => setShowUserRequired(._ => Dialog.Show)
    | (None, None) => setShowRequired(._ => Dialog.Show)
    }
  }

  <>
    <section>
      <div className=%twc("flex justify-between")>
        <div>
          <h3 className=%twc("text-lg font-bold")> {j`2. 주문서 선택`->React.string} </h3>
          <span className=%twc("block text-gray-400 text-sm")>
            {j`*.xls, xlsx 확장자만 업로드 가능`->React.string}
          </span>
        </div>
        <label
          className={isUserSelected
            ? %twc(
                "p-3 w-28 text-white text-center font-bold bg-green-gl rounded-xl cursor-pointer focus:outline-none hover:bg-green-gl-dark whitespace-nowrap focus-within:bg-green-gl-dark focus-within:outline-none"
              )
            : %twc(
                "p-3 w-28 text-white text-center font-bold bg-gray-300 rounded-xl focus:outline-none whitespace-nowrap"
              )}>
          <span> {j`파일 선택`->React.string} </span>
          <input
            id="input-file"
            type_="file"
            accept=`.xls,.xlsx`
            className=%twc("sr-only")
            onChange=handleOnChangeFiles
            disabled={!isUserSelected}
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
    <section className=%twc("mt-10")>
      <div className=%twc("flex justify-between items-center")>
        <div className=%twc("flex-1 flex justify-between")>
          <h3 className=%twc("font-bold text-lg")> {j`3. 주문서 업로드`->React.string} </h3>
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
    <Dialog isShow=isShowRequired onConfirm={_ => setShowRequired(._ => Dialog.Hide)}>
      <p className=%twc("text-gray-500 text-center whitespace-pre-wrap")>
        {`바이어와 파일을 먼저 선택해주세요.`->React.string}
      </p>
    </Dialog>
    <Dialog isShow=isShowUserRequired onConfirm={_ => setShowUserRequired(._ => Dialog.Hide)}>
      <p className=%twc("text-gray-500 text-center whitespace-pre-wrap")>
        {`바이어를 먼저 선택해주세요.`->React.string}
      </p>
    </Dialog>
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
