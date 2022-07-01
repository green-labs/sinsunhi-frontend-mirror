module Placeholder = {
  @react.component
  let make = () => {
    open Skeleton
    <section className=%twc("flex flex-col gap-5 bg-white rounded-sm")>
      <span className=%twc("text-lg xl:text-xl text-enabled-L1 font-bold")>
        {`주문자 정보`->React.string}
      </span>
      <ul className=%twc("flex flex-col")>
        <li className=%twc("flex gap-5")>
          <Box className=%twc("w-18") /> <Box className=%twc("w-32") />
        </li>
        <li className=%twc("flex gap-5")>
          <Box className=%twc("w-18") /> <Box className=%twc("w-32") />
        </li>
        <li className=%twc("flex gap-5")>
          <Box className=%twc("w-18") /> <Box className=%twc("w-32") />
        </li>
      </ul>
    </section>
  }
}

@react.component
let make = () => {
  let user = CustomHooks.User.Buyer.use2()

  let toPhoneNumberForm = s =>
    s
    ->Js.String2.replaceByRe(%re("/[^0-9]/g"), "")
    ->Js.String2.replaceByRe(%re("/(^1[0-9]{3}|^0[0-9]{2})([0-9]+)?([0-9]{4})$/"), "$1-$2-$3")
    ->Js.String2.replace("--", "-")

  {
    switch user {
    | LoggedIn(user') =>
      <section className=%twc("flex flex-col gap-5 bg-white rounded-sm")>
        <span className=%twc("text-lg xl:text-xl text-enabled-L1 font-bold")>
          {`주문자 정보`->React.string}
        </span>
        <ul className=%twc("flex flex-col text-sm gap-2")>
          <li className=%twc("flex")>
            <span className=%twc("w-23 font-bold")> {`주문자명`->React.string} </span>
            <span> {user'.name->React.string} </span>
          </li>
          <li className=%twc("flex")>
            <span className=%twc("w-23 font-bold")> {`연락처`->React.string} </span>
            <span>
              {user'.phone->Option.getWithDefault(`-`)->toPhoneNumberForm->React.string}
            </span>
          </li>
          <li className=%twc("flex")>
            <span className=%twc("w-23 font-bold")> {`이메일`->React.string} </span>
            <span> {user'.email->Option.getWithDefault(`-`)->React.string} </span>
          </li>
        </ul>
      </section>
    | _ => <Placeholder />
    }
  }
}
