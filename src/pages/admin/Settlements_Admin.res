module List = Settlements_List_Admin

external unsafeAsFile: Webapi.Blob.t => Webapi.File.t = "%identity"

module Settlements = {
  @react.component
  let make = () => {
    let router = Next.Router.useRouter()

    let status = CustomHooks.Settlements.use(
      router.query->Webapi.Url.URLSearchParams.makeWithDict->Webapi.Url.URLSearchParams.toString,
    )
    let (producerCodeToDownload, setProducerCodeToDownload) = React.Uncurried.useState(_ => None)
    let (isShowErrorForDownload, setShowErrorForDownload) = React.Uncurried.useState(_ =>
      Dialog.Hide
    )
    let (
      isShowErrorForNothingToDownload,
      setShowErrorForNothingToDownload,
    ) = React.Uncurried.useState(_ => Dialog.Hide)

    let count = switch status {
    | Loaded(settlements) =>
      switch settlements->CustomHooks.Settlements.settlements_decode {
      | Ok(settlements') => settlements'.count->Int.toString
      | Error(_) => `-`
      }
    | _ => `-`
    }

    let handleOnCheckSettlement = producerCode => {
      setProducerCodeToDownload(._ => Some(producerCode))
    }

    let removeCheckedSettlement = () => setProducerCodeToDownload(._ => None)

    let bodyOption: Js.Dict.t<string> = {
      let from =
        router.query
        ->Js.Dict.get("from")
        ->Option.getWithDefault(Js.Date.make()->DateFns.subDays(7)->DateFns.format("yyyyMMdd"))
      let to_ =
        router.query
        ->Js.Dict.get("to")
        ->Option.getWithDefault(Js.Date.make()->DateFns.format("yyyyMMdd"))

      Js.Dict.fromArray([
        ("from", from),
        ("to", to_),
        ("producer-codes", producerCodeToDownload->Option.getWithDefault("")),
      ])
    }

    <>
      <div
        className=%twc(
          "max-w-gnb-panel overflow-auto overflow-x-scroll bg-div-shape-L1 min-h-screen"
        )>
        <header className=%twc("flex items-baseline p-7 pb-0")>
          <h1 className=%twc("text-text-L1 text-xl font-bold")>
            {j`생산자별 정산기초금액 조회`->React.string}
          </h1>
        </header>
        <Summary_Settlement_Admin onReset=removeCheckedSettlement onQuery=removeCheckedSettlement />
        <div className=%twc("p-7 m-4 bg-white rounded shadow-gl overflow-auto overflow-x-scroll")>
          <div>
            <div className=%twc("flex flex-auto justify-between pb-3")>
              <h3 className=%twc("text-lg font-bold")>
                {j`내역`->React.string}
                <span className=%twc("text-base text-primary font-normal ml-1")>
                  {j`${count}건`->React.string}
                </span>
              </h3>
              <div className=%twc("flex")>
                <Select_CountPerPage className=%twc("mr-2") />
                <Excel_Download_Request_Button
                  userType=Admin
                  requestUrl="/settlement/request-excel"
                  bodyOption
                  buttonText={j`주문서 원본 엑셀 다운로드 요청`}
                />
              </div>
            </div>
          </div>
          <List status producerCodeToDownload onCheckSettlement=handleOnCheckSettlement />
        </div>
      </div>
      <Dialog
        isShow=isShowErrorForDownload
        textOnCancel=`확인`
        onCancel={_ => setShowErrorForDownload(._ => Dialog.Hide)}>
        <p className=%twc("text-gray-500 text-center whitespace-pre-wrap")>
          {`다운로드에 실패하였습니다.\n다시 시도하시기 바랍니다.`->React.string}
        </p>
      </Dialog>
      <Dialog
        isShow=isShowErrorForNothingToDownload
        textOnCancel=`확인`
        onCancel={_ => setShowErrorForNothingToDownload(._ => Dialog.Hide)}>
        <p className=%twc("text-gray-500 text-center whitespace-pre-wrap")>
          {`다운로드할 항목을 선택해주세요`->React.string}
        </p>
      </Dialog>
    </>
  }
}

@react.component
let make = () =>
  <Authorization.Admin title=j`관리자 정산기초금액 조회`>
    <Settlements />
  </Authorization.Admin>
