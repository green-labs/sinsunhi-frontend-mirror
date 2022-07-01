module Tooltip = {
  @react.component
  let make = (~children) => {
    <RadixUI.Tooltip.Root delayDuration=300 className=%twc("absolute")>
      <RadixUI.Tooltip.Trigger>
        <IconInfo height="16" width="16" fill="#C4C4C4" />
      </RadixUI.Tooltip.Trigger>
      <RadixUI.Tooltip.Content side=#top sideOffset=10 avoidCollisions=false>
        {children}
      </RadixUI.Tooltip.Content>
    </RadixUI.Tooltip.Root>
  }
}

module Date = {
  @react.component
  let make = () => {
    <Tooltip>
      <div className=%twc("relative w-96")>
        <div
          className=%twc(
            "absolute bottom-0 left-28 block min-w-min bg-white px-6 py-2 border-primary border rounded-xl text-sm font-bold text-primary-variant"
          )>
          <ol className=%twc("text-center whitespace-nowrap")>
            <li>
              {j`1. 온라인택배는 실제 송장이 등록된 날짜입니다.`->React.string}
            </li>
            <li> {j`2. 도매출하는 정산날짜 입니다.`->React.string} </li>
            <li>
              {j`3. 오프라인은 납품확정이 발생한 출하일입니다.`->React.string}
            </li>
          </ol>
          <div
            className=%twc(
              "absolute left-20 h-3 w-3 -bottom-1.5 rounded-sm bg-white border-b border-r border-primary-variant transform -translate-x-1/2 rotate-45"
            )
          />
        </div>
      </div>
    </Tooltip>
  }
}

module MarketType = {
  @react.component
  let make = () => {
    <Tooltip>
      <div
        className=%twc(
          "block min-w-min bg-white px-6 py-2 border-primary border rounded-xl text-sm font-bold text-primary-variant relative"
        )>
        <div className=%twc("shadow-tooltip")>
          {j`온라인 택배의 경우, 택배사에서 배송중 처리가`->React.string}
          <br />
          {j`되지 않은 출고건들은 빠져서 보일 수 있습니다.`->React.string}
        </div>
        <div
          className=%twc(
            "absolute left-1/2 h-3 w-3 -bottom-1.5 rounded-sm bg-white border-b border-r border-primary-variant transform -translate-x-1/2 rotate-45"
          )
        />
      </div>
    </Tooltip>
  }
}
