module Select = {
  @react.component
  let make = (~t, ~values, ~onChange) =>
    <div>
      <label id="select-occupation" className=%twc("block text-sm font-medium text-gray-700") />
      <div className=%twc("relative")>
        <button
          type_="button"
          className=%twc(
            "relative w-48 bg-white border border-border-default-L1 rounded-lg py-2 px-3 focus:outline-none focus:ring-1-gl remove-spin-button focus:border-gray-gl"
          )>
          <span className=%twc("flex items-center text-text-L1")>
            <span className=%twc("block truncate")> {t->React.string} </span>
          </span>
          <span className=%twc("absolute top-1 right-3")>
            <IconArrowSelect height="28" width="28" fill="#121212" />
          </span>
        </button>
        <select className=%twc("absolute left-0 w-full py-3 opacity-0") value={t} onChange>
          {values
          ->Array.map(value => <option key=value value> {value->React.string} </option>)
          ->React.array}
        </select>
      </div>
    </div>
}

module TitleAndCloseButton = {
  @react.component
  let make = (~close) => {
    <div className=%twc("flex mb-5 md:mb-10 justify-between items-center")>
      <h3 className=%twc("font-bold text-xl")>
        {j`화물배송 운송비용 표`->React.string}
      </h3>
      <button onClick={_ => close()} className=%twc("cursor-pointer border-none")>
        <IconClose height="1.5rem" width="1.5rem" fill="#262626" />
      </button>
    </div>
  }
}

module TableRow = {
  let rec render = (l, isLeft) =>
    switch l {
    | Some(l') =>
      switch l'->List.head {
      | Some(l'') =>
        let (distance, price) = l''
        <>
          <div
            key={`${distance->Int.toString}-${price->Int.toString}`}
            className={cx([
              %twc(
                "flex w-full xl:w-1/2 justify-between items-center px-4 py-3 text-sm border-t-0 border-div-border-L2"
              ),
              isLeft ? %twc("border border-x-0 xl:border-r-[1px]") : %twc("border border-x-0"),
            ])}>
            <span> {`${distance->Int.toString}km미만`->React.string} </span>
            <span> {`${price->Locale.Int.show} 원`->React.string} </span>
          </div>
          {render(l'->List.tail, !isLeft)}
        </>
      | None => React.null
      }
    | None => React.null
    }
}

@react.component
let make = () => {
  let (weight, setWeight) = React.Uncurried.useState(_ =>
    Freight_Delivery_Cost_Table_Data.defaultOptionName
  )
  let tableData = Freight_Delivery_Cost_Table_Data.freightDeliveryCostData
  let selectOptions = tableData->Map.String.keysToArray

  let selectedValues = tableData->Map.String.get(weight)

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

  let handleOnChangeWeight = e => {
    let value = (e->ReactEvent.Synthetic.currentTarget)["value"]
    setWeight(._ => value)
  }

  <RadixUI.Dialog.Root>
    <RadixUI.Dialog.Overlay className=%twc("dialog-overlay") />
    <RadixUI.Dialog.Trigger>
      <span
        className=%twc(
          "w-28 h-9 flex justify-center items-center bg-background border border-div-border-L1 rounded-lg text-enabled-L2 text-[15px]"
        )>
        {`화물비 표 보기`->React.string}
      </span>
    </RadixUI.Dialog.Trigger>
    <RadixUI.Dialog.Content
      className=%twc(
        "dialog-content-fix p-5 overflow-y-auto text-sm text-text-L1 rounded-2xl min-w-max"
      )>
      <TitleAndCloseButton close />
      <div className=%twc("flex items-center gap-4")>
        <span className=%twc("text-sm font-bold text-text-L1 min-w-fit")>
          {`화물 무게`->React.string}
        </span>
        <Select t=weight onChange=handleOnChangeWeight values=selectOptions />
      </div>
      <div className=%twc("flex mt-4 w-full h-9 bg-div-shape-L2")>
        <div
          className=%twc(
            "flex flex-1 px-4 items-center justify-between border-div-border-L2 border border-y-0 border-x-0 xl:border-r-[1px]"
          )>
          <span> {`거리`->React.string} </span> <span> {`금액`->React.string} </span>
        </div>
        <div className=%twc("hidden xl:flex flex-1 px-4 items-center justify-between")>
          <span> {`거리`->React.string} </span> <span> {`금액`->React.string} </span>
        </div>
      </div>
      <div className=%twc("flex flex-wrap")> {selectedValues->TableRow.render(true)} </div>
      <RadixUI.Dialog.Close id="btn-close" className=%twc("hidden")>
        {j``->React.string}
      </RadixUI.Dialog.Close>
      <span className=%twc("md:hidden")>
        <Dialog.ButtonBox textOnCancel=`닫기` onCancel={_ => close()} />
      </span>
    </RadixUI.Dialog.Content>
  </RadixUI.Dialog.Root>
}
