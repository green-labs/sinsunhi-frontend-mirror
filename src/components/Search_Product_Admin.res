open ReactHookForm

module Fragment = {
  module Categories = %relay(`
        fragment SearchProductAdminCategoriesFragment on Query
        @argumentDefinitions(
          displayCategoryId: { type: "ID!" }
          productCategoryId: { type: "ID!" }
        ) {
          displayCategoryNode: node(id: $displayCategoryId) {
            ... on DisplayCategory {
              fullyQualifiedName {
                type_: type
                id
                name
              }
            }
          }
        
          productCategoryNode: node(id: $productCategoryId) {
            ... on Category {
              fullyQualifiedName {
                id
                name
              }
            }
          }
        }
  `)
}

module Form = {
  type name = {
    producerName: string,
    producerCodes: string,
    productName: string,
    productNos: string,
    productCategory: string,
    displayCategory: string,
    status: string,
    delivery: string,
    productType: string,
  }

  let formName = {
    producerName: "producer-name",
    producerCodes: "producer-codes",
    productName: "product-name",
    productNos: "product-nos",
    productCategory: "product-category",
    displayCategory: "display-category",
    status: "status",
    delivery: "delivery",
    productType: "product-type",
  }

  @spice
  type submit = {
    @spice.key(formName.producerName) producerName: string,
    @spice.key(formName.producerCodes) producerCodes: string,
    @spice.key(formName.productName) productName: string,
    @spice.key(formName.productNos) productNos: string,
    @spice.key(formName.productCategory) productCategory: Search_Product_Category.Form.submit,
    @spice.key(formName.displayCategory) displayCategory: Search_Display_Category.Form.submit,
    @spice.key(formName.status) status: string,
    @spice.key(formName.delivery) delivery: string,
    @spice.key(formName.productType) productType: string,
  }
}

type defaultValue = {
  producerName: option<string>,
  producerCodes: option<string>,
  productName: option<string>,
  productNos: option<string>,
  status: option<string>,
  delivery: option<string>,
  productType: option<string>,
}

let getDefault = (dict: Js.Dict.t<string>) => {
  producerName: dict->Js.Dict.get("producer-name"),
  producerCodes: dict->Js.Dict.get("producer-codes"),
  productName: dict->Js.Dict.get("name"),
  productNos: dict->Js.Dict.get("product-nos"),
  status: dict->Js.Dict.get("status"),
  delivery: dict->Js.Dict.get("delivery"),
  productType: dict->Js.Dict.get("type"),
}

