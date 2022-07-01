/*
 *
 * 마케팅팀 요청 Paperform 폼 삽입을 위한 바인딩
 * https://paperform.co/
 *
 */

@react.component
let make = (~paperFormId: string, ~prefill: option<string>) => {
  let attrs = {
    "id": paperFormId,
    "data-paperform-id": paperFormId,
    "className": %twc("hidden"),
    "prefill": prefill,
    "data-popup-button": "1",
    "spinner": "1",
  }

  React.useEffect0(_ => {
    open Webapi
    let script = Dom.document->Dom.Document.createElement("script")->Dom.Element.asHtmlElement
    let btn =
      Dom.document
      ->Dom.Document.getElementById(paperFormId)
      ->Option.flatMap(Dom.Element.asHtmlElement)
    let body = Dom.document->Dom.Document.asHtmlDocument->Option.flatMap(Dom.HtmlDocument.body)

    switch (body, script, btn) {
    | (Some(body'), Some(script'), Some(btn')) => {
        script'->Dom.HtmlElement.setAttribute("src", Env.paperformEmbedUrl)
        script'->Dom.HtmlElement.addLoadEventListener(_ => btn'->Dom.HtmlElement.click)
        body'->Dom.Element.appendChild(~child=script')
      }

    | _ => ()
    }
    None
  })

  <ReactUtil.SpreadProps props={attrs}> <button /> </ReactUtil.SpreadProps>
}
