module Mutation = %relay(`
  mutation WebOrderItemBuyerMutation(
    $paymentMethod: PaymentMethod!
    $amount: Int!
    $purpose: PaymentPurpose!
  ) {
    requestPayment(
      input: { paymentMethod: $paymentMethod, amount: $amount, purpose: $purpose }
    ) {
      ... on RequestPaymentKCPResult {
        siteCd
        siteKey
        siteName
        ordrIdxx
        currency
        shopUserId
        buyrName
      }
      ... on RequestPaymentTossPaymentsResult {
        orderId
        amount
        clientKey
        customerName
        customerEmail
        paymentId
      }
      ... on Error {
        code
        message
      }
    }
  }
`)

module PlaceHolder = {
  @react.component
  let make = () => {
    <main className=%twc("flex flex-col gap-5 xl:px-[16%] xl:py-20 bg-surface")>
      <h1 className=%twc("hidden xl:flex ml-5 mb-3 text-3xl font-bold text-enabled-L1")>
        {`주문·결제`->React.string}
      </h1>
      <div className=%twc("flex flex-col xl:flex-row gap-4 xl:gap-5")>
        <article className=%twc("w-full xl:w-3/5 flex flex-col gap-5")>
          <div className=%twc("flex flex-col gap-7 p-7 bg-white")>
            <Web_Order_Product_Info_Buyer.PlaceHolder />
            <div className=%twc("h-px bg-border-default-L2") />
            <Web_Order_Orderer_Info_Buyer.PlaceHolder />
          </div>
          <Web_Order_Delivery_Method_Selection_Buyer.PlaceHoder />
        </article>
        <aside className=%twc("w-full xl:w-2/5")>
          <Web_Order_Payment_Info_Buyer.PlaceHolder />
        </aside>
      </div>
    </main>
  }
}

@react.component
let make = (~query, ~quantity) =>
  <main className=%twc("flex flex-col gap-5 xl:px-[16%] xl:py-20 bg-surface")>
    <h1 className=%twc("hidden xl:flex ml-5 mb-3 text-3xl font-bold text-enabled-L1")>
      {`주문·결제`->React.string}
    </h1>
    <div className=%twc("flex flex-col xl:flex-row gap-4 xl:gap-5")>
      <article className=%twc("w-full xl:w-3/5 flex flex-col gap-5")>
        <div className=%twc("flex flex-col gap-7 p-7 bg-white")>
          <Web_Order_Product_Info_Buyer query quantity />
          <div className=%twc("h-px bg-border-default-L2") />
          <Web_Order_Orderer_Info_Buyer />
        </div>
        <Web_Order_Delivery_Method_Selection_Buyer query quantity />
      </article>
      <aside className=%twc("w-full xl:w-2/5 xl:min-h-full xl:relative")>
        <Web_Order_Payment_Info_Buyer query quantity />
      </aside>
    </div>
  </main>
