let formatDate = d => d->Js.Date.fromString->Locale.DateTime.formatFromUTC("yyyy/MM/dd HH:mm")
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

@react.component
let make = (~kind, ~onChangeLatestUpload) => {
  let prevUploadedDateTime = React.useRef(None)

  let status = CustomHooks.UploadStatus.use(~kind, ~uploadType=CustomHooks.UploadStatus.Invoice)

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

  <section className=%twc("flex")>
    <div className=%twc("table table-fixed w-1/2 pt-5")>
      {switch status {
      | Loading => <div> {j`로딩 중..`->React.string} </div>
      | Error(_) => <div> {j`에러가 발생하였습니다.`->React.string} </div>
      | Loaded(data) =>
        switch data->CustomHooks.UploadStatus.response_decode {
        | Ok(data') => <>
            <div className=%twc("table-row w-full font-bold")>
              <span className=%twc("table-cell w-40 py-2 pr-2")>
                {j`요청일시`->React.string}
              </span>
              <span className=%twc("table-cell w-80 py-2 px-2")> {j`파일명`->React.string} </span>
              <span className=%twc("table-cell w-36 py-2 px-2")> {j`상태`->React.string} </span>
            </div>
            {if data'.data->Garter.Array.isEmpty {
              <div> {j`업로드 한 내역이 없습니다.`->React.string} </div>
            } else {
              data'.data
              ->Garter.Array.map(d => {
                <div className=%twc("table-row w-full") key=d.orderNo>
                  <span className=%twc("table-cell w-40 py-2 pr-2")>
                    {d.createdAt->formatDate->React.string}
                  </span>
                  <span className=%twc("table-cell w-80 py-2 pr-2")>
                    <span className=%twc("block truncate")> {d.filename->React.string} </span>
                  </span>
                  <span className=%twc("table-cell w-36 py-2 px-2")>
                    <span className={d.status->styleStatus}>
                      {displayStatus(d.status, d.successCount, d.failCount)->React.string}
                    </span>
                  </span>
                </div>
              })
              ->React.array
            }}
          </>
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
}
