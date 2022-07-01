open RadixUI

module Mutation = %relay(`
  mutation BulkSaleProductUpdateButtonMutation(
    $id: ID!
    $input: BulkSaleCampaignUpdateInput!
  ) {
    updateBulkSaleCampaign(id: $id, input: $input) {
      result {
        ...BulkSaleProductAdminFragment_bulkSaleCampaign
      }
    }
  }
`)

let decodePackageUnit = s =>
  if s == "kg" {
    Ok(#KG)
  } else if s == "g" {
    Ok(#G)
  } else if s == "mg" {
    Ok(#MG)
  } else {
    Error()
  }

let stringifyPackageUnit = s =>
  switch s {
  | #KG => "kg"
  | #G => "g"
  | #MG => "mg"
  | _ => ""
  }

// FIXME: [> #KG | #G | #MG] vs. [#KG | #G | #MG]
// 응답 받은 enum 타입과 muation으로 전달해야하는 타입이 다르다. 왜??
let convertPackageUnit = (
  s: BulkSaleProductAdminFragment_bulkSaleCampaign_graphql.Types.enum_ProductPackageMassUnit,
): [#G | #KG | #MG] =>
  switch s {
  | #KG => #KG
  | #G => #G
  | #MG => #MG
  | _ => #KG
  }

let makeInput = (
  preferredGrade,
  preferredQuantityAmount,
  preferredQuantityUnit,
  estimatedSellerEarningRate,
  estimatedPurchasePriceMin,
  estimatedPurchasePriceMax,
  isOpen,
): BulkSaleProductUpdateButtonMutation_graphql.Types.bulkSaleCampaignUpdateInput => {
  {
    preferredGrade: Some(preferredGrade),
    preferredQuantity: Some({
      amount: preferredQuantityAmount,
      unit: preferredQuantityUnit,
    }),
    estimatedSellerEarningRate: Some(estimatedSellerEarningRate),
    estimatedPurchasePriceMin: Some(estimatedPurchasePriceMin),
    estimatedPurchasePriceMax: Some(estimatedPurchasePriceMax),
    isOpen: Some(isOpen),
    displayOrder: None,
  }
}

@react.component
let make = (~product: BulkSaleProductAdminFragment_bulkSaleCampaign_graphql.Types.fragment) => {
  let {addToast} = ReactToastNotifications.useToasts()

  let (mutate, isMutating) = Mutation.use()

  let (cropId, setCropId) = React.Uncurried.useState(_ => ReactSelect.Selected({
    value: product.productCategory.crop.id,
    label: product.productCategory.name,
  }))
  let (
    productCategoryId,
    setProductCategoryId,
  ) = React.Uncurried.useState(_ => ReactSelect.Selected({
    value: product.productCategory.id,
    label: product.productCategory.name,
  }))
  let (preferredGrade, setPreferredGrade) = React.Uncurried.useState(_ => Some(
    product.preferredGrade,
  ))
  let (preferredQuantityAmount, setPreferredQuantityAmount) = React.Uncurried.useState(_ => Some(
    product.preferredQuantity.amount->Float.toString,
  ))
  let (preferredQuantityUnit, setPreferredQuantityUnit) = React.Uncurried.useState(_ =>
    product.preferredQuantity.unit->convertPackageUnit
  )
  let (estimatedSellerEarningRate, setEstimatedSellerEarningRate) = React.Uncurried.useState(_ =>
    product.estimatedSellerEarningRate->Float.toString
  )
  let (estimatedPurchasePriceMin, setEstimatedPurchasePriceMin) = React.Uncurried.useState(_ =>
    product.estimatedPurchasePriceMin->Float.toString
  )
  let (estimatedPurchasePriceMax, setEstimatedPurchasePriceMax) = React.Uncurried.useState(_ =>
    product.estimatedPurchasePriceMax->Float.toString
  )

  let (formErrors, setFormErrors) = React.Uncurried.useState(_ => [])

  let close = () => {
    open Webapi
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

  let handleOnSave = _ => {
    let input =
      makeInput
      ->V.map(V.Option.nonEmpty(#ErrorGrade(`등급을 선택해주세요`), preferredGrade))
      ->V.ap(V.Option.float(#ErrorAmount(`중량을 입력해주세요`), preferredQuantityAmount))
      ->V.ap(V.pure(preferredQuantityUnit))
      ->V.ap(
        V.float(
          #ErrorEarningRate(`예상 추가 수익을 입력해주세요`),
          estimatedSellerEarningRate,
        ),
      )
      ->V.ap(
        V.int(
          #ErrorPriceMin(`적정 구매 가격을 입력해주세요`),
          estimatedPurchasePriceMin,
        ),
      )
      ->V.ap(
        V.int(
          #ErrorPriceMax(`적정 구매 가격을 입력해주세요`),
          estimatedPurchasePriceMax,
        ),
      )
      ->V.ap(V.shouldBeTrue(#ErrorIsOpen(``), true))

    switch (input, productCategoryId) {
    | (Ok(input'), ReactSelect.Selected(_)) =>
      mutate(
        ~variables={
          id: product.id,
          input: input',
        },
        ~onCompleted={
          (_, mutationError) => {
            // errors 필드가 응답에 포함되도 onError 콜백이 작동하지 않는 경우에 대한 우회책
            switch mutationError {
            | Some(errors) => {
                Js.Console.log(errors)
                switch errors->Array.get(0) {
                | Some(error) => {
                    addToast(.
                      <div className=%twc("flex items-center")>
                        <IconError height="24" width="24" className=%twc("mr-2") />
                        {error.message->React.string}
                      </div>,
                      {appearance: "error"},
                    )
                    setFormErrors(._ => [])
                  }
                | None => ()
                }
              }
            | None => {
                addToast(.
                  <div className=%twc("flex items-center")>
                    <IconCheck height="24" width="24" fill="#12B564" className=%twc("mr-2") />
                    {j`수정 요청에 성공하였습니다.`->React.string}
                  </div>,
                  {appearance: "success"},
                )
                close()
                setFormErrors(._ => [])
              }
            }
          }
        },
        ~onError={
          err => {
            Js.Console.log(err)
            addToast(.
              <div className=%twc("flex items-center")>
                <IconError height="24" width="24" className=%twc("mr-2") />
                {err.message->React.string}
              </div>,
              {appearance: "error"},
            )
            setFormErrors(._ => [])
          }
        },
        (),
      )->ignore
    | (Error(errors), ReactSelect.Selected(_)) => setFormErrors(._ => errors)
    | (_, ReactSelect.NotSelected) =>
      setFormErrors(._ => [#ErrorProductCategoryId(`품목 품종을 선택해주세요`)])
    }
  }

  let handleOnSelect = (~cleanUpFn=?, setFn, value) => {
    setFn(._ => value)
    switch cleanUpFn {
    | Some(f) => f()
    | None => ()
    }
  }

  let handleOnChange = (~cleanUpFn=?, setFn, e) => {
    let value = (e->ReactEvent.Synthetic.target)["value"]
    setFn(._ => value)
    switch cleanUpFn {
    | Some(f) => f()
    | None => ()
    }
  }

  let handleOnSelectPackageUnit = e => {
    let value = (e->ReactEvent.Synthetic.target)["value"]
    switch value->Input_Select_BulkSale_ProductQuantity.decodePackageUnit {
    | Ok(value') => setPreferredQuantityUnit(._ => value')
    | Error() => ()
    }
  }

  <Dialog.Root>
    <Dialog.Overlay className=%twc("dialog-overlay") />
    <Dialog.Trigger
      className=%twc("h-8 px-5 py-1 text-primary bg-primary-light rounded-lg focus:outline-none")>
      {j`수정하기`->React.string}
    </Dialog.Trigger>
    <Dialog.Content className=%twc("dialog-content overflow-y-auto")>
      <section className=%twc("p-5")>
        <article className=%twc("flex")>
          <h2 className=%twc("text-xl font-bold")> {j`상품 수정`->React.string} </h2>
          <Dialog.Close className=%twc("inline-block p-1 focus:outline-none ml-auto")>
            <IconClose height="24" width="24" fill="#262626" />
          </Dialog.Close>
        </article>
        <React.Suspense fallback={<div> {j`로딩 중..`->React.string} </div>}>
          <Select_BulkSale_Crop
            cropId
            onChange={handleOnSelect(setCropId, ~cleanUpFn=_ => {
              setProductCategoryId(._ => ReactSelect.NotSelected)
              setPreferredGrade(._ => None)
              setPreferredQuantityAmount(._ => None)
              setPreferredQuantityUnit(._ => #KG)
            })}
            error={formErrors
            ->Array.keepMap(error =>
              switch error {
              | #ErrorProductCategoryId(msg) => Some(msg)
              | _ => None
              }
            )
            ->Garter.Array.first}
          />
        </React.Suspense>
        <React.Suspense fallback={<div> {j`로딩 중..`->React.string} </div>}>
          <Select_BulkSale_ProductCategory
            key={switch cropId {
            | ReactSelect.NotSelected => ""
            | ReactSelect.Selected({value}) => value
            }}
            cropId
            productCategoryId
            onChange={handleOnSelect(setProductCategoryId, ~cleanUpFn=_ => {
              setPreferredGrade(._ => None)
              setPreferredQuantityAmount(._ => None)
              setPreferredQuantityUnit(._ => #KG)
            })}
            error={formErrors
            ->Array.keepMap(error =>
              switch error {
              | #ErrorProductCategoryId(msg) => Some(msg)
              | _ => None
              }
            )
            ->Garter.Array.first}
          />
        </React.Suspense>
        <React.Suspense fallback={<div> {j`로딩 중..`->React.string} </div>}>
          <Select_BulkSale_ProductGrade
            productCategoryId
            preferredGrade
            onChange={handleOnChange(setPreferredGrade)}
            error={formErrors
            ->Array.keepMap(error =>
              switch error {
              | #ErrorGrade(msg) => Some(msg)
              | _ => None
              }
            )
            ->Garter.Array.first}
          />
        </React.Suspense>
        <React.Suspense fallback={<div> {j`로딩 중..`->React.string} </div>}>
          <Input_Select_BulkSale_ProductQuantity
            quantityAmount=preferredQuantityAmount
            quantityUnit=preferredQuantityUnit
            onChangeAmount={handleOnChange(setPreferredQuantityAmount)}
            onChangeUnit={handleOnSelectPackageUnit}
            error={formErrors
            ->Array.keepMap(error =>
              switch error {
              | #ErrorAmount(msg) => Some(msg)
              | _ => None
              }
            )
            ->Garter.Array.first}
          />
        </React.Suspense>
        <article className=%twc("mt-5")>
          <h3> {j`예상 추가 수익 비율`->React.string} </h3>
          <div className=%twc("flex mt-2")>
            <Input
              type_="profit-ratio"
              name="profit-ratio"
              className=%twc("flex-1 mr-1")
              size=Input.Small
              placeholder="0"
              value=estimatedSellerEarningRate
              onChange={handleOnChange(setEstimatedSellerEarningRate)}
              textAlign=Input.Right
              error={formErrors
              ->Array.keepMap(error =>
                switch error {
                | #ErrorEarningRate(msg) => Some(msg)
                | _ => None
                }
              )
              ->Garter.Array.first}
            />
          </div>
        </article>
        <article className=%twc("mt-5")>
          <h3> {j`적정 구매 가격`->React.string} </h3>
          <div className=%twc("flex mt-2")>
            <Input
              type_="profit-ratio"
              name="profit-ratio"
              className=%twc("flex-1 mr-1")
              size=Input.Small
              placeholder="0"
              value=estimatedPurchasePriceMin
              onChange={handleOnChange(setEstimatedPurchasePriceMin)}
              textAlign=Input.Right
              error={formErrors
              ->Array.keepMap(error =>
                switch error {
                | #ErrorPriceMin(msg) => Some(msg)
                | _ => None
                }
              )
              ->Garter.Array.first}
            />
            <Input
              type_="profit-ratio"
              name="profit-ratio"
              className=%twc("flex-1 mr-1")
              size=Input.Small
              placeholder="0"
              value=estimatedPurchasePriceMax
              onChange={handleOnChange(setEstimatedPurchasePriceMax)}
              textAlign=Input.Right
              error={formErrors
              ->Array.keepMap(error =>
                switch error {
                | #ErrorPriceMax(msg) => Some(msg)
                | _ => None
                }
              )
              ->Garter.Array.first}
            />
          </div>
        </article>
        <article className=%twc("flex justify-center items-center mt-5")>
          <Dialog.Close className=%twc("flex mr-2")>
            <span id="btn-close" className=%twc("btn-level6 py-3 px-5")>
              {j`닫기`->React.string}
            </span>
          </Dialog.Close>
          <span className=%twc("flex mr-2")>
            <button
              className={isMutating
                ? %twc("btn-level1-disabled py-3 px-5")
                : %twc("btn-level1 py-3 px-5")}
              onClick={_ => handleOnSave()}
              disabled=isMutating>
              {j`저장`->React.string}
            </button>
          </span>
        </article>
      </section>
    </Dialog.Content>
  </Dialog.Root>
}
