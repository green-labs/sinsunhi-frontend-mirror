module Placeholder = {
  let sm = "/images/empty-gray-square-sm-3x.png"
  let lg = "/images/empty-gray-square-lg-3x.png"
}

module Presenter = {
  @react.component
  let make = (~src=?, ~placeholder, ~className=?, ~alt=?) => {
    let (imgSrc, setImgSrc) = React.Uncurried.useState(_ => src)

    // 이미지 로드 중 에러가 발생한 경우 지정된 placeholder이미지를 보여준다. placeholder props가 전달되지 않은경우 아무것도 하지 않는다.
    let onError = _ => {
      setImgSrc(._ => Some(placeholder))->ignore
    }

    switch imgSrc {
    | Some(imgSrc') => <img src=imgSrc' onError ?className ?alt />
    | None => <img src=placeholder onError ?className ?alt />
    }
  }
}

// src가 갱신되었을 때 반응하도록 하기 위해 레이어를 감싸고 key=src 적용
@react.component
let make = (~src, ~placeholder, ~className, ~alt) =>
  <Presenter key=src src placeholder className alt />
