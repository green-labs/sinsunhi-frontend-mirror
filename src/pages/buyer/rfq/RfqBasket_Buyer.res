module Query = {
  module CurrentRequest = %relay(`
    query RfqBasketBuyer_Current_Request_Query($requestIds: [ID!]) {
      ...RfqBasketBuyer_RfqRequestItemsMeat_Fragment
        @arguments(requestIds: $requestIds)
    }
  `)

  module MeatSpecies = %relay(`
    query RfqBasketBuyer_MeatSpecies_Query($orderBy: MeatSpeciesOrderBy) {
      meatSpecies(orderBy: $orderBy) {
        edges {
          node {
            id
            isAvailable
            name
            code
            shortName
          }
        }
      }
    }
`)

  module MeatParts = %relay(`
    query RfqBasketBuyer_MeatParts_Query(
      $isDomestic: Boolean
      $meatSpeciesIds: [ID!]
    ) {
      meatParts(
        first: 9999
        isDomestic: $isDomestic
        meatSpeciesIds: $meatSpeciesIds
      ) {
        edges {
          node {
            isDomestic
            id
            isAvailable
            name
          }
        }
      }
    }
  `)
}

module Fragment = {
  module RequestItemsMeat = %relay(`
    fragment RfqBasketBuyer_RfqRequestItemsMeat_Fragment on Query
    @refetchable(queryName: "RfqBasketBuyer_RfqRequestItemsMeat_Fragment_Query")
    @argumentDefinitions(
      after: { type: "ID" }
      first: { type: "Int", defaultValue: 9999 }
      requestIds: { type: "[ID!]" }
      orderBy: {
        type: "RfqRequestItemMeatOrderBy"
        defaultValue: MEAT_SPECIES_PRIORITY
      }
    ) {
      rfqRequestItemsMeat(
        after: $after
        first: $first
        requestIds: $requestIds
        orderBy: $orderBy
      ) @connection(key: "RfqBasketBuyer__rfqRequestItemsMeat") {
        __id
        count
        edges {
          node {
            id
            part {
              id
              isAvailable
              isDomestic
              name
            }
            species {
              id
              isAvailable
              name
              code
              shortName
            }
            grade {
              grade
              madeIn
            }
            weightKg
            usages {
              edges {
                node {
                  id
                  name
                }
              }
            }
            storageMethod
            packageMethod
            prevTradeSellerName
            prevTradePricePerKg
            preferredBrand
            otherRequirements
            createdAt
            updatedAt
            status
          }
        }
      }
    }

`)
}

module Mutation = {
  module CreateRequestItemsMeat = %relay(`
    mutation RfqBasketBuyer_CreateRequestItemsMeat_Mutation(
      $rfqRequestId: ID!
      $meatPartId: ID
      $meatSpeciesId: ID
      $status: RfqRequestItemStatus!
      $connections: [ID!]!
    ) {
      createRfqRequestItemsMeat(
        input: {
          status: $status
          rfqRequestId: $rfqRequestId
          meatPartId: $meatPartId
          meatSpeciesId: $meatSpeciesId
          meatUsageIds: []
        }
      ) {
        ... on RfqRequestItemMeatMutationPayload {
          result
            @prependNode(
              connections: $connections
              edgeTypeName: "RfqRequestItemMeat"
            ) {
            id
            part {
              id
              isAvailable
              isDomestic
              name
            }
            species {
              code
              id
              name
              isAvailable
            }
          }
        }
      }
    }`)

  module DeleteRequestItemsMeat = %relay(`
    mutation RfqBasketBuyer_DeleteRequestItemsMeat_Mutation(
      $id: ID!
      $connections: [ID!]!
    ) {
      deleteRfqRequestItemsMeat(id: $id) {
        ... on DeleteSuccess {
          deletedId @deleteEdge(connections: $connections)
        }
        ... on Error {
          message
          code
        }
      }
    }
    `)
}

