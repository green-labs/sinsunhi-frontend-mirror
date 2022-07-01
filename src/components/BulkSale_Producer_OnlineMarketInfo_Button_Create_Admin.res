/*
1. 컴포넌트 위치
  어드민 센터 - 전량 구매 - 생산자 소싱 관리 - (리스트) 온라인 유통 정보 입력 버튼
2. 역할
  어드민이 전량 구매 신청한 생산자의 온라인 유통 정보를 신규 생성합니다. 신청 시 입력 받은 유통정보와는 별개의 정보 입니다.
*/
open RadixUI
module Util = BulkSale_Producer_OnlineMarketInfo_Button_Util

module Mutation = %relay(`
  mutation BulkSaleProducerOnlineMarketInfoButtonCreateAdminMutation(
    $input: BulkSaleOnlineSalesInfoCreateInput!
    $connections: [ID!]!
  ) {
    createBulkSaleOnlineSalesInfo(input: $input) {
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
  applicationId,
  market,
  deliveryCompanyId,
  url,
  averageReviewScore,
  numberOfComments,
): BulkSaleProducerOnlineMarketInfoButtonCreateAdminMutation_graphql.Types.bulkSaleOnlineSalesInfoCreateInput => {
  bulkSaleApplicationId: applicationId,
  market: market,
  deliveryCompanyId: deliveryCompanyId,
  url: url,
  averageReviewScore: averageReviewScore,
  numberOfComments: numberOfComments,
}

module Form = {
  @react.component
  let make = (~connectionId, ~selectedMarket, ~applicationId) => {
    let {addToast} = ReactToastNotifications.useToasts()
    let (mutate, isMutating) = Mutation.use()

    let (deliveryCompanyId, setDeliveryCompanyId) = React.Uncurried.useState(_ => None)
    let (url, setUrl) = React.Uncurried.useState(_ => None)
    let (averageReviewScore, setAverageReviewScore) = React.Uncurried.useState(_ => None)
    let (numberOfComments, setNumberOfComments) = React.Uncurried.useState(_ => None)

    let (formErrors, setFormErrors) = React.Uncurried.useState(_ => [])

    let handleOnChange = (setFn, e) => {
      let value = (e->ReactEvent.Synthetic.target)["value"]
      setFn(._ => value)
    }

    let handleOnSave = () => {
      open Util

      let input =
        makeInput
        ->V.map(
          V.nonEmpty(
            #ErrorApplicationId(`어플리케이션 id 값이 필요합니다.`),
            applicationId,
          ),
        )
        // nonEmpty를 사용하는 것이 더 좋아보이지만, selectedMarket이 폴리배리이기 때문에 pure로 일단 처리
        ->V.ap(
          V.Option.pure(
            #ErrorMarket(`온라인 유통경로는 필수 선택 입니다.`),
            selectedMarket->Option.flatMap(convertOnlineMarket),
          ),
        )
        ->V.ap(
          V.Option.nonEmpty(
            #ErrorDeliveryCompanyId(`택배사는 필수 선택 입니다`),
            deliveryCompanyId,
          ),
        )
        ->V.ap(V.Option.nonEmpty(#ErrorUrl(`URL은 필수 입력 사항 입니다.`), url))
        ->V.ap(
          V.Option.float(
            #ErrorAverageReviewScore(`평점은 필수 입력 사항 입니다.`),
            averageReviewScore,
          ),
        )
        ->V.ap(
          V.Option.int(
            #ErrorNumberOfComments(`댓글 수는 필수 입력 사항 입니다.`),
            numberOfComments,
          ),
        )
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
                  {j`입력에 성공하였습니다.`->React.string}
                </div>,
                {appearance: "success"},
              )
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
        ->Array.keepMap(error =>
          switch error {
          | #ErrorDeliveryCompanyId(msg) => Some(msg)
          | _ => None
          }
        )
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
            error={formErrors
            ->Array.keepMap(error =>
              switch error {
              | #ErrorUrl(msg) => Some(msg)
              | _ => None
              }
            )
            ->Garter.Array.first}
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
              error={formErrors
              ->Array.keepMap(error => {
                switch error {
                | #ErrorAverageReviewScore(msg) => Some(msg)
                | _ => None
                }
              })
              ->Garter.Array.first}
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
              error={formErrors
              ->Array.keepMap(error =>
                switch error {
                | #ErrorNumberOfComments(msg) => Some(msg)
                | _ => None
                }
              )
              ->Garter.Array.first}
            />
          </div>
        </article>
      </section>
      <article className=%twc("flex justify-center items-center mt-5 px-5")>
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
