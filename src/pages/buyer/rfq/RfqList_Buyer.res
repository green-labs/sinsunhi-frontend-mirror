module Query = RfqBasket_Buyer.Query
module Fragment = RfqBasket_Buyer.Fragment
module Fragment_type = RfqBasketBuyer_RfqRequestItemsMeat_Fragment_graphql.Types
module Mutation = RfqBasket_Buyer.Mutation

type detail = [
  | #grade
  | #orderAmount
  | #usage
  | #storageMethod
  | #packageMethod
  | #supplyPrice
  | #brand
  | #etc
]

let displayStorageMethod = (v: Fragment_type.enum_RfqMeatStorageMethod) =>
  switch v {
  | #ANY => `모두`
  | #CHILLED => `냉장`
  | #FREEZE_DRIED => `동결`
  | #FROZEN => `냉동`
  | #OTHER => `그 외`
  | _ => ``
  }

let displayPackageMethod = (v: Fragment_type.enum_RfqMeatPackageMethod) =>
  switch v {
  | #ANY => `모두`
  | #CUT => `세절`
  | #OTHER => `그 외`
  | #RAW => `원료육(박스육)`
  | #SPLIT => `소분`
  | _ => ``
  }

let convertToString = v =>
  switch v {
  | #grade => `grade`
  | #orderAmount => `orderAmount`
  | #usage => `usage`
  | #storageMethod => `storageMethod`
  | #packageMethod => `packageMethod`
  | #supplyPrice => `supplyPrice`
  | #brand => `brand`
  | #etc => `etc`
  }

let numberToComma = n =>
  n
  ->Float.fromString
  ->Option.mapWithDefault("", x => Intl.Currency.make(~value=x, ~locale={"ko-KR"->Some}, ()))

module List = {
  module Item = {
    @react.component
    let make = (~title, ~value=?, ~onClick) => {
      <DS_ListItem.Normal1.Item key={UniqueId.make(~prefix={`rfq-items-`}, ())}>
        <DS_TitleList.Left.TitleSubtitle1
          title1={title} titleStyle=%twc("font-normal text-text-L2")
        />
        <DS_ListItem.Normal1.RightGroup>
          <DS_TitleList.Common.TextIcon1.Root onClick>
            {value->Option.mapWithDefault(React.null, value' =>
              <DS_TitleList.Common.TextIcon1.Text className=%twc("text-right word-keep-all")>
                {value'->React.string}
              </DS_TitleList.Common.TextIcon1.Text>
            )}
            <DS_TitleList.Common.TextIcon1.Icon>
              <DS_Icon.Common.ArrowRightLarge1 height="24" width="24" fill="#999999" />
            </DS_TitleList.Common.TextIcon1.Icon>
          </DS_TitleList.Common.TextIcon1.Root>
        </DS_ListItem.Normal1.RightGroup>
      </DS_ListItem.Normal1.Item>
    }
  }

