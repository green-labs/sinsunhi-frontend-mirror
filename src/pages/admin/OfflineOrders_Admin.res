open ReactHookForm
module List = OfflineOrder_List_Admin

external unsafeAsFile: Webapi.Blob.t => Webapi.File.t = "%identity"

@spice
type inputs = {
  checkbox: bool,
  id: string,
  @spice.key("order-quantity") orderQuantity: string,
  @spice.key("order-quantity-complete") confirmedOrderQuantity: string,
  @spice.key("producer-product-cost") cost: string,
  @spice.key("buyer-sell-price") price: string,
  @spice.key("release-date") releaseDate: string,
  @spice.key("release-due-date") releaseDueDate: string,
}
@spice
type form = array<inputs>

// order type is same as inputs type except checkbox
@spice
type order = {
  id: string,
  @spice.key("order-quantity") orderQuantity: string,
  @spice.key("order-quantity-complete") confirmedOrderQuantity: string,
  @spice.key("producer-product-cost") cost: string,
  @spice.key("buyer-sell-price") price: string,
  @spice.key("release-date") releaseDate: string,
  @spice.key("release-due-date") releaseDueDate: string,
}

@spice
type body = array<order>

module OfflineOrders = {
  @react.component
  let make = () => {
    let router = Next.Router.useRouter()
    let {mutate} = Swr.useSwrConfig()
    let {addToast} = ReactToastNotifications.useToasts()
    let queryParms =
      router.query->Webapi.Url.URLSearchParams.makeWithDict->Webapi.Url.URLSearchParams.toString
    let status = CustomHooks.OfflineOrders.use(queryParms)
    let methods = Hooks.Form.use(. ~config=Hooks.Form.config(~mode=#onChange, ()), ())

    let (isShowSuccessToSave, setShowSuccessToSave) = React.Uncurried.useState(_ => Dialog.Hide)
    let (isShowError, setShowError) = React.Uncurried.useState(_ => Dialog.Hide)
    let (errorMessage, setErrorMessage) = React.Uncurried.useState(_ => `저장 실패`)

    let onSubmit = (data: Js.Json.t, _) => {
      let toJsonArray = data => {
        let dict = data->Js.Json.decodeObject->Option.getWithDefault(Js.Dict.empty())

        let inputs =
          dict
          ->Js.Dict.keys
          ->Array.map(k =>
            Js.Dict.get(dict, k)->Option.flatMap(v => {
              let input = v->Js.Json.decodeObject
              input->Option.forEach(v' => v'->Js.Dict.set("id", k->Js.Json.string))

              input
            })
          )
          ->Helper.Option.sequence
          ->Option.map(arr => arr->Array.map(Js.Json.object_))
          ->Option.map(arr => arr->Js.Json.array)
          ->Option.getWithDefault(Js.Json.null)

        inputs
      }
      // Parse
      let orders =
        data
        ->toJsonArray
        ->Js.Json.decodeArray
        ->Option.getWithDefault([])
        ->Array.map(inputs_decode)
        //수정하지 않은 주문 제외
        ->Array.keep(i => i->Result.isOk)
        ->Helper.Result.sequence
        //수정중이지 않은 주문 제외
        ->Result.map(arr => arr->Array.keep(order => order.checkbox))
        ->Result.map(form_encode)
        ->Result.flatMap(body_decode)
        //수정할 주문이 없는 경우 None
        ->(
          r =>
            switch r {
            | Ok(orders') => orders'->Array.length > 0 ? Some(orders') : None
            | Error(e) =>
              Js.log(e)
              None
            }
        )

      orders
      ->Option.map(body_encode)
      ->Option.flatMap(Js.Json.stringifyAny)
      ->Option.map(body =>
        FetchHelper.requestWithRetry(
          ~fetcher=FetchHelper.putWithToken,
          ~url=`${Env.restApiUrl}/offline-order`,
          ~body,
          ~count=3,
          ~onSuccess={
            res => {
              Js.log("success")

              mutate(.
                ~url=`${Env.restApiUrl}/offline-order?${router.query
                  ->Webapi.Url.URLSearchParams.makeWithDict
                  ->Webapi.Url.URLSearchParams.toString}`,
                ~data=None,
                ~revalidation=None,
              )

              methods.reset(. None)
              setShowSuccessToSave(._ => Dialog.Show)
            }
          },
          ~onFailure={
            error => {
              let customError = error->FetchHelper.convertFromJsPromiseError
              setErrorMessage(._ =>
                customError.message->Option.getWithDefault(`요청에 실패했습니다.`)
              )
              setShowError(._ => Dialog.Show)
              addToast(.
                <div className=%twc("flex items-center")>
                  <IconError height="24" width="24" className=%twc("mr-2") />
                  {j`저장 실패`->React.string}
                </div>,
                {appearance: "error"},
              )
            }
          },
        )
      )
      ->ignore
    }

    <div className=%twc("py-8 px-4 bg-div-shape-L1 min-h-screen")>
      <header className=%twc("md:flex md:items-baseline pb-0")>
        <h1 className=%twc("font-bold text-xl")> {j`오프라인 주문관리`->React.string} </h1>
      </header>
      <Search_OfflineOrder_Admin
        defaults={router.query->Search_OfflineOrder_Admin.getDefaults} key={queryParms}
      />
      <ReactHookForm.Provider methods>
        <form onSubmit={methods.handleSubmit(. onSubmit)}>
          <div
            className=%twc(
              "px-7 py-6 mt-2 shadow-gl overflow-auto overflow-x-scroll bg-white rounded"
            )>
            {switch status {
            | Loading
            | Error(_) => React.null
            | Loaded(data) =>
              switch data->CustomHooks.OfflineOrders.offlineOrders_decode {
              | Ok(data') => <>
                  <div className=%twc("md:flex md:justify-between pb-4")>
                    <div className=%twc("flex flex-auto justify-between")>
                      <h2 className=%twc("font-bold text-lg")>
                        {j`내역`->React.string}
                        <span className=%twc("ml-2 text-base text-primary font-normal")>
                          {j`${data'.count
                            ->Float.fromInt
                            ->Locale.Float.show(~digits=0)}개`->React.string}
                        </span>
                      </h2>
                      <div className=%twc("flex")>
                        <Select_CountPerPage className=%twc("mr-2") />
                        <button type_="submit" className=%twc("hidden") disabled={true} />
                        <Excel_Download_Request_Button
                          userType=Admin requestUrl="/offline-order/excel"
                        />
                        <button
                          type_="submit"
                          className=%twc("px-3 py-1 ml-3 rounded-lg bg-primary text-white")>
                          {j`저장`->React.string}
                        </button>
                      </div>
                    </div>
                  </div>
                  <List status />
                </>
              | Error(e) => {
                  Js.log(e)
                  React.null
                }
              }
            }}
          </div>
        </form>
      </ReactHookForm.Provider>
      <Dialog
        isShow=isShowError textOnCancel=`확인` onCancel={_ => setShowError(._ => Dialog.Hide)}>
        <p className=%twc("text-gray-500 text-center whitespace-pre-wrap")>
          {errorMessage->React.string}
        </p>
      </Dialog>
      <Dialog
        isShow=isShowSuccessToSave
        textOnCancel=`확인`
        onCancel={_ => setShowSuccessToSave(._ => Dialog.Hide)}>
        <p className=%twc("text-gray-500 text-center whitespace-pre-wrap")>
          {`선택한 오프라인주문 정보가 저장되었습니다.`->React.string}
        </p>
      </Dialog>
    </div>
  }
}

@react.component
let make = () => {
  let user = CustomHooks.User.Admin.use()
  <>
    <Next.Head> <title> {j`관리자 오프라인 주문관리`->React.string} </title> </Next.Head>
    {switch user {
    | Unknown => <div> {j`인증 확인 중 입니다.`->React.string} </div>
    | NotLoggedIn => <div> {j`로그인이 필요 합니다.`->React.string} </div>
    | LoggedIn(_) => <OfflineOrders />
    }}
  </>
}
