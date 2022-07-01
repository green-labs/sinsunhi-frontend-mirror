type searchType<'a> = [< #Crop | #Cultivar | #All] as 'a

let decodeSearchType = type_ =>
  switch type_ {
  | #Crop => "item"
  | #Cultivar => "kind"
  | #All => "item-kind"
  }

@react.component
let make = (~type_: searchType<'a>, ~value: ReactSelect.selectOption, ~onChange) => {
  let handleLoadOptions = (inputValue: string) =>
    FetchHelper.fetchWithRetry(
      ~fetcher=FetchHelper.getWithToken,
      ~url=`${Env.restApiUrl}/category/search?type=${type_->decodeSearchType}&query=${inputValue}`,
      ~body="",
      ~count=3,
    ) |> Js.Promise.then_(result => {
      let result' =
        result
        ->CustomHooks.CropCategory.response_decode
        ->Result.map(response' =>
          response'.data->Array.map(category => ReactSelect.Selected({
            value: category.id->Int.toString,
            label: `${category.crop}(${category.cultivar})`,
          }))
        )

      switch result' {
      | Ok([]) => Js.Promise.reject(Js.Exn.raiseError(`작물/품종 검색 결과 없음`))
      | Ok(categories) => Js.Promise.resolve(Some(categories))
      | Error(_) =>
        Js.Promise.reject(Js.Exn.raiseError(`작물/품종 검색 에러(디코딩 오류)`))
      }
    })

  <ReactSelect
    value
    loadOptions={Helper.Debounce.make1(handleLoadOptions, 500)}
    cacheOptions=false
    defaultOptions=false
    onChange
    placeholder={switch type_ {
    | #Crop => `작물명으로 찾기`
    | #Cultivar => `품종명으로 찾기`
    | #All => `작물-품종명으로 찾기`
    }}
    noOptionsMessage={_ => `검색 결과가 없습니다.`}
    isClearable=true
    styles={ReactSelect.stylesOptions(
      ~menu=(provide, _) => {
        Js.Obj.assign(Js.Obj.empty(), provide)->Js.Obj.assign({"position": "inherit"})
      },
      ~control=(provide, _) => {
        Js.Obj.assign(Js.Obj.empty(), provide)->Js.Obj.assign({
          "min-height": "unset",
          "height": "2.25rem",
        })
      },
      (),
    )}
  />
}
