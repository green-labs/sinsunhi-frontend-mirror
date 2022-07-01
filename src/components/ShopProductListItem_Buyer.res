/*
 *
 * 1. 위치: 바이어센터 매장 상품 리스트 아이템
 *
 * 2. 역할: 상품 리스트 내에서 각 상품의 간략한 정보를 제공한다
 *
 */

module Fragments = {
  module Root = %relay(`
  fragment ShopProductListItemBuyerFragment on Product {
    type_: type
    ...ShopProductListItemBuyerNormalFragment
    ...ShopProductListItemBuyerQuotedFragment
  }
  `)

  module Normal = %relay(`
    fragment ShopProductListItemBuyerNormalFragment on Product {
      id
      price
      image {
        thumb800x800
      }
      status
      displayName
    }
  `)

  module Quoted = %relay(`
    fragment ShopProductListItemBuyerQuotedFragment on Product {
      id
      image {
        thumb800x800
      }
      displayName
    }
  `)
}

module NormalProduct = {
  module PC = {
    @react.component
    let make = (~query) => {
      let {useRouter, push} = module(Next.Router)
      let router = useRouter()
      let user = CustomHooks.User.Buyer.use2()

      let {id, displayName, price, image, status} = query->Fragments.Normal.use
      let isSoldout = status == #SOLDOUT

      let priceLabel = {
        price->Option.mapWithDefault("", price' =>
          `${price'->Int.toFloat->Locale.Float.show(~digits=0)}원`
        )
      }

      let onClick = ReactEvents.interceptingHandler(_ => {
        router->push(`/buyer/products/${id}`)
      })

      <div className=%twc("w-[280px] h-[376px] cursor-pointer") onClick>
        <div className=%twc("w-[280px] aspect-square rounded-xl overflow-hidden relative")>
          <Image
            src=image.thumb800x800
            className=%twc("w-full h-full object-cover")
            placeholder=Image.Placeholder.sm
            alt={`product-${id}`}
          />
          <div className=%twc("w-full h-full absolute top-0 left-0 bg-black/[.03] rounded-2xl") />
          {switch isSoldout {
          | true => <>
              <div
                className=%twc("w-full h-full absolute top-0 left-0 bg-white opacity-40 rounded-xl")
              />
              <div
                className=%twc(
                  "absolute bottom-0 w-full h-10 bg-gray-600 flex items-center justify-center opacity-90"
                )>
                <span className=%twc("text-white text-xl font-bold")>
                  {`품절`->React.string}
                </span>
              </div>
            </>

          | false => React.null
          }}
        </div>
        <div className=%twc("flex flex-col mt-4")>
          <span className=%twc("text-gray-800 line-clamp-2")> {displayName->React.string} </span>
          {switch user {
          | LoggedIn(_) =>
            let textColor = isSoldout ? %twc(" text-gray-400") : %twc(" text-text-L1")
            <span className={%twc("mt-2 font-bold text-lg") ++ textColor}>
              {priceLabel->React.string}
            </span>

          | NotLoggedIn =>
            <span className=%twc("mt-2 font-bold text-lg text-green-500")>
              {`공급가 회원공개`->React.string}
            </span>
          | Unknown => <Skeleton.Box />
          }}
        </div>
      </div>
    }
  }

  module MO = {
    @react.component
    let make = (~query) => {
      let {useRouter, push} = module(Next.Router)
      let router = useRouter()
      let user = CustomHooks.User.Buyer.use2()

      let {id, displayName, price, image, status} = query->Fragments.Normal.use
      let isSoldout = status == #SOLDOUT

      let priceLabel = {
        price->Option.mapWithDefault("", price' =>
          `${price'->Int.toFloat->Locale.Float.show(~digits=0)}원`
        )
      }

      let onClick = ReactEvents.interceptingHandler(_ => {
        router->push(`/buyer/products/${id}`)
      })

      <div className=%twc("cursor-pointer") onClick>
        <div className=%twc("rounded-xl overflow-hidden relative aspect-square")>
          <Image
            src=image.thumb800x800
            className=%twc("w-full h-full object-cover")
            placeholder=Image.Placeholder.sm
            alt={`product-${id}`}
          />
          <div className=%twc("w-full h-full absolute top-0 left-0 bg-black/[.03] rounded-xl") />
          {switch isSoldout {
          | true => <>
              <div
                className=%twc("w-full h-full absolute top-0 left-0 bg-white opacity-40 rounded-xl")
              />
              <div
                className=%twc(
                  "absolute bottom-0 w-full h-8 bg-gray-600 flex items-center justify-center opacity-90"
                )>
                <span className=%twc("text-white font-bold")> {`품절`->React.string} </span>
              </div>
            </>

          | false => React.null
          }}
        </div>
        <div className=%twc("flex flex-col mt-3")>
          <span className=%twc("text-gray-800 line-clamp-2 text-sm")>
            {displayName->React.string}
          </span>
          {switch user {
          | LoggedIn(_) =>
            let textColor = isSoldout ? %twc(" text-gray-400") : %twc(" text-text-L1")
            <span className={%twc("mt-1 font-bold") ++ textColor}>
              {priceLabel->React.string}
            </span>
          | NotLoggedIn =>
            <span className=%twc("mt-1 font-bold text-green-500")>
              {`공급가 회원공개`->React.string}
            </span>
          | Unknown => <Skeleton.Box />
          }}
        </div>
      </div>
    }
  }
}

