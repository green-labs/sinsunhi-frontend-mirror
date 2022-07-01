/*
1. 컴포넌트 위치
  어드민 센터 - 전량 구매 - 생산자 소싱 관리 - (리스트) 온라인 유통 정보 입력 버튼
2. 역할
  어드민이 전량 구매 신청한 생산자의 온라인 유통 정보를 생성/수정합니다. 신청 시 입력 받은 유통정보와는 별개의 정보 입니다.
*/
open RadixUI
module Util = BulkSale_Producer_OnlineMarketInfo_Button_Util
module FormCreate = BulkSale_Producer_OnlineMarketInfo_Button_Create_Admin.Form
module FormUpdate = BulkSale_Producer_OnlineMarketInfo_Button_Update_Admin.Form

module OnlineMarket = {
  @react.component
  let make = (
    ~market,
    ~selectedMarket,
    ~markets: BulkSaleProducerOnlineMarketInfoAdminFragment_graphql.Types.fragment,
    ~onClick,
  ) => {
    open Util

    let hasInfo =
      markets.bulkSaleOnlineSalesInfo.edges->Array.some(info => info.node.market == market)
    let style = switch (selectedMarket, hasInfo) {
    | (Some(selectedMarket'), _) if market == selectedMarket' =>
      %twc(
        "relative font-bold text-primary bg-primary-light border border-primary py-2 flex justify-center items-center rounded-lg"
      )
    | (_, true) =>
      %twc(
        "relative font-bold border border-bg-pressed-L2 py-2 flex justify-center items-center rounded-lg text-text-L1"
      )
    | (_, false) =>
      %twc(
        "relative border border-bg-pressed-L2 py-2 flex justify-center items-center rounded-lg text-text-L1"
      )
    }
    let svgFill = switch (selectedMarket, hasInfo) {
    | (Some(selectedMarket'), true) if market == selectedMarket' => "#12b564"
    | (_, true) => "#999999"
    | _ => ""
    }

    <li className=style onClick={_ => onClick(market)}>
      {market->displayMarket->React.string}
      <IconCheckOnlineMarketInfo
        width="20" height="20" fill=svgFill className=%twc("absolute right-3")
      />
    </li>
  }
}

module OnlineMarkets = {
  @react.component
  let make = (~selectedMarket, ~markets, ~onClick) => {
    open Util

    <ul className=%twc("px-5 grid grid-cols-4 gap-2")>
      {[
        #NAVER,
        #COUPANG,
        #GMARKET,
        #ST11,
        #WEMAKEPRICE,
        #TMON,
        #AUCTION,
        #SSG,
        #INTERPARK,
        #GSSHOP,
        #OTHER,
      ]
      ->Array.map(market =>
        <OnlineMarket key={market->stringifyMarket} market selectedMarket markets onClick />
      )
      ->React.array}
    </ul>
  }
}

module Form = {
  @react.component
  let make = (
    ~markets: BulkSaleProducerOnlineMarketInfoAdminFragment_graphql.Types.fragment,
    ~applicationId,
  ) => {
    let connectionId = markets.bulkSaleOnlineSalesInfo.__id

    let (selectedMarket, setSelectedMarket) = React.Uncurried.useState(_ => {
      let markets = markets.bulkSaleOnlineSalesInfo.edges->Garter.Array.first
      switch markets {
      | Some(m) => Some(m.node.market)
      | None => Some(#NAVER)
      }
    })

    let market =
      selectedMarket->Option.flatMap(selectedMarket' =>
        markets.bulkSaleOnlineSalesInfo.edges
        ->Array.keep(m => m.node.market == selectedMarket')
        ->Garter.Array.first
      )

    let handleOnClickMarket = (setFn, market) => {
      setFn(._ => Some(market))
    }

    <>
      <OnlineMarkets selectedMarket markets onClick={handleOnClickMarket(setSelectedMarket)} />
      {switch market {
      | Some(market') => <FormUpdate connectionId selectedMarket market=market' />
      | None => <FormCreate connectionId selectedMarket applicationId />
      }}
    </>
  }
}

@react.component
let make = (
  ~onlineMarkets: BulkSaleProducerOnlineMarketInfoAdminFragment_graphql.Types.fragment,
  ~applicationId,
) => {
  <Dialog.Root>
    <Dialog.Overlay className=%twc("dialog-overlay") />
    <Dialog.Trigger className=%twc("text-left")>
      <span className=%twc("inline-block bg-primary-light text-primary py-1 px-2 rounded-lg mt-2")>
        {j`유통 정보 입력`->React.string}
      </span>
    </Dialog.Trigger>
    <Dialog.Content className=%twc("dialog-content-detail overflow-y-auto")>
      <section className=%twc("p-5 text-text-L1")>
        <article className=%twc("flex")>
          <h2 className=%twc("text-xl font-bold")> {j`온라인 유통 정보`->React.string} </h2>
          <Dialog.Close className=%twc("inline-block p-1 focus:outline-none ml-auto")>
            <IconClose height="24" width="24" fill="#262626" />
          </Dialog.Close>
        </article>
      </section>
      <section>
        <React.Suspense fallback={<div> {j`로딩 중`->React.string} </div>}>
          <Form markets=onlineMarkets applicationId />
        </React.Suspense>
      </section>
    </Dialog.Content>
  </Dialog.Root>
}
