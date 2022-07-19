/*
  1. 컴포넌트 위치
  바이어 센터 전시 매장 > PDP Page > 판매자료 다운로드 컴포넌트
  
  2. 역할
  판매자료 다운로드 링크 유무를 고려하여 링크 컴포넌트를 보여줍니다.
*/

module MO = {
  @react.component
  let make = (~salesDocument) => {
    let {useRouter, push} = module(Next.Router)
    let router = useRouter()

    let user = CustomHooks.User.Buyer.use2()

    let (showWarning, setShowWarning) = React.Uncurried.useState(_ => ShopDialog_Buyer.Hide)

    let btnStyle = %twc(
      "group rounded-xl h-13 px-5 flex items-center justify-center focus:outline-none bg-white border border-green-500 hover:border-green-600"
    )

    let labelStyle = %twc("ml-2 font-bold text-green-500 group-hover:text-green-600")

    <section className=%twc("flex flex-col gap-5 px-5 py-8 border-t")>
      <div className=%twc("flex flex-col gap-4 text-center")>
        <div className=%twc("flex flex-col text-gray-800")>
          <span>
            <span className=%twc("font-bold")> {`판매자료 다운받기`->React.string} </span>
            {` 버튼을 누르시면`->React.string}
          </span>
          <span>
            {`이 상품을 바로 판매하고 매출을 올릴 수 있습니다.`->React.string}
          </span>
        </div>
        {switch user {
        | Unknown => React.null

        | LoggedIn(_) =>
          <Next.Link href=salesDocument>
            <a target="_blank" className=btnStyle>
              <IconDownloadCenter
                width="24" height="24" className=%twc("fill-green-500 group-hover:fill-green-600")
              />
              <span className=labelStyle> {`판매자료 다운받기`->React.string} </span>
            </a>
          </Next.Link>

        | NotLoggedIn => <>
            <button onClick={_ => setShowWarning(._ => Show)} className=btnStyle>
              <IconDownloadCenter
                width="24" height="24" className=%twc("fill-green-500 group-hover:fill-green-600")
              />
              <span className=labelStyle> {`판매자료 다운받기`->React.string} </span>
            </button>
            <ShopDialog_Buyer.Mo
              isShow=showWarning
              onCancel={_ => setShowWarning(._ => Hide)}
              onConfirm={_ => router->push(`/buyer/signin`)}
              cancelText=`취소`
              confirmText=`로그인`>
              <div
                className=%twc(
                  "w-full h-18 mt-8 px-8 py-6 flex flex-col items-center justify-center text-lg text-gray-800"
                )>
                <span> {`로그인을 하시면`->React.string} </span>
                <span> {`판매자료를 다운받으실 수 있습니다.`->React.string} </span>
              </div>
            </ShopDialog_Buyer.Mo>
          </>
        }}
      </div>
    </section>
  }
}

module PC = {
  @react.component
  let make = (~salesDocument) => {
    let {useRouter, push} = module(Next.Router)
    let router = useRouter()

    let user = CustomHooks.User.Buyer.use2()

    let (showWarning, setShowWarning) = React.Uncurried.useState(_ => ShopDialog_Buyer.Hide)

    let btnStyle = %twc(
      "group rounded-xl h-13 px-5 flex items-center justify-center focus:outline-none bg-white border border-green-500 hover:border-green-600"
    )
    let labelStyle = %twc("ml-2 font-bold text-green-500 group-hover:text-green-600")

    <>
      <div
        className=%twc("mt-12 w-full p-5 rounded-xl bg-gray-50 flex items-center justify-between")>
        <div className=%twc("flex flex-col text-gray-800")>
          <span>
            <span className=%twc("font-bold")> {`판매자료 다운받기`->React.string} </span>
            {` 버튼을 누르시면`->React.string}
          </span>
          <span>
            {`이 상품을 바로 판매하고 매출을 올릴 수 있습니다.`->React.string}
          </span>
        </div>
        {switch user {
        | Unknown => React.null

        | LoggedIn(_) =>
          <Next.Link href=salesDocument>
            <a target="_blank" className=btnStyle>
              <IconDownloadCenter
                width="24" height="24" className=%twc("fill-green-500 group-hover:fill-green-600")
              />
              <span className=labelStyle> {`판매자료 다운받기`->React.string} </span>
            </a>
          </Next.Link>

        | NotLoggedIn => <>
            <button onClick={_ => setShowWarning(._ => Show)} className=btnStyle>
              <IconDownloadCenter
                width="24" height="24" className=%twc("fill-green-500 group-hover:fill-green-600")
              />
              <span className=labelStyle> {`판매자료 다운받기`->React.string} </span>
            </button>
            <ShopDialog_Buyer
              isShow=showWarning
              onCancel={_ => setShowWarning(._ => Hide)}
              onConfirm={_ => router->push(`/buyer/signin`)}
              cancelText=`취소`
              confirmText=`로그인`>
              <div
                className=%twc(
                  "w-full h-18 mt-8 px-8 py-6 flex flex-col items-center justify-center text-lg text-gray-800"
                )>
                <span> {`로그인을 하시면`->React.string} </span>
                <span> {`판매자료를 다운받으실 수 있습니다.`->React.string} </span>
              </div>
            </ShopDialog_Buyer>
          </>
        }}
      </div>
      <div className=%twc("mt-4 text-gray-600")>
        {`신선하이의 물품 공급 및 판매 외 무단 게시 및 공유 적발시 법적 제재가 가해질 수 있습니다.`->React.string}
      </div>
    </>
  }
}
