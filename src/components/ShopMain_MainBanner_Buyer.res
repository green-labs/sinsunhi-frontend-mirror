/*
 * 1. 컴포넌트 위치
 *    바이어 메인 - 화면 상단 슬라이드 배너
 *
 * 2. 역할
 *    이벤트 배너 정 보를 Swiper 형태로 표현합니다.
 *
 */
@module("../../public/assets/arrow-white-left.svg")
external arrowWhiteLeftIcon: string = "default"

module Fragment = %relay(`
  fragment ShopMainMainBannerBuyerFragment on Query {
    mainBanners {
      id
      imageUrlPc
      isNewTabPc
      imageUrlMobile
      isNewTabMobile
      landingUrl
    }
  }
`)
module PC = {
  module PrevBtn = {
    @react.component
    let make = (~onClick=?) => {
      let handleClick = _ => onClick->Option.map(onClick' => onClick'())->ignore
      <button
        onClick={handleClick} className=%twc("absolute z-[5] left-3 top-1/2 translate-y-[-50%]")>
        <img src=arrowWhiteLeftIcon />
      </button>
    }
  }

  module NextBtn = {
    @react.component
    let make = (~onClick=?) => {
      let handleClick = _ => onClick->Option.map(onClick' => onClick'())->ignore
      <button
        onClick={handleClick}
        className=%twc("absolute rotate-180 z-[5] right-3 top-1/2 translate-y-[-50%]")>
        <img src=arrowWhiteLeftIcon />
      </button>
    }
  }

  module PageIndex = {
    @react.component
    let make = (~total, ~current) => {
      <div
        className=%twc(
          "absolute bottom-3 right-3 rounded-full bg-gray-800 bg-opacity-20 px-4 py-1 flex items-center justify-center"
        )>
        <span className=%twc("text-white text-2xs")>
          {`${(current + 1)->Int.toString} / ${total->Int.toString}`->React.string}
        </span>
      </div>
    }
  }

  module Dots = {
    @react.component
    let make = (~total, ~current) => {
      <div className=%twc("absolute left-1/2 bottom-5 translate-x-[-50%] flex items-center gap-2")>
        {Array.range(0, total - 1)
        ->Array.map(idx => {
          let style =
            current == idx
              ? %twc("w-2 h-2 rounded-full bg-white bg-opacity-70")
              : %twc("w-2 h-2 rounded-full bg-white bg-opacity-50")
          <div key={`banner-dot-${idx->Int.toString}`} className=style />
        })
        ->React.array}
      </div>
    }
  }

  module Placeholder = {
    @react.component
    let make = () => {
      <div className=%twc("w-[920px] aspect-[920/396] animate-pulse rounded-lg bg-gray-150") />
    }
  }

  @react.component
  let make = (~query) => {
    let {mainBanners} = Fragment.use(query)
    let total = mainBanners->Array.length

    let (current, setCurrent) = React.Uncurried.useState(_ => 0)
    let afterChange = changedTo => setCurrent(._ => changedTo)

    <div className=%twc("relative")>
      <SlickSlider
        infinite=true
        slidesToShow=1
        slidesToScroll=1
        dots=false
        arrows=true
        autoplay=true
        autoplaySpeed=5000
        prevArrow={<PrevBtn />}
        nextArrow={<NextBtn />}
        afterChange>
        {switch mainBanners {
        | [] => <Placeholder />
        | _ =>
          mainBanners
          ->Array.map(({id, imageUrlPc, isNewTabPc, landingUrl}) => {
            let key = `main-banner-${id}`
            let target = isNewTabPc ? "_blank" : "_self"
            <a key href=landingUrl target>
              <img
                src=imageUrlPc
                className=%twc("w-full aspect-[920/396] mb-[-7px] object-cover")
                alt=key
              />
            </a>
          })
          ->React.array
        }}
      </SlickSlider>
      <PageIndex current total />
      <Dots current total />
    </div>
  }
}

module MO = {
  module Placeholder = {
    @react.component
    let make = () => {
      <div className=%twc("w-full aspect-[320/164] animate-pulse rounded-lg bg-gray-150") />
    }
  }

  module PageIndex = {
    @react.component
    let make = (~total, ~current) => {
      <div
        className=%twc(
          "absolute bottom-3 right-3 rounded-full bg-gray-800 bg-opacity-20 px-2 py-0.5 flex items-center justify-center"
        )>
        <span className=%twc("text-white text-2xs")>
          {`${(current + 1)->Int.toString} / ${total->Int.toString}`->React.string}
        </span>
      </div>
    }
  }

  module Dots = {
    @react.component
    let make = (~total, ~current) => {
      <div
        className=%twc("absolute left-1/2 bottom-3 translate-x-[-50%] flex items-center gap-[6px]")>
        {Array.range(0, total - 1)
        ->Array.map(idx => {
          let style =
            current == idx
              ? %twc("w-[6px] h-[6px] rounded-full bg-white bg-opacity-70")
              : %twc("w-[6px] h-[6px] rounded-full bg-white bg-opacity-50")
          <div key={`banner-dot-${idx->Int.toString}`} className=style />
        })
        ->React.array}
      </div>
    }
  }

  @react.component
  let make = (~query) => {
    let {mainBanners} = Fragment.use(query)
    let total = mainBanners->Array.length

    let (current, setCurrent) = React.Uncurried.useState(_ => 0)
    let afterChange = changedTo => setCurrent(._ => changedTo)

    <div className=%twc("relative")>
      <SlickSlider
        infinite=true
        slidesToShow=1
        slidesToScroll=1
        dots=false
        arrows=false
        autoplay=true
        autoplaySpeed=5000
        afterChange>
        {switch mainBanners {
        | [] => <Placeholder />
        | _ =>
          mainBanners
          ->Array.map(({id, imageUrlMobile, isNewTabMobile, landingUrl}) => {
            let key = `main-banner-${id}`
            let target = isNewTabMobile ? "_blank" : "_self"
            <a key href=landingUrl target>
              <img
                src=imageUrlMobile
                className=%twc("w-full aspect-[320/164] mb-[-7px] object-cover")
                alt=key
              />
            </a>
          })
          ->React.array
        }}
      </SlickSlider>
      <PageIndex current total />
      <Dots current total />
    </div>
  }
}
