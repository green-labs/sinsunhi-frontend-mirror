module Fragment = %relay(`
  fragment BulkSaleRawProductSaleLedgersAdminFragment on BulkSaleApplication
  @refetchable(queryName: "BulkSaleRawProductSaleLedgersAdminFragmentQuery")
  @argumentDefinitions(
    first: { type: "Int", defaultValue: 100 }
    after: { type: "ID", defaultValue: null }
  ) {
    bulkSaleRawProductSaleLedgers(first: $first, after: $after)
      @connection(key: "BulkSaleRawProductSaleLedgersAdmin_bulkSaleRawProductSaleLedgers") {
      edges {
        cursor
        node {
          id
          path
        }
      }
      pageInfo {
        startCursor
        endCursor
        hasNextPage
        hasPreviousPage
      }
    }
  }
`)

module LedgerFile = {
  @react.component
  let make = (~path) => {
    let status = CustomHooks.BulkSaleLedger.use(path)

    let (downloadUrl, displayText) = switch status {
    | Loading => (None, `로딩 중`)
    | Error(_) => (None, `에러 발생`)
    | Loaded(resource) =>
      switch resource->CustomHooks.BulkSaleLedger.response_decode {
      | Ok(resource') => (
          Some(resource'.url),
          resource'.path
          ->Js.String2.split("/")
          ->Garter.Array.last
          ->Option.getWithDefault(`알 수 없는 파일명`),
        )
      | Error(_) => (None, `에러 발생`)
      }
    }

    <span
      className=%twc(
        "inline-flex max-w-full items-center border border-border-default-L1 rounded-lg p-2 mt-2 text-sm text-text-L1 bg-white"
      )>
      <a href={downloadUrl->Option.getWithDefault("#")} download="" className=%twc("mr-1")>
        <IconDownloadCenter width="20" height="20" fill="#262626" />
      </a>
      <span className=%twc("truncate")> {displayText->React.string} </span>
    </span>
  }
}

@react.component
let make = (~query) => {
  let ledgers = Fragment.use(query)

  <>
    <h3 className=%twc("mt-4")> {j`판매 원표`->React.string} </h3>
    <article className=%twc("mt-2")>
      <div className=%twc("bg-surface rounded-lg p-3")>
        {ledgers.bulkSaleRawProductSaleLedgers.edges
        ->Array.map(edge =>
          <p className=%twc("text-text-L2")> <LedgerFile path={edge.node.path} /> </p>
        )
        ->React.array}
      </div>
    </article>
  </>
}
