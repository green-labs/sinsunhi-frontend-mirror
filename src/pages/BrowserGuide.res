@val @scope("window")
external jsAlert: string => unit = "alert"

@react.component
let make = () => {
  React.useEffect0(_ => {
    Clipboard.init(".btn-link")
    None
  })

  let showAlertCopyToClipboard = _ => {
    %external(window)
    ->Option.map(_ => {
      jsAlert(`클립보드에 복사되었습니다.`)
    })
    ->ignore
  }

  let locationOrigin =
    %external(window)->Option.mapWithDefault(Env.originProd, _ =>
      Webapi.Dom.location |> Webapi.Dom.Location.origin
    )

  <>
    <Next.Head>
      <title> {j`IE 접속 가이드 - 신선하이`->React.string} </title>
    </Next.Head>
    <div className=%twc("flex flex-col h-screen justify-center items-center text-black-gl")>
      <img src="/assets/sinsunhi-logo.svg" width="164" height="42" alt=`신선하이 로고` />
      <div className=%twc("text-center text-lg whitespace-pre font-bold mt-14")>
        {j`지금 사용중인 브라우저에서는 
신선하이를 이용하실 수 없습니다.`->React.string}
      </div>
      <div className=%twc("text-center whitespace-pre mt-5 text-gray-400")>
        {j`안전한 업로드 환경 지원을 위한 조치로 많은 양해 부탁드립니다.
Chrome 브라우저에서 쾌적하게 작동합니다.`->React.string}
      </div>
      <a href=Env.downloadChromeUrl target="_blank">
        <div
          className=%twc(
            "flex justify-center items-center py-3 w-80 border border-gray-200 rounded-xl font-bold mt-14"
          )>
          <IconChrome height="24" width="24" fill="none" />
          <span className=%twc("ml-1")> {j`크롬 다운로드`->React.string} </span>
        </div>
      </a>
      <div className=%twc("flex mt-8 w-80 text-gray-600")>
        <ReactUtil.SpreadProps props={"data-clipboard-text": j`${locationOrigin}/buyer/signin`}>
          <div className="flex-1 btn-link" onClick=showAlertCopyToClipboard>
            <div
              className=%twc("flex justify-center items-center py-3 bg-gray-100 rounded-xl mr-2")>
              {j`바이어 마켓 주소 복사`->React.string}
            </div>
          </div>
        </ReactUtil.SpreadProps>
        <ReactUtil.SpreadProps props={"data-clipboard-text": j`${locationOrigin}/seller/signin`}>
          <div className="flex-1 btn-link" onClick=showAlertCopyToClipboard>
            <div
              className=%twc("flex-1 flex justify-center items-center py-3 bg-gray-100 rounded-xl")>
              {j`생산자 마켓 주소 복사`->React.string}
            </div>
          </div>
        </ReactUtil.SpreadProps>
      </div>
    </div>
  </>
}
