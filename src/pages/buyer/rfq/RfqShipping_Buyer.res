module Query = {
  module RfqNextAcceptableDeliveryDate = %relay(`
    query RfqShippingBuyer_RfqNextAcceptableDeliveryDate_Query {
      rfqNextAcceptableDeliveryDate {
        date
      }
    }
  `)

  module RfqTerms = %relay(`
    query RfqShippingBuyer_RfqTerms_Query {
      terms {
        edges {
          node {
            id
            agreement
          }
        }
      }
    }
  `)

  module Holidays = %relay(`
    query RfqShippingBuyer_Holidays_Query($startDate: Date!, $endDate: Date!) {
      holidays(startDate: $startDate, endDate: $endDate) {
        date
        name
      }
    }
  `)
}

module Mutation = {
  module UpdateDeliveryAddress = %relay(`
    mutation RfqShippingBuyer_UpdateDeliveryAddress_Mutation(
      $id: ID!
      $input: RfqRequestUpdateInput!
    ) {
      updateRfqRequest(id: $id, input: $input) {
        ... on RfqRequestMutationPayload {
          result {
            id
            status
          }
        }
        ... on Error {
          message
          code
        }
      }
    }
  `)
  module UpdateTermAgreement = %relay(`
    mutation RfqShippingBuyer_UpdateTermAgreement_Mutation($agreement: String!) {
      createTerm(input: { agreement: $agreement }) {
        __typename
        ... on Error {
          message
          code
        }
        ... on TermMutationPayload {
          result {
            id
            agreement
          }
        }
      }
    }
  `)
}

let convertNumberInputValue = value =>
  value->Js.String2.replaceByRe(%re("/[^0-9]/g"), "")->Js.String2.replaceByRe(%re("/^[0]/g"), "")

module TriggerListitem = {
  @react.component
  let make = (~leftText, ~rightText, ~hasDivider=true) => {
    <li
      className={Cx.cx([
        %twc("flex items-center min-h-[56px] mx-5 cursor-pointer"),
        hasDivider ? %twc("border-b-2 border-b-border-disabled") : %twc(""),
      ])}>
      <div className=%twc("flex flex-col justify-between truncate")>
        <span className=%twc("block text-base truncate text-text-L1")>
          {leftText->React.string}
        </span>
      </div>
      <div className=%twc("ml-auto pl-2")>
        <div className=%twc("flex")>
          <span> {rightText->React.string} </span>
          <DS_Icon.Common.ArrowRightLarge1
            height="24" width="24" className=%twc("accordian-icon-degree-90") fill={"#999999"}
          />
        </div>
      </div>
    </li>
  }
}

module CalendarListitem = {
  @react.component
  let make = (
    ~leftText,
    ~currentDate,
    ~handleChangeDate,
    ~minDate,
    ~maxDate,
    ~holidays: array<RfqShippingBuyer_Holidays_Query_graphql.Types.response_holidays>,
  ) => {
    let checkHolidays = (e: Js.Date.t) => {
      let date = e->DateFns.format("yyyy-MM-dd")
      let h = holidays->Array.map(x => x.date)
      h->Js.Array2.includes(date)
    }

    let checkWeekend = (e: Js.Date.t) => {
      e->Js.Date.getDay === 0. || e->Js.Date.getDay === 6.
    }

    <li
      className=%twc(
        "flex items-center min-h-[56px] mx-5 cursor-pointer border-b-2 border-b-border-disabled"
      )>
      <div className=%twc("flex flex-col justify-between truncate")>
        <span className=%twc("block text-base truncate text-text-L1")>
          {leftText->React.string}
        </span>
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
            checkHolidays(e) || checkWeekend(e)
          }}
          minDate={minDate->DateFns.format("yyyy-MM-dd")}
          maxDate={maxDate->DateFns.format("yyyy-MM-dd")}
          firstDayOfWeek=0
        />
      </div>
    </li>
  }
}

