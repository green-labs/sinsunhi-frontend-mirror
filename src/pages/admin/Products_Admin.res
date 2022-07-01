module Query = %relay(`
  query ProductsAdminQuery(
    $limit: Int!
    $name: String
    $isDelivery: Boolean
    $offset: Int
    $producerName: String
    $producerCodes: [String!]
    $productNos: [Int!]
    $displayCategoryId: ID!
    $productCategoryId: ID!
    $statuses: [ProductStatus!]
    $productType: [ProductType!]
  ) {
    ...ProductsListAdminFragment
      @arguments(
        sort: UPDATED_DESC
        limit: $limit
        name: $name
        isDelivery: $isDelivery
        offset: $offset
        producerName: $producerName
        producerCodes: $producerCodes
        productNos: $productNos
        statuses: $statuses
        productCategoryId: $productCategoryId
        displayCategoryId: $displayCategoryId
        type: $productType
      )
    products(
      sort: UPDATED_DESC
      first: $limit
      name: $name
      isCourierAvailable: $isDelivery
      offset: $offset
      producerName: $producerName
      categoryId: $productCategoryId
      producerCodes: $producerCodes
      productNos: $productNos
      statuses: $statuses
      displayCategoryId: $displayCategoryId
      type: $productType
    ) {
      totalCount
    }
  }
`)

module QueryCategories = %relay(`
  query ProductsAdminCategoriesQuery(
    $displayCategoryId: ID!
    $productCategoryId: ID!
  ) {
    ...SearchProductAdminCategoriesFragment
      @arguments(
        displayCategoryId: $displayCategoryId
        productCategoryId: $productCategoryId
      )
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
      <div className=%twc("p-7 mt-4 mx-4 bg-white rounded shadow-gl")>
        <div className=%twc("py-6 px-7 flex flex-col text-sm bg-gray-gl rounded-xl") />
      </div>
      <div className=%twc("p-7 m-4 shadow-gl overflow-auto overflow-x-scroll bg-white rounded") />
    </div>
}

module Search = {
  let useSearchDefaultValue = () => {
    let {query} = Next.Router.useRouter()

    Search_Product_Admin.getDefault(query)
  }
  let useCategorySearchInput = (): ProductsAdminCategoriesQuery_graphql.Types.variables => {
    let {query} = Next.Router.useRouter()
    {
      displayCategoryId: query->Js.Dict.get("display-category-id")->Option.getWithDefault(""),
      productCategoryId: query->Js.Dict.get("category-id")->Option.getWithDefault(""),
    }
  }

  @react.component
  let make = () => {
    let defaultValue = useSearchDefaultValue()
    let categorySearchInput = useCategorySearchInput()

    let categoryQueryData = QueryCategories.use(~variables=categorySearchInput, ())

    <Search_Product_Admin defaultValue defaultCategoryQuery={categoryQueryData.fragmentRefs} />
  }
}

module List = {
  let useSearchInput = (): ProductsAdminQuery_graphql.Types.variables => {
    let {query} = Next.Router.useRouter()

    {
      limit: query->Js.Dict.get("limit")->Option.flatMap(Int.fromString)->Option.getWithDefault(25),
      name: query->Js.Dict.get("name")->Option.keep(str => str !== ""),
      producerName: query->Js.Dict.get("producer-name")->Option.keep(str => str !== ""),
      offset: query->Js.Dict.get("offset")->Option.flatMap(Int.fromString),
      displayCategoryId: query->Js.Dict.get("display-category-id")->Option.getWithDefault(""),
      productCategoryId: query->Js.Dict.get("category-id")->Option.getWithDefault(""),
      producerCodes: query
      ->Js.Dict.get("producer-codes")
      ->Option.keep(a => a !== "")
      ->Option.map(str => str->Js.String2.splitByRe(Js.Re.fromString("\s*[,\n\s]\s*")))
      ->Option.map(a => a->Array.keepMap(Garter.Fn.identity)->Array.keep(str => str !== "")),
      productNos: query
      ->Js.Dict.get("product-nos")
      ->Option.keep(a => a !== "")
      ->Option.map(str => str->Js.String2.splitByRe(Js.Re.fromString("\s*[,\n\s]\s*")))
      ->Option.map(a => a->Array.keepMap(Garter.Fn.identity)->Array.keepMap(Int.fromString)),
      statuses: switch query
      ->Js.Dict.get("status")
      ->Option.map(str => str->Js.Json.string->Select_Product_Operation_Status.Base.status_decode) {
      | Some(Ok(SALE)) => [#SALE]->Some
      | Some(Ok(SOLDOUT)) => [#SOLDOUT]->Some
      | Some(Ok(NOSALE)) => [#NOSALE]->Some
      | Some(Ok(RETIRE)) => [#RETIRE]->Some
      | Some(Ok(HIDDEN_SALE)) => [#HIDDEN_SALE]->Some
      | _ => [#SALE, #SOLDOUT, #NOSALE, #RETIRE, #HIDDEN_SALE]->Some
      },
      isDelivery: switch query->Js.Dict.get("delivery") {
      | Some("available") => Some(true)
      | Some("unavailable") => Some(false)
      | _ => None
      },
      productType: {
        switch query
        ->Js.Dict.get("type")
        ->Option.map(str => str->Js.Json.string->Select_Product_Type.Search.status_decode) {
        | Some(Ok(NORMAL)) => [#NORMAL]->Some
        | Some(Ok(QUOTABLE)) => [#QUOTABLE]->Some
        | Some(Ok(QUOTED)) => [#QUOTED]->Some
        | _ => []->Some
        }
      },
    }
  }

  @react.component
  let make = () => {
    let searchInput = useSearchInput()

    let queryData = Query.use(~variables=searchInput, ~fetchPolicy=RescriptRelay.NetworkOnly, ())
    <>
      <div className=%twc("md:flex md:justify-between pb-4")>
        <div className=%twc("flex flex-auto justify-between")>
          <h3 className=%twc("font-bold")>
            {j`내역`->React.string}
            <span className=%twc("ml-1 text-green-gl font-normal")>
              {j`${queryData.products.totalCount->Int.toString}건`->React.string}
            </span>
          </h3>
          <div className=%twc("flex")>
            <Select_CountPerPage className=%twc("mr-2") />
            <Excel_Download_Request_Button userType=Admin requestUrl="/product/request-excel" />
          </div>
        </div>
      </div>
      <Products_List_Admin query={queryData.fragmentRefs} />
    </>
  }
}

module Products = {
  @react.component
  let make = () => {
    <div
      className=%twc(
        "max-w-gnb-panel overflow-auto overflow-x-scroll bg-div-shape-L1 min-h-screen"
      )>
      <header className=%twc("flex items-baseline p-7 pb-0")>
        <h1 className=%twc("text-text-L1 text-xl font-bold")> {j`상품 조회`->React.string} </h1>
      </header>
      <React.Suspense fallback={<div />}> <Search /> </React.Suspense>
      <div className=%twc("p-7 m-4 overflow-auto overflow-x-scroll bg-white rounded shadow-gl")>
        <React.Suspense fallback={<Products_List_Admin.Skeleton />}> <List /> </React.Suspense>
      </div>
    </div>
  }
}

@react.component
let make = () => {
  <Authorization.Admin title=j`관리자 상품 조회`>
    <RescriptReactErrorBoundary fallback={_ => <div> {`에러 발생`->React.string} </div>}>
      <React.Suspense fallback={<Skeleton />}> <Products /> </React.Suspense>
    </RescriptReactErrorBoundary>
  </Authorization.Admin>
}
