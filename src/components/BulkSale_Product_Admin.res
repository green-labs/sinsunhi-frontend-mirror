module Fragment = %relay(`
  fragment BulkSaleProductAdminFragment_bulkSaleCampaign on BulkSaleCampaign
  @refetchable(queryName: "BulkSaleProductAdminRefetchQuery") {
    id
    createdAt
    productCategory {
      id
      name
      crop {
        id
        name
      }
    }
    isOpen
    estimatedPurchasePriceMin
    estimatedPurchasePriceMax
    estimatedSellerEarningRate
    preferredGrade
    preferredQuantity {
      display
      amount
      unit
    }
  }
`)

let formatDate = d => d->Js.Date.fromString->DateFns.format("yyyy/MM/dd HH:mm")

module Item = {
  module Table = {
    @react.component
    let make = (
      ~node: BulkSaleProductsListAdminFragment_graphql.Types.fragment_bulkSaleCampaigns_edges_node,
      ~refetchSummary,
    ) => {
      let product = Fragment.use(node.fragmentRefs)

      <>
        <li className=%twc("grid grid-cols-7-admin-bulk-sale-product")>
          <div className=%twc("h-full flex flex-col justify-center px-4 py-2")>
            {product.createdAt->formatDate->React.string}
          </div>
          <div className=%twc("h-full flex flex-col justify-center px-4 py-2")>
            <Select_BulkSale_Campaign_Status product refetchSummary />
          </div>
          <div className=%twc("h-full flex flex-col justify-center px-4 py-2")>
            {`${product.productCategory.crop.name} > ${product.productCategory.name}`->React.string}
          </div>
          <div className=%twc("h-full flex flex-col justify-center px-4 py-2")>
            {j`${product.estimatedPurchasePriceMin->Locale.Float.show(
                ~digits=0,
              )}원~${product.estimatedPurchasePriceMax->Locale.Float.show(
                ~digits=0,
              )}원`->React.string}
          </div>
          <div className=%twc("h-full flex flex-col justify-center px-4 py-2")>
            {j`${product.preferredGrade} ${product.preferredQuantity.display}`->React.string}
          </div>
          <div className=%twc("h-full flex flex-col justify-center px-4 py-2")>
            {j`${product.estimatedSellerEarningRate->Float.toString}%`->React.string}
          </div>
          <div className=%twc("h-full flex justify-center items-center px-4 py-1")>
            <BulkSale_Product_Update_Button key={product.id} product />
          </div>
        </li>
      </>
    }

    module Loading = {
      open Skeleton

      @react.component
      let make = () => {
        <li className=%twc("grid grid-cols-7-admin-bulk-sale-product")>
          <div className=%twc("h-full flex flex-col px-4 py-2")> <Checkbox /> </div>
          <div className=%twc("h-full flex flex-col px-4 py-2")>
            <Box className=%twc("w-20") /> <Box /> <Box className=%twc("w-12") />
          </div>
          <div className=%twc("h-full flex flex-col px-4 py-2")> <Box /> <Box /> </div>
          <div className=%twc("h-full flex flex-col px-4 py-2")>
            <Box /> <Box className=%twc("w-2/3") /> <Box className=%twc("w-8") />
          </div>
          <div className=%twc("h-full flex flex-col px-4 py-2")> <Box /> </div>
          <div className=%twc("h-full flex flex-col px-4 py-2")> <Box /> </div>
          <div className=%twc("h-full flex flex-col px-4 py-2")> <Box /> <Box /> </div>
        </li>
      }
    }
  }
}

@react.component
let make = (
  ~node: BulkSaleProductsListAdminFragment_graphql.Types.fragment_bulkSaleCampaigns_edges_node,
  ~refetchSummary,
) => {
  <Item.Table node refetchSummary />
}