type deliveryMethod = {method: string, title: string, text: string}
module DeliveryMethodContent = {
  @react.component
  let make = (~currentDeliveryMethod, ~handleChangeDeliveryMethod) => {
    let datas = [
      {
        method: "WAREHOUSE_TRANSFER",
        title: `????????????`,
        text: `???????????? ??????????????? ????????? ??????????????????`,
      },
      {
        method: "DIRECT_DELIVERY",
        title: `????????????`,
        text: `???????????? ???????????????`,
      },
      {
        method: "WAREHOUSE_PICKUP",
        title: `????????????`,
        text: `?????? ????????? ????????? ???????????? ???????????????`,
      },
    ]

    <ul>
      {datas
      ->Array.mapWithIndex((index, data) => {
        let isSelected = data.method === currentDeliveryMethod.method
        <li
          key={index->Int.toString}
          className=%twc("bg-surface flex items-center min-h-[48px] px-5 py-4 cursor-pointer ")
          onClick={_ => handleChangeDeliveryMethod(._ => data)}>
          <div className=%twc("flex flex-col justify-between truncate")>
            <span className=%twc("block text-base truncate text-text-L1 font-bold")>
              {data.title->React.string}
            </span>
            <span className=%twc("block text-base truncate  font-normal text-text-L2")>
              {data.text->React.string}
            </span>
          </div>
          <div className=%twc("ml-auto pl-2")>
            {isSelected
              ? <DS_Icon.Common.RadioOnLarge1 height="24" width="24" fill={"#12B564"} />
              : <DS_Icon.Common.RadioOffLarge1 height="24" width="24" fill={"#B2B2B2"} />}
          </div>
        </li>
      })
      ->React.array}
    </ul>
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
                  {`????????? ????????? ?????????????????????.`->React.string}
                </h1>
                <span className=%twc("mt-4 text-gray-800")>
                  {`???????????? ???????????? ?????? ????????? ?????????????????????.`->React.string}
                </span>
                <span className=%twc("text-gray-800")>
                  {`?????? ??? ???????????? ?????????.`->React.string}
                </span>
              </contents>
            </div>}>
          <SearchAddress onComplete isShow />
        </RescriptReactErrorBoundary>
      </DS_BottomDrawer.Body>
    </DS_BottomDrawer.Root>
  }
}

module AddressButton = {
  @react.component
  let make = (~leftText, ~rightText, ~handleClick) => {
    <li
      onClick={handleClick}
      className=%twc(
        "flex items-center min-h-[56px] mx-5 cursor-pointer border-b-2 border-b-border-disabled"
      )>
      <div className=%twc("flex flex-col justify-between truncate")>
        <span className=%twc("block text-base truncate text-text-L1")>
          {leftText->React.string}
        </span>
      </div>
      <div className=%twc("ml-auto pl-2")>
        <div className=%twc("flex")>
          <span> {rightText->React.string} </span>
          <DS_Icon.Common.ArrowRightLarge1 height="24" width="24" fill={"#999999"} />
        </div>
      </div>
    </li>
  }
}

module DeliveryCycleContent = {
  @react.component
  let make = (~currentDeliveryCycle, ~handleChangeDeliveryCycle) => {
    let arr = [
      {
        "key": `once`,
        "text": `??? ??? (1??? ??????)`,
        "value": `??? ??? (1??? ??????)`,
        "dayCount": `1`,
      },
      {
        "key": `1week`,
        "text": `1?????? ??? ???`,
        "value": `1?????? ??? ???`,
        "dayCount": `7`,
      },
      {
        "key": `2week`,
        "text": `2?????? ??? ???`,
        "value": `2?????? ??? ???`,
        "dayCount": `14`,
      },
      {
        "key": `3week`,
        "text": `3?????? ??? ???`,
        "value": `3?????? ??? ???`,
        "dayCount": `21`,
      },
      {
        "key": `1month`,
        "text": `1????????? ??? ???`,
        "value": `1????????? ??? ???`,
        "dayCount": `30`,
      },
      {
        "key": `2month`,
        "text": `2????????? ??? ???`,
        "value": `2????????? ??? ???`,
        "dayCount": `60`,
      },
      {
        "key": `3month`,
        "text": `3????????? ??? ???`,
        "value": `3????????? ??? ???`,
        "dayCount": `90`,
      },
    ]

    <div className=%twc("bg-surface")>
      {arr
      ->Array.map(data => {
        let isSelected = currentDeliveryCycle["key"] === data["key"]
        <React.Fragment key={data["key"]}>
          <li
            className=%twc("flex py-4 items-center min-h-[48px] px-5 cursor-pointer ")
            onClick={_ => handleChangeDeliveryCycle(._ => data)}>
            <div className=%twc("flex flex-col justify-between truncate")>
              <span className=%twc("block text-base truncate text-text-L1")>
                {data["text"]->React.string}
              </span>
            </div>
            <div className=%twc("ml-auto pl-2")>
              {isSelected
                ? <DS_Icon.Common.RadioOnLarge1 height="24" width="24" fill={"#12B564"} />
                : <DS_Icon.Common.RadioOffLarge1 height="24" width="24" fill={"#B2B2B2"} />}
            </div>
          </li>
        </React.Fragment>
      })
      ->React.array}
    </div>
  }
}

