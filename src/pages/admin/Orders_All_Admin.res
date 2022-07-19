// 수기 주문데이터 관리자 업로드 시연용 컴포넌트
// TODO: 시연이 끝나면 지워도 된다.
module List = Order_All_List_Admin_Buyer

external unsafeAsFile: Webapi.Blob.t => Webapi.File.t = "%identity"

@spice
type data = {
  @spice.key("total-count") totalCount: int,
  @spice.key("update-count") updateCount: int,
}
@spice
type response = {
  data: data,
  message: string,
}

module Orders = {
  @react.component
  let make = () => {
    let router = Next.Router.useRouter()
    // let {mutate} = Swr.useSwrConfig()

    let status = CustomHooks.OrdersAllAdmin.use(
      router.query->Webapi.Url.URLSearchParams.makeWithDict->Webapi.Url.URLSearchParams.toString,
    )

    let count = switch status {
    | Loaded(orders) =>
      switch orders->CustomHooks.OrdersAllAdmin.orders_decode {
      | Ok(orders') => orders'.count->Int.toString
      | Error(_) => `-`
      }
    | _ => `-`
    }

    <>
      <div
        className=%twc(
          "max-w-gnb-panel overflow-auto overflow-x-scroll bg-div-shape-L1 min-h-screen"
        )>
        <header className=%twc("flex items-baseline p-7 pb-0")>
          <h1 className=%twc("text-text-L1 text-xl font-bold")>
            {j`전체주문 조회`->React.string}
          </h1>
        </header>
        <Summary_Order_All_Admin />
        <div className=%twc("p-7 m-4 shadow-gl overflow-auto overflow-x-scroll bg-white rounded")>
          <div className=%twc("md:flex md:justify-between pb-4")>
            <div className=%twc("flex flex-auto justify-between")>
              <h3 className=%twc("font-bold")>
                {j`주문내역`->React.string}
                <span className=%twc("ml-1 text-green-gl font-normal")>
                  {j`${count}건`->React.string}
                </span>
              </h3>
              <div className=%twc("flex")> <Select_CountPerPage className=%twc("mr-2") /> </div>
            </div>
          </div>
          <List status />
        </div>
      </div>
    </>
  }
}

@react.component
let make = () =>
  <Authorization.Admin title=j`관리자 주문서 조회`> <Orders /> </Authorization.Admin>
