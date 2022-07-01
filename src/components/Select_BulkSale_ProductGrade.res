module Query = %relay(`
  query SelectBulkSaleProductGradeQuery($ids: [ID!], $count: Int, $cursor: ID) {
    productCategories(ids: $ids, first: $count, after: $cursor) {
      count
      edges {
        cursor
        node {
          id
          name
          grades
          quantities {
            display
            amount
            unit
          }
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
let make = (~productCategoryId, ~preferredGrade, ~onChange, ~error, ~disabled=?) => {
  let queryData = Query.use(
    ~variables={
      ids: switch productCategoryId {
      | ReactSelect.NotSelected => None
      | ReactSelect.Selected({value}) => Some([value])
      },
      count: switch productCategoryId {
      | ReactSelect.NotSelected => Some(0)
      | ReactSelect.Selected(_) => Some(1000)
      },
      cursor: None,
    },
    (),
  )

  <article className=%twc("mt-5")>
    <h3> {j`등급`->React.string} </h3>
    <label className=%twc("block relative mt-2")>
      <span className={style(error, disabled)}>
        {preferredGrade->Option.getWithDefault(`등급 선택`)->React.string}
      </span>
      <span className=%twc("absolute top-1.5 right-2")>
        <IconArrowSelect height="24" width="24" fill="#121212" />
      </span>
      <select
        value={preferredGrade->Option.getWithDefault("")}
        className=%twc("block w-full h-full absolute top-0 opacity-0")
        onChange>
        <option key="0" value=""> {j`등급 선택`->React.string} </option>
        {queryData.productCategories.edges
        ->Array.get(0)
        ->Option.mapWithDefault(React.null, edge => {
          edge.node.grades
          ->Array.map(grade => <option key={grade} value={grade}> {grade->React.string} </option>)
          ->React.array
        })}
      </select>
    </label>
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
