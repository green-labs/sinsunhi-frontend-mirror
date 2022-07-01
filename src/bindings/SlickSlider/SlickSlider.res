@module("react-slick") @react.component
external make: (
  ~dots: bool=?,
  ~infinite: bool=?,
  ~speed: int=?,
  ~slidesToShow: int=?,
  ~slidesToScroll: int=?,
  ~appendDots: 'dots => React.element=?,
  ~customPaging: int => React.element=?,
  ~dotsClass: string=?,
  ~draggable: bool=?,
  ~centerMode: bool=?,
  ~variableWidth: bool=?,
  ~className: string=?,
  ~centerPadding: string=?,
  ~autoplay: bool=?,
  ~autoplaySpeed: int=?,
  ~arrows: bool=?,
  ~nextArrow: React.element=?,
  ~prevArrow: React.element=?,
  ~children: React.element,
  ~beforeChange: unit => unit=?,
  ~afterChange: int => unit=?,
) => React.element = "default"