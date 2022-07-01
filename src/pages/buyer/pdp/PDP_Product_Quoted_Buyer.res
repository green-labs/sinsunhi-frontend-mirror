/*
  1. 컴포넌트 위치
  바이어 센터 전시 매장 > PDP Page > 상품 정보 (견적 상품)
  
  2. 역할
  견적 상품의 상품 정보를 보여줍니다.
*/

module Fragment = %relay(`
  fragment PDPProductQuotedBuyerFragment on Product {
    ...PDPTitleBuyerFragment
    ...PDPProductQuotedInfoBuyerFragment
  }
`)

module PC = {
  @react.component
  let make = (~query) => {
    let {fragmentRefs} = query->Fragment.use

    <div className=%twc("w-full")>
      <PDP_Title_Buyer.PC query=fragmentRefs />
      <h1 className=%twc("mt-4 font-bold text-blue-500 text-[28px]")>
        {`최저가 견적받기`->React.string}
      </h1>
      <section className=%twc("mt-4 border border-gray-200 rounded-xl divide-y")>
        <div className=%twc("px-6 py-8 divide-y")>
          <PDP_Product_Quoted_Info_Buyer.PC query=fragmentRefs />
          <div className=%twc("flex flex-col gap-6 pt-6")> <PDP_QuoteInfo_Buyer.PC /> </div>
        </div>
      </section>
      <section className=%twc("w-full mt-4")> <PDP_Rfq_Button.Quoted.PC /> </section>
    </div>
  }
}

module MO = {
  @react.component
  let make = (~query) => {
    let {fragmentRefs} = query->Fragment.use

    <>
      <div className=%twc("w-full divide-y")>
        <section className=%twc("pt-5 pb-8")>
          <PDP_Title_Buyer.MO query=fragmentRefs />
          <h1 className=%twc("mt-2 font-bold text-blue-500 text-lg")>
            {`최저가 견적받기`->React.string}
          </h1>
        </section>
        <section className=%twc("py-8")>
          <PDP_Product_Quoted_Info_Buyer.MO query=fragmentRefs />
        </section>
        <section className=%twc("py-8 flex flex-col gap-5")>
          <PDP_QuoteInfo_Buyer.MO /> <PDP_Rfq_Button.Quoted.MO />
        </section>
      </div>
    </>
  }
}
