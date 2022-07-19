open RadixUI

module Detail = {
  let formatDate = d => d->Js.Date.fromString->Locale.DateTime.formatFromUTC("yyyy-MM-dd")

  @react.component
  let make = (~wholesale: CustomHooks.WholeSale.wholesale) => {
    <>
      <h3 className=%twc("font-bold leading-5 text-sm")> {j`상세내역`->React.string} </h3>
      <div className=%twc("mt-2 grid grid-cols-4-shipment-detail-seller min-w-max")>
        <div
          className=%twc(
            "align-middle py-3 pl-3 border-t border-border-default-L2 bg-bg-pressed-L1 text-text-L2"
          )>
          {j`판로유형`->React.string}
        </div>
        <div className=%twc("align-middle py-3 pl-3 border-t border-border-default-L2")>
          {j`도매출하`->React.string}
        </div>
        <div
          className=%twc(
            "align-middle py-3 pl-3 border-t border-border-default-L2 bg-bg-pressed-L1 text-text-L2"
          )>
          {j`날짜`->React.string}
        </div>
        <div className=%twc("align-middle py-3 pl-3 border-t border-border-default-L2")>
          {wholesale.date->formatDate->React.string}
        </div>
        <div
          className=%twc(
            "align-middle py-3 pl-3 border-t border-border-default-L2 bg-bg-pressed-L1 text-text-L2"
          )>
          {j`작물`->React.string}
        </div>
        <div className=%twc("align-middle py-3 pl-3 border-t border-border-default-L2")>
          {wholesale.crop->React.string}
        </div>
        <div
          className=%twc(
            "align-middle py-3 pl-3 border-t border-border-default-L2 bg-bg-pressed-L1 text-text-L2"
          )>
          {j`품종`->React.string}
        </div>
        <div className=%twc("align-middle py-3 pl-3 border-t border-border-default-L2")>
          {wholesale.cultivar->React.string}
        </div>
        <div
          className=%twc(
            "align-middle py-3 pl-3 border-t border-border-default-L2 bg-bg-pressed-L1 text-text-L2"
          )>
          {j`중량·포장`->React.string}
        </div>
        <div className=%twc("align-middle py-3 pl-3 border-t border-border-default-L2 ")>
          {j`${wholesale.weight->Option.mapWithDefault(
              "",
              Float.toString,
            )}, ${wholesale.packageType}`->React.string}
        </div>
        <div
          className=%twc(
            "align-middle py-3 pl-3 border-t border-border-default-L2 bg-bg-pressed-L1 text-text-L2"
          )>
          {j`등급`->React.string}
        </div>
        <div className=%twc("align-middle py-3 pl-3 border-t border-border-default-L2")>
          {wholesale.grade->React.string}
        </div>
        <div
          className=%twc(
            "align-middle py-3 pl-3 border-t border-border-default-L2 bg-bg-pressed-L1 text-text-L2"
          )>
          {j`총 경매금액`->React.string}
        </div>
        <div className=%twc("align-middle py-3 pl-3 border-t border-border-default-L2")>
          {j`${wholesale.totalSettlementAmount->Locale.Float.show(~digits=0)} 원`->React.string}
        </div>
        <div
          className=%twc(
            "align-middle py-3 pl-3 border-t border-border-default-L2 bg-bg-pressed-L1 text-text-L2"
          )>
          {j`총 경매수량`->React.string}
        </div>
        <div className=%twc("align-middle py-3 pl-3 border-t border-border-default-L2")>
          {wholesale.totalQuantity->Float.toString->React.string}
        </div>
        <div
          className=%twc(
            "align-middle py-3 pl-3 border-t border-b border-border-default-L2 bg-bg-pressed-L1 text-text-L2"
          )>
          {j`평균경매단가*`->React.string}
        </div>
        <div className=%twc("align-middle py-3 pl-3 border-t border-border-default-L2")>
          {j`${wholesale.avgUnitPirce->Locale.Float.show(~digits=0)} 원`->React.string}
        </div>
        <div
          className=%twc(
            "align-middle py-3 pl-3 border-t border-border-default-L2 bg-bg-pressed-L1 text-text-L2"
          )>
          {j`총 상장수수료`->React.string}
        </div>
        <div className=%twc("align-middle py-3 pl-3 border-t border-border-default-L2")>
          {j`${wholesale.totalAuctionFee->Locale.Float.show(~digits=0)} 원`->React.string}
        </div>
        <div
          className=%twc(
            "align-middle py-3 pl-3 border-t border-border-default-L2 bg-bg-pressed-L1 text-text-L2"
          )>
          {j`총 하차비용`->React.string}
        </div>
        <div className=%twc("align-middle py-3 pl-3 border-t border-border-default-L2")>
          {j`${wholesale.totalUnloadingCost->Locale.Float.show(~digits=0)} 원`->React.string}
        </div>
        <div
          className=%twc(
            "align-middle py-3 pl-3 border-t border-border-default-L2 bg-bg-pressed-L1 text-text-L2"
          )>
          {j`총 운송비용`->React.string}
        </div>
        <div className=%twc("align-middle py-3 pl-3 border-t border-border-default-L2")>
          {j`${wholesale.totalTransportCost->Locale.Float.show(~digits=0)} 원`->React.string}
        </div>
        <div
          className=%twc(
            "align-middle py-3 pl-3 border-t border-b border-border-default-L2 bg-bg-pressed-L1 text-text-L2"
          )>
          {j`총 포장재지원`->React.string}
        </div>
        <div className=%twc("align-middle py-3 pl-3 border-t border-b border-border-default-L2")>
          {j`${wholesale.totalPackageCostSpt->Locale.Float.show(~digits=0)} 원`->React.string}
        </div>
        <div
          className=%twc(
            "align-middle py-3 pl-3 border-t border-b border-border-default-L2 bg-bg-pressed-L1 text-text-L2"
          )>
          {j`총 운송비지원`->React.string}
        </div>
        <div className=%twc("align-middle py-3 pl-3 border-t border-b border-border-default-L2")>
          {j`${wholesale.totalTransportCostSpt->Locale.Float.show(~digits=0)} 원`->React.string}
        </div>
      </div>
      <span className=%twc("col-span-4 mt-1 text-text-L2")>
        {j`*평균경매단가는 소수점 첫번째 자리에서 반올림됩니다`->React.string}
      </span>
    </>
  }
}

