module Skeleton = {
  @react.component
  let make = () => {
    open Status_BulkSale_Product
    <div className=%twc("py-3 px-7 mt-4 mx-4 shadow-gl bg-white rounded")>
      <ol
        className=%twc(
          "grid grid-cols-2 sm:grid-cols-4 lg:grid-cols-6 lg:justify-between lg:w-full lg:py-3"
        )>
        <Total.Skeleton /> <Item.Skeleton kind=OPEN /> <Item.Skeleton kind=ENDED />
      </ol>
    </div>
  }
}

module StatusFilter = {
  @react.component
  let make = (
    ~data: BulkSaleProductsAdminSummaryFragment_graphql.Types.fragment_bulkSaleCampaignStatistics,
  ) => {
    open Status_BulkSale_Product

    <ol
      className=%twc(
        "grid grid-cols-2 sm:grid-cols-4 lg:grid-cols-6 lg:justify-between lg:w-full lg:py-3"
      )>
      <Total data /> <Item kind=OPEN data /> <Item kind=ENDED data />
    </ol>
  }
}

@react.component
let make = (
  ~summary: BulkSaleProductsAdminSummaryFragment_graphql.Types.fragment_bulkSaleCampaignStatistics,
) => {
  <div className=%twc("py-3 px-7 mt-4 mx-4 shadow-gl bg-white rounded")>
    <StatusFilter data=summary />
  </div>
}