@react.component
let make = (~defaultValue: defaultValue, ~defaultCategoryQuery) => {
  let router = Next.Router.useRouter()
  let categoriesQueryData = Fragment.Categories.use(defaultCategoryQuery)

  let methods = Hooks.Form.use(.
    ~config=Hooks.Form.config(
      ~mode=#all,
      ~defaultValues=[
        (
          //전시카테고리 프리필
          Form.formName.displayCategory,
          categoriesQueryData.displayCategoryNode
          ->Option.flatMap(node => {
            switch node {
            | #DisplayCategory(data) =>
              Search_Display_Category.encodeQualifiedNameValue(data.fullyQualifiedName)->Some
            | _ => None
            }
          })
          ->Option.map(Search_Display_Category.Form.submit_encode)
          ->Option.getWithDefault(
            Search_Display_Category.Form.defaultDisplayCategory(
              Search_Display_Category.Form.Normal,
            ),
          ),
        ),
        (
          //표준카테고리 프리필
          Form.formName.productCategory,
          categoriesQueryData.productCategoryNode
          ->Option.flatMap(node => {
            switch node {
            | #Category(data) =>
              Search_Product_Category.encodeQualifiedNameValue(data.fullyQualifiedName)->Some
            | _ => None
            }
          })
          ->Option.map(Search_Product_Category.Form.submit_encode)
          ->Option.getWithDefault(Search_Product_Category.Form.defaultProductCategory),
        ),
        (
          Form.formName.producerName,
          defaultValue.producerName->Option.getWithDefault("")->Js.Json.string,
        ),
        (
          Form.formName.producerCodes,
          defaultValue.producerCodes->Option.getWithDefault("")->Js.Json.string,
        ),
        (
          Form.formName.productName,
          defaultValue.productName->Option.getWithDefault("")->Js.Json.string,
        ),
        (
          Form.formName.productNos,
          defaultValue.productNos->Option.getWithDefault("")->Js.Json.string,
        ),
        (Form.formName.status, defaultValue.status->Option.getWithDefault(`ALL`)->Js.Json.string),
        (Form.formName.delivery, defaultValue.delivery->Option.getWithDefault("")->Js.Json.string),
        (
          Form.formName.productType,
          defaultValue.productType->Option.getWithDefault(`ALL`)->Js.Json.string,
        ),
      ]
      ->Js.Dict.fromArray
      ->Js.Json.object_,
      (),
    ),
    (),
  )

  let onSubmit = (data: Js.Json.t, _) => {
    let getSelectValue = (select: ReactSelect.selectOption) =>
      switch select {
      | Selected({value}) => Some(value)
      | NotSelected => None
      }

    switch data->Form.submit_decode {
    | Ok(data') => {
        router.query->Js.Dict.set("producer-name", data'.producerName)
        router.query->Js.Dict.set("producer-codes", data'.producerCodes)
        router.query->Js.Dict.set("name", data'.productName)
        router.query->Js.Dict.set("product-nos", data'.productNos)
        router.query->Js.Dict.set("status", data'.status)
        router.query->Js.Dict.set("delivery", data'.delivery)
        router.query->Js.Dict.set("type", data'.productType)
        router.query->Js.Dict.set(
          "category-id",
          {
            open Search_Product_Category.Form
            data'.productCategory
            ->(({c1, c2, c3, c4, c5}: submit) => [c1, c2, c3, c4, c5])
            ->Array.keepMap(getSelectValue)
            ->Garter.Array.last
            ->Option.getWithDefault("")
          },
        )
        router.query->Js.Dict.set(
          "display-category-id",
          {
            open Search_Display_Category.Form
            data'.displayCategory
            ->(({c1, c2, c3, c4, c5}: submit) => [c1, c2, c3, c4, c5])
            ->Array.keepMap(getSelectValue)
            ->Garter.Array.last
            ->Option.getWithDefault("")
          },
        )
        //offset 초기화
        router.query->Js.Dict.set("offset", "0")

        let {makeWithDict, toString} = module(Webapi.Url.URLSearchParams)

        router->Next.Router.push(`${router.pathname}?${router.query->makeWithDict->toString}`)
      }
    | Error(err) => Js.log(err)
    }
  }
  let {register, handleSubmit, control, reset, formState: {errors}} = methods

  let producerName = register(. Form.formName.producerName, None)
  let producerCodes = register(. Form.formName.producerCodes, None)
  let productName = register(. Form.formName.productName, None)
  let productNos = register(.
    Form.formName.productNos,
    Some(Hooks.Register.config(~pattern=%re("/^([0-9]+([,\s]+)?)*$/g"), ())),
  )

  <div className=%twc("p-7 mt-4 mx-4 bg-white rounded shadow-gl")>
    <Provider methods>
      <form onSubmit={handleSubmit(. onSubmit)}>
        <div className=%twc("py-6 px-7 flex flex-col text-sm bg-gray-gl rounded-xl")>
          <div className=%twc("flex")>
            <div className=%twc("w-32 font-bold mt-2 whitespace-nowrap")>
              {j`검색`->React.string}
            </div>
            <div className=%twc("divide-y border-div-border-L1 w-full")>
              <div>
                <div className=%twc("flex items-center gap-2")>
                  <div> {`표준카테고리`->React.string} </div>
                  <div className=%twc("flex h-9 gap-2")>
                    <Search_Product_Category name=Form.formName.productCategory control />
                  </div>
                </div>
                <div className=%twc("flex items-center gap-2 mt-2 mb-3")>
                  <div> {`전시카테고리`->React.string} </div>
                  <Search_Display_Category control name=Form.formName.displayCategory />
                </div>
              </div>
              <div className=%twc("flex flex-col gap-y-2")>
                <div className=%twc("flex gap-12 mt-3")>
                  <div className=%twc("flex items-center grow-0")>
                    <label htmlFor="producer-name">
                      <span className=%twc("mr-2")> {`생산자명`->React.string} </span>
                    </label>
                    <div className=%twc("h-9 w-80")>
                      <input
                        name=producerName.name
                        onBlur=producerName.onBlur
                        onChange=producerName.onChange
                        ref=producerName.ref
                        id=producerName.name
                        className=%twc(
                          "w-44 py-2 px-3 border border-border-default-L1 bg-white rounded-md h-9 focus:outline-none"
                        )
                        placeholder=`생산자명 입력`
                      />
                    </div>
                  </div>
                  <div className=%twc("flex items-center grow-[0.5]")>
                    <label htmlFor="producer-ids">
                      <span className=%twc("mr-2")> {`생산자번호`->React.string} </span>
                    </label>
                    <textarea
                      name=producerCodes.name
                      onBlur=producerCodes.onBlur
                      onChange=producerCodes.onChange
                      ref=producerCodes.ref
                      id=producerCodes.name
                      className=%twc(
                        "w-auto py-2 px-3 border border-border-default-L1 bg-white rounded-md h-9 focus:outline-none grow"
                      )
                      placeholder=`생산자번호 입력(Enter 또는 “,”로 구분 가능, 최대 100개 입력 가능)`
                    />
                  </div>
                </div>
                <div className=%twc("flex items-center")>
                  <label htmlFor="product-name">
                    <span className=%twc("mr-5")> {`상품명`->React.string} </span>
                  </label>
                  <textarea
                    name=productName.name
                    onBlur=productName.onBlur
                    onChange=productName.onChange
                    ref=productName.ref
                    id=productName.name
                    className=%twc(
                      "w-auto py-2 px-3 border border-border-default-L1 bg-white rounded-md h-9 focus:outline-none grow-[0.25]"
                    )
                    placeholder=`상품명 입력`
                  />
                </div>
                <div className=%twc("flex items-center gap-2")>
                  <label htmlFor="product-nos">
                    <span className=%twc("")> {`상품번호`->React.string} </span>
                  </label>
                  <textarea
                    name=productNos.name
                    onBlur=productNos.onBlur
                    onChange=productNos.onChange
                    ref=productNos.ref
                    id=productNos.name
                    className=%twc(
                      "grow-[0.25] w-auto py-2 px-3 border border-border-default-L1 bg-white rounded-md h-9 focus:outline-none "
                    )
                    placeholder=`상품번호 입력(Enter 또는 “,”로 구분 가능, 최대 100개 입력 가능)`
                  />
                  <ErrorMessage
                    errors
                    name=productNos.name
                    render={_ =>
                      <span className=%twc("flex")>
                        <IconError width="20" height="20" />
                        <span className=%twc("text-sm text-notice ml-1")>
                          {`숫자(Enter 또는 ","로 구분 가능)만 입력해주세요`->React.string}
                        </span>
                      </span>}
                  />
                </div>
                <div className=%twc("flex gap-12")>
                  <div className=%twc("flex items-center")>
                    <label htmlFor="status">
                      <span className=%twc("mr-2")> {`판매상태`->React.string} </span>
                    </label>
                    <div className=%twc("bg-white w-44")>
                      <Controller
                        name=Form.formName.status
                        control
                        defaultValue={ALL->Select_Product_Operation_Status.Search.status_encode}
                        render={({field: {onChange, value, ref}}) =>
                          <Select_Product_Operation_Status.Search
                            status={switch value->Select_Product_Operation_Status.Search.status_decode {
                            | Ok(status) => Some(status)
                            | Error(_) => Some(ALL)
                            }}
                            onChange={status =>
                              onChange(
                                Controller.OnChangeArg.value(
                                  status->Select_Product_Operation_Status.Search.status_encode,
                                ),
                              )}
                            forwardRef={ref}
                          />}
                      />
                    </div>
                  </div>
                  <div className=%twc("flex items-center")>
                    <label htmlFor="status">
                      <span className=%twc("mr-2")> {`상품유형`->React.string} </span>
                    </label>
                    <div className=%twc("bg-white w-44")>
                      <Controller
                        name=Form.formName.productType
                        control
                        defaultValue={ALL->Select_Product_Type.Search.status_encode}
                        render={({field: {onChange, value}}) =>
                          <Select_Product_Type.Search
                            status={switch value->Select_Product_Type.Search.status_decode {
                            | Ok(status) => status
                            | Error(_) => ALL
                            }}
                            onChange={status =>
                              onChange(
                                Controller.OnChangeArg.value(
                                  status->Select_Product_Type.Search.status_encode,
                                ),
                              )}
                          />}
                      />
                    </div>
                  </div>
                  <div className=%twc("flex items-center gap-6")>
                    <div> {`택배가능여부`->React.string} </div>
                    <Controller
                      name=Form.formName.delivery
                      control
                      defaultValue={Select_Delivery_Available.ALL->Select_Delivery_Available.status_encode}
                      render={({field: {onChange, value, name}}) =>
                        <Select_Delivery_Available
                          name
                          value={value
                          ->Select_Delivery_Available.status_decode
                          ->(
                            result =>
                              switch result {
                              | Ok(value') => value'
                              | _ => Select_Delivery_Available.ALL
                              }
                          )}
                          onChange={str =>
                            onChange(Controller.OnChangeArg.value(str->Js.Json.string))}
                        />}
                    />
                  </div>
                </div>
              </div>
            </div>
            <div className=%twc("flex-1") />
          </div>
        </div>
        <div className=%twc("flex justify-center mt-5")>
          <input
            type_="button"
            className=%twc(
              "w-20 py-2 bg-gray-button-gl text-black-gl rounded-xl ml-2 hover:bg-gray-button-gl focus:outline-none focus:ring-2 focus:ring-offset-1 focus:ring-gray-gl focus:ring-opacity-100 outline-none"
            )
            value=`초기화`
            onClick={_ =>
              reset(.
                Some(
                  [
                    (
                      Form.formName.productCategory,
                      Search_Product_Category.Form.defaultProductCategory,
                    ),
                    (
                      Form.formName.displayCategory,
                      Search_Display_Category.Form.defaultDisplayCategory(
                        Search_Display_Category.Form.Normal,
                      ),
                    ),
                    (Form.formName.producerName, ""->Js.Json.string),
                    (Form.formName.producerCodes, ""->Js.Json.string),
                    (Form.formName.productName, ""->Js.Json.string),
                    (Form.formName.productNos, ""->Js.Json.string),
                    (
                      Form.formName.status,
                      Select_Product_Operation_Status.Search.status_encode(ALL),
                    ),
                    (Form.formName.delivery, ""->Js.Json.string),
                    (Form.formName.productType, Select_Product_Type.Search.status_encode(ALL)),
                  ]
                  ->Js.Dict.fromArray
                  ->Js.Json.object_,
                ),
              )}
            tabIndex=5
          />
          <input
            type_="submit"
            className=%twc(
              "w-20 py-2 bg-green-gl text-white font-bold rounded-xl ml-2 hover:bg-green-gl-dark focus:outline-none focus:ring-2 focus:ring-offset-1 focus:ring-green-gl focus:ring-opacity-100"
            )
            value=`검색`
            tabIndex=4
          />
        </div>
      </form>
    </Provider>
  </div>
}
