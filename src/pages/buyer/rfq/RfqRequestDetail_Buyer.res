module Query = %relay(`
  query RfqRequestDetailBuyer_Current_Request_Query($id: ID!) {
    node(id: $id) {
      ... on RfqRequest {
        id
        status
        remainSecondsUntilQuotationExpired
        items(first: 9999) {
          edges {
            node {
              ... on RfqRequestItemMeat {
                id
                preferredBrand
                part {
                  isDomestic
                  isAvailable
                  id
                  name
                }
                species {
                  shortName
                }
              }
              status
            }
          }
        }
      }
    }
  }
`)

module StatusLabel = {
  @react.component
  let make = (~status) => {
    let defaultStyle = %twc("px-2 py-1 rounded-[4px] text-sm font-bold truncate")
    let greyStyle = %twc("bg-gray-600 bg-opacity-10 text-gray-600")
    let redStyle = %twc("bg-red-500 bg-opacity-10 text-red-500")
    let blueStyle = %twc("bg-blue-500 bg-opacity-10 text-blue-500")
    let greenStyle = %twc("bg-primary bg-opacity-10 text-primary")

    switch status {
    | #WAITING_FOR_ORDER =>
      <div className={Cx.cx([defaultStyle, greenStyle])}> {`견적서 도착`->React.string} </div>
    | #ORDERED =>
      <div className={Cx.cx([defaultStyle, blueStyle])}> {`주문 요청`->React.string} </div>
    | #MATCH_FAILED =>
      <div className={Cx.cx([defaultStyle, greyStyle])}> {`견적 실패`->React.string} </div>
    | #ORDER_TIMEOUT =>
      <div className={Cx.cx([defaultStyle, redStyle])}> {`견적 만료`->React.string} </div>
    | #REQUEST_CANCELED =>
      <div className={Cx.cx([defaultStyle, redStyle])}> {`요청 취소`->React.string} </div>
    | #WAITING_FOR_QUOTATION
    | #READY_TO_REQUEST
    | #DRAFT
    | _ => React.null
    }
  }
}

module QuotationListitem = {
  @react.component
  let make = (~itemId, ~name, ~speciesName, ~isDomestic, ~status) => {
    let router = Next.Router.useRouter()
    <li
      onClick={_ => router->Next.Router.push(`${router.asPath}/${itemId}`)}
      className=%twc("flex items-center mx-5 p-5 cursor-pointer bg-white rounded-lg mb-3")>
      <div className=%twc("flex flex-col justify-between truncate")>
        <DS_TitleList.Left.Title3Subtitle1
          title1={speciesName} title2={name} title3={isDomestic ? `국내` : `수입`}
        />
      </div>
      <div className=%twc("ml-auto pl-2")>
        <div className=%twc("flex items-center")>
          <StatusLabel status /> <DS_Icon.Common.ArrowRightLarge1 height="24" width="24" />
        </div>
      </div>
    </li>
  }
}

