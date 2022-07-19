/*
 * 1. 컴포넌트 위치
 *    PDP의 매칭상품 등급 셀렉터
 *
 * 2. 역할
 *    매칭 상품의 등급 셀렉터를 제공합니다.
 *
 */

module Fragment = %relay(`
  fragment PDPMatchingSelectGradeBuyer_fragment on MatchingProduct {
    representativeWeight
  
    qualityStandard {
      high {
        description
      }
      medium {
        description
      }
      low {
        description
      }
    }
  
    recentMarketPrice {
      high {
        mean
      }
      medium {
        mean
      }
      low {
        mean
      }
    }
  }
`)

module Item = {
  @react.component
  let make = (~itemId, ~value, ~label, ~description, ~price, ~representativeWeight) => {
    let priceLabel = {
      price->Option.mapWithDefault("", price' => {
        `${(price'->Int.toFloat *. representativeWeight)
            ->Locale.Float.show(~digits=0)}원(${representativeWeight->Float.toString}kg당)`
      })
    }

    <div className=%twc("py-4 flex justify-between items-center")>
      <label htmlFor=itemId className=%twc("w-full flex flex-col")>
        <span className=%twc("text-gray-800 font-bold")> {label->React.string} </span>
        <span className=%twc("text-gray-600 text-sm")> {description->React.string} </span>
        <span className=%twc("text-primary text-base")> {priceLabel->React.string} </span>
      </label>
      <RadixUI.RadioGroup.Item id=itemId value className=%twc("radio-item")>
        <RadixUI.RadioGroup.Indicator className=%twc("radio-indicator") />
      </RadixUI.RadioGroup.Item>
    </div>
  }
}

module RadioSelector = {
  @react.component
  let make = (~query, ~selectedGroup, ~setSelectedGroup) => {
    let {qualityStandard, recentMarketPrice, representativeWeight} = query->Fragment.use

    switch recentMarketPrice {
    | None => React.null

    | Some(recentMarketPrice') =>
      <RadixUI.RadioGroup.Root
        className=%twc("flex flex-col")
        name="grade-select"
        value=selectedGroup
        onValueChange={value => setSelectedGroup(._ => value)}>
        // 상위
        <Item
          itemId="price-group-high"
          value="high"
          label=`가격 상위 그룹`
          description=qualityStandard.high.description
          price=recentMarketPrice'.high.mean
          representativeWeight
        />
        // 중위
        <Item
          itemId="price-group-medium"
          value="medium"
          label=`가격 중위 그룹`
          description=qualityStandard.medium.description
          price=recentMarketPrice'.medium.mean
          representativeWeight
        />
        // 하위
        <Item
          itemId="price-group-low"
          value="low"
          label=`가격 하위 그룹`
          description=qualityStandard.low.description
          price=recentMarketPrice'.low.mean
          representativeWeight
        />
      </RadixUI.RadioGroup.Root>
    }
  }
}

module BottomSheet = {
  @react.component
  let make = (~show, ~onClose, ~setShowModal, ~query, ~selectedGroup, ~setSelectedGroup) => {
    <DS_BottomDrawer.Root isShow=show onClose>
      <section className=%twc("w-full h-16 px-3 flex items-center")>
        <button
          className=%twc("w-10 h-10 flex items-center justify-center")
          onClick={_ => setShowModal(._ => PDP_Matching_Modals_Buyer.Show(GradeGuide))}>
          <img src="/icons/question-gray-circle.svg" className=%twc("w-6 h-6 object-contain") />
        </button>
        <div
          className=%twc("flex flex-1 items-center justify-center text-base text-black font-bold")>
          {`가격대 선택`->React.string}
        </div>
        <button
          onClick={_ => onClose()} className=%twc("w-10 h-10 flex items-center justify-center")>
          <IconClose width="24" height="24" fill="#000" />
        </button>
      </section>
      <DS_BottomDrawer.Body>
        <section className=%twc("px-4")>
          <RadioSelector query selectedGroup setSelectedGroup />
        </section>
        <section className=%twc("px-4 py-5")>
          <button
            onClick={_ => onClose()}
            className=%twc("w-full h-14 rounded-xl bg-primary text-white font-bold text-base")>
            {`선택`->React.string}
          </button>
        </section>
      </DS_BottomDrawer.Body>
    </DS_BottomDrawer.Root>
  }
}

@react.component
let make = (~setShowModal, ~query, ~selectedGroup, ~setSelectedGroup) => {
  let user = CustomHooks.User.Buyer.use2()

  let (showBottmSheet, setShowBottomSheet) = React.Uncurried.useState(_ => false)

  <>
    {switch user {
    | Unknown =>
      <button
        disabled=true
        className=%twc(
          "w-full h-12 px-4 border border-gray-250 rounded-xl flex items-center justify-between text-base text-black"
        )>
        {`가격 상위 그룹`->React.string}
        <IconArrowSelect width="24" height="24" fill="#262626" />
      </button>

    | NotLoggedIn =>
      <button
        onClick={_ =>
          setShowModal(._ => PDP_Matching_Modals_Buyer.Show(
            Unauthorized(`로그인 후에\n견적을 받으실 수 있습니다.`),
          ))}
        className=%twc(
          "w-full h-12 px-4 border border-gray-250 rounded-xl flex items-center justify-between text-base text-black"
        )>
        {`가격 상위 그룹`->React.string}
        <IconArrowSelect width="24" height="24" fill="#262626" />
      </button>

    | LoggedIn(_) =>
      let label = switch selectedGroup {
      | "high" => `가격 상위 그룹`
      | "medium" => `가격 중위 그룹`
      | "low" => `가격 하위 그룹`
      | _ => ""
      }

      <>
        <button
          onClick={_ => setShowBottomSheet(._ => true)}
          className=%twc(
            "w-full h-12 px-4 border border-gray-250 rounded-xl flex items-center justify-between text-base text-black"
          )>
          {label->React.string} <IconArrowSelect width="24" height="24" fill="#262626" />
        </button>
        <BottomSheet
          show=showBottmSheet
          onClose={_ => setShowBottomSheet(._ => false)}
          setShowModal
          query
          selectedGroup
          setSelectedGroup
        />
      </>
    }}
  </>
}
