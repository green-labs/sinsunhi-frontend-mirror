open RadixUI

module Query = %relay(`
  query BuyerInterestedItemCategoryButtonAdminQuery($ids: [ID!]) {
    itemCategoriesListing(ids: $ids) {
      itemCategories {
        id
        name
      }
    }
  } 
`)

module Items = {
  module Capsule = {
    @react.component
    let make = (~label) => {
      <li className=%twc("bg-enabled-L5 px-4 py-2 rounded-full")> {label->React.string} </li>
    }
  }

  @react.component
  let make = (~ids) => {
    let queryData = Query.use(~variables={ids: ids}, ())

    <ul className=%twc("flex flex-wrap gap-2")>
      {switch queryData.itemCategoriesListing->Option.flatMap(listing => listing.itemCategories) {
      | Some(items) => items->Array.map(i => <Capsule key={i.id} label={i.name} />)->React.array
      | None => <li> {`선택 없음`->React.string} </li>
      }}
    </ul>
  }
}

@react.component
let make = (~itemIds) => {
  <Dialog.Root>
    <Dialog.Overlay className=%twc("dialog-overlay") />
    {switch itemIds {
    | Some(_) =>
      <Dialog.Trigger
        className=%twc(
          "text-base focus:outline-none bg-primary-light rounded-lg text-primary py-1 px-5"
        )>
        {j`조회하기`->React.string}
      </Dialog.Trigger>
    | None =>
      <div
        className=%twc(
          "text-base focus:outline-none bg-disabled-L3 text-disabled-L2 rounded-lg py-1 px-5 inline-block"
        )>
        {j`조회하기`->React.string}
      </div>
    }}
    <Dialog.Content className=%twc("dialog-content-detail overflow-y-auto rounded-2xl")>
      <section className=%twc("flex p-5")>
        <h3 className=%twc("text-lg font-bold")> {j`관심품목 조회`->React.string} </h3>
        <Dialog.Close className=%twc("focus:outline-none ml-auto")>
          <IconClose height="24" width="24" fill="#262626" />
        </Dialog.Close>
      </section>
      <section className=%twc("p-5 pt-0")>
        <React.Suspense fallback={<div> {`검색 중`->React.string} </div>}>
          <Items ids=itemIds />
        </React.Suspense>
      </section>
    </Dialog.Content>
  </Dialog.Root>
}
