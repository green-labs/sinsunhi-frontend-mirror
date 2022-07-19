module Query = %relay(`
  query WebOrderCompleteBuyerQuery($orderNo: String!) {
    ...WebOrderCompleteProductInfoBuyerFragment @arguments(orderNo: $orderNo)
    ...WebOrderCompleteDeliveryInfoBuyerFragment @arguments(orderNo: $orderNo)
    ...WebOrderCompletePaymentInfoBuyerFragment @arguments(orderNo: $orderNo)
    wosOrder(orderNo: $orderNo) {
      orderNo
      totalDeliveryCost
      totalOrderPrice
      orderProducts {
        productName
        productId
        stockSku
        productOptionName
        quantity
        price
      }
    }
  }
`)

@spice
type item = {
  @spice.key("item_id") itemId: string, // 상품 코드
  @spice.key("item_name") itemName: string, // 상품명
  currency: string, // "KRW" 고정
  @spice.key("item_variant") itemVariant: string, // 상품 sku
  price: int,
  quantity: int,
}

@spice
type ecommerce = {
  @spice.key("transaction_id") transactionId: string, // 주문번호
  currency: string, // "KRW" 고정
  @spice.key("purchase_revenue") purchaseRevenue: int, // 총 결제 금액
  @spice.key("shipping_value") shippingValue: int, // 총 배송비
}

let toEcommerce = (w: WebOrderCompleteBuyerQuery_graphql.Types.response_wosOrder) =>
  {
    transactionId: w.orderNo,
    currency: "KRW",
    purchaseRevenue: w.totalOrderPrice,
    shippingValue: w.totalDeliveryCost->Option.getWithDefault(0),
  }->ecommerce_encode

let toItems = (
  {
    productId,
    productName,
    stockSku,
    price,
    quantity,
  }: WebOrderCompleteBuyerQuery_graphql.Types.response_wosOrder_orderProducts,
) =>
  {
    itemId: productId->Int.toString,
    itemName: productName,
    currency: "KRW",
    itemVariant: stockSku,
    price: price,
    quantity: quantity,
  }->item_encode

module Placeholder = {
  @react.component
  let make = () => {
    <main className=%twc("flex flex-col gap-5 xl:px-[16%] xl:py-20 bg-surface min-w-[375px]")>
      <label className=%twc("hidden xl:flex ml-5 mb-3 text-3xl font-bold text-enabled-L1")>
        {`주문 완료`->React.string}
      </label>
      <div className=%twc("flex flex-col xl:flex-row gap-4 xl:gap-5")>
        <article className=%twc("w-full xl:w-3/5 flex flex-col gap-5")>
          <section
            className=%twc("flex justify-center bg-white rounded-sm p-7 xl:p-0 min-w-[375px]")>
            <span
              className=%twc(
                "w-full text-center text-base xl:text-xl p-6 font-bold text-text-L1 shadow-card-box xl:shadow-none"
              )>
              {`주문이 완료되었습니다 📦`->React.string}
            </span>
          </section>
          <section className=%twc("flex flex-col p-7 gap-7 bg-white rounded-sm min-w-max")>
            <Web_Order_Complete_Product_Info_Buyer.Placeholder />
            <div className=%twc("h-px bg-border-default-L2") />
            <Web_Order_Complete_Orderer_Info_Buyer.Placeholder />
            <div className=%twc("h-px bg-border-default-L2") />
            <Web_Order_Complete_Delivery_Info_Buyer.Placeholder />
            <div className=%twc("h-px bg-border-default-L2") />
          </section>
        </article>
        <aside className=%twc("xl:w-2/5 min-w-[375px]")>
          <Web_Order_Complete_Payment_Info_Buyer.Placeholder />
        </aside>
      </div>
      <nav
        className=%twc(
          "w-full xl:w-[59%] flex flex-col xl:flex-row gap-2 p-7 pb-16 xl:pb-7 bg-white min-w-[375px]"
        )>
        <Next.Link href="/buyer/orders">
          <a
            className=%twc(
              "flex w-full xl:w-1/2 h-13 bg-surface rounded-lg justify-center items-center text-lg cursor-pointer text-enabled-L1"
            )>
            {`주문 상세내역 보기`->React.string}
          </a>
        </Next.Link>
        <Next.Link href="/buyer">
          <a
            className=%twc(
              "flex w-full xl:w-1/2 h-13 bg-green-100 rounded-lg justify-center items-center font-bold text-lg cursor-pointer text-primary"
            )>
            {`쇼핑 계속하기`->React.string}
          </a>
        </Next.Link>
      </nav>
    </main>
  }
}

