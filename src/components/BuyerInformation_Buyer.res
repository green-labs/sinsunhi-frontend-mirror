open RadixUI

module Button = {
  @react.component
  let make = (~label, ~disabled, ~onClick=?) => {
    <button
      disabled className=%twc("bg-primary text-white font-bold h-13 rounded-xl w-full") ?onClick>
      {label->React.string}
    </button>
  }
}
module SectorAndSale = {
  type capsule = {id: int, label: string}
  module Capsule = {
    @react.component
    let make = (~label, ~selected, ~onClick) => {
      let className = if selected {
        %twc("px-4 py-2 rounded-[20px] bg-primary-light-variant text-primary")
      } else {
        %twc("px-4 py-2 rounded-[20px] bg-gray-50")
      }
      <button className onClick> {label->React.string} </button>
    }
  }
  module Sector = {
    module Query = %relay(`
      query BuyerInformationBuyerBusinessSectorListingQuery {
        selfReportedBusinessSectorListing {
          id
          label
          value
        }
      }
    `)

    @react.component
    let make = (~selected, ~onClick, ~hasSelected) => {
      let queryData = Query.use(~variables=(), ())
      let onClick = (item, _) => onClick(item)

      <>
        <section>
          <h3 className=%twc("font-bold")>
            {`업종`->React.string}
            <span className=%twc("ml-1 text-sm font-normal text-text-L2")>
              {`*최대 3개 선택가능`->React.string}
            </span>
          </h3>
        </section>
        <section className=%twc("flex flex-wrap gap-2 mt-5")>
          {switch queryData.selfReportedBusinessSectorListing {
          | Some(listing) =>
            listing
            ->Array.map(d =>
              <Capsule
                key=d.id
                label=d.label
                selected={hasSelected(selected, d.id)}
                onClick={onClick(d.id)}
              />
            )
            ->React.array
          | None => `업종 정보를 찾을 수 없습니다.`->React.string
          }}
        </section>
        <section className=%twc("mt-4 text-text-L3")>
          <div>
            {`* 슈퍼마켓 : 정육이나 수산은 취급하지 않아요.`->React.string}
          </div>
          <div> {`* 마트 : 정육이나 수산도 취급해요.`->React.string} </div>
        </section>
      </>
    }
  }
  module Sale = {
    module Query = %relay(`
      query BuyerInformationBuyerSalesBinQuery {
        selfReportedSalesBinListing {
          id
          label
          value
        }
      }
    `)

    @react.component
    let make = (~selected, ~onClick) => {
      let queryData = Query.use(~variables=(), ())
      let onClick = (item, _) => onClick(item)
      <>
        <section className=%twc("mt-12")>
          <h3 className=%twc("font-bold")> {`연매출`->React.string} </h3>
        </section>
        <section className=%twc("flex flex-wrap gap-2 mt-5")>
          {switch queryData.selfReportedSalesBinListing {
          | Some(listing) =>
            listing
            ->Array.map(d =>
              <Capsule
                key={d.id}
                label=d.label
                selected={selected == Some(d.id)}
                onClick={onClick(Some(d.id))}
              />
            )
            ->React.array
          | None => `연매출 정보를 찾을 수 없습니다.`->React.string
          }}
        </section>
      </>
    }
  }

  module Mutation = %relay(`
  mutation BuyerInformationBuyerSectorSalesMutation(
    $binId: ID!
    $businessSectors: [ID!]!
  ) {
    setSelfReportedSalesBin(input: { binId: $binId }) {
      ... on SetSelfReportedSalesBinResponse {
        bin {
          id
          value
          label
        }
      }
      ... on Error {
        code
        message
      }
    }
    setSelfReportedBusinessSectors(
      input: { businessSectorIds: $businessSectors }
    ) {
      ... on SetSelfReportedBusinessSectorsResponse {
        businessSectors {
          id
          label
          value
        }
      }
      ... on Error {
        code
        message
      }
    }
  }
  `)

