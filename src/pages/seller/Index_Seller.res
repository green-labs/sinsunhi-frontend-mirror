@react.component
let make = () => {
  open Next.Router

  let router = useRouter()

  React.useEffect(() => {
    router->replace(`/seller/orders?status=CREATE&sort=created`)

    None
  })

  <>
    <Next.Head> <title> {j`생산자 - 신선하이`->React.string} </title> </Next.Head>
    <div className=%twc("container mx-auto flex justify-center items-center h-screen")>
      {`페이지 전환 중 입니다.`->React.string}
    </div>
  </>
}
