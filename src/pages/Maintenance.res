type target = Seller | Buyer | Admin
module Query = %relay(`
  query Maintenance_getSystemMaintenance_Query {
    systemMaintenance {
      id
      endAt
      startAt
      message
      targets
    }
  }
`)

module View = {
  @react.component
  let make = (~message, ~maintenanceTime) => {
    <section
      className=%twc("w-screen h-screen flex flex-col items-center justify-start dialog-overlay")>
      <div className=%twc("flex flex-col h-full items-center justify-center")>
        <img src="/images/maintenance.png" width="140" height="156" />
        <h1 className=%twc("mt-7 text-3xl text-gray-800 whitespace-pre text-center")>
          {`더 나은 서비스를 위해서\n시스템 점검 중입니다`->React.string}
        </h1>
        <div className=%twc("flex flex-col justify-center items-center gap-5")>
          <h3 className=%twc("mt-7 text-[17px]")>
            {message
            ->Option.getWithDefault(`점검 시간 동안 서비스 이용이 일시 중단됩니다.이용에 불편을 드려서 죄송합니다.`)
            ->React.string}
          </h3>
          <div className=%twc("flex flex-col items-center py-3 bg-gray-gl rounded-lg w-[320px]")>
            <span className=%twc("")> {`점검 시간`->React.string} </span>
            <span className=%twc("text-gray-800 font-bold")>
              {maintenanceTime->Option.getWithDefault(`불러오는 중입니다`)->React.string}
            </span>
          </div>
        </div>
      </div>
    </section>
  }
}

module Content = {
  type maintenanceTargetMatch =
    | Matched
    | NotMatched

  let formatDate = (date, formatString) => {
    let dateObj = date->Js.Date.fromString
    dateObj->DateFns.format(formatString)
  }

  let formatForDisplay = date =>
    `${date->formatDate("MM")}월 ${date->formatDate("dd")}일 ${date->formatDate("HH")}시`

  @react.component
  let make = () => {
    // 점검 페이지 로직
    let queryData = Query.use(~variables=(), ())

    let isMaintenanceTarget = (targets, startAt, endAt) => {
      let timeCheck = {
        let now = Js.Date.now()->Js.Date.fromFloat
        // now is after startDate
        DateFns.isAfter(now, startAt->Js.Date.fromString) &&
        //and now is before endDate
        DateFns.isBefore(now, endAt->Js.Date.fromString)
      }
      let targetCheck = {
        Next.Router.useRouter().pathname
        ->Js.String2.split("/")
        ->Array.getBy(x => x !== "")
        ->Option.map(firstPath => targets->Array.some(targetElement => firstPath == targetElement))
        ->Option.getWithDefault(false)
      }

      switch timeCheck && targetCheck {
      | true => Matched
      | false => NotMatched
      }
    }

    switch queryData.systemMaintenance {
    | Some(systemMaintenance) => {
        let {endAt, startAt, message, targets} = systemMaintenance
        switch isMaintenanceTarget(targets, startAt, endAt) {
        | Matched => <>
            <RadixUI.Dialog.Root _open=true>
              <RadixUI.Dialog.Portal>
                <RadixUI.Dialog.Overlay className=%twc("dialog-overlay") />
                <RadixUI.Dialog.Content className=%twc("top-0 bg-white fixed z-20")>
                  <Next.Head>
                    <title> {`🚧 신선하이 점검중입니다 🚧`->React.string} </title>
                  </Next.Head>
                  <View
                    message
                    maintenanceTime={Some(
                      `${startAt->formatForDisplay} ~ ${endAt->formatForDisplay}`,
                    )}
                  />
                </RadixUI.Dialog.Content>
              </RadixUI.Dialog.Portal>
            </RadixUI.Dialog.Root>
          </>
        | NotMatched => React.null
        }
      }
    | None => React.null
    }
  }
}

@react.component
let make = () => {
  let (isCsr, setIsCsr) = React.Uncurried.useState(_ => false)
  React.useEffect0(() => {
    setIsCsr(._ => true)
    None
  })
  switch isCsr {
  | true => <Content />
  | false => React.null
  }
}
