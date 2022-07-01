module DownloadItem = {
  let styleStatus = status => {
    open CustomHooks.UploadStatus
    switch status {
    | SUCCESS => %twc("text-primary whitespace-nowrap")
    | FAIL => %twc("text-red-500 whitespace-nowrap")
    | PROCESSING => %twc("text-gray-700 whitespace-nowrap")
    | WAITING => %twc("text-gray-500 whitespace-nowrap")
    }
  }

  let displayStatus = s => {
    open CustomHooks.UploadStatus
    switch s {
    | SUCCESS => `전체성공`
    | FAIL => `전체실패`
    | PROCESSING => `처리중...`
    | WAITING => `대기중...`
    }
  }

  @react.component
  let make = (~data: CustomHooks.OfflineUploadStatus.data) => {
    let (isShowError, setShowError) = React.Uncurried.useState(_ => Dialog.Hide)

    <>
      <li className=%twc("grid grid-cols-3-offline-upload mt-4")>
        <div>
          {data.createdAt->Js.Date.fromString->DateFns.format("yyyy/MM/dd HH:mm")->React.string}
        </div>
        <div> {data.filename->React.string} </div>
        <div>
          <span className={data.status->styleStatus}>
            {data.status->displayStatus->React.string}
          </span>
          {switch data.errorCode {
          | Some(_) =>
            <button
              className=%twc("ml-5 focus:outline-none underline text-text-L3")
              onClick={_ => setShowError(._ => Dialog.Show)}>
              {j`자세히보기`->React.string}
            </button>
          | None => React.null
          }}
        </div>
      </li>
      <Dialog
        isShow=isShowError onCancel={_ => setShowError(._ => Dialog.Hide)} textOnCancel=`닫기`>
        <p className=%twc("text-text-L1 text-center whitespace-pre-wrap")>
          {j`양식에 맞지 않은 주문서입니다.`->React.string}
          <br />
          {j`아래와 같은 이유로 실패할 수 있습니다.`->React.string}
        </p>
        <br />
        <ol className=%twc("font-bold px-9")>
          <li> {j`1.엑셀파일 형식 (xls, xlsx) 이 아닌 경우`->React.string} </li>
          <li>
            {j`2.필수값 8개 항목 (오프라인주문번호, 오프라인주문일, 단품코드, 바이어코드, 발주량, 생산자공급원가, 바이어판매단가, 출고예정일) 이 없거나 잘못된 값일 경우`->React.string}
          </li>
          <li>
            {j`3.단품정보에 중량 / 패키지 / 등급 3개 항목이 비어 있을 경우`->React.string}
          </li>
          <li>
            {j`4.출고예정일이 오늘보다 과거날짜로 등록을 시도하는 경우`->React.string}
          </li>
          <li> {j`5.엑셀에 비밀번호가 걸려있을 경우`->React.string} </li>
        </ol>
      </Dialog>
    </>
  }
}

@react.component
let make = () => {
  let status = CustomHooks.OfflineUploadStatus.use()

  <>
    <h3 className=%twc("font-bold")> {j`주문서 업로드 결과`->React.string} </h3>
    <div className=%twc("grid grid-cols-3-offline-upload mt-5 font-bold")>
      <div> {j`요청일시`->React.string} </div>
      <div> {j`파일명`->React.string} </div>
      <div> {j`결과`->React.string} </div>
    </div>
    <ol>
      {switch status {
      | Loading => <div> {j`로딩 중..`->React.string} </div>
      | Error(_) => <div> {j`에러가 발생하였습니다.`->React.string} </div>
      | Loaded(data) =>
        switch data->CustomHooks.OfflineUploadStatus.response_decode {
        | Ok(data') if data'.data->Garter.Array.isEmpty =>
          <div> {j`업로드 한 내역이 없습니다.`->React.string} </div>
        | Ok(data') =>
          data'.data->Garter.Array.map(d => <DownloadItem data={d} key={d.uploadNo} />)->React.array
        | Error(_) => React.null
        }
      }}
    </ol>
  </>
}
