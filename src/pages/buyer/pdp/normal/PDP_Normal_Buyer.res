/*
  1. 컴포넌트 위치
  PDP > 일반 상품
  
  2. 역할
  일반 상품의 상품 정보를 표현합니다.
*/

module Fragment = %relay(`
  fragment PDPNormalBuyerFragment on Product {
    # Commons
    image {
      thumb1920x1920
      thumb1000x1000
    }
    salesDocument
    description
    displayName
    status
    notice
    noticeStartAt
    noticeEndAt
  
    # Origin
    ... on NormalProduct {
      price
    }
  
    ... on QuotableProduct {
      price
    }
  
    # Fragments
    ...PDPNormalDetailsBuyerFragment
    ...PDPNormalSelectOptionBuyerFragment
    ...PDPNormalQuantityInputBuyerFragment
    ...PDPNormalTotalPriceBuyerFragment
    ...PDPNormalSubmitBuyerFragment
  }
`)

module PC = {
  @react.component
  let make = (~query) => {
    let router = Next.Router.useRouter()
    let {
      image,
      salesDocument,
      description,
      displayName,
      price,
      status,
      notice,
      noticeStartAt,
      noticeEndAt,
      fragmentRefs,
    } =
      query->Fragment.use

    let (quantity, setQuantity) = React.Uncurried.useState(_ => 1)
    let (selectedOptionId, setSelectedOptionId) = React.Uncurried.useState(_ => None)

    let (showModal, setShowModal) = React.Uncurried.useState(_ => PDP_Normal_Modals_Buyer.Hide)

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
                <PDP_Normal_Title_Buyer.PC displayName price isSoldout={status == #SOLDOUT} />
                <section className=%twc("border border-gray-200 rounded-xl divide-y")>
                  <div className=%twc("px-6 py-8 divide-y")>
                    <PDP_Normal_Details_Buyer.PC query=fragmentRefs />
                    <div className=%twc("flex flex-col gap-6 py-6")>
                      <PDP_Normal_DeliveryGuide_Buyer.PC />
                      <PDP_Normal_SelectOption_Buyer.PC
                        query=fragmentRefs onSelect=setSelectedOptionId setShowModal
                      />
                    </div>
                    <PDP_Normal_QuantityInput_Buyer.PC
                      query=fragmentRefs selectedOptionId quantity setQuantity
                    />
                  </div>
                  <PDP_Normal_TotalPrice_Buyer.PC query=fragmentRefs selectedOptionId quantity />
                </section>
                <section className=%twc("w-full mt-4")>
                  <PDP_Normal_Submit_Buyer.PC
                    query=fragmentRefs selectedOptionId setShowModal quantity
                  />
                </section>
              </div>
            </section>
            <section className=%twc("pt-16")>
              <span className=%twc("text-2xl font-bold text-gray-800")>
                {`상세 설명`->React.string}
              </span>
              <PDP_Notice_Buyer.PC notice noticeStartAt noticeEndAt />
              <div className=%twc("py-16")>
                <Editor.Viewer value={description} />
              </div>
            </section>
            <section className=%twc("w-full py-16 flex justify-center")>
              <div className=%twc("w-full max-w-[600px] aspect-[209/1361]")>
                <img
                  src="https://public.sinsunhi.com/images/20220616/f15dcb82-7b3e-482d-a32a-ab56791617da/%E1%84%89%E1%85%A1%E1%86%BC%E1%84%89%E1%85%A6%20CS%E1%84%80%E1%85%A9%E1%86%BC%E1%84%90%E1%85%A9%E1%86%BC%E1%84%8B%E1%85%A7%E1%86%BC%E1%84%8B%E1%85%A7%E1%86%A8%20%E1%84%8E%E1%85%AC%E1%84%8E%E1%85%AC%E1%84%8C%E1%85%A9%E1%86%BC.jpg"
                  className=%twc("w-full h-full object-cover")
                  alt="pdp-delivery-guide-mo"
                />
              </div>
            </section>
          </div>
        </div>
        <Footer_Buyer.PC />
      </div>
      <PDP_Normal_Modals_Buyer.PC
        show=showModal setShow=setShowModal selectedOptionId quantity setQuantity
      />
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
      description,
      displayName,
      price,
      status,
      notice,
      noticeStartAt,
      noticeEndAt,
      fragmentRefs,
    } =
      query->Fragment.use

    let (quantity, setQuantity) = React.Uncurried.useState(_ => 1)
    let (selectedOptionId, setSelectedOptionId) = React.Uncurried.useState(_ => None)

    let (showModal, setShowModal) = React.Uncurried.useState(_ => PDP_Normal_Modals_Buyer.Hide)

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
                  <PDP_Normal_Title_Buyer.MO displayName price isSoldout={status == #SOLDOUT} />
                  <div className=%twc("pt-4")>
                    <PDP_Normal_SelectOption_Buyer.MO
                      query=fragmentRefs onSelect=setSelectedOptionId setShowModal
                    />
                  </div>
                </section>
                <PDP_Normal_QuantityInput_Buyer.MO
                  query=fragmentRefs selectedOptionId quantity setQuantity
                />
                <section className=%twc("py-8 flex flex-col gap-6")>
                  <PDP_Normal_TotalPrice_Buyer.MO query=fragmentRefs selectedOptionId quantity />
                  <PDP_Normal_Submit_Buyer.MO
                    query=fragmentRefs selectedOptionId setShowModal quantity
                  />
                </section>
                <section className=%twc("py-8")>
                  <PDP_Normal_Details_Buyer.MO query=fragmentRefs />
                </section>
                <section className=%twc("py-8")>
                  <PDP_Normal_DeliveryGuide_Buyer.MO />
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
            <section className=%twc("px-5 py-8")>
              <div className=%twc("w-full aspect-[209/1361]")>
                <img
                  src="https://public.sinsunhi.com/images/20220616/f15dcb82-7b3e-482d-a32a-ab56791617da/%E1%84%89%E1%85%A1%E1%86%BC%E1%84%89%E1%85%A6%20CS%E1%84%80%E1%85%A9%E1%86%BC%E1%84%90%E1%85%A9%E1%86%BC%E1%84%8B%E1%85%A7%E1%86%BC%E1%84%8B%E1%85%A7%E1%86%A8%20%E1%84%8E%E1%85%AC%E1%84%8E%E1%85%AC%E1%84%8C%E1%85%A9%E1%86%BC.jpg"
                  className=%twc("w-full h-full object-cover")
                  alt="pdp-delivery-guide-mo"
                />
              </div>
            </section>
            <Footer_Buyer.MO />
          </div>
        </div>
      </div>
      <PDP_Normal_Modals_Buyer.MO
        show=showModal setShow=setShowModal selectedOptionId quantity setQuantity
      />
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
