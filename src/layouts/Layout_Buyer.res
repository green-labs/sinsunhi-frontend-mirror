module Responsive = {
  // warning: this module will be deprecated
  @react.component
  let make = (~pc=?, ~mobile=?) => {
    <>
      {pc->Option.mapWithDefault(React.null, pc' => {
        // PC View
        <div className=%twc("hidden xl:flex flex-col min-h-screen")> pc' </div>
      })}
      {mobile->Option.mapWithDefault(React.null, mobile' => {
        // Mobile View
        <div className=%twc("block xl:hidden w-full bg-white")>
          <div className=%twc("w-full max-w-3xl mx-auto relative bg-white min-h-screen")>
            mobile'
          </div>
        </div>
      })}
    </>
  }
}

@react.component
let make = (~children) => {
  // warning: this module will be deprecated
  let router = Next.Router.useRouter()

  let paths = {
    switch router.pathname->Js.String2.split("/")->List.fromArray {
    | list{} => []
    | list{_, ...pathnames} => pathnames->List.toArray // 첫번째 아이템은 항상 ""
    }
  }

  switch paths {
  // TEMP: 매칭 PDP는 모바일뷰 Only이므로, 기본 레이아웃 적용대상 예외
  | ["buyer", "products", "[pid]"] => children

  | _ =>
    <div className=%twc("w-full min-h-screen")>
      // PC Header
      <div className=%twc("hidden xl:flex")> <Header_Buyer.PC_Old key=router.asPath /> </div>
      // Mobile Header
      <div className=%twc("block xl:hidden")> <Header_Buyer.Mobile key=router.asPath /> </div>
      //------Content------
      children
      //-------------------
      // PC Footer
      <div className=%twc("hidden xl:flex")> <Footer_Buyer.PC /> </div>
      // Mobile Footer
      <div className=%twc("block xl:hidden")> <Footer_Buyer.MO /> </div>
    </div>
  }
}
