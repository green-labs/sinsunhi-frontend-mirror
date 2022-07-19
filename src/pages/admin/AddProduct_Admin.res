module Product = {
  @react.component
  let make = () => {
    let (productType, setProductType) = React.Uncurried.useState(_ => Select_Product_Type.NORMAL)

    <div className=%twc("max-w-gnb-panel overflow-auto bg-div-shape-L1 min-h-screen")>
      <header className=%twc("flex items-baseline p-7 pb-0")>
        <h1 className=%twc("text-text-L1 text-xl font-bold")> {j`상품 등록`->React.string} </h1>
      </header>
      <div>
        <div className=%twc("px-7 pt-7 mt-4 mx-4 bg-white rounded-t-md shadow-gl")>
          <h2 className=%twc("text-text-L1 text-lg font-bold")>
            {j`상품유형`->React.string}
          </h2>
          <div className=%twc("py-6 w-96")>
            <Select_Product_Type
              status={productType} onChange={status => setProductType(._ => status)}
            />
          </div>
        </div>
      </div>
      {switch productType {
      | NORMAL => <Add_Normal_Product_Form_Admin />
      | QUOTED => <Add_Quoted_Product_Form_Admin />
      | MATCHING => <Add_Matching_Product_Form_Admin />
      }}
    </div>
  }
}

@react.component
let make = () => {
  <Authorization.Admin title=j`관리자 상품 조회`> <Product /> </Authorization.Admin>
}
