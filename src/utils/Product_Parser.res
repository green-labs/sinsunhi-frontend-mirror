module Type = {
  // 서비스에서 지원하는 상품 타입을 관리한다.
  /*
   * Normal: 일반
   * Quotable: 일반 + 견적문의 가능
   * Quoted: 견적
   * Matching: 매칭
   */
  type t = Normal | Quotable | Quoted | Matching

  let decode = (s: string) => {
    switch s {
    | "NormalProduct" => Some(Normal)
    | "QuotableProduct" => Some(Quotable)
    | "QuotedProduct" => Some(Quoted)
    | "MatchingProduct" => Some(Matching)
    | _ => None
    }
  }

  let encode = t => {
    switch t {
    | Normal => "NormalProduct"
    | Quotable => "QuotableProduct"
    | Quoted => "QuotedProduct"
    | Matching => "MatchingProduct"
    }
  }
}
