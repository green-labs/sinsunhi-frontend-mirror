open RadixUI

module Mutation = %relay(`
  mutation BulkSaleProductCreateButtonMutation(
    $input: BulkSaleCampaignCreateInput!
    $connections: [ID!]!
  ) {
    createBulkSaleCampaign(input: $input) {
      result
        @prependNode(
          connections: $connections
          edgeTypeName: "BulkSaleCampaignEdge"
        ) {
        ...BulkSaleProductAdminFragment_bulkSaleCampaign
      }
    }
  }
`)

let makeInput = (
  productCategoryId,
  preferredGrade,
  preferredQuantityAmount,
  preferredQuantityUnit,
  estimatedSellerEarningRate,
  estimatedPurchasePriceMin,
  estimatedPurchasePriceMax,
  isOpen,
): BulkSaleProductCreateButtonMutation_graphql.Types.bulkSaleCampaignCreateInput => {
  productCategoryId: productCategoryId,
  preferredGrade: preferredGrade,
  preferredQuantity: {
    amount: preferredQuantityAmount,
    unit: preferredQuantityUnit,
  },
  estimatedSellerEarningRate: estimatedSellerEarningRate,
  estimatedPurchasePriceMin: estimatedPurchasePriceMin,
  estimatedPurchasePriceMax: estimatedPurchasePriceMax,
  isOpen: Some(isOpen),
  displayOrder: None,
}

@react.component
let make = (~connectionId, ~refetchSummary) => {
  let (mutate, isMutating) = Mutation.use()

  let (cropId, setCropId) = React.Uncurried.useState(_ => ReactSelect.NotSelected)
  let (productCategoryId, setProductCategoryId) = React.Uncurried.useState(_ =>
    ReactSelect.NotSelected
  )
  let (preferredGrade, setPreferredGrade) = React.Uncurried.useState(_ => None)
  let (preferredQuantityAmount, setPreferredQuantityAmount) = React.Uncurried.useState(_ => None)
  let (preferredQuantityUnit, setPreferredQuantityUnit) = React.Uncurried.useState(_ => #KG)
  let (estimatedSellerEarningRate, setEstimatedSellerEarningRate) = React.Uncurried.useState(_ =>
    ""
  )
  let (estimatedPurchasePriceMin, setEstimatedPurchasePriceMin) = React.Uncurried.useState(_ => "")
  let (estimatedPurchasePriceMax, setEstimatedPurchasePriceMax) = React.Uncurried.useState(_ => "")

  let (formErrors, setFormErrors) = React.Uncurried.useState(_ => [])

  let prefill = isOpen =>
    if isOpen {
      setCropId(._ => ReactSelect.NotSelected)
      setProductCategoryId(._ => ReactSelect.NotSelected)
      setPreferredGrade(._ => None)
      setPreferredQuantityAmount(._ => None)
      setEstimatedSellerEarningRate(._ => "")
      setEstimatedPurchasePriceMin(._ => "")
      setEstimatedPurchasePriceMax(._ => "")
    }

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
      ->V.map(
        V.Option.nonEmpty(
          #ErrorProductCategoryId(`?????? ????????? ??????????????????`),
          switch productCategoryId {
          | ReactSelect.NotSelected => None
          | ReactSelect.Selected({value}) => Some(value)
          },
        ),
      )
      ->V.ap(V.Option.nonEmpty(#ErrorGrade(`????????? ??????????????????`), preferredGrade))
      ->V.ap(V.Option.float(#ErrorAmount(`????????? ??????????????????`), preferredQuantityAmount))
      ->V.ap(V.pure(preferredQuantityUnit))
      ->V.ap(
        V.float(
          #ErrorEarningRate(`?????? ?????? ?????? ????????? ??????????????????`),
          estimatedSellerEarningRate,
        ),
      )
      ->V.ap(
        V.int(
          #ErrorPriceMin(`?????? ?????? ????????? ??????????????????`),
          estimatedPurchasePriceMin,
        ),
      )
      ->V.ap(
        V.int(
          #ErrorPriceMax(`?????? ?????? ????????? ??????????????????`),
          estimatedPurchasePriceMax,
        ),
      )
      ->V.ap(V.shouldBeTrue(#ErrorIsOpen(``), true))

    switch input {
    | Ok(input') =>
      mutate(
        ~variables={
          input: input',
          connections: [connectionId],
        },
        ~onCompleted={
          (_, _) => {
            refetchSummary()
            close()
          }
        },
        (),
      )->ignore
    | Error(errors) => setFormErrors(._ => errors)
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

  /*
   * ?????????????????? ????????? ????????? ????????? ??? ???????????? ?????? ?????????,
   * ????????? ????????? ?????? ?????? ????????? ???????????? ??????, prefill ??????
   */
  <Dialog.Root onOpenChange=prefill>
    <Dialog.Overlay className=%twc("dialog-overlay") />
    <Dialog.Trigger
      className=%twc(
        "h-8 px-3 py-1 text-[15px] text-white bg-primary rounded-lg focus:outline-none"
      )>
      {j`?????? ?????? ??????`->React.string}
    </Dialog.Trigger>
    <Dialog.Content className=%twc("dialog-content overflow-y-auto")>
      <section className=%twc("p-5")>
        <article className=%twc("flex")>
          <h2 className=%twc("text-xl font-bold")> {j`?????? ?????? ??????`->React.string} </h2>
          <Dialog.Close className=%twc("inline-block p-1 focus:outline-none ml-auto")>
            <IconClose height="24" width="24" fill="#262626" />
          </Dialog.Close>
        </article>
        <React.Suspense fallback={<div> {j`?????? ???..`->React.string} </div>}>
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
        <React.Suspense fallback={<div> {j`?????? ???..`->React.string} </div>}>
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
        <React.Suspense fallback={<div> {j`?????? ???..`->React.string} </div>}>
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
        <article className=%twc("mt-5")>
          <h3> {j`?????? ?????? ?????? ??????`->React.string} </h3>
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
          <h3> {j`?????? ?????? ??????`->React.string} </h3>
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
              {j`??????`->React.string}
            </span>
          </Dialog.Close>
          <span className=%twc("flex mr-2")>
            <button
              className={isMutating
                ? %twc("btn-level1-disabled py-3 px-5")
                : %twc("btn-level1 py-3 px-5")}
              onClick={_ => handleOnSave()}
              disabled=isMutating>
              {j`??????`->React.string}
            </button>
          </span>
        </article>
      </section>
    </Dialog.Content>
  </Dialog.Root>
}
