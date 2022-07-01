external unsafeAsHtmlInputElement: Dom.element => Dom.htmlInputElement = "%identity"

@react.component
let make = (~onSuccess, ~onFailure) => {
  let router = Next.Router.useRouter()
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
    let userId = router.query->Js.Dict.get("farmer-id")
    switch file {
    | Some(file') =>
      UploadFileToS3PresignedUrl.upload(
        ~kind=UploadFileToS3PresignedUrl.Seller,
        ~userId?,
        ~file=file',
        ~onSuccess=onSuccessWithReset(handleResetFile, onSuccess),
        ~onFailure=onFailureWithClose(onFailure),
        (),
      )->ignore
    | None => setShowFileRequired(._ => Dialog.Show)
    }
  }

  <>
    <section className=%twc("flex-1 px-4")>
      <div className=%twc("flex justify-between")>
        <div>
          <h4 className=%twc("font-semibold")> {j`2. 주문서 선택`->React.string} </h4>
          <span className=%twc("block text-gray-400 text-sm")>
            {j`*.xls, xlsx 확장자만 업로드 가능`->React.string}
          </span>
        </div>
        <label
          className=%twc(
            "p-3 text-white text-center font-bold bg-green-gl rounded-xl cursor-pointer focus:outline-none hover:bg-green-gl-dark whitespace-nowrap focus-within:bg-green-gl-dark focus-within:outline-none"
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
    </section>
    <section className=%twc("flex-1 pl-4")>
      <div className=%twc("flex justify-between")>
        <div className=%twc("flex-auto mr-2")>
          <h4 className=%twc("font-semibold")> {j`3. 주문서 업로드`->React.string} </h4>
          <div
            className={switch file {
            | Some(_) => %twc("relative w-full flex items-center mt-1 text-gray-400 text-sm")
            | None => %twc("relative w-full flex items-center mt-1 text-gray-400 text-sm")
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
                className=%twc("absolute p-2 right-0")
                onClick={_ => setShowDelete(._ => Dialog.Show)}>
                <IconCloseInput height="28" width="28" fill="#B2B2B2" />
              </span>
            )
            ->Option.getWithDefault(React.null)}
          </div>
        </div>
        <button
          className={file->Option.isSome
            ? %twc(
                "text-white font-bold p-3 h-12 bg-green-gl rounded-xl focus:outline-none hover:bg-green-gl-dark whitespace-nowrap"
              )
            : %twc(
                "text-white font-bold p-3 h-12 bg-gray-300 rounded-xl focus:outline-none whitespace-normal"
              )}
          onClick={_ => handleUpload()}
          disabled={file->Option.isNone}>
          {j`업로드`->React.string}
        </button>
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
