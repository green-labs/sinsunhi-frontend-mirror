/*
 *
 * 마케팅팀 요청 Paperform 폼 삽입을 위한 바인딩
 * https://paperform.co/
 *
 */

let modifyPaperformZIndex = () => {
  // 페이퍼폼 z index 조정
  open Webapi
  switch Dom.document->Dom.Document.querySelector(".Paperform__popupwrapper") {
  | None => ()
  | Some(element) => element->Dom.Element.setAttribute("style", "z-index: 20;")
  }
}

let removeBodyScrollLock = () => {
  // 브레이즈가 <body>에 심은 blockScroll ab-pause-scrolling 제거
  open Webapi
  switch Dom.document->Dom.Document.querySelector("body") {
  | None => ()
  | Some(body) => {
      let bodyClassList = body->Dom.Element.classList
      bodyClassList->Dom.DomTokenList.remove("blockScroll")
      bodyClassList->Dom.DomTokenList.remove("ab-pause-scrolling")
    }
  }
}

let makeScriptTag = () => {
  open Webapi
  Dom.document->Dom.Document.createElement("script")->Dom.Element.asHtmlElement
}

let getPaperformBtn = paperFormId => {
  open Webapi
  Dom.document->Dom.Document.getElementById(paperFormId)->Option.flatMap(Dom.Element.asHtmlElement)
}

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
    let script = makeScriptTag()
    let paperformBtn = paperFormId->getPaperformBtn
    let body = Dom.document->Dom.Document.asHtmlDocument->Option.flatMap(Dom.HtmlDocument.body)

    switch (body, script, paperformBtn) {
    | (Some(body'), Some(script'), Some(paperformBtn')) => {
        script'->Dom.HtmlElement.setAttribute("src", Env.paperformEmbedUrl)
        script'->Dom.HtmlElement.addLoadEventListener(_ => {
          // 코드 내에서 발생시킨 click으로 paperform 팝업이 트리거 됨
          // 다 그려진 다음에 z index를 끌어내리기 위해 timeout: 500ms 정도의 버퍼를 두었음.
          // (toImprove: onLoad리스너를 이용한다?)
          paperformBtn'->Dom.HtmlElement.click
          Js.Global.setTimeout(() => {
            modifyPaperformZIndex()
            removeBodyScrollLock()
          }, 500)->ignore
        })
        body'->Dom.Element.appendChild(~child=script')
      }

    | _ => ()
    }
    None
  })

  <ReactUtil.SpreadProps props={attrs}> <button /> </ReactUtil.SpreadProps>
}
