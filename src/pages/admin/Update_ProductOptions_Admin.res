@module("../../../public/assets/inequality-sign-right.svg")
external inequalitySignRightIcon: string = "default"

module Query = %relay(`
  query UpdateProductOptionsAdminQuery($id: ID!) {
    node(id: $id) {
      ... on Product {
        ...UpdateProductOptionsAdminFragment
        ...UpdateProductOptionsAdminProductTypeFragment
      }
    }
  }
`)

module Fragment = %relay(`
  fragment UpdateProductOptionsAdminFragment on Product {
    id
    displayName
    ...ProductSummaryAdminFragment
  
    ... on NormalProduct {
      isCourierAvailable
      productOptions(first: 20)
        @connection(key: "UpdateProductOptionsAdmin_productOptions") {
        __id
        edges {
          node {
            id
            status
            ...UpdateProductOptionAdminFragment
          }
        }
      }
    }
  
    ... on QuotableProduct {
      isCourierAvailable
      productOptions(first: 20)
        @connection(key: "UpdateProductOptionsAdmin_productOptions") {
        __id
        edges {
          node {
            id
            status
            ...UpdateProductOptionAdminFragment
          }
        }
      }
    }
  }
`)

module ProductTypeFragment = %relay(`
  fragment UpdateProductOptionsAdminProductTypeFragment on Product {
    ... on NormalProduct {
      id
    }
    ... on QuotableProduct {
      id
    }
  }
`)

module Mutation = %relay(`
  mutation UpdateProductOptionsAdminMutation(
    $connections: [ID!]!
    $input: UpsertProductOptionsInput!
  ) {
    upsertProductOptions(input: $input) {
      ... on Error {
        message
        code
      }
      ... on UpsertProductOptionsResult {
        createdProductOptions
          @appendNode(
            connections: $connections
            edgeTypeName: "UpdateProductOptionsAdmin_productOptions"
          ) {
          id
          countPerPackageMax
          countPerPackageMin
          cutOffTime
          grade
          memo
          optionName
          packageType
          perSizeMax
          perSizeMin
          perSizeUnit
          perWeightMax
          perWeightMin
          perWeightUnit
          perWeightUnit
          price
          productOptionCost {
            deliveryCost
            fromDate
            rawCost
            workingCost
          }
          status
          stockSku
          weight
          weightUnit
        }
        updatedProductOptions {
          id
          countPerPackageMax
          countPerPackageMin
          cutOffTime
          grade
          memo
          optionName
          packageType
          perSizeMax
          perSizeMin
          perSizeUnit
          perWeightMax
          perWeightMin
          perWeightUnit
          perWeightUnit
          price
          productOptionCost {
            deliveryCost
            fromDate
            rawCost
            workingCost
          }
          status
          stockSku
          weight
        }
      }
    }
  }
`)

module Form = {
  @spice
  type submit = {
    @spice.key("connection-id") connectionId: string,
    @spice.key("create") create: option<array<Add_ProductOption_Admin.Form.submit>>,
    @spice.key("edit") edit: array<Update_ProductOption_Admin.Form.submit>,
  }

  @spice
  type productOption = {@spice.key("product-options") productOption: submit}
}

let contractTypeEncode = str => {
  switch str {
  | _ if str == `온라인택배` => #ONLINE
  | _ if str == `전량판매` => #BULKSALE
  | _ => #ONLINE
  }
}

let statusEncode = str => {
  switch str {
  | _ if str == `SALE` => #SALE
  | _ if str == `SOLDOUT` => #SOLDOUT
  | _ if str == `HIDDEN_SALE` => #HIDDEN_SALE
  | _ if str == `NOSALE` => #NOSALE
  | _ if str == `RETIRE` => #RETIRE
  | _ => #SALE
  }
}

let weightUnitEncode = weightUnit => {
  open Select_Product_Option_Unit.WeightStatus

  switch weightUnit {
  | G => #G
  | KG => #KG
  | T => #T
  }
}
let sizeUnitEncode = sizeUnit => {
  open Select_Product_Option_Unit.SizeStatus

  switch sizeUnit {
  | MM => #MM
  | CM => #CM
  | M => #M
  }
}

