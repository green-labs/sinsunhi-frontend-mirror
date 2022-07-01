open ReactHookForm
module NormalMutation = %relay(`
  mutation AddProductAdminNormalMutation(
    $categoryId: ID!
    $description: String!
    $displayCategoryIds: [ID!]!
    $displayName: String!
    $image: ImageInput!
    $isCourierAvailable: Boolean!
    $isVat: Boolean!
    $name: String!
    $notice: String
    $noticeEndAt: DateTime
    $noticeStartAt: DateTime
    $origin: String!
    $price: Int!
    $producerId: ID!
    $salesDocument: String
    $status: ProductStatus!
    $type_: NormalProductType!
  ) {
    createProduct(
      input: {
        categoryId: $categoryId
        description: $description
        displayCategoryIds: $displayCategoryIds
        displayName: $displayName
        image: $image
        isCourierAvailable: $isCourierAvailable
        isVat: $isVat
        name: $name
        notice: $notice
        noticeEndAt: $noticeEndAt
        noticeStartAt: $noticeStartAt
        origin: $origin
        price: $price
        producerId: $producerId
        salesDocument: $salesDocument
        status: $status
        type: $type_
      }
    ) {
      ... on CreateProductResult {
        product {
          id
        }
      }
      ... on Error {
        code
        message
      }
    }
  }
`)

module QuotedMutation = %relay(`
  mutation AddProductAdminQuotedMutation(
    $categoryId: ID!
    $description: String!
    $displayCategoryIds: [ID!]!
    $displayName: String!
    $image: ImageInput!
    $name: String!
    $notice: String
    $noticeEndAt: DateTime
    $noticeStartAt: DateTime
    $origin: String!
    $grade: String!
    $producerId: ID!
    $salesDocument: String
    $status: ProductStatus!
  ) {
    createQuotedProduct(
      input: {
        categoryId: $categoryId
        description: $description
        displayCategoryIds: $displayCategoryIds
        displayName: $displayName
        image: $image
        name: $name
        notice: $notice
        noticeEndAt: $noticeEndAt
        noticeStartAt: $noticeStartAt
        origin: $origin
        grade: $grade
        producerId: $producerId
        salesDocument: $salesDocument
        status: $status
      }
    ) {
      ... on CreateQuotedProductResult {
        product {
          id
        }
      }
      ... on Error {
        code
        message
      }
    }
  }
`)

module Normal = Add_Normal_Product_Form_Admin
module Quoted = Add_Quoted_Product_Form_Admin

