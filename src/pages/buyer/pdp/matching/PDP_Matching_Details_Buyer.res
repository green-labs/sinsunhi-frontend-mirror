/*
 * 1. 컴포넌트 위치
 *    PDP의 매칭상품 상세정보
 *
 * 2. 역할
 *    매칭 상품의 상세정보를 표현합니다
 *
 */

module Fragment = %relay(`
  fragment PDPMatchingDetailsBuyer_fragment on MatchingProduct {
    origin
    releaseStartMonth
    releaseEndMonth
  }
`)

module Card = {
  @react.component
  let make = (~label, ~value) => {
    <div className=%twc("p-3 border-gray-150 border rounded-lg flex flex-col")>
      <span className=%twc("text-xs text-gray-500")> {label->React.string} </span>
      <span className=%twc("mt-1 text-sm text-gray-800")> {value->React.string} </span>
    </div>
  }
}

@react.component
let make = (~query) => {
  let {origin, releaseStartMonth, releaseEndMonth} = query->Fragment.use

  let periodPabel = {
    `${releaseStartMonth->Int.toString}~${releaseEndMonth->Int.toString}월`
  }

  <section className=%twc("w-full py-6")>
    <h1 className=%twc("text-black font-bold text-lg")> {`상품 상세`->React.string} </h1>
    <ol className=%twc("mt-4 w-full flex overflow-x-scroll scrollbar-hide")>
      {origin
      ->Option.keep(origin' => origin' != "")
      ->Option.mapWithDefault(React.null, origin' => {
        <li className=%twc("mr-2")> <Card label=`원산지` value=origin' /> </li>
      })}
      <li> <Card label=`출하 시기` value=periodPabel /> </li>
    </ol>
  </section>
}