module Container = {
  @react.component
  let make = (~nodeId) => {
    let queryData = Query.use(
      ~variables={
        orderNo: nodeId,
      },
      (),
    )

    React.useEffect0(_ => {
      queryData.wosOrder->Option.forEach(wosOrder => {
        {
          "evnet": "purchase",
          "ecommerce": [wosOrder->toEcommerce],
          "items": wosOrder.orderProducts->Array.keepMap(Garter.Fn.identity)->Array.map(toItems),
        }->DataGtm.push
      })
      None
    })

    <main className=%twc("flex flex-col gap-5 xl:px-[16%] xl:py-20 bg-surface min-w-[375px]")>
      <label className=%twc("hidden xl:flex ml-5 mb-3 text-3xl font-bold text-enabled-L1")>
        {`주문 완료`->React.string}
      </label>
      <div className=%twc("flex flex-col xl:flex-row gap-4 xl:gap-5")>
        <article className=%twc("w-full xl:w-3/5 flex flex-col gap-5")>
          <section
            className=%twc("flex justify-center bg-white rounded-sm p-7 xl:p-0 min-w-[375px]")>
            <span
              className=%twc(
                "w-full text-center text-base xl:text-xl p-6 font-bold text-text-L1 shadow-card-box xl:shadow-none"
              )>
              {`주문이 완료되었습니다 📦`->React.string}
            </span>
          </section>
          <section className=%twc("flex flex-col p-7 gap-7 bg-white rounded-sm min-w-max")>
            <Web_Order_Complete_Product_Info_Buyer query=queryData.fragmentRefs />
            <div className=%twc("h-px bg-border-default-L2") />
            <Web_Order_Complete_Orderer_Info_Buyer />
            <div className=%twc("h-px bg-border-default-L2") />
            <Web_Order_Complete_Delivery_Info_Buyer query=queryData.fragmentRefs />
          </section>
        </article>
        <aside className=%twc("xl:w-2/5 min-w-[375px]")>
          <Web_Order_Complete_Payment_Info_Buyer query=queryData.fragmentRefs />
        </aside>
      </div>
      <nav
        className=%twc(
          "w-full xl:w-[59%] flex flex-col xl:flex-row gap-2 p-7 pb-16 xl:pb-7 bg-white min-w-[375px]"
        )>
        <Next.Link href="/buyer/orders">
          <a
            className=%twc(
              "flex w-full xl:w-1/2 h-13 bg-surface rounded-lg justify-center items-center text-lg cursor-pointer text-enabled-L1"
            )>
            {`주문 상세내역 보기`->React.string}
          </a>
        </Next.Link>
        <Next.Link href="/buyer">
          <a
            className=%twc(
              "flex w-full xl:w-1/2 h-13 bg-green-100 rounded-lg justify-center items-center font-bold text-lg cursor-pointer text-primary"
            )>
            {`쇼핑 계속하기`->React.string}
          </a>
        </Next.Link>
      </nav>
    </main>
  }
}

@react.component
let make = () => {
  let router = Next.Router.useRouter()
  let orderId = router.query->Js.Dict.get("order-id")

  <>
    <Next.Head> <title> {`주문완료 - 신선하이`->React.string} </title> </Next.Head>
    <RescriptReactErrorBoundary fallback={_ => <NotFound />}>
      <React.Suspense fallback={<Placeholder />}>
        {switch orderId {
        | Some(nodeId) => <Container nodeId />
        | None => <Placeholder />
        }}
      </React.Suspense>
    </RescriptReactErrorBoundary>
  </>
}
