module Query = %relay(`
  query PDPBuyerQuery($id: ID!) {
    node(id: $id) {
      ...PDPBuyerFragment
    }
  }
`)

module Fragment = %relay(`
  fragment PDPBuyerFragment on Product {
    type_: type
    name
    image {
      thumb1920x1920
      thumb1000x1000
    }
    description
    ...PDPProductNormalBuyerFragment
    ...PDPProductQuotedBuyerFragment
    ...PDPSalesDocumentBuyerFragment
    ...PDPNoticeBuyerFragment
  }
`)

module PC = {
  @react.component
  let make = (~query, ~image: Fragment.Types.fragment_image, ~description, ~type_) => {
    <div className=%twc("w-[1280px] mx-auto min-h-full")>
      <div className=%twc("w-full pt-16 px-5 divide-y")>
        <section className=%twc("w-full flex pb-12 gap-20")>
          <div>
            <div className=%twc("relative w-[664px] aspect-square rounded-2xl overflow-hidden")>
              <Image
                src=image.thumb1920x1920
                placeholder=Image.Placeholder.lg
                className=%twc("w-full h-full object-cover")
                alt="product-detail-thumbnail"
              />
              <div
                className=%twc("w-full h-full absolute top-0 left-0 bg-black/[.03] rounded-2xl")
              />
            </div>
            <PDP_SalesDocument_Buyer.PC query />
          </div>
          {switch type_ {
          | #NORMAL
          | #QUOTABLE =>
            <PDP_Product_Normal_Buyer.PC query />
          | #QUOTED => <PDP_Product_Quoted_Buyer.PC query />
          | _ => React.null
          }}
        </section>
        <section className=%twc("pt-16")>
          <span className=%twc("text-2xl font-bold text-gray-800")>
            {`상세 설명`->React.string}
          </span>
          <PDP_Notice_Buyer.PC query />
          <div className=%twc("py-16")> <Editor.Viewer value={description} /> </div>
        </section>
        {switch type_ {
        | #NORMAL
        | #QUOTABLE =>
          <section className=%twc("w-full py-16 flex justify-center")>
            <div className=%twc("w-full max-w-[600px] aspect-[209/1361]")>
              <img
                src="https://public.sinsunhi.com/images/20220616/f15dcb82-7b3e-482d-a32a-ab56791617da/%E1%84%89%E1%85%A1%E1%86%BC%E1%84%89%E1%85%A6%20CS%E1%84%80%E1%85%A9%E1%86%BC%E1%84%90%E1%85%A9%E1%86%BC%E1%84%8B%E1%85%A7%E1%86%BC%E1%84%8B%E1%85%A7%E1%86%A8%20%E1%84%8E%E1%85%AC%E1%84%8E%E1%85%AC%E1%84%8C%E1%85%A9%E1%86%BC.jpg"
                className=%twc("w-full h-full object-cover")
                alt="pdp-delivery-guide-mo"
              />
            </div>
          </section>

        | _ => React.null
        }}
      </div>
    </div>
  }
}

module MO = {
  @react.component
  let make = (~query, ~image: Fragment.Types.fragment_image, ~description, ~type_) => {
    <div className=%twc("w-full")>
      <section className=%twc("flex flex-col gap-5")>
        <div className=%twc("w-full pt-[100%] relative overflow-hidden")>
          <Image
            src=image.thumb1000x1000
            placeholder=Image.Placeholder.lg
            className=%twc("absolute top-0 left-0 w-full h-full object-cover")
            alt="product-detail-thumbnail"
          />
          <div className=%twc("w-full h-full absolute top-0 left-0 bg-black/[.03]") />
        </div>
      </section>
      <section className=%twc("px-5 divide-y")>
        {switch type_ {
        | #NORMAL
        | #QUOTABLE =>
          <PDP_Product_Normal_Buyer.MO query />
        | #QUOTED => <PDP_Product_Quoted_Buyer.MO query />
        | _ => React.null
        }}
        <PDP_SalesDocument_Buyer.MO query />
        <div className=%twc("flex flex-col gap-5 py-8")>
          <h1 className=%twc("text-text-L1 text-base font-bold")>
            {`상세설명`->React.string}
          </h1>
          <PDP_Notice_Buyer.MO query />
          <div className=%twc("w-full overflow-x-scroll")>
            <Editor.Viewer value=description />
          </div>
        </div>
      </section>
      {switch type_ {
      | #NORMAL
      | #QUOTABLE =>
        <section className=%twc("px-5 py-8")>
          <div className=%twc("w-full aspect-[209/1361]")>
            <img
              src="https://public.sinsunhi.com/images/20220616/f15dcb82-7b3e-482d-a32a-ab56791617da/%E1%84%89%E1%85%A1%E1%86%BC%E1%84%89%E1%85%A6%20CS%E1%84%80%E1%85%A9%E1%86%BC%E1%84%90%E1%85%A9%E1%86%BC%E1%84%8B%E1%85%A7%E1%86%BC%E1%84%8B%E1%85%A7%E1%86%A8%20%E1%84%8E%E1%85%AC%E1%84%8E%E1%85%AC%E1%84%8C%E1%85%A9%E1%86%BC.jpg"
              className=%twc("w-full h-full object-cover")
              alt="pdp-delivery-guide-mo"
            />
          </div>
        </section>

      | _ => React.null
      }}
    </div>
  }
}

