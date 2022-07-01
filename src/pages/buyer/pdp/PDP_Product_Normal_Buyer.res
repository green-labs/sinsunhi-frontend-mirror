/*
  1. 컴포넌트 위치
  바이어 센터 전시 매장 > PDP Page > 상품 정보 (일반 상품)
  
  2. 역할
  일반 상품의 상품 정보를 보여줍니다.
*/

module Fragment = %relay(`
  fragment PDPProductNormalBuyerFragment on Product {
    _type: type
    ...PDPTitleBuyerFragment
    ...PDPPriceBuyerFragment
    ...PDPProductNormalInfoBuyerFragment
    ...PDPSelectOptionBuyerFragment
    ...PDPProductNormalQuantityInputBuyer
    ...PDPProductNormalTotalPriceBuyerFragment
    ...PDPProductNormalSubmitBuyerFragment
  }
`)

module PC = {
  @react.component
  let make = (~query) => {
    let {_type, fragmentRefs} = query->Fragment.use

    let (quantity, setQuantity) = React.Uncurried.useState(_ => 1)
    let (selected, setSelected) = React.Uncurried.useState((_): option<
      PDP_SelectOption_Buyer.selectedSku,
    > => None)

    <div className=%twc("w-full")>
      <PDP_Title_Buyer.PC query=fragmentRefs />
      <PDP_Price_Buyer.PC query=fragmentRefs />
      <div className=%twc("w-full h-16 my-4 px-6 flex items-center rounded-xl bg-[#FFF1EE]")>
        <span className=%twc("text-orange-500")>
          {`시세에 따라 가격이 변동될 수 있습니다`->React.string}
        </span>
      </div>
      <section className=%twc("border border-gray-200 rounded-xl divide-y")>
        <div className=%twc("px-6 py-8 divide-y")>
          <PDP_Product_Normal_Info_Buyer.PC query=fragmentRefs />
          <div className=%twc("flex flex-col gap-6 py-6")>
            <PDP_DeliveryInfo_Buyer.PC />
            <PDP_SelectOption_Buyer.PC
              query=fragmentRefs onSelect={sku => setSelected(._ => sku)}
            />
          </div>
          <PDP_Product_Normal_QuantityInput_Buyer.PC
            query=fragmentRefs selectedItem=selected quantity setQuantity
          />
        </div>
        <PDP_Product_Normal_TotalPrice_Buyer.PC query=fragmentRefs selectedItem=selected quantity />
      </section>
      <section className=%twc("w-full mt-4")>
        <PDP_Product_Normal_Submit_Buyer.PC query=fragmentRefs selected quantity setQuantity />
      </section>
      {switch _type {
      | #QUOTABLE =>
        <section className=%twc("w-full mt-4")> <PDP_Rfq_Button.Quotable.PC /> </section>
      | _ => React.null
      }}
    </div>
  }
}

module MO = {
  @react.component
  let make = (~query) => {
    let {_type, fragmentRefs} = query->Fragment.use

    let (quantity, setQuantity) = React.Uncurried.useState(_ => 1)
    let (selected, setSelected) = React.Uncurried.useState((_): option<
      PDP_SelectOption_Buyer.selectedSku,
    > => None)

    <div className=%twc("w-full divide-y")>
      <section className=%twc("pt-5 pb-8")>
        <PDP_Title_Buyer.MO query=fragmentRefs />
        <div className=%twc("w-full mt-2")> <PDP_Price_Buyer.MO query=fragmentRefs /> </div>
        <div className=%twc("my-4 w-full rounded-[10px] bg-[#FFF1EE] py-[10px] text-center")>
          <span className=%twc("text-orange-500")>
            {`시세에 따라 변동 될 수 있습니다.`->React.string}
          </span>
        </div>
        <div className=%twc("pt-4")>
          <PDP_SelectOption_Buyer.MO query=fragmentRefs onSelect={sku => setSelected(._ => sku)} />
        </div>
      </section>
      <PDP_Product_Normal_QuantityInput_Buyer.MO
        query=fragmentRefs selectedItem=selected quantity setQuantity
      />
      <section className=%twc("py-8 flex flex-col gap-6")>
        <PDP_Product_Normal_TotalPrice_Buyer.MO query=fragmentRefs selectedItem=selected quantity />
        <PDP_Product_Normal_Submit_Buyer.MO query=fragmentRefs selected quantity setQuantity />
      </section>
      <section className=%twc("py-8")>
        <PDP_Product_Normal_Info_Buyer.MO query=fragmentRefs />
      </section>
      <section className=%twc("py-8")> <PDP_DeliveryInfo_Buyer.MO /> </section>
    </div>
  }
}