  @react.component
  let make = (~selected, ~close) => {
    let {addToast} = ReactToastNotifications.useToasts()

    let selectedSet = switch selected {
    | Some(bs, _) =>
      bs->Option.mapWithDefault(Set.String.empty, bs => {
        bs
        ->Array.map((
          i: BuyerInformationBuyerQuery_graphql.Types.response_viewer_selfReportedBusinessSectors,
        ) => i.id)
        ->Set.String.fromArray
      })
    | None => Set.String.empty
    }
    let selectedBin = switch selected {
    | Some(_, sb) =>
      sb->Option.map((
        sb: BuyerInformationBuyerQuery_graphql.Types.response_viewer_selfReportedSalesBin,
      ) => sb.id)
    | _ => None
    }

    let (businessSectorSet, setBusinessSectorSet) = React.Uncurried.useState(_ => selectedSet)
    let (salesBin, setSalesBin) = React.Uncurried.useState(_ => selectedBin)

    let (mutate, isMutating) = Mutation.use()

    let handleClickBusiSect = item =>
      setBusinessSectorSet(.prev =>
        if prev->Set.String.has(item) {
          prev->Set.String.remove(item)
        } else if prev->Set.String.size < 3 {
          prev->Set.String.add(item)
        } else {
          addToast(.
            <div className=%twc("flex items-center")>
              <IconWarning height="24" width="24" className=%twc("mr-2") stroke="#FED925" />
              {`선택 가능한 최대 품목수를 넘었습니다. (최대3개)`->React.string}
            </div>,
            {appearance: "error"},
          )
          prev
        }
      )
    let handleClickSalesBin = item =>
      setSalesBin(.prev => {
        if prev == item {
          None
        } else {
          item
        }
      })

    let hasItem = (set, item) => set->Set.String.has(item)

    let save = () => {
      switch (salesBin, businessSectorSet->Set.String.size > 0) {
      | (Some(salesBin), true) =>
        mutate(
          ~variables={
            binId: salesBin,
            businessSectors: businessSectorSet->Set.String.toArray,
          },
          ~onCompleted={
            (_, _) => {
              addToast(.
                <div className=%twc("flex items-center")>
                  <IconCheck height="24" width="24" fill="#12B564" className=%twc("mr-2") />
                  {j`업종과 연매출 정보가 저장되었습니다.`->React.string}
                </div>,
                {appearance: "success"},
              )
              close()
            }
          },
          ~onError={
            _ =>
              addToast(.
                <div className=%twc("flex items-center")>
                  <IconError height="24" width="24" className=%twc("mr-2") />
                  {`에러가 발생하였습니다.`->React.string}
                </div>,
                {appearance: "error"},
              )
          },
          (),
        )->ignore
      | (None, true) =>
        addToast(.
          <div className=%twc("flex items-center")>
            <IconWarning height="24" width="24" className=%twc("mr-2") />
            {j`연매출을 선택해주세요.`->React.string}
          </div>,
          {appearance: "success"},
        )

      | (Some(_), false) =>
        addToast(.
          <div className=%twc("flex items-center")>
            <IconWarning height="24" width="24" className=%twc("mr-2") />
            {j`업종을 선택해주세요.`->React.string}
          </div>,
          {appearance: "success"},
        )
      | (None, false) =>
        addToast(.
          <div className=%twc("flex items-center")>
            <IconWarning height="24" width="24" className=%twc("mr-2") />
            {j`업종과 연매출을 선택해주세요.`->React.string}
          </div>,
          {appearance: "success"},
        )
      }
    }

    React.useEffect0(_ => {
      ChannelTalk.hideChannelButton()

      Some(_ => ChannelTalk.showChannelButton())
    })

    <>
      <section className=%twc("p-5 pt-0 text-text-L1")>
        <article>
          <h2 className=%twc("text-xl font-bold whitespace-pre-wrap")>
            {`프로필이 자세할 수록\n`->React.string}
            <span className=%twc("text-primary")> {`맞춤 소싱 정보`->React.string} </span>
            <span> {`를 알려드릴 수 있어요`->React.string} </span>
          </h2>
        </article>
      </section>
      <section className=%twc("p-5 text-text-L1")>
        <Sector selected=businessSectorSet onClick=handleClickBusiSect hasSelected=hasItem />
        <Sale selected=salesBin onClick=handleClickSalesBin />
      </section>
      <section className=%twc("p-5")>
        <Button disabled=isMutating onClick={_ => save()} label={`저장`} />
      </section>
    </>
  }
}

