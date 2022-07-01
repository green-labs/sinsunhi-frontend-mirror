module Crop = {
  module Query = Select_BulkSale_Crop.Query

  @react.component
  let make = (~cropId, ~onChange, ~disabled=false) => {
    let handleLoadOptions = inputValue => {
      Query.fetchPromised(
        ~environment=RelayEnv.envFMBridge,
        ~variables={
          nameMatch: Some(inputValue),
          count: Some(1000),
          cursor: None,
          orderBy: Some(#NAME),
          orderDirection: Some(#ASC),
        },
        (),
      ) |> Js.Promise.then_((result: SelectBulkSaleCropQuery_graphql.Types.rawResponse) => {
        let result' = result.crops.edges->Garter.Array.map(edge => ReactSelect.Selected({
          value: edge.node.id,
          label: edge.node.name,
        }))

        Js.Promise.resolve(Some(result'))
      })
    }
    <article className=%twc("w-full")>
      <ReactSelect
        value=cropId
        loadOptions={Helper.Debounce.make1(handleLoadOptions, 500)}
        cacheOptions=false
        defaultOptions=true
        onChange
        placeholder=`품목 검색`
        noOptionsMessage={_ => `검색 결과가 없습니다.`}
        isClearable=true
        styles={ReactSelect.stylesOptions(
          ~menu=(provide, _) => {
            provide->Js.Obj.assign({
              "position": "inherit",
              "z-index": "999",
            })
          },
          ~control=(provide, _) => {
            provide->Js.Obj.assign({
              "min-height": "unset",
              "height": "2.25rem",
              "border-radius": "0.5rem",
            })
          },
          (),
        )}
        isDisabled={disabled}
      />
    </article>
  }
}

module ProductCategory = {
  module Query = Select_BulkSale_ProductCategory.Query

  @react.component
  let make = (~cropId, ~productCategoryId, ~onChange, ~disabled=false) => {
    let handleLoadOptions = inputValue => {
      switch cropId {
      | ReactSelect.NotSelected => Js.Promise.resolve(None)
      | ReactSelect.Selected({value}) =>
        Query.fetchPromised(
          ~environment=RelayEnv.envFMBridge,
          ~variables={
            nameMatch: Some(inputValue),
            cropIds: Some([value]),
            count: Some(1000),
            cursor: None,
            orderBy: Some(#NAME),
            orderDirection: Some(#ASC),
          },
          (),
        ) |> Js.Promise.then_((
          result: SelectBulkSaleProductCategoryQuery_graphql.Types.rawResponse,
        ) => {
          let result' =
            result.productCategories.edges->Garter.Array.map(edge => ReactSelect.Selected({
              value: edge.node.id,
              label: edge.node.name,
            }))

          Js.Promise.resolve(Some(result'))
        })
      }
    }
    <article className=%twc("w-full")>
      <ReactSelect
        value=productCategoryId
        loadOptions={Helper.Debounce.make1(handleLoadOptions, 500)}
        cacheOptions=false
        defaultOptions=true
        onChange
        placeholder=`품종 검색`
        noOptionsMessage={_ => {
          switch cropId {
          | ReactSelect.NotSelected => `품목을 검색해 주세요.`
          | ReactSelect.Selected(_) => `검색 결과가 없습니다.`
          }
        }}
        isClearable=true
        styles={ReactSelect.stylesOptions(
          ~menu=(provide, _) => {
            provide->Js.Obj.assign({
              "position": "inherit",
              "z-index": "999",
            })
          },
          ~control=(provide, _) => {
            provide->Js.Obj.assign({
              "min-height": "unset",
              "height": "2.25rem",
              "border-radius": "0.5rem",
            })
          },
          (),
        )}
        isDisabled={disabled}
      />
    </article>
  }
}

module Staff = {
  module Query = %relay(`
  query SelectBulkSaleSearchStaffQuery($name: String) {
    adminUsers(first: 999, name: $name) {
      count
      edges {
        cursor
        node {
          id
          name
          emailAddress
        }
      }
    }
  }
`)

  module Mutation = %relay(`
  mutation SelectBulkSaleSearchStaffMutation(
    $id: ID!
    $input: BulkSaleApplicationUpdateInput!
  ) {
    updateBulkSaleApplication(id: $id, input: $input) {
      result {
        id
        staff {
          id
          name
          emailAddress
        }
        staffKey
      }
    }
  }
`)

  let getEmailId = x => x->Js.String2.split("@")->Garter_Array.firstExn

  @react.component
  let make = (~applicationId=?, ~staffInfo, ~onChange=?) => {
    let {addToast} = ReactToastNotifications.useToasts()
    let (selectStaff, setSelectStaff) = React.Uncurried.useState(_ => staffInfo)

    let (mutate, _) = Mutation.use()

    let handleLoadOptions = inputValue => {
      Query.fetchPromised(
        ~environment=RelayEnv.envFMBridge,
        ~variables={
          name: Some(inputValue),
        },
        (),
      ) |> Js.Promise.then_((result: SelectBulkSaleSearchStaffQuery_graphql.Types.rawResponse) => {
        let result' = result.adminUsers.edges->Garter.Array.map(edge => ReactSelect.Selected({
          value: edge.node.id,
          label: edge.node.name ++ `( ` ++ edge.node.emailAddress->getEmailId ++ ` )`,
        }))

        Js.Promise.resolve(Some(result'))
      })
    }

    let handleOnChange = selectValue => {
      switch onChange {
      | Some(onChange') => {
          setSelectStaff(._ => selectValue)
          selectValue->onChange'
        }
      | None =>
        switch applicationId {
        | Some(applicationId') => {
            let input: SelectBulkSaleSearchStaffMutation_graphql.Types.variables = {
              id: applicationId',
              input: Mutation.make_bulkSaleApplicationUpdateInput(
                ~staffId={
                  switch selectValue {
                  | ReactSelect.Selected({value}) => value
                  | _ => ""
                  }
                },
                (),
              ),
            }

            mutate(
              ~variables=input,
              ~onCompleted=(_, _) => {
                addToast(.
                  <div className=%twc("flex items-center")>
                    <IconCheck height="24" width="24" fill="#12B564" className=%twc("mr-2") />
                    {j`담당자를 수정하였습니다.`->React.string}
                  </div>,
                  {appearance: "success"},
                )
                setSelectStaff(._ => selectValue)
              },
              ~onError={
                err => {
                  Js.Console.log(err.message)
                  addToast(.
                    <div className=%twc("flex items-center")>
                      <IconError height="24" width="24" className=%twc("mr-2") />
                      {`담당자 변경중 오류가 발생하였습니다. 관리자에게 문의해주세요.`->React.string}
                    </div>,
                    {appearance: "error"},
                  )
                }
              },
              (),
            )->ignore
          }
        | None => ()
        }
      }
    }

    <article className=%twc("w-full")>
      <ReactSelect
        value=selectStaff
        loadOptions={Helper.Debounce.make1(handleLoadOptions, 500)}
        cacheOptions=false
        defaultOptions=true
        onChange={handleOnChange}
        placeholder=`담당자 선택`
        noOptionsMessage={_ => `검색 결과가 없습니다.`}
        isClearable=true
        styles={ReactSelect.stylesOptions(
          ~menu=(provide, _) => {
            Js.Obj.assign(Js.Obj.empty(), provide)->Js.Obj.assign({
              "position": "absolute",
              "z-index": "999",
            })
          },
          ~control=(provide, _) => {
            Js.Obj.assign(Js.Obj.empty(), provide)->Js.Obj.assign({
              "min-height": "unset",
              "height": "2.25rem",
              "border-radius": "0.5rem",
            })
          },
          (),
        )}
        isDisabled={false}
      />
    </article>
  }
}
