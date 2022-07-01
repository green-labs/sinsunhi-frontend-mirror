open RadixUI
let formatDate = d => d->Js.Date.fromString->Locale.DateTime.formatFromUTC("yyyy/MM/dd HH:mm")

module Summary = {
  module Amount = {
    open Skeleton

    @react.component
    let make = (~buyerId, ~kind, ~className=?) => {
      let status = CustomHooks.TransactionSummary.use(
        [("buyer-id", buyerId->Int.toString)]
        ->Js.Dict.fromArray
        ->Webapi.Url.URLSearchParams.makeWithDict
        ->Webapi.Url.URLSearchParams.toString,
      )

      switch status {
      | Error(error) =>
        error->Js.Console.log
        <Box className=%twc("w-20") />
      | Loading => <Box className=%twc("w-20") />
      | Loaded(response) =>
        switch response->CustomHooks.TransactionSummary.response_decode {
        | Ok(response') =>
          open CustomHooks.TransactionSummary

          <span ?className>
            {switch kind {
            | OrderComplete =>
              `${response'.data.orderComplete->Locale.Float.show(~digits=0)}원`->React.string
            | CashRefund =>
              `${response'.data.cashRefund->Locale.Float.show(~digits=0)}원`->React.string
            | ImwebPay =>
              `${response'.data.imwebPay->Locale.Float.show(~digits=0)}원`->React.string
            | ImwebCancel =>
              `${response'.data.imwebCancel->Locale.Float.show(~digits=0)}원`->React.string
            | OrderCancel =>
              `${response'.data.orderCancel->Locale.Float.show(~digits=0)}원`->React.string
            | OrderRefund =>
              `${response'.data.orderRefund->Locale.Float.show(~digits=0)}원`->React.string
            | Deposit => `${response'.data.deposit->Locale.Float.show(~digits=0)}원`->React.string
            | SinsunCash =>
              `${response'.data.sinsunCash->Locale.Float.show(~digits=0)}원`->React.string
            }}
          </span>
        | Error(error) =>
          error->Js.Console.log
          <Box className=%twc("w-20") />
        }
      }
    }
  }

  @react.component
  let make = (~buyerId) => {
    <div className=%twc("p-5")>
      <span className=%twc("flex")>
        <h2 className=%twc("font-bold mr-2")> {j`주문가능잔액`->React.string} </h2>
        <Amount
          buyerId
          kind={CustomHooks.TransactionSummary.Deposit}
          className=%twc("font-bold text-primary")
        />
      </span>
      <ol className=%twc("grid grid-cols-2 bg-div-border-L2 gap-x-px mt-5")>
        <li className=%twc("flex justify-between items-center py-1.5 bg-white pr-5 text-sm")>
          <span> {j`신선캐시 충전`->React.string} </span>
          <Amount
            buyerId kind={CustomHooks.TransactionSummary.SinsunCash} className=%twc("font-bold")
          />
        </li>
        <li className=%twc("flex justify-between items-center py-1.5 bg-white pl-5 text-sm")>
          <span> {j`상품결제`->React.string} </span>
          <Amount
            buyerId kind={CustomHooks.TransactionSummary.ImwebPay} className=%twc("font-bold")
          />
        </li>
        <li className=%twc("flex justify-between items-center py-1.5 bg-white pr-5 text-sm")>
          <span> {j`상품발주`->React.string} </span>
          <Amount
            buyerId kind={CustomHooks.TransactionSummary.OrderComplete} className=%twc("font-bold")
          />
        </li>
        <li className=%twc("flex justify-between items-center py-1.5 bg-white pl-5 text-sm")>
          <span> {j`주문취소`->React.string} </span>
          <Amount
            buyerId kind={CustomHooks.TransactionSummary.OrderCancel} className=%twc("font-bold")
          />
        </li>
        <li className=%twc("flex justify-between items-center py-1.5 bg-white pr-5 text-sm")>
          <span> {j`상품결제취소`->React.string} </span>
          <Amount
            buyerId kind={CustomHooks.TransactionSummary.ImwebCancel} className=%twc("font-bold")
          />
        </li>
        <li className=%twc("flex justify-between items-center py-1.5 bg-white pl-5 text-sm")>
          <span> {j`환불금액`->React.string} </span>
          <Amount
            buyerId kind={CustomHooks.TransactionSummary.OrderRefund} className=%twc("font-bold")
          />
        </li>
        <li className=%twc("flex justify-between items-center py-1.5 bg-white pr-5 text-sm")>
          <span> {j`잔액환불`->React.string} </span>
          <Amount
            buyerId kind={CustomHooks.TransactionSummary.CashRefund} className=%twc("font-bold")
          />
        </li>
        <li className=%twc("flex justify-between items-center py-1.5 bg-white pl-5 text-sm") />
      </ol>
    </div>
  }
}

module List = {
  @react.component
  let make = (~buyerId) => {
    let (paginationQueryString, setPaginationQueryString) = React.Uncurried.useState(_ => "")

    let status = CustomHooks.Transaction.use(
      [("buyer-id", buyerId->Int.toString)]
      ->Js.Dict.fromArray
      ->Webapi.Url.URLSearchParams.makeWithDict
      ->Webapi.Url.URLSearchParams.toString ++
      "&" ++
      paginationQueryString,
    )

    switch status {
    | Error(error) =>
      error->Js.Console.log
      <ErrorPanel error renderOnRetry={<Transaction_Admin.Item.Table.Loading />} />
    | Loading => <Transaction_Admin.Item.Table.Loading />
    | Loaded(transactions) =>
      switch transactions->CustomHooks.Transaction.response_decode {
      | Ok(transactions') => <>
          <ol
            className=%twc("divide-y divide-gray-100 overflow-y-scroll")
            style={ReactDOMStyle.make(~maxHeight="50vh", ())}>
            {transactions'.data->Garter.Array.length > 0
              ? transactions'.data
                ->Garter.Array.map(transaction =>
                  <Transaction_Admin key={transaction.id->Int.toString} transaction />
                )
                ->React.array
              : <EmptyOrders />}
          </ol>
          <div className=%twc("flex justify-center my-5")>
            <Pagination
              onChangePage={qs => {
                Js.Console.log("!!")
                setPaginationQueryString(._ => qs)
              }}
              pageDisplySize=Constants.pageDisplySize
              itemPerPage=transactions'.limit
              total=transactions'.count
            />
          </div>
        </>
      | Error(error) =>
        error->Js.Console.log
        React.null
      }
    }
  }
}

@react.component
let make = (~buyerId, ~buyerName) => {
  <Dialog.Root>
    <Dialog.Overlay className=%twc("dialog-overlay") />
    <Dialog.Trigger
      className=%twc(
        "text-base focus:outline-none bg-primary-light rounded-lg text-primary py-1 px-5"
      )>
      {j`조회하기`->React.string}
    </Dialog.Trigger>
    <Dialog.Content className=%twc("dialog-content-detail overflow-y-auto")>
      <div className=%twc("flex p-5")>
        <h3 className=%twc("text-lg font-bold")> {j`${buyerName} 거래내역`->React.string} </h3>
        <Dialog.Close className=%twc("focus:outline-none ml-auto")>
          <IconClose height="24" width="24" fill="#262626" />
        </Dialog.Close>
      </div>
      <Summary buyerId />
      <List buyerId />
    </Dialog.Content>
  </Dialog.Root>
}