module Placeholder = {
  @react.component
  let make = () => {
    <Layout_Buyer.Responsive
      pc={<div className=%twc("w-[1280px] mx-auto min-h-full")>
        <div className=%twc("w-full pt-16 px-5")>
          <section className=%twc("w-full flex justify-between")>
            <div>
              <div className=%twc("w-[664px] aspect-square rounded-xl bg-gray-150 animate-pulse") />
              <div
                className=%twc("mt-12 w-[664px] h-[92px] rounded-xl bg-gray-150 animate-pulse")
              />
              <div className=%twc("mt-4 w-[563px] h-[23px] rounded-lg bg-gray-150 animate-pulse") />
            </div>
            <div>
              <div className=%twc("w-[496px] h-[44px] rounded-lg bg-gray-150 animate-pulse") />
              <div className=%twc("mt-4 w-[123px] h-[44px] rounded-lg bg-gray-150 animate-pulse") />
              <div className=%twc("mt-4 w-[496px] h-[56px] rounded-xl bg-gray-150 animate-pulse") />
              <div className=%twc("mt-4 w-[496px] rounded-xl border border-gray-200 px-6 py-8")>
                <div className=%twc("w-[80px] h-[26px] rounded-md bg-gray-150 animate-pulse") />
                <div className=%twc("mt-5 flex items-center justify-between")>
                  <div className=%twc("w-[88px] h-[24px] rounded-md bg-gray-150 animate-pulse") />
                  <div className=%twc("w-[68px] h-[24px] rounded-md bg-gray-150 animate-pulse") />
                </div>
                <div className=%twc("mt-1 flex items-center justify-between")>
                  <div className=%twc("w-[56px] h-[24px] rounded-md bg-gray-150 animate-pulse") />
                  <div className=%twc("w-[48px] h-[24px] rounded-md bg-gray-150 animate-pulse") />
                </div>
                <div className=%twc("mt-1 flex items-center justify-between")>
                  <div className=%twc("w-[72px] h-[24px] rounded-md bg-gray-150 animate-pulse") />
                  <div className=%twc("w-[56px] h-[24px] rounded-md bg-gray-150 animate-pulse") />
                </div>
                <div className=%twc("mt-1 flex items-center justify-between")>
                  <div className=%twc("w-[64px] h-[24px] rounded-md bg-gray-150 animate-pulse") />
                  <div className=%twc("w-[48px] h-[24px] rounded-md bg-gray-150 animate-pulse") />
                </div>
                <RadixUI.Separator.Root className=%twc("h-px bg-gray-100 my-4") />
                <div
                  className=%twc("mt-6 w-[40px] h-[24px] rounded-md bg-gray-150 animate-pulse")
                />
                <div
                  className=%twc("mt-4 w-[440px] h-[80px] rounded-md bg-gray-150 animate-pulse")
                />
                <div
                  className=%twc("mt-6 w-[40px] h-[24px] rounded-md bg-gray-150 animate-pulse")
                />
                <div
                  className=%twc("mt-4 w-[440px] h-[80px] rounded-md bg-gray-150 animate-pulse")
                />
                <div className=%twc("mt-12 flex items-center justify-between")>
                  <div className=%twc("w-[86px] h-[26px] rounded-md bg-gray-150 animate-pulse") />
                  <div className=%twc("w-[117px] h-[38px] rounded-md bg-gray-150 animate-pulse") />
                </div>
              </div>
            </div>
          </section>
          <RadixUI.Separator.Root className=%twc("h-px bg-gray-100 my-12") />
          <section>
            <div className=%twc("mt-4 w-[144px] h-[38px] rounded-md bg-gray-150 animate-pulse") />
            <div
              className=%twc("mt-14 w-[1240px] h-[176px] rounded-lg bg-gray-150 animate-pulse")
            />
            <div className=%twc("mt-14 flex flex-col items-center justify-center")>
              <div className=%twc("w-[640px] h-[44px] rounded-md bg-gray-150 animate-pulse") />
              <div
                className=%twc("mt-[10px] w-[440px] h-[24px] rounded-md bg-gray-150 animate-pulse")
              />
            </div>
            <div
              className=%twc("mt-14 w-[1240px] h-[640px] rounded-lg bg-gray-150 animate-pulse")
            />
          </section>
        </div>
      </div>}
      mobile={<div className=%twc("w-full")>
        <div className=%twc("w-full aspect-square bg-gray-150 animate-pulse") />
        <section className=%twc("px-5 flex flex-col gap-2")>
          <div className=%twc("w-full mt-5 bg-gray-150 rounded-lg animate-pulse") />
          <div className=%twc("w-20 h-6 bg-gray-150 rounded-lg animate-pulse") />
          <div className=%twc("w-full bg-gray-150 rounded-lg animate-pulse") />
          <div className=%twc("w-full bg-gray-150 rounded-lg animate-pulse") />
          <div className=%twc("w-full h-[100px] bg-gray-150 rounded-lg animate-pulse") />
        </section>
      </div>}
    />
  }
}

