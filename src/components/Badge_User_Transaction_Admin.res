@react.component
let make = (~status: CustomHooks.QueryUser.Buyer.status) => {
  open CustomHooks.QueryUser.Buyer

  let displayStyle = switch status {
  | CanOrder =>
    %twc("max-w-min bg-primary-light py-0.5 px-2 text-primary rounded mr-2 whitespace-nowrap")
  | CanNotOrder =>
    %twc("max-w-min bg-enabled-L5 py-0.5 px-2 text-enabled-L1 rounded mr-2 whitespace-nowrap")
  }

  let displayText = status->Converter.displayUserBuyerStatus

  <span className=displayStyle> {displayText->React.string} </span>
}
