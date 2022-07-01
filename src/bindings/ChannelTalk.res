@val @scope("window")
external make: (. string, {..}) => unit = "ChannelIO"

@val @scope("window")
external makeWithCallback: (. string, {..}, (_, {..}) => unit) => unit = "ChannelIO"

@val @scope("window")
external track: (. string, string, {..}) => unit = "ChannelIO"

@val @scope("window")
external do: (. [#shutdown | #showMessenger | #showChannelButton | #hideChannelButton]) => unit =
  "ChannelIO"

let shutdown = () => do(. #shutdown)
let showMessenger = () => do(. #showMessenger)
let showChannelButton = () => do(. #showChannelButton)
let hideChannelButton = () => do(. #hideChannelButton)
//   type currentView =
