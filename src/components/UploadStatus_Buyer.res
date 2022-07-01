let formatDate = d => d->Js.Date.fromString->Locale.DateTime.formatFromUTC("yyyy/MM/dd")
let formatTime = d => d->Js.Date.fromString->Locale.DateTime.formatFromUTC("HH:mm")
let styleStatus = s => {
  open CustomHooks.UploadStatus
  switch s {
  | SUCCESS => %twc("text-green-gl font-bold whitespace-nowrap")
  | FAIL => %twc("text-red-500 font-bold whitespace-nowrap")
  | PROCESSING => %twc("text-gray-700 font-bold whitespace-nowrap")
  | WAITING => %twc("text-gray-500 font-bold whitespace-nowrap")
  }
}
let displayStatus = s => {
  open CustomHooks.UploadStatus
  switch s {
  | SUCCESS => `성공`
  | FAIL => `실패`
  | PROCESSING => `처리중...`
  | WAITING => `대기중...`
  }
}
let displayError = (errorCode: option<CustomHooks.UploadStatus.errorCode>) =>
  switch errorCode {
  | Some(S3GetObject(_)) => `주문서 양식 에러`->React.string
  | Some(RequiredColumns(_)) => `주문서 양식 에러`->React.string
  | Some(ExcelCell(_)) => `주문서 양식 에러`->React.string
  | Some(EncryptedDocument(_)) => `주문서 양식 에러`->React.string
  | Some(Deposit(_)) => `주문가능금액 부족`->React.string
  | Some(ProductId(_)) => `상품코드 에러`->React.string
  | Some(Sku(_)) => `옵션코드 에러`->React.string
  | Some(OrderProductNo(_)) => `주문서 양식 에러`->React.string
  | Some(OrdererId(_)) => `주문서 양식 에러`->React.string
  | Some(Etc(_)) => `주문서 양식 에러`->React.string
  | Some(AfterPay(_)) => `나중결제 한도 부족`->React.string
  | None => React.null
  }
let textOnConfirmButton = (errorCode: option<CustomHooks.UploadStatus.errorCode>) =>
  switch errorCode {
  | Some(S3GetObject(_)) => `발주 메뉴얼 보기`
  | Some(RequiredColumns(_)) => `발주 메뉴얼 보기`
  | Some(ExcelCell(_)) => `발주 메뉴얼 보기`
  | Some(EncryptedDocument(_)) => `발주 메뉴얼 보기`
  | Some(Deposit(_)) => `추가 결제하기`
  | Some(ProductId(_)) => `운영코드 보기`
  | Some(Sku(_)) => `운영코드 보기`
  | Some(OrderProductNo(_)) => `발주 메뉴얼 보기`
  | Some(OrdererId(_)) => `발주 메뉴얼 보기`
  | Some(Etc(_)) => `발주 메뉴얼 보기`
  | Some(AfterPay(_)) => ``
  | None => ``
  }
let errorMessage = (errorCode: option<CustomHooks.UploadStatus.errorCode>) =>
  switch errorCode {
  | Some(S3GetObject(_))
  | Some(RequiredColumns(_))
  | Some(ExcelCell(_))
  | Some(EncryptedDocument(_)) =>
    `양식에 맞지 않은 주문서입니다.
아래와 같은 이유로 실패할 수 있습니다.\n\n`->React.string
  | Some(Deposit(_)) => <>
      {`주문가능금액이 부족해
발주에 실패했습니다.
추가 결제를 진행해 주시기 바랍니다.
`->React.string}
    </>
  | Some(ProductId(s))
  | Some(Sku(s)) => <>
      {`업로드한 주문서 `->React.string}
      <span className=%twc("font-bold")> {s->React.string} </span>
      {`\n상품코드를 재확인하신 후 업로드해주세요.`->React.string}
    </>
  | Some(OrderProductNo(s)) => `${s}\n`->React.string
  | Some(OrdererId(s)) => `${s}\n`->React.string
  | Some(Etc(s)) => `${s}\n`->React.string
  | Some(AfterPay(_)) => <>
      {`나중결제 잔여 한도 부족으로 발주에 실패했습니다.
주문 금액을 조정하여 다시 재업로드해주세요.
`->React.string}
    </>
  | None => React.null
  }
let linkOfGuide = (errorCode: option<CustomHooks.UploadStatus.errorCode>) =>
  switch errorCode {
  | Some(Deposit(_)) => "/buyer/transactions"
  | Some(ProductId(_))
  | Some(Sku(_)) => "/buyer/products/advanced-search"
  | Some(S3GetObject(_))
  | Some(RequiredColumns(_))
  | Some(ExcelCell(_))
  | Some(EncryptedDocument(_))
  | Some(OrderProductNo(_))
  | Some(OrdererId(_))
  | Some(Etc(_))
  | Some(AfterPay(_))
  | None => Env.buyerUploadGuideUri
  }

type errorDetail = {
  errorCode: option<CustomHooks.UploadStatus.errorCode>,
  isShow: Dialog.isShow,
}

let openInNewTab = elementId => {
  open Webapi
  let linkToGuide =
    Dom.document->Dom.Document.getElementById(elementId)->Option.flatMap(Dom.Element.asHtmlElement)

  switch linkToGuide {
  | Some(el) => el->Dom.HtmlElement.click
  | None => ()
  }
}