module BottomButton = {
  @react.component
  let make = (~status, ~requestId) => {
    let router = Next.Router.useRouter()
    switch status {
    | #DRAFT =>
      <DS_ButtonContainer.Floating1
        label={`견적서 이어 작성하기`}
        onClick={_ => {
          DataGtm.push({"event": "Expose_view_RFQ_Livestock_SelectingPart"})
          router->Next.Router.push(`/buyer/rfq/request/draft/basket?requestId=${requestId}`)
        }}
      />
    | #REQUEST_CANCELED
    | #READY_TO_REQUEST
    | #REQUEST_PROCESSED
    | #WAITING_FOR_QUOTATION
    | _ =>
      <DS_ButtonContainer.Floating1
        buttonType=#white
        label={`담당자에게 문의하기`}
        onClick={_ =>
          switch Global.window {
          | Some(window') =>
            Global.Window.openLink(
              window',
              ~url=`${Env.customerServiceUrl}${Env.customerServicePaths["rfqContactManager"]}`,
              ~windowFeatures="",
              (),
            )
          | None => ()
          }}
      />
    }
  }
}

type time = Day(int) | Hour(int) | Minute(int) | Second(int)
module TimerTitle = {
  @react.component
  let make = (~remainSecondsUntilQuotationExpired: int) => {
    let (time, setTime) = React.Uncurried.useState(_ => remainSecondsUntilQuotationExpired)

    React.useEffect0(_ => {
      let id = Js.Global.setInterval(_ => {
        setTime(.time => Js.Math.max_int(0, time - 1))
      }, 1000)

      Some(_ => id->Js.Global.clearInterval)
    })

    let getRemainTimes = (s: int) => {
      let oneMinuteSeconds = 60
      let oneHourSeconds = oneMinuteSeconds * 60
      let oneDaySeconds = oneHourSeconds * 24

      let remainDays = s / oneDaySeconds
      let remainHourSeconds = mod(s, oneDaySeconds)

      let remainHours = remainHourSeconds / oneHourSeconds
      let remainMinuteSeconds = mod(remainHourSeconds, oneHourSeconds)

      let remainMinutes = remainMinuteSeconds / oneMinuteSeconds
      let remainSeconds = mod(remainMinuteSeconds, oneMinuteSeconds)

      (Day(remainDays), Hour(remainHours), Minute(remainMinutes), Second(remainSeconds))
    }

    let getTimeText = (time: time) => {
      let generateText = (num, postfix) =>
        Some(num)
        ->Option.keep(x => x > 0)
        ->Option.mapWithDefault(``, x => `${x->Int.toString}${postfix}`)

      switch time {
      | Day(d) => d->generateText(`일 `)
      | Hour(h) => h->generateText(`시간 `)
      | Minute(m) => m->generateText(`분 `)
      | Second(s) => s->generateText(`초`)
      }
    }

    let (d, h, m, s) = time->getRemainTimes
    let dayText = d->getTimeText
    let hourText = h->getTimeText
    let minuteText = m->getTimeText
    let secondText = s->getTimeText

    let timeText =
      time > 0
        ? `${dayText}${hourText}${minuteText}${secondText} 후 마감됩니다.`
        : `마감되었습니다.`

    <DS_Title.Normal1.TextGroup title1={`견적 요청 현황`} subTitle={timeText} />
  }
}
module Title = {
  @react.component
  let make = (~status, ~remainSecondsUntilQuotationExpired) => {
    <DS_Title.Normal1.Root className=%twc("mt-10 mb-10")>
      {switch status {
      | #DRAFT =>
        <DS_Title.Normal1.TextGroup
          title1={`작성 중인 견적서입니다.`}
          subTitle={`아래의 버튼을 눌러 이어 작성해주세요.`}
        />
      | #READY_TO_REQUEST
      | #WAITING_FOR_QUOTATION =>
        <DS_Title.Normal1.TextGroup
          title1={`요청 중인 견적서입니다.`}
          subTitle={`견적서가 도착하면 알려드릴게요.`}
        />
      | #REQUEST_CANCELED =>
        <DS_Title.Normal1.TextGroup
          title1={`요청이 취소된 견적서입니다.`}
          subTitle={`아래의 버튼을 눌러 새로운 견적을 신청해주세요.`}
        />

      | #REQUEST_PROCESSED => <TimerTitle remainSecondsUntilQuotationExpired />
      | _ =>
        <DS_Title.Normal1.TextGroup
          title1={`잘못된 견적서입니다.`}
          subTitle={`견적서 정보를 확인할 수 없습니다.`}
        />
      }}
    </DS_Title.Normal1.Root>
  }
}

module Detail = {
  @react.component
  let make = (~requestId) => {
    let {node} = Query.use(~variables={id: requestId}, ~fetchPolicy=NetworkOnly, ())

    React.useEffect0(_ => {
      //TODO list count , status count GTM
      let arrItem =
        node->Option.mapWithDefault([], node' => node'.items.edges)->Array.map(edge => edge.node)

      DataGtm.push({
        "event": "Expose_view_RFQ_Livestock_Status_QuotationList",
        "totalCount": arrItem->Array.length,
        "waitingForOrder": arrItem->Array.keep(x => x.status === #WAITING_FOR_ORDER)->Array.length,
        "machedFailed": arrItem->Array.keep(x => x.status === #MATCH_FAILED)->Array.length,
        "ordered": arrItem->Array.keep(x => x.status === #ORDERED)->Array.length,
      })

      None
    })

    switch node {
    | Some(request) => {
        let {status, items, remainSecondsUntilQuotationExpired} = request
        <div
          className=%twc(
            "relative container max-w-3xl mx-auto min-h-screen sm:shadow-gl pt-7 pb-[96px] bg-gray-50"
          )>
          <Title status remainSecondsUntilQuotationExpired />
          {items.edges
          ->Array.mapWithIndex((index, item) => {
            let {status, id: itemId, part, species} = item.node

            switch (itemId, part, species) {
            | (Some(itemId'), Some(part'), Some(species')) =>
              <QuotationListitem
                key={index->Int.toString}
                itemId={itemId'}
                name={part'.name}
                speciesName={species'.shortName}
                isDomestic={part'.isDomestic}
                status={status}
              />
            | _ => React.null
            }
          })
          ->React.array}
          <div />
          <BottomButton status={status} requestId={requestId} />
        </div>
      }

    | None =>
      <div
        className=%twc(
          "relative container max-w-3xl mx-auto min-h-screen sm:shadow-gl pt-7 pb-[96px] bg-gray-50"
        )>
        <DS_Title.Normal1.Root className=%twc("mt-10 mb-10")>
          <DS_Title.Normal1.TextGroup
            title1={`견적서 정보를 찾을 수 없습니다.`}
            subTitle={`아래의 버튼을 눌러 문의해주세요.`}
          />
        </DS_Title.Normal1.Root>
        <BottomButton status={#NONE} requestId={requestId} />
      </div>
    }
  }
}

@react.component
let make = (~requestId: option<string>) => {
  let router = Next.Router.useRouter()

  // Todo - reuqest id를 바탕으로 자신의 견적서인지 확인하는 검증 로직 필요
  switch requestId {
  | Some(id) =>
    <Authorization.Buyer fallback={React.null} title=j`견적서 확인하기`>
      <Detail requestId={id} />
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
