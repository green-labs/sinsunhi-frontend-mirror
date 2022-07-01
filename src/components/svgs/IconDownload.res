@react.component
let make = (~width, ~height, ~fill, ~className) =>
  <svg width height viewBox="0 0 16 16" fill="none" xmlns="http://www.w3.org/2000/svg" className>
    <path
      d="M3.04541 6.75391L7.99973 11.7082L12.954 6.75391"
      stroke=fill
      strokeWidth="1.6"
      strokeLinecap="round"
      strokeLinejoin="round"
    />
    <path
      d="M8 11.7084V1.7998"
      stroke=fill
      strokeWidth="1.6"
      strokeLinecap="round"
      strokeLinejoin="round"
    />
    <path
      d="M14.1998 9.85986V14.2112H7.99981H1.7998V9.85986"
      stroke=fill
      strokeWidth="1.6"
      strokeLinecap="round"
      strokeLinejoin="round"
    />
  </svg>
