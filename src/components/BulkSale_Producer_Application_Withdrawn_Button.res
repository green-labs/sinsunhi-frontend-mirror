module Query = %relay(`
  query BulkSaleProducerApplicationWithdrawnButton_Query($applicationId: ID!) {
    reasons: bulkSaleApplicationWithdrawalReasons(applicationId: $applicationId)
  }
`)

module Reasons = {
  @react.component
  let make = (~applicationId: string) => {
    let {reasons} = Query.use(~variables={applicationId: applicationId}, ())

    <ul className=%twc("py-5 border border-disabled-L2 border-x-0")>
      {reasons
      ->Array.mapWithIndex((i, r) =>
        <li
          className=%twc("list-disc list-inside mt-5 first-of-type:mt-0 font-bold")
          key={`${applicationId}-${i->Int.toString}`}>
          {r->React.string}
        </li>
      )
      ->React.array}
    </ul>
  }
}

@react.component
let make = (~applicationId: string) => {
  open RadixUI
  let (isShow, setShow) = React.Uncurried.useState(_ => false)

  <Dialog.Root _open=isShow>
    <Dialog.Overlay className=%twc("dialog-overlay") />
    <Dialog.Trigger
      className=%twc("absolute top-9 left-0 text-text-L2 focus:outline-none text-left underline")
      onClick={_ => setShow(._ => true)}>
      <span className=%twc("block mt-[10px] underline")> {`취소사유`->React.string} </span>
    </Dialog.Trigger>
    <Dialog.Content className=%twc("dialog-content overflow-y-auto")>
      <section className=%twc("p-5")>
        <article className=%twc("flex")>
          <h2 className=%twc("text-xl font-bold")> {`판매 취소 사유`->React.string} </h2>
          <Dialog.Close
            className=%twc("inline-block p-1 focus:outline-none ml-auto")
            onClick={_ => setShow(._ => false)}>
            <IconClose height="24" width="24" fill="#262626" />
          </Dialog.Close>
        </article>
        <article className=%twc("mt-5")>
          <div className=%twc("pb-5")>
            {`농민이 안심판매 신청을 취소한 사유입니다.`->React.string}
          </div>
          <React.Suspense fallback={React.null}> <Reasons applicationId /> </React.Suspense>
        </article>
        <article className=%twc("flex justify-center items-center mt-5")>
          <Dialog.Close className=%twc("flex mr-2") onClick={_ => setShow(._ => false)}>
            <span id="btn-close" className=%twc("btn-level6 py-3 px-5")>
              {`닫기`->React.string}
            </span>
          </Dialog.Close>
        </article>
      </section>
    </Dialog.Content>
  </Dialog.Root>
}
