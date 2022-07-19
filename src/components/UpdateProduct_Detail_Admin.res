module Fragment = %relay(`
fragment UpdateProductDetailAdminFragment on Product {
  name
  ...UpdateNormalProductFormAdminFragment
  ...UpdateQuotedProductFormAdminFragment
  ...UpdateMatchingProductFormAdminFragment
}
`)

@react.component
let make = (~query, ~productType: Product_Parser.Type.t) => {
  let product = Fragment.use(query)

  let productSelectType = {
    switch productType {
    | Normal => Select_Product_Type.NORMAL
    | Quotable => Select_Product_Type.NORMAL
    | Quoted => Select_Product_Type.QUOTED
    | Matching => Select_Product_Type.MATCHING
    }
  }

  {
    <div className=%twc("max-w-gnb-panel overflow-auto bg-div-shape-L1 min-h-screen mb-16")>
      <header className=%twc("flex flex-col items-baseline p-7 pb-0 gap-1")>
        <div className=%twc("flex justify-center items-center gap-2 text-sm")>
          <span className=%twc("font-bold")> {`상품 조회·수정`->React.string} </span>
          <IconArrow height="16" width="16" stroke="#262626" />
          <span> {`상품 수정`->React.string} </span>
        </div>
        <h1 className=%twc("text-text-L1 text-xl font-bold")>
          {j`${product.name} 수정`->React.string}
        </h1>
      </header>
      <div>
        //상품 기본정보
        <div className=%twc("px-7 pt-7 mt-4 mx-4 bg-white rounded-t-md shadow-gl")>
          <h2 className=%twc("text-text-L1 text-lg font-bold")>
            {j`상품유형`->React.string}
          </h2>
          <div className=%twc("py-6 w-96")>
            <Select_Product_Type status={productSelectType} onChange={_ => ()} />
          </div>
        </div>
      </div>
      {switch productSelectType {
      | NORMAL =>
        <Update_Normal_Product_Form_Admin
          query={product.fragmentRefs} isQuotable={productType == Quotable}
        />
      | QUOTED => <Update_Quoted_Product_Form_Admin query={product.fragmentRefs} />
      | MATCHING => <Update_Matching_Product_Form_Admin query={product.fragmentRefs} />
      }}
    </div>
  }
}
