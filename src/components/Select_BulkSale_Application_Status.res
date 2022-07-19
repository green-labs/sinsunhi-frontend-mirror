module Mutation = %relay(`
  mutation SelectBulkSaleApplicationStatusMutation(
    $id: ID!
    $input: BulkSaleApplicationProgressInput!
  ) {
    changeBulkSaleApplicationProgress(id: $id, input: $input) {
      result {
        ...BulkSaleProducerAdminFragment_bulkSaleApplication
      }
    }
  }
`)

let decodeStatus = s =>
  if s == "applied" {
    Ok(#APPLIED)
  } else if s == "under-discussion" {
    Ok(#UNDER_DISCUSSION)
  } else if s == "on-site-meeting-scheduled" {
    Ok(#ON_SITE_MEETING_SCHEDULED)
  } else if s == "sample-requested" {
    Ok(#SAMPLE_REQUESTED)
  } else if s == "sample-reviewing" {
    Ok(#SAMPLE_REVIEWING)
  } else if s == "rejected" {
    Ok(#REJECTED)
  } else if s == "confirmed" {
    Ok(#CONFIRMED)
  } else if s == "withdrawn" {
    Ok(#WITHDRAWN)
  } else {
    Error()
  }
let stringifyStatus = (
  s: BulkSaleProducerAdminFragment_bulkSaleApplication_graphql.Types.enum_BulkSaleApplicationProgress,
) =>
  switch s {
  | #APPLIED => "applied"
  | #UNDER_DISCUSSION => "under-discussion"
  | #ON_SITE_MEETING_SCHEDULED => "on-site-meeting-scheduled"
  | #SAMPLE_REQUESTED => "sample-requested"
  | #SAMPLE_REVIEWING => "sample-reviewing"
  | #REJECTED => "rejected"
  | #CONFIRMED => "confirmed"
  | #WITHDRAWN => "withdrawn"
  | _ => ""
  }
let displayStatus = (
  s: BulkSaleProducerAdminFragment_bulkSaleApplication_graphql.Types.enum_BulkSaleApplicationProgress,
) =>
  switch s {
  | #APPLIED => `신청 접수 중`
  | #UNDER_DISCUSSION => `판매 협의 중`
  | #ON_SITE_MEETING_SCHEDULED => `현장 미팅 예정`
  | #SAMPLE_REQUESTED => `샘플 요청`
  | #SAMPLE_REVIEWING => `품평회 진행 중`
  | #REJECTED => `추후 판매`
  | #CONFIRMED => `판매 확정`
  | #WITHDRAWN => `고객 취소`
  | _ => `전량 구매 진행 상태 파싱 오류`
  }

@react.component
let make = (
  ~application: BulkSaleProducerAdminFragment_bulkSaleApplication_graphql.Types.fragment,
  ~refetchSummary,
) => {
  let {addToast} = ReactToastNotifications.useToasts()

  let (mutate, isMutating) = Mutation.use()

  let (isShowRejectedDialog, setShowRejectedDialog) = React.Uncurried.useState(_ => false)

  let handleOnChange = e => {
    let value = (e->ReactEvent.Synthetic.target)["value"]
    switch value->decodeStatus {
    | Ok(progress) =>
      switch progress {
      | #REJECTED => setShowRejectedDialog(._ => true)
      | _ =>
        mutate(
          ~variables=Mutation.makeVariables(
            ~id=application.id,
            ~input=Mutation.make_bulkSaleApplicationProgressInput(~progress, ()),
          ),
          ~onCompleted={
            (_, _) => {
              addToast(.
                <div className=%twc("flex items-center")>
                  <IconCheck height="24" width="24" fill="#12B564" className=%twc("mr-2") />
                  {j`수정 요청에 성공하였습니다.`->React.string}
                </div>,
                {appearance: "success"},
              )
              refetchSummary()
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
    | Error() => Js.Console.log(`알 수 없는 진행 상태`)
    }
  }

  <div className=%twc("relative")>
    <label className=%twc("block relative")>
      <span
        className=%twc(
          "flex items-center border border-border-default-L1 rounded-md h-9 px-3 text-enabled-L1"
        )>
        {application.progress->displayStatus->React.string}
      </span>
      <span className=%twc("absolute top-1.5 right-2")>
        <IconArrowSelect height="24" width="24" fill="#121212" />
      </span>
      <select
        value={application.progress->stringifyStatus}
        className=%twc("block w-full h-full absolute top-0 opacity-0")
        onChange={handleOnChange}
        disabled=isMutating>
        {[
          #APPLIED,
          #UNDER_DISCUSSION,
          #ON_SITE_MEETING_SCHEDULED,
          #SAMPLE_REQUESTED,
          #SAMPLE_REVIEWING,
          #REJECTED,
          #CONFIRMED,
          #WITHDRAWN,
        ]
        ->Garter.Array.map(s =>
          <option key={s->stringifyStatus} value={s->stringifyStatus}>
            {s->displayStatus->React.string}
          </option>
        )
        ->React.array}
      </select>
    </label>
    {application.progress == #WITHDRAWN
      ? <BulkSale_Producer_Application_Withdrawn_Button applicationId={application.id} />
      : React.null}
    <BulkSale_Producer_Application_Rejected_Button
      application
      isShow=isShowRejectedDialog
      _open={_ => setShowRejectedDialog(._ => true)}
      close={_ => setShowRejectedDialog(._ => false)}
      refetchSummary
    />
  </div>
}
