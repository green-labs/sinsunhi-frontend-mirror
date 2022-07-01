module UploadFile = Upload_Deliveries

external unsafeAsFile: Fetch.blob => Webapi.File.t = "%identity"

module Upload = {
  @react.component
  let make = () => {
    let {mutate} = Swr.useSwrConfig()

    let (isShowDownloadError, setShowDownloadError) = React.Uncurried.useState(_ => Dialog.Hide)
    let (isShowNothingToDownload, setShowNothingToDownload) = React.Uncurried.useState(_ =>
      Dialog.Hide
    )
    let (isShowSuccess, setShowSuccess) = React.Uncurried.useState(_ => Dialog.Hide)
    let (isShowError, setShowError) = React.Uncurried.useState(_ => Dialog.Hide)

    ChannelTalkHelper.Hook.use()

    <>
      <div
        className=%twc(
          "container pt-4 sm:pt-0 sm:px-0 max-w-lg mx-auto sm:shadow-gl sm:mt-4 rounded-lg"
        )>
        <div className=%twc("p-5 sm:p-7 md:shadow-gl")>
          <h3 className=%twc("font-bold text-lg")>
            {j`송장번호 일괄등록`->React.string}
          </h3>
          <div className=%twc("divide-y")>
            <section className=%twc("flex justify-between py-5")>
              <h4 className=%twc("font-semibold")>
                {j`1. 상품준비중인 주문 다운로드`->React.string}
              </h4>
              {
                let payload =
                  CustomHooks.Auth.use()
                  ->CustomHooks.Auth.toOption
                  ->Option.map(user' =>
                    {
                      "farmer-id": user'.uid,
                      "status": "PACKING",
                      "from": "20210101",
                      "to": Js.Date.make()->DateFns.format("yyyyMMdd"),
                    }
                  )
                <Excel_Download_Request_Button_Seller
                  userType=Seller requestUrl={`/order/request-excel/farmer`} bodyOption=payload
                />
              }
            </section>
            <UploadFile
              onSuccess={_ => {
                setShowSuccess(._ => Dialog.Show)
                mutate(.
                  ~url=`${Env.restApiUrl}/order/recent-uploads?upload-type=invoice`,
                  ~data=None,
                  ~revalidation=None,
                )
              }}
              onFailure={_ => setShowError(._ => Dialog.Show)}
            />
          </div>
        </div>
        <div className=%twc("p-5 sm:p-7 mt-4 md:shadow-gl")>
          <h4 className=%twc("font-semibold")>
            {j`4. 파일 업로드 결과 확인`->React.string}
          </h4>
          <UploadStatus_Seller kind=CustomHooks.UploadStatus.Seller />
        </div>
        <Guide_Upload_Seller />
      </div>
      <Dialog isShow=isShowDownloadError onConfirm={_ => setShowDownloadError(._ => Dialog.Hide)}>
        <p className=%twc("text-gray-500 text-center whitespace-pre-wrap")>
          {`다운로드에 실패하였습니다.\n다시 시도하시기 바랍니다.`->React.string}
        </p>
      </Dialog>
      <Dialog
        isShow=isShowNothingToDownload
        onCancel={_ => setShowNothingToDownload(._ => Dialog.Hide)}
        textOnCancel=`확인`>
        <p className=%twc("text-gray-500 text-center whitespace-pre-wrap")>
          {`다운로드할 주문이 없습니다.`->React.string}
        </p>
      </Dialog>
      <Dialog isShow=isShowSuccess onConfirm={_ => setShowSuccess(._ => Dialog.Hide)}>
        <p className=%twc("text-gray-500 text-center whitespace-pre-wrap")>
          {`파일 업로드가 시작되었습니다.`->React.string}
        </p>
      </Dialog>
      <Dialog isShow=isShowError onConfirm={_ => setShowError(._ => Dialog.Hide)}>
        <p className=%twc("text-gray-500 text-center whitespace-pre-wrap")>
          {`파일 업로드에 실패하였습니다.`->React.string}
        </p>
      </Dialog>
    </>
  }
}

@react.component
let make = () =>
  <Authorization.Seller title=j`송장번호 대량 등록`> <Upload /> </Authorization.Seller>
