external unsafeAsFile: Webapi.Blob.t => Webapi.File.t = "%identity"

@module("../../public/assets/navi-download.svg")
external naviDownloadIcon: string = "default"

module DownloadTableHead = {
  @react.component
  let make = () =>
    <header>
      <ul
        className=%twc(
          "sm:flex hidden flex-row items-center w-full py-3 px-4 bg-gray-50 rounded mt-4 text-sm text-text-L2"
        )>
        <li className="w-1/5 min-w-[150px]"> {j`요청일시`->React.string} </li>
        <li className=%twc("w-2/5")> {j`파일명`->React.string} </li>
        <li className=%twc("w-2/5")> {j`다운로드`->React.string} </li>
      </ul>
    </header>
}

module DownloadTableRow = {
  @react.component
  let make = (~data: CustomHooks.Downloads.download) => {
    let (isShowDownloadError, setShowDownloadError) = React.Uncurried.useState(_ => Dialog.Hide)
    let (errorMessageDownload, setErrorMessageDownload) = React.Uncurried.useState(_ => None)

    let handleErr = message => {
      setErrorMessageDownload(._ => message)
      setShowDownloadError(._ => Dialog.Show)
    }

    let downloadFtn = (requestId, filename) => {
      FetchHelper.requestWithRetry(
        ~fetcher=FetchHelper.getWithToken,
        ~url=`${Env.restApiUrl}/excel-export/${requestId}/download-url`,
        ~body="",
        ~count=3,
        ~onSuccess={
          res =>
            switch res->CustomHooks.AdminS3PresignedUrl.response_decode {
            | Error(err) => handleErr(Some(err.message))
            | Ok(response) => {
                open Webapi
                let {downloadUrl} = response
                let link = Dom.document->Dom.Document.createElement("a")->Dom.Element.asHtmlElement
                let body =
                  Dom.document->Dom.Document.asHtmlDocument->Option.flatMap(Dom.HtmlDocument.body)
                Helper.Option.map2(link, body, (link', body') => {
                  link'->Dom.HtmlElement.setAttribute("href", downloadUrl)
                  link'->Dom.HtmlElement.setAttribute("download", filename)
                  link'->Dom.HtmlElement.setAttribute("style", "{display: none;}")
                  body'->Dom.Element.appendChild(~child=link')
                  link'->Dom.HtmlElement.click
                  let _ = body'->Dom.Element.removeChild(~child=link')
                })->ignore
              }
            }
        },
        ~onFailure={
          err => {
            let customError = err->FetchHelper.convertFromJsPromiseError
            handleErr(customError.message)
          }
        },
      )->ignore
    }

    let isExpired = expiredAt => {
      let now = Js.Date.now()->Js.Date.fromFloat
      switch expiredAt {
      | Some(time) => time->Js.Date.fromString < now
      | None => false
      }
    }

    let statusSplit = ({id, filename, status, expiredAt}: CustomHooks.Downloads.download) => {
      switch status {
      | REQUEST | PROCESSING =>
        <p className=%twc("text-primary")> {j`생성중...`->React.string} </p>
      | SUCCESS if isExpired(expiredAt) =>
        <p className=%twc("text-text-L2")> {j`기한만료`->React.string} </p>
      | SUCCESS =>
        <p className=%twc("flex flex-row items-center")>
          <span> {`생성완료`->React.string} </span>
          <img
            src=naviDownloadIcon
            className=%twc("ml-5 cursor-pointer")
            onClick={_ => downloadFtn(id->Int.toString, filename)}
          />
        </p>
      | FAIL => <p className=%twc("text-emphasis")> {j`생성오류`->React.string} </p>
      }
    }

    let dateSplit = date =>
      Js.String2.split(date, "T")->(
        s =>
          switch s {
          | [a, b] => Some((a, b))
          | _ => None
          }
      )

    let (date, time) =
      data.requestAt
      ->Js.Date.fromString
      ->DateFns.format("yyyy-MM-dd'T'HH:mm:ss")
      ->dateSplit
      ->Option.getWithDefault(("", ""))

    <>
      <ul
        className=%twc(
          "flex flex-row items-center w-full py-4 border-b border-div-border-L2 flex-wrap sm:py-3 sm:px-4 sm:flex-nowrap"
        )>
        <li className=%twc("flex flex-row basis-1/3 sm:w-1/5 order-1 min-w-max sm:basis-1/5")>
          <span> {date->React.string} </span>
          <span className=%twc("text-text-L2 ml-1")> {time->React.string} </span>
        </li>
        <li
          className=%twc(
            "mt-1 w-2/5 basis-full order-3 overflow-x-hidden whitespace-nowrap text-ellipsis sm:basis-2/5 sm:mt-0 sm:order-2"
          )>
          {data.filename->React.string}
        </li>
        <li
          className=%twc(
            "flex justify-end ml-2.5 sm:ml-0 w-2/5 order-2 min-w-max sm:justify-start sm:order-3"
          )>
          {data->statusSplit}
        </li>
      </ul>
      <Dialog isShow=isShowDownloadError onConfirm={_ => setShowDownloadError(._ => Dialog.Hide)}>
        <p className=%twc("text-gray-500 text-center whitespace-pre-wrap")>
          {errorMessageDownload
          ->Option.getWithDefault(j`다운로드에 실패하였습니다.\n다시 시도하시기 바랍니다.`)
          ->React.string}
        </p>
      </Dialog>
    </>
  }
}

@react.component
let make = (~downloads': CustomHooks.Downloads.downloads) => {
  let {data, count, limit} = downloads'

  <div
    className="mt-5 p-5 bg-white rounded w-full min-h-[50vh] sm:min-h-[75vh] sm:p-7 sm:shadow-gl">
    <p className=%twc("flex items-center mb-3")>
      <h3 className=%twc("font-bold")> {`다운로드 요청내역`->React.string} </h3>
      <span className=%twc("ml-2 text-primary")> {`${count->Int.toString}건`->React.string} </span>
    </p>
    <div className=%twc("flex flex-col sm:flex-row sm:justify-between sm:items-center")>
      <span className=%twc("sm:text-sm")>
        {j`생성완료 후 7일간 다운로드 가능합니다.`->React.string}
      </span>
      {count !== 0 ? <Select_CountPerPage className=%twc("my-5 sm:my-0 w-fit") /> : React.null}
    </div>
    {switch count {
    | 0 =>
      <main
        className=%twc(
          "flex flex-row justify-center items-center w-full min-h-screen text-sm text-text-L2"
        )>
        {j`요청하신 다운로드가 없습니다.`->React.string}
      </main>
    | _ => <>
        <DownloadTableHead />
        <main>
          {data
          ->Array.map(data => <DownloadTableRow data key={data.filename ++ data.requestAt} />)
          ->React.array}
          <div className=%twc("flex flex-row items-center my-7 w-full justify-center")>
            <Pagination pageDisplySize=Constants.pageDisplySize itemPerPage=limit total=count />
          </div>
        </main>
      </>
    }}
  </div>
}
