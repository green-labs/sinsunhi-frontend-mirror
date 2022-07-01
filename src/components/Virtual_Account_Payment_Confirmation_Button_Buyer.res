module Query = %relay(`
  query VirtualAccountPaymentConfirmationButtonBuyerQuery(
    $paymentMethod: PaymentMethod!
    $status: PaymentStatus!
  ) {
    payments(paymentMethod: $paymentMethod, status: $status) {
      status
      paymentMethod
      amount
      id
      virtualAccount {
        accountNo
        createdAt
        expiredAt
        bank {
          name
        }
      }
    }
  }
`)

let columnsWithWidth = [
  (`요청일시`, %twc("w-20")),
  (`입금 은행·계좌번호`, %twc("w-32")),
  (`금액`, %twc("w-32")),
  (`기한`, %twc("w-20")),
  (`입금상태`, %twc("w-20")),
]

let formatDate = d => d->Js.Date.fromString->DateFns.format("yyyy-MM-dd")
let formatTime = d => d->Js.Date.fromString->DateFns.format("HH:mm:ss")

module TitleAndCloseButton = {
  @react.component
  let make = (~close) => {
    <div className=%twc("flex mb-5 md:mb-10 justify-between items-center")>
      <h3 className=%twc("font-bold text-xl")> {j`가상계좌 결제 확인`->React.string} </h3>
      <button onClick={_ => close()} className=%twc("cursor-pointer border-none")>
        <IconClose height="1.5rem" width="1.5rem" fill="#262626" />
      </button>
    </div>
  }
}

module TableHead = {
  @react.component
  let make = () =>
    <div className=%twc("hidden md:flex md:bg-div-shape-L2 md:text-text-L2 md:rounded min-w-max")>
      {columnsWithWidth
      ->Array.map(((column, width)) =>
        <div
          key={`head-${column}`}
          className={cx([
            %twc("mr-5 first:ml-5 last:mr-0 py-1 md:py-2 text-center break-all"),
            width,
          ])}>
          {column->React.string}
        </div>
      )
      ->React.array}
    </div>
}

module TableRow = {
  @react.component
  let make = (
    ~rowData: VirtualAccountPaymentConfirmationButtonBuyerQuery_graphql.Types.response_payments,
  ) => {
    let {id, status, amount, virtualAccount} = rowData

    let statusToString = status =>
      switch status {
      | #COMPLETE => `완료`
      | #FAILURE => `만료`
      | #PENDING | _ => `대기`
      }

    <li className=%twc("flex border-b py-2 border-div-border-L2")>
      <div className=%twc("md:hidden w-2/6 text-text-L2 min-w-max mr-3")>
        {columnsWithWidth
        ->Array.map(((column, _)) =>
          <p key={`${id}-${column}`} className=%twc("py-1 md:py-2")> {column->React.string} </p>
        )
        ->React.array}
      </div>
      {switch virtualAccount {
      | Some({accountNo, bank, createdAt, expiredAt}) =>
        <div
          className=%twc(
            "flex flex-col md:flex-row md:justify-center md:items-center whitespace-pre md:h-16"
          )>
          <div className=%twc("mr-5 md:ml-5 md:text-center md:w-20 py-1 md:py-2")>
            <div className=%twc("flex md:flex-col")>
              <p> {createdAt->formatDate->React.string} </p>
              <p className=%twc("text-text-L2 ml-1 md:ml-0")>
                {createdAt->formatTime->React.string}
              </p>
            </div>
          </div>
          <div className=%twc("flex md:flex-col mr-5 md:text-center md:w-32 py-1 md:py-2")>
            <p> {bank.name->React.string} </p>
            <p className=%twc("ml-1 md:ml-0")> {accountNo->React.string} </p>
          </div>
          <div className=%twc("mr-5 md:text-right md:w-32 py-1 md:py-2")>
            <p> {`${amount->Option.getWithDefault(0)->Locale.Int.show} 원`->React.string} </p>
          </div>
          <div className=%twc("mr-5 md:text-center md:w-20 py-1 md:py-2")>
            <div className=%twc("flex md:flex-col")>
              <p> {expiredAt->formatDate->React.string} </p>
              <p className=%twc("text-text-L2 ml-1 md:ml-0")>
                {expiredAt->formatTime->React.string}
              </p>
            </div>
          </div>
          <div className=%twc("mr-0 md:text-center md:w-20 py-1 md:py-2")>
            <p> {status->statusToString->React.string} </p>
          </div>
        </div>
      | None => React.null
      }}
    </li>
  }
}

module ContentsSkeleton = {
  @react.component
  let make = (~children) =>
    <div className=%twc("flex items-center justify-center md:h-[30vh] h-[60vh] font-bold")>
      children
    </div>
}

module List = {
  @react.component
  let make = () => {
    let queryData = Query.use(
      ~variables={paymentMethod: #VIRTUAL_ACCOUNT, status: #PENDING},
      ~fetchPolicy=RescriptRelay.NetworkOnly,
      (),
    )

    switch queryData.payments {
    | [] =>
      <ContentsSkeleton>
        <p className=%twc("text-text-L3")>
          {`가상계좌 결제 확인 내역이 없습니다.`->React.string}
        </p>
      </ContentsSkeleton>
    | charges' =>
      <ul className=%twc("md:min-h-[30vh] min-h-[60vh]")>
        {charges'->Array.map(rowData => <TableRow key=rowData.id rowData />)->React.array}
      </ul>
    }
  }
}

@react.component
let make = () => {
  let close = _ => {
    open Webapi
    let buttonClose = Dom.document->Dom.Document.getElementById("btn-close")
    buttonClose
    ->Option.flatMap(buttonClose' => {
      buttonClose'->Dom.Element.asHtmlElement
    })
    ->Option.forEach(buttonClose' => {
      buttonClose'->Dom.HtmlElement.click
    })
    ->ignore
  }

  <RadixUI.Dialog.Root>
    <RadixUI.Dialog.Overlay className=%twc("dialog-overlay") />
    <RadixUI.Dialog.Trigger
      className=%twc(
        "px-3 h-9 rounded-lg text-enabled-L1 bg-div-shape-L1 whitespace-nowrap focus:outline-none focus:ring-2 focus:ring-gray-150 focus:ring-offset-1"
      )>
      <span> {`가상계좌 결제 확인`->React.string} </span>
    </RadixUI.Dialog.Trigger>
    <RadixUI.Dialog.Content
      className=%twc(
        "dialog-content-fix p-5 overflow-y-auto text-sm text-text-L1 rounded-2xl min-w-max"
      )>
      <TitleAndCloseButton close />
      <TableHead />
      <RescriptReactErrorBoundary
        fallback={_ =>
          <ContentsSkeleton>
            <p className=%twc("text-notice")> {`에러 발생`->React.string} </p>
          </ContentsSkeleton>}>
        <React.Suspense
          fallback={<ContentsSkeleton>
            <p className=%twc("text-text-L3")> {`로딩 중..`->React.string} </p>
          </ContentsSkeleton>}>
          <List />
        </React.Suspense>
      </RescriptReactErrorBoundary>
      <RadixUI.Dialog.Close id="btn-close" className=%twc("hidden")>
        {j``->React.string}
      </RadixUI.Dialog.Close>
      <span className=%twc("md:hidden")>
        <Dialog.ButtonBox textOnCancel=`닫기` onCancel={_ => close()} />
      </span>
    </RadixUI.Dialog.Content>
  </RadixUI.Dialog.Root>
}
