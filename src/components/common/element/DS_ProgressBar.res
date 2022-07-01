module StepGuide = {
  @react.component
  let make = (~step, ~totalStep) => {
    React.useEffect(_ => {
      open Webapi
      let width =
        Dom.document
        ->Dom.Document.getElementById("ds-progress-wrap")
        ->Option.mapWithDefault(0, x => {
          x->Dom.Element.clientWidth
        })

      let _ =
        Dom.document
        ->Dom.Document.getElementById("ds_progress")
        ->Option.map(x =>
          x->Dom.Element.setAttribute(
            "style",
            "width: " ++ (width * step / totalStep)->Js.String2.make ++ "px;",
          )
        )

      None
    })

    <div
      id="ds-progress-wrap"
      className=%twc("fixed top-14 left-1/2 w-full max-w-3xl -translate-x-1/2 h-1")>
      <div className=%twc("relative w-full h-full  bg-surface")>
        <div id="ds_progress" className=%twc("absolute left-0 top-0 bg-primary z-30 h-1") />
      </div>
    </div>
  }
}
