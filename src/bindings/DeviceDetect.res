type selector = {isMobile: bool}
type deviceType =
  | Unknown
  | PC
  | Mobile

@module("react-device-detect")
external getSelectorsByUserAgent: string => selector = "getSelectorsByUserAgent"

@module("react-device-detect") @val
external isMobile: bool = "isMobile"

let detectDeviceFromCtx = ctx => {
  let pick = (k, dict) => dict->Js.Dict.get(k)

  let selector =
    ctx
    ->Option.mapWithDefault(None, "req"->pick)
    ->Option.mapWithDefault(None, "headers"->pick)
    ->Option.mapWithDefault(None, "user-agent"->pick)
    ->Option.map(getSelectorsByUserAgent)

  switch selector {
  | Some({isMobile}) if isMobile == true => Mobile
  | Some({isMobile}) if isMobile == false => PC
  | _ => Unknown
  }
}

let detectDevice = () => {
  switch isMobile {
  | true => Mobile
  | false => PC
  }
}
