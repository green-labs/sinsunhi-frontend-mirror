module Query = %relay(`
  query ShopMainBuyerQuery {
    ...ShopMainBuyerFragment
  }
`)

module Fragment = %relay(`
    fragment ShopMainBuyerFragment on Query {
      ...ShopMainMainBannerBuyerFragment
      ...ShopMainSubBannerBuyer
      ...ShopMainSpecialShowcaseListBuyerFragment
      ...ShopMainCategoryListBuyerQuery
    }
  `)

module PC = {
  @react.component
  let make = (~query) => {
    let router = Next.Router.useRouter()
    let {fragmentRefs} = Fragment.use(query)

    <div className=%twc("w-full min-w-[1280px] min-h-screen")>
      <Header_Buyer.PC key=router.asPath />
      <main className=%twc("w-full bg-white pt-12 pb-20")>
        <div className=%twc("w-[1280px] mx-auto")>
          <div className=%twc("flex px-5")>
            <div className=%twc("w-[920px]")>
              <ShopMain_MainBanner_Buyer.PC query=fragmentRefs />
            </div>
            <div className=%twc("ml-5 w-[310px]")>
              <ShopMain_SubBanner_Buyer.PC query=fragmentRefs />
            </div>
          </div>
          <div className=%twc("w-full mt-20")>
            <ShopMain_CategoryList_Buyer.PC query=fragmentRefs />
          </div>
        </div>
      </main>
      <ShopMainSpecialShowcaseList_Buyer.PC query=fragmentRefs />
      <Footer_Buyer.PC />
    </div>
  }
}

module MO = {
  @react.component
  let make = (~query) => {
    let router = Next.Router.useRouter()
    let {fragmentRefs} = Fragment.use(query)

    <div className=%twc("w-full min-h-screen")>
      <div className=%twc("w-full bg-white")>
        <div className=%twc("w-full max-w-3xl mx-auto bg-white min-h-screen")>
          <Header_Buyer.Mobile.GnbHome key=router.asPath />
          <div className=%twc("w-full p-3 pt-1 bg-white sticky top-0 z-10")>
            <ShopSearchInput_Buyer.MO />
          </div>
          <div className=%twc("w-full flex flex-col bg-white pb-16")>
            <section className=%twc("w-full px-5")>
              <div className=%twc("mt-5")>
                <ShopMain_MainBanner_Buyer.MO query=fragmentRefs />
              </div>
              <div className=%twc("mt-3")> <ShopMain_SubBanner_Buyer.MO query=fragmentRefs /> </div>
            </section>
            <section className=%twc("w-full mt-12")>
              <ShopMain_CategoryList_Buyer.MO query=fragmentRefs />
            </section>
            <ShopMainSpecialShowcaseList_Buyer.MO query=fragmentRefs />
          </div>
          <Footer_Buyer.MO />
        </div>
      </div>
    </div>
  }
}

module Placeholder = {
  @react.component
  let make = (~deviceType) => {
    let router = Next.Router.useRouter()

    switch deviceType {
    | DeviceDetect.Unknown => React.null

    | DeviceDetect.Mobile =>
      <div className=%twc("w-full min-h-screen")>
        <Header_Buyer.Mobile.GnbHome key=router.asPath />
        <div className=%twc("w-full p-3 pt-1 bg-white sticky top-0 z-10")>
          <ShopSearchInput_Buyer.MO />
        </div>
        <div className=%twc("bg-white pt-5 px-5")>
          <ShopMain_MainBanner_Buyer.MO.Placeholder />
        </div>
        <div className=%twc("mt-3 px-5")> <ShopMain_SubBanner_Buyer.MO.Placeholder /> </div>
        <div className=%twc("mt-12 pb-12")> <ShopMain_CategoryList_Buyer.MO.Placeholder /> </div>
        <ShopMainSpecialShowcaseList_Buyer.MO.Placeholder />
        <Footer_Buyer.MO />
      </div>

    | DeviceDetect.PC =>
      <div className=%twc("w-full min-w-[1280px] min-h-screen")>
        <Header_Buyer.PC key=router.asPath />
        <main className=%twc("w-full bg-white pt-12 pb-20")>
          <div className=%twc("w-[1280px] mx-auto")>
            <div className=%twc("flex gap-5 px-5")>
              <div className=%twc("w-[920px]")> <ShopMain_MainBanner_Buyer.PC.Placeholder /> </div>
              <div className=%twc("w-[300px]")> <ShopMain_SubBanner_Buyer.PC.Placeholder /> </div>
            </div>
            <div className=%twc("w-full mt-20")>
              <ShopMain_CategoryList_Buyer.PC.Placeholder />
            </div>
          </div>
          <div className=%twc("mt-12")> <ShopMainSpecialShowcaseList_Buyer.PC.Placeholder /> </div>
        </main>
        <Footer_Buyer.PC />
      </div>
    }
  }
}

module Container = {
  @react.component
  let make = (~deviceType) => {
    // 채널톡 버튼 사용
    ChannelTalkHelper.Hook.use()

    let {fragmentRefs} = Query.use(~variables=(), ~fetchPolicy=RescriptRelay.StoreAndNetwork, ())

    switch deviceType {
    | DeviceDetect.Unknown => React.null
    | DeviceDetect.PC => <PC query=fragmentRefs />
    | DeviceDetect.Mobile => <MO query=fragmentRefs />
    }
  }
}

@react.component
let make = (~deviceType) => {
  let (isCsr, setIsCsr) = React.Uncurried.useState(_ => false)

  React.useEffect0(() => {
    setIsCsr(._ => true)
    None
  })

  <>
    <Next.Head> <title> {`신선하이`->React.string} </title> </Next.Head>
    <RescriptReactErrorBoundary fallback={_ => <Placeholder deviceType />}>
      <React.Suspense fallback={<Placeholder deviceType />}>
        {switch isCsr {
        | true => <Container deviceType />
        | false => <Placeholder deviceType />
        }}
      </React.Suspense>
    </RescriptReactErrorBoundary>
  </>
}
