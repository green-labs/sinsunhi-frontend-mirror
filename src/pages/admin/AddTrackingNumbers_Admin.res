module List = Order_List_Admin_Seller_Packing
module Upload = Upload_Delivery_Admin

external unsafeAsFile: Webapi.Blob.t => Webapi.File.t = "%identity"

type query = {
  from: Js.Date.t,
  to_: Js.Date.t,
}
type target = From | To

let removeQueriesFarmerName = q =>
  q->Js.Dict.entries->Garter.Array.keep(((k, _)) => k !== `farmer-id`)->Js.Dict.fromArray

module QueryFarmerPresenter = {
  @react.component
  let make = (~farmer: option<CustomHooks.QueryUser.Farmer.user>) => {
    let router = Next.Router.useRouter()

    let (selectedFarmer, setSelectedFarmer) = React.Uncurried.useState(_ => ReactSelect.NotSelected)

    React.useEffect1(_ => {
      switch farmer {
      | Some({id, name, phone}) =>
        setSelectedFarmer(._ => ReactSelect.Selected({
          value: id->Int.toString,
          label: `${name}(${phone
            ->Helper.PhoneNumber.parse
            ->Option.flatMap(Helper.PhoneNumber.format)
            ->Option.getWithDefault(phone)})`,
        }))
      | None => ()
      }

      Some(_ => setSelectedFarmer(._ => ReactSelect.NotSelected))
    }, [farmer])

    let handleLoadOptions = inputValue =>
      FetchHelper.fetchWithRetry(
        ~fetcher=FetchHelper.getWithToken,
        ~url=`${Env.restApiUrl}/user?name=${inputValue}&role=farmer`,
        ~body="",
        ~count=3,
      ) |> Js.Promise.then_(result =>
        switch result->CustomHooks.QueryUser.Farmer.users_decode {
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

    let handleChangeFarmer = selection => {
      switch selection {
      | ReactSelect.NotSelected => {
          let cleaned = router.query->removeQueriesFarmerName
          let newQueryString =
            cleaned->Webapi.Url.URLSearchParams.makeWithDict->Webapi.Url.URLSearchParams.toString

          router->Next.Router.push(`${router.pathname}?${newQueryString}`)
        }
      | ReactSelect.Selected({value}) => {
          let cleaned = router.query->removeQueriesFarmerName
          cleaned->Js.Dict.set("farmer-id", value)

          let newQueryString =
            cleaned->Webapi.Url.URLSearchParams.makeWithDict->Webapi.Url.URLSearchParams.toString

          router->Next.Router.push(`${router.pathname}?${newQueryString}`)
        }
      }
    }

    <div className=%twc("w-80 relative")>
      <ReactSelect
        value=selectedFarmer
        loadOptions=handleLoadOptions
        cacheOptions=true
        defaultOptions=false
        onChange=handleChangeFarmer
        placeholder=`생산자 이름으로 찾기`
        noOptionsMessage={_ => `검색 결과가 없습니다.`}
        isClearable=true
      />
    </div>
  }
}

module QueryFarmerWithId = {
  @react.component
  let make = (~id) => {
    let status = CustomHooks.QueryUser.Farmer.use(`user-id=${id}&role=farmer`)

    let farmer = switch status {
    | Loaded(users) =>
      switch users->CustomHooks.QueryUser.Farmer.users_decode {
      | Ok(users') => users'.data->Garter.Array.first
      | Error(_) => None
      }
    | _ => None
    }

    <QueryFarmerPresenter farmer />
  }
}

module QueryFarmerWithoutId = {
  @react.component
  let make = () => {
    <QueryFarmerPresenter farmer=None />
  }
}

module QueryFarmer = {
  @react.component
  let make = () => {
    let router = Next.Router.useRouter()

    switch router.query->Js.Dict.get("farmer-id") {
    | Some(id) => <QueryFarmerWithId id />
    | None => <QueryFarmerWithoutId />
    }
  }
}

module Orders = {
  @react.component
  let make = () => {
    let router = Next.Router.useRouter()
    let {mutate} = Swr.useSwrConfig()

    let status = CustomHooks.OrdersAdmin.use(
      router.query->Webapi.Url.URLSearchParams.makeWithDict->Webapi.Url.URLSearchParams.toString,
    )

    let (query, setQuery) = React.Uncurried.useState(_ => {
      from: Js.Date.make()->DateFns.subDays(7),
      to_: Js.Date.make(),
    })

    let (isShowSuccessUpload, setShowSuccessUpload) = React.Uncurried.useState(_ => Dialog.Hide)
    let (isShowErrorUpload, setShowErrorUpload) = React.Uncurried.useState(_ => Dialog.Hide)

    let (isShowPackingSuccess, setShowPackingSuccess) = React.Uncurried.useState(_ => Dialog.Hide)
    let (isShowPackingError, setShowPackingError) = React.Uncurried.useState(_ => Dialog.Hide)

    // FIXME: useEffect를 사용하지 않고 router.query 값을 바로 useState에 사용하면,
    // router.query->Js.Dict.get("from") 값이 None으로 처리되는 이슈가 있어 사용.
    React.useEffect1(_ => {
      let from =
        router.query
        ->Js.Dict.get("from")
        ->Option.mapWithDefault(Js.Date.make()->DateFns.subDays(5), from =>
          from->DateFns.parse("yyyyMMdd", Js.Date.make())
        )
      let to_ =
        router.query
        ->Js.Dict.get("to")
        ->Option.mapWithDefault(Js.Date.make(), to_ =>
          to_->DateFns.parse("yyyyMMdd", Js.Date.make())
        )
      setQuery(._ => {from: from, to_: to_})

      None
    }, [router.query])

    let handleOnChangeDate = (t, e) => {
      let newDate = (e->DuetDatePicker.DuetOnChangeEvent.detail).valueAsDate
      switch (t, newDate) {
      | (From, Some(newDate')) => setQuery(.prev => {...prev, from: newDate'})
      | (To, Some(newDate')) => setQuery(.prev => {...prev, to_: newDate'})
      | _ => ()
      }
    }

    let handleOnClickQuery = (
      _ => {
        router.query->Js.Dict.set("from", query.from->DateFns.format("yyyyMMdd"))
        router.query->Js.Dict.set("to", query.to_->DateFns.format("yyyyMMdd"))
        let newQueryString =
          router.query->Webapi.Url.URLSearchParams.makeWithDict->Webapi.Url.URLSearchParams.toString

        router->Next.Router.push(`${router.pathname}?${newQueryString}`)
      }
    )->ReactEvents.interceptingHandler

    let dictSet = (dict, key, val) => {
      dict->Js.Dict.set(key, val)
      dict
    }

    <>
      <div
        className=%twc(
          "max-w-gnb-panel overflow-auto overflow-x-scroll bg-div-shape-L1 rounded min-h-screen"
        )>
        <header className=%twc("flex items-baseline p-7 pb-0")>
          <h1 className=%twc("font-bold text-xl")> {j`송장번호 등록`->React.string} </h1>
        </header>
        <div className=%twc("p-7 shadow-gl mt-4 mx-4 bg-white rounded")>
          <h3 className=%twc("font-bold text-xl")>
            {j`송장번호 대량등록`->React.string}
          </h3>
          <div className=%twc("flex justify-between divide-x mt-8")>
            <section className=%twc("flex-1 pr-4")>
              <div className=%twc("flex justify-between")>
                <div className=%twc("flex justify-between")>
                  <h4 className=%twc("font-semibold")>
                    {j`1.상품준비중인 건 다운로드`->React.string}
                  </h4>
                </div>
                <Excel_Download_Request_Button
                  userType=Admin
                  requestUrl="/order/request-excel/farmer"
                  bodyOption={router.query->dictSet("status", "PACKING")}
                />
              </div>
            </section>
            <Upload
              onSuccess={_ => setShowSuccessUpload(._ => Dialog.Show)}
              onFailure={_ => setShowErrorUpload(._ => Dialog.Show)}
            />
          </div>
          <UploadStatus_Admin_Seller
            kind=CustomHooks.UploadStatus.Admin
            // 새로운 가장 최근 업로드가 생기면 목록을 새로 고침 한다.
            onChangeLatestUpload={_ => {
              mutate(.
                ~url=`${Env.restApiUrl}/order?${router.query
                  ->Webapi.Url.URLSearchParams.makeWithDict
                  ->Webapi.Url.URLSearchParams.toString}`,
                ~data=None,
                ~revalidation=Some(true),
              )
            }}
          />
        </div>
        <div className=%twc("p-7 m-4 shadow-gl overflow-auto overflow-x-scroll bg-white rounded")>
          <div className=%twc("md:flex md:justify-between pb-4")>
            <div className=%twc("flex flex-auto justify-between")>
              <h3 className=%twc("font-bold text-xl")>
                {j`송장번호 개별등록`->React.string}
              </h3>
            </div>
            <div className=%twc("flex mt-7 justify-end md:mt-0 md:ml-4")>
              <div className=%twc("flex")>
                <QueryFarmer />
                <div className=%twc("flex ml-4")>
                  <span className=%twc("w-40")>
                    <DatePicker
                      id="from"
                      date={query.from}
                      onChange={handleOnChangeDate(From)}
                      maxDate={Js.Date.make()->DateFns.format("yyyy-MM-dd")}
                      firstDayOfWeek=0
                    />
                  </span>
                  <span className=%twc("mx-1 flex items-center")> {j`~`->React.string} </span>
                  <span className=%twc("w-40")>
                    <DatePicker
                      id="to"
                      date={query.to_}
                      onChange={handleOnChangeDate(To)}
                      maxDate={Js.Date.make()->DateFns.format("yyyy-MM-dd")}
                      minDate={query.from->DateFns.format("yyyy-MM-dd")}
                      firstDayOfWeek=0
                    />
                  </span>
                </div>
              </div>
              <button
                className=%twc(
                  "px-3 py-1 bg-green-gl text-white font-bold rounded-lg ml-2 whitespace-nowrap focus:outline-none focus:ring-2 focus:ring-opacity-100 focus:ring-green-gl"
                )
                onClick=handleOnClickQuery>
                {j`조회`->React.string}
              </button>
            </div>
          </div>
          <List status />
        </div>
      </div>
      <Dialog isShow=isShowPackingSuccess onConfirm={_ => setShowPackingSuccess(._ => Dialog.Hide)}>
        <p className=%twc("text-gray-500 text-center whitespace-pre-wrap")>
          {`상품준비중 변경에 성공하였습니다.`->React.string}
        </p>
      </Dialog>
      <Dialog isShow=isShowPackingError onConfirm={_ => setShowPackingError(._ => Dialog.Hide)}>
        <p className=%twc("text-gray-500 text-center whitespace-pre-wrap")>
          {`상품준비중 변경에 실패하였습니다.\n다시 시도하시기 바랍니다.`->React.string}
        </p>
      </Dialog>
      <Dialog isShow=isShowSuccessUpload onConfirm={_ => setShowSuccessUpload(._ => Dialog.Hide)}>
        <p className=%twc("text-gray-500 text-center whitespace-pre-wrap")>
          {`업로드에 성공하였습니다.`->React.string}
        </p>
      </Dialog>
      <Dialog isShow=isShowErrorUpload onConfirm={_ => setShowErrorUpload(._ => Dialog.Hide)}>
        <p className=%twc("text-gray-500 text-center whitespace-pre-wrap")>
          {`업로드에 실패하였습니다.\n다시 시도하시기 바랍니다.`->React.string}
        </p>
      </Dialog>
    </>
  }
}

@react.component
let make = () =>
  <Authorization.Admin title=j`관리자 송장번호 등록`> <Orders /> </Authorization.Admin>
