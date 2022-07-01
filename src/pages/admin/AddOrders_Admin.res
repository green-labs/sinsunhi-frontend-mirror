module UploadFile = Upload_Orders_Admin

module Upload = {
  @react.component
  let make = (~userId) => {
    let {mutate} = Swr.useSwrConfig()
    let (isShowSuccess, setShowSuccess) = React.Uncurried.useState(_ => Dialog.Hide)
    let (isShowError, setShowError) = React.Uncurried.useState(_ => Dialog.Hide)

    <>
      <div className=%twc("p-7 relative")>
        <UploadFile
          userId
          onSuccess={_ => {
            setShowSuccess(._ => Dialog.Show)
            mutate(.
              ~url=`${Env.restApiUrl}/order/recent-uploads?upload-type=order&pay-type=PAID`,
              ~data=None,
              ~revalidation=None,
            )
          }}
          onFailure={_ => setShowError(._ => Dialog.Show)}
        />
      </div>
      // 다이얼로그
      <Dialog isShow=isShowSuccess onConfirm={_ => setShowSuccess(._ => Dialog.Hide)}>
        <p className=%twc("text-gray-500 text-center whitespace-pre-wrap")>
          {`주문서 업로드가 실행되었습니다. 성공여부를 꼭 주문서 업로드 결과에서 확인해주세요.`->React.string}
        </p>
      </Dialog>
      <Dialog isShow=isShowError onConfirm={_ => setShowError(._ => Dialog.Hide)}>
        <p className=%twc("text-gray-500 text-center whitespace-pre-wrap")>
          {`파일 업로드에 실패하였습니다.`->React.string}
        </p>
      </Dialog>
    </>
  }
}

@react.component
let make = () => {
  let (selectedUser, setSelectedUser) = React.Uncurried.useState(_ => ReactSelect.NotSelected)
  let selectedUserId = switch selectedUser {
  | NotSelected => None
  | Selected({value}) => Some(value)
  }

  let handleLoadOptions = inputValue =>
    FetchHelper.fetchWithRetry(
      ~fetcher=FetchHelper.getWithToken,
      ~url=`${Env.restApiUrl}/user?name=${inputValue}&role=buyer`,
      ~body="",
      ~count=3,
    ) |> Js.Promise.then_(result =>
      switch result->CustomHooks.QueryUser.Buyer.users_decode {
      | Ok(users') if users'.data->Garter.Array.length > 0 =>
        let users'' = users'.data->Garter.Array.map(user => ReactSelect.Selected({
          value: user.id->Int.toString,
          label: `${user.name}(${user.phone
            ->Helper.PhoneNumber.parse
            ->Option.flatMap(Helper.PhoneNumber.format)
            ->Option.getWithDefault(user.phone)})`,
        }))
        Js.Promise.resolve(Some(users''))
      | _ => Js.Promise.reject(Js.Exn.raiseError(`유저 검색 에러`))
      }
    , _)

  let handleChangeUser = selection => {
    setSelectedUser(._ => selection)
  }

  <Authorization.Admin title=j`관리자 주문서 등록`>
    <div className=%twc("py-8 px-4 bg-div-shape-L1 min-h-screen")>
      <header className=%twc("md:flex md:items-baseline pb-0")>
        <h1 className=%twc("font-bold text-xl")> {j`주문서 등록`->React.string} </h1>
        <span className=%twc("md:ml-2 text-sm text-primary")>
          {j`바이어를 검색한 후, 대신 주문서를 업로드할 수 있습니다.`->React.string}
        </span>
      </header>
      <div className=%twc("flex flex-row bg-div-shape-L1")>
        <div className=%twc("flex-1 mr-4 max-w-lg mt-4 shadow-gl h-full bg-white rounded")>
          <div className=%twc("p-7 pb-4")>
            <h3 className=%twc("font-bold text-lg mb-4")>
              {j`1. 바이어 선택`->React.string}
            </h3>
            <div className=%twc("flex")>
              <div className=%twc("flex-auto relative")>
                <ReactSelect
                  value=selectedUser
                  loadOptions=handleLoadOptions
                  cacheOptions=true
                  defaultOptions=false
                  onChange=handleChangeUser
                  placeholder=`바이어 검색`
                  noOptionsMessage={_ => `검색 결과가 없습니다.`}
                  isClearable=true
                />
              </div>
            </div>
          </div>
          <Upload userId={selectedUserId} />
        </div>
        <div className=%twc("flex-1 max-w-lg shadow-gl mt-4 p-7 bg-white rounded")>
          <div className=%twc("pb-4")>
            <h4 className=%twc("text-xl font-bold")>
              {j`주문서 업로드 결과`->React.string}
            </h4>
            <UploadStatus_Buyer
              kind=CustomHooks.UploadStatus.Admin
              uploadType=CustomHooks.UploadStatus.Order
              onChangeLatestUpload={_ => Js.Console.log("업로드 처리 완료")}
            />
          </div>
          <div className=%twc("pt-4")>
            <section>
              <h4 className=%twc("text-sm text-gray-500 font-semibold")>
                {j`주문서 업로드 사용설명서`->React.string}
              </h4>
              <p className=%twc("mt-5 text-sm text-gray-400")>
                {j`주의: 송장번호 일괄 업로드가 완료되기 전까지 일부 기능을 사용하실 수 없습니다. 업로드하신 엑셀 내용에 따라 정상적으로 처리되지 않는 경우가 있을 수 있습니다. 처리결과를 반드시 확인해 주시기 바랍니다. 주문서 업로드는 상황에 따라 5분까지 소요될 수 있습니다. 처리 결과를 필히 확인해주시기 바랍니다`->React.string}
              </p>
            </section>
          </div>
        </div>
      </div>
    </div>
  </Authorization.Admin>
}
