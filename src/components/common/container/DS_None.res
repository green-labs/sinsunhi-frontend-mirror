module Default = {
  @react.component
  let make = (~message) => {
    <section
      className=%twc("relative container max-w-3xl mx-auto min-h-screen sm:shadow-gl bg-gray-50")>
      <div className=%twc("px-5 pt-8")> <DS_TitleList.Left.TitleSubtitle1 title1={message} /> </div>
    </section>
  }
}
