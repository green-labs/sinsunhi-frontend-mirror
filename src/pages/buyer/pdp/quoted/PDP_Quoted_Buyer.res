/*
  1. 컴포넌트 위치
  PDP > 견적 상품
  
  2. 역할
  견적 상품의 상품 정보를 표현합니다.
*/

module Fragment = %relay(`
  fragment PDPQuotedBuyerFragment on QuotedProduct {
    # Commons
    image {
      thumb1920x1920
      thumb1000x1000
    }
    salesDocument
    displayName
    description
    notice
    noticeStartAt
    noticeEndAt
  
    # gtm attrs
    ...PDPQuotedGtmBuyer_fragment
  
    # Fragments
    ...PDPQuotedDetailsBuyerFragment
  }
`)

module PC = {
  @react.component
  let make = (~query) => {
    let router = Next.Router.useRouter()
    let {
      image,
      salesDocument,
      displayName,
      notice,
      noticeStartAt,
      noticeEndAt,
      description,
      fragmentRefs,
    } =
      query->Fragment.use

    let (showModal, setShowModal) = React.Uncurried.useState(_ => PDP_Quoted_Modals_Buyer.Hide)

    <>
      <div className=%twc("w-full min-w-[1280px] min-h-screen")>
        <Header_Buyer.PC key=router.asPath />
        <div className=%twc("w-[1280px] mx-auto min-h-full")>
          <div className=%twc("w-full pt-16 px-5 divide-y")>
            <section className=%twc("w-full flex pb-12 gap-20")>
              <div>
                <PDP_Image_Buyer.PC src=image.thumb1920x1920 />
                {salesDocument->Option.mapWithDefault(React.null, salesDocument' =>
                  <PDP_SalesDocument_Buyer.PC salesDocument=salesDocument' />
                )}
              </div>
              <div className=%twc("w-full")>
                <PDP_Quoted_Title_Buyer.PC displayName />
                <section className=%twc("mt-4 border border-gray-200 rounded-xl divide-y")>
                  <div className=%twc("px-6 py-8 divide-y")>
                    <PDP_Quoted_Details_Buyer.PC query=fragmentRefs />
                    <div className=%twc("flex flex-col gap-6 pt-6")>
                      <PDP_Quoted_RequestGuide_Buyer.PC />
                    </div>
                  </div>
                </section>
                <section className=%twc("w-full mt-4")>
                  <PDP_Quoted_Submit_Buyer.PC setShowModal query=fragmentRefs />
                </section>
              </div>
            </section>
            <section className=%twc("pt-16")>
              <span className=%twc("text-2xl font-bold text-gray-800")>
                {`상세 설명`->React.string}
              </span>
              <PDP_Notice_Buyer.PC notice noticeStartAt noticeEndAt />
              <div className=%twc("py-16")>
                <Editor.Viewer value=description />
              </div>
            </section>
          </div>
        </div>
        <Footer_Buyer.PC />
      </div>
      <PDP_Quoted_Modals_Buyer.PC show=showModal setShow=setShowModal />
    </>
  }
}

module MO = {
  @react.component
  let make = (~query) => {
    let router = Next.Router.useRouter()
    let {
      image,
      salesDocument,
      displayName,
      notice,
      noticeStartAt,
      noticeEndAt,
      description,
      fragmentRefs,
    } =
      query->Fragment.use

    let (showModal, setShowModal) = React.Uncurried.useState(_ => PDP_Quoted_Modals_Buyer.Hide)

    <>
      <div className=%twc("w-full min-h-screen")>
        <div className=%twc("w-full bg-white")>
          <div className=%twc("w-full max-w-3xl mx-auto bg-white min-h-screen")>
            <Header_Buyer.Mobile key=router.asPath />
            <section className=%twc("flex flex-col gap-5")>
              <PDP_Image_Buyer.MO src=image.thumb1000x1000 />
            </section>
            <section className=%twc("px-5 divide-y")>
              <div className=%twc("w-full divide-y")>
                <section className=%twc("pt-5 pb-8")>
                  <PDP_Quoted_Title_Buyer.MO displayName />
                </section>
                <section className=%twc("py-8")>
                  <PDP_Quoted_Details_Buyer.MO query=fragmentRefs />
                </section>
                <section className=%twc("py-8 flex flex-col gap-5")>
                  <PDP_Quoted_RequestGuide_Buyer.MO />
                  <PDP_Quoted_Submit_Buyer.MO setShowModal query=fragmentRefs />
                </section>
              </div>
              {salesDocument->Option.mapWithDefault(React.null, salesDocument' =>
                <PDP_SalesDocument_Buyer.MO salesDocument=salesDocument' />
              )}
              <div className=%twc("flex flex-col gap-5 py-8")>
                <h1 className=%twc("text-text-L1 text-base font-bold")>
                  {`상세설명`->React.string}
                </h1>
                <PDP_Notice_Buyer.MO notice noticeStartAt noticeEndAt />
                <div className=%twc("w-full overflow-x-scroll")>
                  <Editor.Viewer value=description />
                </div>
              </div>
            </section>
            <Footer_Buyer.MO />
          </div>
        </div>
      </div>
      <PDP_Quoted_Modals_Buyer.MO show=showModal setShow=setShowModal />
    </>
  }
}

@react.component
let make = (~deviceType, ~query) => {
  switch deviceType {
  | DeviceDetect.Unknown => React.null
  | DeviceDetect.PC => <PC query />
  | DeviceDetect.Mobile => <MO query />
  }
}
