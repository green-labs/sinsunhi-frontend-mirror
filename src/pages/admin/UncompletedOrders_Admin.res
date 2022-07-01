module List = Order_List_Admin_Uncompleted

external unsafeAsFile: Webapi.Blob.t => Webapi.File.t = "%identity"

type query = {
  from: Js.Date.t,
  to_: Js.Date.t,
}
type target = From | To

@react.component
let make = () => {
  let router = Next.Router.useRouter()
  let status = CustomHooks.OrdersAdminUncompleted.use(
    router.query->Webapi.Url.URLSearchParams.makeWithDict->Webapi.Url.URLSearchParams.toString,
  )

  let (query, setQuery) = React.Uncurried.useState(_ => {
    from: Js.Date.make()->DateFns.subDays(7),
    to_: Js.Date.make(),
  })

  let (isShowConfirm, setShowConfirm) = React.Uncurried.useState(_ => Dialog.Hide)
  let (isShowCancelError, setShowCancelError) = React.Uncurried.useState(_ => Dialog.Hide)
  let (isShowDownloadError, setShowDownloadError) = React.Uncurried.useState(_ => Dialog.Hide)

  React.useEffect1(_ => {
    let from =
      router.query
      ->Js.Dict.get("from")
      ->Option.mapWithDefault(Js.Date.make()->DateFns.subDays(5), from =>
        from->DateFns.parse("yyyyMMdd", Js.Date.make())
      )
    let to_ =
      router.query
      ->Js.Dict.get("to")
      ->Option.mapWithDefault(Js.Date.make(), to_ => to_->DateFns.parse("yyyyMMdd", Js.Date.make()))
    setQuery(._ => {from: from, to_: to_})
    None
  }, [router.query])

  let handleOnChangeDate = (t, e) => {
    let newDate = (e->DuetDatePicker.DuetOnChangeEvent.detail).valueAsDate
    switch (t, newDate) {
    | (From, Some(newDate')) => setQuery(.prev => {...prev, from: newDate'})
    | (To, Some(newDate')) => setQuery(.prev => {...prev, to_: newDate'})
    | _ => ()
    }
  }

  let handleOnClickQuery = (
    _ => {
      router.query->Js.Dict.set("from", query.from->DateFns.format("yyyyMMdd"))
      router.query->Js.Dict.set("to", query.to_->DateFns.format("yyyyMMdd"))
      let newQueryString =
        router.query->Webapi.Url.URLSearchParams.makeWithDict->Webapi.Url.URLSearchParams.toString

      router->Next.Router.push(`${router.pathname}?${newQueryString}`)
    }
  )->ReactEvents.interceptingHandler

  // let downloadOrders = () => {
  //   {
  //     "order-product-numbers": ordersToCancel->Set.String.toArray,
  //   }
  //   ->Js.Json.stringifyAny
  //   ->Option.map(body => {
  //     FetchHelper.requestWithRetry(
  //       ~fetcher=FetchHelper.postWithTokenForExcel,
  //       ~url=`${Env.restApiUrl}/order/excel/buyer`,
  //       ~body,
  //       ~count=3,
  //       ~onSuccess={
  //         res => {
  //           let headers = res->Fetch.Response.headers
  //           let filename =
  //             (headers |> Fetch.Headers.get("Content-Disposition"))
  //             ->Option.flatMap(Helper.parseFilename)
  //             ->Option.map(Js.Global.decodeURIComponent)
  //             ->Option.getWithDefault(
  //               `${Js.Date.make()->DateFns.format("yyyyMMdd")}_주문서.xlsx`,
  //             )

  //           (res->Fetch.Response.blob
  //           |> Js.Promise.then_(blob => {
  //             open Webapi
  //             let anchor =
  //               Dom.document |> Dom.Document.createElement("a") |> Dom.Element.asHtmlElement
  //             let body =
  //               (Dom.document |> Dom.Document.asHtmlDocument)
  //                 ->Option.flatMap(Dom.HtmlDocument.body)

  //             Helper.Option.map2(body, anchor, (body', anchor') => {
  //               let url = Url.createObjectURL(blob->unsafeAsFile)
  //               anchor' |> Dom.HtmlElement.setAttribute("href", url)
  //               anchor' |> Dom.HtmlElement.setAttribute("download", filename)
  //               anchor' |> Dom.HtmlElement.setAttribute("style", "{display: none;}")
  //               body' |> Dom.Element.appendChild(anchor')
  //               anchor' |> Dom.HtmlElement.click
  //               let _ = body' |> Dom.Element.removeChild(anchor')
  //               Url.revokeObjectURL(url)
  //             })->ignore

  //             Js.Promise.resolve(blob)
  //           })
  //           |> Js.Promise.catch(err => {
  //             err->Js.Console.log
  //             Js.Promise.reject(Js.Exn.raiseError(`파일을 다운로드 할 수 없습니다.`))
  //           }))->ignore
  //         }
  //       },
  //       ~onFailure={
  //         _ => setShowDownloadError(._ => Dialog.Show)
  //       },
  //     )
  //   })
  //   ->ignore
  // }

  <Authorization.Admin title=j`관리자 주문서 처리실패`>
    <div className=%twc("py-10 px-7")>
      <header className=%twc("flex items-baseline")>
        <h1 className=%twc("font-bold text-xl")> {j`주문서 처리실패`->React.string} </h1>
        <span className=%twc("ml-2 text-gray-500 text-sm")>
          {j`잔액이 부족하거나 잔여수량이 부족할 경우에 처리실패가 발생할 수 있습니다.`->React.string}
        </span>
      </header>
      <div className=%twc("p-7 sm:mt-4 sm:shadow-gl")>
        <div className=%twc("md:flex md:justify-between pb-4")>
          <div className=%twc("flex flex-auto justify-between")>
            <h3 className=%twc("font-bold")> {j`내역`->React.string} </h3>
            <div className=%twc("flex")>
              <button
                className=%twc("py-1 px-3 text-black-gl bg-gray-button-gl rounded-lg")
                onClick={_ => ()}>
                {j`엑셀 다운로드`->React.string}
              </button>
            </div>
          </div>
          <div className=%twc("flex mt-7 justify-end md:mt-0 md:ml-4")>
            <div className=%twc("flex sm:w-64")>
              <DatePicker
                id="from"
                date={query.from}
                onChange={handleOnChangeDate(From)}
                maxDate={Js.Date.make()->DateFns.format("yyyy-MM-dd")}
                firstDayOfWeek=0
              />
              <DatePicker
                id="to"
                date={query.to_}
                onChange={handleOnChangeDate(To)}
                maxDate={Js.Date.make()->DateFns.format("yyyy-MM-dd")}
                minDate={query.from->DateFns.format("yyyy-MM-dd")}
                firstDayOfWeek=0
              />
            </div>
            <button
              className=%twc(
                "px-3 py-1 bg-green-gl text-white font-bold rounded-lg ml-1 whitespace-nowrap focus:outline-none focus:ring-2 focus:ring-opacity-100 focus:ring-green-gl"
              )
              onClick=handleOnClickQuery>
              {j`조회`->React.string}
            </button>
          </div>
        </div>
        <List status />
      </div>
    </div>
    <Dialog
      isShow=isShowConfirm onConfirm={_ => ()} onCancel={_ => setShowConfirm(._ => Dialog.Hide)}>
      <p className=%twc("text-gray-500 text-center whitespace-pre-wrap")>
        {`선택하신 주문을 취소하시겠습니까?`->React.string}
      </p>
    </Dialog>
    <Dialog isShow=isShowCancelError onConfirm={_ => setShowCancelError(._ => Dialog.Hide)}>
      <p className=%twc("text-gray-500 text-center whitespace-pre-wrap")>
        {`주문 취소에 실패하였습니다.\n다시 시도하시기 바랍니다.`->React.string}
      </p>
    </Dialog>
    <Dialog isShow=isShowDownloadError onConfirm={_ => setShowDownloadError(._ => Dialog.Hide)}>
      <p className=%twc("text-gray-500 text-center whitespace-pre-wrap")>
        {`다운로드에 실패하였습니다.\n다시 시도하시기 바랍니다.`->React.string}
      </p>
    </Dialog>
  </Authorization.Admin>
}
