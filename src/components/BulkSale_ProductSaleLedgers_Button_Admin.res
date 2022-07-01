/*
 * 1. 컴포넌트 위치
 *   어드민 센터 - 전량 구매 - 생산자 소싱 관리 - (리스트) 원표정보 입력 버튼
 *
 * 2. 역할
 *   어드민이 농민의 판매원표 정보를 입력/수정합니다. 신청 시 입력 받은 판매원표 정보와는 별개의 정보 입니다.
 * */
open RadixUI
module FormEntry = BulkSale_ProductSaleLedgers_Button_FormEntry_Admin
module FormUpdate = BulkSale_ProductSaleLedgers_Button_Update_Admin
module FormCreate = BulkSale_ProductSaleLedgers_Button_Create_Admin

module Fragment = %relay(`
  fragment BulkSaleProductSaleLedgersButtonAdminFragment on BulkSaleApplication
  @refetchable(queryName: "BulkSaleProductSaleLedgersButtonAdminRefetchQuery")
  @argumentDefinitions(
    first: { type: "Int", defaultValue: 100 }
    after: { type: "ID", defaultValue: null }
  ) {
    bulkSaleProductSaleLedgers(first: $first, after: $after)
      @connection(
        key: "BulkSaleProductSaleLedgersButtonAdmin_bulkSaleProductSaleLedgers"
      ) {
      __id
      edges {
        cursor
        node {
          id
          path
          date
          wholesaler {
            id
            code
            name
            wholesalerMarket {
              id
              code
              name
            }
          }
          bulkSaleProductSaleLedgerEntries {
            edges {
              cursor
              node {
                id
                grade
                quantity {
                  amount
                  unit
                  display
                }
                volume
                price
              }
            }
            pageInfo {
              startCursor
              endCursor
              hasNextPage
              hasPreviousPage
            }
          }
        }
      }
      pageInfo {
        startCursor
        endCursor
        hasNextPage
        hasPreviousPage
      }
    }
  }
`)

module MutationDelete = %relay(`
  mutation BulkSaleProductSaleLedgersButtonAdminDeleteMutation($id: ID!) {
    deleteBulkSaleProductSaleLedger(id: $id) {
      result {
        id
      }
    }
  }
`)

module LedgerCapsule = {
  @react.component
  let make = (
    ~idx,
    ~selectedLedgerId,
    ~setSelectedLedgerId,
    ~ledger: BulkSaleProductSaleLedgersButtonAdminFragment_graphql.Types.fragment_bulkSaleProductSaleLedgers_edges,
    ~refetchLedgers,
  ) => {
    let {addToast} = ReactToastNotifications.useToasts()

    let (mutate, isMutating) = MutationDelete.use()

    let isSelected = selectedLedgerId->Option.mapWithDefault(false, id => id == ledger.node.id)
    let style = isSelected
      ? %twc(
          "flex justify-center items-center text-primary border border-primary bg-primary-light p-2 hover:bg-primary-light-variant rounded-lg cursor-pointer"
        )
      : %twc(
          "flex justify-center items-center text-text-L2 border border-gray-200 p-2 hover:bg-surface rounded-lg cursor-pointer"
        )

    let delete = () => {
      if !isMutating {
        switch selectedLedgerId {
        | Some(id) =>
          mutate(
            ~variables={id: id},
            ~onCompleted={
              (_, _) => {
                addToast(.
                  <div className=%twc("flex items-center")>
                    <IconCheck height="24" width="24" fill="#12B564" className=%twc("mr-2") />
                    {j`삭제 요청에 성공하였습니다.`->React.string}
                  </div>,
                  {appearance: "success"},
                )
                refetchLedgers()
              }
            },
            ~onError={
              err => {
                Js.Console.log(err)
                addToast(.
                  <div className=%twc("flex items-center")>
                    <IconError height="24" width="24" className=%twc("mr-2") />
                    {err.message->React.string}
                  </div>,
                  {appearance: "error"},
                )
              }
            },
            (),
          )->ignore
        | None => ()
        }
      }
    }

    <span className=style onClick={_ => setSelectedLedgerId(._ => Some(ledger.node.id))}>
      <span> {`판매원표${(idx + 1)->Int.toString}`->React.string} </span>
      <span className=%twc("ml-1") onClick={_ => delete()}>
        <IconClose width="20" height="20" fill={isSelected ? "#12b564" : "#b2b2b2"} />
      </span>
    </span>
  }
}

