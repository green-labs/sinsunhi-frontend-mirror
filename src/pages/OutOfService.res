@react.component
let make = () => {
  ChannelTalkHelper.Hook.use()

  <>
    <Next.Head> <title> {j`서비스 점검 - 신선하이`->React.string} </title> </Next.Head>
    <section className=%twc("min-h-screen flex flex-col justify-center items-center")>
      <p className=%twc("text-xl font-bold")> {`서비스 점검 중 입니다.`->React.string} </p>
      <RadixUI.Separator.Root
        orientation=#horizontal className=%twc("h-px bg-div-border-L1 w-12 my-7")
      />
      <article className=%twc("flex flex-col justify-center items-center text-enabled-L3")>
        <p> {j`안녕하세요, 신선하이입니다.`->React.string} </p>
        <p> {j`주문서(발주서) 양식이 변경에 따라 `->React.string} </p>
        <p>
          {j`바이어센터가 4/11(월) 13:00~15:00까지 점검예정입니다.`->React.string}
        </p>
      </article>
      <article className=%twc("mt-7 flex")>
        <p>
          <Next.Link href="/seller/signin" passHref=true>
            <a className=%twc("font-bold text-green-gl px-2 cursor-pointer min-w-max")>
              {j`생산자 센터로 돌아가기`->React.string}
            </a>
          </Next.Link>
        </p>
        <p>
          <Next.Link href="/buyer/signin" passHref=true>
            <a className=%twc("font-bold text-green-gl px-2 cursor-pointer min-w-max")>
              {j`바이어 센터로 돌아가기`->React.string}
            </a>
          </Next.Link>
        </p>
      </article>
    </section>
  </>
}
