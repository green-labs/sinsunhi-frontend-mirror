@react.component
let make = (~height, ~width, ~fill, ~className=?) =>
  <svg width height viewBox="0 0 20 20" fill xmlns="http://www.w3.org/2000/svg" ?className>
    <path
      d="M2.91699 7.21582V14.3643L9.10812 17.9408V10.7878L2.91699 7.21582Z"
      fill="#262626"
      stroke="#262626"
      strokeWidth="0.6"
      strokeLinecap="round"
      strokeLinejoin="round"
    />
    <path
      d="M3.82031 5.86067L10.0114 9.43265L16.2071 5.86067L10.0114 2.28418L3.82031 5.86067Z"
      fill="#262626"
      stroke="#262626"
      strokeWidth="0.6"
      strokeLinecap="round"
      strokeLinejoin="round"
    />
    <path
      d="M10.9004 17.9408L17.0915 14.3643V7.21582L10.9004 10.7878V17.9408Z"
      fill="#262626"
      stroke="#262626"
      strokeWidth="0.6"
      strokeLinecap="round"
      strokeLinejoin="round"
    />
  </svg>
