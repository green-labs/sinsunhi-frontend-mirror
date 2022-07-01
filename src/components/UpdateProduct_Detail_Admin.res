open ReactHookForm
module Fragment = %relay(`
fragment UpdateProductDetailAdminFragment on Product {
  id
  name
  productId
  status
  type_: type
  displayCategories {
    fullyQualifiedName {
      type_: type
      id
      name
    }
  }
  category {
    fullyQualifiedName {
      id
      name
    }
  }
  ...UpdateNormalProductFormAdminFragment
  ...UpdateQuotedProductFormAdminFragment
}
`)

module NormalMutation = %relay(`
   mutation UpdateProductDetailAdminNormalMutation(
     $id: ID!
     $description: String!
     $displayCategoryIds: [ID!]!
     $displayName: String!
     $image: ImageInput!
     $isCourierAvailable: Boolean!
     $name: String!
     $notice: String
     $noticeEndAt: DateTime
     $noticeStartAt: DateTime
     $origin: String!
     $price: Int!
     $salesDocument: String
     $status: ProductStatus!
     $type_: NormalProductType!
   ) {
     updateProduct(
       input: {
         id: $id
         description: $description
         displayCategoryIds: $displayCategoryIds
         displayName: $displayName
         image: $image
         isCourierAvailable: $isCourierAvailable
         name: $name
         notice: $notice
         noticeEndAt: $noticeEndAt
         noticeStartAt: $noticeStartAt
         origin: $origin
         price: $price
         salesDocument: $salesDocument
         status: $status
         type: $type_
       }
     ) {
       ... on UpdateProductResult {
         product {
           id
         }
       }
     }
   } 
`)

module QuotedMutation = %relay(`
   mutation UpdateProductDetailAdminQuotedMutation(
     $id: ID!
     $description: String!
     $displayCategoryIds: [ID!]!
     $displayName: String!
     $image: ImageInput!
     $name: String!
     $notice: String
     $noticeEndAt: DateTime
     $noticeStartAt: DateTime
     $origin: String!
     $salesDocument: String
     $status: ProductStatus!
     $grade: String!
   ) {
     updateQuotedProduct(
       input: {
         id: $id
         description: $description
         displayCategoryIds: $displayCategoryIds
         displayName: $displayName
         image: $image
         name: $name
         notice: $notice
         noticeEndAt: $noticeEndAt
         noticeStartAt: $noticeStartAt
         origin: $origin
         salesDocument: $salesDocument
         status: $status
         grade: $grade
       }
     ) {
       ... on UpdateQuotedProductResult {
         product {
           id
         }
       }
     }
   } 
`)

module Normal = Update_Normal_Product_Form_Admin
module Quoted = Update_Quoted_Product_Form_Admin

