open RadixUI.HoverCard

@react.component
let make = (~className=?, ~children, ~onHoverChange=?, ~hoverInDelay=0, ~hoverOutDelay=0) => {
  <Root onOpenChange=?onHoverChange openDelay={hoverInDelay} closeDelay={hoverOutDelay}>
    <Trigger ?className> {children} </Trigger>
  </Root>
}
