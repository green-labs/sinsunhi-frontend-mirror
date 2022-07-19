/*
 * 1. 컴포넌트 위치
 *    PDP > 매칭상품 > 모바일 헤더
 *
 * 2. 역할
 *    매칭 상품의 모바일 뷰 헤더를 표현합니다.
 *
 */

module Fragment = %relay(`
  fragment PDPMatchingHeaderBuyer_fragment on MatchingProduct {
    category {
      id
      parent {
        name
        children {
          id
          name
          matchingProduct {
            id
            status
          }
        }
      }
    }
  }
`)

@react.component
let make = (~query) => {
  let router = Next.Router.useRouter()
  let direction = CustomHooks.Scroll.useScrollDirection()

  let {category: {id: categoryId, parent}} = query->Fragment.use

  let (parentName, siblings) = {
    parent->Option.mapWithDefault(("", []), ({name, children}) => (name, children))
  }

  let foldableStyle = switch direction {
  | ScrollStop => %twc("top-14") // default
  | ScrollDown => %twc("top-0 ease-out duration-200")
  | ScrollUp => %twc("top-14 ease-out duration-200")
  }

  // 선택된 카테고리를 센터에 위치하도록 하는 useEffect,
  // 추후 별도로 분리 예정
  React.useEffect1(() => {
    open Webapi
    let windowWidth = Dom.window->Dom.Window.innerWidth
    let container = Dom.document->Dom.Document.getElementById("horizontal-scroll-container")
    let target = Dom.document->Dom.Document.getElementById(`display-category-${categoryId}`)

    switch (container, target) {
    | (Some(container'), Some(target')) => {
        let targetWidth = target'->Dom.Element.clientWidth
        let targetLeft = switch target'->Dom.Element.asHtmlElement {
        | None => None
        | Some(target'') => Some(target''->Dom.HtmlElement.offsetLeft)
        }

        targetLeft
        ->Option.map(targetLeft' => {
          container'->Dom.Element.setScrollLeft(
            (targetLeft' - windowWidth / 2 + targetWidth / 2)->Int.toFloat,
          )
        })
        ->ignore
      }

    | _ => ()
    }

    None
  }, [siblings])

  <>
    <div className=%twc("w-full fixed top-0 left-0 z-10 bg-white")>
      <header className=%twc("w-full max-w-3xl mx-auto h-14 bg-white")>
        <div className=%twc("px-5 py-4 flex justify-between")>
          <button onClick={_ => router->Next.Router.back}>
            <img src="/assets/arrow-right.svg" className=%twc("w-6 h-6 rotate-180") />
          </button>
          <div>
            <span className=%twc("font-bold text-xl")> {parentName->React.string} </span>
          </div>
          <button onClick={_ => router->Next.Router.push("/buyer")}>
            <IconHome height="24" width="24" fill="#262626" />
          </button>
        </div>
      </header>
    </div>
    // Horizontal Scroll
    <div className={%twc("w-full fixed z-[5] bg-white left-0 ") ++ foldableStyle}>
      <section className={%twc("w-full max-w-3xl mx-auto bg-white border-b border-gray-50")}>
        <ol
          id="horizontal-scroll-container"
          className=%twc("overflow-x-scroll scrollbar-hide flex items-center px-2")>
          {switch siblings {
          | [] => React.null

          | _ =>
            siblings
            ->Array.map(({id, name: categoryName, matchingProduct}) => {
              switch matchingProduct {
              // 품종에 연결된 매칭상품이 없는 경우
              | None => React.null

              | Some({id: matchingProductId, status}) =>
                switch status {
                // 품종과 연결된 매칭 상품이 RETIRED 상태일 경우
                | #RETIRE => React.null

                | _ =>
                  let key = `display-category-${id}`
                  let isSelected = categoryId == id
                  let btnStyle = isSelected
                    ? %twc(
                        "mx-2 text-gray-800 border-b-[2px] border-gray-800 pt-2 pb-3 whitespace-nowrap font-bold"
                      )
                    : %twc(
                        "mx-2 text-gray-400 border-b-[2px] border-transparent pt-2 pb-3 whitespace-nowrap"
                      )
                  <li key id=key>
                    <Next.Link href={`/buyer/products/${matchingProductId}`}>
                      <a>
                        <div className=btnStyle> {categoryName->React.string} </div>
                      </a>
                    </Next.Link>
                  </li>
                }
              }
            })
            ->React.array
          }}
        </ol>
      </section>
    </div>
    // Placeholder
    <div className=%twc("w-full h-[102px]") />
  </>
}
