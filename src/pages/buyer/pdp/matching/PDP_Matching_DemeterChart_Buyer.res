module Fragment = %relay(`
  fragment PDPMatchingDemeterChartBuyer_fragment on MarketPricesPerPriceGroup {
    high {
      dealingDate
      higher
      mean
      lower
    }
    medium {
      dealingDate
      higher
      mean
      lower
    }
    low {
      dealingDate
      higher
      mean
      lower
    }
  }
`)

module ChartParser = {
  type marketPrice = {
    dealingDate: string,
    higher: option<int>,
    mean: option<int>,
    lower: option<int>,
  }

  type input = array<marketPrice>

  type chartData = {
    dates: array<string>,
    highers: array<option<float>>,
    means: array<option<float>>,
    lowers: array<option<float>>,
  }

  let makeChartData = (raw: input, representativeWeight) => {
    let init = (list{}, list{}, list{}, list{})

    let (dateList, higherList, meanList, lowerList) = raw->Array.reduce(init, (prev, curr) => {
      let (prevDates, prevHighers, prevMeans, prevLowers) = prev

      (
        list{curr.dealingDate->DateFns.parseISO->DateFns.format("M.dd"), ...prevDates},
        list{curr.higher->Option.map(i => i->Int.toFloat *. representativeWeight), ...prevHighers},
        list{curr.mean->Option.map(i => i->Int.toFloat *. representativeWeight), ...prevMeans},
        list{curr.lower->Option.map(i => i->Int.toFloat *. representativeWeight), ...prevLowers},
      )
    })

    {
      dates: dateList->List.reverse->List.toArray,
      highers: higherList->List.reverse->List.toArray,
      means: meanList->List.reverse->List.toArray,
      lowers: lowerList->List.reverse->List.toArray,
    }
  }
}

@react.component
let make = (~query, ~selectedGroup, ~representativeWeight) => {
  let {high, medium, low} = query->Fragment.use
  let chartId = "pdp-demeter-chart"
  let instance = Echarts.useInstance(~id=chartId)

  let makeOption = (data: ChartParser.chartData) => {
    let {dates, highers, means, lowers} = data

    Echarts.Instance.option(
      ~tooltip=Echarts.Instance.ChartOption({
        "trigger": "axis",
        "backgroundColor": "rgba(38,38,38,1)",
        "textStyle": {
          "color": "rgba(255, 255, 255, 1)",
        },
      }),
      ~grid=Echarts.Instance.ChartOption({
        "right": "16px",
        "left": "50px",
      }),
      ~xAxis=Echarts.Instance.ChartOption({
        "boundaryGap": false,
        "data": dates,
        "axisTick": {"show": false},
        "axisPointer": {
          "show": true,
        },
      }),
      ~yAxis=Echarts.Instance.ChartOption({
        "type": "value",
      }),
      ~series=[
        Echarts.Instance.ChartOption({
          "type": "line",
          "name": "",
          "data": highers,
          "connectNulls": true,
          "itemStyle": {"color": "#ff5735"},
          "lineStyle": {"color": "#ff5735"},
        }),
        Echarts.Instance.ChartOption({
          "type": "line",
          "name": "",
          "data": means,
          "connectNulls": true,
          "itemStyle": {"color": "#12b564"},
          "lineStyle": {"color": "#12b564"},
        }),
        Echarts.Instance.ChartOption({
          "type": "line",
          "name": "",
          "data": lowers,
          "connectNulls": true,
          "itemStyle": {"color": "#2751c4"},
          "lineStyle": {"color": "#2751c4"},
        }),
      ],
      (),
    )
  }

  let highChartDataOption =
    high
    ->Array.map(price => {
      open ChartParser
      {
        dealingDate: price.dealingDate,
        higher: price.higher,
        mean: price.mean,
        lower: price.lower,
      }
    })
    ->ChartParser.makeChartData(representativeWeight)
    ->makeOption

  let lowChartDataOption =
    low
    ->Array.map(price => {
      open ChartParser
      {
        dealingDate: price.dealingDate,
        higher: price.higher,
        mean: price.mean,
        lower: price.lower,
      }
    })
    ->ChartParser.makeChartData(representativeWeight)
    ->makeOption

  let mediumChartDataOption =
    medium
    ->Array.map(price => {
      open ChartParser
      {
        dealingDate: price.dealingDate,
        higher: price.higher,
        mean: price.mean,
        lower: price.lower,
      }
    })
    ->ChartParser.makeChartData(representativeWeight)
    ->makeOption

  React.useEffect5(_ => {
    let newOption = switch selectedGroup {
    | "high" => highChartDataOption
    | "low" => lowChartDataOption
    | "medium" => mediumChartDataOption
    | _ => highChartDataOption
    }

    switch instance {
    | Some(instance') =>
      instance'->Echarts.Instance.setOption(~option=newOption, ~noMerge=false, ~lazyUpdate=false)
    | None => ()
    }

    None
  }, (selectedGroup, instance, highChartDataOption, lowChartDataOption, mediumChartDataOption))

  <Echarts id=chartId className=%twc("w-full h-[400px] px-3") option={highChartDataOption} />
}