// 관심상품 입력
module InterestedCategories = {
  module Capsule = {
    @react.component
    let make = (
      ~item: BuyerInformationBuyerInterestedCategoryListingQuery_graphql.Types.response_interestedCategoryListing_depth0Categories_itemCategories,
      ~onClick,
    ) => {
      <button
        className=%twc("px-4 py-2 rounded-[20px] bg-gray-50 flex items-center whitespace-pre")
        onClick={_ => onClick(item.id)}>
        {item.name->React.string}
        <span className=%twc("ml-1")>
          <IconClose width="16" height="16" fill="#000000" />
        </span>
      </button>
    }
  }

  module Search = {
    @react.component
    let make = (~search, ~onChange, ~onClear) => {
      <>
        <section>
          <h3 className=%twc("font-bold")>
            {`관심 상품 찾기`->React.string}
            <span className=%twc("ml-1 text-sm font-normal text-text-L2")>
              {`*최대 20품목 선택가능`->React.string}
            </span>
          </h3>
        </section>
        <section className=%twc("flex flex-wrap gap-2 mt-5 relative")>
          <Input
            type_="text"
            name="search-category"
            value=search
            error=None
            onChange
            size={Input.Large}
            placeholder={`상품을 검색해보세요.`}
            className=%twc("pl-11")
          />
          <IconSearch
            width="28"
            height="28"
            stroke="#262626"
            className=%twc("absolute left-3 top-1/2 transform -translate-y-1/2")
          />
          {if search->Js.String2.length > 0 {
            <span
              onClick={_ => onClear()}
              className=%twc(
                "absolute p-2 right-1 top-1/2 transform -translate-y-1/2 cursor-pointer"
              )>
              <IconCloseInput width="24" height="24" fill="#DDDDDD" />
            </span>
          } else {
            React.null
          }}
        </section>
      </>
    }
  }

  module Selected = {
    @react.component
    let make = (
      ~data: option<
        array<
          BuyerInformationBuyerInterestedCategoryListingQuery_graphql.Types.response_interestedCategoryListing_depth0Categories_itemCategories,
        >,
      >,
      ~selected,
      ~onClick,
    ) => {
      let matchedItem = id => data->Option.flatMap(d => d->Array.getBy(d => d.id == id))
      let hasSelected = !(selected->Garter.Array.isEmpty)

      <section
        className={hasSelected
          ? %twc("my-4 flex gap-2 overflow-x-auto scrollbar-hide")
          : %twc("flex gap-2 overflow-x-auto scrollbar-hide")}>
        {selected
        ->Array.reverse
        ->Array.map(id => {
          let item = matchedItem(id)
          switch item {
          | Some(item) => <Capsule key={item.id} item onClick />
          | None => React.null
          }
        })
        ->React.array}
      </section>
    }
  }

  module ListItems = {
    @react.component
    let make = (
      ~items: option<
        array<
          BuyerInformationBuyerInterestedCategoryListingQuery_graphql.Types.response_interestedCategoryListing_depth0Categories_itemCategories,
        >,
      >,
      ~selected,
      ~onClickItem,
      ~hasItem,
    ) => {
      switch items {
      | Some(items) => {
          let hasSelected = !(selected->Garter.Array.isEmpty)

          <ul
            className={hasSelected
              ? %twc(
                  "my-4 overflow-scroll scrollbar-hide h-[calc(90vh-476px)] h-lg:h-[calc(900px-482px)]"
                )
              : %twc(
                  "my-4 overflow-scroll scrollbar-hide h-[calc(90vh-416px)] h-lg:h-[calc(900px-422px)]"
                )}
            ariaMultiselectable=true
            style={
              let style = Js.Dict.empty()
              style->Js.Dict.set("content-visibility", "auto")
              style->ReactDOMStyle._dictToStyle
            }>
            {items
            ->Array.map(({id, name}) => {
              <li
                ariaSelected={hasItem(selected, id)}
                key={id}
                className=%twc("flex items-center min-h-[48px] cursor-pointer tab-highlight-color")
                onClick={_ => onClickItem(id)}>
                <div className=%twc("flex flex-col justify-between truncate")>
                  <span className=%twc("block text-base truncate text-text-L1")>
                    {j`$name`->React.string}
                  </span>
                </div>
                <div className=%twc("ml-auto pl-2")>
                  {hasItem(selected, id)
                    ? <DS_Icon.Common.CheckedLarge1 height="24" width="24" fill="#12B564" />
                    : <DS_Icon.Common.UncheckedLarge1 height="24" width="24" fill="#12B564" />}
                </div>
              </li>
            })
            ->React.array}
          </ul>
        }

      | None => `검색 결과가 없습니다.`->React.string
      }
    }
  }

