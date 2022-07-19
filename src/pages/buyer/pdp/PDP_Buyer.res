module Query = %relay(`
  query PDPBuyerQuery($id: ID!) {
    node(id: $id) {
      ...PDPBuyerFragment
  
      # gtm attrs
      ...PDPGtmBuyer_fragment
    }
  }
`)

module Fragment = %relay(`
  fragment PDPBuyerFragment on Product {
    # Commons
    id
    name
    __typename
  
    # Fragments
    ...PDPNormalBuyerFragment
    ...PDPQuotedBuyerFragment
    ...PDPMatchingBuyer_fragment
  }
`)

module Placeholder = {
  @react.component
  let make = (~deviceType) => {
    let router = Next.Router.useRouter()

    switch deviceType {
    | DeviceDetect.Unknown => React.null

    | DeviceDetect.PC =>
      <div className=%twc("w-full min-w-[1280px] min-h-screen")>
        <Header_Buyer.PC key=router.asPath />
        <div className=%twc("w-[1280px] mx-auto min-h-full")>
          <div className=%twc("w-full pt-16 px-5")>
            <section className=%twc("w-full flex justify-between")>
              <div>
                <div
                  className=%twc("w-[664px] aspect-square rounded-xl bg-gray-150 animate-pulse")
                />
                <div
                  className=%twc("mt-12 w-[664px] h-[92px] rounded-xl bg-gray-150 animate-pulse")
                />
                <div
                  className=%twc("mt-4 w-[563px] h-[23px] rounded-lg bg-gray-150 animate-pulse")
                />
              </div>
              <div>
                <div className=%twc("w-[496px] h-[44px] rounded-lg bg-gray-150 animate-pulse") />
                <div
                  className=%twc("mt-4 w-[123px] h-[44px] rounded-lg bg-gray-150 animate-pulse")
                />
                <div
                  className=%twc("mt-4 w-[496px] h-[56px] rounded-xl bg-gray-150 animate-pulse")
                />
                <div className=%twc("mt-4 w-[496px] rounded-xl border border-gray-200 px-6 py-8")>
                  <div className=%twc("w-[80px] h-[26px] rounded-md bg-gray-150 animate-pulse") />
                  <div className=%twc("mt-5 flex items-center justify-between")>
                    <div className=%twc("w-[88px] h-[24px] rounded-md bg-gray-150 animate-pulse") />
                    <div className=%twc("w-[68px] h-[24px] rounded-md bg-gray-150 animate-pulse") />
                  </div>
                  <div className=%twc("mt-1 flex items-center justify-between")>
                    <div className=%twc("w-[56px] h-[24px] rounded-md bg-gray-150 animate-pulse") />
                    <div className=%twc("w-[48px] h-[24px] rounded-md bg-gray-150 animate-pulse") />
                  </div>
                  <div className=%twc("mt-1 flex items-center justify-between")>
                    <div className=%twc("w-[72px] h-[24px] rounded-md bg-gray-150 animate-pulse") />
                    <div className=%twc("w-[56px] h-[24px] rounded-md bg-gray-150 animate-pulse") />
                  </div>
                  <div className=%twc("mt-1 flex items-center justify-between")>
                    <div className=%twc("w-[64px] h-[24px] rounded-md bg-gray-150 animate-pulse") />
                    <div className=%twc("w-[48px] h-[24px] rounded-md bg-gray-150 animate-pulse") />
                  </div>
                  <RadixUI.Separator.Root className=%twc("h-px bg-gray-100 my-4") />
                  <div
                    className=%twc("mt-6 w-[40px] h-[24px] rounded-md bg-gray-150 animate-pulse")
                  />
                  <div
                    className=%twc("mt-4 w-[440px] h-[80px] rounded-md bg-gray-150 animate-pulse")
                  />
                  <div
                    className=%twc("mt-6 w-[40px] h-[24px] rounded-md bg-gray-150 animate-pulse")
                  />
                  <div
                    className=%twc("mt-4 w-[440px] h-[80px] rounded-md bg-gray-150 animate-pulse")
                  />
                  <div className=%twc("mt-12 flex items-center justify-between")>
                    <div className=%twc("w-[86px] h-[26px] rounded-md bg-gray-150 animate-pulse") />
                    <div
                      className=%twc("w-[117px] h-[38px] rounded-md bg-gray-150 animate-pulse")
                    />
                  </div>
                </div>
              </div>
            </section>
            <RadixUI.Separator.Root className=%twc("h-px bg-gray-100 my-12") />
            <section>
              <div className=%twc("mt-4 w-[144px] h-[38px] rounded-md bg-gray-150 animate-pulse") />
              <div
                className=%twc("mt-14 w-[1240px] h-[176px] rounded-lg bg-gray-150 animate-pulse")
              />
              <div className=%twc("mt-14 flex flex-col items-center justify-center")>
                <div className=%twc("w-[640px] h-[44px] rounded-md bg-gray-150 animate-pulse") />
                <div
                  className=%twc(
                    "mt-[10px] w-[440px] h-[24px] rounded-md bg-gray-150 animate-pulse"
                  )
                />
              </div>
              <div
                className=%twc("mt-14 w-[1240px] h-[640px] rounded-lg bg-gray-150 animate-pulse")
              />
            </section>
          </div>
        </div>
        <Footer_Buyer.PC />
      </div>

    | DeviceDetect.Mobile =>
      <div className=%twc("w-full min-h-screen")>
        <div className=%twc("w-full bg-white")>
          <div className=%twc("w-full max-w-3xl mx-auto bg-white min-h-screen")>
            <Header_Buyer.Mobile key=router.asPath />
            <div className=%twc("w-full")>
              <div className=%twc("w-full aspect-square bg-gray-150 animate-pulse") />
              <section className=%twc("px-5 flex flex-col gap-2")>
                <div className=%twc("w-full mt-5 bg-gray-150 rounded-lg animate-pulse") />
                <div className=%twc("w-20 h-6 bg-gray-150 rounded-lg animate-pulse") />
                <div className=%twc("w-full bg-gray-150 rounded-lg animate-pulse") />
                <div className=%twc("w-full bg-gray-150 rounded-lg animate-pulse") />
                <div className=%twc("w-full h-[100px] bg-gray-150 rounded-lg animate-pulse") />
              </section>
            </div>
            <Footer_Buyer.MO />
          </div>
        </div>
      </div>
    }
  }
}

