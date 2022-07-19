module Fragment = %relay(`
  fragment PDPMatchingBuyer_fragment on MatchingProduct {
    image {
      thumb1920x1920
      thumb1000x1000
    }
    category {
      item
      kind
    }
    representativeWeight
  
    ...PDPMatchingTitle_fragment
    ...PDPMatchingSelectGradeBuyer_fragment
    weeklyMarketPrices {
      ...PDPMatchingDemeterChartBuyer_fragment
      ...PDPMatchingDemeterTableBuyer_fragment
    }
    ...PDPMatchingDetailsBuyer_fragment
    ...PDPMatchingGradeGuideBuyer_fragment
  }
`)

module MO = {
  module Divider = {
    @react.component
    let make = () => {
      <div className=%twc("w-full h-3 bg-gray-100") />
    }
  }

  module GradeCard = {
    @react.component
    let make = (~onClick) => {
      <div className=%twc("w-full bg-green-50 rounded-xl p-6")>
        <div className=%twc("flex items-center")>
          <img
            src="/icons/grade-green-circle@3x.png" className=%twc("w-6 h-6 object-contain mr-2")
          />
          <h1 className=%twc("text-black font-bold text-base")>
            {`신선하이 등급으로 필요한 시세를 한눈에`->React.string}
          </h1>
        </div>
        <div className=%twc("mt-2")>
          <p className=%twc("text-sm text-gray-600")>
            {`고객의 구매 목적을 고려한 신선하이 등급을 통해\n상품의 품질별 시세의 흐름을 한눈에 파악할 수 있습니다.`->ReactNl2br.nl2br}
          </p>
        </div>
        <button onClick className=%twc("mt-4 flex items-center")>
          <span className=%twc("text-sm text-primary font-bold")>
            {`신선하이 등급보러가기`->React.string}
          </span>
          <IconArrow width="14" height="14" stroke="#12b564" />
        </button>
      </div>
    }
  }

  @react.component
  let make = (~query) => {
    let user = CustomHooks.User.Buyer.use2()
    let router = Next.Router.useRouter()

    let {image, weeklyMarketPrices, fragmentRefs, representativeWeight} = query->Fragment.use

    let (showModal, setShowModal) = React.Uncurried.useState(_ => PDP_Matching_Modals_Buyer.Hide)
    let (selectedGroup, setSelectedGroup) = React.Uncurried.useState(_ => "high")

    <div className=%twc("w-full min-h-screen")>
      <Header_Buyer.Mobile key=router.asPath />
      <div className=%twc("w-full bg-white")>
        <div className=%twc("w-full max-w-3xl mx-auto relative bg-white min-h-screen")>
          <PDP_Matching_Image_Buyer src=image.thumb1000x1000 />
          <section className=%twc("px-4")>
            <PDP_Matching_Title.MO query=fragmentRefs selectedGroup />
          </section>
          <section className=%twc("px-4")>
            <PDP_Matching_SelectGrade_Buyer
              selectedGroup setSelectedGroup setShowModal query=fragmentRefs
            />
          </section>
          <section className=%twc("py-6")>
            {switch user {
            | Unknown =>
              <div className=%twc("w-full pt-[113%] relative")>
                <img
                  className=%twc("w-full h-full object-contain absolute top-0 left-0")
                  src="/images/chart_placeholder.png"
                />
              </div>
            | NotLoggedIn =>
              <div className=%twc("w-full pt-[113%] relative")>
                <img
                  className=%twc("w-full h-full object-contain absolute top-0 left-0")
                  src="/images/chart_placeholder.png"
                />
                <div
                  className=%twc(
                    "absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 text-center"
                  )>
                  <div className=%twc("text-center mb-4")>
                    {`회원 로그인 후\n전국 도매시장 주간 시세를 확인해보세요`->ReactNl2br.nl2br}
                  </div>
                  <Next.Link href={`/buyer/signin?redirect=${router.asPath}`}>
                    <a>
                      <span
                        className=%twc(
                          "mt-2 px-3 py-2 rounded-xl border border-primary text-primary"
                        )>
                        {`로그인하고 시세 확인하기`->React.string}
                      </span>
                    </a>
                  </Next.Link>
                </div>
              </div>
            | LoggedIn(_) =>
              switch weeklyMarketPrices {
              | None => React.null
              | Some({fragmentRefs}) => <>
                  <PDP_Matching_DemeterChart_Buyer
                    query=fragmentRefs selectedGroup representativeWeight
                  />
                  <PDP_Matching_DemeterTable_Buyer
                    query=fragmentRefs selectedGroup representativeWeight
                  />
                </>
              }
            }}
          </section>
          <Divider />
          <section className=%twc("px-4")>
            <PDP_Matching_Details_Buyer query=fragmentRefs />
          </section>
          <Divider />
          <section className=%twc("px-4 pt-4 pb-16")>
            <GradeCard
              onClick={_ => setShowModal(._ => PDP_Matching_Modals_Buyer.Show(GradeGuide))}
            />
          </section>
        </div>
        <PDP_Matching_Submit_Buyer.MO setShowModal selectedGroup />
        <PDP_Matching_Modals_Buyer.MO show=showModal setShow=setShowModal query=fragmentRefs />
      </div>
      <Footer_Buyer.MO />
    </div>
  }
}

@react.component
let make = (~deviceType, ~query) => {
  switch deviceType {
  | DeviceDetect.Unknown => React.null
  | DeviceDetect.PC | DeviceDetect.Mobile => <MO query /> // 초기 버전에선 모바일 뷰만 제공
  }
}
