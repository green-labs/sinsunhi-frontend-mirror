/*
 * 1. 컴포넌트 위치
 *    PDP의 매칭상품 등급 정보
 *
 * 2. 역할
 *    매칭 상품의 등급 정보를 표현합니다
 *
 */

module Fragment = %relay(`
  fragment PDPMatchingGradeGuideBuyer_fragment on MatchingProduct {
    qualityStandard {
      high {
        color
        description
        fault
        foreignMatter
        freshness
        length
        perRegularity
        perSize
        shape
        sugar
        trimming
      }
      medium {
        color
        description
        fault
        foreignMatter
        freshness
        length
        perRegularity
        perSize
        shape
        sugar
        trimming
      }
      low {
        color
        description
        fault
        foreignMatter
        freshness
        length
        perRegularity
        perSize
        shape
        sugar
        trimming
      }
    }
  }
`)

module Banner = {
  @react.component
  let make = () => {
    <section className=%twc("w-full")>
      <div className=%twc("w-full bg-[#F4F9F9] px-4 pt-10 pb-16 ")>
        <div className=%twc("text-[26px] font-bold text-gray-800")>
          <h1>
            <span className=%twc("text-primary")> {`신선하이`->React.string} </span>
            {` 등급으로`->React.string}
          </h1>
          <h1> {`필요한 정보를 한눈에`->React.string} </h1>
        </div>
        <div className=%twc("mt-3")>
          <span className=%twc("text-gray-800 text-sm")>
            {`고객의 구매 목적을 고려한 신선하이 등급을 통해\n상품의 품질별 시세의 흐름을 한눈에 파악할 수 있습니다.`->ReactNl2br.nl2br}
          </span>
        </div>
      </div>
    </section>
  }
}

module Tab = {
  @react.component
  let make = (~label, ~value, ~isSelected) => {
    let btnStyle = isSelected
      ? %twc(
          "text-gray-800 border-b-[2px] border-gray-800 font-bold pt-2 pb-3 whitespace-nowrap flex flex-1 items-center justify-center"
        )
      : %twc(
          "text-gray-400 border-b-[2px] border-transparent pt-2 pb-3 whitespace-nowrap flex flex-1 items-center justify-center"
        )

    <RadixUI.Tabs.Trigger className=btnStyle value>
      <span> {label->React.string} </span>
    </RadixUI.Tabs.Trigger>
  }
}

