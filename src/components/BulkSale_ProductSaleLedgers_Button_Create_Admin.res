/*
 * 1. 컴포넌트 위치
 *   어드민 센터 - 전량 구매 - 생산자 소싱 관리 - (리스트) 원표정보 입력 버튼 - 판매원표 생성 폼
 *
 * 2. 역할
 *   어드민이 농민의 판매원표 정보를 입력/수정합니다.
 * */
open RadixUI
module FormEntry = BulkSale_ProductSaleLedgers_Button_FormEntry_Admin

module MutationCreate = %relay(`
  mutation BulkSaleProductSaleLedgersButtonCreateAdminMutation(
    $input: BulkSaleProductSaleLedgerCreateInput!
    $connections: [ID!]!
  ) {
    createBulkSaleProductSaleLedger(input: $input) {
      result
        @appendNode(
          connections: $connections
          edgeTypeName: "BulkSaleProductSaleLedgerEdge"
        ) {
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

let makeInputCreate = (
  bulkSaleApplicationId,
  path,
  date,
  wholesalerId,
  ledgers,
): BulkSaleProductSaleLedgersButtonCreateAdminMutation_graphql.Types.bulkSaleProductSaleLedgerCreateInput => {
  bulkSaleApplicationId: bulkSaleApplicationId,
  wholesalerId: wholesalerId,
  path: path,
  date: date,
  bulkSaleProductSaleLedgerEntries: ledgers,
}
let makeEntryInputCreate = (
  grade,
  price,
  amount,
  unit,
  volume,
): BulkSaleProductSaleLedgersButtonCreateAdminMutation_graphql.Types.bulkSaleProductSaleLedgerEntryCreateInput => {
  grade: grade,
  price: price,
  quantity: {
    amount: amount,
    unit: unit,
  },
  volume: volume,
}

@react.component
let make = (~connectionId, ~farmmorningUserId, ~applicationId) => {
  let {addToast} = ReactToastNotifications.useToasts()
  let (mutate, isMutating) = MutationCreate.use()

  let (files, setFiles) = React.Uncurried.useState(_ => None)
  let (path, setPath) = React.Uncurried.useState(_ => None)
  let file = files->Option.flatMap(Garter.Array.first)
  // 판매일자
  let (date, setDate) = React.Uncurried.useState(_ => Js.Date.make()->DateFns.format("yyyy-MM-dd"))
  // 출하시장 id
  let (wholesalerMarketId, setWholesalerMarketId) = React.Uncurried.useState(_ => None)
  // 법인명 id
  let (wholesalerId, setWholesalerId) = React.Uncurried.useState(_ => None)
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

  let onSuccess = presignedUrl => setPath(._ => Some(presignedUrl))
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
    let inputNewEntries =
      newEntries
      ->Map.String.valuesToArray
      ->Array.keepMap(entry => {
        let input =
          makeEntryInputCreate
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
      makeInputCreate
      ->V.map(
        V.nonEmpty(
          ("not-existing-ledger-id", #ErrorApplicationId(`applicationId가 필요합니다`)),
          applicationId,
        ),
      )
      ->V.ap(
        V.Option.nonEmpty(
          ("not-existing-ledger-id", #ErrorPath(`파일을 업로드해주세요`)),
          path,
        ),
      )
      ->V.ap(
        V.Option.nonEmpty(
          ("not-existing-ledger-id", #ErrorDate(`날짜를 입력해주세요`)),
          date->Js.Date.fromString->DateFns.isValid ? Some(date) : None,
        ),
      )
      ->V.ap(
        V.Option.nonEmpty(
          (
            "not-existing-ledger-id",
            #ErrorWholesalerId(`출하시장, 법인명을 선택해주세요`),
          ),
          wholesalerId,
        ),
      )
      ->V.ap(V.pure(inputNewEntries))

    switch input {
    | Ok(input') =>
      mutate(
        ~variables={
          input: input',
          connections: [connectionId],
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
    | Error(errors) => setFormErrors(.prev => prev->Array.concat(errors))
    }
  }

  <>
    <article className=%twc("mb-5")>
      {switch path {
      | Some(path') => <>
          <label className=%twc("block text-text-L1")> {`업로드 파일`->React.string} </label>
          <LedgerFile path=path' />
        </>
      | None => React.null
      }}
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
      {formErrors
      ->Array.keepMap(error =>
        switch error {
        | (_, #ErrorPath(msg)) => Some(msg)
        | _ => None
        }
      )
      ->Garter.Array.first
      ->Option.mapWithDefault(React.null, msg =>
        <span className=%twc("flex mt-2")>
          <IconError width="20" height="20" />
          <span className=%twc("text-sm text-notice ml-1")> {msg->React.string} </span>
        </span>
      )}
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
          error={formErrors
          ->Array.keepMap(error =>
            switch error {
            | (_, #ErrorDate(msg)) => Some(msg)
            | _ => None
            }
          )
          ->Garter.Array.first}
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
