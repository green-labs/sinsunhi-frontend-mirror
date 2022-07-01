module Fragment = %relay(`
    fragment WebOrderCompleteDeliveryInfoBuyerFragment on Query
    @argumentDefinitions(orderNo: { type: "String!" }) {
      wosOrder(orderNo: $orderNo) {
        orderProducts {
          deliveryType
          deliveryDesiredDate
          receiverName
          receiverPhone
          receiverAddress
          deliveryMessage
        }
      }
    }    
`)

let deliveryTypetoString = d =>
  switch d {
  | #PARCEL => `택배배송`
  | #FREIGHT => `화물배송`
  | #SELF => `직접수령`
  | _ => `-`
  }

module Placeholder = {
  @react.component
  let make = () => {
    open Skeleton
    <section className=%twc("flex flex-col gap-5 bg-white rounded-sm")>
      <span className=%twc("text-lg xl:text-xl text-enabled-L1 font-bold")>
        {`배송 정보`->React.string}
      </span>
      <ul className=%twc("flex flex-col")>
        <li className=%twc("flex gap-5")>
          <Box className=%twc("w-18") /> <Box className=%twc("w-32") />
        </li>
        <li className=%twc("flex gap-5")>
          <Box className=%twc("w-18") /> <Box className=%twc("w-32") />
        </li>
        <li className=%twc("flex gap-5")>
          <Box className=%twc("w-18") /> <Box className=%twc("w-32") />
        </li>
        <li className=%twc("flex gap-5")>
          <Box className=%twc("w-18") /> <Box className=%twc("w-32") />
        </li>
        <li className=%twc("flex gap-5")>
          <Box className=%twc("w-18") /> <Box className=%twc("w-32") />
        </li>
        <li className=%twc("flex gap-5")>
          <Box className=%twc("w-18") /> <Box className=%twc("w-32") />
        </li>
      </ul>
    </section>
  }
}

@react.component
let make = (~query) => {
  let {wosOrder} = Fragment.use(query)

  let toPhoneNumberForm = s =>
    s
    ->Js.String2.replaceByRe(%re("/[^0-9]/g"), "")
    ->Js.String2.replaceByRe(%re("/(^1[0-9]{3}|^0[0-9]{2})([0-9]+)?([0-9]{4})$/"), "$1-$2-$3")
    ->Js.String2.replace("--", "-")

  switch wosOrder->Option.flatMap(wosOrder' => wosOrder'.orderProducts->Array.get(0)) {
  | Some(Some({
      deliveryType,
      deliveryDesiredDate,
      receiverName,
      receiverPhone,
      receiverAddress,
      deliveryMessage,
    })) =>
    <section className=%twc("flex flex-col gap-5 bg-white rounded-sm")>
      <span className=%twc("text-lg xl:text-xl text-enabled-L1 font-bold")>
        {`배송 정보`->React.string}
      </span>
      <ul className=%twc("flex flex-col text-sm gap-2")>
        <li className=%twc("flex")>
          <span className=%twc("w-23 font-bold")> {`배송방법`->React.string} </span>
          <span> {deliveryType->deliveryTypetoString->React.string} </span>
        </li>
        {switch (deliveryType, deliveryDesiredDate) {
        | (#PARCEL, _) => React.null
        | (_, Some(deliveryDesiredDate')) =>
          let timezone = Js.Date.now()->Js.Date.fromFloat->Js.Date.getTimezoneOffset
          <li className=%twc("flex")>
            <span className=%twc("w-23 font-bold")> {`배송희망일`->React.string} </span>
            <span>
              {deliveryDesiredDate'
              ->Js.Date.fromString
              ->DateFns.subMinutesf(timezone)
              ->DateFns.format("yyyy-MM-dd")
              ->React.string}
            </span>
          </li>
        | (_, None) => React.null
        }}
        {switch (deliveryType, receiverName) {
        | (#SELF, _) => React.null
        | (_, Some(receiverName')) =>
          <li className=%twc("flex")>
            <span className=%twc("w-23 font-bold")> {`이름`->React.string} </span>
            <span className=%twc("whitespace-pre-wrap")> {receiverName'->React.string} </span>
          </li>
        | (_, None) => React.null
        }}
        {switch (deliveryType, receiverPhone) {
        | (#SELF, _) => React.null
        | (_, Some(receiverPhone')) =>
          <li className=%twc("flex")>
            <span className=%twc("w-23 font-bold")> {`배송지 연락처`->React.string} </span>
            <span> {receiverPhone'->toPhoneNumberForm->React.string} </span>
          </li>
        | (_, None) => React.null
        }}
        {switch (deliveryType, receiverAddress) {
        | (#SELF, _) => React.null
        | (_, Some(receiverAddress')) =>
          <li className=%twc("flex")>
            <span className=%twc("w-23 font-bold")> {`배송지 주소`->React.string} </span>
            <span className=%twc("xl:w-64 w-56 whitespace-pre-wrap")>
              {receiverAddress'->React.string}
            </span>
          </li>
        | (_, None) => React.null
        }}
        {switch deliveryMessage {
        | Some(deliveryMessage') =>
          <li className=%twc("flex")>
            <span className=%twc("w-23 font-bold")> {`배송 요청사항`->React.string} </span>
            <span className=%twc("xl:w-64 w-56 whitespace-pre-wrap")>
              {deliveryMessage'->React.string}
            </span>
          </li>
        | None => React.null
        }}
      </ul>
    </section>
  | _ => <Placeholder />
  }
}
