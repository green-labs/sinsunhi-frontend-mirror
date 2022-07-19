module Query = {
  module TradematchDeliveryPolicy = %relay(`
       query TradematchAskToBuyApplyStepsBuyer_TradematchDeliveryPolicy_Query {
         tradematchDeliveryPolicy {
           acceptableDeliveryDate
         }
       }
  `)

  module TradematchTerms = RfqShipping_Buyer.Query.RfqTerms
}

module Mutation = {
  module CreateTradematchDemand = %relay(`
    mutation TradematchAskToBuyApplyStepsBuyer_CreateTradematchDemand_Mutation(
      $connections: [ID!]!
      $input: TradematchDemandCreateInput!
    ) {
      createTradematchDemand(input: $input) {
        ... on Error {
          message
          code
        }
        ... on TradematchDemandMutationPayload {
          result
            @prependNode(
              connections: $connections
              edgeTypeName: "tradematchDemandEdge"
            ) {
            canceledAt
            deliveryAddress
            deliveryAddress1
            deliveryAddress2
            deliveryDate
            deliveryRegion
            deliveryZipCode
            draftedAt
            id
            numberOfPackagesPerTrade
            packageQuantityUnit
            priceGroup
            pricePerTrade
            productCategoryCode
            productId
            productProcess
            productRequirements
            productSize
            quantityPerPackage
            quantityPerTrade
            requestedAt
            status
            tradeCycle
            wantedPricePerPackage
          }
        }
      }
    }`)

  module PartialUpdateTradematchDemand = %relay(`
    mutation TradematchAskToBuyApplyStepsBuyer_PartialUpdateTradematchDemand_Mutation(
      $id: ID!
      $input: TradematchDemandPartialUpdateInput!
    ) {
      partialUpdateTradematchDemand(id: $id, input: $input) {
        ... on Error {
          message
          code
        }
        ... on TradematchDemandMutationPayload {
          result {
            canceledAt
            deliveryAddress
            deliveryAddress1
            deliveryAddress2
            deliveryDate
            deliveryRegion
            deliveryZipCode
            draftedAt
            id
            numberOfPackagesPerTrade
            packageQuantityUnit
            priceGroup
            pricePerTrade
            productCategoryCode
            productId
            productProcess
            productRequirements
            productSize
            quantityPerPackage
            quantityPerTrade
            requestedAt
            status
            tradeCycle
            wantedPricePerPackage
          }
        }
      }
    }
  `)

  module UpdateTermAgreement = RfqShipping_Buyer.Mutation.UpdateTermAgreement
}

let convertNumberInputValue = value =>
  value->Js.String2.replaceByRe(%re("/[^0-9]/g"), "")->Js.String2.replaceByRe(%re("/^[0]/g"), "")

let stringToNumber = s =>
  s
  ->Js.String2.split(".")
  ->Garter_Array.firstExn
  ->Float.fromString
  ->Option.mapWithDefault(``, x => x->Locale.Float.show(~digits=0))

let getUpdateMutateVariables = (
  ~id,
  ~deliveryAddress1=None,
  ~deliveryAddress2=None,
  ~deliveryDate=None,
  ~deliveryRegion=None,
  ~deliveryZipCode=None,
  ~numberOfPackagesPerTrade=None,
  ~packageQuantityUnit=None,
  ~priceGroup=None,
  ~productCategoryCode=None,
  ~productId=None,
  ~productProcess=None,
  ~productRequirements=None,
  ~productSize=None,
  ~quantityPerPackage=None,
  ~status=None,
  ~tradeCycle=None,
  ~wantedPricePerPackage=None,
  (),
) => {
  Mutation.PartialUpdateTradematchDemand.makeVariables(
    ~id,
    ~input={
      deliveryAddress1,
      deliveryAddress2,
      deliveryDate,
      deliveryRegion,
      deliveryZipCode,
      numberOfPackagesPerTrade,
      packageQuantityUnit,
      priceGroup,
      productCategoryCode,
      productId,
      productProcess,
      productRequirements,
      productSize,
      quantityPerPackage,
      status,
      tradeCycle,
      wantedPricePerPackage,
    },
  )
}

module Common = {
  module Layout = {
    @react.component
    let make = (~children) => {
      <div className=%twc("relative container max-w-3xl mx-auto min-h-screen")> children </div>
    }
  }

