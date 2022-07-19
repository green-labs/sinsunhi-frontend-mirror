open RadixUI

module Query = %relay(`
  query PDPNormalOrderSpecificationBuyerQuery($id: ID!) {
    node(id: $id) {
      ... on ProductOption {
        id
        optionName
        product {
          id
          productId
        }
        stockSku
        price
        productOptionCost {
          deliveryCost
          isFreeShipping
        }
      }
    }
  }
`)

module Placeholder = {
  @react.component
  let make = () => {
    <div className=%twc("w-full h-[497px]") />
  }
}

module Tab = {
  @react.component
  let make = (~label, ~value, ~isSelected) => {
    let btnDefaultStyle = %twc("flex flex-1 items-center justify-center border ")
    let btnStyle = isSelected
      ? %twc("bg-green-50 text-green-500 border-green-500")
      : %twc("text-gray-800 border-gray-250")

    <Tabs.Trigger className={btnDefaultStyle ++ btnStyle} value>
      <span> {label->React.string} </span>
    </Tabs.Trigger>
  }
}

@react.component
let make = (~selectedSkuId, ~quantity, ~setQuantity) => {
  let {useRouter, push, pushObj} = module(Next.Router)
  let router = useRouter()

  let {node} = Query.use(
    ~variables=Query.makeVariables(~id=selectedSkuId),
    ~fetchPolicy=RescriptRelay.StoreOrNetwork,
    (),
  )

  let (selectedMethod, setSelectedMethod) = React.Uncurried.useState(_ => "dropShipping")

  <Tabs.Root
    defaultValue="dropShipping" onValueChange={selected => setSelectedMethod(._ => selected)}>
    <Tabs.List className=%twc("w-full h-12 flex")>
      <Tab
        label=`2개 이상 배송지`
        value="dropShipping"
        isSelected={selectedMethod == "dropShipping"}
      />
      <Tab
        label=`1개 배송지` value="deliverying" isSelected={selectedMethod == "deliverying"}
      />
    </Tabs.List>
    {switch node {
    | None => React.null
    | Some({
        id: productOptionNodeId,
        optionName,
        product: {id: productNodeId, productId},
        stockSku,
        price,
        productOptionCost: {deliveryCost, isFreeShipping},
      }) =>
      let productNoLabel = productId->Int.toString

      // 총 상품가격: 갯수 * 단품 가격
      let priceLabel = {
        let optionPrice = PDP_Parser_Buyer.ProductOption.makeOptionPrice(
          ~price,
          ~deliveryCost,
          ~isFreeShipping,
        )

        optionPrice->Option.mapWithDefault("", optionPrice' => {
          `${(optionPrice' * quantity)->Int.toFloat->Locale.Float.show(~digits=0)}원`
        })
      }

      // 총 배송비
      // 위탁배송: 갯수 * 배송비
      // 웹주문서: 현재 step에서 배송비 표현 없음
      let deliveryCostLabel = {
        let optionDeliveryCost = PDP_Parser_Buyer.ProductOption.makeOptionDeliveryCost(
          ~deliveryCost,
          ~isFreeShipping,
        )
        switch optionDeliveryCost * quantity {
        | 0 => `무료`
        | totalDeliveryCost => `${totalDeliveryCost->Int.toFloat->Locale.Float.show(~digits=0)}원`
        }
      }

      let quantityLabel = quantity->Int.toString

      <>
        <div className=%twc("my-4 w-full flex items-center justify-between")>
          <span className=%twc("w-full text-lg")> {optionName->React.string} </span>
          <Spinbox value=quantity setValue=setQuantity />
        </div>
        // 위탁배송
        <Tabs.Content value="dropShipping">
          <div className=%twc("w-full h-[273px]")>
            <section className=%twc("w-full bg-gray-50 p-4 text-text-L1 flex flex-col")>
              <span className=%twc("font-bold")>
                {`상품번호 : ${productNoLabel}`->React.string}
              </span>
              <span className=%twc("mt-2")> {`단품번호 : ${stockSku}`->React.string} </span>
              <span className=%twc("mt-2")> {`수량 : ${quantityLabel}`->React.string} </span>
              <span className=%twc("mt-2")> {`상품가 : ${priceLabel}`->React.string} </span>
              <span className=%twc("mt-2")>
                {`배송비 : ${deliveryCostLabel}`->React.string}
              </span>
            </section>
            <section className=%twc("mt-2 flex flex-col")>
              <span className=%twc("text-sm text-gray-600")>
                {`해당 상품의 가격과 배송비를 확인하시고 주문해주세요.`->React.string}
              </span>
              <Next.Link
                href="https://drive.google.com/file/d/1hz3Y2U9JlGR4fgiqNdrNFEdKAiL74BOw/view">
                <a
                  className=%twc("flex items-center mt-4") target="_blank" rel="noopener noreferer">
                  <span className=%twc("text-primary text-[17px] font-bold mr-1")>
                    {`위탁 배송 주문 방법 안내`->React.string}
                  </span>
                  <IconArrow width="20" height="20" stroke=`#12B564` />
                </a>
              </Next.Link>
            </section>
          </div>
          <section className=%twc("w-full py-5")>
            <button
              onClick={ReactEvents.interceptingHandler(_ => {
                router->push("/buyer/upload")
              })}
              className=%twc(
                "w-full h-16 bg-primary text-white font-bold flex items-center justify-center rounded-xl"
              )>
              {`주문서 업로드하기`->React.string}
            </button>
          </section>
        </Tabs.Content>
        // 웹주문서
        <Tabs.Content value="deliverying">
          <div className=%twc("w-full h-[273px]")>
            <section className=%twc("w-full bg-gray-50 p-4 text-text-L1 flex flex-col")>
              <span> {`수량 : ${quantityLabel}`->React.string} </span>
              <span className=%twc("mt-2")> {`상품가 : ${priceLabel}`->React.string} </span>
              <span className=%twc("mt-2")>
                {`배송비 : 배송타입 선택 후 확인 가능`->React.string}
              </span>
            </section>
          </div>
          <section className=%twc("w-full py-5")>
            <button
              onClick={ReactEvents.interceptingHandler(_ => {
                router->pushObj({
                  pathname: `/buyer/web-order/${productNodeId}/${productOptionNodeId}`,
                  query: [("quantity", quantity->Int.toString)]->Js.Dict.fromArray,
                })
              })}
              className=%twc(
                "w-full h-16 bg-primary text-white font-bold flex items-center justify-center rounded-xl"
              )>
              {`바로 구매하기`->React.string}
            </button>
          </section>
        </Tabs.Content>
      </>
    }}
  </Tabs.Root>
}
