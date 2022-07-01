module Query = %relay(`
  query GnbBannerListBuyerQuery {
    gnbBanners {
      id
      title
      landingUrl
      isNewTabPc
      isNewTabMobile
    }
  }
`)

module Container = {
  @react.component
  let make = () => {
    let {gnbBanners} = Query.use(~variables=(), ~fetchPolicy=RescriptRelay.StoreOrNetwork, ())

    <div className=%twc("flex items-center py-3 text-lg text-gray-800 font-bold")>
      {gnbBanners
      ->Array.map(({id, title, landingUrl, isNewTabPc}) => {
        let target = isNewTabPc ? "_blank" : "_self"
        <Next.Link key={`gnb-banner-${id}`} href=landingUrl>
          <a target className=%twc("ml-4 cursor-pointer")> {title->React.string} </a>
        </Next.Link>
      })
      ->React.array}
    </div>
  }
}

@react.component
let make = () => {
  let (isCsr, setIsCsr) = React.Uncurried.useState(_ => false)

  React.useEffect0(() => {
    setIsCsr(._ => true)

    None
  })

  isCsr ? <Container /> : React.null
}
