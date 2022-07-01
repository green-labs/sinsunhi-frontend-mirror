@react.component
let make = (~height, ~width, ~fill="none", ~className=?) =>
  <svg
    width
    height
    viewBox="0 0 24 24"
    fill
    xmlns="http://www.w3.org/2000/svg"
    className={className->Option.getWithDefault("")}>
    <path
      d="M3.18981 12.7L10.9947 20.5049L10.0047 21.4948L1.00474 12.4948L0.509766 11.9999L1.00474 11.5049L10.0047 2.50488L10.9947 3.49483L3.18952 11.3H18.9995V12.7H3.18981Z"
      fill="black"
    />
  </svg>
