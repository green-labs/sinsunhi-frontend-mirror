module List = CostManagement_List_Admin

let convertCost: CustomHooks.Costs.cost => (string, Cost_Admin.newCost) = cost => (
  cost.sku,
  {
    rawCost: None,
    workingCost: None,
    deliveryCost: None,
    effectiveDate: None,
    price: None,
    contractType: cost.contractType,
    producerName: cost.producerName,
    productName: cost.producerName,
    optionName: cost.optionName,
    producerId: cost.producerId,
    productId: cost.productId,
    sku: cost.sku,
  },
)

module Costs = {
  @react.component
  let make = (~status: CustomHooks.Costs.result) => {
    let router = Next.Router.useRouter()
    let {mutate} = Swr.useSwrConfig()
    let {addToast} = ReactToastNotifications.useToasts()

    let (skusToSave, setSkusToSave) = React.Uncurried.useState(_ => Set.String.empty)
    let (startDate, setStartDate) = React.Uncurried.useState(_ =>
      Js.Date.make()->DateFns.addDays(1)
    )
    let (newCosts, setNewCosts) = React.Uncurried.useState(_ => Map.String.empty)
    let (isShowNothingToSave, setShowNothingToSave) = React.Uncurried.useState(_ => Dialog.Hide)
    let (isShowInvalidCost, setShowInvalidCost) = React.Uncurried.useState(_ => Dialog.Hide)
    let (isShowSuccessToSave, setShowSuccessToSave) = React.Uncurried.useState(_ => Dialog.Hide)

    let handleOnChangeDate = e => {
      let newDate = (e->DuetDatePicker.DuetOnChangeEvent.detail).valueAsDate
      switch newDate {
      | Some(newDate') => setStartDate(._ => newDate')
      | None => ()
      }
    }

    let handleOnChangeEffectiveDate = (sku, dateAsValue: Js.Date.t) => {
      let newSkusToSave = skusToSave->Set.String.add(sku)
      setSkusToSave(._ => newSkusToSave)

      Js.log2("date", dateAsValue->Js.Date.toISOString)

      setNewCosts(.prevCosts =>
        prevCosts
        ->Map.String.get(sku)
        ->Option.map((prevCost: Cost_Admin.newCost) => {
          ...prevCost,
          effectiveDate: Some(dateAsValue),
        })
        ->Option.mapWithDefault(prevCosts, newCost => prevCosts->Map.String.set(sku, newCost))
      )
    }

    let handleOnChangePrice = (sku, newPrice) => {
      let newSkusToSave = skusToSave->Set.String.add(sku)
      setSkusToSave(._ => newSkusToSave)

      setNewCosts(.prevCosts =>
        prevCosts
        ->Map.String.get(sku)
        ->Option.map((prevCost: Cost_Admin.newCost) => {
          ...prevCost,
          price: Some(newPrice),
        })
        ->Option.mapWithDefault(prevCosts, newCost => prevCosts->Map.String.set(sku, newCost))
      )
    }

    let handleOnChangeRawCost = (sku, newCost) => {
      let newSkusToSave = skusToSave->Set.String.add(sku)
      setSkusToSave(._ => newSkusToSave)

      setNewCosts(.prevCosts =>
        prevCosts
        ->Map.String.get(sku)
        ->Option.map(prevCost => {...prevCost, rawCost: Some(newCost)})
        ->Option.mapWithDefault(prevCosts, newCost' => prevCosts->Map.String.set(sku, newCost'))
      )
    }

