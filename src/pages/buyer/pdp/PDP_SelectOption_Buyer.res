/*
  1. 컴포넌트 위치
  바이어 센터 전시 매장 > PDP Page > 단품 옵션 셀렉터
  
  2. 역할
  상품이 가진 단품을 선택할 수 있습니다.
*/

type selectedSku = {
  id: string,
  stockSku: string,
  label: string,
  priceLabel: string,
}

module Fragments = {
  module List = %relay(`
   fragment PDPSelectOptionBuyerFragment on Product
   @argumentDefinitions(
     first: { type: "Int", defaultValue: 20 }
     after: { type: "ID", defaultValue: null }
   ) {
     status
     productOptions(first: $first, after: $after) {
       edges {
         node {
           stockSku
           ...PDPSelectOptionBuyerItemFragment
         }
       }
     }
   }
  `)

  module Item = %relay(`
  fragment PDPSelectOptionBuyerItemFragment on ProductOption {
    id
    optionName
    stockSku
    price
    status
    productOptionCost {
      deliveryCost
    }
  }  `)
}

module Scroll = {
  @react.component
  let make = (~children) => {
    open RadixUI.ScrollArea
    <Root className=%twc("max-h-[400px] flex flex-col overflow-hidden")>
      <Viewport className=%twc("w-full h-full")> {children} </Viewport>
      <Scrollbar> <Thumb /> </Scrollbar>
    </Root>
  }
}

module Item = {
  @react.component
  let make = (~query, ~onSelect) => {
    let {
      id,
      optionName,
      stockSku,
      price,
      status,
      productOptionCost: {deliveryCost},
    } = Fragments.Item.use(query)

    let isSoldout = status == #SOLDOUT
    let priceLabel = PDP_Parser_Buyer.ProductOption.makePriceLabel(price, deliveryCost)

    open RadixUI
    switch isSoldout {
    | true =>
      // 품절
      <div className=%twc("w-full rounded-lg py-3 px-2 text-gray-400")>
        <span> {optionName->React.string} {`/`->React.string} </span>
        <span>
          <span className=%twc("ml-1 font-bold")> {priceLabel->React.string} </span>
          <span className=%twc("font-bold")> {` - 품절`->React.string} </span>
        </span>
      </div>

    | false => {
        // 구매 가능
        let onClick = ReactEvents.interceptingHandler(_ => {
          onSelect(
            Some({
              id: id,
              stockSku: stockSku,
              label: optionName,
              priceLabel: priceLabel,
            }),
          )
        })

        <DropDown.Item className=%twc("focus:outline-none")>
          <div onClick className=%twc("rounded-lg py-3 px-2 hover:bg-gray-100")>
            <span className=%twc("text-gray-800")>
              <span> {optionName->React.string} {`/`->React.string} </span>
              <span>
                <span className=%twc("ml-1 font-bold")> {priceLabel->React.string} </span>
              </span>
            </span>
          </div>
        </DropDown.Item>
      }
    }
  }
}

module Unauthorized = {
  module PC = {
    @react.component
    let make = (~show, ~setShow) => {
      let {useRouter, push} = module(Next.Router)
      let router = useRouter()

      let onConfirm = ReactEvents.interceptingHandler(_ => {
        let {makeWithDict, toString} = module(Webapi.Url.URLSearchParams)
        let redirectUrl = [("redirect", router.asPath)]->Js.Dict.fromArray->makeWithDict->toString
        router->push(`/buyer/signin?${redirectUrl}`)
      })

      let onCancel = ReactEvents.interceptingHandler(_ => {
        setShow(._ => ShopDialog_Buyer.Hide)
      })

      <ShopDialog_Buyer isShow=show onCancel onConfirm cancelText=`취소` confirmText=`로그인`>
        <div
          className=%twc(
            "h-18 mt-8 px-8 py-6 flex flex-col items-center justify-center text-lg text-text-L1"
          )>
          <span> {`로그인 후에`->React.string} </span>
          <span> {`단품을 선택하실 수 있습니다.`->React.string} </span>
        </div>
      </ShopDialog_Buyer>
    }
  }

  module MO = {
    @react.component
    let make = (~show, ~setShow) => {
      let {useRouter, push} = module(Next.Router)
      let router = useRouter()

      let onConfirm = ReactEvents.interceptingHandler(_ => {
        let {makeWithDict, toString} = module(Webapi.Url.URLSearchParams)
        let redirectUrl = [("redirect", router.asPath)]->Js.Dict.fromArray->makeWithDict->toString
        router->push(`/buyer/signin?${redirectUrl}`)
      })

      let onCancel = ReactEvents.interceptingHandler(_ => {
        setShow(._ => ShopDialog_Buyer.Hide)
      })

      <ShopDialog_Buyer.Mo
        isShow=show onCancel onConfirm cancelText=`취소` confirmText=`로그인`>
        <div
          className=%twc(
            "h-18 mt-8 px-8 py-6 flex flex-col items-center justify-center text-lg text-text-L1"
          )>
          <span> {`로그인 후에`->React.string} </span>
          <span> {`단품을 선택하실 수 있습니다.`->React.string} </span>
        </div>
      </ShopDialog_Buyer.Mo>
    }
  }
}

