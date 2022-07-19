open RadixUI

module Fragment = %relay(`
  fragment BulkSaleMarketSalesInfoButtonAdminFragment on BulkSaleApplication {
    bulkSaleProducerDetail {
      id
      experiencedMarkets {
        edges {
          cursor
          node {
            id
            name
            code
            isAvailable
          }
        }
      }
    }
  }

`)

@react.component
let make = (~query) => {
  let detail = Fragment.use(query)
  let edges = detail.bulkSaleProducerDetail->Option.mapWithDefault([], d => {
    d.experiencedMarkets.edges
  })

  <Dialog.Root>
    <Dialog.Overlay className=%twc("dialog-overlay") />
    {edges->Array.length > 0
      ? <Dialog.Trigger className=%twc("underline text-text-L2 text-left")>
          {`입력 내용 보기`->React.string}
        </Dialog.Trigger>
      : <span> {`없음`->React.string} </span>}
    <Dialog.Content className=%twc("dialog-content overflow-y-auto")>
      <section className=%twc("p-5 text-text-L1")>
        <article className=%twc("flex")>
          <h2 className=%twc("text-xl font-bold")> {j`출하 시장 정보`->React.string} </h2>
          <Dialog.Close className=%twc("inline-block p-1 focus:outline-none ml-auto")>
            <IconClose height="24" width="24" fill="#262626" />
          </Dialog.Close>
        </article>
        <h3 className=%twc("mt-4")> {j`시장명`->React.string} </h3>
        <article className=%twc("mt-2")>
          <div className=%twc("bg-surface rounded-lg p-3")>
            {edges
            ->Array.map(edge =>
              <p key={edge.cursor} className=%twc("text-text-L2")>
                {edge.node.name->React.string}
              </p>
            )
            ->React.array}
          </div>
        </article>
      </section>
    </Dialog.Content>
  </Dialog.Root>
}
