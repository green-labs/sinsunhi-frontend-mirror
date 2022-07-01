let formatDate = d => d->Js.Date.fromString->Locale.DateTime.formatFromUTC("yyyy/MM/dd HH:mm")

module Item = {
  module Table = {
    @react.component
    let make = (~product: CustomHooks.Products.product) => {
      <>
        <li className=%twc("hidden lg:grid lg:grid-cols-7-buyer-product text-gray-700")>
          <div className=%twc("h-full flex flex-col px-4 py-2")>
            <Product_Badge status=product.salesStatus />
          </div>
          <div className=%twc("h-full flex flex-col px-4 py-2")>
            <span className=%twc("block")> {product.productId->Int.toString->React.string} </span>
            <span className=%twc("block text-gray-500")> {product.productSku->React.string} </span>
          </div>
          <div className=%twc("h-full flex flex-col px-4 py-2")>
            <span className=%twc("block")> {product.productName->React.string} </span>
            <span className=%twc("block text-gray-500")>
              {product.productOptionName->Option.getWithDefault("")->React.string}
            </span>
          </div>
          <div className=%twc("h-full flex flex-col px-4 py-2")>
            <span className=%twc("whitespace-nowrap")>
              {`${product.price->Locale.Float.show(~digits=0)}원`->React.string}
            </span>
          </div>
          <div className=%twc("h-full flex flex-col px-4 py-2")>
            <span className=%twc("block")>
              {product.cutOffTime->Option.getWithDefault("")->React.string}
            </span>
          </div>
          <div className=%twc("h-full flex flex-col px-4 py-2")>
            <span className=%twc("block")>
              {product.memo->Option.getWithDefault("")->React.string}
            </span>
          </div>
        </li>
      </>
    }
  }

  module Card = {
    @react.component
    let make = (~product: CustomHooks.Products.product) => {
      <>
        <li className=%twc("py-7 px-5 lg:mb-4 lg:hidden text-black-gl")>
          <section className=%twc("flex justify-between items-start")>
            <div className=%twc("flex")>
              <span className=%twc("w-20 text-gray-gl")> {j`상품`->React.string} </span>
              <div className=%twc("ml-2")>
                <span className=%twc("block")>
                  {product.productId->Int.toString->React.string}
                </span>
                <span className=%twc("block mt-1")> {product.productName->React.string} </span>
              </div>
            </div>
            <Product_Badge status=product.salesStatus />
          </section>
          <section className=%twc("py-3")>
            <div className=%twc("flex")>
              <span className=%twc("w-20 text-gray-gl")> {j`품목`->React.string} </span>
              <div className=%twc("ml-2")>
                <span className=%twc("block")> {product.productSku->React.string} </span>
                <span className=%twc("block mt-1")>
                  {product.productOptionName
                  ->Option.getWithDefault(j`품목명 없음`)
                  ->React.string}
                </span>
              </div>
            </div>
            <div className=%twc("flex mt-3")>
              <span className=%twc("w-20 text-gray-gl")> {j`현재 판매가`->React.string} </span>
              <span className=%twc("ml-2")>
                {`${product.price->Locale.Float.show(~digits=0)}원`->React.string}
              </span>
            </div>
            <RadixUI.Separator.Root className=%twc("separator my-5") />
            <div className=%twc("flex mt-3")>
              <span className=%twc("w-20 text-gray-gl")>
                {j`출고기준시간`->React.string}
              </span>
              <span className=%twc("ml-2")>
                {product.cutOffTime->Option.getWithDefault("")->React.string}
              </span>
            </div>
            <div className=%twc("flex mt-3")>
              <span className=%twc("w-20 text-gray-gl")> {j`메모`->React.string} </span>
              <span className=%twc("ml-2")>
                {product.memo->Option.getWithDefault("")->React.string}
              </span>
            </div>
          </section>
        </li>
      </>
    }
  }
}

@react.component
let make = (~product: CustomHooks.Products.product) => {
  <>
    // PC 뷰
    <Item.Table product />
    // 모바일뷰
    <Item.Card product />
  </>
}
