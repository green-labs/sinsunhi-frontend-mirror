type step =
  | Grade
  | OrderAmount
  | Usage
  | StorageMethod
  | PackageMethod
  | SupplyPrice
  | Brand
  | Etc

module Query = %relay(`
    query RfqApplyBuyer_Query($itemId: ID!) {
      node(id: $itemId) {
        __typename
        ... on RfqRequestItemMeat {
          id
          species {
            id
            name
            code
            meatGrades(first: 9999, orderBy: RANKING) {
              edges {
                node {
                  id
                  grade
                  isDomestic
                  madeIn
                  meatSpecies {
                    code
                  }
                }
              }
            }
            meatUsages(first: 9999) {
              edges {
                node {
                  id
                  name
                }
              }
            }
          }
          part {
            name
            isDomestic
          }
          grade {
            id
            grade
            madeIn
            meatSpecies {
              id
            }
          }
          weightKg
          usages {
            edges {
              node {
                id
                name
              }
            }
          }
          storageMethod
          packageMethod
          prevTradeSellerName
          prevTradePricePerKg
          preferredBrand
          otherRequirements
          createdAt
          updatedAt
        }
      }
    }
  `)

module Mutation = %relay(`
    mutation RfqApplyBuyer_Update_Mutation(
      $id: ID!
      $input: RfqRequestItemMeatUpdateInput!
    ) {
      updateRfqRequestItemsMeat(id: $id, input: $input) {
        __typename
        ... on RfqRequestItemMeatMutationPayload {
          result {
            id
            grade {
              id
              grade
              madeIn
            }
            weightKg
            usages {
              edges {
                node {
                  id
                  name
                }
              }
            }
            storageMethod
            packageMethod
            prevTradeSellerName
            prevTradePricePerKg
            preferredBrand
            otherRequirements
          }
        }
        ... on Error {
          code
          message
        }
      }
    }
  `)

let convertToOptionStep = s =>
  switch s {
  | "grade" => Grade->Some
  | "orderAmount" => OrderAmount->Some
  | "usage" => Usage->Some
  | "storageMethod" => StorageMethod->Some
  | "packageMethod" => PackageMethod->Some
  | "supplyPrice" => SupplyPrice->Some
  | "brand" => Brand->Some
  | "etc" => Etc->Some
  | _ => None
  }

let toStringStorageMethod = (v: RfqApplyBuyer_Query_graphql.Types.enum_RfqMeatStorageMethod) =>
  switch v {
  | #ANY => `ANY`
  | #CHILLED => `CHILLED`
  | #FREEZE_DRIED => `FREEZE_DRIED`
  | #FROZEN => `FROZEN`
  | #OTHER => `OTHER`
  | _ => ``
  }

let toStringPackageMethod = (v: RfqApplyBuyer_Query_graphql.Types.enum_RfqMeatPackageMethod) =>
  switch v {
  | #ANY => `ANY`
  | #CUT => `CUT`
  | #OTHER => `OTHER`
  | #RAW => `RAW`
  | #SPLIT => `SPLIT`
  | _ => ``
  }

module Apply = {
  type item = {
    grade: option<string>,
    weightKg: option<string>,
    usages: array<string>,
    storageMethod: option<string>,
    packageMethod: option<string>,
    prevTradePricePerKg: option<string>,
    prevTradeSellerName: option<string>,
    preferredBrand: option<string>,
    otherRequirements: option<string>,
  }

