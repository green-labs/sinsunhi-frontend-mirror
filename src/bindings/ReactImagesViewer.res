type image = {
  src: option<string>,
  // srcset: option<string>,
  // caption: option<string>,
  // thumbnail: option<string>,
}

@module("react-images-viewer") @react.component
external make: (
  ~imgs: array<image>,
  ~isOpen: bool,
  ~onClickPrev: unit => unit,
  ~onClickNext: unit => unit,
  ~onClose: unit => unit,
  ~onClickThumbnail: int => unit=?,
  ~showThumbnails: bool=?,
  ~width: int=?,
  ~currImg: int=?,
) => React.element = "default"
