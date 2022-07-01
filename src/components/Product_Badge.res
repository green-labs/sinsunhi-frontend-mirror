// 바이어 전시 페이지 론칭 후 삭제 예정
@react.component
let make = (~status) => {
  open CustomHooks.Products

  let displayStyle = switch status {
  | SALE =>
    %twc("max-w-min bg-green-gl-light py-0.5 px-2 text-green-gl rounded mr-2 whitespace-nowrap")
  | SOLDOUT => %twc("max-w-min bg-gray-gl py-0.5 px-2 text-gray-gl rounded mr-2 whitespace-nowrap")
  | HIDDEN_SALE
  | NOSALE
  | HIDDEN
  | RETIRE =>
    %twc("max-w-min bg-gray-gl py-0.5 px-2 text-gray-gl rounded mr-2 whitespace-nowrap")
  }

  module Converter = Converter.SalesStatus(CustomHooks.Products)
  let displayText = status->Converter.statusToString

  <span className=displayStyle> {displayText->React.string} </span>
}

module V2 = {
  @spice
  type status = SALE | SOLDOUT | HIDDEN_SALE | NOSALE | RETIRE

  @react.component
  let make = (~status: status) => {
    let displayText = switch status {
    | SALE => `판매중`
    | SOLDOUT => `품절`
    | HIDDEN_SALE => `전시숨김`
    | NOSALE => `숨김`
    | RETIRE => `영구판매중지`
    }

    let displayStyle = switch status {
    | SALE =>
      %twc("max-w-min bg-green-gl-light py-0.5 px-2 text-green-gl rounded mr-2 whitespace-nowrap")
    | SOLDOUT =>
      %twc("max-w-min bg-gray-gl py-0.5 px-2 text-gray-gl rounded mr-2 whitespace-nowrap")
    | HIDDEN_SALE
    | NOSALE
    | RETIRE =>
      %twc("max-w-min bg-gray-gl py-0.5 px-2 text-gray-gl rounded mr-2 whitespace-nowrap")
    }

    <span className=displayStyle> {displayText->React.string} </span>
  }
}
