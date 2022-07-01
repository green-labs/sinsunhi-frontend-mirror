module Item = {
  @react.component
  let make = () => {
    let status = CustomHooks.OrdersSummaryAdminDashboard.use()
    switch status {
    | Error(error) => <ErrorPanel error />
    | Loading => <div> {j`로딩 중..`->React.string} </div>
    | Loaded(summary) =>
      <div className=%twc("py-8 px-4 bg-div-shape-L1 min-h-screen")>
        <header className=%twc("flex items-baseline")>
          <h1 className=%twc("font-bold text-xl")> {j`대시보드`->React.string} </h1>
          <span className=%twc("ml-2 text-green-gl text-sm")>
            {j`먼저 확인해 주세요!`->React.string}
          </span>
        </header>
        <div className=%twc("flex mt-4 bg-white rounded")>
          <div className=%twc("flex-1 p-7 shadow-gl mr-4")>
            <h3 className=%twc("font-bold text-xl")> {j`주문서`->React.string} </h3>
            <ol className=%twc("flex justify-between mt-4 divide-x")>
              {switch summary->CustomHooks.OrdersSummaryAdminDashboard.orders_decode {
              | Ok(summary') => <>
                  <li className=%twc("flex-1 text-center")>
                    <span className=%twc("block")> {j`최근신규발주`->React.string} </span>
                    <span className=%twc("block mt-2 font-bold")>
                      {j`${summary'.data.newOrders->Int.toString}건`->React.string}
                    </span>
                  </li>
                  <li className=%twc("flex-1 text-center")>
                    <span className=%twc("block")> {j`자동처리완료`->React.string} </span>
                    <span className=%twc("block mt-2 font-bold")>
                      {j`${summary'.data.ordersSuccess->Int.toString}건`->React.string}
                    </span>
                  </li>
                  <li className=%twc("flex-1 text-center")>
                    <span className=%twc("block")> {j`처리실패`->React.string} </span>
                    <span className=%twc("block mt-2 font-bold")>
                      {j`${summary'.data.ordersFail->Int.toString}건`->React.string}
                    </span>
                  </li>
                </>
              | Error(_) => <div> {j`오류가 발생하였습니다.`->React.string} </div>
              }}
            </ol>
          </div>
          <div className=%twc("flex-1 p-7 shadow-gl")>
            <h3 className=%twc("font-bold text-xl")> {j`송장번호`->React.string} </h3>
            <ol className=%twc("flex justify-between mt-4 divide-x")>
              {switch summary->CustomHooks.OrdersSummaryAdminDashboard.orders_decode {
              | Ok(summary') => <>
                  <li className=%twc("flex-1 text-center")>
                    <span className=%twc("block")> {j`최근입력요청`->React.string} </span>
                    <span className=%twc("block mt-2 font-bold")>
                      {summary'.data.invoiceRequested->Int.toString->React.string}
                    </span>
                  </li>
                  <li className=%twc("flex-1 text-center")>
                    <span className=%twc("block")> {j`입력완료`->React.string} </span>
                    <span className=%twc("block mt-2 font-bold")>
                      {j`${summary'.data.invoiceUpdated->Int.toString}건`->React.string}
                    </span>
                  </li>
                  <li className=%twc("flex-1 text-center")>
                    <span className=%twc("block")> {j`입력미완료`->React.string} </span>
                    <span className=%twc("block mt-2 font-bold")>
                      {j`${summary'.data.invoiceNotUpdated->Int.toString}건`->React.string}
                    </span>
                  </li>
                </>
              | Error(_) => <div> {j`오류가 발생하였습니다.`->React.string} </div>
              }}
            </ol>
          </div>
        </div>
      </div>
    }
  }
}

@react.component
let make = () =>
  <Authorization.Admin title=j`관리자 대시보드`> <Item /> </Authorization.Admin>