module NotFound = {
  @react.component
  let make = () => {
    <Layout_Buyer.Responsive
      pc={<div className=%twc("w-[1280px] px-5 py-16 mx-auto")>
        <div className=%twc("mt-14")>
          <div className=%twc("w-full flex items-center justify-center")>
            <span className=%twc("text-3xl text-gray-800")>
              {`상품이 존재하지 않습니다`->React.string}
            </span>
          </div>
          <div className=%twc("mt-7 w-full flex flex-col items-center justify-center")>
            <span className=%twc("text-gray-800")>
              {`상품 URL이 정확한지 확인해주세요.`->React.string}
            </span>
            <span className=%twc("text-gray-800")>
              {`상품이 없을 경우 다른 카테고리의 상품을 선택해주세요.`->React.string}
            </span>
          </div>
        </div>
      </div>}
      mobile={<div className=%twc("w-full px-5 pt-[126px]")>
        <div className=%twc("flex flex-col items-center text-base text-text-L2")>
          <span className=%twc("mb-2 text-xl text-text-L1")>
            {`상품이 존재하지 않습니다`->React.string}
          </span>
          <span> {`상품 URL이 정확한지 확인해주세요.`->React.string} </span>
          <span>
            {`상품이 없을 경우 다른 카테고리의 상품을 선택해주세요.`->React.string}
          </span>
        </div>
      </div>}
    />
  }
}

// PC, MO 컴포넌트에서 중복 호출될 수 있는 로직을 처리하는 공통 컴포넌트
module Common = {
  @react.component
  let make = (~id, ~query) => {
    let {name, image, description, fragmentRefs, type_} = query->Fragment.use

    ChannelTalkHelper.Hook.use(
      ~viewMode=ChannelTalkHelper.Hook.PcOnly,
      ~trackData={
        eventName: `최근 본 상품`,
        eventProperty: {"productId": id, "productName": name},
      },
      (),
    )

    <Layout_Buyer.Responsive
      pc={<PC query=fragmentRefs image description type_ />}
      mobile={<MO query=fragmentRefs image description type_ />}
    />
  }
}

module Container = {
  @react.component
  let make = (~nodeId) => {
    let {node} = Query.use(~variables={id: nodeId}, ~fetchPolicy=RescriptRelay.StoreAndNetwork, ())

    switch node {
    | None => <NotFound />
    | Some({fragmentRefs}) => <Common id=nodeId query=fragmentRefs />
    }
  }
}

@react.component
let make = () => {
  let router = Next.Router.useRouter()
  let pid = router.query->Js.Dict.get("pid")

  <>
    <Next.Head> <title> {`신선하이`->React.string} </title> </Next.Head>
    <RescriptReactErrorBoundary fallback={_ => <NotFound />}>
      <React.Suspense fallback={<Placeholder />}>
        {switch pid {
        | Some(nodeId) => <Container nodeId />
        | None => <Placeholder />
        }}
      </React.Suspense>
    </RescriptReactErrorBoundary>
  </>
}
