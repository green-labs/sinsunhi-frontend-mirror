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
    let {fragmentRefs} = Fragment.use(query)

    <>
      <section className=%twc("w-full bg-white pt-12 pb-20")>
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
      </section>
      <ShopMainSpecialShowcaseList_Buyer.PC query=fragmentRefs />
    </>
  }
}

module MO = {
  @react.component
  let make = (~query) => {
    let {fragmentRefs} = Fragment.use(query)

    <>
      <div className=%twc("w-full p-3 pt-1 bg-white sticky top-0 z-10")>
        <ShopSearchInput_Buyer.MO />
      </div>
      <div className=%twc("w-full flex flex-col bg-white pb-16")>
        // 배너
        <section className=%twc("w-full px-5")>
          <div className=%twc("mt-5")> <ShopMain_MainBanner_Buyer.MO query=fragmentRefs /> </div>
          <div className=%twc("mt-3")> <ShopMain_SubBanner_Buyer.MO query=fragmentRefs /> </div>
        </section>
        // 카테고리
        <section className=%twc("w-full mt-12")>
          <ShopMain_CategoryList_Buyer.MO query=fragmentRefs />
        </section>
        // 기획전
        <ShopMainSpecialShowcaseList_Buyer.MO query=fragmentRefs />
      </div>
    </>
  }
}

module Placeholder = {
  @react.component
  let make = () => {
    <Layout_Buyer.Responsive
      pc={<section className=%twc("w-full bg-white pt-12 pb-20")>
        <div className=%twc("w-[1280px] mx-auto")>
          <div className=%twc("flex gap-5 px-5")>
            <div className=%twc("w-[920px]")> <ShopMain_MainBanner_Buyer.PC.Placeholder /> </div>
            <div className=%twc("w-[300px]")> <ShopMain_SubBanner_Buyer.PC.Placeholder /> </div>
          </div>
          <div className=%twc("w-full mt-20")> <ShopMain_CategoryList_Buyer.PC.Placeholder /> </div>
        </div>
        <div className=%twc("mt-12")> <ShopMainSpecialShowcaseList_Buyer.PC.Placeholder /> </div>
      </section>}
      mobile={<>
        <div className=%twc("w-full p-3 pt-1 bg-white sticky top-0 z-10")>
          <ShopSearchInput_Buyer.MO />
        </div>
        <div className=%twc("bg-white pt-5 px-5")>
          <ShopMain_MainBanner_Buyer.MO.Placeholder />
        </div>
        <div className=%twc("mt-3 px-5")> <ShopMain_SubBanner_Buyer.MO.Placeholder /> </div>
        <div className=%twc("mt-12 pb-12")> <ShopMain_CategoryList_Buyer.MO.Placeholder /> </div>
        <ShopMainSpecialShowcaseList_Buyer.MO.Placeholder />
      </>}
    />
  }
}

module Container = {
  @react.component
  let make = () => {
    // 채널톡 버튼 사용
    ChannelTalkHelper.Hook.use()

    let {fragmentRefs} = Query.use(~variables=(), ~fetchPolicy=RescriptRelay.StoreAndNetwork, ())

    <Layout_Buyer.Responsive pc={<PC query=fragmentRefs />} mobile={<MO query=fragmentRefs />} />
  }
}

@react.component
let make = () => {
  let (isCsr, setIsCsr) = React.Uncurried.useState(_ => false)

  React.useEffect0(() => {
    setIsCsr(._ => true)
    None
  })

  <>
    <Next.Head> <title> {`신선하이`->React.string} </title> </Next.Head>
    <RescriptReactErrorBoundary fallback={_ => <Placeholder />}>
      <React.Suspense fallback={<Placeholder />}>
        {switch isCsr {
        | true => <Container />

        | false => <Placeholder />
        }}
      </React.Suspense>
    </RescriptReactErrorBoundary>
    <SignUp_Buyer_Survey /> // 회원가입완료 survey
  </>
}
