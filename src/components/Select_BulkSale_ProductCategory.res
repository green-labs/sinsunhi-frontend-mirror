// 1. 위치
//    안심 판매 - 소싱 상품 등록/수정 - 상품 등록 다이얼로그
//
// 2. 역할
//    품목 검색 select

module Query = %relay(`
  query SelectBulkSaleProductCategoryQuery(
    $cropIds: [ID!]
    $count: Int
    $cursor: ID
    $nameMatch: String
    $orderBy: ProductCategoryOrderBy
    $orderDirection: OrderDirection
  ) {
    productCategories(
      cropIds: $cropIds
      first: $count
      nameMatch: $nameMatch
      after: $cursor
      orderBy: $orderBy
      orderDirection: $orderDirection
    ) {
      count
      edges {
        cursor
        node {
          id
          name
        }
      }
    }
  }
`)

let normalStyle = %twc(
  "flex items-center border border-border-default-L1 rounded-lg h-9 px-3 text-enabled-L1"
)
let errorStyle = %twc(
  "flex items-center border border-border-default-L1 rounded-lg h-9 px-3 text-enabled-L1 outline-none ring-2 ring-opacity-100 ring-notice remove-spin-button"
)
let disabledStyle = %twc(
  "flex items-center border border-border-default-L1 rounded-lg h-9 px-3 text-enabled-L1 bg-disabled-L3"
)

let style = (error, disabled) =>
  switch disabled {
  | Some(true) => disabledStyle
  | Some(false)
  | None =>
    switch error {
    | Some(_) => errorStyle
    | None => normalStyle
    }
  }

@react.component
let make = (~cropId, ~productCategoryId, ~onChange, ~error, ~disabled=?) => {
  // cropId가 ReactSelect.NotSelected인 경우 쿼리를 할 필요가 없다.
  // 검색어를 이용하여 쿼리를 한다.
  let handleLoadOptions = inputValue => {
    switch cropId {
    | ReactSelect.NotSelected => Js.Promise.resolve(None)
    | ReactSelect.Selected({value}) =>
      Query.fetchPromised(
        ~environment=RelayEnv.envFMBridge,
        ~variables={
          nameMatch: Some(inputValue),
          cropIds: Some([value]),
          count: Some(1000),
          cursor: None,
          orderBy: Some(#NAME),
          orderDirection: Some(#ASC),
        },
        (),
      ) |> Js.Promise.then_((
        result: SelectBulkSaleProductCategoryQuery_graphql.Types.rawResponse,
      ) => {
        let result' =
          result.productCategories.edges->Garter.Array.map(edge => ReactSelect.Selected({
            value: edge.node.id,
            label: edge.node.name,
          }))

        Js.Promise.resolve(Some(result'))
      })
    }
  }

  <article className=%twc("mt-5")>
    <h3 className=%twc("mb-2")> {j`품종`->React.string} </h3>
    <ReactSelect
      value=productCategoryId
      loadOptions={Helper.Debounce.make1(handleLoadOptions, 500)}
      cacheOptions=false
      defaultOptions=true
      onChange
      placeholder=`품종 검색`
      noOptionsMessage={_ => `검색 결과가 없습니다.`}
      isClearable=true
      styles={ReactSelect.stylesOptions(~menu=(provide, _) => {
        Js.Obj.assign(Js.Obj.empty(), provide)->Js.Obj.assign({"position": "inherit"})
      }, ())}
      isDisabled={disabled->Option.getWithDefault(false)}
    />
    <div>
      {error->Option.mapWithDefault(React.null, msg =>
        <span className=%twc("flex mt-2")>
          <IconError width="20" height="20" />
          <span className=%twc("text-sm text-notice ml-1")> {msg->React.string} </span>
        </span>
      )}
    </div>
  </article>
}
