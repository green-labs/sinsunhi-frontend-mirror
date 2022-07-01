/**
 * 수기 주문데이터 관리자 업로드 시연용 컴포넌트
 * TODO: 시연이 끝나면 지워도 된다.
 */
// 상품명 - product-name
// 생산자명 - producer-name
// 바이어명 - buyer-name
module FormFields = %lenses(
  type state = {
    productName: string,
    producerName: string,
    buyerName: string,
  }
)

module Form = ReForm.Make(FormFields)

let initialState: FormFields.state = {
  productName: "",
  producerName: "",
  buyerName: "",
}
