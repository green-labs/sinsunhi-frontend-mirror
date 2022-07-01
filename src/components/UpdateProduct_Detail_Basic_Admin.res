module Fragment = %relay(`
  fragment UpdateProductDetailBasicAdmin on Product {
    name
    displayName
    productId
    price
    status
    origin
    isCourierAvailable
    isVat
    producer {
      id
      name
    }
  }
`)

let statusDecode = (s: UpdateProductDetailBasicAdmin_graphql.Types.enum_ProductStatus): option<
  Select_Product_Operation_Status.Base.status,
> => {
  switch s {
  | #SALE => SALE->Some
  | #SOLDOUT => SOLDOUT->Some
  | #HIDDEN_SALE => HIDDEN_SALE->Some
  | #NOSALE => NOSALE->Some
  | #RETIRE => RETIRE->Some
  | _ => None
  }
}

let deliveryDecode = (s: bool): Select_Delivery.status => {
  switch s {
  | true => AVAILABLE
  | false => UNAVAILABLE
  }
}

let isVatDecode = (s: bool): Select_Tax_Status.status => {
  switch s {
  | true => TAX
  | false => FREE
  }
}

let producerToReactSelected = (
  p: UpdateProductDetailBasicAdmin_graphql.Types.fragment_producer,
) => {
  ReactSelect.Selected({value: p.id, label: p.name})
}

@react.component
let make = (~productId: string, ~query) => {
  let data = Fragment.use(query)

  let allFieldsDisabled = data.status == #RETIRE

  // TODO:
  // 어드민에서는 data.price(상품가격) 이 null일 경우 수정 폼 전체 렌더를 막아야함.

  //운영판매 중지 상태일 때는 모든 인풋필드 비활성화
  <Product_Detail_Basic_Admin
    productId
    defaultProducer={data.producer->producerToReactSelected}
    defaultProducerName={data.name}
    defaultBasePrice={data.price->Option.getWithDefault(-1)}
    defaultBuyerName={data.displayName}
    defaultOperationstatus=?{data.status->statusDecode}
    defaultIsVat={data.isVat->isVatDecode}
    defaultOrigin={data.origin->Option.getWithDefault("")}
    defaultDeliveryMethod={data.isCourierAvailable->deliveryDecode}
    producerNameDisabled={true}
    productCategoryDisabled={true}
    vatDisabled={true}
    allFieldsDisabled
  />
}
