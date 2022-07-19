module Query = {
  module MatchingProduct = %relay(`
    query TradematchAskToBuyApplyBuyer_MatchingProduct_Query($id: ID!) {
      node(id: $id) {
        ... on MatchingProduct {
          name
          representativeWeight
          qualityStandard {
            highQualityStandard: high {
              description
            }
            mediumQualityStandard: medium {
              description
            }
            lowQualityStandard: low {
              description
            }
          }
          recentMarketPrice {
            highRecentMarketPrice: high {
              lower
              mean
              higher
            }
            mediumRecentMarketPrice: medium {
              lower
              mean
              higher
            }
            lowRecentMarketPrice: low {
              lower
              mean
              higher
            }
          }
          category {
            name
            productCategoryCodeId
          }
        }
      }
    }
  `)

  module TradematchDemands = %relay(`
    query TradematchAskToBuyApplyBuyer_TradematchDemands_Query(
      $productIds: [ID!]
      $statuses: [TradematchDemandStatus!]
      $orderBy: TradematchDemandOrderBy
      $orderDirection: OrderDirection
      $first: Int
    ) {
      ...TradematchAskToBuyApplyBuyer_TradematchDemands_Fragment
        @arguments(
          productIds: $productIds
          statuses: $statuses
          orderBy: $orderBy
          orderDirection: $orderDirection
          first: $first
        )
    }
  `)
}

