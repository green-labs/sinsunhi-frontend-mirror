module Fragment = %relay(`
  fragment PDPMatchingDemeterTableBuyer_fragment on MarketPricesPerPriceGroup {
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

module TableParser = {
  type marketPrice = {
    dealingDate: string,
    higher: option<int>,
    mean: option<int>,
    lower: option<int>,
  }

  type input = array<marketPrice>

  type tableData = {
    higherMax: option<float>,
    higherMin: option<float>,
    meanMax: option<float>,
    meanMin: option<float>,
    lowerMax: option<float>,
    lowerMin: option<float>,
  }

  let makeTableData = (raw: input, representativeWeight) => {
    higherMax: raw
    ->Array.keepMap(r => r.higher)
    ->(arr => arr->Garter.Array.isEmpty ? None : Some(arr))
    ->Option.map(arr => arr->Array.reduce(min_int, max))
    ->Option.map(max => max->Int.toFloat *. representativeWeight),
    higherMin: raw
    ->Array.keepMap(r => r.higher)
    ->(arr => arr->Garter.Array.isEmpty ? None : Some(arr))
    ->Option.map(arr => arr->Array.reduce(max_int, min))
    ->Option.map(min => min->Int.toFloat *. representativeWeight),
    meanMax: raw
    ->Array.keepMap(r => r.mean)
    ->(arr => arr->Garter.Array.isEmpty ? None : Some(arr))
    ->Option.map(arr => arr->Array.reduce(min_int, max))
    ->Option.map(max => max->Int.toFloat *. representativeWeight),
    meanMin: raw
    ->Array.keepMap(r => r.mean)
    ->(arr => arr->Garter.Array.isEmpty ? None : Some(arr))
    ->Option.map(arr => arr->Array.reduce(max_int, min))
    ->Option.map(min => min->Int.toFloat *. representativeWeight),
    lowerMax: raw
    ->Array.keepMap(r => r.lower)
    ->(arr => arr->Garter.Array.isEmpty ? None : Some(arr))
    ->Option.map(arr => arr->Array.reduce(min_int, max))
    ->Option.map(max => max->Int.toFloat *. representativeWeight),
    lowerMin: raw
    ->Array.keepMap(r => r.lower)
    ->(arr => arr->Garter.Array.isEmpty ? None : Some(arr))
    ->Option.map(arr => arr->Array.reduce(max_int, min))
    ->Option.map(min => min->Int.toFloat *. representativeWeight),
  }
}

@react.component
let make = (~query, ~selectedGroup, ~representativeWeight) => {
  let {high, medium, low} = query->Fragment.use

  let highTableData =
    high
    ->Array.map(price => {
      open TableParser
      {
        dealingDate: price.dealingDate,
        higher: price.higher,
        mean: price.mean,
        lower: price.lower,
      }
    })
    ->TableParser.makeTableData(representativeWeight)

  let lowTableData =
    low
    ->Array.map(price => {
      open TableParser
      {
        dealingDate: price.dealingDate,
        higher: price.higher,
        mean: price.mean,
        lower: price.lower,
      }
    })
    ->TableParser.makeTableData(representativeWeight)

  let mediumTableData =
    medium
    ->Array.map(price => {
      open TableParser
      {
        dealingDate: price.dealingDate,
        higher: price.higher,
        mean: price.mean,
        lower: price.lower,
      }
    })
    ->TableParser.makeTableData(representativeWeight)

  let {higherMax, higherMin, meanMax, meanMin, lowerMax, lowerMin} = switch selectedGroup {
  | "high" => highTableData
  | "medium" => mediumTableData
  | "low" => lowTableData
  | _ => highTableData
  }

  <div>
    <div className=%twc("px-5 grid grid-rows-4 grid-flow-col mb-2")>
      <div className=%twc("grid grid-cols-4 grid-flow-row pb-1 border-b")>
        <div className=%twc("col-start-3 text-right")> {`주간 최고`->React.string} </div>
        <div className=%twc("col-start-4 text-right")> {`주간 최저`->React.string} </div>
      </div>
      <div className=%twc("grid grid-cols-4 grid-flow-row py-2")>
        <div className=%twc("text-left inline-flex items-center")>
          <div className=%twc("w-2 h-2 rounded-full bg-orange-500 mr-1") />
          {`최대가`->React.string}
        </div>
        <div className=%twc("col-start-3 text-right")>
          <span className=%twc("font-bold")>
            {`${higherMax
              ->Option.map(Locale.Float.show(~digits=0))
              ->Option.getWithDefault("-")}원`->React.string}
          </span>
        </div>
        <div className=%twc("col-start-4 text-right")>
          <span className=%twc("font-bold")>
            {`${higherMin
              ->Option.map(Locale.Float.show(~digits=0))
              ->Option.getWithDefault("-")}원`->React.string}
          </span>
        </div>
      </div>
      <div className=%twc("grid grid-cols-4 grid-flow-row py-2")>
        <div className=%twc("text-left inline-flex items-center")>
          <div className=%twc("w-2 h-2 rounded-full bg-green-500 mr-1") />
          {`평균가`->React.string}
        </div>
        <div className=%twc("col-start-3 text-right")>
          <span className=%twc("font-bold")>
            {`${meanMax
              ->Option.map(Locale.Float.show(~digits=0))
              ->Option.getWithDefault("-")}원`->React.string}
          </span>
        </div>
        <div className=%twc("col-start-4 text-right")>
          <span className=%twc("font-bold")>
            {`${meanMin
              ->Option.map(Locale.Float.show(~digits=0))
              ->Option.getWithDefault("-")}원`->React.string}
          </span>
        </div>
      </div>
      <div className=%twc("grid grid-cols-4 grid-flow-row py-2")>
        <div className=%twc("text-left inline-flex items-center")>
          <div className=%twc("w-2 h-2 rounded-full bg-blue-500 mr-1") />
          {`최소가`->React.string}
        </div>
        <div className=%twc("col-start-3 text-right")>
          <span className=%twc("font-bold")>
            {`${lowerMax
              ->Option.map(Locale.Float.show(~digits=0))
              ->Option.getWithDefault("-")}원`->React.string}
          </span>
        </div>
        <div className=%twc("col-start-4 text-right")>
          <span className=%twc("font-bold")>
            {`${lowerMin
              ->Option.map(Locale.Float.show(~digits=0))
              ->Option.getWithDefault("-")}원`->React.string}
          </span>
        </div>
      </div>
    </div>
    <div className=%twc("text-right text-xs text-gray-500 px-5")>
      {`농림수산부식품교육문화정보원`->React.string}
      <br />
      {`전국 도매시장 평균 거래가`->React.string}
    </div>
  </div>
}