let noneToDefaultCutOffTime = cutOffTime =>
  cutOffTime->Option.mapWithDefault(
    Some(`10시 이전 발주 완료건에 한해 당일 출고(단, 산지 상황에 따라 출고 일정은 변경 될 수 있습니다.)`),
    str => Some(str),
  )

let nonEmptyString = str => str !== ""

let makeUpdateOption: Update_ProductOption_Admin.Form.submit => UpdateProductOptionsAdminMutation_graphql.Types.updateProductOptionInput = option => {
  id: option.id,
  optionName: {
    switch option.name {
    | Some(name') if name' == "" => option.autoGenName
    | Some(name') => name'
    | None => option.autoGenName
    }
  },
  memo: option.memo->Option.keep(nonEmptyString),
  cutOffTime: option.cutOffTime->Option.keep(nonEmptyString)->noneToDefaultCutOffTime,
  status: switch option.operationStatus {
  | SALE => #SALE
  | NOSALE => #NOSALE
  | HIDDEN_SALE => #HIDDEN_SALE
  | SOLDOUT => #SOLDOUT
  | RETIRE => #RETIRE
  },
  productOptionCost: {
    isFreeShipping: switch option.isFreeShipping {
    | FREE => true
    | NOTFREE => false
    },
  },
}

let makeCreateOption: (
  string,
  Add_ProductOption_Admin.Form.submit,
) => UpdateProductOptionsAdminMutation_graphql.Types.createProductOptionInput = (
  productNodeId,
  option,
) => {
  productOptionCost: {
    contractType: option.cost.costType->contractTypeEncode,
    deliveryCost: option.cost.deliveryCost->Option.getWithDefault(0),
    rawCost: option.cost.rawCost,
    workingCost: option.cost.workingCost,
    isFreeShipping: switch option.isFreeShipping {
    | FREE => true
    | NOTFREE => false
    },
  },
  grade: option.grade->Option.keep(nonEmptyString),
  //--- 입수정보
  countPerPackageMax: option.each
  ->Option.keep(_ => option.showEach)
  ->Option.map(each => each.numMax->Int.fromFloat),
  countPerPackageMin: option.each
  ->Option.keep(_ => option.showEach)
  ->Option.map(each => each.numMin->Int.fromFloat),
  perSizeMax: option.each->Option.keep(_ => option.showEach)->Option.map(each => each.sizeMin),
  perSizeMin: option.each->Option.keep(_ => option.showEach)->Option.map(each => each.sizeMax),
  perSizeUnit: option.each
  ->Option.keep(_ => option.showEach)
  ->Option.map(each => each.sizeUnit->sizeUnitEncode),
  perWeightMax: option.each
  ->Option.keep(_ => option.showEach)
  ->Option.map(each =>
    Product_Option_Each_Admin.getPerWeight(
      option.weight,
      option.weightUnit,
      each.numMin,
      Some(each.weightUnit),
    )
  )
  ->Option.flatMap(Float.fromString),
  perWeightMin: option.each
  ->Option.keep(_ => option.showEach)
  ->Option.map(each =>
    Product_Option_Each_Admin.getPerWeight(
      option.weight,
      option.weightUnit,
      each.numMax,
      Some(each.weightUnit),
    )
  )
  ->Option.flatMap(Float.fromString),
  perWeightUnit: option.each
  ->Option.keep(_ => option.showEach)
  ->Option.map(each => each.weightUnit->weightUnitEncode),
  //-- 입수 정보 끝
  cutOffTime: option.cutOffTime->Option.keep(nonEmptyString)->noneToDefaultCutOffTime,
  memo: option.memo->Option.keep(nonEmptyString),
  optionName: {
    switch option.name->Option.keep(str => str !== "") {
    | Some(name') => name'
    | None => {
        let (numMin, numMax, perWeightUnit, sizeMin, sizeMax, sizeUnit) =
          option.each
          ->Option.map(({numMin, numMax, weightUnit, sizeMin, sizeMax, sizeUnit}) => (
            numMin->Some,
            numMax->Some,
            weightUnit->Some,
            sizeMin->Some,
            sizeMax->Some,
            sizeUnit->Some,
          ))
          ->Option.getWithDefault((None, None, None, None, None, None))
        Add_ProductOption_Admin.makeAutoGeneratedName(
          ~grade=option.grade,
          ~package=option.package,
          ~weight=option.weight->Float.toString->Some,
          ~weightUnit=option.weightUnit->Select_Product_Option_Unit.Weight.toString->Some,
          ~numMin={numMin->Option.map(Float.toString)},
          ~numMax={numMax->Option.map(Float.toString)},
          ~perWeightUnit={
            perWeightUnit->Option.map(Select_Product_Option_Unit.Weight.toString)
          },
          ~sizeMin={sizeMin->Option.map(Float.toString)},
          ~sizeMax={sizeMax->Option.map(Float.toString)},
          ~sizeUnit={
            sizeUnit->Option.map(Select_Product_Option_Unit.Size.toString)
          },
          ~showEach={true},
          (),
        )
      }
    }
  },
  packageType: option.package->Option.keep(nonEmptyString),
  price: option.cost.buyerPrice,
  productId: productNodeId,
  weight: option.weight,
  weightUnit: option.weightUnit->weightUnitEncode,
  status: option.operationStatus->statusEncode,
}

module Title = {
  @react.component
  let make = (~productDisplayName) => {
    <header className=%twc("flex flex-col items-baseline px-5 py-4 pb-0 gap-1")>
      <div className=%twc("flex items-center gap-1 text-text-L1 text-sm")>
        <span className=%twc("font-bold")> {`상품 조회·수정`->React.string} </span>
        <img src=inequalitySignRightIcon />
        <span> {`단품 수정`->React.string} </span>
      </div>
      <h1 className=%twc("text-text-L1 text-xl font-bold")>
        {`[${productDisplayName}] 상품의 단품 수정`->React.string}
      </h1>
    </header>
  }
}

module Bottom = {
  @react.component
  let make = (~onReset) => {
    <div
      className=%twc(
        "fixed bottom-0 w-[calc(100vw-300px)] bg-white h-16 flex items-center gap-2 justify-end pr-10"
      )>
      <button
        onClick=onReset className=%twc("px-3 py-2 bg-div-shape-L1 rounded-lg focus:outline-none")>
        {`초기화`->React.string}
      </button>
      <button
        type_="submit"
        className=%twc(
          "px-3 py-2 bg-green-gl text-white rounded-lg hover:bg-green-gl-dark focus:outline-none"
        )>
        {`단품 수정`->React.string}
      </button>
    </div>
  }
}

module Presenter = {
  open ReactHookForm

  @react.component
  let make = (~query) => {
    let queryData = Fragment.use(query)
    let productType = ProductTypeFragment.use(query)
    let router = Next.Router.useRouter()
    let {
      displayName: productDisplayName,
      id: productNodeId,
      isCourierAvailable,
      productOptions,
    } = queryData
    let {addToast} = ReactToastNotifications.useToasts()
    let (isShowUpdateSuccess, setShowUpdateSuccess) = React.Uncurried.useState(_ => Dialog.Hide)
    let (isShowInitalize, setShowInitialize) = React.Uncurried.useState(_ => Dialog.Hide)

    let (mutate, _) = Mutation.use()
    let methods = Hooks.Form.use(. ~config=Hooks.Form.config(~mode=#onChange, ()), ())
    let {handleSubmit, reset, trigger} = methods

    let onSubmit = (data: Js.Json.t, _) => {
      switch data->Form.productOption_decode {
      | Ok({productOption: {create, edit, connectionId}}) =>
        {
          let createProductOptions = {
            create->Option.map(arr => arr->Array.map(makeCreateOption(productNodeId)))
          }

          let updateProductOptions = {
            Some(edit->Array.map(option => makeUpdateOption(option)))
          }

          mutate(
            ~variables={
              connections: [connectionId->RescriptRelay.makeDataId],
              input: {
                createProductOptions: createProductOptions,
                updateProductOptions: updateProductOptions,
              },
            },
            ~onCompleted=(_, _) => {
              setShowUpdateSuccess(._ => Dialog.Show)
            },
            ~onError={
              err => {
                Js.log(err)
                addToast(.
                  <span className=%twc("flex items-center")>
                    <IconError height="24" width="24" className=%twc("mr-2") />
                    {err.message->React.string}
                  </span>,
                  {appearance: "error"},
                )
              }
            },
            (),
          )
        }->ignore
      | Error(err) => {
          Js.log2("decode error", err)
          addToast(.
            <span className=%twc("flex items-center")>
              <IconError height="24" width="24" className=%twc("mr-2") />
              {err.message->React.string}
            </span>,
            {appearance: "error"},
          )->ignore
        }
      }
    }

    let handleReset = ReactEvents.interceptingHandler(_ => {
      setShowInitialize(._ => Dialog.Show)
    })

    switch productType {
    | #NormalProduct(_)
    | #QuotableProduct(_) =>
      switch productOptions {
      | Some(options) =>
        <ReactHookForm.Provider methods>
          <form onSubmit={handleSubmit(. onSubmit)}>
            <div className=%twc("max-w-gnb-panel overflow-auto bg-div-shape-L1 min-h-screen")>
              <Title productDisplayName />
              <Product_Summary_Admin query={queryData.fragmentRefs} />
              <section className=%twc("p-7 mt-4 mx-4 mb-20 bg-white rounded shadow-gl")>
                <Update_ProductOption_List_Admin
                  productDisplayName={productDisplayName}
                  options
                  isCourierAvailable={isCourierAvailable->Option.getWithDefault(false)}
                />
              </section>
            </div>
            <Bottom onReset={handleReset} />
          </form>
          <Dialog
            boxStyle=%twc("text-center rounded-2xl")
            isShow={isShowInitalize}
            textOnCancel=`닫기`
            textOnConfirm=`초기화`
            kindOfConfirm=Dialog.Negative
            onConfirm={_ => {
              reset(. None)
              // validation 을 호출하지 않는한 폼의 내용이 비어있다.
              trigger(. "")
              setShowInitialize(._ => Dialog.Hide)
            }}
            onCancel={_ => {
              setShowInitialize(._ => Dialog.Hide)
            }}>
            <p className=%twc("text-gray-500 text-center whitespace-pre-wrap")>
              {`단품 등록 페이지를`->React.string}
              <br />
              {`초기화 하시겠습니까?`->React.string}
            </p>
          </Dialog>
          <Dialog
            boxStyle=%twc("text-center rounded-2xl")
            isShow={isShowUpdateSuccess}
            textOnCancel=`확인`
            onCancel={_ => {
              setShowUpdateSuccess(._ => Dialog.Hide)
              router->Next.Router.reload(router.pathname)
            }}>
            <p className=%twc("text-gray-500 text-center whitespace-pre-wrap")>
              {`단품정보가 수정되었습니다.`->React.string}
            </p>
          </Dialog>
        </ReactHookForm.Provider>
      | None => React.null
      }

    | #UnselectedUnionMember(_) =>
      <div> {`지원하지 않은 상품 타입 입니다`->React.string} </div>
    }
  }
}

module Container = {
  // node 를 못찾은 경우는 해당 컴포넌트에서 처리합니다.
  // Presenter 는 node가 존재할 때 렌더됩니다.
  @react.component
  let make = (~productId: string) => {
    let queryData = Query.use(
      ~variables={id: productId},
      ~fetchPolicy=RescriptRelay.StoreAndNetwork,
      (),
    )

    switch queryData.node {
    | Some(node') => <Presenter query={node'.fragmentRefs} />
    | None => <div> {`상품이 존재하지 않습니다`->React.string} </div>
    }
  }
}

@react.component
let make = () => {
  let router = Next.Router.useRouter()
  let id = router.query->Js.Dict.get("pid")

  <RescriptReactErrorBoundary fallback={_ => <div> {j`에러 발생`->React.string} </div>}>
    <Authorization.Admin title=j`관리자 단품 관리`>
      <React.Suspense fallback={<div> {j`로딩 중..`->React.string} </div>}>
        {switch id {
        | Some(productId') => <Container productId={productId'} />
        | None => <div> {`상품이 존재하지 않습니다.`->React.string} </div>
        }}
      </React.Suspense>
    </Authorization.Admin>
  </RescriptReactErrorBoundary>
}
