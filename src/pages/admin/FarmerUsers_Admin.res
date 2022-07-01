module List = User_List_Admin_Farmer

external unsafeAsFile: Webapi.Blob.t => Webapi.File.t = "%identity"

module Users = {
  @react.component
  let make = () => {
    let router = Next.Router.useRouter()
    let status = CustomHooks.QueryUser.Farmer.use(// 최초 랜딩 시 role 쿼리 파라미터를 farmer로 설정한다

    {
      let rq = router.query
      rq->Js.Dict.set("role", "farmer")
      rq->Webapi.Url.URLSearchParams.makeWithDict->Webapi.Url.URLSearchParams.toString
    })

    <div className=%twc("py-8 px-4 max-w-gnb-panel overflow-auto bg-div-shape-L1 min-h-screen")>
      <header className=%twc("flex items-baseline pb-0")>
        <h1 className=%twc("font-bold text-xl")> {j`농민 사용자 조회`->React.string} </h1>
      </header>
      <Search_Farmer_Admin />
      <div className=%twc("p-7 mt-4 shadow-gl overflow-auto overflow-x-scroll bg-white rounded")>
        <div className=%twc("md:flex md:justify-between pb-4")>
          <div className=%twc("flex flex-auto justify-between")>
            <h3 className=%twc("font-bold text-xl")> {j`내역`->React.string} </h3>
            <div className=%twc("flex")>
              <Excel_Download_Request_Button
                userType=Admin requestUrl=`/user/request-excel/farmer`
              />
            </div>
          </div>
        </div>
        <List status />
      </div>
    </div>
  }
}

@react.component
let make = () =>
  <Authorization.Admin title=j`관리자 농민 사용자 조회`> <Users /> </Authorization.Admin>
