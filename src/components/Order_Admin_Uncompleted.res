let formatDate = d => d->Js.Date.fromString->Locale.DateTime.formatFromUTC("yyyy/MM/dd HH:mm")

module Item = {
  module Table = {
    @react.component
    let make = (~order: CustomHooks.OrdersAdminUncompleted.orderUncompleted) => {
      let (isShowDetail, setShowDetail) = React.Uncurried.useState(_ => Dialog.Hide)

      <>
        <div className=%twc("table-cell py-2 align-top")>
          <span className=%twc("block mb-1")> {order.orderNo->React.string} </span>
          <span className=%twc("block text-gray-400 mb-1")>
            {order.orderDate->formatDate->React.string}
          </span>
        </div>
        <div className=%twc("table-cell p-2 align-top")>
          <span className=%twc("block text-gray-400")> {order.name->React.string} </span>
        </div>
        <div className=%twc("table-cell p-2 align-top")>
          <span className=%twc("whitespace-nowrap")> {order.email->React.string} </span>
          <span className=%twc("whitespace-nowrap")> {order.phone->React.string} </span>
        </div>
        <div className=%twc("table-cell p-2 align-top")>
          <span className=%twc("block")> {order.currentDeposit->Float.toString->React.string} </span>
          <button
            type_="button"
            className={switch order.data {
            | Some(_) =>
              %twc("block bg-gray-100 text-gray-500 py-1 px-2 rounded-lg mt-2 whitespace-nowrap")
            | None =>
              %twc("block bg-gray-100 text-gray-500 py-1 px-2 rounded-lg mt-2 whitespace-nowrap")
            }}
            onClick={_ => setShowDetail(._ => Dialog.Show)}
            disabled={switch order.data {
            | Some(_) => false
            | None => true
            }}>
            {j`조회하기`->React.string}
          </button>
        </div>
        <div className=%twc("table-cell p-2 align-top")>
          <span className=%twc("block")>
            {order.userDeposit->Option.mapWithDefault("0", Float.toString)->React.string}
          </span>
          <button
            type_="button"
            className=%twc(
              "block bg-gray-100 text-gray-500 py-1 px-2 rounded-lg mt-2 whitespace-nowrap"
            )>
            {j`다운로드`->React.string}
          </button>
        </div>
        <div className=%twc("table-cell p-2 align-top")>
          <span className=%twc("block w-32 overflow-hidden overflow-ellipsis")>
            {order.errorCode->Option.getWithDefault("")->React.string}
          </span>
        </div>
        // 바이어별 주문 내역
        <Dialog isShow=isShowDetail>
          {<div className=%twc("bg-white transform transition-all rounded-xl py-10 px-7")>
            <h3 className=%twc("text-2xl font-bold text-left")>
              {j`${order.name}님의 주문 내역`->React.string}
            </h3>
            <div className=%twc("flex justify-end text-gray-500 mt-4")>
              {j`총 잔액: ${order.currentDeposit->Float.toString}`->React.string}
            </div>
            <div className=%twc("block overflow-y-auto overscroll-contain max-h-50")>
              <div className=%twc("table mt-4 text-sm")>
                <div className=%twc("table-row bg-gray-100")>
                  <div className=%twc("table-cell p-4 align-middle text-gray-500")>
                    {j`주문번호·일자·바이어명`->React.string}
                  </div>
                  <div className=%twc("table-cell p-4 align-middle text-gray-500")>
                    {j`주문상품`->React.string}
                  </div>
                  <div className=%twc("table-cell p-4 align-middle text-gray-500")>
                    <span className=%twc("block")> {j`상품금액`->React.string} </span>
                    <span className=%twc("block")> {j`잔여수량`->React.string} </span>
                  </div>
                </div>
                {order.data->Option.mapWithDefault(React.null, details => {
                  details
                  ->Garter.Array.map(detail => {
                    <div className=%twc("table-row text-left")>
                      <div className=%twc("table-cell p-3 border-b")>
                        <span className=%twc("block")> {order.orderNo->React.string} </span>
                        <span className=%twc("block mt-1 text-gray-500")>
                          {order.orderDate->formatDate->React.string}
                        </span>
                        <span className=%twc("block mt-1 text-gray-500")>
                          {order.name->React.string}
                        </span>
                      </div>
                      <div className=%twc("table-cell p-3 border-b")>
                        <span className=%twc("block mt-1 text-gray-500")>
                          {detail.productSku->React.string}
                        </span>
                        <span className=%twc("block mt-1")>
                          {detail.productName->React.string}
                        </span>
                        <span className=%twc("block mt-1 text-gray-500")>
                          {detail.productOptionName->Option.getWithDefault("")->React.string}
                        </span>
                      </div>
                      <div className=%twc("table-cell p-3 border-b")>
                        <span className=%twc("block mt-1")>
                          {`${detail.productPrice->Locale.Float.show(~digits=0)}원`->React.string}
                        </span>
                        <span className=%twc("block mt-1")> {detail.quantity->React.string} </span>
                      </div>
                    </div>
                  })
                  ->React.array
                })}
              </div>
            </div>
            <button
              className=%twc(
                "mt-8 p-4 w-full sm:w-2/3 lg:w-1/2 bg-gray-200 rounded-xl hover:bg-green-gl-dark font-bold"
              )
              onClick={_ => setShowDetail(._ => Dialog.Hide)}>
              {j`확인`->React.string}
            </button>
          </div>}
        </Dialog>
      </>
    }
  }
}

@react.component
let make = (~order: CustomHooks.OrdersAdminUncompleted.orderUncompleted) => {
  <li className=%twc("table-row text-gray-700")> <Item.Table order /> </li>
}