module LedgerAddButton = {
  @react.component
  let make = (~selectedLedgerId, ~addLedger) => {
    let isSelected = selectedLedgerId->Option.isNone
    let style = isSelected
      ? %twc(
          "flex justify-center items-center text-primary border border-primary bg-primary-light p-2 hover:bg-primary-light-variant rounded-lg cursor-pointer"
        )
      : %twc(
          "flex justify-center items-center text-text-L2 border border-gray-200 rounded-lg p-2 hover:bg-gray-150"
        )

    <button className=style onClick={_ => addLedger()}>
      <IconPlus
        width="16" height="16" fill={isSelected ? "#12b564" : "#b2b2b2"} className=%twc("mr-1")
      />
      {`추가`->React.string}
    </button>
  }
}

module Content = {
  @react.component
  let make = (~farmmorningUserId, ~applicationId, ~query) => {
    let (queryData, refetch) = Fragment.useRefetchable(query)

    let (selectedLedgerId, setSelectedLedgerId) = React.Uncurried.useState(_ =>
      queryData.bulkSaleProductSaleLedgers.edges
      ->Garter.Array.first
      ->Option.map(edge => edge.node.id)
    )

    let addLedger = () => {
      setSelectedLedgerId(._ => None)
    }

    let refetchLedgers = () => {
      refetch(
        ~variables=Fragment.makeRefetchVariables(),
        ~fetchPolicy=RescriptRelay.StoreAndNetwork,
        (),
      )->ignore
    }

    <section className=%twc("p-5 text-text-L1")>
      <article className=%twc("flex")>
        <h2 className=%twc("text-xl font-bold")> {j`판매 원표`->React.string} </h2>
        <Dialog.Close className=%twc("inline-block p-1 focus:outline-none ml-auto")>
          <IconClose height="24" width="24" fill="#262626" />
        </Dialog.Close>
      </article>
      <article className=%twc("bg-red-50 text-emphasis p-4 rounded-lg mt-7 mb-5")>
        {`선택된 한 개의 원표만 저장 /수정 가능합니다. (빈칸 제출 가능)`->React.string}
      </article>
      <article className=%twc("flex gap-2 mb-5")>
        {queryData.bulkSaleProductSaleLedgers.edges
        ->Array.mapWithIndex((idx, ledger) =>
          <LedgerCapsule idx ledger selectedLedgerId setSelectedLedgerId refetchLedgers />
        )
        ->React.array}
        <LedgerAddButton selectedLedgerId addLedger />
      </article>
      {switch selectedLedgerId {
      | Some(ledgerId) =>
        switch queryData.bulkSaleProductSaleLedgers.edges
        ->Array.map(edge => edge.node)
        ->Array.keep(node => node.id == ledgerId)
        ->Garter.Array.first {
        | Some(ledger) => <FormUpdate key=ledgerId ledger farmmorningUserId />
        | None =>
          <FormCreate
            key={selectedLedgerId->Option.getWithDefault(
              Js.Date.make()->DateFns.getTime->Float.toString,
            )}
            farmmorningUserId
            applicationId
            connectionId={queryData.bulkSaleProductSaleLedgers.__id}
          />
        }
      | None =>
        <FormCreate
          key={selectedLedgerId->Option.getWithDefault(
            Js.Date.make()->DateFns.getTime->Float.toString,
          )}
          farmmorningUserId
          applicationId
          connectionId={queryData.bulkSaleProductSaleLedgers.__id}
        />
      }}
    </section>
  }
}

@react.component
let make = (~farmmorningUserId, ~applicationId, ~query) => {
  <Dialog.Root>
    <Dialog.Overlay className=%twc("dialog-overlay") />
    <Dialog.Trigger className=%twc("text-left")>
      <span className=%twc("inline-block bg-primary-light text-primary py-1 px-2 rounded-lg mt-2")>
        {j`원표정보 입력`->React.string}
      </span>
    </Dialog.Trigger>
    <Dialog.Content className=%twc("dialog-content-detail overflow-y-auto")>
      // TODO: 스켈레톤 추가
      <React.Suspense fallback={<> </>}>
        <Content farmmorningUserId applicationId query />
      </React.Suspense>
    </Dialog.Content>
  </Dialog.Root>
}
