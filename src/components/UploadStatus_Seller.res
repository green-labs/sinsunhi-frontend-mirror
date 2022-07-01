let formatDate = d => d->Js.Date.fromString->Locale.DateTime.formatFromUTC("yyyy/MM/dd")
let formatTime = d => d->Js.Date.fromString->Locale.DateTime.formatFromUTC("HH:mm")
let styleStatus = s => {
  open CustomHooks.UploadStatus
  switch s {
  | SUCCESS => %twc("text-green-gl")
  | FAIL => %twc("text-red-500")
  | PROCESSING => %twc("text-gray-700")
  | WAITING => %twc("text-gray-500")
  }
}

let displayStatus = (status, successCount, failCount) => {
  open CustomHooks.UploadStatus
  switch status {
  | WAITING => `대기중..`
  | PROCESSING => `처리중..`
  | SUCCESS =>
    Helper.Option.map2(successCount, failCount, (successCount', failCount') =>
      if failCount' > 0 {
        `일부성공(${successCount'->Int.toString}/${(successCount' + failCount')->Int.toString})`
      } else {
        `성공(${successCount'->Int.toString}/${successCount'->Int.toString})`
      }
    )->Option.getWithDefault(`성공`)
  | FAIL => `실패`
  }
}

type errorDetail = {
  failCodes: option<array<CustomHooks.UploadStatus.failDataJson>>,
  isShow: Dialog.isShow,
}

@react.component
let make = (~kind) => {
  let (failDetail, setFailDetail) = React.Uncurried.useState(_ => {
    isShow: Dialog.Hide,
    failCodes: None,
  })

  let status = CustomHooks.UploadStatus.use(~kind, ~uploadType=CustomHooks.UploadStatus.Invoice)

  <>
    <section className=%twc("flex flex-col")>
      <div className=%twc("table table-fixed pt-5")>
        {switch status {
        | Loading => <div> {j`로딩 중..`->React.string} </div>
        | Error(_) => <div> {j`에러가 발생하였습니다.`->React.string} </div>
        | Loaded(data) =>
          switch data->CustomHooks.UploadStatus.response_decode {
          | Ok(data') =>
            if data'.data->Garter.Array.isEmpty {
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
                    <span className=%twc("flex justify-between")>
                      <span className={d.status->styleStatus}>
                        {displayStatus(d.status, d.successCount, d.failCount)->React.string}
                      </span>
                      <span
                        className=%twc("whitespace-nowrap ml-1 text-gray-400 underline")
                        onClick={_ =>
                          setFailDetail(._ => {isShow: Dialog.Show, failCodes: d.failDataJson})}>
                        {switch d.failDataJson {
                        | Some(_) => `자세히보기`->React.string
                        | None => React.null
                        }}
                      </span>
                    </span>
                  </span>
                </div>
              })
              ->React.array
            }
          | Error(_) => React.null
          }
        }}
      </div>
      <div className=%twc("text-gray-gl")>
        <span className=%twc("block pt-7 font-bold")> {j`*주의사항`->React.string} </span>
        <ol className=%twc("list-decimal list-inside mt-2 text-sm")>
          <li>
            {j`형식에 맞는 주문서를 업로드 해야만 업로드에 성공합니다.`->React.string}
          </li>
          <li>
            {j`택배사명이 형식에 맞아야 업로드에 성공합니다.(우체국x,우체국 택배o)`->React.string}
          </li>
          <li>
            {j`가송장 입력을 지양해주세요. 가송장 입력 경우 “미출고"로 계속 노출.`->React.string}
          </li>
          <li>
            {j`일부 성공했을 경우, [미출고 건 다운로드]를 클릭해 확인 부탁드립니다.`->React.string}
          </li>
        </ol>
        <span className=%twc("block mt-6 text-sm")>
          {j`*가장 최근 요청한 3가지 등록건만 노출됩니다.`->React.string}
        </span>
      </div>
    </section>
    <Dialog
      isShow={failDetail.isShow}
      textOnCancel=`확인`
      onCancel={_ => setFailDetail(._ => {isShow: Dialog.Hide, failCodes: None})}>
      <p className=%twc("whitespace-pre-wrap text-gray-gl")>
        {`송장번호 대량 입력 일부 성공`->React.string}
      </p>
      {switch failDetail.failCodes {
      | Some(failCodes') =>
        <div className=%twc("mt-4")>
          <ol className=%twc("text-left list-decimal list-inside")>
            <li>
              <span className=%twc("font-bold")> {j`택배사명이 형식`->React.string} </span>
              {j`에 맞아야 합니다.`->React.string}
            </li>
            <li>
              <span className=%twc("font-bold")>
                {j`송장번호 항목이 빈값`->React.string}
              </span>
              {j`이 아니어야 합니다.`->React.string}
            </li>
            <li>
              <span className=%twc("font-bold")>
                {j`배송이 완료되었을 경우`->React.string}
              </span>
              {j` 송장번호 수정이 불가능합니다.`->React.string}
            </li>
          </ol>
          <div className=%twc("text-black-gl mt-4")>
            <div className=%twc("grid grid-cols-2-gl-seller-upload-error h-12 bg-gray-gl")>
              <div className=%twc("h-full px-4 flex justify-center items-center whitespace-nowrap")>
                {j`행`->React.string}
              </div>
              <div className=%twc("h-full px-4 flex justify-center items-center whitespace-nowrap")>
                {j`상태값`->React.string}
              </div>
            </div>
            <ol className=%twc("list-height-seller-error overflow-y-auto divide-y divide-gray-100")>
              {failCodes'->Garter.Array.length > 0
                ? failCodes'
                  ->Garter.Array.map(code =>
                    <li className=%twc("grid grid-cols-2-gl-seller-upload-error h-12")>
                      <div
                        className=%twc(
                          "h-full px-4 flex justify-center items-center whitespace-nowrap"
                        )>
                        {code.rowNumber->Int.toString->React.string}
                      </div>
                      <div className=%twc("h-full p-3 truncate")>
                        {switch code.failCode {
                        | InvalidSpec(m) => m->React.string
                        | InvalidCourierCode(m) => m->React.string
                        | NotYourProduct(m) => m->React.string
                        | NotAllowedModify(m) => m->React.string
                        }}
                      </div>
                    </li>
                  )
                  ->React.array
                : `에러 코드가 없습니다.`->React.string}
            </ol>
          </div>
        </div>
      | _ => React.null
      }}
    </Dialog>
  </>
}