  let getItemInfo = (node: option<RfqApplyBuyer_Query_graphql.Types.response_node>) => {
    let itemInfo = switch node {
    | Some(node') => {
        grade: node'.grade->Option.mapWithDefault(None, grade' => Some(grade'.id)),
        weightKg: node'.weightKg->Option.mapWithDefault(None, weightKg' => Some(
          weightKg'->Js.String2.make,
        )),
        usages: node'.usages.edges->Garter_Array.isEmpty
          ? []
          : node'.usages.edges->Array.map(edge => edge.node.id),
        storageMethod: node'.storageMethod->Option.mapWithDefault(None, storageMethod' => Some(
          storageMethod'->toStringStorageMethod,
        )),
        packageMethod: node'.packageMethod->Option.mapWithDefault(None, packageMethod' => Some(
          packageMethod'->toStringPackageMethod,
        )),
        prevTradePricePerKg: node'.prevTradePricePerKg->Option.mapWithDefault(
          None,
          prevTradePricePerKg' => Some(prevTradePricePerKg'->Js.String2.make),
        ),
        prevTradeSellerName: node'.prevTradeSellerName == ""
          ? None
          : Some(node'.prevTradeSellerName),
        preferredBrand: node'.preferredBrand == "" ? None : Some(node'.preferredBrand),
        otherRequirements: node'.otherRequirements == "" ? None : Some(node'.otherRequirements),
      }
    | None => {
        grade: None,
        weightKg: None,
        usages: [],
        storageMethod: None,
        packageMethod: None,
        prevTradePricePerKg: None,
        prevTradeSellerName: None,
        preferredBrand: None,
        otherRequirements: None,
      }
    }

    let getEmptyGradeId = (speciesCode, isDomestic) => {
      node
      ->Option.flatMap(x => x.species)
      ->Option.map(x => x.meatGrades.edges)
      ->Option.mapWithDefault(None, x =>
        x
        ->Array.map(x => x.node)
        ->Array.keep(x => speciesCode === x.meatSpecies.code)
        ->Array.keep(x => x.isDomestic === isDomestic)
        ->Garter.Array.first
      )
      ->Option.mapWithDefault(None, x => x.id->Some)
    }

    let (isSkipGrade, emptyGradeId) = {
      // 닭고기 or 돼지고기(수입산) 은 등급이 없으므로 skip
      node->Option.mapWithDefault((false, None), node' => {
        switch (node'.species->Option.map(x => x.code), node'.part->Option.map(x => x.isDomestic)) {
        | (Some(speciesCode'), Some(isDomestic')) =>
          switch (speciesCode', isDomestic') {
          | ("CHICKEN", _) => (true, getEmptyGradeId(speciesCode', isDomestic'))
          | ("PORK", false) => (true, getEmptyGradeId(speciesCode', isDomestic'))
          | _ => (false, None)
          }
        | _ => (false, None)
        }
      })
    }

    (itemInfo, isSkipGrade, emptyGradeId)
  }

  @react.component
  let make = (~itemId, ~requestId, ~step) => {
    let isModifyDetail = step->Option.flatMap(convertToOptionStep)->Option.isSome

    let router = Next.Router.useRouter()

    let {addToast} = ReactToastNotifications.useToasts()

    let {node} = Query.use(~variables={itemId: itemId}, ())

    let (mutateUpdate, _) = Mutation.use()

    let (itemInfo, isSkipGrade, emtyGradeId) = getItemInfo(node)
    let (step, setStep) = React.Uncurried.useState(_ =>
      step->Option.flatMap(convertToOptionStep)->Option.getWithDefault(PackageMethod)
    )

    let (grade, setGrade) = React.Uncurried.useState(_ =>
      isModifyDetail ? itemInfo.grade : isSkipGrade ? emtyGradeId : None
    )
    let (weightKg, setWeightKg) = React.Uncurried.useState(_ =>
      isModifyDetail ? itemInfo.weightKg : None
    )
    let (usage, setUsage) = React.Uncurried.useState(_ => isModifyDetail ? itemInfo.usages : [])
    let (storageMethod, setStorageMethod) = React.Uncurried.useState(_ =>
      isModifyDetail ? itemInfo.storageMethod : None
    )
    let (packageMethod, setPackageMethod) = React.Uncurried.useState(_ =>
      isModifyDetail ? itemInfo.packageMethod : None
    )
    let (prevTradePricePerKg, setPrevTradePricePerKg) = React.Uncurried.useState(_ =>
      isModifyDetail ? itemInfo.prevTradePricePerKg : None
    )
    let (prevTradeSellerName, setPrevTradeSellerName) = React.Uncurried.useState(_ =>
      isModifyDetail ? itemInfo.prevTradeSellerName : None
    )
    let (preferredBrand, setPreferredBrand) = React.Uncurried.useState(_ =>
      isModifyDetail ? itemInfo.preferredBrand : None
    )
    let (etc, setEtc) = React.Uncurried.useState(_ =>
      isModifyDetail ? itemInfo.otherRequirements : None
    )

    React.useEffect1(_ => {
      DataGtm.push({
        "event": switch step {
        | Grade => "Expose_view_RFQ_Livestock_MeatGrade"
        | OrderAmount => "Expose_view_RFQ_Livestock_WeightKg"
        | Usage => "Expose_view_RFQ_Livestock_MeatUsage"
        | StorageMethod => "Expose_view_RFQ_Livestock_StorageStatus"
        | PackageMethod => "Expose_view_RFQ_Livestock_PackageMethod"
        | SupplyPrice => "Expose_view_RFQ_Livestock_Prevtradepriceperkg"
        | Brand => "Expose_view_RFQ_Livestock_PreferredBrand"
        | Etc => "Expose_view_RFQ_Livestock_Otherrequest"
        },
      })
      None
    }, [step])

    let getTitle =
      node->Option.mapWithDefault("", node' =>
        node'.part->Option.mapWithDefault("", part' =>
          `${part'.name} / ${part'.isDomestic ? `국내` : `수입`}`
        )
      )

    let handleOnChangeStepPrev = _ => {
      if isModifyDetail {
        router->Next.Router.push(`/buyer/rfq/request/draft/list?requestId=${requestId}`)
      } else {
        switch step {
        | PackageMethod =>
          router->Next.Router.push(`/buyer/rfq/request/draft/list?requestId=${requestId}`)
        | Grade => setStep(._ => PackageMethod)
        | OrderAmount => setStep(._ => isSkipGrade ? PackageMethod : Grade)
        | Usage => setStep(._ => OrderAmount)
        | StorageMethod => setStep(._ => Usage)
        | SupplyPrice => setStep(._ => StorageMethod)
        | Brand => setStep(._ => SupplyPrice)
        | Etc => setStep(._ => Brand)
        }
      }
    }

    let handleOnChange = (setFn, value) => {
      setFn(._ => value->Js.String2.trim === "" ? None : Some(value))
    }

    let checkDisabled = step => {
      let disableFlag = switch step {
      | PackageMethod => packageMethod->Option.isNone
      | Grade => grade->Option.isNone
      | OrderAmount =>
        weightKg->Option.isNone ||
          weightKg
          ->Option.flatMap(x => x->Int.fromString)
          ->Option.mapWithDefault(false, x => x < 50)

      | Usage => usage->Garter.Array.isEmpty
      | StorageMethod => storageMethod->Option.isNone
      | SupplyPrice =>
        prevTradePricePerKg->Option.isNone ||
          prevTradePricePerKg
          ->Option.flatMap(x => x->Int.fromString)
          ->Option.mapWithDefault(false, x => x < 100)
      | Brand => preferredBrand->Option.isNone
      | Etc => etc->Option.isNone
      }

      // 세부저장일 경우 이전값과 같은지 체크
      if !disableFlag && isModifyDetail {
        switch step {
        | PackageMethod =>
          itemInfo.packageMethod->Option.mapWithDefault(false, x =>
            x === packageMethod->Option.getWithDefault("")
          )
        | Grade =>
          itemInfo.grade->Option.mapWithDefault(false, x => x === grade->Option.getWithDefault(""))
        | OrderAmount =>
          itemInfo.weightKg->Option.mapWithDefault(false, x =>
            x === weightKg->Option.getWithDefault("")
          )
        | StorageMethod =>
          itemInfo.storageMethod->Option.mapWithDefault(false, x =>
            x === storageMethod->Option.getWithDefault("")
          )
        | Usage
        | SupplyPrice
        | Brand
        | Etc => disableFlag
        }
      } else {
        disableFlag
      }
    }

    let updateItem = (~emptyUsage=?, ~emptyBrand=?, ~emptyEtc=?, ()) => {
      let input: RfqApplyBuyer_Update_Mutation_graphql.Types.rfqRequestItemMeatUpdateInput = {
        meatGradeId: grade,
        meatPartId: None,
        meatSpeciesId: None,
        meatUsageIds: {
          switch emptyUsage {
          | Some(emptyUsage') => emptyUsage'
          | None => usage->Garter.Array.isEmpty ? [] : usage
          }
        },
        storageMethod,
        packageMethod,
        preferredBrand: {
          switch emptyBrand {
          | Some(emptyBrand') => emptyBrand'
          | None => preferredBrand
          }
        },
        prevTradePricePerKg,
        prevTradeSellerName,
        weightKg,
        otherRequirements: {
          switch emptyEtc {
          | Some(emptyEtc') => emptyEtc'
          | None => etc
          }
        },
        status: #READY_TO_REQUEST,
      }

      mutateUpdate(
        ~variables={id: itemId, input},
        ~onCompleted={
          ({updateRfqRequestItemsMeat}, _) => {
            switch updateRfqRequestItemsMeat {
            | #RfqRequestItemMeatMutationPayload(_) =>
              addToast(.
                `${getTitle} 작성이 완료되었어요!`->DS_Toast.getToastComponent(#succ),
                {appearance: "succ"},
              )
            | #Error(error) =>
              error.code->Js.Console.error
              addToast(.
                `요청 중 요류가 발생했습니다. 잠시 후 다시 시도해주세요.`->DS_Toast.getToastComponent(
                  #error,
                ),
                {appearance: "error"},
              )
            | #UnselectedUnionMember(_) => ()
            }

            router->Next.Router.push(`/buyer/rfq/request/draft/list?requestId=${requestId}`)
          }
        },
        ~onError=_ => {
          addToast(.
            `저장중 문제가 발생하였습니다. 관리자에게 문의해주세요.`->DS_Toast.getToastComponent(
              #error,
            ),
            {appearance: "error"},
          )
        },
        (),
      )->ignore
    }

    let handleModifyMutation = (step, _) => {
      switch isModifyDetail {
      | true => updateItem()
      | false =>
        setStep(._ =>
          switch step {
          | PackageMethod => isSkipGrade ? OrderAmount : Grade
          | Grade => OrderAmount
          | OrderAmount => Usage
          | Usage => StorageMethod
          | StorageMethod => SupplyPrice
          | SupplyPrice => Brand
          | Brand => Etc
          | Etc => Grade
          }
        )
      }
    }

    <>
      <div className=%twc("relative container max-w-3xl mx-auto min-h-screen sm:shadow-gl pt-11")>
        <DS_TopNavigation.Detail.Root>
          <DS_TopNavigation.Detail.Left>
            <a className=%twc("cursor-pointer") onClick={_ => handleOnChangeStepPrev()}>
              <DS_Icon.Common.ArrowLeftXLarge1 height="32" width="32" className=%twc("relative") />
            </a>
          </DS_TopNavigation.Detail.Left>
          <DS_TopNavigation.Detail.Center>
            {getTitle->React.string}
          </DS_TopNavigation.Detail.Center>
          {
            let nextStep = switch step {
            | Usage => Some(StorageMethod)
            | Brand => Some(Etc)
            | Etc => Some(Etc)
            | _ => None
            }

            nextStep->Option.mapWithDefault(React.null, nextStep' =>
              <button
                onClick={_ => {
                  switch step {
                  | Usage => setUsage(._ => [])
                  | Brand => setPreferredBrand(._ => None)
                  | Etc => setEtc(._ => None)
                  | _ => ()
                  }

                  isModifyDetail
                    ? switch step {
                      | Usage => updateItem(~emptyUsage=[], ())
                      | Brand => updateItem(~emptyBrand=Some(""), ())
                      | Etc => updateItem(~emptyEtc=Some(""), ())
                      | _ => ()
                      }
                    : switch step {
                      | Etc => updateItem()
                      | _ => setStep(._ => nextStep')
                      }
                }}
                className=%twc("text-enabled-L1")>
                {`건너뛰기`->React.string}
              </button>
            )
          }
        </DS_TopNavigation.Detail.Root>
        {<DS_ProgressBar.StepGuide
          step={switch step {
          | PackageMethod => 1
          | Grade => 2
          | OrderAmount => 3
          | Usage => 4
          | StorageMethod => 5
          | SupplyPrice => 6
          | Brand => 7
          | Etc => 8
          }}
          totalStep=8
        />}
        {node->Option.mapWithDefault(React.null, node' => {
          switch step {
          | PackageMethod =>
            <RfqApplyDetail_Buyer.PackageMethod
              packageMethod handleOnChangePackageMethod={handleOnChange(setPackageMethod)}
            />
          | Grade =>
            <RfqApplyDetail_Buyer.Grade
              grade handleOnChangeGrade={handleOnChange(setGrade)} node=node'
            />
          | OrderAmount =>
            <RfqApplyDetail_Buyer.OrderAmount
              weightKg handleOnChangeWeightKg={handleOnChange(setWeightKg)}
            />
          | Usage =>
            <RfqApplyDetail_Buyer.Purpose
              usage
              setUsage
              edges={node'.species->Option.mapWithDefault([], x => x.meatUsages.edges)}
            />
          | StorageMethod =>
            <RfqApplyDetail_Buyer.StorageMethod
              storageMethod handleOnChangeStorageMethod={handleOnChange(setStorageMethod)}
            />
          | SupplyPrice =>
            <RfqApplyDetail_Buyer.SupplyPrice
              prevTradeSellerName
              handleOnChangePrevTradeSellerName={handleOnChange(setPrevTradeSellerName)}
              prevTradePricePerKg
              handleOnChangePrevTradePricePerKg={handleOnChange(setPrevTradePricePerKg)}
            />
          | Brand =>
            <RfqApplyDetail_Buyer.Brand
              preferredBrand handleOnChangePreferredBrand={handleOnChange(setPreferredBrand)}
            />
          | Etc => <RfqApplyDetail_Buyer.Etc etc handleOnChangeEtc={handleOnChange(setEtc)} />
          }
        })}
      </div>
      {switch step {
      | Grade
      | Usage
      | StorageMethod
      | PackageMethod =>
        <DS_ButtonContainer.Floating1
          dataGtm={switch step {
          | Grade => `Click_RFQ_Livestock_MeatGrade`
          | Usage => `Click_RFQ_Livestock_MeatUsage`
          | StorageMethod => `Click_RFQ_Livestock_StorageStatus`
          | PackageMethod => `Click_RFQ_Livestock_PackageMethod`
          | _ => ``
          }}
          disabled={checkDisabled(step)}
          label={isModifyDetail ? `저장` : `다음`}
          onClick={handleModifyMutation(step)}
        />
      | OrderAmount
      | SupplyPrice
      | Brand =>
        <DS_ButtonContainer.Full1
          dataGtm={switch step {
          | OrderAmount => `Click_RFQ_Livestock_WeightKg`
          | SupplyPrice => `Click_RFQ_Livestock_Prevtradepriceperkg`
          | Brand => `Click_RFQ_Livestock_PreferredBrand`
          | _ => ``
          }}
          disabled={checkDisabled(step)}
          label={isModifyDetail ? `저장` : `다음`}
          onClick={handleModifyMutation(step)}
        />
      | Etc =>
        <DS_ButtonContainer.Full1
          dataGtm={`Click_RFQ_Livestock_OtherRequirements`}
          disabled={checkDisabled(step)}
          label={isModifyDetail ? `저장` : `다음`}
          onClick={_ => {
            updateItem()
          }}
        />
      }}
    </>
  }
}

@react.component
let make = (~itemId: option<string>, ~requestId: option<string>, ~step: option<string>) => {
  let router = Next.Router.useRouter()

  {
    switch (itemId, requestId) {
    | (Some(itemId'), Some(requestId')) =>
      <Authorization.Buyer fallback={React.null} title={j`바이어 견적 요청`}>
        <React.Suspense>
          <RfqCommon.CheckBuyerRequestStatus requestId={requestId'}>
            <Apply itemId={itemId'} requestId={requestId'} step />
          </RfqCommon.CheckBuyerRequestStatus>
        </React.Suspense>
      </Authorization.Buyer>
    | _ => {
        React.useEffect0(_ => {
          router->Next.Router.push("/buyer/rfq")
          None
        })
        React.null
      }
    }
  }
}
