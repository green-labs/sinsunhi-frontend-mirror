/*
 *
 * 1. 위치: 바이어센터 메인 상단 검색창
 *
 * 2. 역할: 상품명을 입력받아서 검색결과 페이지로 이동한다
 *
 */

@react.component
let make = () => {
  let {useRouter, pushObj} = module(Next.Router)
  let router = useRouter()

  let (keyword, setKeyword) = React.Uncurried.useState(_ => "")
  let (isEditing, setEditing) = React.Uncurried.useState(_ => false)

  let inputStyle = {
    let default = %twc(
      "w-full h-full border-2 border-green-500 rounded-full px-4 remove-spin-button focus:outline-none focus:border-green-500 focus:ring-opacity-100 text-base"
    )
    isEditing ? cx([default, %twc("text-green-500")]) : default
  }

  let onChangeKeyword = e => setKeyword(._ => (e->ReactEvent.Synthetic.target)["value"])

  let submit = ReactEvents.interceptingHandler(_ => {
    if keyword == "" {
      ignore()
    } else {
      router->pushObj({
        pathname: "/buyer/search",
        query: Js.Dict.fromArray([("keyword", keyword->Js.Global.encodeURIComponent)]),
      })
    }
  })

  React.useEffect1(_ => {
    if router.pathname == "/buyer/search" {
      router.query
      ->Js.Dict.get("keyword")
      ->Option.map(Js.Global.decodeURIComponent)
      ->Option.map(keyword' => setKeyword(._ => keyword'))
      ->ignore
    } else {
      setKeyword(._ => "")
    }

    None
  }, [router])

  <form onSubmit={submit}>
    <div className={%twc("flex min-w-[658px] h-13 justify-center relative")}>
      <input
        className=inputStyle
        type_="text"
        name="shop-search"
        placeholder=`찾고있는 작물을 검색해보세요`
        value={keyword}
        onChange={onChangeKeyword}
        onFocus={_ => setEditing(._ => true)}
        onBlur={_ => setEditing(._ => false)}
      />
      <button
        type_="submit"
        className=%twc(
          "absolute right-0 h-[52px] bg-green-500 rounded-full focus:outline-none flex items-center justify-center px-6"
        )>
        <IconSearch width="36" height="36" stroke="#fff" />
        <span className=%twc("text-white font-bold")> {`검색`->React.string} </span>
      </button>
    </div>
  </form>
}

module MO = {
  @react.component
  let make = () => {
    let {useRouter, pushObj} = module(Next.Router)
    let router = useRouter()

    let (keyword, setKeyword) = React.Uncurried.useState(_ => "")
    let (isEditing, setEditing) = React.Uncurried.useState(_ => false)

    let inputStyle = {
      let default = %twc(
        "w-full h-10 border border-green-500 rounded-full px-4 remove-spin-button focus:outline-none focus:border-green-500 focus:ring-opacity-100 text-[15px]"
      )
      isEditing ? cx([default, %twc("text-green-500")]) : default
    }

    let onChangeKeyword = e => setKeyword(._ => (e->ReactEvent.Synthetic.target)["value"])

    let submit = ReactEvents.interceptingHandler(_ => {
      if keyword == "" {
        ignore()
      } else {
        router->pushObj({
          pathname: "/buyer/search",
          query: Js.Dict.fromArray([("keyword", keyword->Js.Global.encodeURIComponent)]),
        })
      }
    })

    React.useEffect1(_ => {
      if router.pathname == "/buyer/search" {
        router.query
        ->Js.Dict.get("keyword")
        ->Option.map(Js.Global.decodeURIComponent)
        ->Option.map(keyword' => setKeyword(._ => keyword'))
        ->ignore
      } else {
        setKeyword(._ => "")
      }

      None
    }, [router])

    <form onSubmit={submit} className=%twc("w-full")>
      <div className=%twc("relative w-full")>
        <input
          className={inputStyle}
          type_="text"
          name="shop-search"
          placeholder=`찾고있는 작물을 검색해보세요`
          value={keyword}
          onChange={onChangeKeyword}
          onFocus={_ => setEditing(._ => true)}
          onBlur={_ => setEditing(._ => false)}
        />
        {switch keyword {
        | "" => React.null
        | _ =>
          <img
            onClick={ReactEvents.interceptingHandler(_ => setKeyword(._ => ""))}
            src="/icons/reset-input-gray-circle@3x.png"
            className=%twc("absolute w-6 h-6 right-10 top-1/2 translate-y-[-50%]")
          />
        }}
        <button type_="submit" className=%twc("absolute right-3 top-1/2 translate-y-[-50%]")>
          <IconSearch width="24" height="24" stroke="#12B564" />
        </button>
      </div>
    </form>
  }
}
