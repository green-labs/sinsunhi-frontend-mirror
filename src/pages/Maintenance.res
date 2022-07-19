type target = Seller | Buyer | Admin
module MaintenanceTime = {
  type t = {
    from: Js.Date.t,
    to_: option<Js.Date.t>,
  }

  // now is after startDate
  let afterCheck = from_ => DateFns.isAfter(Js.Date.now()->Js.Date.fromFloat, from_)

  //and now is before endDate
  let beforeCheck = to_ => DateFns.isBefore(Js.Date.now()->Js.Date.fromFloat, to_)

  let make = (from, to_) => {
    from
    ->Option.map(Js.Date.fromString)
    ->Option.flatMap(from => {
      switch afterCheck(from) {
      | true =>
        switch to_->Option.map(Js.Date.fromString) {
        | Some(to_) if beforeCheck(to_) => Some({from: from, to_: Some(to_)})
        | Some(_) => None
        | None => Some({from: from, to_: None})
        }
      | false => None
      }
    })
  }

  let format = ({from, to_}) => {
    let formatForDisplay = date =>
      `${date->DateFns.format("MM")}월 ${date->DateFns.format("dd")}일 ${date->DateFns.format(
          "HH",
        )}시`

    `${from->formatForDisplay} ~ ${to_->Option.map(formatForDisplay)->Option.getWithDefault("")}`
  }
}
module Match = {
  type matchedInfo = {
    message: option<string>,
    maintenanceTime: MaintenanceTime.t,
  }

  type t =
    | Matched(array<matchedInfo>)
    | NotMatched

  let make = (pathname, target, message, from, to_) => {
    switch (target->Js.Array2.includes(pathname), MaintenanceTime.make(from, to_)) {
    | (true, Some(maintenanceTime)) =>
      Matched([
        {
          message: message,
          maintenanceTime: maintenanceTime,
        },
      ])
    | _ => NotMatched
    }
  }

  let join = (a, b) =>
    switch (a, b) {
    | (NotMatched, NotMatched) => NotMatched
    | (Matched(a), NotMatched) => Matched(a)
    | (NotMatched, Matched(b)) => Matched(b)
    | (Matched(a), Matched(b)) => Matched(a->Array.concat(b))
    }

  let getIncidentForDisplay = t =>
    switch t {
    | Matched(incidents) => incidents->Array.get(0)
    | NotMatched => None
    }
}

module StatusPageCompat = {
  module Component = {
    @spice
    type t = {name: string}
  }

  module IncidentUpdate = {
    @spice
    type t = {
      @spice.key("affected_components") components: option<array<Component.t>>,
      body: string,
      @spice.key("created_at") createdAt: string,
    }
  }
  module Incident = {
    @spice
    type incident = {
      components: array<Component.t>,
      id: string,
      impact: string,
      name: option<string>,
      @spice.key("created_at") createdAt: string,
      @spice.key("scheduled_for") scheduledFor: option<string>,
      @spice.key("scheduled_until") scheduledUntil: option<string>,
      @spice.key("started_at") startedAt: option<string>,
      @spice.key("incident_updates") incidentUpdates: array<IncidentUpdate.t>,
    }
  }

  module Target = {
    type t =
      | Incident
      | Maintenance

    let apiEndPoint = t => {
      switch t {
      | Incident => "unresolved"
      | Maintenance => "scheduled"
      }
    }
  }

  @spice
  type incidents = array<Incident.incident>

  let use = target => {
    let apiFetcher = url => {
      open FetchHelper
      url->Fetch.fetchWithInit(
        Fetch.RequestInit.make(
          ~method_=Get,
          ~headers=Fetch.HeadersInit.make({
            "Authorization": `OAuth ${Env.statusPageKey}`,
          }),
          (),
        ),
      )
      |> Js.Promise.then_(res =>
        if res->Fetch.Response.ok {
          res->Fetch.Response.json
        } else {
          res->Fetch.Response.json
          |> Js.Promise.then_(errJson => {
            Js.Promise.reject({
              let error = makeError(`요청에 실패했습니다.`)
              error->setStatus(res->Fetch.Response.status)
              error->setInfo(errJson)
              switch errJson->errJson_decode {
              | Ok(errJson') => error->setMessage(errJson'.message)
              | Error(_) => ()
              }
              error->convertToExn
            })
          })
          |> Js.Promise.catch(err => {
            Js.Promise.reject(err->convertToExnFromPromiseError)
          })
        }
      )
      |> Js.Promise.then_(data => Js.Promise.resolve(data))
      |> Js.Promise.catch(_ => Js.Promise.resolve(Js.Json.null))
    }

    let {data, error} = Swr.useSwr(
      `https://api.statuspage.io/v1/pages/${Env.statusPagePageId}/incidents/${target->Target.apiEndPoint}`,
      apiFetcher,
      Swr.fetcherOptions(
        ~revalidateIfStale=false,
        ~revalidateOnFocus=false,
        ~revalidateOnReconnect=false,
        ~errorRetryCount=0,
        ~shouldRetryOnError=false,
        (),
      ),
    )
    switch (data, error) {
    | (Some(data), None) =>
      data->incidents_decode->Result.mapWithDefault(None, incident => incident->Some)
    | (_, _) => None
    }
  }

