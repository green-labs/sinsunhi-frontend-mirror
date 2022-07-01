@react.component
let make = (~children) => {
  let router = Next.Router.useRouter()
  let thirdPathname =
    router.pathname->Js.String2.split("/")->Array.keep(x => x !== "")->Garter.Array.get(2)

  switch thirdPathname {
  | Some(_) => children
  | None => <Layout_Buyer> children </Layout_Buyer>
  }
}
