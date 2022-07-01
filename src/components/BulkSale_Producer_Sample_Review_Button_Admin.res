open RadixUI

module Fragment = %relay(`
  fragment BulkSaleProducerSampleReviewButtonAdminFragment on BulkSaleApplication
  @refetchable(queryName: "BulkSaleProducerSampleReviewButtonAdminRefetchQuery") {
    bulkSaleSampleReviews {
      count
      edges {
        cursor
        node {
          id
          brix
          marketabilityScore
          packageScore
          quantity {
            display
            amount
            unit
          }
          createdAt
          updatedAt
        }
      }
    }
  }
`)

@react.component
let make = (~applicationId, ~sampleReview) => {
  let (queryData, refetch) = Fragment.useRefetchable(sampleReview)

  let sampleReview =
    queryData.bulkSaleSampleReviews.edges->Array.get(0)->Option.map(edge => edge.node)

  let refetchSampleReviews = () => {
    refetch(
      ~variables=Fragment.makeRefetchVariables(),
      ~fetchPolicy=RescriptRelay.StoreAndNetwork,
      (),
    )->ignore
  }

  <Dialog.Root>
    <Dialog.Overlay className=%twc("dialog-overlay") />
    <Dialog.Trigger className=%twc("text-left")>
      <span
        className=%twc(
          "h-8 px-5 py-1 text-primary bg-primary-light rounded-lg focus:outline-none cursor-pointer"
        )>
        {switch sampleReview {
        | Some(_) => j`평가수정`
        | None => j`평가입력`
        }->React.string}
      </span>
    </Dialog.Trigger>
    {switch sampleReview {
    | Some(sampleReview') =>
      <BulkSale_Producer_Sample_Review_Button_Update_Admin sampleReview=sampleReview' />
    | None =>
      <BulkSale_Producer_Sample_Review_Button_Create_Admin applicationId refetchSampleReviews />
    }}
  </Dialog.Root>
}