module PC = {
  @react.component
  let make = (~query, ~onSelect) => {
    let user = CustomHooks.User.Buyer.use2()
    let {productOptions, status} = query->Fragments.List.use
    let isSoldout = status == #SOLDOUT

    let (dropdownOpen, setDropdownOpen) = React.Uncurried.useState(_ => false)
    let (show, setShow) = React.Uncurried.useState(_ => ShopDialog_Buyer.Hide)

    let handleSelect = selected => {
      setDropdownOpen(._ => false)
      onSelect(selected)
    }

    open RadixUI
    <div className=%twc("w-full")>
      <h1 className=%twc("text-base font-bold text-text-L1")> {`단품 선택`->React.string} </h1>
      <div className=%twc("w-full mt-4")>
        {switch user {
        | Unknown => <Skeleton.Box />
        | NotLoggedIn =>
          let onClick = ReactEvents.interceptingHandler(_ => setShow(._ => Show))
          <>
            <div
              onClick
              className=%twc("w-full h-13 p-3 flex items-center justify-between border rounded-xl")>
              <span className=%twc("text-gray-600")> {`선택해주세요`->React.string} </span>
              <IconArrowSelect height="20" width="20" fill="#121212" />
            </div>
            <Unauthorized.PC show setShow />
          </>

        | LoggedIn(_) =>
          <div className=%twc("w-full")>
            <DropDown.Root _open=dropdownOpen onOpenChange={to_ => setDropdownOpen(._ => to_)}>
              {switch isSoldout {
              | true =>
                <div
                  className=%twc(
                    "h-13 p-3 flex items-center justify-between border border-gray-300 rounded-xl bg-gray-100"
                  )>
                  <span className=%twc("text-gray-400")>
                    {`선택해주세요`->React.string}
                  </span>
                  <IconArrowSelect height="20" width="20" fill="#B2B2B2" />
                </div>

              | false =>
                <DropDown.Trigger className=%twc("w-full focus:outline-none")>
                  <div
                    className=%twc(
                      "w-full h-13 p-3 flex items-center justify-between border rounded-xl"
                    )>
                    <span className=%twc("text-gray-600")>
                      {`선택해주세요`->React.string}
                    </span>
                    <IconArrowSelect height="20" width="20" fill="#121212" />
                  </div>
                </DropDown.Trigger>
              }}
              <DropDown.Content
                align=#start
                sideOffset=4
                className=%twc(
                  "dropdown-content w-[446px] bg-white border rounded-lg shadow-md p-1"
                )>
                <Scroll>
                  {productOptions.edges
                  ->Array.map(({node: {stockSku, fragmentRefs}}) => {
                    <Item key={`sku-${stockSku}`} query=fragmentRefs onSelect=handleSelect />
                  })
                  ->React.array}
                </Scroll>
              </DropDown.Content>
            </DropDown.Root>
          </div>
        }}
      </div>
    </div>
  }
}

module MO = {
  @react.component
  let make = (~query, ~onSelect) => {
    let user = CustomHooks.User.Buyer.use2()
    let {productOptions, status} = query->Fragments.List.use
    let isSoldout = status == #SOLDOUT

    let (dropdownOpen, setDropdownOpen) = React.Uncurried.useState(_ => false)
    let (show, setShow) = React.Uncurried.useState(_ => ShopDialog_Buyer.Hide)

    let handleSelect = selected => {
      setDropdownOpen(._ => false)
      onSelect(selected)
    }

    <div className=%twc("w-full flex flex-col gap-4")>
      <h1 className=%twc("text-base font-bold text-text-L1")> {`단품선택`->React.string} </h1>
      <section>
        {switch user {
        | Unknown => <Skeleton.Box />
        | NotLoggedIn =>
          let onClick = ReactEvents.interceptingHandler(_ => setShow(._ => Show))
          <>
            <div
              onClick
              className=%twc("w-full h-13 p-3 flex items-center justify-between border rounded-xl")>
              <span className=%twc("text-gray-600")>
                {`단품을 선택해 주세요`->React.string}
              </span>
              <IconArrowSelect height="20" width="20" fill="#121212" />
            </div>
            <Unauthorized.MO show setShow />
          </>
        | LoggedIn(_) => {
            open RadixUI
            <div className=%twc("flex flex-col")>
              <DropDown.Root _open=dropdownOpen onOpenChange={to_ => setDropdownOpen(._ => to_)}>
                {switch isSoldout {
                | true =>
                  <div
                    className=%twc(
                      "h-13 p-3 flex items-center justify-between border border-gray-300 rounded-xl bg-gray-100"
                    )>
                    <span className=%twc("text-gray-400")>
                      {`단품을 선택해 주세요`->React.string}
                    </span>
                    <IconArrowSelect height="20" width="20" fill="#B2B2B2" />
                  </div>

                | false =>
                  <DropDown.Trigger className=%twc("focus:outline-none")>
                    <div
                      className=%twc(
                        "w-full h-13 p-3 flex items-center justify-between border rounded-xl"
                      )>
                      <span className=%twc("text-gray-600")>
                        {`단품을 선택해 주세요`->React.string}
                      </span>
                      <IconArrowSelect height="20" width="20" fill="#121212" />
                    </div>
                  </DropDown.Trigger>
                }}
                <DropDown.Content
                  align=#start
                  sideOffset=4
                  className=%twc(
                    "dropdown-content w-[calc(100vw-40px)] max-w-[calc(768px-40px)] bg-white border rounded-lg shadow-md p-1"
                  )>
                  <Scroll>
                    {productOptions.edges
                    ->Array.map(({node: {stockSku, fragmentRefs}}) => {
                      <Item key={`sku-${stockSku}`} query=fragmentRefs onSelect=handleSelect />
                    })
                    ->React.array}
                  </Scroll>
                </DropDown.Content>
              </DropDown.Root>
            </div>
          }
        }}
      </section>
    </div>
  }
}
