module Fragment = %relay(`
  fragment BulkSaleProducerAdminFragment_bulkSaleApplication on BulkSaleApplication
  @refetchable(queryName: "BulkSaleProducerAdminRefetchQuery")
  @argumentDefinitions(
    orderBy: { type: "BulkSaleEvaluationOrderBy", defaultValue: ID }
    orderDirection: { type: "OrderDirection", defaultValue: DESC }
  ) {
    id
    appliedAt
    progress
    memo
    applicantName
    productCategory {
      name
      crop {
        name
      }
    }
    bulkSaleCampaign {
      id
      productCategory {
        name
        crop {
          name
        }
      }
      estimatedPurchasePriceMin
      estimatedPurchasePriceMax
      estimatedSellerEarningRate
      preferredGrade
      preferredQuantity {
        display
        amount
        unit
      }
    }
    bulkSaleEvaluations(orderBy: $orderBy, orderDirection: $orderDirection) {
      count
      edges {
        cursor
        node {
          id
          reason
        }
      }
    }
    bulkSaleAnnualProductSalesInfo {
      count
      edges {
        cursor
        node {
          id
          averageAnnualSales
        }
      }
    }
    userBusinessSupportInfo {
      experiencedYearsRange
    }
    farmmorningUser {
      id
      name
      phoneNumber
      userBusinessRegistrationInfo {
        id
        name
        businessRegistrationNumber
        businessType
      }
      isDeleted
    }
    farm {
      address
      addressDetail
      zipCode
    }
    staff {
      id
      name
      emailAddress
    }
    staffKey
    isTest
    ...BulkSaleProducerSampleReviewButtonAdminFragment
    ...BulkSaleMarketSalesInfoButtonAdminFragment
    ...BulkSaleRawProductSaleLedgersAdminFragment
    ...BulkSaleProductSaleLedgersButtonAdminFragment
    ...BulkSaleProducerOnlineMarketInfoAdminFragment
  }
`)

let formatDate = d => d->Js.Date.fromString->DateFns.format("yyyy/MM/dd HH:mm")

let displayExperiencedYearRange = (
  s: BulkSaleProducerAdminFragment_bulkSaleApplication_graphql.Types.enum_ExperienceYearsRange,
) =>
  switch s {
  | #NEWCOMER => `경력없음`
  | #FROM_0_TO_1 => `1년 미만`
  | #FROM_1_TO_5 => `1~5년 미만`
  | #FROM_5_TO_10 => `5~10년 미만`
  | #FROM_10_TO_20 => `10~20년 미만`
  | #FROM_20_TO_INF => `20년 이상`
  | _ => `-`
  }
let displayAnnualProductSalesInfo = (
  s: BulkSaleProducerAdminFragment_bulkSaleApplication_graphql.Types.enum_AverageAnnualSalesRange,
) =>
  switch s {
  | #FROM_0_TO_30M => `3천만원 미만`
  | #FROM_30M_TO_100M => `3,000만원~1억원 미만`
  | #FROM_100M_TO_300M => `1~3억원 미만`
  | #FROM_300M_TO_500M => `3~5억원 미만`
  | #FROM_500M_TO_INF => `5억원 이상`

  | _ => `-`
  }
let displayBusinessType = (
  s: BulkSaleProducerAdminFragment_bulkSaleApplication_graphql.Types.enum_IndividualOrCompany,
) =>
  switch s {
  | #INDIVIDUAL => `개인`
  | #COMPANY => `법인`
  | _ => `-`
  }

let getEmailId = x => x->Js.String2.split("@")->Garter_Array.firstExn