module Content = {
  @react.component
  let make = (
    ~value,
    ~description,
    ~sugar,
    ~perSize,
    ~perRegularity,
    ~color,
    ~freshness,
    ~fault,
    ~length,
    ~foreignMatter,
    ~shape,
    ~trimming,
  ) => {
    <RadixUI.Tabs.Content value>
      <section className=%twc("w-full px-4 py-8")>
        <span className=%twc("text-base text-black")> {description->React.string} </span>
      </section>
      <section className=%twc("px-4")> <Divider className=%twc("h-[2px] bg-gray-100") /> </section>
      <section className=%twc("w-full px-4 divide-y divide-dashed pb-14")>
        {sugar->Option.mapWithDefault(React.null, sugar' => {
          <div className=%twc("w-full flex py-4")>
            <div className=%twc("w-16")> {`당도`->React.string} </div>
            <div className=%twc("ml-5 w-full")> {sugar'->ReactNl2br.nl2br} </div>
          </div>
        })}
        {perSize->Option.mapWithDefault(React.null, perSize' => {
          <div className=%twc("w-full flex py-4")>
            <div className=%twc("w-16")> {`낱개 크기`->React.string} </div>
            <div className=%twc("ml-5 w-full")> {perSize'->ReactNl2br.nl2br} </div>
          </div>
        })}
        {perRegularity->Option.mapWithDefault(React.null, perRegularity' => {
          <div className=%twc("w-full flex py-4")>
            <div className=%twc("w-16")> {`낱개 고르기`->React.string} </div>
            <div className=%twc("ml-5 w-full")> {perRegularity'->ReactNl2br.nl2br} </div>
          </div>
        })}
        {length->Option.mapWithDefault(React.null, length' => {
          <div className=%twc("w-full flex py-4")>
            <div className=%twc("w-16")> {`길이`->React.string} </div>
            <div className=%twc("ml-5 w-full")> {length'->ReactNl2br.nl2br} </div>
          </div>
        })}
        {shape->Option.mapWithDefault(React.null, shape' => {
          <div className=%twc("w-full flex py-4")>
            <div className=%twc("w-16")> {`모양`->React.string} </div>
            <div className=%twc("ml-5 w-full")> {shape'->ReactNl2br.nl2br} </div>
          </div>
        })}
        {trimming->Option.mapWithDefault(React.null, trimming' => {
          <div className=%twc("w-full flex py-4")>
            <div className=%twc("w-16")> {`손질`->React.string} </div>
            <div className=%twc("ml-5 w-full")> {trimming'->ReactNl2br.nl2br} </div>
          </div>
        })}
        {color->Option.mapWithDefault(React.null, color' => {
          <div className=%twc("w-full flex py-4")>
            <div className=%twc("w-16")> {`색택`->React.string} </div>
            <div className=%twc("ml-5 w-full")> {color'->ReactNl2br.nl2br} </div>
          </div>
        })}
        {freshness->Option.mapWithDefault(React.null, freshness' => {
          <div className=%twc("w-full flex py-4")>
            <div className=%twc("w-16")> {`신선도`->React.string} </div>
            <div className=%twc("ml-5 w-full")> {freshness'->ReactNl2br.nl2br} </div>
          </div>
        })}
        {fault->Option.mapWithDefault(React.null, fault' => {
          <div className=%twc("w-full flex py-4")>
            <div className=%twc("w-16")> {`결점`->React.string} </div>
            <div className=%twc("ml-5 w-full")> {fault'->ReactNl2br.nl2br} </div>
          </div>
        })}
        {foreignMatter->Option.mapWithDefault(React.null, foreignMatter' => {
          <div className=%twc("w-full flex py-4")>
            <div className=%twc("w-16")> {`이물`->React.string} </div>
            <div className=%twc("ml-5 w-full")> {foreignMatter'->ReactNl2br.nl2br} </div>
          </div>
        })}
      </section>
    </RadixUI.Tabs.Content>
  }
}

module Divider = {
  @react.component
  let make = (~className=?) => <RadixUI.Separator.Root ?className />
}

@react.component
let make = (~query) => {
  let {qualityStandard: {high, medium, low}} = query->Fragment.use

  let (selectedTab, setSelectedTab) = React.Uncurried.useState(_ => "high")

  <>
    <Banner />
    <RadixUI.Tabs.Root
      defaultValue="high" onValueChange={selected => setSelectedTab(._ => selected)}>
      <RadixUI.Tabs.List className=%twc("mt-6 w-full h-11 flex items-center justify-between px-4")>
        <Tab label=`가격 상위 그룹` value="high" isSelected={selectedTab == "high"} />
        <Tab label=`가격 중위 그룹` value="medium" isSelected={selectedTab == "medium"} />
        <Tab label=`가격 하위 그룹` value="low" isSelected={selectedTab == "low"} />
      </RadixUI.Tabs.List>
      <Divider className=%twc("h-[1px] bg-gray-50 m-0") />
      <Content
        value="high"
        description=high.description
        sugar=high.sugar
        perSize=high.perSize
        perRegularity=high.perRegularity
        color=high.color
        freshness=high.freshness
        fault=high.fault
        length=high.length
        foreignMatter=high.foreignMatter
        shape=high.shape
        trimming=high.trimming
      />
      <Content
        value="medium"
        description=medium.description
        sugar=medium.sugar
        perSize=medium.perSize
        perRegularity=medium.perRegularity
        color=medium.color
        freshness=medium.freshness
        fault=medium.fault
        length=medium.length
        foreignMatter=medium.foreignMatter
        shape=medium.shape
        trimming=medium.trimming
      />
      <Content
        value="low"
        description=low.description
        sugar=low.sugar
        perSize=low.perSize
        perRegularity=low.perRegularity
        color=low.color
        freshness=low.freshness
        fault=low.fault
        length=low.length
        foreignMatter=low.foreignMatter
        shape=low.shape
        trimming=low.trimming
      />
    </RadixUI.Tabs.Root>
  </>
}