    let handleOnChangeDeliveryCost = (sku, newCost) => {
      let newSkusToSave = skusToSave->Set.String.add(sku)
      setSkusToSave(._ => newSkusToSave)

      setNewCosts(.prevCosts =>
        prevCosts
        ->Map.String.get(sku)
        ->Option.map(prevCost => {...prevCost, deliveryCost: Some(newCost)})
        ->Option.mapWithDefault(prevCosts, newCost' => prevCosts->Map.String.set(sku, newCost'))
      )
    }

    let handleOnChangeWorkingCost = (sku, newCost) => {
      let newSkusToSave = skusToSave->Set.String.add(sku)
      setSkusToSave(._ => newSkusToSave)

      setNewCosts(.prevCosts =>
        prevCosts
        ->Map.String.get(sku)
        ->Option.map(prevCost => {...prevCost, workingCost: Some(newCost)})
        ->Option.mapWithDefault(prevCosts, newCost' => prevCosts->Map.String.set(sku, newCost'))
      )
    }

    let count = switch status {
    | Loaded(costs) =>
      switch costs->CustomHooks.Costs.costs_decode {
      | Ok(costs') => costs'.count->Int.toString
      | Error(_) => `-`
      }
    | _ => `-`
    }

    let handleOnChangeContractType = (sku, typeAsValue) => {
      let newSkusToSave = skusToSave->Set.String.add(sku)
      setSkusToSave(._ => newSkusToSave)

      setNewCosts(.prevCosts =>
        prevCosts
        ->Map.String.get(sku)
        ->Option.map((prevCost: Cost_Admin.newCost) => {
          ...prevCost,
          contractType: typeAsValue,
        })
        ->Option.mapWithDefault(prevCosts, newCost' => prevCosts->Map.String.set(sku, newCost'))
      )
    }

    let handleOnCheckCost = (productSku, e) => {
      let checked = (e->ReactEvent.Synthetic.target)["checked"]
      if checked {
        let newSkusToSave = skusToSave->Set.String.add(productSku)
        setSkusToSave(._ => newSkusToSave)
      } else {
        let newSkusToSave = skusToSave->Set.String.remove(productSku)
        setSkusToSave(._ => newSkusToSave)
      }
    }
    let check = productSku => {
      skusToSave->Set.String.has(productSku)
    }

    let handleCheckAll = e => {
      let checked = (e->ReactEvent.Synthetic.target)["checked"]
      if checked {
        switch status {
        | Loaded(costs) =>
          let allOrderProductNo = switch costs->CustomHooks.Costs.costs_decode {
          | Ok(costs') => costs'.data->Garter.Array.map(cost => cost.sku)->Set.String.fromArray
          | Error(_) => Set.String.empty
          }
          setSkusToSave(._ => allOrderProductNo)
        | _ => ()
        }
      } else {
        setSkusToSave(._ => Set.String.empty)
      }
    }
    let countOfChecked = skusToSave->Set.String.size

    let handleOnSave = (
      _ => {
        if skusToSave->Set.String.size < 1 {
          setShowNothingToSave(._ => Dialog.Show)
        } else if (
          newCosts
          ->Map.String.toArray
          // 체크박스를 선택한 sku들만 keep하고
          ->Garter.Array.keep(((k, _)) => skusToSave->Set.String.has(k))
          // sku 중 새로운 변경원가시작일과 변경원가를 입력한 것만 keep한다.
          ->Garter.Array.keep(((_, v)) =>
            v.price->Option.flatMap(price => price->Float.fromString)->Option.isSome &&
            v.rawCost->Option.flatMap(cost => cost->Float.fromString)->Option.isSome &&
            v.effectiveDate->Option.isSome &&
            v.deliveryCost->Option.flatMap(Float.fromString)->Option.isSome &&
            v.workingCost->Option.flatMap(Float.fromString)->Option.isSome
          )
          // 체크박스로 선택한 sku와 변경원가시작일과 변경원가를 입력한 sku들의 개수가 같은지 확인한다.
          ->Garter.Array.length !== skusToSave->Set.String.size
        ) {
          setShowInvalidCost(._ => Dialog.Show)
        } else {
          {
            "list": newCosts
            ->Map.String.toArray
            ->Garter.Array.keep(((k, _)) => skusToSave->Set.String.has(k))
            ->Garter.Array.map(((_, v)) => {
              {
                "price": v.price->Option.map(Float.fromString),
                "raw-cost": v.rawCost->Option.map(Float.fromString),
                "delivery-cost": v.deliveryCost->Option.map(Float.fromString),
                "working-cost": v.workingCost->Option.map(Float.fromString),
                "effective-date": v.effectiveDate->Option.map(Js.Date.toISOString),
                "producer-id": v.producerId,
                "product-id": v.productId,
                "sku": v.sku,
                "contract-type": v.contractType->CustomHooks.Costs.contractType_encode,
              }
            }),
          }
          ->Js.Json.stringifyAny
          ->Option.forEach(body =>
            FetchHelper.requestWithRetry(
              ~fetcher=FetchHelper.postWithToken,
              ~url=`${Env.restApiUrl}/settlement/cost`,
              ~body,
              ~count=3,
              ~onSuccess={
                _ => {
                  setShowSuccessToSave(._ => Dialog.Show)
                  mutate(.
                    ~url=`${Env.restApiUrl}/settlement/cost?${router.query
                      ->Webapi.Url.URLSearchParams.makeWithDict
                      ->Webapi.Url.URLSearchParams.toString}`,
                    ~data=None,
                    ~revalidation=Some(true),
                  )
                  setSkusToSave(._ => Set.String.empty)
                }
              },
              ~onFailure={
                _ =>
                  addToast(.
                    <div className=%twc("flex items-center")>
                      <IconError height="24" width="24" className=%twc("mr-2") />
                      {j`저장 실패`->React.string}
                    </div>,
                    {appearance: "error"},
                  )
              },
            )->ignore
          )
        }
      }
    )->ReactEvents.interceptingHandler

    let handleChangeAllEffectiveDate = (
      _ => {
        setNewCosts(.prevCosts =>
          prevCosts->Map.String.mapWithKey((k, v) => {
            if skusToSave->Set.String.has(k) {
              {
                ...v,
                effectiveDate: startDate->Some,
              }
            } else {
              v
            }
          })
        )
      }
    )->ReactEvents.interceptingHandler

    // 변경 전 원가 데이터와 새로 변경할 데이터가 한 화면에서 각각 처리되어야 하기 때문에,
    // fetch한 원가 데이터를 newCosts: Map.String에 저장해서 처리한다.

    React.useEffect1(_ => {
      switch status {
      | Loaded(costs) =>
        switch costs->CustomHooks.Costs.costs_decode {
        | Ok(costs') =>
          setNewCosts(._ => costs'.data->Garter.Array.map(convertCost)->Map.String.fromArray)
        | Error(_) => ()
        }
      | _ => ()
      }

      Some(_ => setNewCosts(._ => Map.String.empty))
    }, [status])

    <>
      <div
        className=%twc(
          "max-w-gnb-panel overflow-auto overflow-x-scroll bg-div-shape-L1 min-h-screen"
        )>
        <header className=%twc("flex items-baseline p-7 pb-0")>
          <h1 className=%twc("text-text-L1 text-xl font-bold")>
            {j`단품 가격관리`->React.string}
          </h1>
        </header>
        <Summary_Cost_Admin />
        <div className=%twc("p-7 m-4 bg-white rounded shadow-gl overflow-auto overflow-x-scroll")>
          <div className=%twc("divide-y")>
            <div className=%twc("flex flex-auto justify-between pb-3")>
              <h3 className=%twc("text-lg font-bold")>
                {j`내역`->React.string}
                <span className=%twc("text-base text-primary font-normal ml-1")>
                  {j`${count}건`->React.string}
                </span>
              </h3>
              <div className=%twc("flex")>
                <Select_CountPerPage className=%twc("mr-2") /> <Select_Cost_Kind />
              </div>
            </div>
            <div className=%twc("flex items-center mb-3 pt-3")>
              <div className=%twc("mr-2")>
                {j`선택됨`->React.string}
                <span className=%twc("text-default font-bold ml-1")>
                  {countOfChecked->Int.toString->React.string}
                </span>
              </div>
              <div className=%twc("flex items-center mx-2")>
                <DatePicker
                  id="start-date"
                  date={startDate}
                  onChange={handleOnChangeDate}
                  firstDayOfWeek=0
                  align=DatePicker.Left
                  minDate="2021-01-01"
                />
                <span className=%twc("w-auto")>
                  <button
                    onClick=handleChangeAllEffectiveDate
                    className={skusToSave->Set.String.size > 0
                      ? %twc("btn-level6 p-2 px-4 ml-2")
                      : %twc("btn-level6-disabled p-2 px-4 ml-2")}
                    disabled={skusToSave->Set.String.size < 1}>
                    {j`변경원가시작일 일괄적용`->React.string}
                  </button>
                </span>
              </div>
              <div className=%twc("ml-2")>
                <button className=%twc("btn-level1 p-2 px-4") onClick=handleOnSave>
                  {j`저장`->React.string}
                </button>
              </div>
            </div>
          </div>
          <List
            status
            newCosts
            onChangeEffectiveDate=handleOnChangeEffectiveDate
            onChangePrice=handleOnChangePrice
            onChangeRawCost=handleOnChangeRawCost
            onChangeDeliveryCost=handleOnChangeDeliveryCost
            onChangeWorkingCost=handleOnChangeWorkingCost
            onChangeContractType=handleOnChangeContractType
            check
            onCheckCost=handleOnCheckCost
            onCheckAll=handleCheckAll
            countOfChecked
          />
        </div>
      </div>
      <Dialog
        isShow=isShowNothingToSave
        textOnCancel=`확인`
        onCancel={_ => setShowNothingToSave(._ => Dialog.Hide)}>
        <p className=%twc("text-gray-500 text-center whitespace-pre-wrap")>
          {`저장할 상품 항목을 선택해주세요`->React.string}
        </p>
      </Dialog>
      <Dialog
        isShow=isShowInvalidCost
        textOnCancel=`확인`
        onCancel={_ => setShowInvalidCost(._ => Dialog.Hide)}>
        <p className=%twc("text-gray-500 text-center whitespace-pre-wrap")>
          {`입력하신 변경원가시작일과 변경원가,변경바이어판매가를 확인해주세요.`->React.string}
        </p>
      </Dialog>
      <Dialog
        isShow=isShowSuccessToSave
        textOnCancel=`확인`
        onCancel={_ => setShowSuccessToSave(._ => Dialog.Hide)}>
        <p className=%twc("text-gray-500 text-center whitespace-pre-wrap")>
          {`선택한 변경원가,변경바이어판매가,변경원가시작일이 저장되었습니다.`->React.string}
        </p>
      </Dialog>
    </>
  }
}

@react.component
let make = () => {
  let router = Next.Router.useRouter()
  let status = CustomHooks.Costs.use(
    router.query->Webapi.Url.URLSearchParams.makeWithDict->Webapi.Url.URLSearchParams.toString,
  )

  <Authorization.Admin title=j`관리자 단품가격관리`>
    <Costs status />
  </Authorization.Admin>
}