module BulkSale = {
  @react.component
  let make = (~bulksale: CustomHooks.WholeSale.bulksale) => {
    <>
      <h3 className=%twc("font-bold leading-5 text-sm")>
        {j`신선하이 전량판매 단가 경매 단가 비교`->React.string}
      </h3>
      <div className=%twc("mt-2 grid grid-cols-4-shipment-detail-seller min-w-max")>
        <div
          className=%twc(
            "align-middle py-3 pl-3 border-t border-border-default-L2 bg-bg-pressed-L1 text-text-L2"
          )>
          {j`전량판매 단가`->React.string}
        </div>
        <div className=%twc("align-middle py-3 pl-3 border-t border-border-default-L2")>
          {j`${bulksale.unitPrice->Locale.Float.show(~digits=0)} 원`->React.string}
        </div>
        <div
          className=%twc(
            "align-middle py-3 pl-3 border-t border-border-default-L2 bg-bg-pressed-L1 text-text-L2"
          )>
          {j`차액*`->React.string}
        </div>
        <div className=%twc("align-middle py-3 pl-3 border-t border-border-default-L2")>
          {j`${bulksale.difference->Locale.Float.show(~digits=0)} 원`->React.string}
        </div>
        <div
          className=%twc(
            "align-middle py-3 pl-3 border-t border-b border-border-default-L2 bg-bg-pressed-L1 text-text-L2"
          )>
          {j`총 차액**`->React.string}
        </div>
        <div
          className=%twc(
            "col-span-3 align-middle py-3 pl-3 border-t border-b border-border-default-L2"
          )>
          {j`${bulksale.totalDiff->Locale.Float.show(~digits=0)} 원`->React.string}
        </div>
        <span className=%twc("col-span-4 mt-1 text-text-L2")>
          {j`*전량판매 단가 - 평균단가 = 차액  **차액 X 경매수량 = 총 차액`->React.string}
        </span>
      </div>
    </>
  }
}

module OrderList = {
  module AuctionItem = {
    @react.component
    let make = (~order: CustomHooks.WholeSale.order) => {
      <li className=%twc("grid grid-cols-3-shipment-auction-seller")>
        <div className=%twc("border-b border-border-default-L2 py-3 pl-4")>
          {j`${order.marketName}(${order.wholesalerName})`->React.string}
        </div>
        <div className=%twc("border-b border-border-default-L2 py-3")>
          {j`${order.unitPrice->Locale.Float.show(~digits=0)} 원`->React.string}
        </div>
        <div className=%twc("border-b border-border-default-L2 py-3")>
          {order.quantity->Float.toString->React.string}
        </div>
      </li>
    }
  }
  module Pagination = {
    //pageDisplaySize -> 표시할 페이지 갯수
    // cur : 현재 page
    // itemsPerPage: 페이지당 item 갯수
    // total: 총 item 갯수

