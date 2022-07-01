@react.component
let make = (~width, ~height, ~stroke="white") =>
  <svg width height viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg">
    <g clipPath="url(#clip0_76_5372)">
      <path
        d="M15.2417 5.75H4.91667C4.27233 5.75 3.75 6.27233 3.75 6.91667V13.025C3.75 13.6693 4.27233 14.1917 4.91667 14.1917H15.2417C15.886 14.1917 16.4083 13.6693 16.4083 13.025V6.91667C16.4083 6.27233 15.886 5.75 15.2417 5.75Z"
        stroke
        strokeMiterlimit="10"
      />
      <path d="M3.75 8.9248H16.4083" stroke strokeMiterlimit="10" />
    </g>
    <defs>
      <clipPath id="clip0_76_5372">
        <rect width="13.4917" height="9.275" fill="white" transform="translate(3.33325 5.33301)" />
      </clipPath>
    </defs>
  </svg>
