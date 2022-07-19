module Query = %relay(`
  query RfqItemDetailBuyer_Current_Item_Query($id: ID!) {
    node(id: $id) {
      ... on RfqRequestItemMeat {
        id
        packageMethod
        otherRequirements
        prevTradePricePerKg
        preferredBrand
        status
        storageMethod
        updatedAt
        weightKg
        createdAt
        prevTradeSellerName
        part {
          id
          name
          isDomestic
        }
        grade {
          grade
        }
        usages {
          edges {
            node {
              name
              id
              isAvailable
            }
          }
        }
        request {
          deliveryAddress
          deliveryMethod
          desiredDeliveryDate
          deliveryCycle
        }
        selectedQuotations {
          edges {
            node {
              id
              deliveryFee
              brand
              pricePerKg
              price
              weightKg
              grade {
                grade
                id
              }
            }
          }
        }
      }
    }
  }
`)

module Mutation = {
  module CreateRfqOrder = %relay(`
   mutation RfqItemDetailBuyer_CreateRfqOrder_Mutation(
     $input: RfqOrderCreateInput!
   ) {
     createRfqOrder(input: $input) {
       ... on RfqOrderMutationPayload {
         result {
           quotation {
             requestItem {
               id
               status
             }
           }
         }
       }
       ... on Error {
         message
         code
       }
     }
   }`)
}

let numberToComma = n =>
  n
  ->Float.fromString
  ->Option.mapWithDefault("", x => Intl.Currency.make(~value=x, ~locale={"ko-KR"->Some}, ()))

let displayDeleveryMethod = v =>
  switch v {
  | #ANY => `상관없음`
  | #DIRECT_DELIVERY => `직접배송`
  | #OTHER => `기타`
  | #WAREHOUSE_PICKUP => `창고수령`
  | #WAREHOUSE_TRANSFER => `창고배송`
  | _ => `기타`
  }

let displayStorageMethod = v =>
  switch v {
  | #ANY => `모두`
  | #CHILLED => `냉장`
  | #FREEZE_DRIED => `동결`
  | #FROZEN => `냉동`
  | #OTHER => `그 외`
  | _ => ``
  }

let displayPackageMethod = v =>
  switch v {
  | #ANY => `모두`
  | #CUT => `세절`
  | #OTHER => `그 외`
  | #RAW => `원료육(박스육)`
  | #SPLIT => `소분`
  | _ => ``
  }

