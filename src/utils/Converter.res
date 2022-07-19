// - CREATE — 신규 주문 → 바이어가 아임웹에서 결제하고 신선하이 서비스에 발주서 엑셀을 업로드함
// - PACKING — 상품준비중 → 농민이 주문 들어온거 확인하고 상품 준비중으로 변경함
// - DEPARTURE — 집하중 → 농민이 택배 보내고 송장번호를 입력함
// - DELIVERING — 배송중 → 배송추적API를 통해 송장번호 배송상태 연동됨
// - COMPLETE — 배송완료 → 배송추적API를 통해 송장번호 배송완료 연동됨
// - CANCEL — 주문취소 → 바이어/어드민이 취소함
// - ERROR — 송장번호에러 → 송장번호 입력했을때 배송추적API 호출하는데, 여기서 송장번호 유효성검사 실패한 경우
// - REFUND - 환불
module Status = (
  T: {
    type status =
      | CREATE
      | PACKING
      | DEPARTURE
      | DELIVERING
      | COMPLETE
      | CANCEL
      | ERROR
      | REFUND
      | NEGOTIATING
  },
) => {
  let displayStatus = (s: T.status) =>
    switch s {
    | CREATE => `신규주문`
    | PACKING => `상품준비중`
    | DEPARTURE => `집하중`
    | DELIVERING => `배송중`
    | COMPLETE => `배송완료`
    | CANCEL => `주문취소`
    | ERROR => `송장번호에러`
    | REFUND => `환불처리`
    | NEGOTIATING => `협의중`
    }
}

module RefundReason = (
  T: {
    type refundReason = DeliveryDelayed | DefectiveProduct
  },
) => {
  let displayRefundReason = (r: T.refundReason) => {
    switch r {
    | DeliveryDelayed => `배송지연`
    | DefectiveProduct => `상품불량`
    }
  }
}

module SalesStatus = (
  T: {
    type salesStatus = SALE | SOLDOUT | HIDDEN_SALE | NOSALE | RETIRE | HIDDEN
  },
) => {
  let statusToString = (s: T.salesStatus) =>
    switch s {
    | SALE => `판매중`
    | SOLDOUT => `품절`
    | HIDDEN_SALE => `전시판매숨김`
    | NOSALE => `숨김`
    | RETIRE => `영구판매중지`
    | HIDDEN => `숨김`
    }
}

let stringifySettlementCycle = (c: CustomHooks.Settlements.settlementCycle) =>
  switch c {
  | Week => `1주일`
  | HalfMonth => `15일`
  | Month => `1개월`
  }

let displayTransactionKind = k => {
  open CustomHooks.Transaction
  switch k {
  | OrderComplete => `상품발주`
  | CashRefund => `잔액환불`
  | ImwebPay => `상품결제`
  | ImwebCancel => `상품결제취소`
  | OrderCancel => `주문취소`
  | OrderRefundDeliveryDelayed => `환불(배송지연)`
  | OrderRefundDefectiveProduct => `환불(상품불량)`
  | SinsunCash => `신선캐시 충전`
  }
}

let displayUserBuyerStatus = s => {
  open CustomHooks.QueryUser.Buyer
  switch s {
  | CanOrder => `거래가능`
  | CanNotOrder => `거래불가`
  }
}

let getStringFromJsonWithDefault = (j, default) =>
  j->Js.Json.decodeString->Option.getWithDefault(default)
