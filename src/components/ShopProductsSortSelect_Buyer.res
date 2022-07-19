/*
 *
 * 1. 위치:  바이어센터 매장 검색결과 상단 정렬기준
 *          바이어센터 매장 전시카테고리 상품 리스트 상단 정렬기준
 *
 * 2. 역할: 상품리스트의 정렬기준을 선택할 수 있다
 *
 */

@module("../../public/assets/arrow-gray800-up-down.svg")
external arrowUpDownIcon:string = "default"


let encodeSort = sort => {
  switch sort {
  | #UPDATED_ASC => "updated-asc"
  | #UPDATED_DESC => "updated-desc"
  | #PRICE_ASC => "price-asc"
  | #PRICE_DESC => "price-desc"
  | _ => ""
  }
}

let decodeSort = sortStr => {
  switch sortStr {
  | "updated-asc" => Some(#UPDATED_ASC)
  | "updated-desc" => Some(#UPDATED_DESC)
  | "price-asc" => Some(#PRICE_ASC)
  | "price-desc" => Some(#PRICE_DESC)
  | _ => None
  }
}

let makeSortLabel = sort => {
  switch sort {
  | #UPDATED_ASC => `오래된순`
  | #UPDATED_DESC => `최신순`
  | #PRICE_ASC => `낮은가격순`
  | #PRICE_DESC => `높은가격순`
  | _ => ""
  }
}


@react.component
let make = () => {
  let router = Next.Router.useRouter()
  let label =
    router.query
    ->Js.Dict.get("sort")
    ->Option.flatMap(decodeSort)
    ->Option.mapWithDefault(`최신순`, makeSortLabel)

  let (_open, setOpen) = React.Uncurried.useState(_ => false)

  let makeOnSelect = sort => {
    ReactEvents.interceptingHandler(_ => {
      setOpen(._ => false)
      let newQuery = router.query
      newQuery->Js.Dict.set("sort", sort->encodeSort)

      router->Next.Router.pushObj({
        pathname: router.pathname,
        query: newQuery,
      })
    })
  }

  open RadixUI.DropDown
  <div className=%twc("flex items-center")>
    <span className=%twc("text-gray-600 text-sm")> {`정렬기준: `->React.string} </span>
    <Root _open onOpenChange={to_ => setOpen(._ => to_)}>
      <Trigger className=%twc("focus:outline-none")>
        <div className=%twc("ml-2 flex items-center justify-center")>
          <span className=%twc("text-sm mr-1 text-gray-800")> {label->React.string} </span>
          <img src=arrowUpDownIcon />
        </div>
      </Trigger>
      <Content
        align=#start
        className=%twc(
          "dropdown-content bg-white shadow-lg p-1 border border-[#cccccc] rounded-lg cursor-pointer"
        )>
        <Item
          onSelect={#UPDATED_DESC->makeOnSelect}
          className=%twc(
            "w-[120px] p-2 focus:outline-none text-gray-800 hover:bg-gray-100 rounded-lg cursor-pointer"
          )>
          {#UPDATED_DESC->makeSortLabel->React.string}
        </Item>
        <Item
          onSelect={#PRICE_ASC->makeOnSelect}
          className=%twc(
            "w-[120px] p-2 focus:outline-none text-gray-800 hover:bg-gray-100 rounded-lg"
          )>
          {#PRICE_ASC->makeSortLabel->React.string}
        </Item>
      </Content>
    </Root>
  </div>
}

module MO = {
  @react.component
  let make = () => {
    let router = Next.Router.useRouter()
    let label =
      router.query
      ->Js.Dict.get("sort")
      ->Option.flatMap(decodeSort)
      ->Option.mapWithDefault(`최신순`, makeSortLabel)

    let (_open, setOpen) = React.Uncurried.useState(_ => false)

    let makeOnSelect = sort => {
      ReactEvents.interceptingHandler(_ => {
        setOpen(._ => false)
        let newQuery = router.query
        newQuery->Js.Dict.set("sort", sort->encodeSort)

        router->Next.Router.pushObj({
          pathname: router.pathname,
          query: newQuery,
        })
      })
    }

    open RadixUI.DropDown
    <div className=%twc("flex items-center")>
      <Root _open onOpenChange={to_ => setOpen(._ => to_)}>
        <Trigger className=%twc("focus:outline-none")>
          <div className=%twc("ml-2 flex items-center justify-center")>
            <span className=%twc("text-sm mr-1 text-gray-800")> {label->React.string} </span>
            <img src=arrowUpDownIcon />
          </div>
        </Trigger>
        <Content
          align=#start
          className=%twc(
            "dropdown-content bg-white shadow-lg p-1 border border-[#cccccc] rounded-lg cursor-pointer"
          )>
          <Item
            onSelect={#UPDATED_DESC->makeOnSelect}
            className=%twc(
              "w-[120px] p-2 focus:outline-none text-gray-800 hover:bg-gray-100 rounded-lg cursor-pointer"
            )>
            {#UPDATED_DESC->makeSortLabel->React.string}
          </Item>
          <Item
            onSelect={#PRICE_ASC->makeOnSelect}
            className=%twc(
              "w-[120px] p-2 focus:outline-none text-gray-800 hover:bg-gray-100 rounded-lg"
            )>
            {#PRICE_ASC->makeSortLabel->React.string}
          </Item>
        </Content>
      </Root>
    </div>
  }
}
