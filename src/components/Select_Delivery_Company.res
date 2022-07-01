module Query = %relay(`
  query SelectDeliveryCompanyQuery(
    $first: Int
    $orderBy: DeliveryCompanyOrderBy
    $orderDirection: OrderDirection
  ) {
    deliveryCompanies(
      first: $first
      orderBy: $orderBy
      orderDirection: $orderDirection
    ) {
      count
      edges {
        cursor
        node {
          id
          code
          name
          isAvailable
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
  "flex items-center border border-border-default-L1 rounded-lg h-9 px-3 text-enabled-L1 outline-none ring-2 ring-opacity-100 ring-notice remove-spin-button"
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
let make = (~label, ~deliveryCompanyId, ~onChange, ~className=?, ~error, ~disabled=?) => {
  let queryData = Query.use(
    ~variables={first: Some(100), orderBy: Some(#NAME), orderDirection: Some(#ASC)},
    (),
  )

  <article className=%twc("mt-7 px-5 max-w-sm")>
    <h3 className=%twc("text-sm")> {label->React.string} </h3>
    <label className=%twc("block relative mt-2")>
      <span
        className={className->Option.mapWithDefault(style(error, disabled), className' =>
          cx([style(error, disabled), className'])
        )}>
        {deliveryCompanyId
        ->Option.flatMap(id => {
          queryData.deliveryCompanies.edges
          ->Array.keep(edge => edge.node.id == id)
          ->Array.map(edge => edge.node.name)
          ->Garter.Array.first
        })
        ->Option.getWithDefault(`택배사 선택`)
        ->React.string}
      </span>
      <span className=%twc("absolute top-1.5 right-2")>
        <IconArrowSelect height="24" width="24" fill="#121212" />
      </span>
      <select
        value={deliveryCompanyId->Option.getWithDefault("")}
        className=%twc("block w-full h-full absolute top-0 opacity-0")
        onChange
        ?disabled>
        <option value=""> {j`택배사 선택`->React.string} </option>
        {queryData.deliveryCompanies.edges
        ->Array.map(edge =>
          <option key={edge.node.id} value={edge.node.id}> {edge.node.name->React.string} </option>
        )
        ->React.array}
      </select>
    </label>
    {error
    ->Option.map(err =>
      <span className=%twc("flex mt-2")>
        <IconError width="20" height="20" />
        <span className=%twc("text-sm text-notice ml-1")> {err->React.string} </span>
      </span>
    )
    ->Option.getWithDefault(React.null)}
  </article>
}
