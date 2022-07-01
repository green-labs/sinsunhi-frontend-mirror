@react.component
let make = () => {
  open Next.Router
  let router = useRouter()

  React.useEffect0(_ => {
    router->replace("/admin/dashboard")

    None
  })

  <Authorization.Admin title=j`관리자`>
    <div className=%twc("container mx-auto flex justify-center items-center h-screen")>
      {`페이지 전환 중 입니다.`->React.string}
    </div>
  </Authorization.Admin>
}
