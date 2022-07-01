module UploadFile = OfflineOrders_Upload_Admin
module UploadStatus = OfflineOrders_UploadStatus_Admin

@react.component
let make = () => {
  let user = CustomHooks.User.Admin.use()
  let {mutate} = Swr.useSwrConfig()
  let (isShowSuccess, setShowSuccess) = React.Uncurried.useState(_ => Dialog.Hide)
  let (isShowError, setShowError) = React.Uncurried.useState(_ => Dialog.Hide)
  //upload logic 추가

  let handleUploadSuccess = () => {
    setShowSuccess(._ => Dialog.Show)
    mutate(.
      ~url=`${Env.restApiUrl}/offline-orders/recent-uploads?upload-type=order`,
      ~data=None,
      ~revalidation=None,
    )
  }

  <>
    <Next.Head> <title> {j`관리자 오프라인 주문등록`->React.string} </title> </Next.Head>
    {switch user {
    | Unknown => <div> {j`인증 확인 중 입니다.`->React.string} </div>
    | NotLoggedIn => <div> {j`로그인이 필요 합니다.`->React.string} </div>
    | LoggedIn(_) => <>
        <div className=%twc("py-8 px-4 bg-div-shape-L1 min-h-screen")>
          <header className=%twc("md:flex md:items-baseline pb-0")>
            <h1 className=%twc("font-bold text-xl")>
              {j`오프라인 주문서 등록`->React.string}
            </h1>
          </header>
          <div className=%twc("flex flex-col bg-white mt-5 p-7")>
            <h2 className=%twc("font-bold text-lg")>
              {j`주문 업로드`->React.string}
              <span className=%twc("ml-2 text-base text-text-L3 font-normal")>
                <a
                  className=%twc("underline focus:outline-none")
                  href={`${Env.s3PublicUrl}/order/off_order_sample.xlsx`}
                  download="off_order_sample.xlsx">
                  {j`샘플양식 다운로드`->React.string}
                </a>
              </span>
            </h2>
            <UploadFile
              onSuccess={handleUploadSuccess} onFailure={_ => setShowError(._ => Dialog.Hide)}
            />
            <div className=%twc("mt-9")> <UploadStatus /> </div>
          </div>
        </div>
        <Dialog isShow=isShowSuccess onConfirm={_ => setShowSuccess(._ => Dialog.Hide)}>
          <p className=%twc("text-gray-500 text-center whitespace-pre-wrap")>
            {`주문서 업로드가 실행되었습니다. 성공여부를 꼭 주문서 업로드 결과에서 확인해주세요.`->React.string}
          </p>
        </Dialog>
        <Dialog isShow=isShowError onConfirm={_ => setShowError(._ => Dialog.Hide)}>
          <p className=%twc("text-gray-500 text-center whitespace-pre-wrap")>
            {`파일 업로드에 실패하였습니다.`->React.string}
          </p>
        </Dialog>
      </>
    }}
  </>
}
