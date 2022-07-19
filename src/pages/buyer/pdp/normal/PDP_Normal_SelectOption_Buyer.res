/*
  1. 컴포넌트 위치
  PDP > 일반 상품 > 단품 옵션 셀렉터
  
  2. 역할
  일반 상품이 가진 단품을 선택할 수 있습니다.
*/

module Fragments = {
  module List = %relay(`
   fragment PDPNormalSelectOptionBuyerFragment on Product
   @argumentDefinitions(
     first: { type: "Int", defaultValue: 20 }
     after: { type: "ID", defaultValue: null }
   ) {
     status
   
     ... on NormalProduct {
       productOptions(first: $first, after: $after) {
         edges {
           node {
             stockSku
             ...PDPNormalSelectOptionBuyerItemFragment
           }
         }
       }
     }
   
     ... on QuotableProduct {
       productOptions(first: $first, after: $after) {
         edges {
           node {
             stockSku
             ...PDPNormalSelectOptionBuyerItemFragment
           }
         }
       }
     }
   }
  `)

  module Item = %relay(`
  fragment PDPNormalSelectOptionBuyerItemFragment on ProductOption {
    id
    optionName
    stockSku
    price
    status
    productOptionCost {
      deliveryCost
      isFreeShipping
    }
  }  
  `)
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
    let {id, optionName, price, status, productOptionCost: {deliveryCost, isFreeShipping}} =
      query->Fragments.Item.use

    let optionPrice = PDP_Parser_Buyer.ProductOption.makeOptionPrice(
      ~price,
      ~deliveryCost,
      ~isFreeShipping,
    )

    let optionPriceLabel = {
      optionPrice->Option.mapWithDefault("", optionPrice' =>
        `${optionPrice'->Float.fromInt->Locale.Float.show(~digits=0)}원`
      )
    }

    open RadixUI
    switch status {
    | #SOLDOUT =>
      // 품절
      <div className=%twc("w-full rounded-lg py-3 px-2 text-gray-400")>
        <span> {optionName->React.string} {`/`->React.string} </span>
        <span>
          <span className=%twc("ml-1 font-bold")> {optionPriceLabel->React.string} </span>
          <span className=%twc("font-bold")> {` - 품절`->React.string} </span>
        </span>
      </div>

    | _ =>
      // 구매 가능
      <DropDown.Item className=%twc("focus:outline-none")>
        <div
          onClick={_ => onSelect(._ => Some(id))}
          className=%twc("rounded-lg py-3 px-2 hover:bg-gray-100")>
          <span className=%twc("text-gray-800")>
            <span> {optionName->React.string} {`/`->React.string} </span>
            <span className=%twc("ml-1 font-bold")> {optionPriceLabel->React.string} </span>
          </span>
        </div>
      </DropDown.Item>
    }
  }
}

module PC = {
  @react.component
  let make = (~query, ~onSelect, ~setShowModal) => {
    let user = CustomHooks.User.Buyer.use2()

    let {productOptions, status} = query->Fragments.List.use

    open RadixUI
    <div className=%twc("w-full")>
      <h1 className=%twc("text-base font-bold text-text-L1")> {`단품 선택`->React.string} </h1>
      <div className=%twc("w-full mt-4")>
        {switch user {
        | Unknown =>
          <div
            className=%twc("w-full h-13 p-3 flex items-center justify-between border rounded-xl")>
            <span className=%twc("text-gray-600")> {`선택해주세요`->React.string} </span>
            <IconArrowSelect height="20" width="20" fill="#121212" />
          </div>

        | NotLoggedIn => <>
            <div
              onClick={_ => {
                setShowModal(._ => PDP_Normal_Modals_Buyer.Show(
                  Unauthorized(`로그인 후에\n단품을 선택하실 수 있습니다.`),
                ))
              }}
              className=%twc("w-full h-13 p-3 flex items-center justify-between border rounded-xl")>
              <span className=%twc("text-gray-600")> {`선택해주세요`->React.string} </span>
              <IconArrowSelect height="20" width="20" fill="#121212" />
            </div>
          </>

        | LoggedIn(_) =>
          <div className=%twc("w-full")>
            <DropDown.Root>
              {switch status {
              | #SOLDOUT =>
                // 품절
                <div
                  className=%twc(
                    "h-13 p-3 flex items-center justify-between border border-gray-300 rounded-xl bg-gray-100"
                  )>
                  <span className=%twc("text-gray-400")>
                    {`선택해주세요`->React.string}
                  </span>
                  <IconArrowSelect height="20" width="20" fill="#B2B2B2" />
                </div>

              | _ =>
                // 구매가능
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
                  {switch productOptions {
                  | Some(productOptions') =>
                    productOptions'.edges->Array.map(({node: {stockSku, fragmentRefs}}) => {
                      <Item key={`sku-${stockSku}`} query=fragmentRefs onSelect />
                    })
                  | None => []
                  }->React.array}
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
  let make = (~query, ~onSelect, ~setShowModal) => {
    let user = CustomHooks.User.Buyer.use2()

    let {productOptions, status} = query->Fragments.List.use

    <div className=%twc("w-full flex flex-col gap-4")>
      <h1 className=%twc("text-base font-bold text-text-L1")> {`단품선택`->React.string} </h1>
      <section>
        {switch user {
        | Unknown =>
          <div
            className=%twc("w-full h-13 p-3 flex items-center justify-between border rounded-xl")>
            <span className=%twc("text-gray-600")>
              {`단품을 선택해 주세요`->React.string}
            </span>
            <IconArrowSelect height="20" width="20" fill="#121212" />
          </div>

        | NotLoggedIn =>
          <div
            onClick={_ => {
              setShowModal(._ => PDP_Normal_Modals_Buyer.Show(
                Unauthorized(`로그인 후에\n단품을 선택하실 수 있습니다.`),
              ))
            }}
            className=%twc("w-full h-13 p-3 flex items-center justify-between border rounded-xl")>
            <span className=%twc("text-gray-600")>
              {`단품을 선택해 주세요`->React.string}
            </span>
            <IconArrowSelect height="20" width="20" fill="#121212" />
          </div>

        | LoggedIn(_) => {
            open RadixUI
            <div className=%twc("flex flex-col")>
              <DropDown.Root>
                {switch status {
                | #SOLDOUT =>
                  // 품절
                  <div
                    className=%twc(
                      "h-13 p-3 flex items-center justify-between border border-gray-300 rounded-xl bg-gray-100"
                    )>
                    <span className=%twc("text-gray-400")>
                      {`단품을 선택해 주세요`->React.string}
                    </span>
                    <IconArrowSelect height="20" width="20" fill="#B2B2B2" />
                  </div>

                | _ =>
                  // 구매가능
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
                    {switch productOptions {
                    | Some(productOptions') =>
                      productOptions'.edges->Array.map(({node: {stockSku, fragmentRefs}}) => {
                        <Item key={`sku-${stockSku}`} query=fragmentRefs onSelect />
                      })
                    | None => []
                    }->React.array}
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
