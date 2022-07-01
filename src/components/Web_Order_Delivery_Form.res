open Web_Order_Inputs_Buyer
module Form = Web_Order_Buyer_Form

@react.component
let make = (~watchValue) => {
  switch watchValue {
  | Some(deliveryType') =>
    switch deliveryType'->Js.Json.string->Form.deliveryType_decode {
    | Ok(decode') => <>
        <div className=%twc("py-7 flex flex-col gap-5 border border-div-border-L2 border-x-0")>
          {switch decode' {
          | #PARCEL => <>
              <ReceiverNameInput />
              <ReceiverPhoneInput />
              <ReceiverAddressInput />
              <DeliveryMessageInput />
            </>
          | #FREIGHT => <>
              <DeliveryDesiredDateSelection />
              <ReceiverNameInput />
              <ReceiverPhoneInput />
              <ReceiverAddressInput />
              <DeliveryMessageInput />
            </>
          | #SELF => <>
              <DeliveryDesiredDateSelection selfMode=true />
              <div className=%twc("flex flex-col xl:flex-row items-baseline")>
                <label className=%twc("xl:w-1/4 mb-2 xl:mb-0 block font-bold")>
                  {`수령지`->React.string}
                </label>
                <span className=%twc("gap-1 xl:w-3/4 text-sm text-text-L1")>
                  {`상품을 수령하실 수 있는 주소지는 결제 후, 담당MD가 직접 연락드려 전달드릴 예정입니다.`->React.string}
                </span>
              </div>
              <DeliveryMessageInput selfMode=true />
            </>
          }}
        </div>
        <PaymentMethodSelection />
      </>
    | Error(_) => React.null
    }
  | None => React.null
  }
}