module NormalSuccessDialog = {
  type showWithId = Show(string) | Hide
  @react.component
  let make = (~showWithId) => {
    let router = Next.Router.useRouter()

    let (isShow, id) = {
      switch showWithId {
      | Show(id) => (Dialog.Show, Some(id))
      | Hide => (Dialog.Hide, None)
      }
    }

    <Dialog
      boxStyle=%twc("text-center rounded-2xl")
      isShow
      textOnCancel=`아니오(목록으로)`
      textOnConfirm=`네`
      kindOfConfirm=Dialog.Positive
      onCancel={_ => router->Next.Router.push("/admin/products")}
      onConfirm={_ =>
        id
        ->Option.map(id' => router->Next.Router.push(`/admin/products/${id'}/create-options`))
        ->ignore}>
      <div className=%twc("flex flex-col")>
        <span> {`상품등록이 완료되었습니다.`->React.string} </span>
        <span> {`이어서 상품의 단품을 등록하시겠어요?`->React.string} </span>
      </div>
    </Dialog>
  }
}

module QuotedSuccessDialog = {
  @react.component
  let make = (~isShow) => {
    let router = Next.Router.useRouter()

    <Dialog
      boxStyle=%twc("text-center rounded-2xl")
      isShow
      textOnCancel=`확인`
      kindOfConfirm=Dialog.Positive
      onCancel={_ => router->Next.Router.push("/admin/products")}>
      <div className=%twc("flex flex-col")>
        <span> {`견적상품등록이 완료되었습니다.`->React.string} </span>
      </div>
    </Dialog>
  }
}

let makeCategoryId = form => {
  open ReactSelect
  switch form {
  | Selected({value}) => value
  | NotSelected => ""
  }
}

let makeDisplayCategoryIds = (form: array<Select_Display_Categories.Form.submit>) => {
  form->Array.keepMap(({c1, c2, c3, c4, c5}) =>
    [c1, c2, c3, c4, c5]
    ->Array.keepMap(select =>
      switch select {
      | Selected({value}) => Some(value)
      | NotSelected => None
      }
    )
    ->Garter.Array.last
  )
}

let makeNoticeDate = (dateStr, setTimeFn) => {
  dateStr
  ->Option.keep(str => str != "")
  ->Option.map(dateStr' => {
    dateStr'->Js.Date.fromString->setTimeFn->Js.Date.toISOString
  })
}
let makeNormalProductVariables = (form: Normal.Form.submit) =>
  NormalMutation.makeVariables(
    ~categoryId=form.productCategory.c5->makeCategoryId,
    ~displayCategoryIds=form.displayCategories->makeDisplayCategoryIds,
    ~description=form.editor,
    ~displayName=form.buyerProductName,
    ~image={
      original: form.thumbnail.original,
      thumb1000x1000: form.thumbnail.thumb1000x1000,
      thumb100x100: form.thumbnail.thumb100x100,
      thumb1920x1920: form.thumbnail.thumb1920x1920,
      thumb400x400: form.thumbnail.thumb400x400,
      thumb800x800: form.thumbnail.thumb800x800,
    },
    ~isVat={form.tax->Select_Tax_Status.toBool},
    ~isCourierAvailable={form.delivery->Select_Delivery.toBool},
    ~name=form.producerProductName,
    ~notice=?{form.notice->Option.keep(str => str != "")},
    ~noticeEndAt=?{form.noticeEndAt->makeNoticeDate(DateFns.endOfDay)},
    ~noticeStartAt=?{form.noticeStartAt->makeNoticeDate(DateFns.startOfDay)},
    ~origin=form.origin,
    ~price=form.basePrice,
    ~producerId=form.producerName.value,
    ~salesDocument=?{form.documentURL->Option.keep(str => str != "")},
    ~status=switch form.operationStatus {
    | SALE => #SALE
    | SOLDOUT => #SOLDOUT
    | HIDDEN_SALE => #HIDDEN_SALE
    | NOSALE => #NOSALE
    | RETIRE => #RETIRE
    },
    ~type_=switch form.quotable {
    | true => #QUOTABLE
    | false => #NORMAL
    },
    (),
  )

let makeQuotedProductVariables = (form: Quoted.Form.submit) =>
  QuotedMutation.makeVariables(
    ~categoryId=form.productCategory.c5->makeCategoryId,
    ~displayCategoryIds=form.displayCategories->makeDisplayCategoryIds,
    ~description=form.editor,
    ~displayName=form.buyerProductName,
    ~image={
      original: form.thumbnail.original,
      thumb1000x1000: form.thumbnail.thumb1000x1000,
      thumb100x100: form.thumbnail.thumb100x100,
      thumb1920x1920: form.thumbnail.thumb1920x1920,
      thumb400x400: form.thumbnail.thumb400x400,
      thumb800x800: form.thumbnail.thumb800x800,
    },
    ~name=form.producerProductName,
    ~notice=?{form.notice->Option.keep(str => str != "")},
    ~noticeEndAt=?{form.noticeEndAt->makeNoticeDate(DateFns.endOfDay)},
    ~noticeStartAt=?{form.noticeStartAt->makeNoticeDate(DateFns.startOfDay)},
    ~origin=form.origin,
    ~grade=form.grade,
    ~producerId=form.producerName.value,
    ~salesDocument=?{form.documentURL->Option.keep(str => str != "")},
    ~status=switch form.operationStatus {
    | SALE => #SALE
    | SOLDOUT => #SOLDOUT
    | HIDDEN_SALE => #HIDDEN_SALE
    | NOSALE => #NOSALE
    | RETIRE => #RETIRE
    },
    (),
  )

module Product = {
  @react.component
  let make = () => {
    let (normalMutate, isNormalMutating) = NormalMutation.use()
    let (quotedMutate, isQuotedMutating) = QuotedMutation.use()

    let {addToast} = ReactToastNotifications.useToasts()
    let (productType, setProductType) = React.Uncurried.useState(_ => Select_Product_Type.NORMAL)

    let methods = Hooks.Form.use(.
      ~config=Hooks.Form.config(
        ~mode=#onChange,
        ~defaultValues=[
          (
            Product_Detail_Basic_Admin.Form.formName.displayCategories,
            [
              Select_Display_Categories.Form.defaultDisplayCategory(
                Select_Display_Categories.Form.Normal,
              ),
            ]->Js.Json.array,
          ),
          (Product_Detail_Description_Admin.Form.formName.thumbnail, ""->Js.Json.string),
        ]
        ->Js.Dict.fromArray
        ->Js.Json.object_,
        (),
      ),
      (),
    )
    let {handleSubmit, reset} = methods

    let (isShowReset, setShowReset) = React.Uncurried.useState(_ => Dialog.Hide)
    let (isShowNormalSuccess, setShowNormalSucess) = React.Uncurried.useState(_ =>
      NormalSuccessDialog.Hide
    )
    let (isShowQuotedSuccess, setShowQuotedSucess) = React.Uncurried.useState(_ => Dialog.Hide)

    let onSubmit = (data: Js.Json.t, _) => {
      Js.log(data)
      let result = switch productType {
      | NORMAL =>
        data
        ->Normal.Form.submit_decode
        ->Result.map(data' =>
          normalMutate(
            ~variables=makeNormalProductVariables(data'),
            ~onCompleted=({createProduct}, _) => {
              switch createProduct {
              | #CreateProductResult({product}) => setShowNormalSucess(._ => Show(product.id))
              | _ => ()
              }
            },
            (),
          )->ignore
        )

      | QUOTED =>
        data
        ->Quoted.Form.submit_decode
        ->Result.map(data' =>
          quotedMutate(
            ~variables=makeQuotedProductVariables(data'),
            ~onCompleted=({createQuotedProduct}, _) => {
              switch createQuotedProduct {
              | #CreateQuotedProductResult(_) => setShowQuotedSucess(._ => Dialog.Show)
              | _ => ()
              }
            },
            (),
          )->ignore
        )
      }

      switch result {
      | Error(e) => {
          Js.log(e)
          addToast(.
            <div className=%twc("flex items-center")>
              <IconError height="24" width="24" className=%twc("mr-2") />
              {j`오류가 발생하였습니다. 등록내용을 확인하세요.`->React.string}
            </div>,
            {appearance: "error"},
          )
        }
      | _ => ()
      }
    }

    let handleReset = ReactEvents.interceptingHandler(_ => {
      setShowReset(._ => Dialog.Show)
    })

    <ReactHookForm.Provider methods>
      <form onSubmit={handleSubmit(. onSubmit)}>
        <div className=%twc("max-w-gnb-panel overflow-auto bg-div-shape-L1 min-h-screen")>
          <header className=%twc("flex items-baseline p-7 pb-0")>
            <h1 className=%twc("text-text-L1 text-xl font-bold")>
              {j`상품 등록`->React.string}
            </h1>
          </header>
          <div>
            <div className=%twc("px-7 pt-7 mt-4 mx-4 bg-white rounded-t-md shadow-gl")>
              <h2 className=%twc("text-text-L1 text-lg font-bold")>
                {j`상품유형`->React.string}
              </h2>
              <div className=%twc("py-6 w-80")>
                <Select_Product_Type
                  status={productType} onChange={status => setProductType(._ => status)}
                />
              </div>
            </div>
            {switch productType {
            | NORMAL => <Add_Normal_Product_Form_Admin />
            | QUOTED => <Add_Quoted_Product_Form_Admin />
            }}
          </div>
        </div>
        <div
          className=%twc(
            "relative h-16 max-w-gnb-panel bg-white flex items-center gap-2 justify-end pr-5"
          )>
          <button
            type_="reset"
            className=%twc("px-3 py-2 bg-div-shape-L1 rounded-lg focus:outline-none")
            onClick={handleReset}
            disabled={isNormalMutating || isQuotedMutating}>
            {`초기화`->React.string}
          </button>
          <button
            type_="submit"
            className=%twc(
              "px-3 py-2 bg-green-gl text-white rounded-lg hover:bg-green-gl-dark focus:outline-none"
            )
            disabled={isNormalMutating || isQuotedMutating}>
            {`상품 등록`->React.string}
          </button>
        </div>
      </form>
      <Dialog
        boxStyle=%twc("text-center rounded-2xl")
        isShow={isShowReset}
        textOnCancel=`닫기`
        textOnConfirm=`초기화`
        kindOfConfirm=Dialog.Negative
        onConfirm={_ => {
          reset(. None)
          setShowReset(._ => Dialog.Hide)
        }}
        onCancel={_ => setShowReset(._ => Dialog.Hide)}>
        <p> {`모든 내용을 초기화 하시겠어요?`->React.string} </p>
      </Dialog>
      <NormalSuccessDialog showWithId={isShowNormalSuccess} />
      <QuotedSuccessDialog isShow={isShowQuotedSuccess} />
    </ReactHookForm.Provider>
  }
}

@react.component
let make = () => {
  <Authorization.Admin title=j`관리자 상품 조회`> <Product /> </Authorization.Admin>
}