module Fragment = {
  module TradematchDemands = %relay(`
    fragment TradematchAskToBuyApplyBuyer_TradematchDemands_Fragment on Query
    @refetchable(queryName: "TradematchAskToBuyApplyBuyerRefetchQuery")
    @argumentDefinitions(
      after: { type: "ID" }
      productIds: { type: "[ID!]" }
      first: { type: "Int" }
      orderDirection: { type: "OrderDirection" }
      orderBy: { type: "TradematchDemandOrderBy" }
      statuses: { type: "[TradematchDemandStatus!]" }
    ) {
      tradematchDemands(
        after: $after
        productIds: $productIds
        statuses: $statuses
        orderBy: $orderBy
        orderDirection: $orderDirection
        first: $first
      ) @connection(key: "TradematchAskToBuyApplyBuyer__tradematchDemands") {
        __id
        edges {
          node {
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
}

module Mutation = {
  module DeleteTradematchDemand = %relay(`
    mutation TradematchAskToBuyApplyBuyer_DeleteTradematchDemand_Mutation(
      $id: ID!
      $connections: [ID!]!
    ) {
      deleteTradematchDemand(id: $id) {
        ... on Error {
          message
        }
        ... on DeleteSuccess {
          deletedId @deleteEdge(connections: $connections)
        }
      }
    }
  `)
}

module Layout = {
  @react.component
  let make = (~children) => {
    <div className=%twc("bg-gray-100")>
      <div className=%twc("relative container bg-white max-w-3xl mx-auto min-h-screen")>
        children
      </div>
    </div>
  }
}

module Header = {
  @react.component
  let make = (~title=?, ~handleClickLeftButton=History.back) => {
    <>
      <div className=%twc("w-full fixed top-0 left-0 z-10")>
        <header className=%twc("w-full max-w-3xl mx-auto h-14 bg-white")>
          <div className=%twc("px-5 py-4 flex justify-between")>
            <button onClick={_ => handleClickLeftButton()}>
              <IconArrow height="24" width="24" stroke="#262626" className=%twc("rotate-180") />
            </button>
            <div>
              <span className=%twc("font-bold text-base")>
                {title->Option.mapWithDefault(``, x => x)->React.string}
              </span>
            </div>
            <div />
          </div>
        </header>
      </div>
      <div className=%twc("w-full h-14") />
    </>
  }
}

module ProgressBar = {
  @react.component
  let make = () => {
    let {currentStepIndex, totalStepLength} = CustomHooks.Tradematch.usePageSteps()
    let percentage =
      (currentStepIndex + 1)->Int.toFloat /. (totalStepLength + 1)->Int.toFloat *. 100.
    let style = ReactDOM.Style.make(~width=`${percentage->Float.toString}%`, ())

    <div className=%twc("max-w-3xl fixed h-1 w-full bg-surface z-[10]")>
      <div style className=%twc("absolute left-0 top-0 bg-primary z-30 h-full") />
    </div>
  }
}

module Skeleton = {
  @react.component
  let make = () => {
    <>
      <div className=%twc("px-5 py-9")> <Skeleton.Box className=%twc("h-18") /> </div>
      <div className=%twc("space-y-8")>
        <div className=%twc("px-5 space-y-1")>
          <Skeleton.Box className=%twc("h-7 w-1/5") />
          <Skeleton.Box className=%twc("h-5 w-1/3") />
          <Skeleton.Box className=%twc("h-5 w-1/2") />
        </div>
        <div className=%twc("px-5 space-y-1")>
          <Skeleton.Box className=%twc("h-7 w-1/5") />
          <Skeleton.Box className=%twc("h-5 w-1/3") />
          <Skeleton.Box className=%twc("h-5 w-1/2") />
        </div>
      </div>
      <div className=%twc("fixed bottom-0 max-w-3xl w-full px-4 py-5")>
        <Skeleton.Box className=%twc("w-full rounded-xl h-[52px]") />
      </div>
      <div className=%twc("h-24") />
    </>
  }
}

module NotFoundProductOrDemand = {
  @react.component
  let make = () => {
    <DS_Dialog.Popup.Root _open=true>
      <DS_Dialog.Popup.Portal>
        <DS_Dialog.Popup.Overlay />
        <DS_Dialog.Popup.Content>
          <DS_Dialog.Popup.Title>
            {`상품 정보를 찾을 수 없습니다.`->React.string}
          </DS_Dialog.Popup.Title>
          <DS_Dialog.Popup.Description>
            {`해당 상품을 찾을 수 없습니다.`->React.string}
          </DS_Dialog.Popup.Description>
          <DS_Dialog.Popup.Buttons>
            <DS_Dialog.Popup.Close asChild=true>
              <DS_Button.Normal.Large1 label={`돌아가기`} onClick={_ => History.back()} />
            </DS_Dialog.Popup.Close>
          </DS_Dialog.Popup.Buttons>
        </DS_Dialog.Popup.Content>
      </DS_Dialog.Popup.Portal>
    </DS_Dialog.Popup.Root>
  }
}

module StatusChecker = {
  @react.component
  let make = (
    ~currentDemand: option<
      TradematchAskToBuyApplyBuyer_TradematchDemands_Fragment_graphql.Types.fragment_tradematchDemands_edges_node,
    >,
    ~connectionId,
    ~children,
  ) => {
    let {navigateToFirstStep, replaceToStep} = CustomHooks.Tradematch.useNavigateStep()
    let {currentStep, firstStep} = CustomHooks.Tradematch.usePageSteps()
    let {addToast} = ReactToastNotifications.useToasts()

    let (deleteMutate, _) = Mutation.DeleteTradematchDemand.use()

    switch (currentStep !== firstStep, currentDemand->Option.isSome) {
    | (true, false) => navigateToFirstStep()
    | _ => ()
    }

    let hasDraftDemand = currentDemand->Option.isSome
    let (isOpenCheckDraftDemand, setIsOpenCheckDraftDemand) = React.Uncurried.useState(_ =>
      hasDraftDemand
    )

    let applyContinueDraftDemand = () => {
      switch currentDemand {
      | Some(demand) =>
        switch (
          // grade
          demand.priceGroup->Option.isSome,
          demand.productCategoryCode->Js.String2.length > 0,
          // count
          demand.numberOfPackagesPerTrade->Option.isSome,
          demand.packageQuantityUnit->Option.isSome,
          demand.quantityPerPackage->Option.isSome,
          // price
          demand.wantedPricePerPackage->Option.isSome,
          // cycle
          demand.tradeCycle->Js.String2.length > 0,
          // requirement
          demand.productProcess->Js.String2.length > 0,
          demand.productSize->Js.String2.length > 0,
          demand.productRequirements->Js.String2.length > 0,
        ) {
        | (true, true, true, true, true, true, true, true, true, true) => replaceToStep("shipping")
        | (true, true, true, true, true, true, true, _, _, _) => replaceToStep("requirement")
        | (true, true, true, true, true, true, _, _, _, _) => replaceToStep("cycle")
        | (true, true, true, true, true, _, _, _, _, _) => replaceToStep("price")
        | (true, true, _, _, _, _, _, _, _, _) => replaceToStep("count")
        | (_, _, _, _, _, _, _, _, _, _) => navigateToFirstStep()
        }
      | None => navigateToFirstStep()
      }
    }

    let handleClickAcceptButton = () => {
      setIsOpenCheckDraftDemand(._ => false)
      applyContinueDraftDemand()
    }

    let handleClickRejectButton = () => {
      switch currentDemand {
      | Some(demand) => {
          let variables = Mutation.DeleteTradematchDemand.makeVariables(
            ~id=demand.id,
            ~connections=[connectionId],
          )
          deleteMutate(
            ~variables,
            ~onCompleted=({deleteTradematchDemand}, _) => {
              switch deleteTradematchDemand {
              | #DeleteSuccess(_) => {
                  setIsOpenCheckDraftDemand(._ => false)
                  navigateToFirstStep()
                }
              | #UnselectedUnionMember(_)
              | #Error(_) =>
                addToast(.
                  `요청 중 요류가 발생했습니다. 잠시 후 다시 시도해주세요.`->DS_Toast.getToastComponent(
                    #error,
                  ),
                  {appearance: "error"},
                )
              }
            },
            ~onError={
              err => {
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
        }
      | None => ()
      }
    }

    <>
      {switch isOpenCheckDraftDemand {
      | true => <> <Header /> <Skeleton /> </>
      | false => children
      }}
      <DS_Dialog.Popup.Root _open=isOpenCheckDraftDemand>
        <DS_Dialog.Popup.Portal>
          <DS_Dialog.Popup.Overlay />
          <DS_Dialog.Popup.Content>
            <DS_Dialog.Popup.Title>
              {`작성중인 견적서가 있습니다.`->React.string}
            </DS_Dialog.Popup.Title>
            <DS_Dialog.Popup.Description>
              {`이어서 작성하시겠어요?`->React.string}
            </DS_Dialog.Popup.Description>
            <DS_Dialog.Popup.Buttons>
              <DS_Dialog.Popup.Close asChild=true>
                <DS_Button.Normal.Large1
                  buttonType=#white
                  onClick={_ => handleClickRejectButton()}
                  label={`새로 작성하기`}
                />
              </DS_Dialog.Popup.Close>
              <DS_Dialog.Popup.Close asChild=true>
                <DS_Button.Normal.Large1
                  label={`이어서 작성하기`} onClick={_ => handleClickAcceptButton()}
                />
              </DS_Dialog.Popup.Close>
            </DS_Dialog.Popup.Buttons>
          </DS_Dialog.Popup.Content>
        </DS_Dialog.Popup.Portal>
      </DS_Dialog.Popup.Root>
    </>
  }
}

module Content = {
  @react.component
  let make = (~pid: string) => {
    let {currentStep} = CustomHooks.Tradematch.usePageSteps()

    let {node} = Query.MatchingProduct.use(~variables={id: pid}, ())
    let draftStatusTradematchDemands = Query.TradematchDemands.use(
      ~variables={
        productIds: Some([pid]),
        statuses: Some([#DRAFT]),
        orderBy: Some(#DRAFTED_AT),
        orderDirection: Some(#DESC),
        first: Some(100),
      },
      ~fetchPolicy=NetworkOnly,
      (),
    )

    let {data} = draftStatusTradematchDemands.fragmentRefs->Fragment.TradematchDemands.usePagination
    let tradematchDemands = data.tradematchDemands->Fragment.TradematchDemands.getConnectionNodes
    let connectionId = data.tradematchDemands.__id
    let currentDemand = tradematchDemands->Garter_Array.first

    <StatusChecker currentDemand={currentDemand} connectionId={connectionId}>
      <Header
        title={switch node {
        | Some(node') => `${node'.category.name} 견적 신청`
        | None => ``
        }}
      />
      {switch node {
      | Some(matchingProduct) => <>
          <ProgressBar />
          {switch currentStep {
          | "grade" =>
            <Tradematch_Ask_To_Buy_Apply_Steps_Buyer.Grade
              pid={pid}
              product={matchingProduct}
              currentDemand={currentDemand}
              connectionId={connectionId}
            />
          | "count" =>
            <Tradematch_Ask_To_Buy_Apply_Steps_Buyer.Count
              product={matchingProduct} currentDemand={currentDemand}
            />
          | "price" =>
            <Tradematch_Ask_To_Buy_Apply_Steps_Buyer.Price
              product={matchingProduct} currentDemand={currentDemand}
            />
          | "cycle" =>
            <Tradematch_Ask_To_Buy_Apply_Steps_Buyer.Cycle currentDemand={currentDemand} />
          | "requirement" =>
            <Tradematch_Ask_To_Buy_Apply_Steps_Buyer.Requirement currentDemand={currentDemand} />
          | "shipping" =>
            <React.Suspense fallback={<Skeleton />}>
              <Tradematch_Ask_To_Buy_Apply_Steps_Buyer.Shipping currentDemand={currentDemand} />
            </React.Suspense>
          | _ =>
            <Tradematch_Ask_To_Buy_Apply_Steps_Buyer.Grade
              pid={pid}
              product={matchingProduct}
              currentDemand={currentDemand}
              connectionId={connectionId}
            />
          }}
        </>
      | None => <> <Skeleton /> <NotFoundProductOrDemand /> </>
      }}
    </StatusChecker>
  }
}

@react.component
let make = (~pid: option<string>) => {
  <Authorization.Buyer title=j`견적 신청`>
    <Layout>
      <RescriptReactErrorBoundary
        fallback={_ => <> <Header /> <Skeleton /> <NotFoundProductOrDemand /> </>}>
        <React.Suspense fallback={<> <Header /> <Skeleton /> </>}>
          {switch pid {
          | Some(pid') => <Content pid={pid'} />
          | None => React.null
          }}
        </React.Suspense>
      </RescriptReactErrorBoundary>
    </Layout>
  </Authorization.Buyer>
}
