/*
 *  1. 위치: 바이어센터 메인, 회원가입을 통해 진입했을때 1회만 노출
 *
 *  2. 역할: embed된 외부 서베이 폼을 노출합니다.
 */

let dropByK = (dict, k) => {
  dict->Js.Dict.entries->Garter.Array.keep(((key, _)) => key != k)->Js.Dict.fromArray
}

@react.component
let make = () => {
  let {useRouter, replaceObj} = module(Next.Router)
  let router = useRouter()
  let user = CustomHooks.User.Buyer.use2()

  let (show, setShow) = React.Uncurried.useState(_ => false)

  let userPrefill = switch user {
  | LoggedIn(user') =>
    switch (user'.email, user'.phone) {
    | (Some(email), Some(phone)) => Some(`crtk4=${email}&d810t=${phone}`)
    | (Some(email), None) => Some(`crtk4=${email}`)
    | (None, Some(phone)) => Some(`d810t=${phone}`)
    | (None, None) => None
    }
  | NotLoggedIn
  | Unknown =>
    None
  }

  // welcome 파라메터가 있을 경우 서베이를 보여주고, 반복출력을 피하기 위해 welcome 파라메터를 제거
  React.useEffect1(() => {
    if router.query->Js.Dict.get("welcome")->Option.isSome {
      router->replaceObj({
        pathname: router.pathname,
        query: router.query->dropByK("welcome"),
      })
      setShow(._ => true)
    }

    None
  }, [router.query])

  {
    switch (show, user) {
    | (true, LoggedIn(_)) => <Paperform paperFormId=Env.buyerSignupSurveyKey prefill=userPrefill />
    | _ => React.null
    }
  }
}
