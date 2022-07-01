open RadixUI

module Mutation = %relay(`
  mutation BulkSaleProducerSampleReviewButtonCreateAdminMutation(
    $input: BulkSaleSampleReviewCreateInput!
  ) {
    createBulkSaleSampleReview(input: $input) {
      result {
        id
        brix
        marketabilityScore
        packageScore
        quantity {
          display
          amount
          unit
        }
        createdAt
        updatedAt
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
  s: BulkSaleProducerAdminFragment_bulkSaleApplication_graphql.Types.enum_ProductPackageMassUnit,
): [#G | #KG | #MG] =>
  switch s {
  | #KG => #KG
  | #G => #G
  | #MG => #MG
  | _ => #KG
  }

let decodeScore = s =>
  if s == "very-bad" {
    Ok(#VERY_BAD)
  } else if s == "bad" {
    Ok(#BAD)
  } else if s == "good" {
    Ok(#GOOD)
  } else if s == "very-good" {
    Ok(#VERY_GOOD)
  } else {
    Error()
  }
let stringifyScore = s =>
  switch s {
  | #VERY_BAD => "very-bad"
  | #BAD => "bad"
  | #GOOD => "good"
  | #VERY_GOOD => "very-good"
  | _ => ""
  }
let displayScore = s =>
  switch s {
  | #VERY_BAD => `매우불량`
  | #BAD => `불량`
  | #GOOD => `양호`
  | #VERY_GOOD => `매우양호`
  | _ => ""
  }
// FIXME
// 응답 받은 enum 타입과 muation으로 전달해야하는 타입이 다르다. 왜??
let convertScore = (
  s: BulkSaleProducerSampleReviewButtonAdminFragment_graphql.Types.enum_ReviewScore,
): [#VERY_BAD | #BAD | #GOOD | #VERY_GOOD] =>
  switch s {
  | #VERY_BAD => #VERY_BAD
  | #BAD => #BAD
  | #GOOD => #GOOD
  | #VERY_GOOD => #VERY_GOOD
  | _ => #VERY_BAD
  }

let makeInput = (
  applicationId,
  amount,
  unit,
  brix,
  packageScore,
  marketabilityScore,
): BulkSaleProducerSampleReviewButtonCreateAdminMutation_graphql.Types.bulkSaleSampleReviewCreateInput => {
  {
    bulkSaleApplicationId: applicationId,
    quantity: {amount: amount, unit: unit},
    brix: brix,
    packageScore: packageScore,
    marketabilityScore: marketabilityScore,
  }
}

@react.component
let make = (~applicationId, ~refetchSampleReviews) => {
  let {addToast} = ReactToastNotifications.useToasts()

  let (mutate, isMutating) = Mutation.use()

  let (quantityAmount, setQuantityAmount) = React.Uncurried.useState(_ => None)
  let (quantityUnit, setQuantityUnit) = React.Uncurried.useState(_ => #KG)
  let (brix, setBrix) = React.Uncurried.useState(_ => None)
  let (packageScore, setPackageScore) = React.Uncurried.useState(_ => #VERY_GOOD)
  let (marketabilityScore, setMarketabilityScore) = React.Uncurried.useState(_ => #VERY_GOOD)

  let (formErrors, setFormErrors) = React.Uncurried.useState(_ => [])

  let close = () => {
    open Webapi
    let buttonClose = Dom.document->Dom.Document.getElementById("btn-close")
    buttonClose
    ->Option.flatMap(buttonClose' => {
      buttonClose' |> Dom.Element.asHtmlElement
    })
    ->Option.forEach(buttonClose' => {
      buttonClose' |> Dom.HtmlElement.click
    })
    ->ignore
  }

  let handleOnSave = _ => {
    let input =
      makeInput
      ->V.map(V.nonEmpty(#ErrorApplicationId(`ApplicationId가 필요 합니다.`), applicationId))
      ->V.ap(
        V.Option.float(
          #ErrorQuantityAmount(`단위가 입력되어야 합니다.`),
          quantityAmount,
        ),
      )
      ->V.ap(V.pure(quantityUnit))
      ->V.ap(V.pure(brix))
      ->V.ap(V.pure(Some(packageScore)))
      ->V.ap(V.pure(Some(marketabilityScore)))
    switch input {
    | Ok(input') =>
      mutate(
        ~variables={
          input: input',
        },
        ~onCompleted={
          (_, _) => {
            addToast(.
              <div className=%twc("flex items-center")>
                <IconCheck height="24" width="24" fill="#12B564" className=%twc("mr-2") />
                {j`수정 요청에 성공하였습니다.`->React.string}
              </div>,
              {appearance: "success"},
            )
            close()
            refetchSampleReviews()
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
          }
        },
        (),
      )->ignore
    | Error(errors) => setFormErrors(._ => errors)
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

  let handleOnSelect = (~setFn, ~decodeFn, e) => {
    let value = (e->ReactEvent.Synthetic.target)["value"]
    switch value->decodeFn {
    | Ok(value') => setFn(._ => value')
    | Error() => ()
    }
  }

  <Dialog.Content className=%twc("dialog-content-detail overflow-y-auto")>
    <section className=%twc("p-5")>
      <article className=%twc("flex")>
        <h2 className=%twc("text-xl font-bold")> {j`상품 평가`->React.string} </h2>
        <Dialog.Close className=%twc("inline-block p-1 focus:outline-none ml-auto")>
          <IconClose height="24" width="24" fill="#262626" />
        </Dialog.Close>
      </article>
    </section>
    <section className=%twc("p-5")>
      <article className=%twc("bg-red-50 rounded-lg p-4 text-emphasis")>
        {j`샘플 수령 및 품평회 이후 입력 부탁드립니다. (빈칸 제출 가능)`->React.string}
      </article>
    </section>
    <section className=%twc("p-5 grid grid-cols-2 gap-x-4")>
      <article className=%twc("mt-5")>
        <h3> {`단위`->React.string} </h3>
        <Input_Select_BulkSale_ProductQuantity
          quantityAmount
          quantityUnit
          onChangeAmount={handleOnChange(setQuantityAmount)}
          onChangeUnit={handleOnSelect(
            ~setFn=setQuantityUnit,
            ~decodeFn=Input_Select_BulkSale_ProductQuantity.decodePackageUnit,
          )}
          error={formErrors
          ->Array.keepMap(error =>
            switch error {
            | #ErrorQuantityAmount(msg) => Some(msg)
            | _ => None
            }
          )
          ->Garter.Array.first}
        />
      </article>
      <article className=%twc("mt-5")>
        <h3> {j`브릭스(Brix)`->React.string} </h3>
        <div className=%twc("flex mt-2")>
          <Input
            type_="brix"
            name="brix"
            className=%twc("flex-1 mr-1")
            size=Input.Small
            placeholder="0"
            value={brix->Option.getWithDefault("")}
            onChange={handleOnChange(setBrix)}
            error=None
            textAlign=Input.Right
          />
        </div>
      </article>
      <article className=%twc("mt-5")>
        <h3> {j`포장상태`->React.string} </h3>
        <label className=%twc("block relative mt-2")>
          <span
            className=%twc(
              "flex items-center border border-border-default-L1 rounded-lg h-9 px-3 text-enabled-L1"
            )>
            {packageScore->displayScore->React.string}
          </span>
          <span className=%twc("absolute top-1.5 right-2")>
            <IconArrowSelect height="24" width="24" fill="#121212" />
          </span>
          <select
            value={packageScore->stringifyScore}
            className=%twc("block w-full h-full absolute top-0 opacity-0")
            onChange={handleOnSelect(~setFn=setPackageScore, ~decodeFn=decodeScore)}>
            {[#VERY_GOOD, #GOOD, #BAD, #VERY_BAD]
            ->Array.map(unit =>
              <option key={unit->stringifyScore} value={unit->stringifyScore}>
                {unit->displayScore->React.string}
              </option>
            )
            ->React.array}
          </select>
        </label>
      </article>
      <article className=%twc("mt-5")>
        <h3> {j`상품성`->React.string} </h3>
        <label className=%twc("block relative mt-2")>
          <span
            className=%twc(
              "flex items-center border border-border-default-L1 rounded-lg h-9 px-3 text-enabled-L1"
            )>
            {marketabilityScore->displayScore->React.string}
          </span>
          <span className=%twc("absolute top-1.5 right-2")>
            <IconArrowSelect height="24" width="24" fill="#121212" />
          </span>
          <select
            value={marketabilityScore->stringifyScore}
            className=%twc("block w-full h-full absolute top-0 opacity-0")
            onChange={handleOnSelect(~setFn=setMarketabilityScore, ~decodeFn=decodeScore)}>
            {[#VERY_GOOD, #GOOD, #BAD, #VERY_BAD]
            ->Array.map(unit =>
              <option key={unit->stringifyScore} value={unit->stringifyScore}>
                {unit->displayScore->React.string}
              </option>
            )
            ->React.array}
          </select>
        </label>
      </article>
    </section>
    <section className=%twc("p-5")>
      <article className=%twc("flex justify-center items-center")>
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
}
