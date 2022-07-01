module Layout = {
  @react.component
  let make = (~children=?) =>
    <div className=%twc("pl-5 pr-20 py-10")>
      <strong className=%twc("text-xl")> {j`다운로드 센터`->React.string} </strong>
      {children->Option.getWithDefault(React.null)}
    </div>
}

@react.component
let make = () =>
  <Authorization.Admin title=j`관리자 다운로드 센터`>
    <DownloadCenter_Render> <Layout /> </DownloadCenter_Render>
  </Authorization.Admin>
