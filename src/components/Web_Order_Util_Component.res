module Tooltip = {
  module PC = {
    @react.component
    let make = (~children, ~className="") => {
      <RadixUI.Tooltip.Root delayDuration=300 className=%twc("absolute")>
        <RadixUI.Tooltip.Trigger>
          <img
            onClick={e => e->ReactEvent.Synthetic.preventDefault}
            src="/icons/icon_common_tooltip_q_line_20.png"
            className={cx([%twc("w-5 h-5"), className])}
          />
        </RadixUI.Tooltip.Trigger>
        <RadixUI.Tooltip.Content side=#top sideOffset=10 avoidCollisions=false>
          <div className=%twc("relative w-96")>
            <div
              className=%twc(
                "absolute bottom-0 left-28 block min-w-min bg-white px-6 py-2 border-primary border rounded-xl text-sm font-bold text-primary-variant"
              )>
              {children}
              <div
                className=%twc(
                  "absolute left-20 h-3 w-3 -bottom-1.5 rounded-sm bg-white border-b border-r border-primary-variant transform -translate-x-1/2 rotate-45"
                )
              />
            </div>
          </div>
        </RadixUI.Tooltip.Content>
      </RadixUI.Tooltip.Root>
    }
  }

  module Mobile = {
    @react.component
    let make = (~children, ~className="") => {
      let (touch, setTouch) = React.useState(_ => false)

      React.useEffect1(_ => {
        if touch {
          Js.Global.setTimeout(() => setTouch(_ => false), 2000)->ignore
        }
        None
      }, [touch])

      <RadixUI.Tooltip.Root _open=touch delayDuration=300 className=%twc("absolute")>
        <RadixUI.Tooltip.Trigger>
          <img
            onClick={e => {
              e->ReactEvent.Synthetic.preventDefault
              setTouch(_ => !touch)
            }}
            src="/icons/icon_common_tooltip_q_line_20.png"
            className={cx([%twc("w-5 h-5"), className])}
          />
        </RadixUI.Tooltip.Trigger>
        <RadixUI.Tooltip.Content side=#top sideOffset=10 avoidCollisions=false>
          <div className=%twc("relative w-96")>
            <div
              className=%twc(
                "absolute bottom-0 left-28 block min-w-min bg-white px-6 py-2 border-primary border rounded-xl text-sm font-bold text-primary-variant"
              )>
              {children}
              <div
                className=%twc(
                  "absolute left-20 h-3 w-3 -bottom-1.5 rounded-sm bg-white border-b border-r border-primary-variant transform -translate-x-1/2 rotate-45"
                )
              />
            </div>
          </div>
        </RadixUI.Tooltip.Content>
      </RadixUI.Tooltip.Root>
    }
  }
}

module RadioButton = {
  module PlaceHolder = {
    @react.component
    let make = () => {
      open Skeleton
      <Box className=%twc("w-24 xl:w-32 min-h-[2.75rem] rounded-xl") />
    }
  }
  @react.component
  let make = (~watchValue, ~name, ~value) => {
    let checked = watchValue->Option.mapWithDefault(false, watch => watch == value)
    <span
      className={checked
        ? %twc(
            "w-24 xl:w-32 h-11 pl-1 flex justify-center items-center text-sm xl:text-base text-primary font-bold border border-primary bg-primary-light rounded-xl cursor-pointer"
          )
        : %twc(
            "w-24 xl:w-32 h-11 flex justify-center items-center text-sm xl:text-base text-text-L1 border border-div-border-L2 rounded-xl cursor-pointer"
          )}>
      {name->React.string}
      {checked
        ? <IconCheck width="30" height="20" fill="#12b564" className=%twc("mb-1") />
        : React.null}
    </span>
  }
}
