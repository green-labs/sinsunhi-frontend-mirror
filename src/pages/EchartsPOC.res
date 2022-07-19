@react.component
let make = () => {
  let option = Echarts.Instance.option(
    ~xAxis=ChartOption({
      "type": "category",
      "data": ["5.1", "5.2", "5.3", "5.4"],
      "axisTick": {"show": false},
    }),
    ~tooltip=ChartOption({
      "trigger": "axis",
    }),
    ~toolbox=ChartOption({
      "show": true,
      "dataZoom": {
        "yAxisIndex": "none",
      },
    }),
    ~yAxis=ChartOption({"type": "value"}),
    ~series=[
      ChartOption({"type": "line", "name": "avg", "data": [4, 5, 6, 7, 8]}),
      ChartOption({"type": "line", "name": "min", "data": [1, 2, 3, 4, 5]}),
      ChartOption({"type": "line", "name": "max", "data": [10, 12, 13, 14, 15]}),
    ],
    (),
  )

  <Echarts id="echart-test" option className=%twc("w-full h-[800px]") />
}
