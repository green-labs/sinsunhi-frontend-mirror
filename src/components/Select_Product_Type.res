@spice
type status = | @spice.as(`일반상품`) NORMAL | @spice.as(`견적상품`) QUOTED

let toString = status => status->status_encode->Js.Json.decodeString->Option.getWithDefault("")

@react.component
let make = (~status, ~onChange) => {
  <div className=%twc("bg-bg-pressed-L2 w-full p-2 rounded-xl ")>
    <div className=%twc("p-1 relative flex")>
      <div
        className={cx([
          %twc("absolute bg-white top-0 h-full w-1/2 rounded-lg"),
          status == NORMAL ? %twc("left-0") : %twc("left-1/2"),
        ])}
      />
      <div
        className={cx([
          %twc("text-center py-2 px-6 flex-1 z-10 cursor-pointer"),
          status == NORMAL ? %twc("text-text-L1") : %twc("text-text-L2"),
        ])}
        onClick={_ => onChange(NORMAL)}>
        {NORMAL->toString->React.string}
      </div>
      <div
        className={cx([
          %twc("text-center py-2 px-6 flex-1 z-10 cursor-pointer"),
          status == NORMAL ? %twc("text-text-L2") : %twc("text-text-L1"),
        ])}
        onClick={_ => onChange(QUOTED)}>
        {QUOTED->toString->React.string}
      </div>
    </div>
  </div>
}

module Search = {
  @spice
  type status =
    | @spice.as(`ALL`) ALL
    | @spice.as(`NORMAL`) NORMAL
    | @spice.as(`QUOTED`) QUOTED
    | @spice.as(`QUOTABLE`) QUOTABLE

  let toString = status => status->status_encode->Js.Json.decodeString->Option.getWithDefault(`ALL`)

  let toDisplayName = status =>
    switch status {
    | ALL => `전체`
    | NORMAL => `일반상품`
    | QUOTED => `견적상품`
    | QUOTABLE => `일반+견적상품`
    }

  let defaultStyle = %twc(
    "flex px-3 py-2 border items-center border-border-default-L1 rounded-lg h-9 text-enabled-L1 focus:outline bg-white"
  )

  @react.component
  let make = (~status, ~onChange) => {
    let value = status->toString

    let handleProductOperationStatus = e => {
      let status = (e->ReactEvent.Synthetic.target)["value"]

      switch status->status_decode {
      | Ok(status') => onChange(status')
      | _ => ignore()
      }
    }

    <span>
      <label className=%twc("block relative")>
        <span className=defaultStyle> {status->toDisplayName->React.string} </span>
        <span className=%twc("absolute top-1.5 right-2")>
          <IconArrowSelect height="24" width="24" fill="#121212" />
        </span>
        <select
          value={value}
          className=%twc("block w-full h-full absolute top-0 opacity-0")
          onChange={handleProductOperationStatus}>
          <option value="" disabled=true hidden={value == "" ? false : true}>
            {`운영상태 선택`->React.string}
          </option>
          {[ALL, NORMAL, QUOTED, QUOTABLE]
          ->Array.map(s => {
            let value = s->toString
            <option key={value} value> {s->toDisplayName->React.string} </option>
          })
          ->React.array}
        </select>
      </label>
    </span>
  }
}