module NotFound = {
  @react.component
  let make = (~deviceType) => {
    let router = Next.Router.useRouter()

    switch deviceType {
    | DeviceDetect.Unknown => React.null

    | DeviceDetect.PC =>
      <div className=%twc("w-full min-w-[1280px] min-h-screen")>
        <Header_Buyer.PC key=router.asPath />
        <div className=%twc("w-[1280px] px-5 py-16 mx-auto")>
          <div className=%twc("mt-14")>
            <div className=%twc("w-full flex items-center justify-center")>
              <span className=%twc("text-3xl text-gray-800")>
                {`상품이 존재하지 않습니다`->React.string}
              </span>
            </div>
            <div className=%twc("mt-7 w-full flex flex-col items-center justify-center")>
              <span className=%twc("text-gray-800")>
                {`상품 URL이 정확한지 확인해주세요.`->React.string}
              </span>
              <span className=%twc("text-gray-800")>
                {`상품이 없을 경우 다른 카테고리의 상품을 선택해주세요.`->React.string}
              </span>
            </div>
          </div>
        </div>
        <Footer_Buyer.PC />
      </div>

    | DeviceDetect.Mobile =>
      <div className=%twc("w-full min-h-screen")>
        <div className=%twc("w-full bg-white")>
          <div className=%twc("w-full max-w-3xl mx-auto bg-white min-h-screen")>
            <Header_Buyer.Mobile key=router.asPath />
            <div className=%twc("w-full px-5 pt-[126px]")>
              <div className=%twc("flex flex-col items-center text-base text-text-L2")>
                <span className=%twc("mb-2 text-xl text-text-L1")>
                  {`상품이 존재하지 않습니다`->React.string}
                </span>
                <span> {`상품 URL이 정확한지 확인해주세요.`->React.string} </span>
                <span>
                  {`상품이 없을 경우 다른 카테고리의 상품을 선택해주세요.`->React.string}
                </span>
              </div>
            </div>
            <Footer_Buyer.MO />
          </div>
        </div>
      </div>
    }
  }
}

