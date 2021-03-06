@react.component
let make = (~width, ~height, ~fill, ~className=?) =>
  <svg width height viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg" ?className>
    <rect width="24" height="24" fill="white" />
    <path
      fillRule="evenodd"
      clipRule="evenodd"
      d="M13.1251 2.55071C12.8494 2.53554 12.6251 2.76085 12.6251 3.03699V10.9926C12.6251 11.2687 12.849 11.4926 13.1251 11.4926L21.0807 11.4926C21.3569 11.4926 21.5822 11.2683 21.567 10.9926C21.3167 6.44465 17.6731 2.80098 13.1251 2.55071Z"
      fill
    />
    <path
      fillRule="evenodd"
      clipRule="evenodd"
      d="M11.0057 3.67016C11.2814 3.65498 11.5057 3.88029 11.5057 4.15644V12.1121C11.5057 12.3882 11.7295 12.6121 12.0057 12.6121L19.9613 12.612C20.2374 12.612 20.4627 12.8363 20.4476 13.112C20.1882 17.8255 16.2839 21.5677 11.5057 21.5677C6.55961 21.5677 2.55005 17.5581 2.55005 12.612C2.55005 7.83378 6.2922 3.92954 11.0057 3.67016Z"
      fill
    />
  </svg>
