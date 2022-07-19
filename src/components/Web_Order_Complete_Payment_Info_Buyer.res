module Fragment = %relay(`
    fragment WebOrderCompletePaymentInfoBuyerFragment on Query
    @argumentDefinitions(orderNo: { type: "String!" }) {
      wosOrder(orderNo: $orderNo) {
        totalOrderPrice
        totalDeliveryCost
        paymentMethod
        orderProducts {
          deliveryType
        }
      }
    }    
`)

let paymentMethodToString = m =>
  switch m {
  | Some(#CREDIT_CARD) => `카드결제`
  | Some(#VIRTUAL_ACCOUNT) => `가상계좌`
  | Some(#TRANSFER) => `계좌이체`
  | _ => `-`
  }

let makePrice = (o, d, m) =>
  switch m {
  | #SELF
  | #FREIGHT => (o, 0)
  | #PARCEL => (o - d, d)
  | _ => (0, 0)
  }

module Placeholder = {
  @react.component
  let make = () => {
    open Skeleton
    <section className=%twc("flex flex-col rounded-sm bg-white w-full p-7 gap-7")>
      <span className=%twc("text-lg xl:text-xl text-enabled-L1 font-bold")>
        {`결제 정보`->React.string}
      </span>
      <ul className=%twc("text-sm flex flex-col gap-5")>
        <li key="payment-method" className=%twc("flex justify-between items-center")>
          <span className=%twc("text-text-L2")> {`결제 수단`->React.string} </span>
          <Box className=%twc("h-6 my-0 w-20 text-base font-bold xl:text-sm") />
        </li>
        // 단기적으로 상품금액, 배송비 노출을 없애기로함 (7/6) -> isFreeShipping이 wosOrder에 추가되면 부활시킬 예정
        // <li key="product-price" className=%twc("flex justify-between items-center")>
        //   <span className=%twc("text-text-L2")> {`총 상품금액`->React.string} </span>
        //   <Box className=%twc("h-6 my-0 w-20 text-base font-bold xl:text-sm") />
        // </li>
        // <li key="delivery-cost" className=%twc("flex justify-between items-center")>
        //   <span className=%twc("text-text-L2")> {`배송비`->React.string} </span>
        //   <Box className=%twc("h-6 my-0 w-20 text-base font-bold xl:text-sm") />
        // </li>
        <li key="total-price" className=%twc("flex justify-between items-center")>
          <span className=%twc("text-text-L2")> {`총 결제금액`->React.string} </span>
          <Box className=%twc("h-6 my-0 w-24 text-base font-bold xl:text-sm") />
        </li>
      </ul>
    </section>
  }
}

@react.component
let make = (~query) => {
  let {wosOrder} = Fragment.use(query)

  switch wosOrder {
  | Some({totalOrderPrice, totalDeliveryCost, paymentMethod, orderProducts}) =>
    let deliveryType =
      orderProducts->Array.get(0)->Option.flatMap(a => a->Option.map(b => b.deliveryType))

    let (productPrice, deliveryPrice) =
      deliveryType->Option.mapWithDefault((0, 0), d =>
        makePrice(totalOrderPrice, totalDeliveryCost->Option.getWithDefault(0), d)
      )

    <section className=%twc("flex flex-col rounded-sm bg-white w-full p-7 gap-7")>
      <span className=%twc("text-lg xl:text-xl text-enabled-L1 font-bold")>
        {`결제 정보`->React.string}
      </span>
      <ul className=%twc("text-sm flex flex-col gap-5")>
        <li key="payment-method" className=%twc("flex justify-between items-center h-6")>
          <span className=%twc("text-text-L2")> {`결제 수단`->React.string} </span>
          <span className=%twc("text-base font-bold xl:text-sm")>
            {paymentMethod->paymentMethodToString->React.string}
          </span>
        </li>
        // 단기적으로 상품금액, 배송비 노출을 없애기로함 (7/6) -> isFreeShipping이 wosOrder에 추가되면 부활시킬 예정
        // <li key="product-price" className=%twc("flex justify-between items-center h-6")>
        //   <span className=%twc("text-text-L2")> {`총 상품금액`->React.string} </span>
        //   <span className=%twc("text-base font-bold xl:text-sm")>
        //     {`${productPrice->Locale.Int.show}원`->React.string}
        //   </span>
        // </li>
        // <li key="delivery-cost" className=%twc("flex justify-between items-center h-6")>
        //   <span className=%twc("text-text-L2")> {`배송비`->React.string} </span>
        //   <span className=%twc("text-base font-bold xl:text-sm")>
        //     {`${deliveryPrice->Locale.Int.show}원`->React.string}
        //   </span>
        // </li>
        <li key="total-price" className=%twc("flex justify-between items-center h-6")>
          <span className=%twc("text-text-L2")> {`총 결제금액`->React.string} </span>
          <span className=%twc("text-xl xl:text-lg text-primary font-bold")>
            {`${(productPrice + deliveryPrice)->Locale.Int.show}원`->React.string}
          </span>
        </li>
      </ul>
    </section>
  | _ => <Placeholder />
  }
}