module Shipping = {
  @react.component
  let make = (~requestId) => {
    CustomHooks.useSmoothScroll()

    let router = Next.Router.useRouter()
    let {addToast} = ReactToastNotifications.useToasts()

    React.useEffect0(_ => {
      DataGtm.push({"event": "Expose_view_RFQ_Livestock_ShippingInfo"})
      None
    })

    let {terms} = Query.RfqTerms.use(~variables=(), ())
    let {
      rfqNextAcceptableDeliveryDate: {date: minDateString},
    } = Query.RfqNextAcceptableDeliveryDate.use(~variables=(), ())

    let isTermAgree =
      terms.edges->Array.map(x => x.node.agreement)->Array.keep(x => x === `rfq`)->Array.length > 0

    let minDate = minDateString->Js.Date.fromString
    let maxDate = minDate->DateFns.addDays(30)
    let maxDateString = maxDate->DateFns.format("yyyy-MM-dd")

    let {holidays} = Query.Holidays.use(
      ~variables={
        startDate: minDateString,
        endDate: maxDateString,
      },
      (),
    )

    let (updateRfqRequest, isMutating) = Mutation.UpdateDeliveryAddress.use()
    let (updateTermAgreement, _) = Mutation.UpdateTermAgreement.use()

    let (isAddressDrawerShow, setIsAddressDrawerShow) = React.Uncurried.useState(_ => false)
    let (selectedDeliveryDate, setSelectedDeliveryDate) = React.Uncurried.useState(_ => None)
    let (selectedDeliveryMethod, setSelectedDeliveryMethod) = React.Uncurried.useState(_ => {
      method: "",
      title: `??????????????????`,
      text: ``,
    })
    let (deliveryCycle, setDeliveryCycle) = React.Uncurried.useState(_ =>
      {"key": `none`, "text": `??????????????????`, "value": "", "dayCount": ``}
    )
    let (deliveryAddress, setDeliveryAddress) = React.Uncurried.useState(_ => ``)
    let (isAgreedPrivacyPolicy, setIsAgreedPrivacyPolicy) = React.Uncurried.useState(_ => false)

    let deliveryMethodRef = React.useRef(Js.Nullable.null)
    let deliveryCycleRef = React.useRef(Js.Nullable.null)

    let scrollToTargetItem = (text: string) => {
      let moveScroll = (el: Dom.element) => {
        Js.Global.setTimeout(_ => {
          open Webapi
          let rectArray = el->Dom.Element.getClientRects
          let rect = rectArray->Dom.RectList.toArray->Array.getExn(0)
          let top = rect->Dom.DomRect.top
          let currentScrollY = Dom.window->Dom.Window.scrollY
          let headerHeight = 56.
          let targetScrollY = top +. currentScrollY -. headerHeight

          Dom.window->Dom.Window.scrollTo(0.0, targetScrollY)
        }, 350)->ignore
      }

      switch text {
      | "deliveryMethod" =>
        switch deliveryMethodRef.current->Js.Nullable.toOption {
        | Some(el) => el->moveScroll
        | None => ()
        }
      | "deliveryCycle" =>
        switch deliveryCycleRef.current->Js.Nullable.toOption {
        | Some(el) => el->moveScroll
        | None => ()
        }
      | _ => ()
      }
    }

    let toggleDrawer = _ => setIsAddressDrawerShow(.prev => !prev)
    let onCompleteAddressDrawer = (data: DaumPostCode.oncompleteResponse) => {
      let newAddress =
        `${data.sido} ${data.sigungu} ${data.bname}`
        ->Js.String2.replaceByRe(%re("/[ ]{2,}/"), " ")
        ->Js.String2.trim
      setDeliveryAddress(._ => newAddress)
      toggleDrawer()
    }

    let isValidItems = {
      let validDeliveryCycle = deliveryCycle["dayCount"]->convertNumberInputValue

      switch (
        selectedDeliveryDate,
        selectedDeliveryMethod.method !== "",
        validDeliveryCycle !== `0` && validDeliveryCycle !== ``,
        deliveryAddress !== ``,
        isAgreedPrivacyPolicy || isTermAgree,
      ) {
      | (Some(_), true, true, true, true) => true
      | _ => false
      }
    }

    let handleUpdateRfqRequest = _ => {
      DataGtm.push({"event": "Click_RFQ_Livestock_ShippingInfo"})
      let deliveryMethod = switch selectedDeliveryMethod.method {
      | "WAREHOUSE_TRANSFER" => #WAREHOUSE_TRANSFER->Some
      | "DIRECT_DELIVERY" => #DIRECT_DELIVERY->Some
      | "WAREHOUSE_PICKUP" => #WAREHOUSE_PICKUP->Some
      | _ => None
      }

      let desiredDeliveryDate =
        selectedDeliveryDate->Option.mapWithDefault(None, date => Some(date->Js.Date.toISOString))

      updateRfqRequest(
        ~variables={
          id: requestId,
          input: {
            status: #READY_TO_REQUEST,
            deliveryAddress: Some(deliveryAddress),
            desiredDeliveryDate,
            deliveryCycle: Some(deliveryCycle["value"]),
            deliveryMethod,
          },
        },
        ~onCompleted={
          ({updateRfqRequest}, _) => {
            switch updateRfqRequest {
            | #RfqRequestMutationPayload(_) => {
                DataGtm.push({"event": "Expose_view_RFQ_Livestock_RequestCompleted"})
                router->Next.Router.push("/buyer/rfq/request/draft/complete")
              }

            | #Error(_)
            | #UnselectedUnionMember(_) =>
              addToast(.
                `?????? ??? ????????? ??????????????????. ?????? ??? ?????? ??????????????????.`->DS_Toast.getToastComponent(
                  #error,
                ),
                {appearance: "error"},
              )
            }
          }
        },
        ~onError={
          err =>
            addToast(.
              `?????? ??? ????????? ??????????????????. ?????? ??? ?????? ??????????????????.`->DS_Toast.getToastComponent(
                #error,
              ),
              {appearance: "error"},
            )
        },
        (),
      )->ignore
    }

