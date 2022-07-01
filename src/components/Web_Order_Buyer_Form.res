let name = "web-order"

@spice
type deliveryType = [
  | @spice.as("parcel") #PARCEL
  | @spice.as("freight") #FREIGHT
  | @spice.as("self") #SELF
]

@spice
type paymentMethod = [
  | @spice.as("card") #CREDIT_CARD
  | @spice.as("virtual") #VIRTUAL_ACCOUNT
  | @spice.as("transfer") #TRANSFER
]

@spice
type productOptions = {
  @spice.key("delivery-cost") deliveryCost: option<int>,
  @spice.key("delivery-desired-date") deliveryDesiredDate: option<string>,
  @spice.key("delivery-message") deliveryMessage: option<string>,
  @spice.key("delivery-type") deliveryType: deliveryType,
  grade: option<string>,
  @spice.key("is-tax-free") isTaxFree: bool,
  @spice.key("orderer-name") ordererName: string,
  @spice.key("orderer-phone") ordererPhone: string,
  price: int,
  @spice.key("product-id") productId: int,
  @spice.key("product-name") productName: string,
  @spice.key("product-option-name") productOptionName: string,
  quantity: int,
  @spice.key("receiver-address") receiverAddress: option<string>,
  @spice.key("receiver-name") receiverName: option<string>,
  @spice.key("receiver-phone") receiverPhone: option<string>,
  @spice.key("receiver-zipcode") receiverZipCode: option<string>,
  @spice.key("receiver-detail-address") receiverDetailAddress: option<string>,
  @spice.key("stock-sku") stockSku: string,
}

@spice
type webOrder = {
  @spice.key("order-user-id") orderUserId: int,
  @spice.key("payment-purpose") paymentPurpose: string,
  @spice.key("total-delivery-cost") totalDeliveryCost: int,
  @spice.key("total-order-price") totalOrderPrice: int,
  @spice.key("product-options") productOptions: array<productOptions>,
  @spice.key("payment-method") paymentMethod: paymentMethod,
}

@spice
type submit = {@spice.key("web-order") webOrder: webOrder}

type inputNames = {
  orderUserId: string,
  paymentPurpose: string,
  totalDeliveryCost: string,
  totalOrderPrice: string,
  paymentMethod: string,
  deliveryCost: string,
  deliveryDesiredDate: string,
  deliveryMessage: string,
  deliveryType: string,
  grade: string,
  isTaxFree: string,
  ordererName: string,
  ordererPhone: string,
  price: string,
  productId: string,
  productName: string,
  productOptionName: string,
  quantity: string,
  receiverAddress: string,
  receiverName: string,
  receiverPhone: string,
  receiverZipCode: string,
  receiverDetailAddress: string,
  stockSku: string,
}
let names = {
  orderUserId: `${name}.order-user-id`,
  paymentPurpose: `${name}.payment-purpose`,
  totalDeliveryCost: `${name}.total-delivery-cost`,
  totalOrderPrice: `${name}.total-order-price`,
  paymentMethod: `${name}.payment-method`,
  deliveryCost: `${name}.product-options.0.delivery-cost`,
  deliveryDesiredDate: `${name}.product-options.0.delivery-desired-date`,
  deliveryMessage: `${name}.product-options.0.delivery-message`,
  deliveryType: `${name}.product-options.0.delivery-type`,
  grade: `${name}.product-options.0.grade`,
  isTaxFree: `${name}.product-options.0.is-tax-free`,
  ordererName: `${name}.product-options.0.orderer-name`,
  ordererPhone: `${name}.product-options.0.orderer-phone`,
  price: `${name}.product-options.0.price`,
  productId: `${name}.product-options.0.product-id`,
  productName: `${name}.product-options.0.product-name`,
  productOptionName: `${name}.product-options.0.product-option-name`,
  quantity: `${name}.product-options.0.quantity`,
  receiverAddress: `${name}.product-options.0.receiver-address`,
  receiverName: `${name}.product-options.0.receiver-name`,
  receiverPhone: `${name}.product-options.0.receiver-phone`,
  receiverZipCode: `${name}.product-options.0.receiver-zipcode`,
  receiverDetailAddress: `${name}.product-options.0.receiver-detail-address`,
  stockSku: `${name}.product-options.0.stock-sku`,
}

let defaultValue = isCourierAvailable =>
  [("delivery-type", Js.Json.string(isCourierAvailable ? "parcel" : "freight"))]
  ->Js.Dict.fromArray
  ->Js.Json.object_