  let getItemCountInfo = (items: array<Fragment_type.fragment_rfqRequestItemsMeat_edges_node>) => {
    let count = items->Array.length
    let readyCount = items->Array.keep(x => x.status === #READY_TO_REQUEST)->Array.length
    (readyCount, count, count !== 0 && count === readyCount)
  }

  @react.component
  let make = (~requestId) => {
    let router = Next.Router.useRouter()
    let {addToast} = ReactToastNotifications.useToasts()
    let queryData = Query.CurrentRequest.use(
      ~variables={requestIds: Some([requestId])},
      ~fetchPolicy={RescriptRelay.NetworkOnly},
      (),
    )
    let {data} = Fragment.RequestItemsMeat.usePagination(queryData.fragmentRefs)
    let (deleteRequestItemMeat, _) = Mutation.DeleteRequestItemsMeat.use()

    let arrItem = data.rfqRequestItemsMeat->Fragment.RequestItemsMeat.getConnectionNodes

    React.useEffect0(_ => {
      DataGtm.push({"event": "Expose_view_RFQ_Livestock_PartList"})
      None
    })

    let handleMove = itemId => {
      router->Next.Router.push(
        switch itemId {
        | Some(itemId') => `/buyer/rfq/request/draft/apply?itemId=${itemId'}&requestId=${requestId}`
        | None => `/buyer/rfq/request/draft/basket?requestId=${requestId}`
        },
      )
    }

    let handleMoveDetail = (itemId, step, _) => {
      router->Next.Router.push(
        `/buyer/rfq/request/draft/apply?itemId=${itemId}&requestId=${requestId}&step=${step->convertToString}`,
      )
    }

    let (completeItemCount, totalItemCount, isValidItems) = arrItem->getItemCountInfo

    let handleDeleteItem = (itemId, _) => {
      deleteRequestItemMeat(
        ~variables={
          id: itemId,
          connections: [data.rfqRequestItemsMeat.__id],
        },
        ~onCompleted={
          ({deleteRfqRequestItemsMeat}, _) => {
            switch deleteRfqRequestItemsMeat {
            | #DeleteSuccess(_) =>
              addToast(.
                `삭제되었습니다.`->DS_Toast.getToastComponent(#succ),
                {appearance: "success"},
              )
            | #UnselectedUnionMember(_)
            | #Error(_) =>
              addToast(.
                `요청 중 요류가 발생했습니다. 잠시 후 다시 시도해주세요.`->DS_Toast.getToastComponent(
                  #error,
                ),
                {appearance: "error"},
              )
            }
          }
        },
        (),
      )->ignore
    }
    <>
      <div
        className=%twc(
          "relative container max-w-3xl mx-auto min-h-screen sm:shadow-gl pt-11 bg-gray-50"
        )>
        <DS_TopNavigation.Detail.Root bgClassName={%twc("bg-gray-50")}>
          <DS_TopNavigation.Detail.Left>
            <a
              className=%twc("cursor-pointer")
              onClick={_ =>
                router->Next.Router.push(
                  `/buyer/rfq/request/draft/basket?requestId=${requestId}&from=list`,
                )}>
              <DS_Icon.Common.ArrowLeftXLarge1 height="32" width="32" className=%twc("relative") />
            </a>
          </DS_TopNavigation.Detail.Left>
        </DS_TopNavigation.Detail.Root>
        <div>
          <DS_Title.Normal1.Root className=%twc("mt-7")>
            <DS_Title.Normal1.TextGroup
              title1={`선택하신 상품의`} title2={`견적요청서를 작성해주세요`}
            />
          </DS_Title.Normal1.Root>
          <section className=%twc("mt-7")>
            <DS_ListItem.Normal1.Root>
              <DS_ListItem.Normal1.Item>
                <DS_ListItem.Normal1.TextGroup
                  title1={j`$completeItemCount개 작성 / $totalItemCount개`}
                  titleStyle=%twc("text-base leading-6 text-enabled-L2")
                />
                <DS_ListItem.Normal1.RightGroup>
                  <DS_TitleList.Common.TextIcon1.Root>
                    <DS_TitleList.Common.TextIcon1.Text
                      className=%twc("text-[13px] leading-5 text-enabled-L2")>
                      {`저장됨`->React.string}
                    </DS_TitleList.Common.TextIcon1.Text>
                    <DS_TitleList.Common.TextIcon1.Icon>
                      <DS_Icon.Common.LineCheckedMedium1 height="16" width="16" fill="#999999" />
                    </DS_TitleList.Common.TextIcon1.Icon>
                  </DS_TitleList.Common.TextIcon1.Root>
                </DS_ListItem.Normal1.RightGroup>
              </DS_ListItem.Normal1.Item>
            </DS_ListItem.Normal1.Root>
            <DS_Card.Infomation1.Root className=%twc("mt-9")>
              {arrItem
              ->Array.map(node => {
                let {id: itemId, part, species} = node
                <DS_Card.Infomation1.Content key={UniqueId.make(~prefix={`rfq-card-items-`}, ())}>
                  // MainList
                  <DS_Card.Infomation1.MainList
                    className=%twc("px-5 flex justify-between items-start cursor-pointer")
                    onClick={_ => handleMove(Some(itemId))}>
                    <DS_TitleList.Left.Title3Subtitle1
                      title1={species->Option.mapWithDefault("", x => x.shortName)}
                      title2={part->Option.mapWithDefault("", x => x.name)}
                      title3={part->Option.mapWithDefault(``, x =>
                        x.isDomestic ? `국내` : `수입`
                      )}
                    />
                    <div
                      onClick={e => {
                        e->ReactEvent.Synthetic.preventDefault
                        e->ReactEvent.Synthetic.stopPropagation
                      }}>
                      <DS_Dialog.Popup.Root>
                        <DS_Dialog.Popup.Trigger asChild=false>
                          <DataGtm dataGtm={`Delete_RFQ_Livestock_RequestList`}>
                            <div
                              className=%twc(
                                "flex justify-start items-center space-x-1 cursor-pointer"
                              )>
                              <DS_Icon.Common.DeleteMedium1 width="16" height="16" fill="#727272" />
                              <span
                                className=%twc("text-[13px] leading-5 text-enabled-L2 truncate")>
                                {`삭제`->React.string}
                              </span>
                            </div>
                          </DataGtm>
                        </DS_Dialog.Popup.Trigger>
                        <DS_Dialog.Popup.Portal>
                          <DS_Dialog.Popup.Overlay />
                          <DS_Dialog.Popup.Content>
                            <DS_Dialog.Popup.Title>
                              {`아래 부위를 삭제할까요?`->React.string}
                            </DS_Dialog.Popup.Title>
                            <DS_Dialog.Popup.Description>
                              {`${species->Option.mapWithDefault("", x =>
                                  x.shortName
                                )} / ${part->Option.mapWithDefault("", x =>
                                  x.name
                                )} / ${part->Option.mapWithDefault(``, x =>
                                  x.isDomestic ? `국내` : `수입`
                                )}`->React.string}
                            </DS_Dialog.Popup.Description>
                            <DS_Dialog.Popup.Buttons>
                              <DS_Dialog.Popup.Close asChild=true>
                                <DS_Button.Normal.Large1 buttonType=#white label={`아니오`} />
                              </DS_Dialog.Popup.Close>
                              <DS_Dialog.Popup.Close asChild=true>
                                <DS_Button.Normal.Large1
                                  label={`네`} onClick={handleDeleteItem(itemId)}
                                />
                              </DS_Dialog.Popup.Close>
                            </DS_Dialog.Popup.Buttons>
                          </DS_Dialog.Popup.Content>
                        </DS_Dialog.Popup.Portal>
                      </DS_Dialog.Popup.Root>
                    </div>
                  </DS_Card.Infomation1.MainList>
                  {
                    let isSkipGrade = switch (
                      node.species->Option.map(x => x.code),
                      node.part->Option.map(x => x.isDomestic),
                    ) {
                    | (Some(speciesCode'), Some(isDomestic')) =>
                      switch (speciesCode', isDomestic') {
                      | ("CHICKEN", _) => true
                      | ("PORK", false) => true
                      | _ => false
                      }
                    | _ => false
                    }

                    // SubList
                    switch node.grade->Option.isSome {
                    | false =>
                      <DataGtm dataGtm={`Input_RFQ_Livestock_RequestList`}>
                        <div
                          className=%twc("px-5 mt-5 flex justify-center cursor-pointer")
                          onClick={_ => handleMove(Some(itemId))}>
                          <span className=%twc("text-primary")>
                            {`상세 요청사항 입력하기`->React.string}
                          </span>
                          <DS_Icon.Common.ArrowRightLarge1 height="24" width="24" fill="#999999" />
                        </div>
                      </DataGtm>
                    | true =>
                      <DS_Card.Infomation1.SubList>
                        <DS_ListItem.Normal1.Root className=%twc("space-y-3.5")>
                          {node.packageMethod->Option.mapWithDefault(React.null, x =>
                            <Item
                              title={`포장상태`}
                              value={x->displayPackageMethod}
                              onClick={handleMoveDetail(itemId, #packageMethod)}
                            />
                          )}
                          {isSkipGrade
                            ? React.null
                            : node.grade->Option.mapWithDefault(React.null, x => <>
                                <Item
                                  title={`등급`}
                                  value={x.grade}
                                  onClick={handleMoveDetail(itemId, #grade)}
                                />
                              </>)}
                          {node.weightKg->Option.mapWithDefault(React.null, x =>
                            <Item
                              title={`주문량`}
                              value={`${x
                                ->Js.String2.split(".")
                                ->Garter_Array.firstExn
                                ->numberToComma} kg`}
                              onClick={handleMoveDetail(itemId, #orderAmount)}
                            />
                          )}
                          {switch node.usages.edges->Garter.Array.isEmpty {
                          | false =>
                            <Item
                              title={`사용용도`}
                              value={node.usages.edges->Array.map(edge => {
                                edge.node.name
                              }) |> Js.Array.joinWith(", ")}
                              onClick={handleMoveDetail(itemId, #usage)}
                            />
                          | true => React.null
                          }}
                          {node.storageMethod->Option.mapWithDefault(React.null, x => {
                            <Item
                              title={`보관상태`}
                              value={x->displayStorageMethod}
                              onClick={handleMoveDetail(itemId, #storageMethod)}
                            />
                          })}
                          {node.prevTradeSellerName === ""
                            ? React.null
                            : <Item
                                title={`기존공급처`}
                                value={node.prevTradeSellerName}
                                onClick={handleMoveDetail(itemId, #supplyPrice)}
                              />}
                          {node.prevTradePricePerKg->Option.mapWithDefault(React.null, x =>
                            <Item
                              title={`기존공급가`}
                              value={`${x->Int.toString->numberToComma}원/kg`}
                              onClick={handleMoveDetail(itemId, #supplyPrice)}
                            />
                          )}
                          {node.preferredBrand === ""
                            ? React.null
                            : <Item
                                title={`선호브랜드`}
                                value={node.preferredBrand}
                                onClick={handleMoveDetail(itemId, #brand)}
                              />}
                          {node.otherRequirements === ""
                            ? React.null
                            : <Item
                                title={`기타 요청사항`}
                                onClick={handleMoveDetail(itemId, #etc)}
                              />}
                        </DS_ListItem.Normal1.Root>
                      </DS_Card.Infomation1.SubList>
                    }
                  }
                </DS_Card.Infomation1.Content>
              })
              ->React.array}
            </DS_Card.Infomation1.Root>
            <DataGtm dataGtm={`Create_RFQ_Livestock_RequestList`}>
              <button
                onClick={_ => handleMove(None)}
                className=%twc(
                  "w-full py-3 flex justify-center items-center gap-1 leading-6 cursor-pointer mt-4 text-enabled-L2 pb-[104px] tab-highlight-color"
                )>
                <DS_Icon.Common.PlusSmall1 height="12" width="12" fill={"#727272"} />
                {`부위 추가 하기`->React.string}
              </button>
            </DataGtm>
          </section>
        </div>
      </div>
      <DS_ButtonContainer.Floating1
        dataGtm={`Click_RFQ_Livestock_PartList`}
        disabled={!isValidItems}
        label={`작성 완료`}
        onClick={_ =>
          router->Next.Router.push(`/buyer/rfq/request/draft/shipping?requestId=${requestId}`)}
      />
    </>
  }
}

@react.component
let make = (~requestId: option<string>) => {
  let router = Next.Router.useRouter()

  switch requestId {
  | Some(id) =>
    <Authorization.Buyer fallback={React.null} title={j`바이어 견적 요청`}>
      <React.Suspense fallback={<div />}>
        <RfqCommon.CheckBuyerRequestStatus requestId={id}>
          <List requestId={id} />
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