@react.component
let make = (~kind, ~onChangeLatestUpload, ~uploadType) => {
  let prevUploadedDateTime = React.useRef(None)

  let (errorDetail, setErrorDetail) = React.Uncurried.useState(_ => {
    isShow: Dialog.Hide,
    errorCode: None,
  })

  let status = CustomHooks.UploadStatus.use(~kind, ~uploadType)

  React.useEffect1(_ => {
    switch status {
    | Loaded(data) =>
      switch data->CustomHooks.UploadStatus.response_decode {
      | Ok(data') =>
        // 업로드 결과의 가장 최근 생성일이 변경되면 onChangeLatestUpload prop의 함수를 실행한다.
        // 새로운 업로드 결과가 있다면 목록을 새로고침 하기 위한 useEffect
        let latestUpload = data'.data->Garter.Array.first

        switch (prevUploadedDateTime.current, latestUpload) {
        | (Some(prevCreatedAt), Some(lu)) =>
          if lu.status === SUCCESS && prevCreatedAt !== lu.createdAt {
            onChangeLatestUpload()
            prevUploadedDateTime.current = Some(lu.createdAt)
          }
        | (None, Some(lu)) => prevUploadedDateTime.current = Some(lu.createdAt)
        | _ => ()
        }
      | Error(_) => ()
      }
    | _ => ()
    }

    None
  }, [status])

  <>
    <section className=%twc("table table-fixed w-full")>
      {switch status {
      | Loading => <div> {j`로딩 중..`->React.string} </div>
      | Error(_) => <div> {j`에러가 발생하였습니다.`->React.string} </div>
      | Loaded(data) =>
        switch data->CustomHooks.UploadStatus.response_decode {
        | Ok(data') => <>
            {if data'.data->Garter.Array.isEmpty {
              <div> {j`업로드 한 내역이 없습니다.`->React.string} </div>
            } else {
              data'.data
              ->Garter.Array.map(d => {
                <div className=%twc("table-row w-full") key=d.orderNo>
                  <span
                    className=%twc(
                      "table-cell w-24 py-3 pr-2 text-gray-gl border-b border-gray-200"
                    )>
                    <span className=%twc("block")> {d.createdAt->formatDate->React.string} </span>
                    <span className=%twc("block")> {d.createdAt->formatTime->React.string} </span>
                  </span>
                  <span className=%twc("table-cell w-full py-3 px-2 border-b border-gray-200")>
                    <span className=%twc("block truncate")> {d.filename->React.string} </span>
                    <span className=%twc("flex")>
                      <span className={d.status->styleStatus}>
                        {d.status->displayStatus->React.string}
                      </span>
                      <span className=%twc("flex-auto ml-2 text-red-500 truncate")>
                        {displayError(d.errorCode)}
                      </span>
                      {
                        let dataGtm = switch d.errorCode {
                        | Some(_) => "btn-recent-order-error-show-detail"
                        | None => "btn-recent-order-success-show-detail"
                        }

                        <ReactUtil.SpreadProps props={"data-gtm": dataGtm}>
                          <span
                            className=%twc("whitespace-nowrap ml-1 text-gray-400 underline")
                            onClick={_ =>
                              setErrorDetail(._ => {isShow: Dialog.Show, errorCode: d.errorCode})}>
                            {switch (uploadType, d.status, d.errorCode) {
                            | (OrderAfterPay, SUCCESS, None)
                            | (_, _, Some(_)) =>
                              `자세히보기`->React.string
                            | (_, _, None) => React.null
                            }}
                          </span>
                        </ReactUtil.SpreadProps>
                      }
                    </span>
                  </span>
                </div>
              })
              ->React.array
            }}
          </>
        | Error(err) =>
          `error: `->Js.log2(err)
          React.null
        }
      }}
    </section>
    <Dialog
      isShow={errorDetail.isShow}
      textOnConfirm={textOnConfirmButton(errorDetail.errorCode)}
      textOnCancel=`닫기`
      onConfirm={_ => {
        setErrorDetail(._ => {isShow: Dialog.Hide, errorCode: None})
        switch errorDetail.errorCode {
        | Some(_) => openInNewTab("link-of-guide")
        | None => ()
        }
      }}
      onCancel={_ => setErrorDetail(._ => {isShow: Dialog.Hide, errorCode: None})}>
      <a
        id="link-of-guide"
        href={linkOfGuide(errorDetail.errorCode)}
        target="_blank"
        className=%twc("hidden")
      />
      <p className=%twc("whitespace-pre-wrap text-text-L1 text-center")>
        {errorMessage(errorDetail.errorCode)}
      </p>
      {switch errorDetail.errorCode {
      | Some(S3GetObject(_))
      | Some(RequiredColumns(_))
      | Some(ExcelCell(_))
      | Some(EncryptedDocument(_)) =>
        <p className=%twc("whitespace-pre-wrap text-left text-black-gl font-bold")>
          {`1.[주문서 양식]에서 행(2~3행)을 삭제하지 않고
업로드했을 경우
2.엑셀 (xlsx,xls) 형식이 아닌 경우
3. 필수 값에 빈 값이 있을 경우
4. 엑셀에 비밀번호가 걸려있을 경우`->React.string}
        </p>
      | _ => React.null
      }}
      {
        // 나중결제 등록 성공에 대한 메시지
        switch (uploadType, errorDetail.errorCode) {
        | (CustomHooks.UploadStatus.OrderAfterPay, None) =>
          `나중결제로 주문을 등록했어요. 맨 상단 [내역보기]를 눌러 만기일 및 상환필요금액을 확인하세요.`->React.string
        | _ => React.null
        }
      }
    </Dialog>
  </>
}
