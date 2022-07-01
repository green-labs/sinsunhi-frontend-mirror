module Complete = {
  @react.component
  let make = () => {
    let router = Next.Router.useRouter()

    React.useEffect0(_ => {
      DataGtm.push({"event": "Expose_view_RFQ_Livestock_RequestCompleted"})
      None
    })

    <div className=%twc("relative container max-w-3xl mx-auto min-h-screen sm:shadow-gl pt-11")>
      <DS_TopNavigation.Detail.Root>
        <DS_TopNavigation.Detail.Left>
          <a className=%twc("cursor-pointer") onClick={_ => router->Next.Router.push("/buyer/rfq")}>
            <DS_Icon.Common.ArrowLeftXLarge1 height="32" width="32" className=%twc("relative") />
          </a>
        </DS_TopNavigation.Detail.Left>
      </DS_TopNavigation.Detail.Root>
      <div className=%twc("px-5")>
        <div className=%twc("pt-7 text-[26px] font-bold leading-[38px]")>
          <DS_Badge.Medium text=`요청서를 보냈어요!` colorType=#secondary />
          <h1 className=%twc("mt-2")> {`24시간 안으로 견적서를`->React.string} </h1>
          <h1> {`보내드립니다`->React.string} </h1>
          <h3 className=%twc("text-base text-text-L3 font-normal")>
            {`카카오톡에서 확인하실 수 있어요`->React.string}
          </h3>
        </div>
      </div>
      <DS_ButtonContainer.Floating1
        label={`카카오톡으로 확인하기`}
        buttonType=#white
        // Todo - 모바일에서는 카카오톡이 바로 열리는지 체크 필요
        onClick={_ =>
          switch Global.window {
          | Some(window') =>
            Global.Window.openLink(window', ~url=Env.kakaotalkChannel, ~windowFeatures="", ())
          | None => ()
          }}
      />
    </div>
  }
}

@react.component
let make = () =>
  <Authorization.Buyer title=j`바이어 견적 요청`> <Complete /> </Authorization.Buyer>
