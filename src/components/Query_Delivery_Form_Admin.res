// farmer-name (바이어명)
// order-product-no (주문번호)
// product-id (상품번호)
// orderer-name (주문자명)
// receiver-name (수취인명)
// sku (단품번호)

module FormFields = %lenses(
  type state = {
    farmerName: string,
    orderProductNo: string,
    productId: string,
    ordererName: string,
    receiverName: string,
    sku: string,
  }
)

module Form = ReForm.Make(FormFields)

let initialState: FormFields.state = {
  farmerName: "",
  orderProductNo: "",
  productId: "",
  ordererName: "",
  receiverName: "",
  sku: "",
}
