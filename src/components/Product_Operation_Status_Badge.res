module Fragment = %relay(`
  fragment ProductOperationStatusBadge on Product {
    status
  }
`)

@react.component
let make = (~query) => {
  let {status} = Fragment.use(query)

  let displayStyle = switch status {
  | #SALE =>
    %twc("max-w-min bg-green-gl-light py-0.5 px-2 text-green-gl rounded mr-2 whitespace-nowrap")
  | #SOLDOUT
  | #HIDDEN_SALE
  | #NOSALE
  | #RETIRE
  | _ =>
    %twc("max-w-min bg-gray-gl py-0.5 px-2 text-gray-gl rounded mr-2 whitespace-nowrap")
  }

  let displayText = switch status {
  | #SALE => `판매중`
  | #SOLDOUT => `품절`
  | #HIDDEN_SALE => `전시판매숨김`
  | #NOSALE => `숨김`
  | #RETIRE => `영구판매중지`
  | _ => `상태를 표시할 수 없습니다.`
  }

  <span className={displayStyle}> {displayText->React.string} </span>
}
