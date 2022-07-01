module Skeleton = {
  @react.component
  let make = () => {
    open Status_BulkSale_Producer
    <div className=%twc("py-3 px-7 mt-4 mx-4 shadow-gl bg-white rounded")>
      <ol
        className=%twc(
          "grid grid-cols-2 sm:grid-cols-4 lg:grid-cols-7 lg:justify-between lg:w-full lg:py-3"
        )>
        <Total.Skeleton />
        <Item.Skeleton kind=APPLIED />
        <Item.Skeleton kind=UNDER_DISCUSSION />
        <Item.Skeleton kind=ON_SITE_MEETING_SCHEDULED />
        <Item.Skeleton kind=SAMPLE_REQUESTED />
        <Item.Skeleton kind=SAMPLE_REVIEWING />
        <Item.Skeleton kind=REJECTED />
        <Item.Skeleton kind=CONFIRMED />
        <Item.Skeleton kind=WITHDRAWN />
      </ol>
    </div>
  }
}
module StatusFilter = {
  @react.component
  let make = (
    ~data: BulkSaleProducersAdminTotalSummaryFragment_graphql.Types.fragment_totalStatistics,
  ) => {
    <ol
      className=%twc(
        "grid grid-cols-2 sm:grid-cols-4 lg:grid-cols-7 lg:justify-between lg:w-full lg:py-3"
      )>
      <Status_BulkSale_Producer.Total data />
      <Status_BulkSale_Producer.Item kind=Status_BulkSale_Producer.APPLIED data />
      <Status_BulkSale_Producer.Item kind=Status_BulkSale_Producer.UNDER_DISCUSSION data />
      <Status_BulkSale_Producer.Item kind=Status_BulkSale_Producer.ON_SITE_MEETING_SCHEDULED data />
      <Status_BulkSale_Producer.Item kind=Status_BulkSale_Producer.SAMPLE_REQUESTED data />
      <Status_BulkSale_Producer.Item kind=Status_BulkSale_Producer.SAMPLE_REVIEWING data />
      <Status_BulkSale_Producer.Item kind=Status_BulkSale_Producer.REJECTED data />
      <Status_BulkSale_Producer.Item kind=Status_BulkSale_Producer.CONFIRMED data />
      <Status_BulkSale_Producer.Item kind=Status_BulkSale_Producer.WITHDRAWN data />
    </ol>
  }
}

@react.component
let make = (
  ~summary: BulkSaleProducersAdminTotalSummaryFragment_graphql.Types.fragment_totalStatistics,
) => {
  <div className=%twc("py-3 px-7 mt-4 mx-4 bg-white rounded")>
    <StatusFilter data=summary /> <Search_Producers_Admin />
  </div>
}
