module DropDown = {
  module Root = {
    @module("@radix-ui/react-dropdown-menu") @react.component
    external make: (
      ~children: React.element,
      ~defaultOpen: bool=?,
      ~_open: bool=?,
      ~className: string=?,
      ~onOpenChange: bool => unit=?,
    ) => React.element = "Root"
  }

  module Trigger = {
    @module("@radix-ui/react-dropdown-menu") @react.component
    external make: (~children: React.element, ~className: string=?) => React.element = "Trigger"
  }

  module Content = {
    @module("@radix-ui/react-dropdown-menu") @react.component
    external make: (
      ~children: React.element,
      ~align: [#start | #center | #end]=?,
      ~className: string=?,
      ~sideOffset: int=?,
    ) => React.element = "Content"
  }

  module Label = {
    @module("@radix-ui/react-dropdown-menu") @react.component
    external make: (~children: React.element, ~className: string=?) => React.element = "Label"
  }

  module Item = {
    @module("@radix-ui/react-dropdown-menu") @react.component
    external make: (
      ~children: React.element=?,
      ~className: string=?,
      ~disabled: bool=?,
      ~onSelect: ReactEvent.synthetic<'a> => unit=?,
    ) => React.element = "Item"
  }

  module Separator = {
    @module("@radix-ui/react-dropdown-menu") @react.component
    external make: (~className: string=?) => React.element = "Separator"
  }
}

module Dialog = {
  module Root = {
    @module("@radix-ui/react-dialog") @react.component
    external make: (
      ~children: React.element,
      ~defaultOpen: bool=?,
      ~_open: bool=?,
      ~onOpenChange: bool => unit=?,
      ~className: string=?,
    ) => React.element = "Root"
  }

  module Trigger = {
    @module("@radix-ui/react-dialog") @react.component
    external make: (
      ~onClick: ReactEvent.synthetic<'a> => unit=?,
      ~children: React.element,
      ~className: string=?,
      ~asChild: bool=?,
      ~ref: ReactDOM.Ref.t=?,
    ) => React.element = "Trigger"
  }

  module Overlay = {
    @module("@radix-ui/react-dialog") @react.component
    external make: (~className: string=?, ~ref: ReactDOM.Ref.t=?) => React.element = "Overlay"
  }

  module Portal = {
    @module("@radix-ui/react-dialog") @react.component
    external make: (~children: React.element, ~className: string=?) => React.element = "Portal"
  }

  module Content = {
    @module("@radix-ui/react-dialog") @react.component
    external make: (
      ~children: React.element,
      ~className: string=?,
      ~ref: ReactDOM.Ref.t=?,
      ~onPointerDownOutside: ReactEvent.Mouse.t => unit=?,
    ) => React.element = "Content"
  }

  module Title = {
    @module("@radix-ui/react-dialog") @react.component
    external make: (
      ~children: React.element,
      ~className: string=?,
      ~ref: ReactDOM.Ref.t=?,
    ) => React.element = "Title"
  }

  module Description = {
    @module("@radix-ui/react-dialog") @react.component
    external make: (
      ~children: React.element,
      ~className: string=?,
      ~ref: ReactDOM.Ref.t=?,
    ) => React.element = "Description"
  }

  module Close = {
    @module("@radix-ui/react-dialog") @react.component
    external make: (
      ~onClick: unit => unit=?,
      ~children: React.element,
      ~className: string=?,
      ~id: string=?,
      ~asChild: bool=?,
      ~ref: ReactDOM.Ref.t=?,
    ) => React.element = "Close"
  }
}

module Accordian = {
  module Root = {
    @module("@radix-ui/react-accordion") @react.component
    external make: (
      ~children: React.element,
      ~_type: [#single | #multiple],
      ~collapsible: bool=?,
      ~className: string=?,
      ~value: array<string>=?,
      ~onValueChange: array<string> => unit=?,
    ) => React.element = "Root"
  }
  module RootMultiple = {
    @module("@radix-ui/react-accordion") @react.component
    external make: (
      ~asChild: bool=?,
      ~children: React.element,
      ~_type: [#multiple],
      ~className: string=?,
      ~value: array<string>=?,
      ~onValueChange: array<string> => unit=?,
      ~ref: ReactDOM.Ref.t=?,
    ) => React.element = "Root"
  }

