open RadixUI

let displayRawMarket = (
  rm: BulkSaleProducerOnlineMarketInfoAdminFragment_graphql.Types.enum_OnlineMarket,
) =>
  switch rm {
  | #NAVER => `네이버`
  | #COUPANG => `쿠팡`
  | #GMARKET => `지마켓`
  | #ST11 => `11번가`
  | #WEMAKEPRICE => `위메프`
  | #TMON => `티몬`
  | #AUCTION => `옥션`
  | #SSG => `SSG`
  | #INTERPARK => `인터파크`
  | #GSSHOP => `지에스숍`
  | #OTHER
  | _ => `기타`
  }

module Names = {
  @react.component
  let make = (~market) => {
    <>
      <h3 className=%twc("mt-4")> {j`유통경로`->React.string} </h3>
      <article className=%twc("mt-2")>
        <div className=%twc("bg-surface rounded-lg p-3")>
          <p className=%twc("text-text-L2")> {market->displayRawMarket->React.string} </p>
        </div>
      </article>
    </>
  }
}

module DeliveryCompany = {
  @react.component
  let make = (
    ~deliveryCompany: BulkSaleProducerOnlineMarketInfoAdminFragment_graphql.Types.fragment_bulkSaleRawOnlineSale_deliveryCompany,
  ) => {
    <>
      <h3 className=%twc("mt-4")> {j`계약된 택배사`->React.string} </h3>
      <article className=%twc("mt-2")>
        <div className=%twc("bg-surface rounded-lg p-3")>
          <p className=%twc("text-text-L2")> {deliveryCompany.name->React.string} </p>
        </div>
      </article>
    </>
  }
}

module Urls = {
  @react.component
  let make = (~url) => {
    <>
      <h3 className=%twc("mt-4")> {j`판매했던 URL`->React.string} </h3>
      <article className=%twc("mt-2")>
        <div className=%twc("bg-surface rounded-lg p-3")>
          <p className=%twc("text-text-L2")>
            {if url == "" {
              `(입력한 URL 없음)`
            } else {
              url
            }->React.string}
          </p>
        </div>
      </article>
    </>
  }
}

@react.component
let make = (
  ~onlineMarkets: BulkSaleProducerOnlineMarketInfoAdminFragment_graphql.Types.fragment,
) => {
  <Dialog.Root>
    <Dialog.Overlay className=%twc("dialog-overlay") />
    {switch onlineMarkets.bulkSaleRawOnlineSale {
    | Some(_) =>
      <Dialog.Trigger className=%twc("underline text-text-L2 text-left")>
        {j`입력 내용 보기`->React.string}
      </Dialog.Trigger>
    | None => <span> {j`아니오`->React.string} </span>
    }}
    <Dialog.Content className=%twc("dialog-content overflow-y-auto")>
      <section className=%twc("p-5 text-text-L1")>
        <article className=%twc("flex")>
          <h2 className=%twc("text-xl font-bold")> {j`온라인판매 정보`->React.string} </h2>
          <Dialog.Close className=%twc("inline-block p-1 focus:outline-none ml-auto")>
            <IconClose height="24" width="24" fill="#262626" />
          </Dialog.Close>
        </article>
        {onlineMarkets.bulkSaleRawOnlineSale->Option.mapWithDefault(
          React.null,
          bulkSaleRawOnlineSale => {
            <>
              <Names market=bulkSaleRawOnlineSale.market />
              {switch bulkSaleRawOnlineSale.deliveryCompany {
              | Some(deliveryCompany) => <DeliveryCompany deliveryCompany />
              | None => React.null
              }}
              <Urls url=bulkSaleRawOnlineSale.url />
            </>
          },
        )}
      </section>
    </Dialog.Content>
  </Dialog.Root>
}
