/*
 * 1. 컴포넌트 위치
 *    바이어 메인 - 화면 상단 우측 기획전 리스트
 *
 * 2. 역할
 *    기획전 정보를 리스트 형태로 표현합니다.
 *
 */
module Fragment = %relay(`
  fragment ShopMainSubBannerBuyer on Query {
    subBanners {
      id
      imageUrlPc
      imageUrlMobile
      landingUrl
      isNewTabPc
      isNewTabMobile
    }
  }
`)

module PC = {
  module Placeholder = {
    @react.component
    let make = () => {
      <div className=%twc("w-full flex flex-col gap-3")>
        {[1, 2, 3]
        ->Array.map(idx => {
          <div
            key={`sub-banner-skeleton-${idx->Int.toString}`}
            className=%twc("flex flex-1 aspect-[300/124] rounded-xl animate-pulse bg-gray-150")
          />
        })
        ->React.array}
      </div>
    }
  }

  @react.component
  let make = (~query) => {
    let {subBanners} = Fragment.use(query)

    <div className=%twc("w-full flex flex-col gap-3")>
      {subBanners
      ->Array.map(({id, imageUrlPc, isNewTabPc, landingUrl}) => {
        let key = `sub-banner-${id}`
        let target = isNewTabPc ? "_blank" : "_self"
        <div key className=%twc("flex flex-1 aspect-[300/124] rounded-xl overflow-hidden")>
          <a href=landingUrl target className=%twc("w-full h-full")>
            <img src=imageUrlPc className=%twc("w-full h-full object-cover") alt=key />
          </a>
        </div>
      })
      ->React.array}
    </div>
  }
}

module MO = {
  module Placeholder = {
    @react.component
    let make = () => {
      <div className=%twc("w-full flex items-center gap-[10px]")>
        {[1, 2, 3]
        ->Array.map(idx => {
          <div
            key={`sub-banner-skeleton-${idx->Int.toString}`}
            className=%twc("flex flex-1 aspect-[228/168] rounded-xl animate-pulse bg-gray-150")
          />
        })
        ->React.array}
      </div>
    }
  }

  @react.component
  let make = (~query) => {
    let {subBanners} = Fragment.use(query)

    <div className=%twc("w-full flex items-center gap-[10px]")>
      {subBanners
      ->Array.map(({id, imageUrlMobile, isNewTabMobile, landingUrl}) => {
        let key = `sub-banner-${id}`
        let target = isNewTabMobile ? "_blank" : "_self"
        <div key className=%twc("flex flex-1 aspect-[228/168] rounded-xl overflow-hidden")>
          <a href=landingUrl target className=%twc("w-full h-full")>
            <img src=imageUrlMobile className=%twc("w-full h-full object-cover") alt=key />
          </a>
        </div>
      })
      ->React.array}
    </div>
  }
}