  module Title = {
    @react.component
    let make = (~text, ~subText=?, ~label=?) => {
      <div className=%twc("px-5 py-9")>
        {label->Option.mapWithDefault(React.null, x => x)}
        <h2 className=%twc("text-2xl font-bold whitespace-pre-line")> {text->React.string} </h2>
        {switch subText {
        | Some(subText') =>
          <h3 className=%twc("text-gray-600 whitespace-pre-line text-sm mt-3")>
            {subText'->React.string}
          </h3>
        | None => React.null
        }}
      </div>
    }
  }

  module FloatingButton = {
    @react.component
    let make = (~handleClickButton, ~disabled=false) => {
      let {isLast} = CustomHooks.Tradematch.usePageSteps()
      let buttonText = isLast ? `견적 신청 완료` : `다음`
      <>
        <div className=%twc("fixed bottom-0 max-w-3xl w-full gradient-cta-t tab-highlight-color")>
          <div className=%twc("w-full max-w-[768px] px-4 py-5 mx-auto")>
            <button
              disabled
              onClick={handleClickButton}
              className={cx([
                %twc("h-14 w-full rounded-xl bg-primary text-white text-lg font-bold"),
                %twc("disabled:bg-disabled-L2 disabled:text-inverted disabled:text-opacity-50"),
              ])}>
              {buttonText->React.string}
            </button>
          </div>
        </div>
        <div className=%twc("h-24") />
      </>
    }
  }
}

module CalendarListitem = {
  @react.component
  let make = (~leftText, ~currentDate, ~handleChangeDate, ~minDate, ~maxDate) => {
    let checkWeekend = (e: Js.Date.t) => {
      e->Js.Date.getDay === 0. || e->Js.Date.getDay === 6.
    }

    <li
      className=%twc(
        "flex items-center min-h-[56px] mx-5 cursor-pointer border-b-2 border-b-border-disabled"
      )>
      <div className=%twc("flex flex-col justify-between truncate")>
        <span className=%twc("block text-base truncate")> {leftText->React.string} </span>
      </div>
      <div className=%twc("ml-auto pl-2")>
        <DatePicker
          id="date"
          date=?{currentDate}
          onFocus={_ => {
            open Webapi
            Dom.document
            ->Dom.Document.getElementById("date")
            ->Option.flatMap(inputEl' => inputEl'->Dom.Element.asHtmlElement)
            ->Option.forEach(inputEl' => inputEl'->Dom.HtmlElement.blur)
          }}
          onChange={e => {
            let newDate = (e->DuetDatePicker.DuetOnChangeEvent.detail).valueAsDate
            handleChangeDate(._ => newDate)
          }}
          isDateDisabled={e => {
            checkWeekend(e)
          }}
          minDate={minDate->DateFns.format("yyyy-MM-dd")}
          maxDate={maxDate->DateFns.format("yyyy-MM-dd")}
          firstDayOfWeek=0
        />
      </div>
    </li>
  }
}

module SearchAddress = {
  @react.component
  let make = (~onComplete, ~isShow) => {
    React.useLayoutEffect1(_ => {
      if isShow {
        open DaumPostCode
        open Webapi
        let iframeWrapper = Dom.document->Dom.Document.getElementById("iframe-embed-addr")
        let drawerHeaderHeight = 56

        switch iframeWrapper {
        | Some(iframeWrapper') => {
            let (w, h) = (
              iframeWrapper'->Dom.Element.clientWidth,
              Dom.window->Dom.Window.innerHeight - drawerHeaderHeight,
            )
            let option = makeOption(
              ~oncomplete=onComplete,
              ~width=w->Float.fromInt,
              ~height=h->Float.fromInt,
              (),
            )
            let daumPostCode = option->make
            let openOption = makeEmbedOption(~q="", ~autoClose=true)
            daumPostCode->embedPostCode(iframeWrapper', openOption)
            iframeWrapper'->Dom.Element.setAttribute("style", "display: block;")
          }

        | _ => ()
        }
      }
      None
    }, [isShow])

    <div id="iframe-embed-addr" />
  }
}

module AddressDrawer = {
  @react.component
  let make = (~onComplete, ~closeDrawer, ~isShow) => {
    <DS_BottomDrawer.Root full=true isShow onClose={_ => closeDrawer()}>
      <DS_BottomDrawer.Header />
      <DS_BottomDrawer.Body>
        <RescriptReactErrorBoundary
          fallback={_ =>
            <div className=%twc("flex items-center justify-center")>
              <contents className=%twc("flex flex-col items-center justify-center")>
                <IconNotFound width="160" height="160" />
                <h1 className=%twc("mt-7 text-2xl text-gray-800 font-bold")>
                  {`처리중 오류가 발생하였습니다.`->React.string}
                </h1>
                <span className=%twc("mt-4 text-gray-800")>
                  {`페이지를 불러오는 중에 문제가 발생하였습니다.`->React.string}
                </span>
                <span className=%twc("text-gray-800")>
                  {`잠시 후 재시도해 주세요.`->React.string}
                </span>
              </contents>
            </div>}>
          <SearchAddress onComplete isShow />
        </RescriptReactErrorBoundary>
      </DS_BottomDrawer.Body>
    </DS_BottomDrawer.Root>
  }
}

module Grade = {
  @react.component
  let make = (
    ~pid: string,
    ~currentDemand: option<
      TradematchAskToBuyApplyBuyer_TradematchDemands_Fragment_graphql.Types.fragment_tradematchDemands_edges_node,
    >,
    ~product: TradematchAskToBuyApplyBuyer_MatchingProduct_Query_graphql.Types.response_node,
    ~connectionId,
  ) => {
    let router = Next.Router.useRouter()
    let {navigateToNextStep} = CustomHooks.Tradematch.useNavigateStep()
    let {addToast} = ReactToastNotifications.useToasts()
    let (createMutate, isCreateMutating) = Mutation.CreateTradematchDemand.use()
    let (updateMutate, isUpdateMutating) = Mutation.PartialUpdateTradematchDemand.use()
    let {
      representativeWeight,
      recentMarketPrice,
      qualityStandard: {highQualityStandard, mediumQualityStandard, lowQualityStandard},
      category: {productCategoryCodeId},
    } = product

    let defaultSelectedGrade = switch (currentDemand, router.query->Js.Dict.get("grade")) {
    | (Some(currdntDemand'), _) => currdntDemand'.priceGroup
    | (None, Some(pdpSelectedGrade)) =>
      switch pdpSelectedGrade {
      | "high" => Some("HIGH")
      | "medium" => Some("MEDIUM")
      | "low" => Some("LOW")
      | _ => None
      }
    | _ => None
    }

    let (selectedGrade, setSelectedGrade) = React.Uncurried.useState(_ => defaultSelectedGrade)
    let isSelected = selectedGrade->Option.isSome

    let trackData = () => {
      let (higher, mean, lower) = switch (selectedGrade, recentMarketPrice) {
      | (Some(`HIGH`), Some(recentMarketPrice')) => {
          let {higher, lower, mean} = recentMarketPrice'.highRecentMarketPrice
          (higher, mean, lower)
        }

      | (Some(`MEDIUM`), Some(recentMarketPrice')) => {
          let {higher, lower, mean} = recentMarketPrice'.mediumRecentMarketPrice
          (higher, mean, lower)
        }

      | (Some(`LOW`), Some(recentMarketPrice')) => {
          let {higher, lower, mean} = recentMarketPrice'.lowRecentMarketPrice
          (higher, mean, lower)
        }

      | _ => (None, None, None)
      }

      DataGtm.push({
        "event": "click_intention_grade",
        "product_id": pid,
        "category_id": productCategoryCodeId,
        "grade_avg_price": mean,
        "grade_min_price": lower,
        "grade_max_price": higher,
      })
    }

    let handleClickButton = _ => {
      trackData()

      switch currentDemand {
      | Some(currentDemand') =>
        updateMutate(
          ~variables={
            getUpdateMutateVariables(
              ~id=currentDemand'.id,
              ~productId=Some(pid),
              ~priceGroup=selectedGrade,
              ~productCategoryCode=productCategoryCodeId,
            )()
          },
          ~onCompleted=({partialUpdateTradematchDemand}, _) => {
            switch partialUpdateTradematchDemand {
            | #TradematchDemandMutationPayload(_) => navigateToNextStep()
            | #Error(_)
            | #UnselectedUnionMember(_) =>
              addToast(.
                `요청 중 요류가 발생했습니다. 잠시 후 다시 시도해주세요.`->DS_Toast.getToastComponent(
                  #error,
                ),
                {appearance: "error"},
              )
            }
            ()
          },
          ~onError={
            err =>
              addToast(.
                `요청 중 요류가 발생했습니다. 잠시 후 다시 시도해주세요.`->DS_Toast.getToastComponent(
                  #error,
                ),
                {appearance: "error"},
              )
          },
          (),
        )->ignore
      | None =>
        createMutate(
          ~variables={
            connections: [connectionId],
            input: {
              productId: Some(pid),
              priceGroup: selectedGrade,
              productCategoryCode: productCategoryCodeId,
              deliveryAddress1: None,
              deliveryAddress2: None,
              deliveryDate: None,
              deliveryRegion: None,
              deliveryZipCode: None,
              numberOfPackagesPerTrade: None,
              packageQuantityUnit: None,
              productProcess: None,
              productRequirements: None,
              productSize: None,
              quantityPerPackage: None,
              tradeCycle: None,
              wantedPricePerPackage: None,
            },
          },
          ~onCompleted=({createTradematchDemand}, _) => {
            switch createTradematchDemand {
            | #TradematchDemandMutationPayload(_) => navigateToNextStep()
            | #Error(_)
            | #UnselectedUnionMember(_) =>
              addToast(.
                `요청 중 요류가 발생했습니다. 잠시 후 다시 시도해주세요.`->DS_Toast.getToastComponent(
                  #error,
                ),
                {appearance: "error"},
              )
            }
            ()
          },
          ~onError={
            err =>
              addToast(.
                `요청 중 요류가 발생했습니다. 잠시 후 다시 시도해주세요.`->DS_Toast.getToastComponent(
                  #error,
                ),
                {appearance: "error"},
              )
          },
          (),
        )->ignore
      }
    }

    <div>
      <Common.Title text={`찾으시는 상품의\n가격 그룹을 선택해주세요`} />
      <form>
        <RadixUI.RadioGroup.Root
          name="tradematch-grade"
          className=%twc("flex flex-col gap-8")
          value={selectedGrade->Option.mapWithDefault("", x => x)}
          onValueChange={v => setSelectedGrade(._ => Some(v))}>
          {switch recentMarketPrice {
          | Some(recentMarketPrice') =>
            <>
              {
                let {mean} = recentMarketPrice'.highRecentMarketPrice
                let {description} = highQualityStandard

                <li className=%twc("w-full items-center list-none")>
                  <label className=%twc("flex w-full justify-between cursor-pointer px-5")>
                    <div>
                      <div className=%twc("text-lg font-bold text-text-L1")>
                        {`상위 가격 그룹`->React.string}
                      </div>
                      <div className=%twc("text-sm text-gray-600")>
                        {description->React.string}
                      </div>
                      {switch mean {
                      | Some(mean') =>
                        <div className=%twc("text-sm text-primary")>
                          {`평균 ${(mean'->Int.toFloat *. representativeWeight)
                            ->Float.toString
                            ->stringToNumber}원(${representativeWeight->Float.toString}kg당)`->React.string}
                        </div>
                      | _ => React.null
                      }}
                    </div>
                    <div className=%twc("flex items-center")>
                      <RadixUI.RadioGroup.Item
                        id={`HIGH`}
                        value={`HIGH`}
                        className={cx([
                          %twc(
                            "relative flex items-center justify-center ml-[25px] min-w-[22px] min-h-[22px] max-w-[22px] max-h-[22px] border-[1.5px] rounded-full border-enabled-L4 "
                          ),
                          %twc(
                            "after:content-[''] after:w-[7px] after:h-[7px] after:bg-enabled-L4 after:bg-opacity-30 after:rounded-full after:absolute "
                          ),
                        ])}>
                        <RadixUI.RadioGroup.Indicator
                          className={cx([
                            %twc("relative flex items-center justify-center h-full w-full "),
                            %twc(
                              "after:block after:content-[''] after:rounded-full after:border-green-500 after:border-[7px] after:bg-transparent after:min-w-[22px] after:h-[22px]"
                            ),
                          ])}
                        />
                      </RadixUI.RadioGroup.Item>
                    </div>
                  </label>
                </li>
              }
              {
                let {mean} = recentMarketPrice'.mediumRecentMarketPrice
                let {description} = mediumQualityStandard

                <li className=%twc("w-full items-center list-none")>
                  <label className=%twc("flex w-full justify-between cursor-pointer px-5")>
                    <div>
                      <div className=%twc("text-lg font-bold text-text-L1")>
                        {`중위 가격 그룹`->React.string}
                      </div>
                      <div className=%twc("text-sm text-gray-600")>
                        {description->React.string}
                      </div>
                      {switch mean {
                      | Some(mean') =>
                        <div className=%twc("text-sm text-primary")>
                          {`평균 ${(mean'->Int.toFloat *. representativeWeight)
                            ->Float.toString
                            ->stringToNumber}원(${representativeWeight->Float.toString}kg당)`->React.string}
                        </div>
                      | _ => React.null
                      }}
                    </div>
                    <div className=%twc("flex items-center")>
                      <RadixUI.RadioGroup.Item
                        id={`MEDIUM`}
                        value={`MEDIUM`}
                        className={cx([
                          %twc(
                            "relative flex items-center justify-center ml-[25px] min-w-[22px] min-h-[22px] max-w-[22px] max-h-[22px] border-[1.5px] rounded-full border-enabled-L4 "
                          ),
                          %twc(
                            "after:content-[''] after:w-[7px] after:h-[7px] after:bg-enabled-L4 after:bg-opacity-30 after:rounded-full after:absolute "
                          ),
                        ])}>
                        <RadixUI.RadioGroup.Indicator
                          className={cx([
                            %twc("relative flex items-center justify-center h-full w-full "),
                            %twc(
                              "after:block after:content-[''] after:rounded-full after:border-green-500 after:border-[7px] after:bg-transparent after:min-w-[22px] after:h-[22px]"
                            ),
                          ])}
                        />
                      </RadixUI.RadioGroup.Item>
                    </div>
                  </label>
                </li>
              }
              {
                let {mean} = recentMarketPrice'.lowRecentMarketPrice
                let {description} = lowQualityStandard

                <li className=%twc("w-full items-center list-none")>
                  <label className=%twc("flex w-full justify-between cursor-pointer px-5")>
                    <div>
                      <div className=%twc("text-lg font-bold text-text-L1")>
                        {`하위 가격 그룹`->React.string}
                      </div>
                      <div className=%twc("text-sm text-gray-600")>
                        {description->React.string}
                      </div>
                      {switch mean {
                      | Some(mean') =>
                        <div className=%twc("text-sm text-primary")>
                          {`평균 ${(mean'->Int.toFloat *. representativeWeight)
                            ->Float.toString
                            ->stringToNumber}원(${representativeWeight->Float.toString}kg당)`->React.string}
                        </div>
                      | _ => React.null
                      }}
                    </div>
                    <div className=%twc("flex items-center")>
                      <RadixUI.RadioGroup.Item
                        id={`LOW`}
                        value={`LOW`}
                        className={cx([
                          %twc(
                            "relative flex items-center justify-center ml-[25px] min-w-[22px] min-h-[22px] max-w-[22px] max-h-[22px] border-[1.5px] rounded-full border-enabled-L4 "
                          ),
                          %twc(
                            "after:content-[''] after:w-[7px] after:h-[7px] after:bg-enabled-L4 after:bg-opacity-30 after:rounded-full after:absolute "
                          ),
                        ])}>
                        <RadixUI.RadioGroup.Indicator
                          className={cx([
                            %twc("relative flex items-center justify-center h-full w-full "),
                            %twc(
                              "after:block after:content-[''] after:rounded-full after:border-green-500 after:border-[7px] after:bg-transparent after:min-w-[22px] after:h-[22px]"
                            ),
                          ])}
                        />
                      </RadixUI.RadioGroup.Item>
                    </div>
                  </label>
                </li>
              }
            </>
          | None => React.null
          }}
        </RadixUI.RadioGroup.Root>
      </form>
      <Common.FloatingButton
        handleClickButton={handleClickButton}
        disabled={isCreateMutating || isUpdateMutating || !isSelected}
      />
    </div>
  }
}

module Count = {
  @react.component
  let make = (
    ~product: TradematchAskToBuyApplyBuyer_MatchingProduct_Query_graphql.Types.response_node,
    ~currentDemand: option<
      TradematchAskToBuyApplyBuyer_TradematchDemands_Fragment_graphql.Types.fragment_tradematchDemands_edges_node,
    >,
  ) => {
    let {navigateToNextStep} = CustomHooks.Tradematch.useNavigateStep()
    let {addToast} = ReactToastNotifications.useToasts()
    let productWeight = product.representativeWeight

    let (count, setcount) = React.Uncurried.useState(_ =>
      currentDemand
      ->Option.flatMap(x => x.numberOfPackagesPerTrade)
      ->Option.mapWithDefault(1, x => x)
    )

    let increaseCount = () => setcount(.prev => prev + 1)
    let decreaseCount = () => {
      setcount(.prev => {
        switch prev === 1 {
        | true => prev
        | false => prev - 1
        }
      })
    }

    let (updateMutate, isUpdateMutating) = Mutation.PartialUpdateTradematchDemand.use()

    let trackData = () => {
      let demandId = switch currentDemand {
      | Some(currentDemand') => currentDemand'.id
      | None => ""
      }

      DataGtm.push({
        "event": "click_intention_quantity",
        "tradematch_demand_id": demandId,
        "quantity_per_trade": count,
      })
    }

    let handleClickButton = _ => {
      trackData()
      switch currentDemand {
      | Some(currentDemand') =>
        updateMutate(
          ~variables={
            getUpdateMutateVariables(
              ~id=currentDemand'.id,
              ~numberOfPackagesPerTrade=Some(count),
              ~packageQuantityUnit=Some(#KG), // Todo - 카테고리 별 단위가 다른지 상품팀 확인 필요
              ~quantityPerPackage=Some(product.representativeWeight),
            )()
          },
          ~onCompleted=({partialUpdateTradematchDemand}, _) => {
            switch partialUpdateTradematchDemand {
            | #TradematchDemandMutationPayload(_) => navigateToNextStep()
            | #Error(_)
            | #UnselectedUnionMember(_) =>
              addToast(.
                `요청 중 요류가 발생했습니다. 잠시 후 다시 시도해주세요.`->DS_Toast.getToastComponent(
                  #error,
                ),
                {appearance: "error"},
              )
            }
            ()
          },
          ~onError={
            err =>
              addToast(.
                `요청 중 요류가 발생했습니다. 잠시 후 다시 시도해주세요.`->DS_Toast.getToastComponent(
                  #error,
                ),
                {appearance: "error"},
              )
          },
          (),
        )->ignore
      | None => ()
      }
    }

    <div>
      <Common.Title text={`납품 1회당 구매량을\n작성해주세요`} />
      <div className=%twc("mx-5")>
        <div
          className=%twc(
            "flex justify-between items-center border-border-default-L2 px-4 h-[88px] border-[1px] border-solid rounded-lg mb-3"
          )>
          <div className=%twc("font-bold")>
            <span className=%twc("break-all")> {productWeight->Float.toString->React.string} </span>
            <span className=%twc("word-keep-all")> {`Kg`->React.string} </span>
          </div>
          <div className=%twc("flex justify-between items-center")>
            <button
              onClick={_ => decreaseCount()}
              className=%twc(
                "w-10 h-10 rounded-full bg-div-shape-L2 font-bold text-lg select-none"
              )>
              {`-`->React.string}
            </button>
            <div className=%twc("mx-3 text-center w-[60px]")>
              <span className=%twc("break-all")> {count->Int.toString->React.string} </span>
              <span
                className=%twc("word-keep-all
              ")>
                {` 박스`->React.string}
              </span>
              <span />
            </div>
            <button
              onClick={_ => increaseCount()}
              className=%twc(
                "w-10 h-10 rounded-full bg-div-shape-L2 font-bold text-lg select-none"
              )>
              {`+`->React.string}
            </button>
          </div>
        </div>
        <div>
          <span className=%twc("text-gray-500 text-sm")>
            {`총 ${(productWeight *. count->Int.toFloat)->Float.toString}kg`->React.string}
          </span>
        </div>
      </div>
      <Common.FloatingButton handleClickButton={handleClickButton} disabled={isUpdateMutating} />
    </div>
  }
}

module Price = {
  @react.component
  let make = (
    ~product: TradematchAskToBuyApplyBuyer_MatchingProduct_Query_graphql.Types.response_node,
    ~currentDemand: option<
      TradematchAskToBuyApplyBuyer_TradematchDemands_Fragment_graphql.Types.fragment_tradematchDemands_edges_node,
    >,
  ) => {
    let {navigateToNextStep} = CustomHooks.Tradematch.useNavigateStep()
    let {addToast} = ReactToastNotifications.useToasts()

    let currentDemandPriceGroup = switch currentDemand {
    | Some(currentDemand') => currentDemand'.priceGroup
    | None => None
    }->Option.mapWithDefault("", x => x)

    let {representativeWeight, recentMarketPrice} = product

    let titleText = switch currentDemandPriceGroup {
    | `HIGH` =>
      `상위 가격 그룹, ${representativeWeight->Float.toString}kg당\n구매 희망가를 적어주세요`
    | `MEDIUM` =>
      `중위 가격 그룹, ${representativeWeight->Float.toString}kg당\n구매 희망가를 적어주세요`
    | `LOW` =>
      `하위 가격 그룹, ${representativeWeight->Float.toString}kg당\n구매 희망가를 적어주세요`
    | _ => `구매 희망가를 적어주세요`
    }

    let numberOfPackagesPerTrade = currentDemand->Option.flatMap(x => x.numberOfPackagesPerTrade)
    let totalWeightText = switch numberOfPackagesPerTrade {
    | Some(numberOfPackagesPerTrade') => {
        let totalWeight =
          (representativeWeight *. numberOfPackagesPerTrade'->Int.toFloat)
            ->Locale.Float.show(~digits=0)
        `총 ${totalWeight}kg`
      }

    | _ => `정보 없음`
    }

    let currentRecentMarketPrice = switch (currentDemandPriceGroup, recentMarketPrice) {
    | (`HIGH`, Some(recentMarketPrice')) => {
        let {higher, lower, mean} = recentMarketPrice'.highRecentMarketPrice
        (higher, mean, lower)
      }

    | (`MEDIUM`, Some(recentMarketPrice')) => {
        let {higher, lower, mean} = recentMarketPrice'.mediumRecentMarketPrice
        (higher, mean, lower)
      }

    | (`LOW`, Some(recentMarketPrice')) => {
        let {higher, lower, mean} = recentMarketPrice'.lowRecentMarketPrice
        (higher, mean, lower)
      }

    | _ => (None, None, None)
    }

    let getPackagePriceText = (n: int) =>
      (n->Int.toFloat *. representativeWeight)->Float.toInt->Int.toString->stringToNumber

    let averagePriceText = switch currentRecentMarketPrice {
    | (Some(higher'), Some(mean'), Some(lower')) =>
      `평균 ${mean'->getPackagePriceText}원(최저${lower'->getPackagePriceText}원~최고${higher'->getPackagePriceText}원)`
    | _ => ``
    }

    let estimatedTotalPrice = switch currentRecentMarketPrice {
    | (_, Some(mean'), _) => (mean'->Int.toFloat *. representativeWeight)->Float.toInt
    | _ => 0
    }

    let wantedPricePerPackage = currentDemand->Option.flatMap(x => x.wantedPricePerPackage)
    let defaultPriceInputValue = switch wantedPricePerPackage {
    | Some(_) => wantedPricePerPackage
    | None => estimatedTotalPrice->Some
    }

    let (price, setPrice) = React.Uncurried.useState(_ => defaultPriceInputValue)
    let (updateMutate, isUpdateMutating) = Mutation.PartialUpdateTradematchDemand.use()

    let trackData = () => {
      let demandId = switch currentDemand {
      | Some(currentDemand') => currentDemand'.id
      | None => ""
      }

      DataGtm.push({
        "event": "click_intention_price",
        "tradematch_demand_id": demandId,
        "price_per_trade": price,
      })
    }

    let handleClickButton = _ => {
      trackData()
      switch currentDemand {
      | Some(currentDemand') =>
        updateMutate(
          ~variables={
            getUpdateMutateVariables(~id=currentDemand'.id, ~wantedPricePerPackage=price)()
          },
          ~onCompleted=({partialUpdateTradematchDemand}, _) => {
            switch partialUpdateTradematchDemand {
            | #TradematchDemandMutationPayload(_) => navigateToNextStep()
            | #Error(_)
            | #UnselectedUnionMember(_) =>
              addToast(.
                `요청 중 요류가 발생했습니다. 잠시 후 다시 시도해주세요.`->DS_Toast.getToastComponent(
                  #error,
                ),
                {appearance: "error"},
              )
            }
            ()
          },
          ~onError={
            err =>
              addToast(.
                `요청 중 요류가 발생했습니다. 잠시 후 다시 시도해주세요.`->DS_Toast.getToastComponent(
                  #error,
                ),
                {appearance: "error"},
              )
          },
          (),
        )->ignore
      | None => ()
      }
    }

    let estimatedTotalPriceText = switch (price, numberOfPackagesPerTrade) {
    | (Some(price'), Some(numberOfPackagesPerTrade')) =>
      `예상 ${(price'->Int.toFloat *. numberOfPackagesPerTrade'->Int.toFloat)
          ->Locale.Float.show(~digits=0)}원`
    | _ => ``
    }

    <div>
      <Common.Title
        text={titleText}
        subText={`시장 평균가 이하면 생산자와\n매칭 확률이 낮아질 수 있습니다`}
      />
      <DS_InputField.Line1.Root className=%twc("mt-4")>
        <DS_InputField.Line1.Input
          type_="text"
          placeholder={`구매 희망 입찰가`}
          inputMode={"decimal"}
          value={switch price {
          | Some(price') => price'->Int.toFloat->Locale.Float.show(~digits=0)
          | None => ""
          }}
          autoFocus=true
          onChange={e => {
            let value = (e->ReactEvent.Synthetic.target)["value"]
            setPrice(._ => value->convertNumberInputValue->Int.fromString)
          }}
          unit={`원`}
          isClear=true
          fnClear={_ => setPrice(._ => None)}
          underLabel={averagePriceText}
          maxLength={11}
        />
      </DS_InputField.Line1.Root>
      <div className=%twc("mt-9 mx-5")>
        <div
          className=%twc(
            "relative flex justify-between items-center border-border-default-L2 px-4 h-[72px] border-[1px] border-solid rounded-lg mb-3"
          )>
          <div className=%twc("w-[26%] mr-[30px]")>
            <span className=%twc("break-all font-bold")> {totalWeightText->React.string} </span>
          </div>
          <div className=%twc("w-[46%] flex justify-end")>
            <span className=%twc("break-all font-bold")>
              {estimatedTotalPriceText->React.string}
            </span>
          </div>
        </div>
        <div>
          <span className=%twc("text-gray-400 text-sm whitespace-pre-line")>
            {`배송비는 별도입니다\n추가 옵션 및 시기에 따라 가격이 변동 될 수 있습니다`->React.string}
          </span>
        </div>
      </div>
      <Common.FloatingButton
        handleClickButton={handleClickButton} disabled={price->Option.isNone || isUpdateMutating}
      />
    </div>
  }
}
module Cycle = {
  @react.component
  let make = (
    ~currentDemand: option<
      TradematchAskToBuyApplyBuyer_TradematchDemands_Fragment_graphql.Types.fragment_tradematchDemands_edges_node,
    >,
  ) => {
    let {navigateToNextStep} = CustomHooks.Tradematch.useNavigateStep()
    let {addToast} = ReactToastNotifications.useToasts()

    let (selectedCycle, setSelectedCycle) = React.Uncurried.useState(_ =>
      currentDemand->Option.flatMap(x => Some(x.tradeCycle))
    )

    let cycles = [`매일`, `주 3~5회`, `주 1~2회`, `월 1~2회`, `일회성 주문`]

    let isSelectedCycle = switch selectedCycle {
    | Some(selectedCycle') => cycles->Array.getBy(x => x === selectedCycle')->Option.isNone
    | None => false
    }

    let (updateMutate, isUpdateMutating) = Mutation.PartialUpdateTradematchDemand.use()

    let trackData = () => {
      let demandId = switch currentDemand {
      | Some(currentDemand') => currentDemand'.id
      | None => ""
      }

      DataGtm.push({
        "event": "click_intention_cycle",
        "tradematch_demand_id": demandId,
        "trade_cycle": selectedCycle,
      })
    }

    let handleClickButton = _ => {
      trackData()
      switch currentDemand {
      | Some(currentDemand') =>
        updateMutate(
          ~variables={
            getUpdateMutateVariables(~id=currentDemand'.id, ~tradeCycle=selectedCycle)()
          },
          ~onCompleted=({partialUpdateTradematchDemand}, _) => {
            switch partialUpdateTradematchDemand {
            | #TradematchDemandMutationPayload(_) => navigateToNextStep()
            | #Error(_)
            | #UnselectedUnionMember(_) =>
              addToast(.
                `요청 중 요류가 발생했습니다. 잠시 후 다시 시도해주세요.`->DS_Toast.getToastComponent(
                  #error,
                ),
                {appearance: "error"},
              )
            }
            ()
          },
          ~onError={
            err =>
              addToast(.
                `요청 중 요류가 발생했습니다. 잠시 후 다시 시도해주세요.`->DS_Toast.getToastComponent(
                  #error,
                ),
                {appearance: "error"},
              )
          },
          (),
        )->ignore
      | None => ()
      }
    }

    <div>
      <Common.Title text={`원하시는 납품주기를\n선택해주세요`} />
      <form>
        <RadixUI.RadioGroup.Root
          name="tradematch-cycle"
          value={selectedCycle->Option.mapWithDefault("", x => x)}
          onValueChange={v => setSelectedCycle(._ => Some(v))}>
          {cycles
          ->Array.mapWithIndex((index, value) => {
            <li key={index->Int.toString} className=%twc("flex w-full items-center h-[60px]")>
              <label
                className=%twc(
                  "flex items-center justify-between w-full h-full px-5 cursor-pointer"
                )>
                <div className=%twc("text-text-L1")> {value->React.string} </div>
                <RadixUI.RadioGroup.Item
                  id={value}
                  value={value}
                  className={cx([
                    %twc(
                      "relative flex items-center justify-center ml-[25px] min-w-[22px] min-h-[22px] max-w-[22px] max-h-[22px] border-[1.5px] rounded-full border-enabled-L4 "
                    ),
                    %twc(
                      "after:content-[''] after:w-[7px] after:h-[7px] after:bg-enabled-L4 after:bg-opacity-30 after:rounded-full after:absolute "
                    ),
                  ])}>
                  <RadixUI.RadioGroup.Indicator
                    className={cx([
                      %twc("relative flex items-center justify-center h-full w-full "),
                      %twc(
                        "after:block after:content-[''] after:rounded-full after:border-green-500 after:border-[7px] after:bg-transparent after:min-w-[22px] after:h-[22px]"
                      ),
                    ])}
                  />
                </RadixUI.RadioGroup.Item>
              </label>
            </li>
          })
          ->React.array}
        </RadixUI.RadioGroup.Root>
      </form>
      <Common.FloatingButton
        handleClickButton={handleClickButton} disabled={isSelectedCycle || isUpdateMutating}
      />
    </div>
  }
}

module Requirement = {
  @react.component
  let make = (
    ~currentDemand: option<
      TradematchAskToBuyApplyBuyer_TradematchDemands_Fragment_graphql.Types.fragment_tradematchDemands_edges_node,
    >,
  ) => {
    let {navigateToNextStep} = CustomHooks.Tradematch.useNavigateStep()
    let {addToast} = ReactToastNotifications.useToasts()

    let (size, setSize) = React.Uncurried.useState(_ =>
      currentDemand->Option.mapWithDefault("", x => x.productSize)
    )
    let (process, setProcess) = React.Uncurried.useState(_ =>
      currentDemand->Option.mapWithDefault("", x => x.productProcess)
    )
    let (requirement, setRequirement) = React.Uncurried.useState(_ =>
      currentDemand->Option.mapWithDefault("", x => x.productRequirements)
    )
    let (updateMutate, isUpdateMutating) = Mutation.PartialUpdateTradematchDemand.use()

    let trackData = () => {
      let demandId = switch currentDemand {
      | Some(currentDemand') => currentDemand'.id
      | None => ""
      }

      DataGtm.push({
        "event": "click_intention_requirements",
        "tradematch_demand_id": demandId,
        "product_size": size,
        "product_process": process,
        "product_requirements": requirement,
      })
    }

    let handleClickButton = _ => {
      trackData()
      switch currentDemand {
      | Some(currentDemand') =>
        updateMutate(
          ~variables={
            getUpdateMutateVariables(
              ~id=currentDemand'.id,
              ~productProcess=Some(process),
              ~productSize=Some(size),
              ~productRequirements=Some(requirement),
            )()
          },
          ~onCompleted=({partialUpdateTradematchDemand}, _) => {
            switch partialUpdateTradematchDemand {
            | #TradematchDemandMutationPayload(_) => navigateToNextStep()
            | #Error(_)
            | #UnselectedUnionMember(_) =>
              addToast(.
                `요청 중 요류가 발생했습니다. 잠시 후 다시 시도해주세요.`->DS_Toast.getToastComponent(
                  #error,
                ),
                {appearance: "error"},
              )
            }
            ()
          },
          ~onError={
            err =>
              addToast(.
                `요청 중 요류가 발생했습니다. 잠시 후 다시 시도해주세요.`->DS_Toast.getToastComponent(
                  #error,
                ),
                {appearance: "error"},
              )
          },
          (),
        )->ignore
      | None => ()
      }
    }

    <div>
      <Common.Title text={`기타 요청사항을\n남겨주세요`} />
      <div>
        <DS_InputField.Line1.Root className=%twc("mt-4")>
          <div className=%twc("mb-2 text-sm")> {`사이즈`->React.string} </div>
          <DS_InputField.Line1.Input
            type_="text"
            placeholder={`개당 200g ~250g 내외`}
            value={size}
            onChange={e => {
              let value = (e->ReactEvent.Synthetic.target)["value"]
              setSize(._ => value)
            }}
            maxLength={10000}
          />
        </DS_InputField.Line1.Root>
        <DS_InputField.Line1.Root className=%twc("mt-4")>
          <div className=%twc("mb-2 text-sm")> {`상품 가공`->React.string} </div>
          <DS_InputField.Line1.Input
            type_="text"
            placeholder={`껍질제거, 세척, 절단, 건조 등`}
            value={process}
            onChange={e => {
              let value = (e->ReactEvent.Synthetic.target)["value"]
              setProcess(._ => value)
            }}
            maxLength={10000}
          />
        </DS_InputField.Line1.Root>
        <DS_InputField.Line1.Root className=%twc("mt-4")>
          <div className=%twc("mb-2 text-sm")> {`기타`->React.string} </div>
          <DS_InputField.Line1.Input
            type_="text"
            placeholder={`선별수준, 원산지, 평균 당도 등`}
            value={requirement}
            onChange={e => {
              let value = (e->ReactEvent.Synthetic.target)["value"]
              setRequirement(._ => value)
            }}
            maxLength={10000}
          />
        </DS_InputField.Line1.Root>
      </div>
      <Common.FloatingButton handleClickButton={handleClickButton} disabled={isUpdateMutating} />
    </div>
  }
}

@send external focus: Dom.element => unit = "focus"
module Shipping = {
  @react.component
  let make = (
    ~currentDemand: option<
      TradematchAskToBuyApplyBuyer_TradematchDemands_Fragment_graphql.Types.fragment_tradematchDemands_edges_node,
    >,
  ) => {
    let {tradematchDeliveryPolicy} = Query.TradematchDeliveryPolicy.use(~variables=(), ())
    let {terms} = Query.TradematchTerms.use(~variables=(), ())
    let (updateMutate, isUpdateMutating) = Mutation.PartialUpdateTradematchDemand.use()
    let (updateTermAgreement, _) = Mutation.UpdateTermAgreement.use()

    let {navigateToNextStep} = CustomHooks.Tradematch.useNavigateStep()
    let {addToast} = ReactToastNotifications.useToasts()

    let isTermAgree =
      terms.edges->Array.map(x => x.node.agreement)->Array.keep(x => x === `rfq`)->Array.length > 0

    let (isAgreedPrivacyPolicy, setIsAgreedPrivacyPolicy) = React.Uncurried.useState(_ =>
      isTermAgree
    )
    let (selectedDeliveryDate, setSelectedDeliveryDate) = React.Uncurried.useState(_ => None)

    let minDateString = switch tradematchDeliveryPolicy {
    | Some(tradematchDeliveryPolicy') => tradematchDeliveryPolicy'.acceptableDeliveryDate
    | None => Js.Date.make()->DateFns.addDays(7)->DateFns.format("yyyy-MM-dd")
    }

    let minDate = minDateString->Js.Date.fromString
    let maxDate = minDate->DateFns.addDays(30)

    let deliveryAddressDetailInput = React.useRef(Js.Nullable.null)
    let (isAddressDrawerShow, setIsAddressDrawerShow) = React.Uncurried.useState(_ => false)

    let (deliveryRegion, setDeliveryRegion) = React.Uncurried.useState(_ => ``)
    let (deliveryAddress, setDeliveryAddress) = React.Uncurried.useState(_ => ``)
    let (deliveryAddressDetail, setDeliveryAddressDetail) = React.Uncurried.useState(_ => ``)
    let (deliveryAddressZipcode, setDeliveryAddressZipcode) = React.Uncurried.useState(_ => ``)

    React.useEffect1(() => {
      setDeliveryAddressDetail(._ => ``)
      deliveryAddressDetailInput.current
      ->Js.Nullable.toOption
      ->Belt.Option.forEach(input => input->focus)

      None
    }, [deliveryAddress])

    let toggleDrawer = _ => setIsAddressDrawerShow(.prev => !prev)
    let onCompleteAddressDrawer = (data: DaumPostCode.oncompleteResponse) => {
      let {zonecode, sido, sigungu, bname, addressType, address, autoRoadAddress} = data
      let deliveryAddress = switch addressType {
      | #R => address
      | #J => autoRoadAddress
      }

      let deliveryRegion =
        `${sido} ${sigungu} ${bname}`
        ->Js.String2.replaceByRe(%re("/[ ]{2,}/"), " ")
        ->Js.String2.trim

      setDeliveryRegion(._ => deliveryRegion)
      setDeliveryAddress(._ => deliveryAddress)
      setDeliveryAddressZipcode(._ => zonecode)
      toggleDrawer()
    }

    let updateDemand = _ => {
      switch currentDemand {
      | Some(currentDemand') => {
          let deliveryDate =
            selectedDeliveryDate->Option.mapWithDefault(None, date => Some(
              date->Js.Date.toISOString,
            ))
          updateMutate(
            ~variables={
              getUpdateMutateVariables(
                ~id=currentDemand'.id,
                ~deliveryAddress1=Some(deliveryAddress),
                ~deliveryAddress2=Some(deliveryAddressDetail->Js.String2.trim),
                ~deliveryDate,
                ~deliveryRegion=Some(deliveryRegion),
                ~deliveryZipCode=Some(deliveryAddressZipcode),
                ~status=Some(#REQUESTED),
              )()
            },
            ~onCompleted=({partialUpdateTradematchDemand}, _) => {
              switch partialUpdateTradematchDemand {
              | #TradematchDemandMutationPayload(_) => navigateToNextStep()
              | #Error(_)
              | #UnselectedUnionMember(_) =>
                addToast(.
                  `요청 중 요류가 발생했습니다. 잠시 후 다시 시도해주세요.`->DS_Toast.getToastComponent(
                    #error,
                  ),
                  {appearance: "error"},
                )
              }
              ()
            },
            ~onError={
              err =>
                addToast(.
                  `요청 중 요류가 발생했습니다. 잠시 후 다시 시도해주세요.`->DS_Toast.getToastComponent(
                    #error,
                  ),
                  {appearance: "error"},
                )
            },
            (),
          )->ignore
        }

      | None => ()
      }
    }

    let trackData = () => {
      let demandId = switch currentDemand {
      | Some(currentDemand') => currentDemand'.id
      | None => ""
      }

      DataGtm.push({
        "event": "click_intention_address",
        "tradematch_demand_id": demandId,
      })
    }

    let handleClickButton = _ => {
      trackData()
      switch isTermAgree {
      | true => updateDemand()
      | false =>
        updateTermAgreement(
          ~variables={agreement: "rfq"},
          ~onCompleted=({createTerm}, _) => {
            switch createTerm {
            | #TermMutationPayload(_) => updateDemand()
            | #Error(_)
            | #UnselectedUnionMember(_) =>
              addToast(.
                `요청 중 요류가 발생했습니다. 잠시 후 다시 시도해주세요.`->DS_Toast.getToastComponent(
                  #error,
                ),
                {appearance: "error"},
              )
            }
          },
          ~onError=_ =>
            addToast(.
              `요청 중 요류가 발생했습니다. 잠시 후 다시 시도해주세요.`->DS_Toast.getToastComponent(
                #error,
              ),
              {appearance: "error"},
            ),
          (),
        )->ignore
      }
    }

    let isValidItems = {
      switch (
        selectedDeliveryDate,
        deliveryRegion !== ``,
        deliveryAddress !== ``,
        deliveryAddressZipcode !== ``,
        isAgreedPrivacyPolicy,
      ) {
      | (Some(_), true, true, true, true) => true
      | _ => false
      }
    }

    <>
      <div>
        <Common.Title text={`마지막으로\n배송정보를 알려주세요`} />
        <CalendarListitem
          leftText={`배송 희망일`}
          currentDate={selectedDeliveryDate}
          handleChangeDate={setSelectedDeliveryDate}
          minDate={minDate}
          maxDate={maxDate}
        />
        <div className=%twc("mx-5 mb-[30px]")>
          <div className=%twc("my-4")> {`배송지`->React.string} </div>
          <div className=%twc("flex mb-[13px]")>
            <input
              disabled=true
              value=deliveryAddressZipcode
              className={cx([
                %twc(
                  "w-full px-[14px] py-[13px] rounded-[10px] border-border-default-L1 border-[1px]"
                ),
                %twc("disabled:bg-disabled-L3"),
              ])}
              placeholder={`우편번호`}
            />
            <button
              className=%twc(
                "ml-2 min-w-[92px] bg-blue-gray-700 px-[14px] py-[13px] rounded-[10px] text-inverted font-bold"
              )
              onClick={toggleDrawer}>
              {`주소 검색`->React.string}
            </button>
          </div>
          <div className=%twc("mb-[13px]")>
            <input
              disabled=true
              className={cx([
                %twc(
                  "w-full px-[14px] py-[13px] rounded-[10px] border-border-default-L1 border-[1px]"
                ),
                %twc("disabled:bg-disabled-L3"),
              ])}
              value=deliveryAddress
              placeholder={`주소`}
            />
          </div>
          <div>
            <input
              ref={ReactDOM.Ref.domRef(deliveryAddressDetailInput)}
              onChange={e => {
                let value = (e->ReactEvent.Synthetic.target)["value"]
                setDeliveryAddressDetail(._ => value)
              }}
              value=deliveryAddressDetail
              disabled={deliveryAddress->Js.String2.length === 0}
              className={cx([
                %twc(
                  "w-full px-[14px] py-[13px] rounded-[10px] border-border-default-L1 border-[1px]"
                ),
                %twc("disabled:bg-disabled-L3 disabled:text-inverted disabled:text-opacity-50"),
              ])}
              placeholder={`상세주소를 입력해주세요.`}
            />
          </div>
        </div>
        {isTermAgree
          ? React.null
          : <>
              <div className=%twc("h-3 bg-border-default-L2") />
              <div className=%twc("my-7 mx-5")>
                <button onClick={_ => setIsAgreedPrivacyPolicy(.prev => !prev)}>
                  <div>
                    <div className=%twc("flex items-center space-x-2 mb-3")>
                      {isAgreedPrivacyPolicy
                        ? <DS_Icon.Common.CheckedLarge1 height="24" width="24" fill={`#12B564`} />
                        : <DS_Icon.Common.UncheckedLarge1 height="24" width="24" />}
                      <span className=%twc("font-bold leading-7 tracking-tight text-enabled-L1")>
                        {`개인정보 제공에 동의해주세요`->React.string}
                      </span>
                    </div>
                    <div className=%twc("pl-8 text-left")>
                      <p className=%twc("text-[13px] text-enabled-L2 leading-5 tracking-tight")>
                        <div>
                          {`(주)그린랩스는 다음과 같은 목적으로 개인정보를 수집합니다.`->React.string}
                        </div>
                        <div> {`1. 개인정보 수집 항목 : 주소`->React.string} </div>
                        <div>
                          {`2. 개인정보 수집 목적 : 견적 매칭 서비스 및 구매상품 배송`->React.string}
                        </div>
                        <div>
                          {`3. 개인정보의 보유 및 이용 기간 : `->React.string}
                          <span className=%twc("font-bold")>
                            {`회원탈퇴 시 즉시 파기`->React.string}
                          </span>
                          {` 이용자는 개인정보 수집 및 이용 동의를 거부할 권리가 있습니다. 다만, 이에 동의하지 않을 경우 신선매칭 서비스 이용이 어려울 수 있습니다.`->React.string}
                        </div>
                      </p>
                    </div>
                  </div>
                </button>
              </div>
            </>}
      </div>
      <Common.FloatingButton
        handleClickButton={handleClickButton} disabled={!isValidItems || isUpdateMutating}
      />
      <AddressDrawer
        isShow={isAddressDrawerShow} closeDrawer={toggleDrawer} onComplete={onCompleteAddressDrawer}
      />
    </>
  }
}
