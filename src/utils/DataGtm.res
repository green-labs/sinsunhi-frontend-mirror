@val @scope("window") @return(nullable)
external dataLayer: option<Js.Array2.t<{..}>> = "dataLayer"

let push = (data: {..}) => {
  switch dataLayer {
  | Some(layer) => layer->Js.Array2.push(data)->ignore
  | None => Js.Console.error("window.dataLayer is not defined")
  }
}

@react.component
let make = (~children, ~dataGtm: string) => {
  <ReactUtil.SpreadProps props={"data-gtm": dataGtm}> {children} </ReactUtil.SpreadProps>
}
