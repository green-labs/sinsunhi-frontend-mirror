module Query = %relay(`
  query SelectWholesalerQuery($first: Int, $marketIds: [String!]) {
    wholesalers(first: $first, marketIds: $marketIds){
      count
      edges {
        cursor
        node {
          id
          code
          name
        }
      }
    }
  }

`)

module Loading = {
  @react.component
  let make = () => {
    <article className=%twc("flex-1")>
      <h3 className=%twc("text-sm")> {`법인명`->React.string} </h3>
      <label className=%twc("block relative mt-2")>
        <span
          className=%twc(
            "flex items-center border border-border-default-L1 rounded-md h-9 px-3 text-enabled-L1"
          )>
          {`로딩 중`->React.string}
        </span>
        <span className=%twc("absolute top-1.5 right-2")>
          <IconArrowSelect height="24" width="24" fill="#121212" />
        </span>
      </label>
    </article>
  }
}

@react.component
let make = (~label, ~wholesalerMarketId, ~wholesalerId, ~onChange) => {
  let queryData = Query.use(
    ~variables={first: Some(100), marketIds: wholesalerMarketId->Option.map(id => [id])},
    (),
  )

  <article className=%twc("flex-1")>
    <h3 className=%twc("text-sm")> {label->React.string} </h3>
    <label className=%twc("block relative mt-2")>
      <span
        className=%twc(
          "flex items-center border border-border-default-L1 rounded-md h-9 px-3 text-enabled-L1"
        )>
        {wholesalerId
        ->Option.flatMap(id => {
          queryData.wholesalers.edges
          ->Array.keep(edge => edge.node.id == id)
          ->Array.map(edge => edge.node.name)
          ->Garter.Array.first
        })
        ->Option.getWithDefault(`시장 선택`)
        ->React.string}
      </span>
      <span className=%twc("absolute top-1.5 right-2")>
        <IconArrowSelect height="24" width="24" fill="#121212" />
      </span>
      <select
        value={wholesalerId->Option.getWithDefault("")}
        className=%twc("block w-full h-full absolute top-0 opacity-0")
        onChange>
        <option value=""> {j`법인선택`->React.string} </option>
        {queryData.wholesalers.edges
        ->Array.map(edge =>
          <option key={edge.node.id} value={edge.node.id}> {edge.node.name->React.string} </option>
        )
        ->React.array}
      </select>
    </label>
  </article>
}
