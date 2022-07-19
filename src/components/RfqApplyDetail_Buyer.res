type madinInType = RfqApplyBuyer_Query_graphql.Types.enum_MeatMadeIn

let convertNumberInputValue = value =>
  value->Js.String2.replaceByRe(%re("/[^0-9]/g"), "")->Js.String2.replaceByRe(%re("/^[0]/g"), "")

let numberToComma = n =>
  n
  ->Float.fromString
  ->Option.mapWithDefault("", x => Intl.Currency.make(~value=x, ~locale={"ko-KR"->Some}, ()))

module Grade = {
  module List = {
    @react.component
    let make = (
      ~edges: array<RfqApplyBuyer_Query_graphql.Types.response_node_species_meatGrades_edges>,
      ~madeIn: madinInType,
      ~handleOnChangeGrade,
      ~grade,
    ) => {
      edges
      ->Array.keep(x => x.node.madeIn === madeIn)
      ->Array.map(x => {
        let isSelected = grade->Option.mapWithDefault(false, grade' => grade' === x.node.id)

        <DS_ListItem.Normal1.Item key={x.node.id} onClick={_ => handleOnChangeGrade(x.node.id)}>
          <DS_ListItem.Normal1.TextGroup title1={x.node.grade} />
          <DS_ListItem.Normal1.RightGroup>
            {isSelected
              ? <DS_Icon.Common.RadioOnLarge1 height="24" width="24" fill={"#12B564"} />
              : <DS_Icon.Common.RadioOffLarge1 height="24" width="24" fill={"#B2B2B2"} />}
          </DS_ListItem.Normal1.RightGroup>
        </DS_ListItem.Normal1.Item>
      })
      ->React.array
    }
  }
  @react.component
  let make = (
    ~grade,
    ~handleOnChangeGrade,
    ~node: RfqApplyBuyer_Query_graphql.Types.response_node,
  ) => {
    let {part, species} = node
    let isBeef = species->Option.mapWithDefault(false, x => x.name === `소고기`)
    let isDomestic = part->Option.mapWithDefault(false, x => x.isDomestic)
    let edges = species->Option.mapWithDefault([], x => x.meatGrades.edges)

    let (madeIn, setMadeIn) = React.Uncurried.useState(_ =>
      isDomestic ? #KR : isBeef ? #US : #OTHER
    )

    <section className=%twc("pt-7 pb-28")>
      <DS_Title.Normal1.Root>
        <DS_Title.Normal1.TextGroup
          title1={`찾으시는 상품의`} title2={`등급을 선택해주세요`}
        />
      </DS_Title.Normal1.Root>
      <article className=%twc("px-5")>
        <DS_Tab.LeftTab.Root className=%twc("mt-8 space-x-0")>
          {isDomestic
            ? <DS_Tab.LeftTab.Item>
                <DS_Button.Chip.TextSmall1
                  className=%twc("text-sm")
                  label={`국내산`}
                  onClick={_ => setMadeIn(._ => #KR)}
                  selected={madeIn === #KR}
                />
              </DS_Tab.LeftTab.Item>
            : {
                switch isBeef {
                | true =>
                  <>
                    <DS_Tab.LeftTab.Item>
                      <DS_Button.Chip.TextSmall1
                        className=%twc("text-sm")
                        label={`미국산`}
                        onClick={_ => setMadeIn(._ => #US)}
                        selected={madeIn === #US}
                      />
                    </DS_Tab.LeftTab.Item>
                    <DS_Tab.LeftTab.Item>
                      <DS_Button.Chip.TextSmall1
                        className=%twc("text-sm")
                        label={`호주산`}
                        onClick={_ => setMadeIn(._ => #AU)}
                        selected={madeIn === #AU}
                      />
                    </DS_Tab.LeftTab.Item>
                    <DS_Tab.LeftTab.Item>
                      <DS_Button.Chip.TextSmall1
                        className=%twc("text-sm")
                        label={`캐나다산`}
                        onClick={_ => setMadeIn(._ => #CA)}
                        selected={madeIn === #CA}
                      />
                    </DS_Tab.LeftTab.Item>
                    <DS_Tab.LeftTab.Item>
                      <DS_Button.Chip.TextSmall1
                        className=%twc("text-sm")
                        label={`뉴질랜드산`}
                        onClick={_ => setMadeIn(._ => #NZ)}
                        selected={madeIn === #NZ}
                      />
                    </DS_Tab.LeftTab.Item>
                  </>
                | false =>
                  <DS_Tab.LeftTab.Item>
                    <DS_Button.Chip.TextSmall1
                      className=%twc("text-sm")
                      label={`수입산`}
                      onClick={_ => setMadeIn(._ => #OTHER)}
                      selected={madeIn === #OTHER}
                    />
                  </DS_Tab.LeftTab.Item>
                }
              }}
        </DS_Tab.LeftTab.Root>
      </article>
      <DS_ListItem.Normal1.Root className=%twc("space-y-8 mt-11 tab-highlight-color")>
        <List edges madeIn handleOnChangeGrade grade />
      </DS_ListItem.Normal1.Root>
    </section>
  }
}

module OrderAmount = {
  @react.component
  let make = (~weightKg, ~handleOnChangeWeightKg) => {
    let minimumAmount = 50

    <section className=%twc("pt-7")>
      <DS_Title.Normal1.Root>
        <DS_Title.Normal1.TextGroup title1={`주문량을`} title2={`작성해주세요`} />
      </DS_Title.Normal1.Root>
      <DS_InputField.Line1.Root className=%twc("mt-4")>
        <DS_InputField.Line1.Input
          type_="text"
          placeholder={`납품 1회당 배송량`}
          inputMode={"decimal"}
          value={weightKg->Option.mapWithDefault(``, x =>
            x->Js.String2.split(".")->Garter_Array.firstExn->numberToComma
          )}
          autoFocus=true
          onChange={e => {
            let value = (e->ReactEvent.Synthetic.target)["value"]
            handleOnChangeWeightKg(value->convertNumberInputValue)
          }}
          unit={`kg`}
          isClear=true
          fnClear={_ => handleOnChangeWeightKg("")}
          underLabelType=#ton
          underLabel={`최소 주문량 ${minimumAmount->Int.toString}kg`}
          errorMessage={weightKg->Option.mapWithDefault(None, x =>
            x
            ->Js.String2.split(".")
            ->Garter_Array.first
            ->Option.flatMap(Int.fromString)
            ->Option.mapWithDefault(None, x =>
              x < minimumAmount
                ? Some(`최소 주문량은 ${minimumAmount->Int.toString}kg 입니다.`)
                : None
            )
          )}
          maxLength={6}
        />
      </DS_InputField.Line1.Root>
    </section>
  }
}

module Purpose = {
  type check = {
    id: string,
    name: string,
  }

  @react.component
  let make = (
    ~usage,
    ~setUsage,
    ~edges: array<RfqApplyBuyer_Query_graphql.Types.response_node_species_meatUsages_edges>,
  ) => {
    <section className=%twc("pt-7 pb-28")>
      <DS_Title.Normal1.Root>
        <DS_Title.Normal1.TextGroup title1={`사용용도를 알려주세요`} />
      </DS_Title.Normal1.Root>
      <div className=%twc("flex justify-end items-center px-5 mt-1.5")>
        <span className=%twc("text-[13px] text-enabled-L2")>
          {`중복 선택 가능`->React.string}
        </span>
      </div>
      <DS_ListItem.Normal1.Root className=%twc("mt-7 space-y-8 tab-highlight-color")>
        {edges
        ->Array.map(({node: {id, name}}) => {
          let isUnChecked = usage->Array.keep(x => x === id)->Garter.Array.isEmpty
          <DS_ListItem.Normal1.Item
            key={id}
            onClick={_ => {
              setUsage(.prev =>
                isUnChecked ? prev->Array.concat([id]) : prev->Array.keep(x => x != id)
              )
            }}>
            <DS_ListItem.Normal1.TextGroup title1={name} titleStyle=%twc("text-lg") />
            <DS_ListItem.Normal1.RightGroup>
              {isUnChecked
                ? <DS_Icon.Common.UncheckedLarge1 width="22" height="22" />
                : <DS_Icon.Common.CheckedLarge1 width="22" height="22" fill={"#12B564"} />}
            </DS_ListItem.Normal1.RightGroup>
          </DS_ListItem.Normal1.Item>
        })
        ->React.array}
      </DS_ListItem.Normal1.Root>
    </section>
  }
}

module StorageMethod = {
  module List = {
    @react.component
    let make = (~arr, ~handleOnChangeStorageMethod, ~storageMethod) => {
      arr
      ->Array.map(x => {
        let (name, value) = x
        let isSelected =
          storageMethod->Option.mapWithDefault(false, storageMethod' => storageMethod' === value)

        <DS_ListItem.Normal1.Item key={value} onClick={_ => handleOnChangeStorageMethod(value)}>
          <DS_ListItem.Normal1.TextGroup title1={name} />
          <DS_ListItem.Normal1.RightGroup>
            {isSelected
              ? <DS_Icon.Common.RadioOnLarge1 height="24" width="24" fill={"#12B564"} />
              : <DS_Icon.Common.RadioOffLarge1 height="24" width="24" fill={"#B2B2B2"} />}
          </DS_ListItem.Normal1.RightGroup>
        </DS_ListItem.Normal1.Item>
      })
      ->React.array
    }
  }
  @react.component
  let make = (~storageMethod, ~handleOnChangeStorageMethod) => {
    <section className=%twc("pt-7")>
      <DS_Title.Normal1.Root>
        <DS_Title.Normal1.TextGroup
          title1={`원하시는 보관상태를`} title2={`선택해주세요`}
        />
      </DS_Title.Normal1.Root>
      <DS_ListItem.Normal1.Root className=%twc("space-y-8 text-lg mt-11 tab-highlight-color")>
        <List
          arr={[(`냉동`, `FROZEN`), (`냉장`, `CHILLED`), (`동결`, `FREEZE_DRIED`)]}
          handleOnChangeStorageMethod
          storageMethod
        />
      </DS_ListItem.Normal1.Root>
    </section>
  }
}

module PackageMethod = {
  @react.component
  let make = (~packageMethod, ~handleOnChangePackageMethod) => {
    <section className=%twc("pt-7")>
      <DS_Title.Normal1.Root>
        <DS_Title.Normal1.TextGroup
          title1={`원하시는 포장상태를`} title2={`선택해주세요`}
        />
      </DS_Title.Normal1.Root>
      <DS_ListItem.Normal1.Root className=%twc("space-y-8 text-lg mt-9 tab-highlight-color")>
        <DS_ListItem.Normal1.Item
          onClick={_ => handleOnChangePackageMethod(packageMethod->Option.isNone ? "RAW" : "")}>
          <DS_ListItem.Normal1.TextGroup title1={`원료육(박스육)`} />
          <DS_ListItem.Normal1.RightGroup>
            {packageMethod->Option.mapWithDefault(
              <DS_Icon.Common.UncheckedLarge1 width="22" height="22" />,
              _ => <DS_Icon.Common.CheckedLarge1 width="22" height="22" fill={"#12B564"} />,
            )}
          </DS_ListItem.Normal1.RightGroup>
        </DS_ListItem.Normal1.Item>
      </DS_ListItem.Normal1.Root>
      <div className=%twc("absolute w-full bottom-[108px] px-5 flex justify-between")>
        <div className=%twc("leading-6 tracking-tight")>
          <h5> {`세절/분쇄가 필요한 경우,`->React.string} </h5>
          <h5> {`담당자에게 문의 부탁드립니다.`->React.string} </h5>
        </div>
        <DataGtm dataGtm={`Contact_RFQ_Livestock_PackageMethod`}>
          <button
            onClick={_ =>
              switch Global.window {
              | Some(window') =>
                Global.Window.openLink(
                  window',
                  ~url=`${Env.customerServiceUrl}${Env.customerServicePaths["rfqMeatProcess"]}`,
                  ~windowFeatures="",
                  (),
                )
              | None => ()
              }}
            className=%twc(
              "text-[15px] leading-6 tracking-tight font-bold rounded-lg px-3.5 py-3 border border-border-default-L1 bg-surface"
            )>
            {`문의하기`->React.string}
          </button>
        </DataGtm>
      </div>
    </section>
  }
}

module SupplyPrice = {
  @react.component
  let make = (
    ~prevTradeSellerName,
    ~handleOnChangePrevTradeSellerName,
    ~prevTradePricePerKg,
    ~handleOnChangePrevTradePricePerKg,
  ) => {
    <section className=%twc("pt-7")>
      <DS_Title.Normal1.Root>
        <DS_Title.Normal1.TextGroup title1={`기존 거래 단가를`} title2={`알려주세요`} />
      </DS_Title.Normal1.Root>
      <DS_InputField.Line1.Root className=%twc("mt-10")>
        <DS_InputField.Line1.Input
          type_="text"
          placeholder={`기존 거래 단가`}
          inputMode={"decimal"}
          value={prevTradePricePerKg->Option.getWithDefault(``)->numberToComma}
          onChange={e => {
            let value = (e->ReactEvent.Synthetic.target)["value"]
            handleOnChangePrevTradePricePerKg(value->convertNumberInputValue)
          }}
          unit={`원/kg`}
          isClear=true
          fnClear={_ => handleOnChangePrevTradePricePerKg("")}
          underLabelType=#won
          errorMessage={prevTradePricePerKg->Option.mapWithDefault(None, x =>
            x
            ->Js.String2.split(".")
            ->Garter_Array.first
            ->Option.flatMap(Int.fromString)
            ->Option.mapWithDefault(None, x =>
              x < 100 ? Some(`최소 거래 단가는 100원/kg 입니다.`) : None
            )
          )}
          maxLength={7}
        />
      </DS_InputField.Line1.Root>
      <DS_InputField.Line1.Root className=%twc("mt-5")>
        <DS_InputField.Line1.Input
          type_="text"
          placeholder={`기존 거래처명`}
          value={prevTradeSellerName->Option.getWithDefault(``)}
          onChange={e => {
            let value = (e->ReactEvent.Synthetic.target)["value"]
            handleOnChangePrevTradeSellerName(value)
          }}
          isClear=true
          fnClear={_ => handleOnChangePrevTradeSellerName("")}
          maxLength={30}
        />
      </DS_InputField.Line1.Root>
    </section>
  }
}

module Brand = {
  @react.component
  let make = (~preferredBrand, ~handleOnChangePreferredBrand) => {
    <section className=%twc("pt-7")>
      <DS_Title.Normal1.Root>
        <DS_Title.Normal1.TextGroup title1={`선호 브랜드를`} title2={`작성해주세요`} />
      </DS_Title.Normal1.Root>
      <DS_InputField.Line1.Root className=%twc("mt-4")>
        <DS_InputField.Line1.Input
          type_="text"
          placeholder={`예: Excel`}
          value={preferredBrand->Option.getWithDefault(``)}
          onChange={e => {
            let value = (e->ReactEvent.Synthetic.target)["value"]
            handleOnChangePreferredBrand(value)
          }}
          isClear=true
          fnClear={_ => handleOnChangePreferredBrand("")}
          maxLength=100
        />
      </DS_InputField.Line1.Root>
    </section>
  }
}

module Etc = {
  @react.component
  let make = (~etc, ~handleOnChangeEtc) => {
    <section className=%twc("pt-7")>
      <DS_Title.Normal1.Root>
        <DS_Title.Normal1.TextGroup title1={`기타 요청사항을`} title2={`남겨주세요`} />
      </DS_Title.Normal1.Root>
      <div className=%twc("px-5")>
        <DS_Input.InputText1
          type_="text"
          className=%twc("mt-7")
          placeholder={`예: 무항생제 찾습니다`}
          autoFocus=true
          value={etc->Option.getWithDefault(``)}
          onChange={e => {
            let value = (e->ReactEvent.Synthetic.target)["value"]
            handleOnChangeEtc(value)
          }}
          maxLength=300
        />
      </div>
    </section>
  }
}
