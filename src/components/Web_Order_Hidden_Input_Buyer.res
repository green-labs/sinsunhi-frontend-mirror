module Fragment = %relay(`
        fragment WebOrderHiddenInputBuyerFragment on Query
        @argumentDefinitions(
          productNodeId: { type: "ID!" }
          productOptionNodeId: { type: "ID!" }
        ) {
          productNode: node(id: $productNodeId) {
            ... on NormalProduct {
              productId
              name
              isVat
              image {
                original
              }
            }
        
            ... on QuotableProduct {
              productId
              name
              isVat
              image {
                original
              }
            }
          }
          productOptionNode: node(id: $productOptionNodeId) {
            ... on ProductOption {
              optionName
              price
              productOptionCost {
                deliveryCost
              }
              stockSku
              grade
            }
          }
        }
  `)

open ReactHookForm
module Form = Web_Order_Buyer_Form

module Hidden = {
  @react.component
  let make = (~value, ~inputName, ~isNumber=false) => {
    let {register} = Hooks.Context.use(. ~config=Hooks.Form.config(~mode=#all, ()), ())
    let {ref, name} = register(.
      inputName,
      isNumber ? Some(Hooks.Register.config(~valueAsNumber=true, ())) : None,
    )

    <input type_="hidden" id=name ref name defaultValue=?value />
  }
}

@react.component
let make = (~query, ~quantity, ~watchValue) => {
  let fragments = Fragment.use(query)
  let {control} = Hooks.Context.use(. ~config=Hooks.Form.config(~mode=#all, ()), ())

  let productInfo = switch fragments.productNode {
  | Some(product) =>
    switch product {
    | #NormalProduct({productId, name, isVat}) => <>
        <Hidden
          inputName=Form.names.productId value={Some(productId->Int.toString)} isNumber=true
        />
        <Hidden inputName=Form.names.productName value={Some(name)} />
        <Controller
          control
          name=Form.names.isTaxFree
          defaultValue={!isVat->Js.Json.boolean}
          render={_ => <div />}
        />
      </>
    | _ => React.null
    }
  | None => React.null
  }

  let optionInfo = switch fragments.productOptionNode {
  | Some(productOption) =>
    switch productOption {
    | #ProductOption({optionName, stockSku, grade, productOptionCost, price}) => <>
        <Hidden inputName=Form.names.productOptionName value={Some(optionName)} />
        <Hidden
          inputName=Form.names.deliveryCost
          value={Some(productOptionCost.deliveryCost->Int.toString)}
          isNumber=true
        />
        <Hidden inputName=Form.names.stockSku value={Some(stockSku)} />
        <Hidden inputName=Form.names.grade value={grade} />
        {switch watchValue {
        | Some(deliveryType') =>
          switch deliveryType'->Js.Json.string->Form.deliveryType_decode {
          | Ok(decode') =>
            switch decode' {
            | #FREIGHT
            | #SELF =>
              <Hidden inputName=Form.names.totalDeliveryCost value={Some("0")} isNumber=true />
            | #PARCEL =>
              <Hidden
                inputName=Form.names.totalDeliveryCost
                value={Some((quantity * productOptionCost.deliveryCost)->Int.toString)}
                isNumber=true
              />
            }
          | Error(_) =>
            <Hidden
              inputName=Form.names.totalDeliveryCost
              value={Some((quantity * productOptionCost.deliveryCost)->Int.toString)}
              isNumber=true
            />
          }
        | None => React.null
        }}
        <Hidden
          inputName=Form.names.totalOrderPrice
          value={Some((quantity * price->Option.getWithDefault(0))->Int.toString)}
          isNumber=true
        />
        <Hidden
          inputName=Form.names.price
          value={Some(price->Option.getWithDefault(0)->Int.toString)}
          isNumber=true
        />
        <Hidden inputName=Form.names.quantity value={Some(quantity->Int.toString)} isNumber=true />
      </>
    | _ => React.null
    }
  | None => React.null
  }

  let user = CustomHooks.User.Buyer.use2()

  let userInfo = switch user {
  | LoggedIn(user') => <>
      <Hidden inputName=Form.names.orderUserId value={Some(user'.id->Int.toString)} isNumber=true />
      <Hidden inputName=Form.names.ordererName value={Some(user'.name)} />
      <Hidden inputName=Form.names.ordererPhone value={user'.phone} />
    </>
  | _ => React.null
  }

  <>
    {productInfo}
    {optionInfo}
    {userInfo}
    <Hidden inputName=Form.names.paymentPurpose value={Some("ORDER")} />
  </>
}
