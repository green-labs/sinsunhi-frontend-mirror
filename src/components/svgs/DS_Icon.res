module Common = {
  module LineCheckedMedium1 = {
    @react.component
    let make = (~height, ~width, ~fill=?, ~className=?) =>
      <svg
        width
        height
        viewBox="0 0 16 16"
        xmlns="http://www.w3.org/2000/svg"
        className={className->Option.getWithDefault("")}>
        <path
          fillRule="evenodd"
          clipRule="evenodd"
          d="M12.997 5.31919L12.0158 4.33789L6.80654 9.51589L3.94123 6.7511L3.00757 7.77989L6.84312 11.4401L12.997 5.31919Z"
          fill={fill->Option.getWithDefault("black")}
        />
      </svg>
  }
  module LineCheckedLarge1 = {
    @react.component
    let make = (~height, ~width, ~fill=?, ~className=?) =>
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
          fill={fill->Option.getWithDefault("black")}
        />
      </svg>
  }
  module CheckedLarge1 = {
    @react.component
    let make = (~height, ~width, ~fill=?, ~className=?) =>
      <svg
        width
        height
        viewBox="0 0 24 24"
        fill="none"
        className={className->Option.getWithDefault("")}
        xmlns="http://www.w3.org/2000/svg">
        <path
          fillRule="evenodd"
          clipRule="evenodd"
          d="M3 1C1.89543 1 1 1.89543 1 3V21C1 22.1046 1.89543 23 3 23H21C22.1046 23 23 22.1046 23 21V3C23 1.89543 22.1046 1 21 1H3ZM17.7348 9.67829C18.1094 9.27246 18.0841 8.63981 17.6783 8.2652C17.2725 7.8906 16.6398 7.9159 16.2652 8.32172L10.9712 14.0569L7.70711 10.7929C7.31658 10.4024 6.68342 10.4024 6.29289 10.7929C5.90237 11.1834 5.90237 11.8166 6.29289 12.2071L10.2929 16.2071C10.4853 16.3996 10.7479 16.5052 11.02 16.4998C11.2921 16.4944 11.5502 16.3783 11.7348 16.1783L17.7348 9.67829Z"
          fill={fill->Option.getWithDefault("black")}
        />
      </svg>
  }

  module UncheckedLarge1 = {
    @react.component
    let make = (~height, ~width, ~fill=?, ~className=?) =>
      <svg
        width
        height
        viewBox="0 0 24 24"
        fill={fill->Option.getWithDefault("none")}
        className={className->Option.getWithDefault("")}
        xmlns="http://www.w3.org/2000/svg">
        <path
          fillRule="evenodd"
          clipRule="evenodd"
          d="M21 2.4H3C2.66863 2.4 2.4 2.66863 2.4 3V21C2.4 21.3314 2.66863 21.6 3 21.6H21C21.3314 21.6 21.6 21.3314 21.6 21V3C21.6 2.66863 21.3314 2.4 21 2.4ZM3 1C1.89543 1 1 1.89543 1 3V21C1 22.1046 1.89543 23 3 23H21C22.1046 23 23 22.1046 23 21V3C23 1.89543 22.1046 1 21 1H3Z"
          fill="#B2B2B2"
        />
        <path
          opacity="0.3"
          fillRule="evenodd"
          clipRule="evenodd"
          d="M17.6783 8.2652C18.0841 8.63981 18.1094 9.27246 17.7348 9.67829L11.7348 16.1783C11.5502 16.3783 11.2921 16.4944 11.02 16.4998C10.7479 16.5052 10.4853 16.3996 10.2929 16.2071L6.29289 12.2071C5.90237 11.8166 5.90237 11.1834 6.29289 10.7929C6.68342 10.4024 7.31658 10.4024 7.70711 10.7929L10.9712 14.0569L16.2652 8.32172C16.6398 7.9159 17.2725 7.8906 17.6783 8.2652Z"
          fill="#B2B2B2"
        />
      </svg>
  }

  module DeleteMedium1 = {
    @react.component
    let make = (~height, ~width, ~fill=?, ~className=?) =>
      <svg
        width
        height
        viewBox="0 0 16 16"
        xmlns="http://www.w3.org/2000/svg"
        className={className->Option.getWithDefault("")}>
        <path
          fillRule="evenodd"
          clipRule="evenodd"
          d="M7.99997 1.3335C8.29452 1.3335 8.5333 1.57228 8.5333 1.86683V3.34017H12.26H13.8333C14.1279 3.34017 14.3666 3.57895 14.3666 3.8735C14.3666 4.16805 14.1279 4.40684 13.8333 4.40684H12.7837L12.6199 13.4565C12.6146 13.7472 12.3774 13.9802 12.0866 13.9802H3.91329C3.6225 13.9802 3.38531 13.7472 3.38005 13.4565L3.21619 4.40684H2.16663C1.87208 4.40684 1.6333 4.16805 1.6333 3.8735C1.6333 3.57895 1.87208 3.34017 2.16663 3.34017H3.73996H7.46663V1.86683C7.46663 1.57228 7.70542 1.3335 7.99997 1.3335ZM11.7169 4.40684H4.28304L4.43706 12.9135H11.5629L11.7169 4.40684ZM8.49326 6.0068C8.49326 5.71225 8.25448 5.47347 7.95993 5.47347C7.66538 5.47347 7.4266 5.71225 7.4266 6.0068V11.4401C7.4266 11.7347 7.66538 11.9735 7.95993 11.9735C8.25448 11.9735 8.49326 11.7347 8.49326 11.4401V6.0068ZM10.08 5.47347C10.3745 5.47347 10.6133 5.71225 10.6133 6.0068V11.4401C10.6133 11.7347 10.3745 11.9735 10.08 11.9735C9.78541 11.9735 9.54663 11.7347 9.54663 11.4401V6.0068C9.54663 5.71225 9.78541 5.47347 10.08 5.47347ZM6.37331 6.0068C6.37331 5.71225 6.13453 5.47347 5.83997 5.47347C5.54542 5.47347 5.30664 5.71225 5.30664 6.0068V11.4401C5.30664 11.7347 5.54542 11.9735 5.83997 11.9735C6.13453 11.9735 6.37331 11.7347 6.37331 11.4401V6.0068Z"
          fill={fill->Option.getWithDefault("#262626")}
        />
      </svg>
  }
  module ArrowLeftXLarge1 = {
    @react.component
    let make = (~height, ~width, ~fill=?, ~className=?) =>
      <svg
        width
        height
        viewBox="0 0 32 32"
        fill="none"
        xmlns="http://www.w3.org/2000/svg"
        className={className->Option.getWithDefault("")}>
        <path
          fillRule="evenodd"
          clipRule="evenodd"
          d="M9.11631 16.8839C8.62815 16.3957 8.62815 15.6043 9.11631 15.1161L18.1162 6.11619C18.6044 5.62804 19.3958 5.62804 19.884 6.11619C20.3722 6.60435 20.3722 7.3958 19.884 7.88396L11.768 16L19.884 24.116C20.3722 24.6042 20.3722 25.3957 19.884 25.8838C19.3958 26.372 18.6044 26.372 18.1162 25.8838L9.11631 16.8839Z"
          fill={fill->Option.getWithDefault("#262626")}
        />
      </svg>
  }
  module ArrowRightLarge1 = {
    @react.component
    let make = (~height, ~width, ~fill=?, ~className=?) =>
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
          d="M13.5594 12L8.5 17.0345L9.4703 18L15.5 12L9.4703 6L8.5 6.96552L13.5594 12Z"
          fill={fill->Option.getWithDefault("black")}
        />
      </svg>
  }
  module RadioOnLarge1 = {
    @react.component
    let make = (~height, ~width, ~fill=?, ~className=?) =>
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
          d="M12 23C18.0751 23 23 18.0751 23 12C23 5.92487 18.0751 1 12 1C5.92487 1 1 5.92487 1 12C1 18.0751 5.92487 23 12 23ZM12 8C14.2091 8 16 9.79086 16 12C16 14.2091 14.2091 16 12 16C9.79086 16 8 14.2091 8 12C8 9.79086 9.79086 8 12 8Z"
          fill={fill->Option.getWithDefault("black")}
        />
      </svg>
  }
  module RadioOffLarge1 = {
    @react.component
    let make = (~height, ~width, ~fill=?, ~className=?) =>
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
          d="M12 21.6C17.3019 21.6 21.6 17.3019 21.6 12C21.6 6.69807 17.3019 2.4 12 2.4C6.69807 2.4 2.4 6.69807 2.4 12C2.4 17.3019 6.69807 21.6 12 21.6ZM12 23C18.0751 23 23 18.0751 23 12C23 5.92487 18.0751 1 12 1C5.92487 1 1 5.92487 1 12C1 18.0751 5.92487 23 12 23Z"
          fill={fill->Option.getWithDefault("black")}
        />
        <circle
          r="4" transform="matrix(1 0 0 -1 12 12)" fill={fill->Option.getWithDefault("black")}
        />
      </svg>
  }
  module SelectLarge1 = {
    @react.component
    let make = (~height, ~width, ~fill=?, ~className=?, ~stroke=?) =>
      <svg
        width
        height
        viewBox="0 0 24 24"
        fill="none"
        xmlns="http://www.w3.org/2000/svg"
        className={className->Option.getWithDefault("")}>
        <path
          d="M8.71046 15.9562C8.50218 15.7479 8.16449 15.7479 7.95621 15.9562C7.74793 16.1645 7.74793 16.5022 7.95621 16.7105L11.2895 20.0438C11.4978 20.2521 11.8355 20.2521 12.0438 20.0438L15.3771 16.7105C15.5854 16.5022 15.5854 16.1645 15.3771 15.9562C15.1688 15.7479 14.8312 15.7479 14.6229 15.9562L11.6667 18.9124L8.71046 15.9562Z"
          fill={fill->Option.getWithDefault("black")}
          stroke={stroke->Option.getWithDefault("black")}
          strokeWidth="0.4"
          strokeLinecap="round"
          strokeLinejoin="round"
        />
        <path
          d="M8.71046 8.04379C8.50218 8.25207 8.16449 8.25207 7.95621 8.04379C7.74793 7.83551 7.74793 7.49782 7.95621 7.28954L11.2895 3.95621C11.4978 3.74793 11.8355 3.74793 12.0438 3.95621L15.3771 7.28954C15.5854 7.49782 15.5854 7.83551 15.3771 8.04379C15.1688 8.25207 14.8312 8.25207 14.6229 8.04379L11.6667 5.08758L8.71046 8.04379Z"
          fill={fill->Option.getWithDefault("black")}
          stroke={stroke->Option.getWithDefault("black")}
          strokeWidth="0.4"
          strokeLinecap="round"
          strokeLinejoin="round"
        />
      </svg>
  }
  module CheckedLarge2 = {
    @react.component
    let make = (~height, ~width, ~fill=?, ~className=?) =>
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
          d="M23 12C23 18.0751 18.0751 23 12 23C5.92487 23 1 18.0751 1 12C1 5.92487 5.92487 1 12 1C18.0751 1 23 5.92487 23 12ZM11.0573 13.7136L16.2652 8.07172C16.6398 7.6659 17.2725 7.6406 17.6783 8.0152C18.0841 8.38981 18.1094 9.02246 17.7348 9.42829L11.7348 15.9283C11.5502 16.1283 11.2921 16.2444 11.02 16.2498C10.7479 16.2552 10.4853 16.1496 10.2929 15.9571L6.29289 11.9571C5.90237 11.5666 5.90237 10.9334 6.29289 10.5429C6.68342 10.1524 7.31658 10.1524 7.70711 10.5429L9.11515 11.9509L11.0573 13.7136Z"
          fill={fill->Option.getWithDefault("black")}
        />
      </svg>
  }
  module ArrowDownLarge1 = {
    @react.component
    let make = (~height, ~width, ~fill=?, ~className=?) =>
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
          d="M12 13.5594L6.96552 8.5L6 9.4703L12 15.5L18 9.4703L17.0345 8.5L12 13.5594Z"
          fill={fill->Option.getWithDefault("black")}
        />
      </svg>
  }
  module RefreshMedium1 = {
    @react.component
    let make = (~height, ~width, ~fill=?, ~className=?) =>
      <svg
        width
        height
        viewBox="0 0 16 16"
        fill="none"
        xmlns="http://www.w3.org/2000/svg"
        className={className->Option.getWithDefault("")}>
        <path
          d="M3.25063 8.21314C3.13426 5.59407 5.14922 3.37618 7.75082 3.25908C9.35923 3.18657 11 4.00016 11.6158 5.00049H12.677V4.22382C11.6158 2.80604 9.75445 1.91376 7.69507 2.00661C4.40585 2.15465 1.85897 4.95862 2.00606 8.26914C2.15317 11.5793 4.94012 14.1424 8.22902 13.9944C11.2225 13.8592 13.6509 11.4327 13.9011 8.5H12.6501C12.4044 10.7728 10.5057 12.6365 8.17326 12.7419C5.5714 12.859 3.36697 10.8312 3.25063 8.21314Z"
          fill="black"
        />
        <path
          fillRule="evenodd"
          clipRule="evenodd"
          d="M12.3 4.8V2H13.7V6.2H9.5V4.8H12.3Z"
          fill={fill->Option.getWithDefault("black")}
        />
      </svg>
  }
  module ClearMedium1 = {
    @react.component
    let make = (~height, ~width, ~fill=?, ~className=?) =>
      <svg
        width
        height
        viewBox="0 0 16 16"
        fill="none"
        xmlns="http://www.w3.org/2000/svg"
        className={className->Option.getWithDefault("")}>
        <path
          fillRule="evenodd"
          clipRule="evenodd"
          d="M8 16C12.4183 16 16 12.4183 16 8C16 3.58172 12.4183 0 8 0C3.58172 0 0 3.58172 0 8C0 12.4183 3.58172 16 8 16ZM10.9593 4.57134L11.7618 5.37946L8.95312 8.20781L11.7619 11.0363L10.9594 11.8444L8.15063 9.01593L5.34184 11.8444L4.53935 11.0363L7.34814 8.20781L4.5395 5.37946L5.34199 4.57134L8.15063 7.39969L10.9593 4.57134Z"
          fill={fill->Option.getWithDefault("black")}
        />
      </svg>
  }
  module PlusSmall1 = {
    @react.component
    let make = (~height, ~width, ~fill=?, ~className=?) =>
      <svg
        width
        height
        viewBox="0 0 12 12"
        fill="none"
        xmlns="http://www.w3.org/2000/svg"
        className={className->Option.getWithDefault("")}>
        <path
          fillRule="evenodd"
          clipRule="evenodd"
          d="M5.3 6.7V12H6.7V6.7H12V5.3H6.7V0H5.3V5.3H0V6.7H5.3Z"
          fill={fill->Option.getWithDefault("black")}
        />
      </svg>
  }
  module EditSmall1 = {
    @react.component
    let make = (~height, ~width, ~fill=?, ~className=?) =>
      <svg
        width
        height
        viewBox="0 0 14 14"
        fill="none"
        xmlns="http://www.w3.org/2000/svg"
        className={className->Option.getWithDefault("")}>
        <path
          fillRule="evenodd"
          clipRule="evenodd"
          d="M11.1807 5.17709L8.853 2.85889L1.78238 9.90156L1.02531 12.5236C0.925668 12.8713 1.12921 13.0741 1.47767 12.9748L4.10979 12.221L11.1807 5.17709Z"
          fill={fill->Option.getWithDefault("black")}
        />
        <path
          fillRule="evenodd"
          clipRule="evenodd"
          d="M11.0416 1.09578C10.914 0.968072 10.7041 0.968072 10.5758 1.09578L9.55176 2.1624L11.8783 4.48121L12.9036 3.41399C13.0318 3.28688 13.0318 3.07776 12.9036 2.95065L11.0416 1.09578Z"
          fill={fill->Option.getWithDefault("black")}
        />
      </svg>
  }
  module CloseLarge2 = {
    @react.component
    let make = (~height, ~width, ~fill=?, ~className=?) =>
      <svg
        width
        height
        viewBox="0 0 24 24"
        fill="none"
        xmlns="http://www.w3.org/2000/svg"
        className={className->Option.getWithDefault("")}>
        <path
          d="M12.9232 12.0764L18.2973 6.69203L17.3073 5.7002L11.9333 11.0845L6.69014 5.83136L5.7002 6.8232L10.9433 12.0764L5.85222 17.1772L6.84217 18.169L11.9333 13.0682L17.1553 18.3002L18.1453 17.3084L12.9232 12.0764Z"
          fill={fill->Option.getWithDefault("black")}
        />
      </svg>
  }
  module PeriodSmall1 = {
    @react.component
    let make = (~height, ~width, ~fill=?, ~className=?) =>
      <svg
        width
        height
        viewBox="0 0 14 14"
        fill="none"
        xmlns="http://www.w3.org/2000/svg"
        className={className->Option.getWithDefault("")}>
        <circle
          cx="7" cy="7" r="6.4" stroke={fill->Option.getWithDefault("#FF2B35")} strokeWidth="1.2"
        />
        <path
          d="M6.4 7.5C6.4 7.83137 6.66863 8.1 7 8.1C7.33137 8.1 7.6 7.83137 7.6 7.5H6.4ZM7.6 4C7.6 3.66863 7.33137 3.4 7 3.4C6.66863 3.4 6.4 3.66863 6.4 4H7.6ZM7.6 7.5V4H6.4V7.5H7.6Z"
          fill={fill->Option.getWithDefault("#FF2B35")}
        />
        <path
          d="M7.42426 7.07574C7.18995 6.84142 6.81005 6.84142 6.57574 7.07574C6.34142 7.31005 6.34142 7.68995 6.57574 7.92426L7.42426 7.07574ZM9.07574 10.4243C9.31005 10.6586 9.68995 10.6586 9.92426 10.4243C10.1586 10.1899 10.1586 9.81005 9.92426 9.57574L9.07574 10.4243ZM6.57574 7.92426L9.07574 10.4243L9.92426 9.57574L7.42426 7.07574L6.57574 7.92426Z"
          fill={fill->Option.getWithDefault("#FF2B35")}
        />
      </svg>
  }
}