let makeDisplayCategoryIds = (displayCategories: array<Select_Display_Categories.Form.submit>) => {
  displayCategories->Array.keepMap(({c1, c2, c3, c4, c5}) =>
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

let encodeStatus = (status: Select_Product_Operation_Status.Base.status) => {
  switch status {
  | SALE => #SALE
  | SOLDOUT => #SOLDOUT
  | HIDDEN_SALE => #HIDDEN_SALE
  | NOSALE => #NOSALE
  | RETIRE => #RETIRE
  }
}

let makeNormalProductVariables = (productId, form: Normal.Form.submit) =>
  NormalMutation.makeVariables(
    ~id=productId,
    ~displayCategoryIds=form.displayCategories->makeDisplayCategoryIds,
    ~displayName=form.buyerProductName,
    ~image={
      original: form.thumbnail.original,
      thumb1000x1000: form.thumbnail.thumb1000x1000,
      thumb100x100: form.thumbnail.thumb100x100,
      thumb1920x1920: form.thumbnail.thumb1920x1920,
      thumb400x400: form.thumbnail.thumb400x400,
      thumb800x800: form.thumbnail.thumb800x800,
    },
    ~description=form.editor,
    ~isCourierAvailable=form.delivery->Select_Delivery.toBool,
    ~name=form.producerProductName,
    ~notice=?{form.notice->Option.keep(str => str != "")},
    ~noticeStartAt=?{form.noticeStartAt->makeNoticeDate(DateFns.startOfDay)},
    ~noticeEndAt=?{form.noticeEndAt->makeNoticeDate(DateFns.endOfDay)},
    ~origin=form.origin,
    ~price=form.basePrice,
    ~salesDocument=?{form.documentURL->Option.keep(str => str != "")},
    ~status=form.operationStatus->encodeStatus,
    ~type_=switch form.quotable {
    | true => #QUOTABLE
    | false => #NORMAL
    },
    (),
  )

let makeQuotedProductVariables = (productId, form: Quoted.Form.submit) =>
  QuotedMutation.makeVariables(
    ~id=productId,
    ~displayCategoryIds=form.displayCategories->makeDisplayCategoryIds,
    ~displayName=form.buyerProductName,
    ~image={
      original: form.thumbnail.original,
      thumb1000x1000: form.thumbnail.thumb1000x1000,
      thumb100x100: form.thumbnail.thumb100x100,
      thumb1920x1920: form.thumbnail.thumb1920x1920,
      thumb400x400: form.thumbnail.thumb400x400,
      thumb800x800: form.thumbnail.thumb800x800,
    },
    ~description=form.editor,
    ~name=form.producerProductName,
    ~grade=form.grade,
    ~notice=?{form.notice->Option.keep(str => str != "")},
    ~noticeStartAt=?{form.noticeStartAt->makeNoticeDate(DateFns.startOfDay)},
    ~noticeEndAt=?{form.noticeEndAt->makeNoticeDate(DateFns.endOfDay)},
    ~origin=form.origin,
    ~salesDocument=?{form.documentURL->Option.keep(str => str != "")},
    ~status=form.operationStatus->encodeStatus,
    (),
  )

@react.component
let make = (~query) => {
  let product = Fragment.use(query)
  let router = Next.Router.useRouter()
  let (normalMutate, isNormalMutating) = NormalMutation.use()
  let (quotedlMutate, isQuotedlMutating) = QuotedMutation.use()
  let {addToast} = ReactToastNotifications.useToasts()
  let (isShowUpdateSuccess, setShowUpdateSuccess) = React.Uncurried.useState(_ => Dialog.Hide)
  let (isShowInitalize, setShowInitialize) = React.Uncurried.useState(_ => Dialog.Hide)

  let productType = {
    open Select_Product_Type
    switch product.type_ {
    | #NORMAL => NORMAL
    | #QUOTABLE => NORMAL
    | #QUOTED => QUOTED
    | _ => NORMAL
    }
  }

  let methods = Hooks.Form.use(.
    ~config=Hooks.Form.config(
      ~mode=#onChange,
      ~defaultValues=[
        //다이나믹하게 생성되는 Field array 특성상 defaultValue를 Form에서 초기 설정을 해주어 맨 처음 마운트 될때만 값이 유지되도록 한다.
        (
          Product_Detail_Basic_Admin.Form.formName.displayCategories,
          product.displayCategories
          ->Array.map(d => d.fullyQualifiedName)
          ->Array.map(Select_Display_Categories.encodeQualifiedNameValue)
          ->Array.map(Select_Display_Categories.Form.submit_encode)
          ->Js.Json.array,
        ),
        (
          Product_Detail_Basic_Admin.Form.formName.productCategory,
          product.category.fullyQualifiedName
          ->Select_Product_Category.encodeQualifiedNameValue
          ->Select_Product_Category.Form.submit_encode,
        ),
      ]
      ->Js.Dict.fromArray
      ->Js.Json.object_,
      (),
    ),
    (),
  )
  let {handleSubmit} = methods

  let onSubmit = (data: Js.Json.t, _) => {
    let result = switch productType {
    | NORMAL =>
      data
      ->Normal.Form.submit_decode
      ->Result.map(data' =>
        normalMutate(
          ~variables=makeNormalProductVariables(product.id, data'),
          ~onCompleted={(_, _) => setShowUpdateSuccess(._ => Dialog.Show)},
          (),
        )->ignore
      )

    | QUOTED =>
      data
      ->Quoted.Form.submit_decode
      ->Result.map(data' =>
        quotedlMutate(
          ~variables=makeQuotedProductVariables(product.id, data'),
          ~onCompleted={(_, _) => setShowUpdateSuccess(._ => Dialog.Show)},
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
            {j`오류가 발생하였습니다. 수정내용을 확인하세요.`->React.string}
          </div>,
          {appearance: "error"},
        )
      }
    | _ => ()
    }
  }

  let handleReset = ReactEvents.interceptingHandler(_ => {
    setShowInitialize(._ => Dialog.Show)
  })

  {
    <ReactHookForm.Provider methods>
      <form onSubmit={handleSubmit(. onSubmit)}>
        <div className=%twc("max-w-gnb-panel overflow-auto bg-div-shape-L1 min-h-screen mb-16")>
          <header className=%twc("flex flex-col items-baseline p-7 pb-0 gap-1")>
            <div className=%twc("flex justify-center items-center gap-2 text-sm")>
              <span className=%twc("font-bold")> {`상품 조회·수정`->React.string} </span>
              <IconArrow height="16" width="16" fill="#262626" />
              <span> {`상품 수정`->React.string} </span>
            </div>
            <h1 className=%twc("text-text-L1 text-xl font-bold")>
              {j`${product.name} 수정`->React.string}
            </h1>
          </header>
          <div>
            //상품 기본정보
            <div className=%twc("px-7 pt-7 mt-4 mx-4 bg-white rounded-t-md shadow-gl")>
              <h2 className=%twc("text-text-L1 text-lg font-bold")>
                {j`상품유형`->React.string}
              </h2>
              <div className=%twc("py-6 w-80")>
                <Select_Product_Type status={productType} onChange={_ => ()} />
              </div>
            </div>
            {switch productType {
            | NORMAL => <Update_Normal_Product_Form_Admin query={product.fragmentRefs} />
            | QUOTED => <Update_Quoted_Product_Form_Admin query={product.fragmentRefs} />
            }}
          </div>
        </div>
        <div
          className=%twc(
            "fixed bottom-0 h-16 max-w-gnb-panel bg-white flex items-center gap-2 justify-end pr-10 w-full z-50"
          )>
          {switch product.status {
          | #RETIRE =>
            <button
              type_="submit"
              disabled=true
              className=%twc("px-3 py-2 bg-disabled-L2 text-white rounded-lg focus:outline-none")>
              {`상품을 수정할 수 없습니다.`->React.string}
            </button>
          | _ => <>
              <button
                type_="reset"
                className=%twc("px-3 py-2 bg-div-shape-L1 rounded-lg focus:outline-none")
                onClick={handleReset}
                disabled={isNormalMutating || isQuotedlMutating}>
                {`수정내용 초기화`->React.string}
              </button>
              <button
                type_="submit"
                disabled={isNormalMutating || isQuotedlMutating}
                className=%twc(
                  "px-3 py-2 bg-green-gl text-white rounded-lg hover:bg-green-gl-dark focus:outline-none"
                )>
                {`상품 수정`->React.string}
              </button>
            </>
          }}
        </div>
      </form>
      <Dialog
        boxStyle=%twc("text-center rounded-2xl")
        isShow={isShowInitalize}
        textOnCancel=`닫기`
        textOnConfirm=`초기화`
        kindOfConfirm=Dialog.Negative
        onConfirm={_ => {
          router->Next.Router.reload(router.pathname)
          setShowInitialize(._ => Dialog.Hide)
        }}
        onCancel={_ => setShowInitialize(._ => Dialog.Hide)}>
        <p> {`수정한 모든 내용을 초기화 하시겠어요?`->React.string} </p>
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
          {`상품정보가 수정되었습니다.`->React.string}
        </p>
      </Dialog>
    </ReactHookForm.Provider>
  }
}
