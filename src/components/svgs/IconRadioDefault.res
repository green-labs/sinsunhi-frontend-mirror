@react.component
let make = (~width, ~height, ~fill, ~className=?) =>
  <svg width height viewBox="0 0 20 20" fill xmlns="http://www.w3.org/2000/svg" ?className>
    <circle cx="10" cy="10" r="9.25" fill="white" stroke="#D9D9D9" strokeWidth="1.5" />
  </svg>