    let handleClickSubmitButton = _ => {
      if !isTermAgree {
        updateTermAgreement(
          ~variables={agreement: "rfq"},
          ~onCompleted=({createTerm}, _) => {
            switch createTerm {
            | #TermMutationPayload(_) => handleUpdateRfqRequest()
            | #Error(_)
            | #UnselectedUnionMember(_) =>
              addToast(.
                `?????? ??? ????????? ??????????????????. ?????? ??? ?????? ??????????????????.`->DS_Toast.getToastComponent(
                  #error,
                ),
                {appearance: "error"},
              )
            }
          },
          ~onError=_ =>
            addToast(.
              `?????? ??? ????????? ??????????????????. ?????? ??? ?????? ??????????????????.`->DS_Toast.getToastComponent(
                #error,
              ),
              {appearance: "error"},
            ),
          (),
        )->ignore
      } else {
        handleUpdateRfqRequest()
      }
    }

    <div
      className=%twc(
        "relative container max-w-3xl mx-auto min-h-screen sm:shadow-gl pt-14 pb-[96px] "
      )>
      <DS_TopNavigation.Detail.Root className=%twc("bg-white z-[5]")>
        <DS_TopNavigation.Detail.Left>
          <a className=%twc("cursor-pointer") onClick={_ => History.back()}>
            <DS_Icon.Common.ArrowLeftXLarge1 height="32" width="32" className=%twc("relative") />
          </a>
        </DS_TopNavigation.Detail.Left>
      </DS_TopNavigation.Detail.Root>
      <div className=%twc("p-5")>
        <h2 className=%twc("text-xl font-bold leading-8")>
          <span className=%twc("block")> {`???????????????`->React.string} </span>
          <span> {`??????????????? ???????????????`->React.string} </span>
        </h2>
      </div>
      <div>
        <div className=%twc("")>
          <DS_Accordion.RootSingle
            _type=#single collapsible=true onValueChange={scrollToTargetItem}>
            <DS_Accordion.Item value={"desiredDeliveryDate"}>
              <CalendarListitem
                leftText={`?????? ?????? ?????????`}
                currentDate={selectedDeliveryDate}
                handleChangeDate={setSelectedDeliveryDate}
                minDate={minDate}
                maxDate={maxDate}
                holidays={holidays}
              />
            </DS_Accordion.Item>
            <DS_Accordion.Item value={`deliveryMethod`}>
              <DS_Accordion.Header>
                <DS_Accordion.Trigger className=%twc("w-full")>
                  <div ref={ReactDOM.Ref.domRef(deliveryMethodRef)}>
                    <TriggerListitem
                      leftText={`????????????`} rightText={selectedDeliveryMethod.title}
                    />
                  </div>
                </DS_Accordion.Trigger>
              </DS_Accordion.Header>
              <DS_Accordion.Content>
                <DeliveryMethodContent
                  currentDeliveryMethod={selectedDeliveryMethod}
                  handleChangeDeliveryMethod={setSelectedDeliveryMethod}
                />
              </DS_Accordion.Content>
            </DS_Accordion.Item>
            <DS_Accordion.Item value={`deliveryAddress`}>
              <AddressButton
                leftText={`????????????`}
                rightText={deliveryAddress === `` ? `??????????????????` : deliveryAddress}
                handleClick={toggleDrawer}
              />
            </DS_Accordion.Item>
            <DS_Accordion.Item value={`deliveryCycle`}>
              <DS_Accordion.Header>
                <DS_Accordion.Trigger className=%twc("w-full")>
                  <div ref={ReactDOM.Ref.domRef(deliveryCycleRef)}>
                    <TriggerListitem
                      leftText={`???????????? ??????`}
                      rightText={deliveryCycle["text"]}
                      hasDivider=false
                    />
                  </div>
                </DS_Accordion.Trigger>
              </DS_Accordion.Header>
              <DS_Accordion.Content>
                <DeliveryCycleContent
                  currentDeliveryCycle={deliveryCycle} handleChangeDeliveryCycle={setDeliveryCycle}
                />
              </DS_Accordion.Content>
            </DS_Accordion.Item>
          </DS_Accordion.RootSingle>
        </div>
        {!isTermAgree
          ? {
              <>
                <div className=%twc("h-3 bg-border-default-L2") />
                <div className=%twc("pt-7")>
                  <button
                    className=%twc("text-left tab-highlight-color")
                    onClick={_ => setIsAgreedPrivacyPolicy(.prev => !prev)}>
                    <DS_ListItem.Information1
                      title={`???????????? ????????? ??????????????????`}
                      content={<p
                        className=%twc("pl-8 text-[13px] text-enabled-L2 leading-5 tracking-tight")>
                        <div>
                          {`(???)??????????????? ????????? ?????? ???????????? ??????????????? ???????????????.`->React.string}
                        </div>
                        <div> {`1. ???????????? ?????? ?????? : ??????`->React.string} </div>
                        <div>
                          {`2. ???????????? ?????? ?????? : ?????? ?????? ????????? ??? ???????????? ??????`->React.string}
                        </div>
                        <div>
                          {`3. ??????????????? ?????? ??? ?????? ?????? : `->React.string}
                          <span className=%twc("font-bold")>
                            {`???????????? ??? ?????? ??????`->React.string}
                          </span>
                          {` ???????????? ???????????? ?????? ??? ?????? ????????? ????????? ????????? ????????????. ??????, ?????? ???????????? ?????? ?????? ???????????? ????????? ????????? ????????? ??? ????????????.`->React.string}
                        </div>
                      </p>}>
                      <DS_ListItem.Information1.Left>
                        {isAgreedPrivacyPolicy
                          ? <DS_Icon.Common.CheckedLarge1 height="24" width="24" fill={`#12B564`} />
                          : <DS_Icon.Common.UncheckedLarge1 height="24" width="24" />}
                      </DS_ListItem.Information1.Left>
                    </DS_ListItem.Information1>
                  </button>
                </div>
              </>
            }
          : React.null}
      </div>
      <DS_ButtonContainer.Floating1
        dataGtm={`Click_RFQ_Livestock_ShippingInfo`}
        label={`??????????????????`}
        onClick={_ => handleClickSubmitButton()}
        disabled={!isValidItems || isMutating}
      />
      <AddressDrawer
        isShow={isAddressDrawerShow} closeDrawer={toggleDrawer} onComplete={onCompleteAddressDrawer}
      />
    </div>
  }
}

@react.component
let make = (~requestId: option<string>) => {
  let router = Next.Router.useRouter()

  switch requestId {
  | Some(id) =>
    <Authorization.Buyer fallback={React.null} title={j`????????? ?????? ??????`}>
      <React.Suspense fallback={<div />}>
        <RfqCommon.CheckBuyerRequestStatus requestId={id}>
          <Shipping requestId={id} />
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
