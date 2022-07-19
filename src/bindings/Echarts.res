module Components = {
  @module("echarts/components")
  external gridComponent: {..} = "GridComponent"
  @module("echarts/components")
  external tooltipComponent: {..} = "TooltipComponent"
  @module("echarts/components")
  external toolboxComponent: {..} = "ToolboxComponent"
  @module("echarts/components")
  external titleComponent: {..} = "TitleComponent"
}
module Renderers = {
  @module("echarts/renderers")
  external canvasRenderer: {..} = "CanvasRenderer"
  @module("echarts/renderers")
  external svgRenderer: {..} = "SVGRenderer"
}

module Charts = {
  @module("echarts/charts")
  external customChart: {..} = "CustomChart"
  @module("echarts/charts")
  external barChart: {..} = "BarChart"
  @module("echarts/charts")
  external lineChart: {..} = "LineChart"
}

module Instance = {
  type t

  @unboxed
  type rec chartOption = ChartOption({..}): chartOption

  @deriving({abstract: light})
  type option = {
    @optional
    title: {"text": string},
    @optional
    tooltip: chartOption,
    @optional
    toolbox: chartOption,
    @optional
    grid: chartOption,
    @optional
    dataZoom: array<chartOption>,
    @optional
    xAxis: chartOption,
    @optional
    yAxis: chartOption,
    @optional
    dataset: chartOption,
    @optional
    series: array<chartOption>,
  }

  @send
  external resize: t => unit = "resize"

  @send
  external setOption: (t, ~option: option, ~noMerge: bool, ~lazyUpdate: bool) => unit = "setOption"
}

type t
@module external echarts: t = "echarts/core"

type initOption = {renderer: [#svg | #canvas]}

@send
external init: (t, Dom.element, ~theme: string=?, ~opts: initOption=?, unit) => Instance.t = "init"

@send
external dispose: (t, Instance.t) => unit = "dispose"

@send
external getInstanceByDom: (t, Dom.element) => option<Instance.t> = "getInstanceByDom"

@module("echarts/core")
external use: array<{..}> => unit = "use"

// Use components
// use must me used before make("init")
use([
  Components.tooltipComponent,
  Components.gridComponent,
  Charts.lineChart,
  Renderers.svgRenderer,
])

let useInstance = (~id) => {
  let (instance, setInstance) = React.Uncurried.useState(_ => None)

  React.useEffect0(_ => {
    open Webapi
    let target = Dom.document->Dom.Document.getElementById(id)

    let instance = switch target {
    | Some(target') => getInstanceByDom(echarts, target')
    | None => None
    }

    setInstance(._ => instance)
    None
  })

  instance
}

// INFO
// noMerge, lazyUpdate 기능이 필요하면 바인딩 추가
@react.component
let make = (~id, ~option, ~className) => {
  React.useEffect0(_ => {
    open Webapi
    let target = Dom.document->Dom.Document.getElementById(id)

    switch target {
    | Some(target') =>
      // init
      let instance = init(echarts, target', ~opts={renderer: #svg}, ())

      // resize handler
      let resizeHandler = (ins, _) => ins->Instance.resize
      Dom.window->Dom.Window.addEventListener("resize", resizeHandler(instance))

      //setOption
      instance->Instance.setOption(~option, ~noMerge=false, ~lazyUpdate=false)

      Some(
        _ => {
          Dom.window->Dom.Window.removeEventListener("resize", resizeHandler(instance))
          dispose(echarts, instance)
        },
      )

    | None => None
    }
  })

  <div id className />
}
