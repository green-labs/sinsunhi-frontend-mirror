@react.component
let make = (~height, ~width, ~fill, ~className=?) =>
  <svg
    width
    height
    viewBox="0 0 24 24"
    fill="none"
    xmlns="http://www.w3.org/2000/svg"
    className={className->Option.getWithDefault("")}>
    <path
      fillRule="evenodd"
      clipRule="evenodd"
      d="M20.5387 7.47815C20.8269 7.77566 20.8194 8.25047 20.5218 8.53868L10.1993 18.5387C9.90842 18.8204 9.44642 18.8204 9.15557 18.5387L3.47815 13.0387C3.18065 12.7505 3.17311 12.2757 3.46132 11.9782C3.74953 11.6806 4.22434 11.6731 4.52185 11.9613L9.67742 16.9558L19.4782 7.46132C19.7757 7.17311 20.2505 7.18065 20.5387 7.47815Z"
      fill
    />
  </svg>
