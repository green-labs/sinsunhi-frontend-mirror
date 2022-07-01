module Query = %relay(`
  query ShopCategorySelectBuyerQuery(
    $parentId: ID
    $types: [DisplayCategoryType!]
    $onlyDisplayable: Boolean
  ) {
    displayCategories(
      types: $types
      parentId: $parentId
      onlyDisplayable: $onlyDisplayable
    ) {
      id
      name
      children {
        id
      }
    }
  }
`)

/*
 *
 * 1. 위치: 모바일 뷰 바이어센터 메인 상단 전체 카테고리
 *
 * 2. 역할: 전시 카테고리 리스트를 2depth 까지 cascader 형태로 표현한다
 *
 */

module Mobile = {
  module Query = %relay(`
  query ShopCategorySelectBuyerMobileQuery(
    $parentId: ID
    $types: [DisplayCategoryType!]
    $onlyDisplayable: Boolean
  ) {
    displayCategories(
      types: $types
      parentId: $parentId
      onlyDisplayable: $onlyDisplayable
    ) {
      id
      name
      children {
        id
      }
    }
  
    gnbBanners {
      id
      title
      landingUrl
      isNewTabMobile
    }
  } 
  `)
  module Sub = {
    @react.component
    let make = (~parentId, ~parentName) => {
      let {displayCategories} = Query.use(
        ~variables=Query.makeVariables(~types=[#NORMAL], ~parentId, ~onlyDisplayable=true, ()),
        (),
      )

      let parentQueryStr = {
        [("category-id", parentId), ("category-name", parentName)]
        ->Webapi.Url.URLSearchParams.makeWithArray
        ->Webapi.Url.URLSearchParams.toString
      }

      <>
        <Next.Link href={`/buyer/products?${parentQueryStr}`}>
          <button
            className=%twc(
              "text-left px-5 py-3 bg-white flex justify-between items-center active:bg-bg-pressed-L2"
            )>
            <span className=%twc("font-bold")> {`전체보기`->React.string} </span>
            <IconArrow width="16" height="16" fill="#B2B2B2" />
          </button>
        </Next.Link>
        {displayCategories
        ->Array.map(({name, id}) => {
          let queryStr = {
            [("category-id", id), ("category-name", name->Js.Global.encodeURIComponent)]
            ->Webapi.Url.URLSearchParams.makeWithArray
            ->Webapi.Url.URLSearchParams.toString
          }

          <Next.Link href={`/buyer/products?${queryStr}`} key=id>
            <button
              className=%twc(
                "text-left px-5 py-3 bg-white flex justify-between items-center active:bg-bg-pressed-L2"
              )>
              {name->React.string} <IconArrow width="16" height="16" fill="#B2B2B2" />
            </button>
          </Next.Link>
        })
        ->React.array}
      </>
    }
  }

  @react.component
  let make = () => {
    let (isOpen, setOpen) = React.Uncurried.useState(_ => false)
    let close = () => setOpen(._ => false)
    let {displayCategories, gnbBanners} = Query.use(
      ~variables=Query.makeVariables(~types=[#NORMAL], ~onlyDisplayable=true, ()),
      (),
    )

    let defaultParentId = displayCategories->Array.get(0)->Option.map(({id}) => id)
    let (parentId, setParentId) = React.Uncurried.useState(_ => defaultParentId)

    let parent = {
      parentId->Option.flatMap(parentId' => {
        displayCategories->Array.getBy(({id}) => id == parentId')
      })
    }

    let clickedStyle = id => {
      switch parentId {
      | Some(parentId') => parentId' == id ? %twc("bg-white text-primary font-bold") : %twc("")
      | None => %twc("")
      }
    }

    let makeOnClick = id => ReactEvents.interceptingHandler(_ => setParentId(._ => Some(id)))

    <>
      <button onClick={_ => setOpen(._ => true)}>
        <IconHamburger width="28" height="28" fill="#12B564" />
      </button>
      {switch isOpen {
      | true =>
        <RemoveScroll>
          <div
            className={cx([
              %twc("w-full h-full fixed top-0 left-0 bg-gray-50 z-20 overflow-y-auto"),
            ])}>
            <div className=%twc("w-full max-w-3xl mx-auto bg-white min-h-full")>
              <div className=%twc("relative overflow-auto")>
                <div className=%twc("h-14 text-center py-4 px-5")>
                  <span className=%twc("font-bold text-xl")> {`카테고리`->React.string} </span>
                  <button className=%twc("float-right") onClick={_ => close()}>
                    <IconClose width="24" height="24" fill="#262626" />
                  </button>
                </div>
                <div className=%twc("flex flex-col")>
                  <div className=%twc("grid grid-cols-10 border-y min-h-[432px] text-[15px]")>
                    <div className=%twc("col-span-4 flex flex-col bg-surface")>
                      {displayCategories
                      ->Array.map(({id, name}) =>
                        <button
                          key=id
                          className={cx([
                            %twc(
                              "text-left px-5 py-3 border-b last:border-none active:bg-bg-pressed-L2"
                            ),
                            clickedStyle(id),
                          ])}
                          onClick={makeOnClick(id)}>
                          {name->React.string}
                        </button>
                      )
                      ->React.array}
                    </div>
                    <div className=%twc("col-span-6 flex flex-col border-none")>
                      <React.Suspense fallback={<div />}>
                        {parent->Option.mapWithDefault(React.null, ({id, name}) => {
                          <Sub parentId=id parentName=name />
                        })}
                      </React.Suspense>
                    </div>
                  </div>
                  {gnbBanners
                  ->Array.map(({title, id, landingUrl, isNewTabMobile}) =>
                    <Next.Link href={landingUrl} key=id>
                      <a
                        className=%twc("py-4 px-5 flex justify-between active:bg-bg-pressed-L2")
                        target={isNewTabMobile ? "_blank" : ""}
                        rel="noopener noreferer">
                        <div> {title->React.string} </div>
                        <IconArrow width="24" height="24" fill="#B2B2B2" />
                      </a>
                    </Next.Link>
                  )
                  ->React.array}
                </div>
              </div>
            </div>
          </div>
        </RemoveScroll>
      | false => React.null
      }}
    </>
  }
}

/*
 *
 * 1. 위치: 바이어센터 메인 상단 전체 카테고리
 *
 * 2. 역할: 전시 카테고리 리스트를 Cascader 형태로 표현한다
 *
 */

module PC = {
  module type RecursiveCategories = {
    @react.component
    let make: (~parentId: option<string>) => React.element
  }
  module rec RecursiveCategories: RecursiveCategories = {
    @react.component
    let make = (~parentId) => {
      let {pushObj, useRouter} = module(Next.Router)
      let router = useRouter()

      let {displayCategories} = Query.use(
        ~variables=Query.makeVariables(~types=[#NORMAL], ~parentId?, ~onlyDisplayable=true, ()),
        (),
      )
      let (hoveredId, setHoveredId) = React.Uncurried.useState((_): option<string> => None)

      let makeHoverChange = (~id, ~children, _) => {
        switch children {
        | [] => setHoveredId(._ => None)
        | _ => setHoveredId(._ => Some(id))
        }
      }

      let makeOnClick = (id, name) => {
        ReactEvents.interceptingHandler(_ => {
          router->pushObj({
            pathname: `/buyer/products`,
            query: [
              ("category-id", id),
              ("category-name", name->Js.Global.encodeURIComponent),
            ]->Js.Dict.fromArray,
          })
        })
      }

      switch displayCategories {
      | [] => React.null
      | _ => <>
          <div className=%twc("w-[222px] px-8 py-5 flex flex-col")>
            {displayCategories
            ->Array.map(({id, name, children}) => {
              <Hoverable
                key=id className=%twc("mt-3") onHoverChange={makeHoverChange(~id, ~children)}>
                <div
                  onClick={makeOnClick(id, name)}
                  className=%twc(
                    "w-full flex items-center justify-between group cursor-pointer group"
                  )>
                  <span
                    className=%twc(
                      "text-[15px] text-gray-800 group-hover:text-green-600 group-hover:font-bold"
                    )>
                    {name->React.string}
                  </span>
                  <span className=%twc("w-4 h-4")>
                    <IconArrow
                      className=%twc("hidden group-hover:block")
                      width="16"
                      height="16"
                      fill="#12B564"
                    />
                  </span>
                </div>
              </Hoverable>
            })
            ->React.array}
          </div>
          {hoveredId->Option.mapWithDefault(React.null, hoveredId' => {
            <React.Suspense fallback={<div className=%twc("w-[222px]") />}>
              <RecursiveCategories key=hoveredId' parentId=Some(hoveredId') />
            </React.Suspense>
          })}
        </>
      }
    }
  }

  @react.component
  let make = () => {
    let (isHovered, setIsHovered) = React.Uncurried.useState(_ => false)

    let triggerStyle = %twc("flex items-center w-56 h-[54px] px-7 ")
    let textStyle = %twc("mx-2 text-lg font-bold ")

    <div>
      <Hoverable onHoverChange={to_ => setIsHovered(._ => to_)}>
        {switch isHovered {
        | false =>
          <div className={triggerStyle ++ %twc("border-t border-x border-transparent")}>
            <IconHamburger width="24" height="18" />
            <span className={textStyle ++ %twc("text-text-L1")}>
              {`전체 카테고리`->React.string}
            </span>
            <IconArrow className=%twc("rotate-90") fill="#B2B2B2" width="20" height="20" />
          </div>
        | true => <>
            <div className={triggerStyle ++ %twc("border-t border-x border-primary")}>
              <IconHamburger width="24" height="18" />
              <span className={textStyle ++ %twc("text-primary")}>
                {`전체 카테고리`->React.string}
              </span>
              <IconArrow className=%twc("-rotate-90") fill="#12B564" width="20" height="20" />
            </div>
            <div className=%twc("relative")>
              <div
                className=%twc(
                  "h-[434px] bg-white absolute top-0 border border-green-500 flex divide-x"
                )>
                <React.Suspense fallback={<div className=%twc("w-[222px]") />}>
                  <RecursiveCategories parentId=None />
                </React.Suspense>
              </div>
              <div className=%twc("w-[222px] bg-white absolute top-0 left-[1px] h-1") />
            </div>
          </>
        }}
      </Hoverable>
    </div>
  }
}
