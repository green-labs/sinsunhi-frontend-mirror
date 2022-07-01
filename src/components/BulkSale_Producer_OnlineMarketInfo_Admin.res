/*
1. 컴포넌트 위치
  어드민 센터 - 전량 구매 - 생산자 소싱 관리 - (리스트) 온라인 유통 정보 컬럼
2. 역할
  팜모닝에서 신청 시 입력된 온라인 유통 경로 정보를 확인하는 버튼과 어드민이 새롭게 입력/수정하는 버튼을 제공합니다.
*/
module Fragment = %relay(`
  fragment BulkSaleProducerOnlineMarketInfoAdminFragment on BulkSaleApplication
  @refetchable(queryName: "BulkSaleProducerOnlineMarketInfoAdminRefetchQuery")
  @argumentDefinitions(
    first: { type: "Int", defaultValue: 100 }
    after: { type: "ID", defaultValue: null }
  ) {
    bulkSaleRawOnlineSale {
      id
      market
      deliveryCompany {
        id
        code
        name
      }
      url
      createdAt
    }
    bulkSaleOnlineSalesInfo(first: $first, after: $after)
      @connection(key: "BulkSaleOnlineSalesInfoList_bulkSaleOnlineSalesInfo") {
      __id
      count
      edges {
        cursor
        node {
          id
          market
          deliveryCompany {
            id
            code
            name
            isAvailable
          }
          url
          numberOfComments
          averageReviewScore
          createdAt
          updatedAt
        }
      }
    }
  }
`)

@react.component
let make = (~query, ~applicationId) => {
  let onlineMarkets = Fragment.use(query)

  <>
    <BulkSale_Producer_RawOnlineMarketInfo_Button_Admin onlineMarkets />
    <BulkSale_Producer_OnlineMarketInfo_Button_Admin onlineMarkets applicationId />
  </>
}
