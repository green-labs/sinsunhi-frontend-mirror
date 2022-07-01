@react.component
let make = (~userType: CustomHooks.Auth.role, ~requestUrl, ~buttonText=?, ~bodyOption=?) => {
  let router = Next.Router.useRouter()
  let {addToast} = ReactToastNotifications.useToasts()
  let (isShowRequest, setIsShowRequest) = React.Uncurried.useState(_ => Dialog.Hide)
  let (isShowMoveToDownloadCenter, setIsShowMoveToDownloadCenter) = React.Uncurried.useState(_ =>
    Dialog.Hide
  )
  let (errorMessageDownload, setErrorMessageDownload) = React.Uncurried.useState(_ => None)
  let (isShowDownloadError, setShowDownloadError) = React.Uncurried.useState(_ => Dialog.Hide)

  let downloadCenterPath = switch userType {
  | Admin => "/admin/download-center"
  | Buyer => "/buyer/download-center"
  | Seller => "/seller/download-center"
  }

  let menuLocation = switch userType {
  | Buyer | Seller => j`우측 상단`
  | Admin => j`좌측`
  }

  let download = () => {
    bodyOption ->
    Option.getWithDefault(router.query)
    ->Js.Json.stringifyAny
    ->Option.map(body => {
      FetchHelper.requestWithRetry(
        ~fetcher=FetchHelper.postWithTokenForExcel,
        ~url=`${Env.restApiUrl}${requestUrl}`,
        ~body,
        ~count=3,
        ~onSuccess={
          _ => {
            setIsShowMoveToDownloadCenter(._ => Dialog.Show)
          }
        },
        ~onFailure={
          err => {
            let customError = err->FetchHelper.convertFromJsPromiseError
            setErrorMessageDownload(._ => customError.message)
            setShowDownloadError(._ => Dialog.Show)
          }
        },
      )
    })
    ->ignore
  }
  <>
    <button
      className=%twc("h-9 px-3 text-black-gl bg-gray-button-gl rounded-lg flex items-center min-w-max")
      onClick={_ => setIsShowRequest(._ => Dialog.Show)}>
      <IconDownload height="16" width="16" fill="#121212" className=%twc("relative mr-1") />
      {buttonText -> Option.getWithDefault(j`엑셀 다운로드 요청`)->React.string}
    </button>
    <Dialog
      isShow=isShowRequest
      onConfirm={_ => {
        download()
        setIsShowRequest(._ => Dialog.Hide)
        addToast(.
          <div className=%twc("flex items-center")>
            <IconCheck height="24" width="24" fill="#12B564" className=%twc("mr-2") />
            {j`다운로드 파일 생성을 요청합니다.`->React.string}
          </div>,
          {appearance: "success"},
        )
      }}
      textOnCancel=j`닫기`
      onCancel={_ => setIsShowRequest(._ => Dialog.Hide)}>
      <span className=%twc("flex items-center justify-center w-full py-10")>
        <strong> {j`엑셀 다운로드`->React.string} </strong>
        <span> {j`를 요청하시겠어요?`->React.string} </span>
      </span>
    </Dialog>
    <Dialog
      isShow=isShowMoveToDownloadCenter
      onConfirm={_ => Next.Router.push(router, downloadCenterPath)}
      textOnCancel=j`닫기`
      onCancel={_ => setIsShowMoveToDownloadCenter(._ => Dialog.Hide)}>
      <span className=%twc("flex flex-col items-center justify-center w-full py-5")>
        <span className=%twc("flex")>
          <strong> {j`엑셀 다운로드 요청`->React.string} </strong>
          <span> {j`이 완료되었어요.`->React.string} </span>
        </span>
        <span>
          <strong> {j`다운로드 센터`->React.string} </strong>
          <span> {j`로 이동하시겠어요?`->React.string} </span>
        </span>
        <span className=%twc("mt-10 whitespace-pre-wrap")>
          {j`*다운로드 파일 생성 진행은 ${menuLocation}\n 다운로드 센터에서 확인하실 수 있어요.`->React.string}
        </span>
      </span>
    </Dialog>
    <Dialog isShow=isShowDownloadError onConfirm={_ => setShowDownloadError(._ => Dialog.Hide)}>
      <p className=%twc("text-gray-500 text-center whitespace-pre-wrap")>
        {errorMessageDownload
        ->Option.getWithDefault(`다운로드에 실패하였습니다.\n다시 시도하시기 바랍니다.`)
        ->React.string}
      </p>
    </Dialog>
  </>
}