module Item = {
  module Table = {
    @react.component
    let make = (
      ~node: BulkSaleProducersListAdminFragment_graphql.Types.fragment_bulkSaleApplications_edges_node,
      ~refetchSummary,
    ) => {
      let application = Fragment.use(node.fragmentRefs)

      <li className=%twc("grid grid-cols-11-admin-bulk-sale-producers")>
        <div className=%twc("h-full flex flex-col justify-center px-4 py-2")>
          {application.appliedAt->formatDate->React.string}
        </div>
        <div className=%twc("h-full flex flex-col justify-center px-4 py-2")>
          <Select_BulkSale_Application_Status application refetchSummary />
        </div>
        <div className=%twc("h-full flex flex-col justify-center px-4 py-2 relative")>
          {application.staff
          ->Option.mapWithDefault("", x => x.name ++ `( ` ++ x.emailAddress->getEmailId ++ ` )`)
          ->React.string}
          <div className=%twc("absolute w-[180px] left-0")>
            <Select_BulkSale_Search.Staff
              key={application.id}
              applicationId={application.id}
              staffInfo={switch application.staff {
              | Some(staff') =>
                ReactSelect.Selected({
                  value: staff'.id,
                  label: staff'.name ++ `( ` ++ staff'.emailAddress->getEmailId ++ ` )`,
                })
              | None => ReactSelect.NotSelected
              }}
            />
          </div>
        </div>
        <div className=%twc("h-full flex flex-col justify-center px-4 py-2")>
          <p className=%twc("mb-2")>
            {switch application.bulkSaleCampaign {
            | Some(campaign) =>
              `${campaign.productCategory.crop.name} > ${campaign.productCategory.name}`->React.string
            | None =>
              `${application.productCategory.crop.name} > ${application.productCategory.name}`->React.string
            }}
          </p>
          <BulkSale_Producer_Sample_Review_Button_Admin
            applicationId={application.id} sampleReview=application.fragmentRefs
          />
        </div>
        <div className=%twc("h-full flex flex-col justify-center px-4 py-2")>
          <p>
            {switch application.bulkSaleCampaign {
            | Some(campaign) =>
              j`${campaign.estimatedPurchasePriceMin->Locale.Float.show(
                  ~digits=0,
                )}원~${campaign.estimatedPurchasePriceMax->Locale.Float.show(
                  ~digits=0,
                )}원`->React.string
            | None => React.null
            }}
            <span className=%twc("text-text-L2")>
              {application.bulkSaleCampaign->Option.mapWithDefault(React.null, campaign =>
                j`(${campaign.preferredGrade},${campaign.preferredQuantity.display})`->React.string
              )}
            </span>
          </p>
          <p>
            {application.bulkSaleCampaign->Option.mapWithDefault(React.null, campaign =>
              j`수익률 ${campaign.estimatedSellerEarningRate->Float.toString}%`->React.string
            )}
          </p>
        </div>
        <div className=%twc("h-full flex flex-col justify-center px-4 py-2")>
          <div className=%twc("flex")>
            <p>
              {if application.applicantName == "" {
                `사용자: ${application.farmmorningUser.name}`->React.string
              } else {
                `사용자: ${application.applicantName}`->React.string
              }}
            </p>
            {switch application.farmmorningUser.isDeleted {
            | true =>
              <span className=%twc("ml-2 py-0.5 px-1.5 text-xs bg-red-100 text-notice rounded")>
                {`탈퇴`->React.string}
              </span>
            | false => React.null
            }}
          </div>
          <p>
            {if application.farmmorningUser.userBusinessRegistrationInfo.name == "" {
              React.null
            } else {
              `사업자: ${application.farmmorningUser.userBusinessRegistrationInfo.name}`->React.string
            }}
          </p>
          <p>
            {`(${application.farmmorningUser.phoneNumber
              ->Helper.PhoneNumber.parse
              ->Option.flatMap(Helper.PhoneNumber.format)
              ->Option.getWithDefault(application.farmmorningUser.phoneNumber)})`->React.string}
          </p>
          <p className=%twc("text-text-L3")>
            {Helper.Option.map2(application.farm.address, application.farm.addressDetail, (
              address,
              addressDetail,
            ) => address ++ " " ++ addressDetail)
            ->Option.getWithDefault(`주소 없음`)
            ->React.string}
          </p>
          <p className=%twc("text-text-L3")>
            {switch application.farm.zipCode {
            | Some(zipCode) => `우)${zipCode}`
            | None => `(우편번호 없음)`
            }->React.string}
          </p>
        </div>
        <div className=%twc("h-full flex flex-col justify-center px-4 py-2")>
          <p>
            {j`농사경력 ${application.userBusinessSupportInfo.experiencedYearsRange->Option.mapWithDefault(
                `-`,
                displayExperiencedYearRange,
              )}`->React.string}
          </p>
          <p>
            {application.bulkSaleAnnualProductSalesInfo.edges
            ->Array.map(edge =>
              `연평균 ${edge.node.averageAnnualSales->displayAnnualProductSalesInfo}`->React.string
            )
            ->React.array}
          </p>
        </div>
        <div className=%twc("h-full flex flex-col justify-center px-4 py-2")>
          <p>
            {application.farmmorningUser.userBusinessRegistrationInfo.businessRegistrationNumber->React.string}
          </p>
          <p>
            {application.farmmorningUser.userBusinessRegistrationInfo.businessType
            ->displayBusinessType
            ->React.string}
          </p>
        </div>
        <div className=%twc("h-full flex flex-col justify-center px-4 py-2")>
          <BulkSale_Producer_MarketSales_Admin
            farmmorningUserId=application.farmmorningUser.id
            applicationId={application.id}
            query=application.fragmentRefs
          />
        </div>
        <div className=%twc("h-full flex flex-col justify-center px-4 py-2")>
          <BulkSale_Producer_OnlineMarketInfo_Admin
            applicationId={application.id} query=application.fragmentRefs
          />
        </div>
        <div className=%twc("h-full flex flex-row justify-between px-4 py-3")>
          <p className=%twc("h-[105px] pr-4 text-ellipsis line-clamp-5")>
            {application.memo->React.string}
          </p>
          <BulkSale_Producer_Memo_Update_Button
            applicationId={application.id} memoData={application.memo}
          />
        </div>
      </li>
    }

    module Loading = {
      open Skeleton

      @react.component
      let make = () => {
        <li className=%twc("grid grid-cols-7-admin-bulk-sale-product")>
          <div className=%twc("h-full flex flex-col px-4 py-2")> <Checkbox /> </div>
          <div className=%twc("h-full flex flex-col px-4 py-2")>
            <Box className=%twc("w-20") /> <Box /> <Box className=%twc("w-12") />
          </div>
          <div className=%twc("h-full flex flex-col px-4 py-2")> <Box /> <Box /> </div>
          <div className=%twc("h-full flex flex-col px-4 py-2")>
            <Box /> <Box className=%twc("w-2/3") /> <Box className=%twc("w-8") />
          </div>
          <div className=%twc("h-full flex flex-col px-4 py-2")> <Box /> </div>
          <div className=%twc("h-full flex flex-col px-4 py-2")> <Box /> </div>
          <div className=%twc("h-full flex flex-col px-4 py-2")> <Box /> <Box /> </div>
        </li>
      }
    }
  }
}

@react.component
let make = (
  ~node: BulkSaleProducersListAdminFragment_graphql.Types.fragment_bulkSaleApplications_edges_node,
  ~refetchSummary,
) => {
  <Item.Table node refetchSummary />
}