let openCustomerService = () => {
  switch Global.window {
  | Some(window') =>
    Global.Window.openLink(
      window',
      ~url=`${Env.customerServiceUrl}${Env.customerServicePaths["rfqContactManager"]}`,
      ~windowFeatures="",
      (),
    )
  | None => ()
  }
}

module Listitem = {
  module Normal = {
    @react.component
    let make = (~label, ~text) => {
      <li className=%twc("px-5 py-[14px]")>
        <div className=%twc("flex items-center")>
          <div className=%twc("flex flex-col justify-between word-keep-all")>
            <span className=%twc("block text-base text-text-L2")> {label->React.string} </span>
          </div>
          <div className=%twc("ml-auto pl-2 text-enabled-L1 font-bold text-right word-keep-all")>
            {text->React.string}
          </div>
        </div>
      </li>
    }
  }

  module Radio = {
    @react.component
    let make = (~label, ~priceText, ~isSelected, ~onClick) => {
      <li className=%twc("flex items-center min-h-[48px] px-5 py-4 cursor-pointer") onClick>
        <div className=%twc("flex flex-col justify-between truncate")>
          <span className=%twc("block truncate text-lg text-text-L1")> {label->React.string} </span>
          <span className=%twc("block text-sm truncate font-normal text-primary-variant")>
            {priceText->React.string}
          </span>
        </div>
        <div className=%twc("ml-auto pl-2")>
          {isSelected
            ? <DS_Icon.Common.RadioOnLarge1 height="24" width="24" fill={"#12B564"} />
            : <DS_Icon.Common.RadioOffLarge1 height="24" width="24" fill={"#B2B2B2"} />}
        </div>
      </li>
    }
  }

  module Quotation = {
    @react.component
    let make = (~label, ~text, ~bold=?, ~highlightContent=?) => {
      <li className=%twc("mx-5 my-[6px]")>
        <div className=%twc("flex items-center")>
          <div className=%twc("flex flex-col justify-between")>
            <span className=%twc("block text-base text-text-L2 word-keep-all")>
              {label->React.string}
            </span>
          </div>
          <div className=%twc("ml-auto pl-2 text-right")>
            <span
              className={bold->Option.mapWithDefault(%twc("text-enabled-L1 word-keep-all"), x =>
                x ? %twc("font-bold") : ``
              )}>
              {text->React.string}
            </span>
          </div>
        </div>
        {highlightContent->Option.mapWithDefault(React.null, x => {
          <div className=%twc("text-right text-primary-variant")> {x} </div>
        })}
      </li>
    }
  }
}

module Divider = {
  module Screen = {
    @react.component
    let make = () => <div className=%twc("h-3 bg-border-default-L2") />
  }

  module Card = {
    @react.component
    let make = () =>
      <li className=%twc("mx-5 py-[14px]")>
        <div className=%twc("border-b-2 border-gray-200") />
      </li>
  }

  module List = {
    @react.component
    let make = () =>
      <li className=%twc("mx-5 py-[14px]")>
        <div className=%twc("border-b-2 border-b-border-disabled") />
      </li>
  }
}

module ItemContent = {
  @react.component
  let make = (~item: RfqItemDetailBuyer_Current_Item_Query_graphql.Types.response_node) => {
    <div className=%twc("mt-7 mb-10")>
      <DS_Title.Normal1.Root className=%twc("mb-5")>
        <DS_Title.Normal1.TextGroup title1={`요청하신 내용`} />
      </DS_Title.Normal1.Root>
      <div className=%twc("py-[14px] mx-5 bg-gray-100 rounded-xl ")>
        <ul>
          {item.grade->Option.mapWithDefault(React.null, x =>
            <Listitem.Quotation label={`등급`} text={x.grade} />
          )}
          {item.weightKg->Option.mapWithDefault(React.null, x =>
            <Listitem.Quotation label={`주문양`} text={`${x->numberToComma}kg`} />
          )}
          {item.usages.edges->Garter.Array.isEmpty
            ? React.null
            : <Listitem.Quotation
                label={`사용용도`}
                text={item.usages.edges->Array.map(edge => {
                  edge.node.name
                }) |> Js.Array.joinWith(", ")}
              />}
          {item.storageMethod->Option.mapWithDefault(React.null, x =>
            <Listitem.Quotation label={`보관상태`} text={x->displayStorageMethod} />
          )}
          {item.packageMethod->Option.mapWithDefault(React.null, x =>
            <Listitem.Quotation label={`포장상태`} text={x->displayPackageMethod} />
          )}
          {item.preferredBrand === ""
            ? React.null
            : <Listitem.Quotation label={`선호브랜드`} text={item.preferredBrand} />}
          <Divider.Card />
          <Listitem.Quotation
            label={`납품 희망일자`}
            text={item.request.desiredDeliveryDate
            ->Js.Date.fromString
            ->DateFns.format("yyyy.MM.dd")}
          />
          <Listitem.Quotation
            label={`수령방식`} text={item.request.deliveryMethod->displayDeleveryMethod}
          />
          <Listitem.Quotation label={`배송지역`} text={item.request.deliveryAddress} />
          <Listitem.Quotation label={`정기 배송 여부`} text={item.request.deliveryCycle} />
          {item.otherRequirements === ``
            ? React.null
            : <>
                <Divider.Card />
                <li className=%twc("mx-5 my-[7px]")>
                  <div className=%twc("mb-2 truncate")>
                    <span className=%twc("block text-base truncate text-text-L2")>
                      {`요청 사항`->React.string}
                    </span>
                  </div>
                  <div className=%twc("ml-auto")>
                    <div className=%twc("w-full")> {item.otherRequirements->React.string} </div>
                  </div>
                </li>
              </>}
        </ul>
      </div>
    </div>
  }
}

module QuotationContent = {
  @react.component
  let make = (
    ~quotation: RfqItemDetailBuyer_Current_Item_Query_graphql.Types.response_node_selectedQuotations_edges,
    ~prevTradePricePerKg: option<int>,
  ) => {
    let {pricePerKg, price, weightKg, grade} = quotation.node

    let pricePerKgIntFloat = pricePerKg->Float.fromString
    let prevTradePricePerKgFloat = prevTradePricePerKg->Option.flatMap(x => Some(x->Float.fromInt))

    let lowCostPrice = switch (
      weightKg->Int.fromString,
      pricePerKg->Int.fromString,
      prevTradePricePerKg,
    ) {
    | (Some(weightKg'), Some(pricePerKg'), Some(prevTradePricePerKg')) => {
        let diffPrice = prevTradePricePerKg' * weightKg' - weightKg' * pricePerKg'
        Some(diffPrice / 10000)->Option.keep(x => x > 0)
      }

    | _ => None
    }
    let lowCostRate = switch (pricePerKgIntFloat, prevTradePricePerKgFloat) {
    | (Some(currentPrice), Some(prevPrice)) => {
        let rate = 1. -. currentPrice /. prevPrice
        Some((rate *. 100.)->Js.Math.floor_float)->Option.keep(x => x > 0.)
      }

    | _ => None
    }

    <div className=%twc("mt-9 mb-[22px]")>
      <ul>
        <Listitem.Quotation
          label={`총 금액`}
          bold=true
          text={`${price->Int.toString->numberToComma}원`}
          highlightContent={lowCostPrice->Option.mapWithDefault(React.null, x => <>
            <span> {`기존거래가 보다 `->React.string} </span>
            <span className=%twc("font-bold")>
              {`${x->Int.toString->numberToComma}만원 저렴`->React.string}
            </span>
          </>)}
        />
        <Divider.List />
        <Listitem.Quotation label={`등급`} text={grade.grade} />
        <Divider.List />
        <Listitem.Quotation
          label={`단가`}
          text={`${pricePerKg->numberToComma}원/kg`}
          highlightContent={lowCostRate->Option.mapWithDefault(React.null, x => <>
            <span> {`기존거래가 보다 `->React.string} </span>
            <span className=%twc("font-bold")>
              {`${x->Float.toString}% 저렴`->React.string}
            </span>
          </>)}
        />
        <Listitem.Quotation label={`주문양`} text={`${weightKg->numberToComma}kg`} />
      </ul>
    </div>
  }
}

module ConfirmButton = {
  @react.component
  let make = (
    ~item: RfqItemDetailBuyer_Current_Item_Query_graphql.Types.response_node,
    ~quotation: RfqItemDetailBuyer_Current_Item_Query_graphql.Types.response_node_selectedQuotations_edges,
  ) => {
    let {addToast} = ReactToastNotifications.useToasts()

    let (mutate, isMutating) = Mutation.CreateRfqOrder.use()
    let createOrder = _ => {
      let deliveryMethod = switch item.request.deliveryMethod {
      | #ANY => Some(#ANY)
      | #DIRECT_DELIVERY => Some(#DIRECT_DELIVERY)
      | #OTHER => Some(#OTHER)
      | #WAREHOUSE_PICKUP => Some(#WAREHOUSE_PICKUP)
      | #WAREHOUSE_TRANSFER => Some(#WAREHOUSE_TRANSFER)
      | _ => None
      }

      switch deliveryMethod {
      | Some(deliveryMethod') =>
        mutate(
          ~variables={
            input: {quotationId: quotation.node.id, deliveryMethod: deliveryMethod'},
          },
          ~onCompleted=({createRfqOrder}, _) =>
            switch createRfqOrder {
            | #RfqOrderMutationPayload(_) =>
              addToast(.
                `발주 요청이 완료되었습니다.`->DS_Toast.getToastComponent(#succ),
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
      | None => ()
      }
    }

    <>
      <DS_Dialog.Popup.Root>
        <DS_Dialog.Popup.Trigger asChild=true>
          <DS_ButtonContainer.Floating1
            label={`주문하기`}
            onClick={_ =>
              DataGtm.push({"event": "Expose_view_RFQ_Livestock_Quotation_Detail_Check_Popup"})}
          />
        </DS_Dialog.Popup.Trigger>
        <DS_Dialog.Popup.Portal>
          <DS_Dialog.Popup.Overlay />
          <DS_Dialog.Popup.Content>
            <DS_Dialog.Popup.Title>
              {`주문하시겠어요?`->React.string}
            </DS_Dialog.Popup.Title>
            <DS_Dialog.Popup.Description>
              <span className=%twc("block")>
                <span> {item.part->Option.mapWithDefault(``, x => x.name)->React.string} </span>
                <span> {` / `->React.string} </span>
                <span>
                  {item.part
                  ->Option.mapWithDefault(``, x => x.isDomestic ? `국내` : `수입`)
                  ->React.string}
                </span>
              </span>
              <span className=%twc("block")> {quotation.node.grade.grade->React.string} </span>
              <span className=%twc("block")>
                {`${quotation.node.pricePerKg->numberToComma}원/kg`->React.string}
              </span>
              <span className=%twc("block")>
                {`총 금액:${quotation.node.price->Int.toString->numberToComma}원`->React.string}
              </span>
            </DS_Dialog.Popup.Description>
            <DS_Dialog.Popup.Buttons>
              <DS_Dialog.Popup.Close asChild=true>
                <DS_Button.Normal.Large1 buttonType=#white label={`아니오`} />
              </DS_Dialog.Popup.Close>
              <DS_Dialog.Popup.Close asChild=true>
                <DataGtm dataGtm={`Click_Yes_RFQ_Livestock_Quotation_Detail_Check_Popup`}>
                  <div onClick={_ => ()} className=%twc("w-full")>
                    <DS_Button.Normal.Large1
                      label={`네`} onClick={createOrder} disabled={isMutating}
                    />
                  </div>
                </DataGtm>
              </DS_Dialog.Popup.Close>
            </DS_Dialog.Popup.Buttons>
          </DS_Dialog.Popup.Content>
        </DS_Dialog.Popup.Portal>
      </DS_Dialog.Popup.Root>
    </>
  }
}

module ConfirmContent = {
  module Drawer = {
    @react.component
    let make = (~item: RfqItemDetailBuyer_Current_Item_Query_graphql.Types.response_node) => {
      let (isDrawerShow, setDrawerShow) = React.Uncurried.useState(_ => false)
      let (selectedQuotation, setSelectedQuotation) = React.Uncurried.useState(_ =>
        item.selectedQuotations.edges->Garter.Array.first
      )
      let togglePopup = _ => {
        if isDrawerShow === false {
          DataGtm.push({"event": "Click_Order_RFQ_Livestock_Quotation_Detail"})
        }
        setDrawerShow(._ => !isDrawerShow)
      }

      let titleText =
        item.part->Option.mapWithDefault(``, part =>
          `${part.name}/${part.isDomestic ? `국내` : `수입`}`
        )

      <>
        <DS_ButtonContainer.Floating1 label={`주문하기`} onClick={togglePopup} />
        <DS_BottomDrawer.Root isShow=isDrawerShow onClose={togglePopup}>
          <DS_BottomDrawer.Header />
          <DS_BottomDrawer.Body>
            <DS_Title.Normal1.Root className=%twc("mb-8")>
              <DS_Title.Normal1.TextGroup
                title1={`${titleText}의`} title2={`희망상품을 선택해주세요`}
              />
            </DS_Title.Normal1.Root>
            <ul className=%twc("pb-[96px] overflow-y-auto")>
              {item.selectedQuotations.edges
              ->Array.map(x => {
                <Listitem.Radio
                  key={x.node.grade.id}
                  label={x.node.grade.grade}
                  priceText={`${x.node.pricePerKg->numberToComma}원/kg`}
                  onClick={_ => setSelectedQuotation(._ => Some(x))}
                  isSelected={selectedQuotation->Option.flatMap(x => Some(x.node.id)) ===
                    Some(x.node.id)}
                />
              })
              ->React.array}
            </ul>
            {switch selectedQuotation {
            | Some(quotation) => <ConfirmButton item quotation />
            | None => React.null
            }}
          </DS_BottomDrawer.Body>
        </DS_BottomDrawer.Root>
      </>
    }
  }
}

module Scene = {
  module Ordered = {
    @react.component
    let make = (~item: RfqItemDetailBuyer_Current_Item_Query_graphql.Types.response_node) => {
      let titleText =
        item.part->Option.mapWithDefault(`요청 내용`, part =>
          `${part.name} / ${part.isDomestic ? `국내` : `수입`}`
        )

      <>
        <div
          className=%twc(
            "relative container max-w-3xl mx-auto min-h-screen sm:shadow-gl pt-14 pb-[96px] bg-white"
          )>
          <DS_TopNavigation.Detail.Root>
            <DS_TopNavigation.Detail.Left>
              <a className=%twc("cursor-pointer") onClick={_ => History.back()}>
                <DS_Icon.Common.ArrowLeftXLarge1
                  height="32" width="32" className=%twc("relative")
                />
              </a>
            </DS_TopNavigation.Detail.Left>
            <DS_TopNavigation.Detail.Center>
              {titleText->React.string}
            </DS_TopNavigation.Detail.Center>
          </DS_TopNavigation.Detail.Root>
          <DS_Title.Normal1.Root className=%twc("mt-10 mb-14")>
            <DS_Title.Normal1.TextGroup
              title1={`주문이 요청되었습니다.`}
              subTitle={`담당자가 영업일 기준 24시간 이내에\n연락드릴 예정입니다.`}
            />
          </DS_Title.Normal1.Root>
          <div className=%twc("mx-5")>
            <DS_TitleList.Left.Title2Subtitle1
              titleStyle=%twc("text-xl font-bold")
              title1={item.part->Option.mapWithDefault("", x => x.name)}
              title2={item.part->Option.mapWithDefault(``, x => x.isDomestic ? `국내` : `수입`)}
            />
          </div>
          {switch item.selectedQuotations.edges->Garter.Array.first {
          | Some(quotation') =>
            <QuotationContent
              quotation={quotation'} prevTradePricePerKg={item.prevTradePricePerKg}
            />
          | None => React.null
          }}
          <Divider.Screen />
          <ItemContent item />
          <DS_ButtonContainer.Floating1
            buttonType=#white
            label={`담당자에게 문의하기`}
            onClick={_ => openCustomerService()}
          />
        </div>
      </>
    }
  }

  module OrderTimeout = {
    @react.component
    let make = (~item: RfqItemDetailBuyer_Current_Item_Query_graphql.Types.response_node) => {
      let router = Next.Router.useRouter()
      let titleText =
        item.part->Option.mapWithDefault(`요청 내용`, part =>
          `${part.name} / ${part.isDomestic ? `국내` : `수입`}`
        )
      <div
        className=%twc(
          "relative container max-w-3xl mx-auto min-h-screen sm:shadow-gl pt-14 pb-[96px] bg-white"
        )>
        <DS_TopNavigation.Detail.Root>
          <DS_TopNavigation.Detail.Left>
            <a className=%twc("cursor-pointer") onClick={_ => History.back()}>
              <DS_Icon.Common.ArrowLeftXLarge1 height="32" width="32" className=%twc("relative") />
            </a>
          </DS_TopNavigation.Detail.Left>
          <DS_TopNavigation.Detail.Center>
            {titleText->React.string}
          </DS_TopNavigation.Detail.Center>
        </DS_TopNavigation.Detail.Root>
        <DS_Title.Normal1.Root className=%twc("mt-10 mb-14")>
          <DS_Title.Normal1.TextGroup
            title1={`만료된 견적서입니다.`}
            subTitle={`견적요청 기간이 만료되었습니다.\n새로 견적서를 작성해주세요.`}
          />
        </DS_Title.Normal1.Root>
        <DS_ButtonContainer.Floating1
          label={`신규 견적서 작성하기`}
          onClick={_ => router->Next.Router.push(`/buyer/rfq/`)}
        />
      </div>
    }
  }

  module WaitingForOrder = {
    @react.component
    let make = (~item: RfqItemDetailBuyer_Current_Item_Query_graphql.Types.response_node) => {
      let isGradeFree = item.grade->Option.keep(x => x.grade === `등급무관`)->Option.isSome

      let (currentQuotation, setCurrentQuotation) = React.Uncurried.useState(_ => {
        item.selectedQuotations.edges->Garter.Array.first
      })

      <>
        <div
          className=%twc(
            "relative container max-w-3xl mx-auto min-h-screen sm:shadow-gl pt-14 pb-[96px] bg-white"
          )>
          <DS_TopNavigation.Detail.Root>
            <DS_TopNavigation.Detail.Left>
              <a className=%twc("cursor-pointer") onClick={_ => History.back()}>
                <DS_Icon.Common.ArrowLeftXLarge1
                  height="32" width="32" className=%twc("relative")
                />
              </a>
            </DS_TopNavigation.Detail.Left>
          </DS_TopNavigation.Detail.Root>
          <DS_Title.Normal1.Root className=%twc("mt-7 mb-14")>
            <DS_Title.Normal1.TextGroup
              title1={`견적서가 도착했어요`}
              subTitle={`최저가로 정기 배송이 가능합니다.`}
            />
          </DS_Title.Normal1.Root>
          <div className=%twc("mx-5")>
            <DS_TitleList.Left.Title2Subtitle1
              titleStyle=%twc("text-xl font-bold")
              title1={item.part->Option.mapWithDefault("", x => x.name)}
              title2={item.part->Option.mapWithDefault(``, x => x.isDomestic ? `국내` : `수입`)}
            />
          </div>
          {isGradeFree
            ? <div className=%twc("mt-5")>
                <div
                  className=%twc(
                    "DS_tab_leftTab flex flex-row items-center gap-5 whitespace-nowrap overflow-x-auto h-11 px-5 text-lg text-gray-300"
                  )>
                  {item.selectedQuotations.edges
                  ->Array.map(x => {
                    let isSelected =
                      Some(x.node.id) === currentQuotation->Option.flatMap(x => Some(x.node.id))
                    <DS_Tab.LeftTab.Item key={x.node.grade.id}>
                      <DS_Button.Chip.TextSmall1
                        className=%twc("text-sm")
                        label={x.node.grade.grade}
                        onClick={_ => setCurrentQuotation(._ => Some(x))}
                        selected=isSelected
                      />
                    </DS_Tab.LeftTab.Item>
                  })
                  ->React.array}
                </div>
              </div>
            : React.null}
          {switch currentQuotation {
          | Some(quotation') =>
            <QuotationContent
              quotation={quotation'} prevTradePricePerKg={item.prevTradePricePerKg}
            />
          | None => React.null
          }}
          <Divider.Screen />
          <ItemContent item />
        </div>
        {isGradeFree
          ? <ConfirmContent.Drawer item />
          : {
              switch currentQuotation {
              | Some(quotation) => <ConfirmButton item quotation />
              | None => React.null
              }
            }}
      </>
    }
  }

  module MatchFailed = {
    @react.component
    let make = (~item: RfqItemDetailBuyer_Current_Item_Query_graphql.Types.response_node) => {
      let titleText =
        item.part->Option.mapWithDefault(`요청 내용`, part =>
          `${part.name} / ${part.isDomestic ? `국내` : `수입`}`
        )
      <div
        className=%twc(
          "relative container max-w-3xl mx-auto min-h-screen sm:shadow-gl pt-14 pb-[96px] bg-white"
        )>
        <DS_TopNavigation.Detail.Root>
          <DS_TopNavigation.Detail.Left>
            <a className=%twc("cursor-pointer") onClick={_ => History.back()}>
              <DS_Icon.Common.ArrowLeftXLarge1 height="32" width="32" className=%twc("relative") />
            </a>
          </DS_TopNavigation.Detail.Left>
          <DS_TopNavigation.Detail.Center>
            {titleText->React.string}
          </DS_TopNavigation.Detail.Center>
        </DS_TopNavigation.Detail.Root>
        <DS_Title.Normal1.Root className=%twc("mt-10 mb-14")>
          <DS_Title.Normal1.TextGroup
            title1={`들어온 견적서가 없습니다`}
            subTitle={`궁금하신점은 담당자에게 문의해주세요.`}
          />
        </DS_Title.Normal1.Root>
        <DS_ButtonContainer.Floating1
          buttonType=#white
          label={`담당자에게 문의하기`}
          onClick={_ => openCustomerService()}
        />
      </div>
    }
  }

  module WaitingQuotation = {
    @react.component
    let make = (~item: RfqItemDetailBuyer_Current_Item_Query_graphql.Types.response_node) => {
      <div
        className=%twc(
          "relative container max-w-3xl mx-auto min-h-screen sm:shadow-gl pt-14 bg-white"
        )>
        <DS_TopNavigation.Detail.Root>
          <DS_TopNavigation.Detail.Left>
            <a className=%twc("cursor-pointer") onClick={_ => History.back()}>
              <DS_Icon.Common.ArrowLeftXLarge1 height="32" width="32" className=%twc("relative") />
            </a>
          </DS_TopNavigation.Detail.Left>
          <DS_TopNavigation.Detail.Center>
            {`요청 내용`->React.string}
          </DS_TopNavigation.Detail.Center>
        </DS_TopNavigation.Detail.Root>
        {item.part->Option.mapWithDefault(React.null, x =>
          <div className=%twc("mx-5 mt-14 mb-[16px]")>
            <DS_TitleList.Left.Title2Subtitle1
              titleStyle=%twc("text-xl font-bold")
              title1={x.name}
              title2={x.isDomestic ? `국내` : `수입`}
            />
          </div>
        )}
        <ul>
          {item.grade->Option.mapWithDefault(React.null, x =>
            <Listitem.Normal label={`등급`} text={x.grade} />
          )}
          {item.weightKg->Option.mapWithDefault(React.null, x =>
            <Listitem.Normal label={`주문양`} text={`${x->numberToComma}kg`} />
          )}
          {item.usages.edges->Garter.Array.isEmpty
            ? React.null
            : <Listitem.Normal
                label={`사용용도`}
                text={item.usages.edges->Array.map(edge => {
                  edge.node.name
                }) |> Js.Array.joinWith(", ")}
              />}
          {item.storageMethod->Option.mapWithDefault(React.null, x =>
            <Listitem.Normal label={`보관상태`} text={x->displayStorageMethod} />
          )}
          {item.packageMethod->Option.mapWithDefault(React.null, x =>
            <Listitem.Normal label={`포장상태`} text={x->displayPackageMethod} />
          )}
          {item.prevTradeSellerName === ""
            ? React.null
            : <Listitem.Normal label={`기존공급처`} text={item.prevTradeSellerName} />}
          {item.prevTradePricePerKg->Option.mapWithDefault(React.null, x =>
            <Listitem.Normal
              label={`기존공급가`} text={`${x->Int.toString->numberToComma}원/kg`}
            />
          )}
          {item.preferredBrand === ""
            ? React.null
            : <Listitem.Normal label={`선호브랜드`} text={item.preferredBrand} />}
        </ul>
      </div>
    }
  }

  module Canceled = {
    @react.component
    let make = (~item: RfqItemDetailBuyer_Current_Item_Query_graphql.Types.response_node) => {
      let router = Next.Router.useRouter()
      let titleText =
        item.part->Option.mapWithDefault(`요청 내용`, part =>
          `${part.name} / ${part.isDomestic ? `국내` : `수입`}`
        )

      <div
        className=%twc(
          "relative container max-w-3xl mx-auto min-h-screen sm:shadow-gl pt-14 pb-[96px] bg-white"
        )>
        <DS_TopNavigation.Detail.Root>
          <DS_TopNavigation.Detail.Left>
            <a className=%twc("cursor-pointer") onClick={_ => History.back()}>
              <DS_Icon.Common.ArrowLeftXLarge1 height="32" width="32" className=%twc("relative") />
            </a>
          </DS_TopNavigation.Detail.Left>
          <DS_TopNavigation.Detail.Center>
            {titleText->React.string}
          </DS_TopNavigation.Detail.Center>
        </DS_TopNavigation.Detail.Root>
        <DS_Title.Normal1.Root className=%twc("mt-10 mb-14")>
          <DS_Title.Normal1.TextGroup
            title1={`취소한 견적서입니다.`}
            subTitle={`취소처리된 견적서입니다.\n새로 견적서를 작성해주세요.`}
          />
        </DS_Title.Normal1.Root>
        <DS_ButtonContainer.Floating1
          label={`신규 견적서 작성하기`}
          onClick={_ => router->Next.Router.push(`/buyer/rfq/`)}
        />
      </div>
    }
  }

  module NotFound = {
    @react.component
    let make = () => {
      let router = Next.Router.useRouter()

      <div
        className=%twc(
          "relative container max-w-3xl mx-auto min-h-screen sm:shadow-gl pt-14 pb-[96px] bg-white"
        )>
        <DS_TopNavigation.Detail.Root>
          <DS_TopNavigation.Detail.Left>
            <a className=%twc("cursor-pointer") onClick={_ => History.back()}>
              <DS_Icon.Common.ArrowLeftXLarge1 height="32" width="32" className=%twc("relative") />
            </a>
          </DS_TopNavigation.Detail.Left>
        </DS_TopNavigation.Detail.Root>
        <DS_Title.Normal1.Root className=%twc("mt-7 mb-14")>
          <DS_Title.Normal1.TextGroup
            title1={`잘못된 요청입니다.`}
            subTitle={`해당 견적서를 찾을 수 없습니다.`}
          />
        </DS_Title.Normal1.Root>
        <DS_ButtonContainer.Floating1
          label={`신규 견적서 작성하기`}
          onClick={_ => router->Next.Router.push(`/buyer/rfq/`)}
        />
      </div>
    }
  }
}

module Detail = {
  @react.component
  let make = (~itemId) => {
    let {node} = Query.use(~variables={id: itemId}, ~fetchPolicy=NetworkOnly, ())

    React.useEffect0(_ => {
      DataGtm.push({"event": "Expose_view_RFQ_Livestock_Quotation_Detail"})
      None
    })

    switch node {
    | Some(item) =>
      switch item.status {
      | #ORDERED => <Scene.Ordered item={item} />
      | #ORDER_TIMEOUT => <Scene.OrderTimeout item={item} />
      | #REQUEST_CANCELED => <Scene.Canceled item={item} />
      | #WAITING_FOR_ORDER => <Scene.WaitingForOrder item={item} />
      | #MATCH_FAILED => <Scene.MatchFailed item={item} />
      | #READY_TO_REQUEST
      | #WAITING_FOR_QUOTATION =>
        <Scene.WaitingQuotation item={item} />
      | #DRAFT
      | _ =>
        <Scene.NotFound />
      }
    | None => <Scene.NotFound />
    }
  }
}

@react.component
let make = (~itemId: option<string>) => {
  let router = Next.Router.useRouter()

  // Todo - item id를 바탕으로 자신의 item인지 확인하는 검증 로직 필요
  switch itemId {
  | Some(id) =>
    <Authorization.Buyer fallback={React.null} title={j`견적서 확인하기`}>
      <Detail itemId={id} />
    </Authorization.Buyer>

  | None => {
      React.useEffect0(_ => {
        router->Next.Router.replace("/buyer/rfq")
        None
      })
      React.null
    }
  }
}
