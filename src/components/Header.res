type sellerTab = [#upload | #list | #downloadCenter | #shipments]

module User = {
  type kind = Seller | Buyer | Admin
  @react.component
  let make = (~kind) => {
    let router = Next.Router.useRouter()
    let user = CustomHooks.Auth.use()

    let logOut = (
      _ => {
        CustomHooks.Auth.logOut()
        ChannelTalkHelper.logout()
        let role = user->CustomHooks.Auth.toOption->Option.map(user' => user'.role)
        switch role {
        | Some(Seller) => router->Next.Router.push("/seller/signin")
        | Some(Buyer) => router->Next.Router.push("/buyer/signin")
        | Some(Admin) => router->Next.Router.push("/admin/signin")
        | None => ()
        }
      }
    )->ReactEvents.interceptingHandler

    <div id="gnb-user" className=%twc("relative flex items-center sm:h-16")>
      <RadixUI.DropDown.Root>
        // PC 뷰
        <RadixUI.DropDown.Trigger className=%twc("focus:outline-none")>
          <div className=%twc("hidden sm:flex sm:h-16 sm:items-center underline")>
            <span>
              {user
              ->CustomHooks.Auth.toOption
              ->Option.flatMap(user' =>
                switch kind {
                | Seller => Some(user'.name)
                | Buyer
                | Admin =>
                  user'.email
                }
              )
              ->Option.getWithDefault("")
              ->React.string}
            </span>
            <span className=%twc("relative ml-1")>
              <IconArrowSelect height="28" width="28" fill="#121212" />
            </span>
          </div>
          <div className=%twc("flex items-center h-16 sm:hidden")>
            <span
              className=%twc("flex w-8 h-8 rounded-full bg-gray-100 justify-center items-center")>
              {user
              ->CustomHooks.Auth.toOption
              ->Option.flatMap(user' =>
                switch kind {
                | Seller => Some(user'.name)
                | Buyer
                | Admin =>
                  user'.email
                }
              )
              ->Option.map(Js.String2.slice(~from=0, ~to_=1))
              ->Option.map(Js.String2.toUpperCase)
              ->Option.getWithDefault("")
              ->React.string}
            </span>
          </div>
        </RadixUI.DropDown.Trigger>
        <RadixUI.DropDown.Content
          align=#end className=%twc("dropdown-content bg-white shadow-gl p-2")>
          <RadixUI.DropDown.Item
            className=%twc("focus:outline-none hover:bg-div-shape-L1 rounded-lg")>
            <span
              className=%twc("block py-3 px-8 whitespace-nowrap cursor-default") onClick={logOut}>
              {j`로그아웃`->React.string}
            </span>
          </RadixUI.DropDown.Item>
          <RadixUI.DropDown.Item className=%twc("focus:outline-none")>
            <a href=Env.kakaotalkChannel target="_blank" className=%twc("cursor-default")>
              <span
                className=%twc(
                  "block py-3 px-8 whitespace-nowrap hover:bg-div-shape-L1 rounded-lg"
                )>
                {j`고객센터`->React.string}
              </span>
            </a>
          </RadixUI.DropDown.Item>
        </RadixUI.DropDown.Content>
      </RadixUI.DropDown.Root>
    </div>
  }
}

module Seller = {
  @react.component
  let make = () => {
    let router = Next.Router.useRouter()
    let tabActive = %twc(
      "block py-2 shadow-inner-b-4 shadow-green sm:h-16 sm:flex sm:items-center whitespace-nowrap"
    )
    let tabInactive = %twc(
      "block py-2 shadow-green sm:h-16 sm:flex sm:items-center text-gray-400 whitespace-nowrap"
    )
    let secondPathname =
      router.pathname->Js.String2.split("/")->Array.keep(x => x !== "")->Garter.Array.get(1)
    let tab: sellerTab =
      secondPathname
      ->Option.map(p =>
        switch p {
        | "upload" => #upload
        | "orders" => #list
        | "download-center" => #downloadCenter
        | "shipments" => #shipments
        | _ => #list
        }
      )
      ->Option.getWithDefault(#list)

    <nav>
      <ol
        className=%twc(
          "px-4 shadow-inner-b-1 shadow-gray sm:flex sm:items-center sm:justify-between sm:pl-10 sm:pr-4 md:px-20"
        )>
        <div className=%twc("flex flex-nowrap items-center")>
          <Next.Link href="/seller">
            <li className=%twc("flex-1 py-2")>
              <img
                src="/assets/sinsunhi-logo.svg"
                className=%twc("w-[86px] h-[22px] md:w-[100px] md:h-[25px]")
                alt=`신선하이 로고`
              />
            </li>
          </Next.Link>
          <li className=%twc("flex-1 flex justify-end sm:hidden")> <User kind=User.Seller /> </li>
        </div>
        <div className=%twc("flex flex-row overflow-x-scroll scrollbar-hide")>
          <Next.Link
            href={`/seller/shipments?from=${Js.Date.make()
              ->DateFns.subDays(7)
              ->DateFns.format("yyyy-MM-dd")}&to=${Js.Date.make()->DateFns.format("yyyy-MM-dd")}`}
            passHref=true>
            <a className=%twc("text-lg font-bold text-green-gl px-2 cursor-pointer min-w-max")>
              <span
                id="button"
                className={switch tab {
                | #upload => tabInactive
                | #list => tabInactive
                | #downloadCenter => tabInactive
                | #shipments => tabActive
                }}>
                {j`출하내역`->React.string}
              </span>
            </a>
          </Next.Link>
          <Next.Link href={`/seller/orders?status=CREATE&sort=created`} passHref=true>
            <a className=%twc("text-lg font-bold text-green-gl px-2 cursor-pointer min-w-max")>
              <span
                id="button"
                className={switch tab {
                | #upload => tabInactive
                | #list => tabActive
                | #downloadCenter => tabInactive
                | #shipments => tabInactive
                }}>
                {j`주문내역`->React.string}
              </span>
            </a>
          </Next.Link>
          <Next.Link href={`/seller/upload`} passHref=true>
            <a className=%twc("text-lg font-bold text-green-gl px-2 cursor-pointer min-w-max")>
              <span
                id="button"
                className={switch tab {
                | #upload => tabActive
                | #list => tabInactive
                | #downloadCenter => tabInactive
                | #shipments => tabInactive
                }}>
                {j`송장번호 대량 입력`->React.string}
              </span>
            </a>
          </Next.Link>
          <Next.Link href={`/seller/download-center`} passHref=true>
            <a className=%twc("text-lg font-bold text-green-gl px-2 cursor-pointer min-w-max")>
              <span
                id="button"
                className={switch tab {
                | #upload => tabInactive
                | #list => tabInactive
                | #downloadCenter => tabActive
                | #shipments => tabInactive
                }}>
                {j`다운로드 센터`->React.string}
              </span>
            </a>
          </Next.Link>
        </div>
        <li className=%twc("hidden sm:flex")> <User kind=User.Seller /> </li>
      </ol>
    </nav>
  }
}

module Admin = {
  @react.component
  let make = () => {
    <nav>
      <ol
        className=%twc(
          "px-4 shadow-inner-b-1 shadow-gray flex justify-between items-center h-16 sm:px-10 md:px-20"
        )>
        <li>
          <img
            src="/assets/sinsunhi-logo.svg"
            className=%twc("w-[86px] h-[22px] md:w-[100px] md:h-[25px]")
            alt=`신선하이 로고`
          />
        </li>
        <li> <User kind=User.Admin /> </li>
      </ol>
    </nav>
  }
}