module QuotedProduct = {
  module PC = {
    @react.component
    let make = (~query) => {
      let {useRouter, push} = module(Next.Router)
      let router = useRouter()

      let {id, image, displayName} = query->Fragments.Quoted.use

      let onClick = ReactEvents.interceptingHandler(_ => {
        router->push(`/buyer/products/${id}`)
      })

      <div className=%twc("w-[280px] h-[376px] cursor-pointer") onClick>
        <div className=%twc("w-[280px] aspect-square rounded-xl overflow-hidden relative")>
          <Image
            src=image.thumb800x800
            className=%twc("w-full h-full object-cover")
            placeholder=Image.Placeholder.sm
            alt={`product-${id}`}
          />
          <div className=%twc("w-full h-full absolute top-0 left-0 bg-black/[.03] rounded-2xl") />
        </div>
        <div className=%twc("flex flex-col mt-4")>
          <span className=%twc("text-gray-800 line-clamp-2")> {displayName->React.string} </span>
          <span className=%twc("mt-2 font-bold text-lg text-blue-500")>
            {`최저가 견적받기`->React.string}
          </span>
        </div>
      </div>
    }
  }

  module MO = {
    @react.component
    let make = (~query) => {
      let {useRouter, push} = module(Next.Router)
      let router = useRouter()

      let {id, image, displayName} = query->Fragments.Quoted.use

      let onClick = ReactEvents.interceptingHandler(_ => {
        router->push(`/buyer/products/${id}`)
      })

      <div className=%twc("cursor-pointer") onClick>
        <div className=%twc("rounded-xl overflow-hidden relative aspect-square")>
          <Image
            src=image.thumb800x800
            className=%twc("w-full h-full object-cover")
            placeholder=Image.Placeholder.sm
            alt={`product-${id}`}
          />
          <div className=%twc("w-full h-full absolute top-0 left-0 bg-black/[.03] rounded-xl") />
        </div>
        <div className=%twc("flex flex-col mt-3")>
          <span className=%twc("text-gray-800 line-clamp-2 text-sm")>
            {displayName->React.string}
          </span>
          <span className=%twc("mt-1 font-bold text-blue-500")>
            {`최저가 견적받기`->React.string}
          </span>
        </div>
      </div>
    }
  }
}

module PC = {
  module Placeholder = {
    @react.component
    let make = () => {
      <div className=%twc("w-[280px] h-[376px]")>
        <div className=%twc("w-[280px] h-[280px] animate-pulse rounded-xl bg-gray-100") />
        <div className=%twc("mt-3 w-[244px] h-[24px] animate-pulse rounded-sm bg-gray-100") />
        <div className=%twc("mt-2 w-[88px] h-[24px] animate-pulse rounded-sm bg-gray-100") />
      </div>
    }
  }

  @react.component
  let make = (~query) => {
    let {type_, fragmentRefs} = query->Fragments.Root.use

    switch type_ {
    | #QUOTABLE
    | #NORMAL =>
      <NormalProduct.PC query=fragmentRefs />
    | #QUOTED => <QuotedProduct.PC query=fragmentRefs />
    | _ => React.null
    }
  }
}

module MO = {
  module Placeholder = {
    @react.component
    let make = () => {
      <div>
        <div className=%twc("w-full aspect-square animate-pulse rounded-xl bg-gray-100") />
        <div className=%twc("mt-3 w-[132px] h-5 animate-pulse rounded-sm bg-gray-100") />
        <div className=%twc("mt-1 w-[68px] h-[22px] animate-pulse rounded-sm bg-gray-100") />
      </div>
    }
  }

  @react.component
  let make = (~query) => {
    let {type_, fragmentRefs} = query->Fragments.Root.use

    switch type_ {
    | #QUOTABLE
    | #NORMAL =>
      <NormalProduct.MO query=fragmentRefs />
    | #QUOTED => <QuotedProduct.MO query=fragmentRefs />
    | _ => React.null
    }
  }
}
