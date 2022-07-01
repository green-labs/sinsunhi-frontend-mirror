let setHref = path =>
  %external(window)
  ->Option.map(_ => {
    open Webapi
    Dom.location->Dom.Location.setHref(path)
  })
  ->ignore

@react.component
let make = (~path, ~message=?) => {
  React.useEffect0(() => {
    setHref(path)
    None
  })
  <div>
    {switch message {
    | Some(m) => m->React.string
    | None =>
      <div className="container mx-auto flex justify-center items-center h-screen">
        {`페이지 전환 중 입니다.`->React.string}
      </div>
    }}
  </div>
}