  module SearchResults = {
    module Query = %relay(`
      query BuyerInformationBuyerInterestedItemCategoryQuery($q: String) {
        searchInterestedItemCategoryListing(q: $q) {
          itemCategories {
            id
            name
          }
        }
      }
  `)

    @react.component
    let make = (~search, ~selected, ~isMutating, ~save, ~onClickItem, ~hasItem) => {
      let (debouncedSearch, _) = CustomHooks.useDebounce(search, 500)

      let queryData = Query.use(~variables={q: Some(debouncedSearch)}, ())

      let hasSelected = !(selected->Garter.Array.isEmpty)

      <>
        <ul
          className={hasSelected
            ? %twc(
                "my-4 overflow-scroll scrollbar-hide h-[calc(90vh-398px)] h-lg:h-[calc(900px-398px)]"
              )
            : %twc(
                "my-4 overflow-scroll scrollbar-hide h-[calc(90vh-358px)] h-lg:h-[calc(900px-358px)]"
              )}
          ariaMultiselectable=true
          style={
            let style = Js.Dict.empty()
            style->Js.Dict.set("content-visibility", "auto")
            style->ReactDOMStyle._dictToStyle
          }>
          {switch queryData.searchInterestedItemCategoryListing->Option.flatMap(listing =>
            listing.itemCategories
          ) {
          | Some(itemCategories) =>
            itemCategories
            ->Array.map(({id, name}) => {
              <li
                ariaSelected={hasItem(selected, id)}
                key={id}
                className=%twc("flex items-center min-h-[48px] cursor-pointer tab-highlight-color")
                onClick={_ => onClickItem(id)}>
                <div className=%twc("flex flex-col justify-between truncate")>
                  <span className=%twc("block text-base truncate text-text-L1")>
                    {j`$name`->React.string}
                  </span>
                </div>
                <div className=%twc("ml-auto pl-2")>
                  {hasItem(selected, id)
                    ? <DS_Icon.Common.CheckedLarge1 height="24" width="24" fill="#12B564" />
                    : <DS_Icon.Common.UncheckedLarge1 height="24" width="24" fill="#12B564" />}
                </div>
              </li>
            })
            ->React.array
          | None => `검색 결과가 없습니다.`->React.string
          }}
        </ul>
        <DS_ButtonContainer.Floating1 disabled=isMutating label={`저장`} onClick={_ => save()} />
      </>
    }
  }

