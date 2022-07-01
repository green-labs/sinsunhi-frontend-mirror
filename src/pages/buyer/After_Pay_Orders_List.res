module Mock = {
  // TODO: delete me
  type order = {
    paymentWithFees: float,
    payment: float,
    debt: float,
    loanFees: float,
    lateFees: float,
    debtDueDate: string,
    createdAt: string,
    state: string,
  }

  let order = {
    paymentWithFees: 10000000000.0,
    payment: 10000000000.0,
    debt: 10000000.0,
    loanFees: 200000.0,
    lateFees: 4000.0,
    debtDueDate: "2019-08-24",
    createdAt: "2019-08-24",
    state: `상환 완료`,
  }

  let orderShort = {
    paymentWithFees: 10000000000.0,
    payment: 10000.0,
    debt: 100.0,
    loanFees: 20.0,
    lateFees: 40.0,
    debtDueDate: "2019-08-24",
    createdAt: "2019-08-24",
    state: `상환 완료`,
  }

  let data = [order, order, orderShort, order]
}

module Th = {
  @react.component
  let make = (~children) => {
    <th className=%twc("font-normal p-2 bg-gray-50")> children </th>
  }
}

module Td = {
  let tdBorderBottom = %twc("p-3 border-b border-gray-200 ")

  @react.component
  let make = (~className=?, ~children) => {
    let mergedClassName = className->Belt.Option.getWithDefault("")
    <td className={tdBorderBottom ++ mergedClassName}> children </td>
  }
}

module List = {
  @react.component
  let make = (~data: array<CustomHooks.AfterPayOrdersList.order>) => {
    let makeDate = d =>
      d->Js.String2.split(" ")->Belt.Array.get(0)->Belt.Option.getWithDefault("-")->React.string

    <table className=%twc("text-[0.8125rem] w-[35rem]")>
      <thead>
        <tr>
          <Th> {`주문일`->React.string} </Th>
          <Th> {`나중결제 주문금액`->React.string} </Th>
          <Th> {`상환 필요 금액*`->React.string} </Th>
          <Th> {`만기일`->React.string} </Th>
          <Th> {`상환 상태`->React.string} </Th>
        </tr>
      </thead>
      <tbody>
        {data
        ->Belt.Array.mapWithIndex((i, order) => {
          // order.debt + order.lateFees + order.loanFees 를 서버에서 계산하여
          // order.paymentWithFees 값으로 내려주는 것으로 변경
          let _remain = order.debt +. order.lateFees +. order.loanFees
          let stateColor = switch order.state {
          | CustomHooks.AfterPayOrdersList.OVERDUE => %twc(" text-red-500")
          | _ => %twc("")
          }

          <tr key={i->Belt.Int.toString}>
            <Td className=%twc("text-center")> {order.createdAt->makeDate} </Td>
            <Td className=%twc("text-right")>
              {order.payment->Locale.Float.show(~digits=0)->React.string} {`원`->React.string}
            </Td>
            <Td className=%twc("text-right")>
              {order.paymentWithFees->Locale.Float.show(~digits=0)->React.string}
              {`원`->React.string}
            </Td>
            <Td className=%twc("text-center")> {order.debtDueDate->makeDate} </Td>
            <Td className={%twc("text-center") ++ stateColor}>
              {order.state->CustomHooks.AfterPayOrdersList.stateToString->React.string}
            </Td>
          </tr>
        })
        ->React.array}
      </tbody>
    </table>
  }
}

module Dialog = {
  @react.component
  let make = (~open_, ~children) => {
    <RadixUI.Dialog.Root _open=open_>
      <RadixUI.Dialog.Overlay className=%twc("dialog-overlay") />
      <RadixUI.Dialog.Content
        className=%twc(
          "w-fit shadow-[0px_10px_40px_10px_rgba(0,0,0,0.3)] rounded-2xl p-5 dialog-content-nosize"
        )>
        children
      </RadixUI.Dialog.Content>
    </RadixUI.Dialog.Root>
  }
}

module View = {
  let useFetchWithPrevios = page => {
    let fetchedData = CustomHooks.AfterPayOrdersList.use(page)
    let previous = React.useRef(CustomHooks.AfterPayOrdersList.Loading)
    React.useEffect1(() => {
      switch fetchedData {
      | Loading => ()
      | data' => previous.current = data'
      }
      None
    }, [fetchedData])

    switch fetchedData {
    | Loading => previous.current
    | Loaded(_) | Error(_) => fetchedData
    }
  }

  @react.component
  let make = (~setOpen) => {
    let (page, setPage) = React.Uncurried.useState(_ => 1)
    let data = useFetchWithPrevios(page)

    let handleClose = _ => {
      setOpen(._ => false)
    }

    let handleOnChangePage = e => {
      e->ReactEvent.Synthetic.preventDefault
      e->ReactEvent.Synthetic.stopPropagation

      let value = (e->ReactEvent.Synthetic.currentTarget)["value"]
      setPage(._ => value->Belt.Int.fromString->Belt.Option.getWithDefault(1))
    }

    let totalCount = switch data {
    | Loaded(list) => list.totalCount
    | _ => 0
    }

    <div className=%twc("flex flex-col items-center gap-7")>
      <div className=%twc("w-full flex items-center")>
        <div>
          <span className=%twc("text-xl font-bold")>
            {`나중결제 이용 내역`->React.string}
          </span>
          <span className=%twc("text-green-500")>
            {` ${totalCount->Belt.Int.toString}건`->React.string}
          </span>
        </div>
        <div className=%twc("ml-auto")>
          <button onClick=handleClose> <IconClose height="24" width="24" fill="#262626" /> </button>
        </div>
      </div>
      {switch data {
      | Loaded(list) => <>
          <div className=%twc("flex flex-col gap-2")>
            <List data=list.data />
            <div className=%twc("ml-auto text-[0.8125rem] text-gray-500")>
              {`*상환 필요 금액 : 수수료, 연체료 포함`->React.string}
            </div>
          </div>
          <Pagination.Template
            cur={page}
            pageDisplySize=5
            itemPerPage=list.size
            total=list.totalCount
            handleOnChangePage
          />
        </>
      | Loading => "loading"->React.string
      | Error(_) => React.null
      }}
    </div>
  }
}

@react.component
let make = (~open_, ~setOpen) => {
  <Dialog open_> <View setOpen /> </Dialog>
}
