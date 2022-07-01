open ReactHookForm
module Form = Web_Order_Buyer_Form

module Fragment = %relay(`
        fragment WebOrderPaymentInfoBuyerFragment on Query
        @argumentDefinitions(productOptionNodeId: { type: "ID!" }) {
          node(id: $productOptionNodeId) {
            ... on ProductOption {
              price
              productOptionCost {
                deliveryCost
              }
            }
          }
        }
  `)

module PlaceHolder = {
  @react.component
  let make = () => {
    open Skeleton
    <div className=%twc("rounded-sm bg-white w-full p-7")>
      <span className=%twc("text-lg xl:text-xl text-enabled-L1 font-bold")>
        {`결제 정보`->React.string}
      </span>
      <ul
        className=%twc(
          "text-sm flex flex-col gap-4 py-7 border border-x-0 border-t-0 border-div-border-L2"
        )>
        <li key="product-price" className=%twc("flex justify-between items-center")>
          <span className=%twc("text-text-L2")> {`총 상품금액`->React.string} </span>
          <Box className=%twc("w-20") />
        </li>
        <li key="delivery-cost" className=%twc("flex justify-between items-center")>
          <span className=%twc("text-text-L2")> {`배송비`->React.string} </span>
          <Box className=%twc("w-20") />
        </li>
        <li key="total-price" className=%twc("flex justify-between items-center")>
          <span className=%twc("text-text-L2")> {`총 결제금액`->React.string} </span>
          <Box className=%twc("w-24") />
        </li>
      </ul>
      <div className=%twc("mt-7 mb-10 flex justify-center items-center text-text-L1")>
        <Box className=%twc("w-44") />
      </div>
      <Box className=%twc("w-full min-h-[3.5rem] rounded-xl") />
    </div>
  }
}

@react.component
let make = (~query, ~quantity) => {
  let fragments = Fragment.use(query)

  let deliveryType = Hooks.WatchValues.use(
    Hooks.WatchValues.Text,
    ~config=Hooks.WatchValues.config(~name=Form.names.deliveryType, ()),
    (),
  )

  let (totalProductPrice, totalDeliveryCost, isFreightDelivery) = switch (
    fragments.node,
    deliveryType,
  ) {
  | (Some({price, productOptionCost: {deliveryCost}}), Some(deliveryType')) =>
    switch deliveryType'->Js.Json.string->Form.deliveryType_decode {
    | Ok(decode) =>
      switch decode {
      | #FREIGHT => (price->Option.getWithDefault(0) * quantity, 0, true)
      | #SELF => (price->Option.getWithDefault(0) * quantity, 0, false)
      | #PARCEL => (
          (price->Option.getWithDefault(0) - deliveryCost) * quantity,
          deliveryCost * quantity,
          false,
        )
      }
    | Error(_) => (0, 0, false)
    }
  | (Some({productOptionCost: {deliveryCost}}), None) => (0, deliveryCost * quantity, false)
  | _ => (0, 0, false)
  }

  let (_, _, _, scrollY) = CustomHooks.Scroll.useScrollObserver(Px(50.0), ~sensitive=None)

  let (isFixedOff, setIsFixedOff) = React.Uncurried.useState(_ => false) // 초기값 설정을 위해 useState사용

  open Webapi
  let (scrollHeight, innerHeight) =
    Dom.document
    ->Dom.Document.getElementsByTagName("body")
    ->Dom.HtmlCollection.item(0)
    ->Option.mapWithDefault((0, 0), a => (
      a->Dom.Element.scrollHeight,
      Dom.window->Dom.Window.innerHeight,
    ))

  React.useEffect3(_ => {
    setIsFixedOff(._ => scrollHeight - innerHeight - scrollY->Float.toInt < 140)

    // TODO: 모니터 해상도가 달라도 140이라는 수치가 적용되는지 확인하기 (QA)
    None
  }, (scrollHeight, innerHeight, scrollY))

  <div
    className={cx([
      %twc("rounded-sm bg-white p-7 w-full xl:w-fit"),
      isFixedOff ? %twc("xl:absolute xl:bottom-0") : %twc("xl:fixed"),
    ])}>
    <span className=%twc("text-lg xl:text-xl text-enabled-L1 font-bold")>
      {`결제 정보`->React.string}
    </span>
    <ul
      className=%twc(
        "text-sm flex flex-col gap-5 py-7 border border-x-0 border-t-0 border-div-border-L2 xl:w-[440px]"
      )>
      <li key="product-price" className=%twc("flex justify-between items-center")>
        <span className=%twc("text-text-L2")> {`총 상품금액`->React.string} </span>
        <span className=%twc("text-base font-bold xl:text-sm xl:font-normal")>
          {`${totalProductPrice->Locale.Int.show}원`->React.string}
        </span>
      </li>
      <li key="delivery-cost" className=%twc("flex justify-between items-center")>
        <span className=%twc("text-text-L2")> {`배송비`->React.string} </span>
        <span className=%twc("text-base font-bold xl:text-sm xl:font-normal")>
          {(isFreightDelivery ? `협의` : totalDeliveryCost->Locale.Int.show ++ `원`)->React.string}
        </span>
      </li>
      <li key="total-price" className=%twc("flex justify-between items-center")>
        <span className=%twc("text-text-L2")> {`총 결제금액`->React.string} </span>
        <span className=%twc("text-xl xl:text-lg text-primary font-bold")>
          {`${(totalProductPrice + totalDeliveryCost)->Locale.Int.show}원`->React.string}
        </span>
      </li>
    </ul>
    <div className=%twc("mt-7 mb-10 text-center text-text-L1")>
      <span>
        {`주문 내용을 확인했으며, 정보 제공에 동의합니다.`->React.string}
      </span>
    </div>
    <button
      type_="submit"
      className=%twc(
        "w-full h-14 flex justify-center items-center bg-primary text-lg text-white rounded-xl"
      )>
      {`결제하기`->React.string}
    </button>
  </div>
}