  module RootSingle = {
    @module("@radix-ui/react-accordion") @react.component
    external make: (
      ~asChild: bool=?,
      ~children: React.element,
      ~_type: [#single],
      ~collapsible: bool=?,
      ~className: string=?,
      ~value: string=?,
      ~onValueChange: string => unit=?,
      ~ref: ReactDOM.Ref.t=?,
    ) => React.element = "Root"
  }

  module Trigger = {
    @module("@radix-ui/react-accordion") @react.component
    external make: (
      ~children: React.element,
      ~className: string=?,
      ~asChild: bool=?,
      ~ref: ReactDOM.Ref.t=?,
    ) => React.element = "Trigger"
  }

  module Item = {
    @module("@radix-ui/react-accordion") @react.component
    external make: (
      ~children: React.element,
      ~value: string,
      ~className: string=?,
      ~asChild: bool=?,
      ~disabled: bool=?,
      ~ref: ReactDOM.Ref.t=?,
    ) => React.element = "Item"
  }

  module Header = {
    @module("@radix-ui/react-accordion") @react.component
    external make: (
      ~ref: ReactDOM.Ref.t=?,
      ~children: React.element,
      ~className: string=?,
      ~asChild: bool=?,
    ) => React.element = "Header"
  }

  module Content = {
    @module("@radix-ui/react-accordion") @react.component
    external make: (
      ~children: React.element,
      ~className: string=?,
      ~asChild: bool=?,
      ~forceMount: bool=?,
      ~ref: ReactDOM.Ref.t=?,
    ) => React.element = "Content"
  }
}

module RadioGroup = {
  module Root = {
    @module("@radix-ui/react-radio-group") @react.component
    external make: (
      ~children: React.element,
      ~value: string,
      ~onValueChange: string => unit,
      ~name: string,
      ~required: bool=?,
      ~className: string=?,
    ) => React.element = "Root"
  }

  module Item = {
    @module("@radix-ui/react-radio-group") @react.component
    external make: (
      ~children: React.element,
      ~value: string,
      ~disabled: bool=?,
      ~required: bool=?,
      ~className: string=?,
      ~id: string=?,
    ) => React.element = "Item"
  }

  module Indicator = {
    @module("@radix-ui/react-radio-group") @react.component
    external make: (~className: string=?) => React.element = "Indicator"
  }
}

module Separator = {
  module Root = {
    @module("@radix-ui/react-separator") @react.component
    external make: (
      ~orientation: [#horizontal | #vertical]=?,
      ~decorative: bool=?,
      ~className: string=?,
    ) => React.element = "Root"
  }
}

module Tooltip = {
  module Root = {
    @module("@radix-ui/react-tooltip") @react.component
    external make: (
      ~children: React.element,
      ~defaultOpen: bool=?,
      ~_open: bool=?,
      ~onOpenChange: bool => unit=?,
      ~delayDuration: int=?,
      ~className: string=?,
    ) => React.element = "Root"
  }

  module Trigger = {
    @module("@radix-ui/react-tooltip") @react.component
    external make: (
      ~children: React.element,
      ~className: string=?,
      ~asChild: bool=?,
    ) => React.element = "Trigger"
  }

  module Content = {
    @module("@radix-ui/react-tooltip") @react.component
    external make: (
      ~children: React.element,
      ~side: [#top | #right | #bottom | #left]=?,
      ~sideOffset: int=?,
      ~align: [#start | #center | #end]=?,
      ~alignOffset: int=?,
      ~className: string=?,
      ~avoidCollisions: bool=?,
    ) => React.element = "Content"
  }

  module Arrow = {
    @module("@radix-ui/react-tooltip") @react.component
    external make: (
      ~width: int=?,
      ~height: int=?,
      ~offset: int=?,
      ~className: string=?,
    ) => React.element = "Arrow"
  }
}

module Collapsible = {
  module Root = {
    @module("@radix-ui/react-collapsible") @react.component
    external make: (
      ~children: React.element,
      ~defaultOpen: bool=?,
      ~_open: bool=?,
      ~onOpenChange: bool => unit=?,
      ~disabled: bool=?,
    ) => React.element = "Root"
  }

