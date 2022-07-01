module PlaceHolder = {
  @react.component
  let make = () => {
    open Skeleton
    <section className=%twc("flex flex-col gap-5 bg-white rounded-sm")>
      <span className=%twc("text-lg xl:text-xl text-enabled-L1 font-bold")>
        {`주문자 정보`->React.string}
      </span>
      <div className=%twc("flex text-sm")>
        <ul className=%twc("w-23 flex flex-col gap-2 font-bold")>
          <li> {`주문자명`->React.string} </li>
          <li> {`연락처`->React.string} </li>
          <li> {`이메일`->React.string} </li>
        </ul>
        <ul className=%twc("flex flex-col")>
          <Box className=%twc("w-20") />
          <Box className=%twc("w-20") />
          <Box className=%twc("w-20") />
        </ul>
      </div>
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

  <section className=%twc("flex flex-col gap-5 bg-white rounded-sm")>
    <span className=%twc("text-lg xl:text-xl text-enabled-L1 font-bold")>
      {`주문자 정보`->React.string}
    </span>
    <div className=%twc("flex text-sm")>
      <ul className=%twc("w-23 flex flex-col gap-2 font-bold")>
        <li> {`주문자명`->React.string} </li>
        <li> {`연락처`->React.string} </li>
        <li> {`이메일`->React.string} </li>
      </ul>
      <ul className=%twc("flex flex-col gap-2")>
        {switch user {
        | LoggedIn(user') => <>
            <li> {user'.name->React.string} </li>
            <li> {user'.phone->Option.getWithDefault(`-`)->toPhoneNumberForm->React.string} </li>
            <li> {user'.email->Option.getWithDefault(`-`)->React.string} </li>
          </>
        | _ => React.null
        }}
      </ul>
    </div>
  </section>
}
