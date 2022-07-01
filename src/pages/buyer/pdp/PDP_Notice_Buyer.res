/*
  1. 컴포넌트 위치
  바이어 센터 전시 매장 > PDP Page > 공지사항 컴포넌트
  
  2. 역할
  공지사항 여부 + 적용 노출 날짜를 고려하여 공지사항을 보여줍니다.
*/

module Fragment = %relay(`
  fragment PDPNoticeBuyerFragment on Product {
    notice
    noticeStartAt
    noticeEndAt
  }
`)

module PC = {
  @react.component
  let make = (~query) => {
    let {notice, noticeStartAt, noticeEndAt} = Fragment.use(query)
    let noticeDateLabel = PDP_Parser_Buyer.Product.Normal.makeNoticeDateLabel(
      noticeStartAt,
      noticeEndAt,
    )

    switch notice {
    | None => React.null
    | Some(notice') =>
      <div className=%twc("mt-14 flex min-h-[204px]")>
        <div className=%twc("p-7 flex flex-col flex-1 bg-gray-50 rounded-xl mr-5")>
          <span className=%twc("font-bold text-gray-800")> {`공지사항`->React.string} </span>
          <p className=%twc("mt-2 text-gray-800 whitespace-pre-wrap")>
            {notice'->ReactNl2br.nl2br}
          </p>
          <span className=%twc("mt-2 text-gray-600")> {noticeDateLabel->React.string} </span>
        </div>
        <button onClick={_ => ChannelTalk.showMessenger()} className=%twc("w-[314px] h-[204px]")>
          <Image
            className=%twc("w-full h-full object-cover")
            src={"/images/qna-green-square@3x.png"}
            alt={"detail-qna"}
          />
        </button>
      </div>
    }
  }
}

module MO = {
  @react.component
  let make = (~query) => {
    let {notice, noticeStartAt, noticeEndAt} = Fragment.use(query)
    let noticeDateLabel = PDP_Parser_Buyer.Product.Normal.makeNoticeDateLabel(
      noticeStartAt,
      noticeEndAt,
    )

    switch notice {
    | None => React.null
    | Some(notice') =>
      <div className=%twc("flex flex-col gap-2 bg-surface p-4 rounded-2xl")>
        <h4 className=%twc("text-[15px] font-bold")> {`공지사항`->React.string} </h4>
        <p className=%twc("text-text-L1")> {notice'->ReactNl2br.nl2br} </p>
        <span className=%twc("text-text-L2 text-sm")> {noticeDateLabel->React.string} </span>
      </div>
    }
  }
}