  let isMaintenanceTarget = (statusPageIncidents: option<incidents>, pathname) => {
    statusPageIncidents
    ->Option.map(statusPageIncidents =>
      statusPageIncidents->Array.map(statusPageResult => {
        let message =
          statusPageResult.incidentUpdates
          ->SortArray.stableSortBy((incidentA, incidentB) =>
            DateFns.compareDesc(
              incidentA.createdAt->Js.Date.fromString,
              incidentB.createdAt->Js.Date.fromString,
            )
          )
          ->Array.get(0)
          ->Option.map(latestIncident => latestIncident.body)

        switch statusPageResult {
        | statusPageResult if statusPageResult.scheduledFor->Option.isSome =>
          //예정된 시작 시간과 예정된 종료 시간이 제시된 경우
          Match.make(
            pathname,
            statusPageResult.components
            ->Array.map(component => component.name)
            ->Array.map(name => name->Js.String2.toLowerCase),
            message,
            statusPageResult.scheduledFor,
            statusPageResult.scheduledUntil,
          )
        | _ =>
          //사건 발생 시작 시간만 존재하는 경우
          Match.make(
            pathname,
            statusPageResult.components
            ->Array.map(component => component.name)
            ->Array.map(name => name->Js.String2.toLowerCase),
            message,
            Some(statusPageResult.createdAt),
            None,
          )
        }
      })
    )
    ->Option.map(matches => matches->Array.reduce(Match.NotMatched, Match.join))
    ->Option.getWithDefault(Match.NotMatched)
  }
}

module View = {
  @react.component
  let make = (~message, ~maintenanceTime=?) => {
    <section
      className=%twc("w-screen h-screen flex flex-col items-center justify-start dialog-overlay")>
      <div className=%twc("flex flex-col h-full items-center justify-center")>
        <img src="/images/maintenance.png" width="140" height="156" />
        <h1 className=%twc("mt-7 text-3xl text-gray-800 whitespace-pre text-center")>
          {`더 나은 서비스를 위해서\n시스템 점검 중입니다`->React.string}
        </h1>
        <div className=%twc("flex flex-col justify-center items-center gap-5")>
          <h3 className=%twc("mt-7 text-[17px] whitespace-pre text-center")>
            {message
            ->Option.getWithDefault(`점검 시간 동안 서비스 이용이 일시 중단됩니다.\n이용에 불편을 드려서 죄송합니다.`)
            ->React.string}
          </h3>
          <div className=%twc("flex flex-col items-center py-3 bg-gray-gl rounded-lg w-[320px]")>
            <span className=%twc("")> {`점검 시간`->React.string} </span>
            <span className=%twc("text-gray-800 font-bold")>
              {maintenanceTime
              ->Option.map(MaintenanceTime.format)
              ->Option.getWithDefault(`불러오는 중입니다`)
              ->React.string}
            </span>
          </div>
        </div>
      </div>
    </section>
  }
}

module Content = {
  @react.component
  let make = () => {
    // 점검 페이지 로직
    let currentPathName =
      Next.Router.useRouter().pathname
      ->Js.String2.split("/")
      ->Array.get(1)
      ->Option.getWithDefault("")

    let incidentResultFromStatusPage =
      StatusPageCompat.use(StatusPageCompat.Target.Incident)->StatusPageCompat.isMaintenanceTarget(
        currentPathName,
      )

    let maintenanceResultFromStatusPage =
      StatusPageCompat.use(
        StatusPageCompat.Target.Maintenance,
      )->StatusPageCompat.isMaintenanceTarget(currentPathName)

    switch incidentResultFromStatusPage
    ->Match.join(maintenanceResultFromStatusPage)
    ->Match.getIncidentForDisplay {
    | Some({message, maintenanceTime}) =>
      <RadixUI.Dialog.Root _open=true>
        <RadixUI.Dialog.Portal>
          <RadixUI.Dialog.Overlay className=%twc("dialog-overlay") />
          <RadixUI.Dialog.Content className=%twc("top-0 bg-white fixed z-20")>
            <Next.Head>
              <title> {`🚧 신선하이 점검중입니다 🚧`->React.string} </title>
            </Next.Head>
            <View message maintenanceTime />
          </RadixUI.Dialog.Content>
        </RadixUI.Dialog.Portal>
      </RadixUI.Dialog.Root>

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
