@react.component
let make = (~height, ~width, ~fill, ~className=?) =>
  <svg
    width
    height
    viewBox="0 0 20 20"
    fill="none"
    xmlns="http://www.w3.org/2000/svg"
    className={className->Option.getWithDefault("")}>
    <path
      d="M5.8335 16.666L12.5002 9.99935L5.8335 3.33268"
      stroke=fill
      strokeWidth="2"
      strokeLinecap="round"
      strokeLinejoin="round"
    />
  </svg>