  module List = {
    type tab = {id: string, name: string}
    @react.component
    let make = (
      ~data: BuyerInformationBuyerInterestedCategoryListingQuery_graphql.Types.response,
      ~isMutating,
      ~save,
      ~selected,
      ~onClickItem,
      ~hasItem,
    ) => {
      let initialSelectedDepth0Category =
        data.interestedCategoryListing
        ->Option.flatMap(listing => listing.depth0Categories->Garter.Array.first)
        ->Option.map(depth0Categories => depth0Categories.id)

      let (selectedDepth0Category, setSelectedDepth0Category) = React.Uncurried.useState(_ =>
        initialSelectedDepth0Category
      )

      let itemCategories = switch selectedDepth0Category {
      | Some(selectedDepth0) =>
        data.interestedCategoryListing->Option.flatMap(listing =>
          listing.depth0Categories
          ->Array.keep(depth0Item => depth0Item.id == selectedDepth0)
          ->Garter.Array.first
          ->Option.map(depth0Item => depth0Item.itemCategories)
        )
      | None =>
        data.interestedCategoryListing->Option.flatMap(listing =>
          listing.depth0Categories
          ->Garter.Array.first
          ->Option.map(depth0Item => depth0Item.itemCategories)
        )
      }

      let countOfSelected = selectedDepth0Category =>
        data.interestedCategoryListing
        ->Option.flatMap(listing =>
          listing.depth0Categories->Array.getBy(depth0Item =>
            depth0Item.id == selectedDepth0Category
          )
        )
        ->Option.map(depth0Categories =>
          depth0Categories.itemCategories->Array.keep(itemCategory =>
            selected->Garter.Array.some(i => i == itemCategory.id)
          )
        )
        ->Option.map(Array.length)
        ->Option.map(Int.toString)

      <>
        <section className=%twc("mt-4")>
          <DS_Tab.LeftTab.Root>
            {switch data.interestedCategoryListing {
            | Some(list) =>
              list.depth0Categories
              ->Array.map(({id, name}) => {
                <DS_Tab.LeftTab.Item key={id} className=%twc("mx-2 first:ml-0 last:mr-0")>
                  <DS_Button.Tab.LeftTab1
                    onClick={_ => setSelectedDepth0Category(._ => Some(id))}
                    text=name
                    selected={Some(id) == selectedDepth0Category}
                    labelNumber={countOfSelected(id)}
                  />
                </DS_Tab.LeftTab.Item>
              })
              ->React.array
            | None => React.null
            }}
          </DS_Tab.LeftTab.Root>
        </section>
        <React.Suspense>
          <ListItems
            key={selectedDepth0Category->Option.getWithDefault("")}
            items=itemCategories
            selected
            onClickItem
            hasItem
          />
        </React.Suspense>
        <div className=%twc("h-[56px]") />
        <DS_ButtonContainer.Floating1 disabled=isMutating label={`저장`} onClick={_ => save()} />
      </>
    }
  }

  module Mutation = %relay(`
    mutation BuyerInformationBuyerInterestedCategoryMutation(
      $itemCategoryIds: [ID!]!
    ) {
      setInterestedItemCategories(input: { itemCategoryIds: $itemCategoryIds }) {
        ... on SetInterestedItemCategoriesResponse {
          itemCategoryIds
        }
        ... on Error {
          code
          message
        }
      }
    }
  `)

  module SearchAndList = {
    @react.component
    let make = (
      ~data: BuyerInformationBuyerInterestedCategoryListingQuery_graphql.Types.response,
      ~selected: option<
        array<BuyerInformationBuyerQuery_graphql.Types.response_viewer_interestedItemCategories>,
      >,
      ~changeModeToSectorSale,
    ) => {
      let {addToast} = ReactToastNotifications.useToasts()

      let selected = switch selected {
      | Some(selected) => selected->Array.map(s => s.id)
      | None => []
      }
      let (selected, setSelected) = React.Uncurried.useState(_ => selected)

      let (mutate, isMutating) = Mutation.use()

      let save = () => {
        if selected->Garter.Array.length > 0 {
          mutate(
            ~variables={
              itemCategoryIds: selected,
            },
            ~onCompleted={
              (_, _) => {
                addToast(.
                  <div className=%twc("flex items-center")>
                    <IconCheck height="24" width="24" fill="#12B564" className=%twc("mr-2") />
                    {j`관심 상품이 저장되었습니다.`->React.string}
                  </div>,
                  {appearance: "success"},
                )
                changeModeToSectorSale()
              }
            },
            ~onError={
              _ =>
                addToast(.
                  <div className=%twc("flex items-center")>
                    <IconError height="24" width="24" className=%twc("mr-2") />
                    {`에러가 발생하였습니다.`->React.string}
                  </div>,
                  {appearance: "error"},
                )
            },
            (),
          )->ignore
        } else {
          addToast(.
            <div className=%twc("flex items-center")>
              <IconWarning height="24" width="24" className=%twc("mr-2") />
              {`관심 상품을 선택해주세요.`->React.string}
            </div>,
            {appearance: "error"},
          )
        }
      }

      let itemCategories =
        data.interestedCategoryListing
        ->Option.map(listing =>
          listing.depth0Categories->Array.map(depth0Item => depth0Item.itemCategories)
        )
        ->Option.map(Array.concatMany)

      let handleClickItemCategory = item =>
        setSelected(.prev =>
          if prev->Garter.Array.some(p => p == item) {
            prev->Garter.Array.keep(p => p != item)
          } else if prev->Garter.Array.length < 20 {
            prev->Garter.Array.concat([item])
          } else {
            addToast(.
              <div className=%twc("flex items-center whitespace-pre-line sm:whitespace-normal")>
                <IconWarning height="24" width="24" className=%twc("mr-2") stroke="#FED925" />
                {`선택 가능한 최대 품목수를 넘었습니다. \n(최대20개)`->React.string}
              </div>,
              {appearance: "error"},
            )
            prev
          }
        )

      let hasItem = (set, item) => set->Garter.Array.some(i => i == item)

      let (search, setSearch) = React.Uncurried.useState(_ => "")

      let handleOnChange = event => {
        let value: string = (event->ReactEvent.Synthetic.target)["value"]
        setSearch(._ => value)
      }

      let handleOnClear = () => setSearch(._ => "")

      <>
        <Search search onChange=handleOnChange onClear=handleOnClear />
        <Selected data=itemCategories selected onClick=handleClickItemCategory />
        {if search->Js.String2.length > 0 {
          <React.Suspense fallback={<div className=%twc("h-[500px]") />}>
            <SearchResults
              key={search}
              search
              selected
              isMutating
              save
              onClickItem=handleClickItemCategory
              hasItem
            />
          </React.Suspense>
        } else {
          <List selected data isMutating save onClickItem=handleClickItemCategory hasItem />
        }}
      </>
    }
  }

