/*
1. 컴포넌트 위치
  어드민 센터 - 전량 구매 - 생산자 소싱 관리 - (리스트) 온라인 유통 정보 입력 버튼
2. 역할
  어드민이 전량 구매 신청한 생산자의 온라인 유통 정보를 업데이트합니다. 신청 시 입력 받은 유통정보와는 별개의 정보 입니다.
*/
open RadixUI
module Util = BulkSale_Producer_OnlineMarketInfo_Button_Util

module Mutation = %relay(`
  mutation BulkSaleProducerOnlineMarketInfoButtonUpdateAdminMutation(
    $id: ID!
    $input: BulkSaleOnlineSalesInfoUpdateInput!
    $connections: [ID!]!
  ) {
    updateBulkSaleOnlineSalesInfo(id: $id, input: $input) {
      result
        @prependNode(
          connections: $connections
          edgeTypeName: "BulkSaleOnlineMarketSalesEdge"
        ) {
        id
        market
        deliveryCompany {
          id
          code
          name
          isAvailable
        }
        url
        numberOfComments
        averageReviewScore
        createdAt
        updatedAt
      }
    }
  }
`)

let makeInput = (
  market,
  deliveryCompanyId,
  url,
  averageReviewScore,
  numberOfComments,
): BulkSaleProducerOnlineMarketInfoButtonUpdateAdminMutation_graphql.Types.bulkSaleOnlineSalesInfoUpdateInput => {
  market: market,
  deliveryCompanyId: deliveryCompanyId,
  url: url,
  averageReviewScore: averageReviewScore,
  numberOfComments: numberOfComments,
}

module Form = {
  @react.component
  let make = (
    ~connectionId,
    ~selectedMarket,
    ~market: BulkSaleProducerOnlineMarketInfoAdminFragment_graphql.Types.fragment_bulkSaleOnlineSalesInfo_edges,
  ) => {
    let {addToast} = ReactToastNotifications.useToasts()
    let (mutate, isMutating) = Mutation.use()

    let (deliveryCompanyId, setDeliveryCompanyId) = React.Uncurried.useState(_ =>
      market.node.deliveryCompany->Option.map(dc => dc.id)
    )
    let (url, setUrl) = React.Uncurried.useState(_ => Some(market.node.url))
    let (averageReviewScore, setAverageReviewScore) = React.Uncurried.useState(_ => Some(
      market.node.averageReviewScore->Float.toString,
    ))
    let (numberOfComments, setNumberOfComments) = React.Uncurried.useState(_ => Some(
      market.node.numberOfComments->Int.toString,
    ))

    let (formErrors, setFormErrors) = React.Uncurried.useState(_ => [])

    let handleOnChange = (setFn, e) => {
      let value = (e->ReactEvent.Synthetic.target)["value"]
      setFn(._ => value)
    }

    // 수정 폼 컴포넌트는 화면에 한 번 렌더링 된 후 그대로 있는 상태에서 유통 경로 버튼을 클릭하여 선택할 때마다,
    // 폼 데이터 값이 기존에 저장되어있는 유통 경로 별 정보가 상태값에 업데이트 되어야 해서 useEffect 사용
    React.useEffect1(_ => {
      setDeliveryCompanyId(._ => market.node.deliveryCompany->Option.map(dc => dc.id))
      setUrl(._ => Some(market.node.url))
      setAverageReviewScore(._ => Some(market.node.averageReviewScore->Float.toString))
      setNumberOfComments(._ => Some(market.node.numberOfComments->Int.toString))

      None
    }, [market])

    let close = () => {
      open Webapi
      let buttonClose = Dom.document->Dom.Document.getElementById("btn-close")
      buttonClose
      ->Option.flatMap(buttonClose' => {
        buttonClose' |> Dom.Element.asHtmlElement
      })
      ->Option.forEach(buttonClose' => {
        buttonClose' |> Dom.HtmlElement.click
      })
      ->ignore
    }

    let handleOnSave = () => {
      open Util

      let input =
        makeInput
        ->V.map(V.pure(selectedMarket->Option.flatMap(convertOnlineMarket)))
        ->V.ap(
          V.Option.nonEmpty(
            #ErrorDeliveryCompanyId(`택배사를 선택해야 합니다.`),
            deliveryCompanyId,
          ),
        )
        ->V.ap(V.pure(url))
        ->V.ap(V.pure(averageReviewScore->Option.flatMap(Float.fromString)))
        ->V.ap(V.pure(numberOfComments->Option.flatMap(Int.fromString)))
      switch input {
      | Ok(input') =>
        mutate(
          ~variables={
            id: market.node.id,
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
              close()
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
      | Error(errors) => setFormErrors(._ => errors)
      }
    }

    <section className=%twc("pb-5")>
      <Select_Delivery_Company
        label=`계약된 택배사`
        deliveryCompanyId
        onChange={handleOnChange(setDeliveryCompanyId)}
        error={formErrors
        ->Array.keepMap(error => {
          switch error {
          | #ErrorDeliveryCompanyId(msg) => Some(msg)
          | _ => None
          }
        })
        ->Garter.Array.first}
      />
      <article className=%twc("mt-5 px-5")>
        <h3> {j`판매했던 URL`->React.string} </h3>
        <div className=%twc("flex mt-2")>
          <Textarea
            type_="online-sale-urls"
            name="online-sale-urls"
            className=%twc("flex-1 mr-1")
            size=Textarea.Small
            placeholder=`URL 입력`
            value={url->Option.getWithDefault("")}
            onChange={handleOnChange(setUrl)}
            error=None
          />
        </div>
      </article>
      <section className=%twc("flex mt-5 px-5")>
        <article className=%twc("flex-1")>
          <h3> {j`평점`->React.string} </h3>
          <div className=%twc("flex mt-2")>
            <Input
              type_="online-sale-average-review-score"
              name="online-sale-average-review-score"
              className=%twc("flex-1 mr-1")
              size=Input.Small
              placeholder=`평점 입력`
              value={averageReviewScore->Option.getWithDefault("")}
              onChange={handleOnChange(setAverageReviewScore)}
              error=None
            />
          </div>
        </article>
        <article className=%twc("flex-1")>
          <h3> {j`댓글 수`->React.string} </h3>
          <div className=%twc("flex mt-2")>
            <Input
              type_="online-sale-average-review-score"
              name="online-sale-average-review-score"
              className=%twc("flex-1 mr-1")
              size=Input.Small
              placeholder=`댓글 수 입력`
              value={numberOfComments->Option.getWithDefault("")}
              onChange={handleOnChange(setNumberOfComments)}
              error=None
            />
          </div>
        </article>
      </section>
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
  }
}
