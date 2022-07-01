/*
 * 1. 위치
 *   전량 구매 생산자 소싱 관리 페이지 - 시장출하 여부
 * 2. 역할
 *   농민 신청 시 입력한 출하 시장과 판매원표를 쿼리 한다.
 * */
@react.component
let make = (~farmmorningUserId, ~applicationId, ~query) => {
  <>
    // 출하 시장 리스트
    <BulkSale_MarketSalesInfo_Button_Admin query />
    <BulkSale_ProductSaleLedgers_Button_Admin farmmorningUserId applicationId query />
  </>
}
