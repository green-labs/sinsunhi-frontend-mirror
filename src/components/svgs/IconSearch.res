@react.component
let make = (~width="36", ~height="36", ~className=?, ~fill="#fff") => {
  <svg ?className width height viewBox="0 0 36 36" fill="none" xmlns="http://www.w3.org/2000/svg">
    <path
      d="M15.4284 23.7857C20.044 23.7857 23.7856 20.0441 23.7856 15.4286C23.7856 10.813 20.044 7.07141 15.4284 7.07141C10.8129 7.07141 7.07129 10.813 7.07129 15.4286C7.07129 20.0441 10.8129 23.7857 15.4284 23.7857Z"
      stroke=fill
      strokeWidth="2"
      strokeLinecap="round"
      strokeLinejoin="round"
    />
    <path
      d="M28.9294 28.9282L22.0723 22.071"
      stroke=fill
      strokeWidth="2"
      strokeLinecap="round"
      strokeLinejoin="round"
    />
  </svg>
}
