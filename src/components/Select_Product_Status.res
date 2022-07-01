type status = ALL | SALE | SOLDOUT | HIDDEN_SALE | NOSALE | RETIRE | HIDDEN

let encodeStatus = status =>
  switch status {
  | ALL => `ALL`
  | SALE => `SALE`
  | SOLDOUT => `SOLDOUT`
  | HIDDEN_SALE => `HIDDEN_SALE`
  | NOSALE => `NOSALE`
  | RETIRE => `RETIRE`
  | HIDDEN => `HIDDEN`
  }
let decodeStatus = status =>
  if status === "ALL" {
    ALL->Some
  } else if status === "SALE" {
    SALE->Some
  } else if status === "SOLDOUT" {
    SOLDOUT->Some
  } else if status === "HIDDEN_SALE" {
    HIDDEN_SALE->Some
  } else if status === "NOSALE" {
    NOSALE->Some
  } else if status === "RETIRE" {
    RETIRE->Some
  } else if status === "HIDDEN" {
    HIDDEN->Some
  } else {
    None
  }
let parseStatus = q =>
  q->Js.Dict.get("status")->Option.flatMap(decodeStatus)->Option.getWithDefault(ALL)
let formatStatus = status =>
  switch status {
  | ALL => `전체`
  | SALE => `판매중`
  | SOLDOUT => `품절`
  | HIDDEN_SALE => `전신판매숨김`
  | NOSALE => `숨김`
  | RETIRE => `영구판매중지`
  | HIDDEN => `숨김`
  }

@react.component
let make = (~status, ~onChange) => {
  let displayStatus = status->formatStatus

  <span>
    <label className=%twc("block relative")>
      <span
        className=%twc(
          "md:w-44 flex items-center border border-border-default-L1 bg-white rounded-md h-9 px-3 text-enabled-L1"
        )>
        {displayStatus->React.string}
      </span>
      <span className=%twc("absolute top-1.5 right-2")>
        <IconArrowSelect height="24" width="24" fill="#121212" />
      </span>
      <select
        value={status->encodeStatus}
        className=%twc("block w-full h-full absolute top-0 opacity-0")
        onChange>
        {[ALL, SALE, SOLDOUT]
        ->Garter.Array.map(s =>
          <option key={s->encodeStatus} value={s->encodeStatus}>
            {s->formatStatus->React.string}
          </option>
        )
        ->React.array}
      </select>
    </label>
  </span>
}
