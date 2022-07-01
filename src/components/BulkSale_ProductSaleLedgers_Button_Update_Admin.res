/*
 * 1. 컴포넌트 위치
 *   어드민 센터 - 전량 구매 - 생산자 소싱 관리 - (리스트) 원표정보 입력 버튼 - 판매원표 수정 폼
 *
 * 2. 역할
 *   어드민이 농민의 판매원표 정보를 입력/수정합니다. 신청 시 입력 받은 판매원표 정보와는 별개의 정보 입니다.
 * */
open RadixUI
module FormEntry = BulkSale_ProductSaleLedgers_Button_FormEntry_Admin

module MutationUpdate = %relay(`
  mutation BulkSaleProductSaleLedgersButtonUpdateAdminMutation(
    $id: ID!
    $input: BulkSaleProductSaleLedgerUpdateInput!
  ) {
    updateBulkSaleProductSaleLedger(id: $id, input: $input) {
      result {
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
  }
`)

module LedgerFile = {
  @react.component
  let make = (~path) => {
    let status = CustomHooks.BulkSaleLedger.use(path)

    let (downloadUrl, displayText) = switch status {
    | Loading => (None, `로딩 중`)
    | Error(_) => (None, `에러 발생`)
    | Loaded(resource) =>
      switch resource->CustomHooks.BulkSaleLedger.response_decode {
      | Ok(resource') => (
          Some(resource'.url),
          resource'.path
          ->Js.String2.split("/")
          ->Garter.Array.last
          ->Option.getWithDefault(`알 수 없는 파일명`),
        )
      | Error(_) => (None, `에러 발생`)
      }
    }

    <span
      className=%twc(
        "w-full inline-flex justify-center items-center border border-border-default-L1 rounded-lg p-2 mt-2 text-sm text-text-L1 bg-white"
      )>
      <a href={downloadUrl->Option.getWithDefault("#")} download="" className=%twc("mr-1")>
        <IconDownloadCenter width="20" height="20" fill="#262626" />
      </a>
      <span className=%twc("truncate")> {displayText->React.string} </span>
    </span>
  }
}

external unsafeAsHtmlInputElement: Dom.element => Dom.htmlInputElement = "%identity"

let makeInputUpdate = (
  path,
  date,
  wholesalerId,
  ledgers,
): BulkSaleProductSaleLedgersButtonUpdateAdminMutation_graphql.Types.bulkSaleProductSaleLedgerUpdateInput => {
  wholesalerId: wholesalerId,
  path: path,
  date: date,
  bulkSaleProductSaleLedgerEntries: ledgers,
}
let makeEntryInputUpdate = (
  grade,
  price,
  amount,
  unit,
  volume,
): BulkSaleProductSaleLedgersButtonUpdateAdminMutation_graphql.Types.bulkSaleProductSaleLedgerEntryCreateInput => {
  grade: grade,
  price: price,
  quantity: {
    amount: amount,
    unit: unit,
  },
  volume: volume,
}
// FIXME: [> #KG | #G | #MG] vs. [#KG | #G | #MG]
let convertPackageUnit = (
  s: BulkSaleProductSaleLedgersButtonAdminFragment_graphql.Types.enum_ProductPackageMassUnit,
): [#G | #KG | #MG] =>
  switch s {
  | #KG => #KG
  | #G => #G
  | #MG => #MG
  | _ => #KG
  }

@react.component
let make = (
  ~farmmorningUserId,
  ~ledger: BulkSaleProductSaleLedgersButtonAdminFragment_graphql.Types.fragment_bulkSaleProductSaleLedgers_edges_node,
) => {
  let {addToast} = ReactToastNotifications.useToasts()
  let (mutate, isMutating) = MutationUpdate.use()

  let (files, setFiles) = React.Uncurried.useState(_ => None)
  let file = files->Option.flatMap(Garter.Array.first)
  // 판매원표 url
  let (path, setPath) = React.Uncurried.useState(_ => ledger.path)
  // 판매일자
  let (date, setDate) = React.Uncurried.useState(_ => ledger.date)
  // 출하시장 id
  let (wholesalerMarketId, setWholesalerMarketId) = React.Uncurried.useState(_ =>
    ledger.wholesaler->Option.map(w => w.wholesalerMarket.id)
  )
  // 법인명 id
  let (wholesalerId, setWholesalerId) = React.Uncurried.useState(_ =>
    ledger.wholesaler->Option.map(w => w.id)
  )
  // 저장된 Entries (등급, 중량, 거래량, 경락단가)
  let (entries, setEntries) = React.Uncurried.useState(_ =>
    ledger.bulkSaleProductSaleLedgerEntries.edges
    ->Array.map(edge => (
      edge.node.id,
      (
        {
          id: edge.node.id,
          grade: edge.node.grade,
          price: edge.node.price->Int.toString,
          quantity: {
            amount: edge.node.quantity.amount->Float.toString,
            unit: edge.node.quantity.unit->convertPackageUnit,
          },
          volume: edge.node.volume->Int.toString,
        }: FormEntry.entry
      ),
    ))
    ->Map.String.fromArray
  )
  // 추가된 Entries (등급, 중량, 거래량, 경락단가)
  let (newEntries, setNewEntries) = React.Uncurried.useState(_ =>
    Map.String.empty->Map.String.set(
      Js.Date.make()->DateFns.getTime->Float.toString,
      (
        {
          id: Js.Date.make()->DateFns.getTime->Float.toString,
          grade: "",
          price: "",
          quantity: {
            amount: "",
            unit: #KG,
          },
          volume: "",
        }: FormEntry.entry
      ),
    )
  )

  let (formErrors, setFormErrors) = React.Uncurried.useState(_ => [])

  // FIXME
  let (_isShowFileRequired, setShowFileRequired) = React.Uncurried.useState(_ => false)

  let handleOnChangeFiles = e => {
    let values = (e->ReactEvent.Synthetic.target)["files"]
    setFiles(._ => Some(values))
  }

  let handleResetFile = () => {
    open Webapi
    let inputFile = Dom.document->Dom.Document.getElementById("input-file")
    inputFile
    ->Option.map(inputFile' => {
      inputFile'->unsafeAsHtmlInputElement->Dom.HtmlInputElement.setValue("")
    })
    ->ignore
    setFiles(._ => None)
  }

  let onSuccess = presignedUrl => setPath(._ => presignedUrl)
  let onFailure = () => ()

  let onSuccessWithReset = (resetFn, successFn, presignedUrl) => {
    resetFn()
    successFn(presignedUrl)
  }

  let onFailureWithClose = (failureFn, _) => {
    failureFn()
  }

  let handleUpload = () => {
    switch file {
    | Some(file') =>
      UploadFileToS3PresignedUrl.uploadBulkSale(
        ~file=file',
        ~farmmorningUserId,
        ~onSuccess=onSuccessWithReset(handleResetFile, onSuccess),
        ~onFailure=onFailureWithClose(onFailure),
        (),
      )->ignore
    | None => setShowFileRequired(._ => true)
    }
  }

  let handleOnChangeDate = e => {
    let newDate = (e->ReactEvent.Synthetic.target)["value"]
    setDate(._ => newDate)
  }

  let handleOnChange = (setFn, e) => {
    let value = (e->ReactEvent.Synthetic.target)["value"]
    setFn(._ => value)
  }

  let addNewEntry = () => {
    let entries = newEntries->Map.String.set(
      Js.Date.make()->DateFns.getTime->Float.toString,
      {
        id: Js.Date.make()->DateFns.getTime->Float.toString,
        grade: "",
        price: "",
        quantity: {
          amount: "",
          unit: #KG,
        },
        volume: "",
      },
    )
    setNewEntries(._ => entries)
  }

  let handleOnSave = _ => {
    let inputEntries =
      entries
      ->Map.String.valuesToArray
      ->Array.keepMap(entry => {
        let input =
          makeEntryInputUpdate
          ->V.map(V.nonEmpty(#ErrorGrade(`등급을 입력해주세요`), entry.grade))
          ->V.ap(V.int(#ErrorPrice(`경락단가를 입력해주세요`), entry.price))
          ->V.ap(V.float(#ErrorAmount(`중량을 입력해주세요`), entry.quantity.amount))
          ->V.ap(V.pure(entry.quantity.unit))
          ->V.ap(V.int(#ErrorVolume(`거래량을 입력해주세요`), entry.volume))
        switch input {
        | Ok(input') => Some(input')
        | Error(_) => None
        }
      })
    let inputNewEntries =
      newEntries
      ->Map.String.valuesToArray
      ->Array.keepMap(entry => {
        let input =
          makeEntryInputUpdate
          ->V.map(V.nonEmpty(#ErrorGrade(`등급을 입력해주세요`), entry.grade))
          ->V.ap(V.int(#ErrorPrice(`경락단가를 입력해주세요`), entry.price))
          ->V.ap(V.float(#ErrorAmount(`중량을 입력해주세요`), entry.quantity.amount))
          ->V.ap(V.pure(entry.quantity.unit))
          ->V.ap(V.int(#ErrorVolume(`거래량을 입력해주세요`), entry.volume))
        switch input {
        | Ok(input') => Some(input')
        | Error(_) => None
        }
      })
    let input =
      makeInputUpdate
      ->V.map(V.pure(Some(path)))
      // 판매원표의 Entry의 input 데이터 중 날짜는 밸리데이션하지 않고,
      // 유효하지 않은 날짜 값은 요청에 포함하지 않습니다.
      ->V.ap(V.pure(date->DateFns.isValid ? Some(date) : None))
      ->V.ap(V.pure(wholesalerId))
      ->V.ap(V.pure([inputEntries, inputNewEntries]->Array.concatMany))

    switch input {
    | Ok(input') =>
      mutate(
        ~variables={
          id: ledger.id,
          input: input',
        },
        ~onCompleted={
          (_, _) => {
            addToast(.
              <div className=%twc("flex items-center")>
                <IconCheck height="24" width="24" fill="#12B564" className=%twc("mr-2") />
                {j`수정 요청에 성공하였습니다.`->React.string}
              </div>,
              {appearance: "success"},
            )
            // close()
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
    | Error(errors) => setFormErrors(.prev => prev->Array.concat(errors)) // array<Result.t<'a, 'b>> 순회해서 Error 표시 처리
    }
  }

  <>
    <article className=%twc("mb-5")>
      <label className=%twc("block text-text-L1")> {`업로드 파일`->React.string} </label>
      <LedgerFile path />
    </article>
    <article>
      <h3 className=%twc("text-sm")> {`판매원표 업로드`->React.string} </h3>
      <div className=%twc("flex gap-2 mt-2")>
        <div
          className={switch file {
          | Some(_) =>
            %twc(
              "p-2 relative w-full flex items-center rounded-xl border border-gray-200 text-gray-400"
            )
          | None =>
            %twc(
              "p-2 relative w-full flex items-center rounded-xl border border-gray-200 text-gray-400 bg-gray-100"
            )
          }}>
          <span>
            {file
            ->Option.map(file' => file'->Webapi.File.name)
            ->Option.getWithDefault(`파일명.jpg`)
            ->React.string}
          </span>
          {file
          ->Option.map(_ =>
            <span className=%twc("absolute p-2 right-0") onClick={_ => handleResetFile()}>
              <IconCloseInput height="28" width="28" fill="#B2B2B2" />
            </span>
          )
          ->Option.getWithDefault(React.null)}
        </div>
        <label className=%twc("relative")>
          <span
            className=%twc(
              "inline-block text-center text-text-L1 p-3 w-28 bg-div-shape-L1 rounded-xl focus:outline-none hover:text-white hover:bg-primary whitespace-nowrap hover:cursor-pointer"
            )>
            {j`파일 선택`->React.string}
          </span>
          <input
            id="input-file"
            type_="file"
            accept=`.pdf,.png,.jpg,.gif`
            className=%twc("sr-only")
            onChange=handleOnChangeFiles
          />
        </label>
        <button
          className={file->Option.isSome
            ? %twc(
                "text-white font-bold p-3 w-28 bg-green-gl rounded-xl focus:outline-none hover:bg-green-gl-dark"
              )
            : %twc("text-white font-bold p-3 w-28 bg-gray-300 rounded-xl focus:outline-none")}
          onClick={_ => handleUpload()}
          disabled={file->Option.isNone}>
          {j`업로드`->React.string}
        </button>
      </div>
    </article>
    <section className=%twc("flex gap-2 mt-4")>
      <article className=%twc("w-1/3")>
        <h3 className=%twc("text-sm")> {`판매일자`->React.string} </h3>
        <Input
          name="ledger-date"
          type_="date"
          className=%twc("mt-2")
          size=Input.Small
          value={date}
          onChange=handleOnChangeDate
          error=None
          min="2021-01-01"
        />
      </article>
      <Select_WholesalerMarket
        label=`출하 시장`
        wholesalerMarketId
        wholesalerId
        onChangeWholesalerMarket={handleOnChange(setWholesalerMarketId)}
        onChangeWholesaler={handleOnChange(setWholesalerId)}
        error={formErrors
        ->Array.keepMap(error =>
          switch error {
          | (_, #ErrorWholesalerId(msg)) => Some(msg)
          | _ => None
          }
        )
        ->Garter.Array.first}
      />
    </section>
    <div className=%twc("bg-surface rounded-xl")>
      <section className=%twc("px-4 my-4 divide-y")>
        {entries
        ->Map.String.valuesToArray
        ->Array.map(entry =>
          <FormEntry key={entry.id} id={entry.id} entries setEntries formErrors />
        )
        ->React.array}
        {newEntries
        ->Map.String.toArray
        ->Array.map(((id, _entry)) => {
          <FormEntry key=id id entries=newEntries setEntries=setNewEntries formErrors />
        })
        ->React.array}
      </section>
      <section className=%twc("flex justify-center items-center py-2")>
        <span className=%twc("w-[75px]")>
          <button className=%twc("btn-level2-line-gray py-2 text-sm") onClick={_ => addNewEntry()}>
            {`등급추가`->React.string}
          </button>
        </span>
      </section>
    </div>
    <section>
      <article className=%twc("flex justify-center items-center mt-5")>
        <Dialog.Close className=%twc("flex mr-2")>
          <span id="btn-close" className=%twc("btn-level6 py-3 px-5")>
            {j`닫기`->React.string}
          </span>
        </Dialog.Close>
        <span className=%twc("flex mr-2")>
          <button
            className={isMutating
              ? %twc("btn-level1-disabled py-3 px-5")
              : %twc("btn-level1 py-3 px-5")}
            onClick={_ => handleOnSave()}
            disabled=isMutating>
            {j`저장`->React.string}
          </button>
        </span>
      </article>
    </section>
  </>
}
