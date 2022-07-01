@react.component
let make = (~error: FetchHelper.customError, ~renderOnRetry: option<React.element>=?) => {
  if error.status === 401 {
    renderOnRetry->Option.getWithDefault(
      <div> {j`새로운 데이터 확인 중..`->React.string} </div>,
    )
  } else {
    <div> {j`에러가 발생하였습니다.`->React.string} </div>
  }
}
