module Layout = {
  @react.component
  let make = (~children=?) =>
    <div className=%twc("sm:px-20 py-4")>
      {children->Option.getWithDefault(React.null)}
      <footer className=%twc("w-full flex flex-row items-center justify-center py-7 text-text-L3 ")>
        {j`ⓒ Copyright Greenlabs All Reserved. (주)그린랩스`->React.string}
      </footer>
    </div>
}

@react.component
let make = () =>
  <Authorization.Buyer title=j`다운로드 센터`>
    <DownloadCenter_Render> <Layout /> </DownloadCenter_Render>
  </Authorization.Buyer>
