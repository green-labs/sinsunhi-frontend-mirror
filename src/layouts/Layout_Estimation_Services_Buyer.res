@react.component
let make = (~children) => {
  let router = Next.Router.useRouter()
  let paths = router.pathname->Js.String2.split("/")->Array.keep(x => x !== "")

  let secondPathname = paths->Garter.Array.get(1)
  let thirdPathname = paths->Garter.Array.get(2)
  let fourthPathname = paths->Garter.Array.get(3)

  switch (secondPathname, thirdPathname, fourthPathname) {
  // 견적요청(Rfq) 서비스
  | (Some("rfq"), None, _) => <Layout_Buyer> children </Layout_Buyer>
  | (Some("rfq"), Some(_), _) => children

  // 구매요청(Tradematch) 서비스
  | (Some("tradematch"), _, Some("apply"))
  | (Some("tradematch"), _, Some("applied")) => children

  | _ => <Layout_Buyer> children </Layout_Buyer>
  }
}