  module Query = %relay(`
  query BuyerInformationBuyerInterestedCategoryListingQuery {
    interestedCategoryListing {
      depth0Categories {
        id
        name
        itemCategories {
          id
          name
        }
      }
    }
  }
  `)

  @react.component
  let make = (~selected, ~changeModeToSectorSale) => {
    let queryData = Query.use(~variables=(), ())

    React.useEffect0(_ => {
      ChannelTalk.hideChannelButton()

      Some(_ => ChannelTalk.showChannelButton())
    })

    <>
      <section className=%twc("p-5 pt-0 text-text-L1")>
        <article>
          <h2 className=%twc("text-xl font-bold whitespace-pre-wrap")>
            {`관심 상품을 입력하고\n`->React.string}
            <span className=%twc("text-primary")>
              {`더 유리한 소싱 조건`->React.string}
            </span>
            <span> {`을 받아보세요!`->React.string} </span>
          </h2>
        </article>
      </section>
      <section className=%twc("p-5 text-text-L1")>
        <SearchAndList data=queryData selected changeModeToSectorSale />
      </section>
    </>
  }
}

type isOpen = Show | Hide
type mode = SectorAndSale | InterestedCategories

// 유저의 입력 정보 쿼리
module Query = %relay(`
  query BuyerInformationBuyerQuery {
    viewer {
      selfReportedSalesBin {
        id
        label
        value
      }
      selfReportedBusinessSectors {
        id
        label
        value
      }
      interestedItemCategories {
        id
        name
      }
    }
  }
`)

module Fetcher = {
  @spice
  type lastShownDate = {
    userId: int,
    date: string,
  }

  let parse = str =>
    try {
      switch str->Js.Json.parseExn->lastShownDate_decode {
      | Ok(lastShownDate) => Some(lastShownDate)
      | Error(_) => None
      }
    } catch {
    | _ => None
    }

  let makeLastShown = id =>
    {
      userId: id,
      date: Js.Date.make()->DateFns.formatISO,
    }
    ->lastShownDate_encode
    ->Js.Json.stringify

