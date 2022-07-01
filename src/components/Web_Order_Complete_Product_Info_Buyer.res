module Fragment = %relay(`
    fragment WebOrderCompleteProductInfoBuyerFragment on Query
    @argumentDefinitions(orderNo: { type: "String!" }) {
      wosOrder(orderNo: $orderNo) {
        orderProducts {
          productName
          productOptionName
          quantity
          price
          image {
            original
          }
        }
      }
    }    
`)

module Placeholder = {
  @react.component
  let make = () => {
    open Skeleton
    <section className=%twc("flex flex-col gap-5 bg-white rounded-sm")>
      <span className=%twc("text-lg xl:text-xl text-enabled-L1 font-bold")>
        {`상품 정보`->React.string}
      </span>
      <div className=%twc("flex justify-between gap-3 h-18 xl:h-20")>
        <Box className=%twc("w-18 h-18 xl:w-20 xl:h-20 rounded-lg") />
        <div className=%twc("flex-auto")>
          <Box className=%twc("w-20 h-5 mb-2") />
          <Box className=%twc("w-20 h-5 ") />
          <Box className=%twc("text-sm text-text-L2 h-6 w-16") />
        </div>
        <Box className=%twc("hidden xl:flex h-6 w-10") />
      </div>
    </section>
  }
}

@react.component
let make = (~query) => {
  let {wosOrder} = Fragment.use(query)

  switch wosOrder->Option.flatMap(wosOrder' => wosOrder'.orderProducts->Array.get(0)) {
  | Some(Some({productName, productOptionName, quantity, price, image})) =>
    <section className=%twc("flex flex-col gap-5 bg-white rounded-sm w-full")>
      <span className=%twc("text-lg xl:text-xl text-enabled-L1 font-bold")>
        {`상품 정보`->React.string}
      </span>
      <div className=%twc("flex justify-between gap-3 text-sm w-full")>
        <img
          className=%twc("w-18 h-18 xl:w-20 xl:h-20 rounded-lg")
          src={image->Option.mapWithDefault("", image' => image'.original)}
          alt="product-image"
        />
        <div className=%twc("flex-auto")>
          <div
            className=%twc(
              "xl:w-64 w-56 text-base whitespace-pre-wrap font-bold text-enabled-L1 mb-1"
            )>
            {productName->React.string}
          </div>
          <div className=%twc("xl:w-64 w-56 whitespace-pre-wrap text-text-L2 mb-2 xl:mb-3")>
            {productOptionName->React.string}
          </div>
          <div className=%twc("text-text-L2")>
            {`${price->Locale.Int.show}원 | 수량 ${quantity->Int.toString}개`->React.string}
          </div>
        </div>
        <div className=%twc("hidden xl:flex font-bold text-text-L1 min-w-fit")>
          {`총 ${(price * quantity)->Locale.Int.show}원`->React.string}
        </div>
      </div>
    </section>
  | _ => <Placeholder />
  }
}
