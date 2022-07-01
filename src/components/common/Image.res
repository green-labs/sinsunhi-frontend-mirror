module Placeholder = {
  let sm = "/images/empty-gray-square-sm-3x.png"
  let lg = "/images/empty-gray-square-lg-3x.png"
}

@react.component
let make = (~src, ~placeholder=?, ~className=?, ~alt=?) => {
  let (imgSrc, setImgSrc) = React.Uncurried.useState(_ => src)

  // 이미지 로드 중 에러가 발생한 경우 지정된 placeholder이미지를 보여준다. placeholder props가 전달되지 않은경우 아무것도 하지 않는다.
  let onError = _ => {
    placeholder->Option.map(placeholder' => setImgSrc(._ => placeholder'))->ignore
  }

  <img src=imgSrc onError ?className ?alt />
}
