@react.component
let make = (~status) => {
  open CustomHooks.Orders

  let displayStyle = switch status {
  | CREATE
  | PACKING
  | DEPARTURE
  | DELIVERING
  | NEGOTIATING =>
    %twc("max-w-min bg-green-gl-light py-0.5 px-2 text-green-gl rounded mr-2 whitespace-nowrap")
  | COMPLETE
  | CANCEL
  | ERROR
  | REFUND =>
    %twc("max-w-min bg-gray-gl py-0.5 px-2 text-gray-gl rounded mr-2 whitespace-nowrap")
  }

  module Converter = Converter.Status(CustomHooks.Orders)
  let displayText = status->Converter.displayStatus

  <span className=displayStyle> {displayText->React.string} </span>
}
