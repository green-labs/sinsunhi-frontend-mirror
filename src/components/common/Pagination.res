// pageDisplaySize -> 표시할 페이지의 갯수
// cur -> 현재 페이지
// itemPerPage -> 페이지 당 item 갯수
// total -> 총 item 갯수

module Template = {
  @react.component
  let make = (~cur, ~pageDisplySize, ~itemPerPage, ~total, ~handleOnChangePage=?) => {
    let totalPage = (total->Float.fromInt /. itemPerPage->Float.fromInt)->Js.Math.ceil_int
    let (start, end) = {
      let nth = (cur - 1) / pageDisplySize
      let start = pageDisplySize * nth + 1
      let end = Js.Math.min_int(start + pageDisplySize - 1, totalPage)
      (start, end)
    }

    let isDisabledLeft = start <= 1
    let isDisabledRight = end >= totalPage
    let buttonStyle = i =>
      cur === i ? %twc("w-10 h-12 text-center font-bold") : %twc("w-10 h-12 text-center")

    <ol className=%twc("flex")>
      <button
        value={(start - 1)->Int.toString}
        onClick=?handleOnChangePage
        className={cx([
          %twc(
            "transform rotate-180 w-12 h-12 rounded-full bg-gray-100 flex justify-center items-center mr-4"
          ),
          isDisabledLeft ? %twc("cursor-not-allowed") : %twc("cursor-pointer"),
        ])}
        disabled=isDisabledLeft>
        <IconArrow
          height="20"
          width="20"
          stroke={isDisabledLeft ? "#CCCCCC" : "#727272"}
          className=%twc("relative -right-0.5")
        />
      </button>
      {Array.range(start, end)
      ->Array.map(i =>
        <li key={i->Int.toString}>
          <button value={i->Int.toString} onClick=?handleOnChangePage className={buttonStyle(i)}>
            {i->Int.toString->React.string}
          </button>
        </li>
      )
      ->React.array}
      <button
        value={(end + 1)->Int.toString}
        onClick=?handleOnChangePage
        className={cx([
          %twc("w-12 h-12 rounded-full bg-gray-100 flex justify-center items-center ml-4"),
          isDisabledRight ? %twc("cursor-not-allowed") : %twc("cursor-pointer"),
        ])}
        disabled=isDisabledRight>
        <IconArrow
          height="20"
          width="20"
          stroke={isDisabledRight ? "#CCCCCC" : "#727272"}
          className=%twc("relative -right-0.5")
        />
      </button>
    </ol>
  }
}

@react.component
let make = (~pageDisplySize, ~itemPerPage, ~total, ~onChangePage=?) => {
  let router = Next.Router.useRouter()
  let cur =
    router.query
    ->Js.Dict.get("offset")
    ->Option.flatMap(offset' =>
      offset'->Int.fromString->Option.map(offset'' => offset'' / itemPerPage + 1)
    )
    ->Option.getWithDefault(1)

  let handleOnChangePage = e => {
    e->ReactEvent.Synthetic.preventDefault
    e->ReactEvent.Synthetic.stopPropagation

    let value = (e->ReactEvent.Synthetic.currentTarget)["value"]
    router.query->Js.Dict.set("offset", ((value - 1) * itemPerPage)->Int.toString)
    let newQueryString =
      router.query->Webapi.Url.URLSearchParams.makeWithDict->Webapi.Url.URLSearchParams.toString

    switch onChangePage {
    | Some(f) => newQueryString->f
    | None => router->Next.Router.push(`${router.pathname}?${newQueryString}`)
    }
  }

  <Template cur pageDisplySize itemPerPage total handleOnChangePage />
}
