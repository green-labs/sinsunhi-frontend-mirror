@react.component
let make = (~height, ~width, ~fill) =>
  <svg width height viewBox="0 0 28 28" fill xmlns="http://www.w3.org/2000/svg">
    <circle cx="14" cy="14" r="10" fill />
    <path
      d="M18 10L10 18" stroke="white" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"
    />
    <path
      d="M10 10L18 18" stroke="white" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"
    />
  </svg>