  module Trigger = {
    @module("@radix-ui/react-collapsible") @react.component
    external make: (~children: React.element, ~className: string=?) => React.element = "Trigger"
  }

  module Content = {
    @module("@radix-ui/react-collapsible") @react.component
    external make: (
      ~children: React.element,
      ~className: string=?,
      ~asChild: bool=?,
      ~forceMount: bool=?,
    ) => React.element = "Content"
  }
}

module ScrollArea = {
  type orientation = [#vertical | #horizontal]

  module Root = {
    @module("@radix-ui/react-scroll-area") @react.component
    external make: (
      ~children: React.element,
      ~className: string=?,
      ~asChild: bool=?,
      ~scrollHideDelay: int=?,
    ) => React.element = "Root"
  }

  module Viewport = {
    @module("@radix-ui/react-scroll-area") @react.component
    external make: (
      ~children: React.element,
      ~className: string=?,
      ~asChild: bool=?,
    ) => React.element = "Viewport"
  }

  module Scrollbar = {
    @module("@radix-ui/react-scroll-area") @react.component
    external make: (
      ~children: React.element,
      ~className: string=?,
      ~asChild: bool=?,
      ~orientation: orientation=?,
    ) => React.element = "Scrollbar"
  }

  module Thumb = {
    @module("@radix-ui/react-scroll-area") @react.component
    external make: (
      ~children: React.element=?,
      ~className: string=?,
      ~asChild: bool=?,
    ) => React.element = "Thumb"
  }

  module Corner = {
    @module("@radix-ui/react-scroll-area") @react.component
    external make: (
      ~children: React.element,
      ~className: string=?,
      ~asChild: bool=?,
    ) => React.element = "Corner"
  }
}

module HoverCard = {
  module Root = {
    @module("@radix-ui/react-hover-card") @react.component
    external make: (
      ~children: React.element,
      ~className: string=?,
      ~defaultOpen: bool=?,
      ~open_: bool=?,
      ~onOpenChange: option<bool => unit>=?,
      ~openDelay: int=?,
      ~closeDelay: int=?,
    ) => React.element = "Root"
  }

  module Trigger = {
    @module("@radix-ui/react-hover-card") @react.component
    external make: (
      ~children: React.element,
      ~className: string=?,
      ~asChild: bool=?,
    ) => React.element = "Trigger"
  }

  module Content = {
    type side = [#top | #right | #bottom | #left]

    @module("@radix-ui/react-hover-card") @react.component
    external make: (
      ~children: React.element,
      ~className: string=?,
      ~side: side=?,
    ) => React.element = "Content"
  }
}

module Tabs = {
  type orientation = [#horizontal | #vertical]
  type dir = [#ltr | #rtl] // reading direction - ltr: left to right / rtl: right to left
  type activationMode = [#automatic | #manual]

  module Root = {
    @module("@radix-ui/react-tabs") @react.component
    external make: (
      ~children: React.element,
      ~className: string=?,
      ~defaultValue: string=?,
      ~onValueChange: string => unit=?,
      ~orientation: orientation=?,
      ~dir: dir=?,
      ~activationMode: activationMode=?,
    ) => React.element = "Root"
  }

  module List = {
    @module("@radix-ui/react-tabs") @react.component
    external make: (
      ~children: React.element,
      ~asChild: bool=?,
      ~loop: bool=?,
      ~className: string=?,
    ) => React.element = "List"
  }

  module Trigger = {
    @module("@radix-ui/react-tabs") @react.component
    external make: (
      ~children: React.element,
      ~value: string,
      ~asChild: bool=?,
      ~disabled: bool=?,
      ~className: string=?,
    ) => React.element = "Trigger"
  }

  module Content = {
    @module("@radix-ui/react-tabs") @react.component
    external make: (
      ~children: React.element,
      ~value: string,
      ~asChild: bool=?,
      ~className: string=?,
    ) => React.element = "Content"
  }
}