module BasketListItems = {
  @react.component
  let make = (~id, ~isDomestic, ~handleClickListitem, ~selectedPartIds) => {
    let query = Query.MeatParts.use(
      ~variables={meatSpeciesIds: Some([id]), isDomestic: Some(isDomestic)},
      (),
    )

    <ul className=%twc("my-4") ariaMultiselectable=true>
      {query.meatParts.edges
      ->Array.map(({node}) => {
        let {name, id} = node
        let isSelected = selectedPartIds->Js.Array2.includes(id)

        <li
          key={id}
          className=%twc("flex items-center min-h-[48px] mx-5 cursor-pointer tab-highlight-color")
          onClick={_ => handleClickListitem(id)}
          ariaSelected=isSelected>
          <div className=%twc("flex flex-col justify-between truncate")>
            <span className=%twc("block text-base truncate text-text-L1")>
              {j`$name`->React.string}
            </span>
          </div>
          <div className=%twc("ml-auto pl-2")>
            {isSelected
              ? <DS_Icon.Common.CheckedLarge1 height="24" width="24" fill="#12B564" />
              : <DS_Icon.Common.UncheckedLarge1 height="24" width="24" fill="#12B564" />}
          </div>
        </li>
      })
      ->React.array}
    </ul>
  }
}

module Basket = {
  @react.component
  let make = (~requestId, ~from: option<string>) => {
    let router = Next.Router.useRouter()

    let (_, _, _, scrollY) = CustomHooks.Scroll.useScrollObserver(Px(50.0), ~sensitive=None)
    let isScrolled = scrollY >= 112.0

    React.useEffect0(_ => {
      DataGtm.push({"event": "Expose_view_RFQ_Livestock_SelectingPart"})
      None
    })

    let query = Query.MeatSpecies.use(
      ~variables={
        orderBy: Some(#PRIORITY),
      },
      (),
    )
    let {fragmentRefs} = Query.CurrentRequest.use(~variables={requestIds: Some([requestId])}, ())

    let (createRequestItemMeat, _) = Mutation.CreateRequestItemsMeat.use()
    let (deleteRequestItemMeat, _) = Mutation.DeleteRequestItemsMeat.use()

    let {data} = fragmentRefs->Fragment.RequestItemsMeat.usePagination

    let selectedPartIds =
      data.rfqRequestItemsMeat.edges
      ->Array.map(x => x.node.part)
      ->Array.keepMap(Garter.Fn.identity)
      ->Array.map(x => x.id)
    let selectedMeatsCountText = data.rfqRequestItemsMeat.edges->Array.length

    let meatSpicesDefaultDomestic = false
    let ((selectedId, selectedDomestic), setSelectedTab) = React.Uncurried.useState(_ => (
      query.meatSpecies.edges
      ->Garter.Array.first
      ->Option.mapWithDefault(`bWVhdC1zcGVjaWVzOkJFRUY=`, x => x.node.id),
      meatSpicesDefaultDomestic,
    ))

    let handleClickListitem = (meatPartId: string) => {
      let selectedItemMeat = data.rfqRequestItemsMeat.edges->Js.Array2.find(x =>
        switch x.node.part {
        | Some(part') => part'.id === meatPartId
        | None => false
        }
      )

      switch selectedItemMeat {
      | Some(selectedItemMeat) =>
        deleteRequestItemMeat(
          ~variables={
            id: selectedItemMeat.node.id,
            connections: [data.rfqRequestItemsMeat.__id],
          },
          (),
        )->ignore
      | None =>
        createRequestItemMeat(
          ~variables={
            status: #DRAFT,
            rfqRequestId: requestId,
            meatPartId: Some(meatPartId),
            meatSpeciesId: Some(selectedId),
            connections: [data.rfqRequestItemsMeat.__id],
          },
          (),
        )->ignore
      }
    }

    let getLabelCount = (speciesId, isDomestic) => {
      let count =
        data.rfqRequestItemsMeat.edges
        ->Array.map(x => x.node)
        ->Array.keep(x => x.species->Option.mapWithDefault(false, x => x.id === speciesId))
        ->Array.keep(x => x.part->Option.mapWithDefault(false, x => x.isDomestic === isDomestic))
        ->Array.length
      count > 0 ? Some(count->Js.String2.make) : None
    }

    let paddingClassName = isScrolled ? %twc("pt-[167px]") : %twc("pt-14")

    <div
      className={cx([
        paddingClassName,
        %twc("relative container max-w-3xl mx-auto min-h-screen sm:shadow-gl"),
      ])}>
      <DS_TopNavigation.Detail.Root>
        <DS_TopNavigation.Detail.Left>
          <a
            className=%twc("cursor-pointer")
            onClick={_ => {
              switch from {
              | Some(from') =>
                from' === "list" ? router->Next.Router.push(`/buyer/rfq`) : History.back()
              | _ => History.back()
              }
            }}>
            <DS_Icon.Common.ArrowLeftXLarge1 height="32" width="32" className=%twc("relative") />
          </a>
        </DS_TopNavigation.Detail.Left>
      </DS_TopNavigation.Detail.Root>
      {isScrolled
        ? React.null
        : <DS_Title.Normal1.Root className=%twc("pt-3")>
            <DS_Title.Normal1.TextGroup
              title1={`견적요청할 부위를`} title2={`선택해주세요`}
            />
          </DS_Title.Normal1.Root>}
      <section className={isScrolled ? %twc("sticky top-14 left-0") : %twc("mt-9")}>
        <DS_Tab.LeftTab.Root>
          {query.meatSpecies.edges
          ->Array.map(({node}) => {
            let {id, name} = node

            <React.Fragment key={id}>
              <DS_Tab.LeftTab.Item>
                <DS_Button.Tab.LeftTab1
                  onClick={_ => setSelectedTab(._ => (id, false))}
                  text={j`$name/수입`}
                  selected={selectedId === id && selectedDomestic === false}
                  labelNumber={getLabelCount(id, false)}
                />
              </DS_Tab.LeftTab.Item>
              <DS_Tab.LeftTab.Item>
                <DS_Button.Tab.LeftTab1
                  onClick={_ => setSelectedTab(._ => (id, true))}
                  text={j`$name/국내`}
                  selected={selectedId === id && selectedDomestic === true}
                  labelNumber={getLabelCount(id, true)}
                />
              </DS_Tab.LeftTab.Item>
            </React.Fragment>
          })
          ->React.array}
        </DS_Tab.LeftTab.Root>
      </section>
      <React.Suspense>
        <BasketListItems
          id={selectedId}
          isDomestic={selectedDomestic}
          handleClickListitem={handleClickListitem}
          selectedPartIds={selectedPartIds}
        />
      </React.Suspense>
      <div className=%twc("h-[104px]") />
      <DS_ButtonContainer.Floating1
        dataGtm={`Click_RFQ_Livestock_SelectingPart`}
        disabled={selectedMeatsCountText > 0 ? false : true}
        label={selectedMeatsCountText > 0
          ? j`$selectedMeatsCountText개 선택하기`
          : `선택하기`}
        onClick={_ =>
          router->Next.Router.push(`/buyer/rfq/request/draft/list?requestId=${requestId}`)}
      />
    </div>
  }
}

@react.component
let make = (~requestId: option<string>, ~from: option<string>) => {
  let router = Next.Router.useRouter()

  switch requestId {
  | Some(id) =>
    <Authorization.Buyer fallback={React.null} title=j`바이어 견적 요청`>
      <React.Suspense>
        <RfqCommon.CheckBuyerRequestStatus requestId={id}>
          <Basket requestId={id} from />
        </RfqCommon.CheckBuyerRequestStatus>
      </React.Suspense>
    </Authorization.Buyer>

  | None => {
      React.useEffect0(_ => {
        router->Next.Router.push("/buyer/rfq")
        None
      })
      React.null
    }
  }
}
