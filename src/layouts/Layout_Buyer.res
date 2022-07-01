module Responsive = {
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
  let router = Next.Router.useRouter()

  <div className=%twc("w-full min-h-screen")>
    // PC Header
    <div className=%twc("hidden xl:flex")> <Header_Buyer.PC key=router.asPath /> </div>
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
