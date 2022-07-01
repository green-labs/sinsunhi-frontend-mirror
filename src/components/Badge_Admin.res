@react.component
let make = (~status, ~refundReason=?) => {
  open CustomHooks.OrdersAdmin

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

  module ConverterStatus = Converter.Status(CustomHooks.OrdersAdmin)
  module ConverterRefund = Converter.RefundReason(CustomHooks.OrdersAdmin)
  let displayText = status->ConverterStatus.displayStatus

  <span className=displayStyle>
    {displayText->React.string}
    {switch (status, refundReason) {
    | (REFUND, Some(refundReason')) =>
      `(${refundReason'
        ->Js.Json.string
        ->CustomHooks.OrdersAdmin.refundReason_decode
        ->Result.mapWithDefault("-", ConverterRefund.displayRefundReason)})`->React.string
    | _ => React.null
    }}
  </span>
}
