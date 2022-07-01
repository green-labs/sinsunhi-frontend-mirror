@react.component
let make = (~width, ~height, ~className=?) =>
  <svg width height viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg" ?className>
    <circle cx="10" cy="10" r="7.4" stroke="#FF2B35" strokeWidth="1.2" />
    <path d="M10 6V11.5" stroke="#FF2B35" strokeWidth="1.2" strokeLinecap="round" />
    <circle cx="10" cy="14" r="0.5" fill="#FF2B35" stroke="#FF2B35" strokeWidth="0.5" />
  </svg>