  @react.component
  let make = () => {
    let (isOpen, setOpen) = React.Uncurried.useState(_ => Hide)
    let (mode, setMode) = React.Uncurried.useState(_ => InterestedCategories)

    let queryData = Query.use(~variables=(), ())

    let user = CustomHooks.Auth.use()
    React.useEffect2(_ => {
      // 1. 과거 입력한 정보를 확인하여 팝업을 선택적으로 띄운다.
      // 2. 하루에 한 번만 띄운다.
      switch user {
      | LoggedIn({id, role: Buyer}) => {
          let lastShownDate = LocalStorageHooks.BuyerInfoLastShown.get()
          let userId = lastShownDate->parse->Option.map(lastShown => lastShown.userId)
          let date = lastShownDate->parse->Option.map(lastShown => lastShown.date)

          if (
            lastShownDate == "" ||
            userId != Some(id) ||
            date->Option.mapWithDefault(true, d => d->DateFns.parseISO->DateFns.isYesterday)
          ) {
            let isSalesBinInput =
              queryData.viewer->Option.flatMap(viewer => viewer.selfReportedSalesBin)
            let isBusiniessSectorsInput =
              queryData.viewer->Option.flatMap(viewer =>
                viewer.selfReportedBusinessSectors->Option.map(arr => !Garter.Array.isEmpty(arr))
              )
            let isInterestedItemCategoriesInput =
              queryData.viewer->Option.flatMap(viewer =>
                viewer.interestedItemCategories->Option.map(arr => !Garter.Array.isEmpty(arr))
              )
            switch (isSalesBinInput, isBusiniessSectorsInput, isInterestedItemCategoriesInput) {
            | (Some(_), Some(true), Some(true)) => ()
            | (Some(_) | None, Some(false) | None, Some(true)) => {
                setOpen(._ => Show)
                setMode(._ => SectorAndSale)
                LocalStorageHooks.BuyerInfoLastShown.set(makeLastShown(id))
              }

            | _ => {
                setOpen(._ => Show)
                setMode(._ => InterestedCategories)
                LocalStorageHooks.BuyerInfoLastShown.set(makeLastShown(id))
              }
            }
          } else {
            ()
          }
        }

      | _ => ()
      }
      None
    }, (queryData, user))

    let changeModeToSectorSale = () => setMode(._ => SectorAndSale)
    let close = () => setOpen(._ => Hide)

    let hasInputBusinessSectorsAndSalesBin = queryData.viewer->Option.mapWithDefault(false, v => {
      let bs = v.selfReportedBusinessSectors->Option.map(arr => !(arr->Garter.Array.isEmpty))
      let sb = v.selfReportedSalesBin
      switch (bs, sb) {
      | (Some(true), Some(_)) => true
      | _ => false
      }
    })

    let contentStyle = switch mode {
    | SectorAndSale => %twc("dialog-content-detail overflow-y-auto rounded-2xl")
    | InterestedCategories => %twc("dialog-content-full overflow-y-auto sm:rounded-2xl")
    }

    <Dialog.Root
      _open={switch isOpen {
      | Show => true
      | Hide => false
      }}>
      <Dialog.Overlay className=%twc("dialog-overlay") />
      <Dialog.Content className=contentStyle>
        <section className=%twc("text-text-L1")>
          <article className=%twc("flex")>
            <Dialog.Close
              className=%twc("p-2 m-3 mb-0 focus:outline-none ml-auto")
              onClick={_ => {
                if mode == InterestedCategories && !hasInputBusinessSectorsAndSalesBin {
                  setMode(._ => SectorAndSale)
                } else {
                  setOpen(._ => Hide)
                }
              }}>
              <IconClose height="24" width="24" fill="#262626" />
            </Dialog.Close>
          </article>
        </section>
        {switch mode {
        | SectorAndSale =>
          <SectorAndSale
            selected={queryData.viewer->Option.map(v => (
              v.selfReportedBusinessSectors,
              v.selfReportedSalesBin,
            ))}
            close
          />
        | InterestedCategories =>
          <InterestedCategories
            selected={queryData.viewer->Option.flatMap(v => v.interestedItemCategories)}
            changeModeToSectorSale
          />
        }}
      </Dialog.Content>
    </Dialog.Root>
  }
}

@react.component
let make = () => {
  let user = CustomHooks.Auth.use()

  switch user {
  | LoggedIn({role: Buyer}) =>
    <React.Suspense fallback={<div> {`!!!`->React.string} </div>}>
      <Fetcher />
    </React.Suspense>
  | _ => React.null
  }
}
