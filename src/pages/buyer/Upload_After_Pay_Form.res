module UploadForm = {
  @react.component
  let make = () => {
    let {mutate} = Swr.useSwrConfig()

    let user = CustomHooks.User.Buyer.use()
    let userId = switch user {
    | LoggedIn({id}) => Some(id)
    | NotLoggedIn
    | Unknown =>
      None
    }

    let (isShowSuccess, setShowSuccess) = React.Uncurried.useState(_ => Dialog.Hide)
    let (isShowError, setShowError) = React.Uncurried.useState(_ => Dialog.Hide)

    let scrollIntoView = target => {
      open Webapi
      let el = Dom.document->Dom.Document.getElementById(target)
      el->Option.mapWithDefault((), el' =>
        el'->Dom.Element.scrollIntoViewWithOptions({"behavior": "smooth", "block": "start"})
      )
    }

    ChannelTalkHelper.Hook.use()

    <>
      <div className=%twc("container max-w-lg mx-auto p-7 pt-0 sm:shadow-gl")>
        <div className=%twc("divide-y")>
          <div />
          <Upload_After_Pay_Orders
            onSuccess={_ => {
              setShowSuccess(._ => Dialog.Show)
              userId->Belt.Option.forEach(userId' => {
                mutate(.
                  ~url=`${Env.afterPayApiUrl}/buyers/${userId'->Js.Int.toString}/credit`,
                  ~data=None,
                  ~revalidation=None,
                )
              })

              scrollIntoView("upload-status")
            }}
            onFailure={_ => setShowError(._ => Dialog.Show)}
            startIndex=1
          />
          <section className=%twc("py-5")>
            <div className=%twc("flex justify-between")>
              <h4 className=%twc("font-semibold")>
                {j`주문서 양식`->React.string}
                <span className=%twc("block text-gray-400 text-sm")>
                  {j`*이 양식으로 작성된 주문서만 업로드 가능`->React.string}
                </span>
              </h4>
              <a href=Env.buyerOrderExcelFormUri>
                <span
                  className=%twc(
                    "inline-block text-center text-green-gl font-bold py-2 w-28 border border-green-gl rounded-xl focus:outline-none hover:text-green-gl-dark hover:border-green-gl-dark"
                  )>
                  {j`양식 다운로드`->React.string}
                </span>
              </a>
            </div>
          </section>
        </div>
      </div>
      // 다이얼로그
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
  }
}

module UploadResult = {
  @react.component
  let make = () => {
    let {mutate} = Swr.useSwrConfig()
    let creditUrl = CustomHooks.AfterPayCredit.useGetUrl()

    <div id="upload-status" className=%twc("container max-w-lg mx-auto p-7 sm:shadow-gl sm:mt-4")>
      <section className=%twc("py-5")>
        <h4 className=%twc("font-semibold")> {j`주문서 업로드 결과`->React.string} </h4>
        <p className=%twc("mt-1 text-gray-400 text-sm")>
          {j`*가장 최근 요청한 3가지 등록건만 노출됩니다.`->React.string}
        </p>
      </section>
      <UploadStatus_Buyer
        kind=CustomHooks.UploadStatus.Buyer
        uploadType=CustomHooks.UploadStatus.OrderAfterPay
        onChangeLatestUpload={_ =>
          creditUrl->Belt.Option.forEach(url =>
            mutate(. ~url, ~data=None, ~revalidation=Some(true))
          )}
      />
      <p className=%twc("mt-5 text-sm text-gray-400")>
        {j`주의: 송장번호 일괄 업로드가 완료되기 전까지 일부 기능을 사용하실 수 없습니다. 업로드하신 엑셀 내용에 따라 정상적으로 처리되지 않는 경우가 있을 수 있습니다. 처리결과를 반드시 확인해 주시기 바랍니다. 주문서 업로드는 상황에 따라 5분까지 소요될 수 있습니다. 처리 결과를 필히 확인해주시기 바랍니다`->React.string}
      </p>
    </div>
  }
}
