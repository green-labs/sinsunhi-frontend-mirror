open CustomHooks.Costs

let toString = (t: contractType) => t->contractType_encode->Js.Json.decodeString

let toContractTypeDisplay = str =>
  switch str {
  | "bulk-sale" => `전량구매`
  | "online" => `온라인`
  | _ => `온라인`
  }

@react.component
let make = (~contractType: contractType, ~onChange) => {
  <>
    <span
      className=%twc(
        "flex items-center border border-border-default-L1 rounded-lg py-1.5 px-3 text-enabled-L1 bg-white leading-4.5"
      )>
      {contractType
      ->toString
      ->Option.mapWithDefault(`온라인`, toContractTypeDisplay)
      ->React.string}
    </span>
    <span className=%twc("absolute top-3.5 right-5")>
      <IconArrowSelect height="24" width="24" fill="#121212" />
    </span>
    <select
      id="new-isBulksale"
      value={contractType->toString->Option.getWithDefault("online")}
      className=%twc("block w-full h-full absolute top-0 opacity-0")
      onChange>
      <option value={Online->toString->Option.getWithDefault("online")}>
        {j`온라인`->React.string}
      </option>
      <option value={Bulksale->toString->Option.getWithDefault("bulk-sale")}>
        {j`전량구매`->React.string}
      </option>
    </select>
  </>
}