module Error = {
  @react.component
  let make = (~deviceType) => {
    let router = Next.Router.useRouter()

    switch deviceType {
    | DeviceDetect.Unknown => React.null

    | DeviceDetect.PC =>
      <div className=%twc("w-full min-w-[1280px] min-h-screen")>
        <Header_Buyer.PC key=router.asPath />
        <div className=%twc("w-[1280px] px-5 py-16 mx-auto")>
          <div className=%twc("mt-14")>
            <div className=%twc("w-full flex items-center justify-center")>
              <span className=%twc("text-3xl text-gray-800")>
                {`상품을 가져오는데 실패하였습니다`->React.string}
              </span>
            </div>
            <div className=%twc("mt-7 w-full flex flex-col items-center justify-center")>
              <span className=%twc("text-gray-800")>
                {`상품 URL이 정확한지 확인해주세요.`->React.string}
              </span>
              <span className=%twc("text-gray-800")>
                {`상품이 없을 경우 다른 카테고리의 상품을 선택해주세요.`->React.string}
              </span>
            </div>
          </div>
        </div>
        <Footer_Buyer.PC />
      </div>

    | DeviceDetect.Mobile =>
      <div className=%twc("w-full min-h-screen")>
        <div className=%twc("w-full bg-white")>
          <div className=%twc("w-full max-w-3xl mx-auto bg-white min-h-screen")>
            <Header_Buyer.Mobile key=router.asPath />
            <div className=%twc("w-full px-5 pt-[126px]")>
              <div className=%twc("flex flex-col items-center text-base text-text-L2")>
                <span className=%twc("mb-2 text-xl text-text-L1")>
                  {`상품을 가져오는데 실패하였습니다`->React.string}
                </span>
                <span> {`상품 URL이 정확한지 확인해주세요.`->React.string} </span>
                <span>
                  {`상품이 없을 경우 다른 카테고리의 상품을 선택해주세요.`->React.string}
                </span>
              </div>
            </div>
            <Footer_Buyer.MO />
          </div>
        </div>
      </div>
    }
  }
}

module Presenter = {
  @react.component
  let make = (~deviceType, ~query) => {
    let {id, name, __typename, fragmentRefs} = query->Fragment.use
    let pushGtmPageView = PDP_Gtm_Buyer.PageView.use(~query)

    ChannelTalkHelper.Hook.use(
      ~viewMode=ChannelTalkHelper.Hook.PcOnly,
      ~trackData={
        eventName: `최근 본 상품`,
        eventProperty: {"productId": id, "productName": name},
      },
      (),
    )

    React.useEffect0(() => {
      pushGtmPageView()
      None
    })

    switch __typename->Product_Parser.Type.decode {
    // 일반 / 일반 + 견적 상품
    | Some(Normal) | Some(Quotable) => <PDP_Normal_Buyer deviceType query=fragmentRefs />
    // 견적 상품
    | Some(Quoted) => <PDP_Quoted_Buyer deviceType query=fragmentRefs />
    // 매칭 상품
    | Some(Matching) => <PDP_Matching_Buyer deviceType query=fragmentRefs /> // 초기 버전에선 모바일 뷰만 제공
    // Unknown
    | None => React.null
    }
  }
}

module Container = {
  @react.component
  let make = (~deviceType, ~nodeId) => {
    let {node} = Query.use(~variables={id: nodeId}, ~fetchPolicy=RescriptRelay.StoreAndNetwork, ())

    switch node {
    | None => <NotFound deviceType />
    | Some({fragmentRefs}) => <Presenter deviceType query=fragmentRefs />
    }
  }
}

@react.component
let make = (~deviceType) => {
  let router = Next.Router.useRouter()
  let pid = router.query->Js.Dict.get("pid")

  let (isCsr, setIsCsr) = React.Uncurried.useState(_ => false)

  React.useEffect0(() => {
    setIsCsr(._ => true)
    None
  })

  <>
    <Next.Head>
      <title> {`신선하이`->React.string} </title>
    </Next.Head>
    <RescriptReactErrorBoundary fallback={_ => <Error deviceType />}>
      <React.Suspense fallback={React.null}>
        {switch (isCsr, pid) {
        | (true, Some(nodeId)) => <Container deviceType nodeId />
        | _ => React.null
        }}
      </React.Suspense>
    </RescriptReactErrorBoundary>
  </>
}