    @react.component
    let make = (~pageDisplaySize, ~cur: int, ~total: int, ~itemPerPage: int, ~onChangePage) => {
      let totalPage = (total->Float.fromInt /. itemPerPage->Float.fromInt)->Js.Math.ceil_int

      let (start, end) = {
        let nth = (cur - 1) / pageDisplaySize
        let start = pageDisplaySize * nth + 1
        let end = Js.Math.min_int(start + pageDisplaySize - 1, totalPage)
        (start, end)
      }

      let handleOnChangePage = e => {
        e->ReactEvent.Synthetic.preventDefault
        e->ReactEvent.Synthetic.stopPropagation

        let value = (e->ReactEvent.Synthetic.currentTarget)["value"]

        value
        ->Int.fromString
        ->Option.map(v => (v - 1) * itemPerPage)
        ->Option.map(onChangePage)
        ->ignore
      }

      let isDisabledLeft = start <= 1
      let isDisabledRight = end >= totalPage

      let buttonStyle = i =>
        cur === i ? %twc("w-10 h-12 text-center font-bold") : %twc("w-10 h-12 text-center")

      <ol className=%twc("flex")>
        <button
          value={start->Int.toString}
          onClick={handleOnChangePage}
          className={cx([
            %twc(
              "transform rotate-180 w-12 h-12 rounded-full bg-gray-100 flex justify-center items-center mr-4"
            ),
            isDisabledLeft ? %twc("cursor-not-allowed") : %twc("cursor-pointer"),
          ])}
          disabled=isDisabledLeft>
          <IconArrow
            height="20"
            width="20"
            stroke={isDisabledLeft ? "#CCCCCC" : "#727272"}
            className=%twc("relative")
          />
        </button>
        {Array.range(start, end)
        ->Array.map(i =>
          <li key={i->Int.toString}>
            <button value={i->Int.toString} onClick={handleOnChangePage} className={buttonStyle(i)}>
              {i->Int.toString->React.string}
            </button>
          </li>
        )
        ->React.array}
        <button
          value={end->Int.toString}
          onClick={handleOnChangePage}
          className={cx([
            %twc("w-12 h-12 rounded-full bg-gray-100 flex justify-center items-center ml-4"),
            isDisabledRight ? %twc("cursor-not-allowed") : %twc("cursor-pointer"),
          ])}
          disabled=isDisabledRight>
          <IconArrow
            height="20"
            width="20"
            stroke={isDisabledRight ? "#CCCCCC" : "#727272"}
            className=%twc("relative")
          />
        </button>
      </ol>
    }
  }

  @react.component
  let make = (~orders: array<CustomHooks.WholeSale.order>) => {
    let {pageDisplySize} = module(Constants)
    let (offset, setOffset) = React.Uncurried.useState(_ => 0)
    let itemPerPage = 10

    <>
      <div className=%twc("grid grid-cols-3-shipment-auction-seller min-w-max")>
        <div className=%twc("bg-bg-pressed-L1 text-text-L2 rounded py-2 pl-4")>
          {j`도매시장(청과)`->React.string}
        </div>
        <div className=%twc("bg-bg-pressed-L1 text-text-L2 rounded py-2")>
          {j`경락단가`->React.string}
        </div>
        <div className=%twc("bg-bg-pressed-L1 text-text-L2 rounded py-2")>
          {j`수량`->React.string}
        </div>
      </div>
      <ol>
        {orders
        ->Array.slice(~offset, ~len=itemPerPage)
        ->Array.map(order => <AuctionItem order key={UniqueId.make(~prefix="auction", ())} />)
        ->React.array}
      </ol>
      <div className=%twc("flex justify-center py-5")>
        {<Pagination
          pageDisplaySize={pageDisplySize}
          cur={offset / itemPerPage + 1}
          total={orders->Array.length}
          itemPerPage
          onChangePage={offset => setOffset(._ => offset)}
        />}
      </div>
    </>
  }
}

@react.component
let make = (~date: string, ~sku: string) => {
  let status = CustomHooks.WholeSale.use(
    [("settlement-date", date), ("sku", sku)]
    ->Js.Dict.fromArray
    ->Webapi.Url.URLSearchParams.makeWithDict
    ->Webapi.Url.URLSearchParams.toString,
  )

  <Dialog.Root>
    <Dialog.Trigger
      className=%twc(
        "max-w-min py-1 px-5 bg-green-gl-light text-green-gl rounded-md whitespace-nowrap focus:outline-none focus:ring-1 focus:ring-green-gl focus:ring-offset-1 focus:ring-opacity-80"
      )>
      {j`조회하기`->React.string}
    </Dialog.Trigger>
    <Dialog.Overlay className=%twc("dialog-overlay") />
    <Dialog.Content
      className=%twc(
        "dialog-content text-text-L1 text-xs p-5 tracking-tight min-w-max overflow-y-auto"
      )>
      <Dialog.Title className=%twc("flex justify-between")>
        <span className=%twc("font-bold text-xl leading-7")>
          {j`상세내역 조회`->React.string}
        </span>
        <Dialog.Close id="btn_close" className=%twc("focus:outline-none")>
          <IconClose height="24" width="24" fill="#262626" />
        </Dialog.Close>
      </Dialog.Title>
      {switch status {
      | Loaded(response) =>
        switch response->CustomHooks.WholeSale.response_decode {
        | Ok({data: wholesale}) => <>
            <section className=%twc("mt-10")> <Detail wholesale /> </section>
            {switch wholesale.bulksale {
            | Some(bulksale) => <section className=%twc("mt-10")> <BulkSale bulksale /> </section>
            | None => React.null
            }}
            <section className=%twc("mt-12")> <OrderList orders={wholesale.orders} /> </section>
          </>
        | Error(error) => {
            Js.log(error)
            React.null
          }
        }
      | _ => React.null
      }}
    </Dialog.Content>
  </Dialog.Root>
}
