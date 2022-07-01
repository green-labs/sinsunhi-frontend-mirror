module UploadFile = Upload_Orders

module UserDeposit = {
  @react.component
  let make = () => {
    let router = Next.Router.useRouter()
    let status = CustomHooks.UserDeposit.use(
      router.query->Webapi.Url.URLSearchParams.makeWithDict->Webapi.Url.URLSearchParams.toString,
    )

    <div className=%twc("container max-w-lg mx-auto px-5 sm:p-7 sm:shadow-gl")>
      <Next.Link href="/buyer/transactions" passHref=true>
        <a
          className=%twc(
            "w-full h-auto flex items-center p-5 sm:p-0 shadow-gl sm:shadow-none rounded-lg"
          )>
          <div>
            <span className=%twc("block text-sm")>
              {j`총 주문 가능 금액`->React.string}
            </span>
            <span className=%twc("block text-primary text-lg font-bold")>
              {switch status {
              | Error(error) =>
                error->Js.Console.log
                <Skeleton.Box className=%twc("w-40") />
              | Loading => <Skeleton.Box className=%twc("w-40") />
              | Loaded(deposit) =>
                switch deposit->CustomHooks.UserDeposit.response_decode {
                | Ok(deposit') =>
                  `${deposit'.data.deposit->Locale.Float.show(~digits=0)}원`->React.string
                | Error(_) => <Skeleton.Box className=%twc("w-40") />
                }
              }}
            </span>
          </div>
          <IconArrow height="24" width="24" fill="#262626" className="ml-auto" />
        </a>
      </Next.Link>
    </div>
  }
}

module Tab = {
  module Selected = {
    @react.component
    let make = (~children) =>
      <div className=%twc("pb-4 border-b border-gray-800 h-full")> children </div>
  }

  module Unselected = {
    @react.component
    let make = (~href, ~children) =>
      <div className=%twc("pb-4 text-gray-600")> <Next.Link href> children </Next.Link> </div>
  }

  module Container = {
    @react.component
    let make = (~children) =>
      <div
        className=%twc(
          "container max-w-lg mx-auto p-7 pb-0 sm:shadow-gl sm:mt-4 border-b flex gap-5 text-lg font-bold"
        )>
        children
      </div>
  }

  module Prepaid = {
    @react.component
    let make = () => {
      let buyer = CustomHooks.AfterPayCredit.use()

      switch buyer {
      | Loaded({credit: {isAfterPayEnabled: true}}) =>
        <Container>
          <Selected> {`선결제 주문`->React.string} </Selected>
          <Unselected href="/buyer/after-pay/upload">
            {`나중결제 주문`->React.string}
          </Unselected>
        </Container>
      | _ => React.null
      }
    }
  }

  module AfterPay = {
    @react.component
    let make = () =>
      <Container>
        <Unselected href="/buyer/upload"> {`선결제 주문`->React.string} </Unselected>
        <Selected> {`나중결제 주문`->React.string} </Selected>
      </Container>
  }
}

@react.component
let make = () => {
  let router = Next.Router.useRouter()
  let {mutate} = Swr.useSwrConfig()

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

  <Authorization.Buyer title=j`주문서 업로드`>
    <Tab.Prepaid />
    <UserDeposit />
    <div
      className=%twc("max-w-lg mt-4 mx-5 sm:mx-auto sm:shadow-gl rounded-lg border border-red-150")>
      <div className=%twc("py-4 px-5 bg-red-gl rounded-lg text-red-500")>
        <span className=%twc("block font-bold")> {j`[필독사항]`->React.string} </span>
        <div className=%twc("flex gap-1.5")>
          <span> {`1.`->React.string} </span>
          <div>
            {j`가이드를 참고하여 주문서를 작성해주셔야 합니다.`->React.string}
            <a id="link-of-upload-guide" href=Env.buyerUploadGuideUri target="_blank">
              <p className=%twc("inline mx-1 min-w-max cursor-pointer hover:underline")>
                {`[가이드]`->React.string}
              </p>
            </a>
            <span className=%twc("block sm:whitespace-pre-wrap")>
              {`잘못 작성된 주문서를 등록하시면 주문이 실패됩니다.\n※ 현금영수증 관련 내용(P열~Q열)이 자주 누락됩니다.\n꼭 확인해 주세요!`->React.string}
            </span>
          </div>
        </div>
        <div className=%twc("flex gap-1")>
          <span> {`2.`->React.string} </span>
          <div>
            <span className=%twc("sm:whitespace-pre-wrap")>
              {`먼저 주문가능금액(신선캐시) 충전이 필요합니다.\n주문가능금액이 발주할 총 금액보다 많아야 하니 부족할 경우\n`->React.string}
            </span>
            <a id="link-of-upload-guide" href="/buyer/transactions" target="_blank">
              <p className=%twc("inline mr-0.5 min-w-max cursor-pointer hover:underline")>
                {`[결제내역]`->React.string}
              </p>
            </a>
            {j`탭에서 신선캐시를 충전해주세요.`->React.string}
          </div>
        </div>
      </div>
    </div>
    <div className=%twc("container max-w-lg mx-auto p-7 sm:shadow-gl sm:mt-4")>
      <h3 className=%twc("font-bold text-lg w-full sm:w-9/12")>
        {j`주문서 양식에 맞는 주문서를 선택하신 후 업로드를 진행해보세요.`->React.string}
      </h3>
      <div className=%twc("divide-y")>
        <UploadFile
          onSuccess={_ => {
            setShowSuccess(._ => Dialog.Show)
            mutate(.
              ~url=`${Env.restApiUrl}/order/recent-uploads?upload-type=order&pay-type=PAID`,
              ~data=None,
              ~revalidation=None,
            )
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
    <div id="upload-status" className=%twc("container max-w-lg mx-auto p-7 sm:shadow-gl sm:mt-4")>
      <section className=%twc("py-5")>
        <h4 className=%twc("font-semibold")> {j`주문서 업로드 결과`->React.string} </h4>
        <p className=%twc("mt-1 text-gray-400 text-sm")>
          {j`*가장 최근 요청한 3가지 등록건만 노출됩니다.`->React.string}
        </p>
      </section>
      <UploadStatus_Buyer
        kind=CustomHooks.UploadStatus.Buyer
        uploadType=CustomHooks.UploadStatus.Order
        onChangeLatestUpload={_ =>
          mutate(.
            ~url=`${Env.restApiUrl}/user/deposit?${router.query
              ->Webapi.Url.URLSearchParams.makeWithDict
              ->Webapi.Url.URLSearchParams.toString}`,
            ~data=None,
            ~revalidation=Some(true),
          )}
      />
      <p className=%twc("mt-5 text-sm text-gray-400")>
        {j`주의: 주문서 업로드가 완료되기 전까지 일부 기능을 사용하실 수 없습니다. 주문서에 기재하신 내용에 따라 정상적으로 처리되지 않을 수 있습니다. 처리 결과를 반드시 확인해 주시기 바랍니다. 주문서 업로드는 상황에 따라 5분까지 소요될 수 있습니다.`->React.string}
      </p>
    </div>
    <Guide_Upload_Buyer />
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
  </Authorization.Buyer>
}
