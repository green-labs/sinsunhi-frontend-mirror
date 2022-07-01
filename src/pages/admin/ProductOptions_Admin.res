module List = Product_Option_List_Admin

module Query = %relay(`
  query ProductOptionsAdminQuery(
    $sort: ProductOptionSort!
    $limit: Int!
    $offset: Int
    $producerName: String
    $status: ProductOptionStatus
    $productName: String
    $categoryId: Int
  ) {
    ...ProductOptionListAdminFragment
      @arguments(
        sort: $sort
        limit: $limit
        offset: $offset
        producerName: $producerName
        status: $status
        productName: $productName
        categoryId: $categoryId
      )
    productOptions(
      sort: $sort
      first: $limit
      offset: $offset
      producerName: $producerName
      productOptionStatus: $status
      productName: $productName
      categoryId: $categoryId
    ) {
      totalCount
    }
  }
`)

module Skeleton = {
  @react.component
  let make = () =>
    <div
      className=%twc(
        "max-w-gnb-panel overflow-auto overflow-x-scroll bg-div-shape-L1 min-h-gnb-admin"
      )>
      <header className=%twc("flex items-baseline p-7 pb-0")>
        <h1 className=%twc("text-text-L1 text-xl font-bold")> {j`상품 조회`->React.string} </h1>
      </header>
      <div className=%twc("p-7 m-4 shadow-gl overflow-auto overflow-x-scroll bg-white rounded")>
        <List.Skeleton />
      </div>
    </div>
}

module ProductOptions = {
  @react.component
  let make = () => {
    let router = Next.Router.useRouter()
    let queryData = Query.use(
      ~variables={
        sort: #SKU_DESC,
        limit: router.query
        ->Js.Dict.get("limit")
        ->Option.flatMap(Int.fromString)
        ->Option.getWithDefault(25),
        offset: router.query->Js.Dict.get("offset")->Option.flatMap(Int.fromString),
        categoryId: router.query->Js.Dict.get("category-id")->Option.flatMap(Int.fromString),
        producerName: router.query
        ->Js.Dict.get("producer-name")
        ->Option.flatMap(a => a === "" ? None : Some(a)),
        productName: router.query
        ->Js.Dict.get("product-name")
        ->Option.flatMap(a => a === "" ? None : Some(a)),
        status: switch router.query->Js.Dict.get("status") {
        | Some("SALE") => #SALE->Some
        | Some("SOLDOUT") => #SOLDOUT->Some
        | Some("NOSALE") => #NOSALE->Some
        | Some("RETIRE") => #RETIRE->Some
        | Some("HIDDEN_SALE") => #HIDDEN_SALE->Some
        | _ => None
        },
      },
      ~fetchPolicy=RescriptRelay.StoreAndNetwork,
      (),
    )
    Js.log(router)

    <div
      className=%twc(
        "max-w-gnb-panel overflow-auto overflow-x-scroll bg-div-shape-L1 min-h-screen"
      )>
      <header className=%twc("flex items-baseline p-7 pb-0")>
        <h1 className=%twc("text-text-L1 text-xl font-bold")>
          {j`단품 목록 조회`->React.string}
        </h1>
      </header>
      <Search_Product_Option_Admin />
      <div className=%twc("p-7 m-4 overflow-auto overflow-x-scroll bg-white rounded shadow-gl")>
        <div className=%twc("md:flex md:justify-between pb-4")>
          <div className=%twc("flex flex-auto justify-between")>
            <h3 className=%twc("font-bold")>
              {j`내역`->React.string}
              <span className=%twc("ml-1 text-green-gl font-normal")>
                {j`${queryData.productOptions.totalCount->Int.toString}건`->React.string}
              </span>
            </h3>
            <div className=%twc("flex")>
              <Select_CountPerPage className=%twc("mr-2") />
              <Excel_Download_Request_Button userType=Admin requestUrl="/product/request-excel" />
            </div>
          </div>
        </div>
        <List query={queryData.fragmentRefs} />
      </div>
    </div>
  }
}

@react.component
let make = () =>
  <Authorization.Admin title=j`관리자 상품 조회`>
    <RescriptReactErrorBoundary fallback={_ => <div> {`에러 발생`->React.string} </div>}>
      <React.Suspense fallback={<Skeleton />}> <ProductOptions /> </React.Suspense>
    </RescriptReactErrorBoundary>
  </Authorization.Admin>
