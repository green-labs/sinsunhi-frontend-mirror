open ReactHookForm
open Web_Order_Util_Component
module Form = Web_Order_Buyer_Form

module Fragment = %relay(`
        fragment WebOrderDeliveryMethodSelectionBuyerFragment on Query
        @argumentDefinitions(productNodeId: { type: "ID!" }) {
          productNode: node(id: $productNodeId) {
            ... on Product {
              isCourierAvailable
            }
          }
        }
  `)

module PlaceHoder = {
  @react.component
  let make = () => {
    <section className=%twc("flex flex-col p-7 gap-5 bg-white rounded-sm")>
      <span className=%twc("flex items-center gap-1 text-lg xl:text-xl text-enabled-L1 font-bold")>
        {`배송 방식 선택`->React.string}
        <Tooltip.PC className=%twc("hidden xl:flex")>
          {`선택하신 배송 방식에 따라 배송비 부과 정책이 달라집니다.`->React.string}
        </Tooltip.PC>
        <Tooltip.Mobile className=%twc("flex xl:hidden")>
          {`선택하신 배송 방식에 따라 배송비 부과 정책이 달라집니다.`->React.string}
        </Tooltip.Mobile>
      </span>
      <div className=%twc("flex gap-2")>
        <RadioButton.PlaceHolder /> <RadioButton.PlaceHolder /> <RadioButton.PlaceHolder />
      </div>
    </section>
  }
}

@react.component
let make = (~query, ~quantity) => {
  let {register, formState: {errors}} = Hooks.Context.use(.
    ~config=Hooks.Form.config(~mode=#onChange, ()),
    (),
  )

  let {productNode} = Fragment.use(query)

  let {ref, name, onChange, onBlur} = register(.
    Form.names.deliveryType,
    Some(Hooks.Register.config(~required=true, ())),
  )

  let watchValue = Hooks.WatchValues.use(
    Hooks.WatchValues.Text,
    ~config=Hooks.WatchValues.config(~name=Form.names.deliveryType, ()),
    (),
  )

  <section className=%twc("flex flex-col gap-5 p-7 bg-white rounded-sm")>
    <span className=%twc("flex items-center gap-1 text-lg xl:text-xl text-enabled-L1 font-bold")>
      {`배송 방식 선택`->React.string}
      <Tooltip.PC className=%twc("hidden xl:flex")>
        {`선택하신 배송 방식에 따라 배송비 부과 정책이 달라집니다.`->React.string}
      </Tooltip.PC>
      <Tooltip.Mobile className=%twc("flex xl:hidden")>
        {`선택하신 배송 방식에 따라 배송비 부과 정책이 달라집니다.`->React.string}
      </Tooltip.Mobile>
    </span>
    <div className=%twc("flex gap-2")>
      {{
        switch productNode {
        | Some(#Product({isCourierAvailable})) =>
          switch isCourierAvailable {
          | true => [
              ("parcel", `택배배송`),
              ("freight", `화물배송`),
              ("self", `직접수령`),
            ]
          | false => [("freight", `화물배송`), ("self", `직접수령`)]
          }
        | _ => []
        }
      }
      ->Array.map(((value, n)) =>
        <label
          key=n
          className=%twc(
            "focus:outline-none focus-within:bg-primary-light focus-within:outline-none focus-within:rounded-xl"
          )>
          <input className=%twc("sr-only") type_="radio" id=name ref name onChange onBlur value />
          <RadioButton watchValue name=n value />
        </label>
      )
      ->React.array}
    </div>
    <ErrorMessage
      name
      errors
      render={_ =>
        <span className=%twc("flex")>
          <IconError width="20" height="20" />
          <span className=%twc("text-sm text-notice ml-1")>
            {`배송 방식을 선택해주세요`->React.string}
          </span>
        </span>}
    />
    <Web_Order_Delivery_Form watchValue />
    <Web_Order_Hidden_Input_Buyer query quantity watchValue />
  </section>
}
