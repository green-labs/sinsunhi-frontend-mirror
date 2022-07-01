open RadixUI
open Webapi

@react.component
let make = (~user: CustomHooks.QueryUser.Farmer.user) => {
  let router = Next.Router.useRouter()
  let {mutate} = Swr.useSwrConfig()
  let {addToast} = ReactToastNotifications.useToasts()

  let (selectedUser, setSelectedUser) = React.Uncurried.useState(_ => ReactSelect.NotSelected)

  let close = () => {
    let buttonClose = Dom.document->Dom.Document.getElementById("btn-close")
    buttonClose
    ->Option.flatMap(buttonClose' => {
      buttonClose'->Dom.Element.asHtmlElement
    })
    ->Option.forEach(buttonClose' => {
      buttonClose'->Dom.HtmlElement.click
    })
    ->ignore
  }

  let save = (
    _ => {
      {
        "farmer-id": user.id,
        "md-id": switch selectedUser {
        | ReactSelect.Selected({value}) => value->Int.fromString
        | ReactSelect.NotSelected => None
        },
      }
      ->Js.Json.stringifyAny
      ->Option.map(body => {
        FetchHelper.requestWithRetry(
          ~fetcher=FetchHelper.putWithToken,
          ~url=`${Env.restApiUrl}/user/farmer`,
          ~body,
          ~count=3,
          ~onSuccess={
            _ => {
              close()
              addToast(.
                <div className=%twc("flex items-center")>
                  <IconCheck height="24" width="24" fill="#12B564" className=%twc("mr-2") />
                  {j`저장되었습니다.`->React.string}
                </div>,
                {appearance: "success"},
              )
              mutate(.
                ~url=`${Env.restApiUrl}/user?${{
                    let rq = router.query
                    rq->Js.Dict.set("role", "farmer")
                    rq->Webapi.Url.URLSearchParams.makeWithDict->Webapi.Url.URLSearchParams.toString
                  }}`,
                ~data=None,
                ~revalidation=Some(true),
              )
            }
          },
          ~onFailure={
            _ =>
              addToast(.
                <div className=%twc("flex items-center")>
                  <IconError height="24" width="24" className=%twc("mr-2") />
                  {j`오류가 발생하였습니다.`->React.string}
                </div>,
                {appearance: "error"},
              )
          },
        )
      })
      ->ignore
    }
  )->ReactEvents.interceptingHandler

  let handleLoadOptions = inputValue =>
    FetchHelper.fetchWithRetry(
      ~fetcher=FetchHelper.getWithToken,
      ~url=`${Env.restApiUrl}/user?name=${inputValue}&role=admin`,
      ~body="",
      ~count=3,
    ) |> Js.Promise.then_(result =>
      switch result->CustomHooks.QueryUser.Admin.users_decode {
      | Ok(users') if users'.data->Garter.Array.length > 0 =>
        let users'' = users'.data->Garter.Array.map(user => ReactSelect.Selected({
          value: user.id->Int.toString,
          label: `${user.name}(${user.email->Option.getWithDefault("")})
            `,
        }))
        Js.Promise.resolve(Some(users''))
      | _ => Js.Promise.reject(Js.Exn.raiseError(`유저 검색 에러`))
      }
    )

  let handleChangeUser = selection => {
    setSelectedUser(._ => selection)
  }

  <Dialog.Root>
    <Dialog.Overlay className=%twc("dialog-overlay") />
    <Dialog.Trigger className=%twc("block text-left mb-1 underline focus:outline-none")>
      <IconEdit height="20" width="20" />
    </Dialog.Trigger>
    <Dialog.Content className=%twc("dialog-content overflow-y-auto")>
      <div className=%twc("p-5")>
        <section className=%twc("flex")>
          <h2 className=%twc("text-xl font-bold")> {j`담당소싱MD`->React.string} </h2>
          <Dialog.Close className=%twc("inline-block p-1 focus:outline-none ml-auto")>
            <IconClose height="24" width="24" fill="#262626" />
          </Dialog.Close>
        </section>
        <section className=%twc("mt-7")>
          <h3> {j`담당자`->React.string} </h3>
          <div className=%twc("mt-2")>
            <ReactSelect
              value=selectedUser
              loadOptions=handleLoadOptions
              cacheOptions=true
              defaultOptions=false
              onChange=handleChangeUser
              placeholder=`담당MD 이름으로 찾기`
              noOptionsMessage={_ => `검색 결과가 없습니다.`}
              isClearable=true
              styles={ReactSelect.stylesOptions(~menu=(provide, _) => {
                Js.Obj.assign(Js.Obj.empty(), provide)->Js.Obj.assign({"position": "inherit"})
              }, ())}
            />
          </div>
        </section>
        <section className=%twc("flex justify-center items-center mt-5")>
          <Dialog.Close className=%twc("flex mr-2")>
            <span id="btn-close" className=%twc("btn-level6 py-3 px-5")>
              {j`닫기`->React.string}
            </span>
          </Dialog.Close>
          <span className=%twc("flex mr-2")>
            <button className=%twc("btn-level1 py-3 px-5") onClick=save>
              {j`저장`->React.string}
            </button>
          </span>
        </section>
      </div>
    </Dialog.Content>
  </Dialog.Root>
}
