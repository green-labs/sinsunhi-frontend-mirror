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
    bulkSaleProducerDetail {
      id
      hasOnlineExperience
      experienceYearType
      handsOn
      name
      phoneNumber
      producerComment
    }
    userPccProduction {
      id
      grade
      images
      certificates
      facilityType
    }
    userPccSalesCondition {
      id
      canDeliver
      deliveryWeightUnit
      deliveryDailyCapacity
      deliveryPackages
      supplyFrequency
      averageAnnualSales
      supplyBegin {
        dayOfMonth
        month
      }
      supplyEnd {
        dayOfMonth
        month
      }
    }
    staffKey
    isTest
    ...BulkSaleProducerSampleReviewButtonAdminFragment
    ...BulkSaleMarketSalesInfoButtonAdminFragment
  }
`)

let formatDate = d => d->Js.Date.fromString->DateFns.format("yyyy/MM/dd HH:mm")

let displayExperiencedYearRange = (s: int) =>
  switch s {
  | 0 => `????????????`
  | 1 => `1??? ??????`
  | 5 => `1~5???`
  | 10 => `5~10???`
  | 20 => `10~20???`
  | 40 => `~20?????????`
  | _ => ``
  }

let displayAnnualProductSalesInfo = (
  s: BulkSaleProducerAdminFragment_bulkSaleApplication_graphql.Types.enum_AverageAnnualSalesRange,
) =>
  switch s {
  | #FROM_0_TO_30M => `3????????? ??????`
  | #FROM_30M_TO_100M => `3,000??????~1?????? ??????`
  | #FROM_100M_TO_300M => `1~3?????? ??????`
  | #FROM_300M_TO_500M => `3~5?????? ??????`
  | #FROM_500M_TO_INF => `5?????? ??????`

  | _ => `-`
  }
let displayBusinessType = (
  s: BulkSaleProducerAdminFragment_bulkSaleApplication_graphql.Types.enum_IndividualOrCompany,
) =>
  switch s {
  | #INDIVIDUAL => `??????`
  | #COMPANY => `??????`
  | _ => `-`
  }

let displayFacilityType = facilityType =>
  switch facilityType {
  | #GLASS => `????????????`
  | #OPEN_FIELD => `??????`
  | #VINYL_HOUSE_FIELD => `???????????????(??????)`
  | #VINYL_HOUSE_SMART_FARM => `???????????????(????????????)`
  | _ => ""
  }

let displayCertificate = (
  certificate: BulkSaleProducerAdminFragment_bulkSaleApplication_graphql.Types.enum_ProductionCertificate,
) =>
  switch certificate {
  | #ECO_FRIENDLY => `?????????`
  | #GAP => "GAP"
  | #LOW_CARBON => `?????????`
  | _ => ""
  }

let displaySupplyFrequency = f => {
  switch f {
  | #DAILY => `??????`
  | #ONCE_A_WEEK => `??? 1~2???`
  | #THREE_TIMES_A_WEEK => `??? 3~5???`
  | #MONTHLY => `??? 1~2???`
  | _ => ``
  }
}

let displayDeliveryPackage = f => {
  switch f {
  | #TON_BAG => `??????`
  | #CONTI => `??????`
  | _ => ``
  }
}

let getEmailId = x => x->Js.String2.split("@")->Garter_Array.firstExn

let months = list{
  (1, `1???`),
  (2, `2???`),
  (3, `3???`),
  (4, `4???`),
  (5, `5???`),
  (6, `6???`),
  (7, `7???`),
  (8, `8???`),
  (9, `9???`),
  (10, `10???`),
  (11, `11???`),
  (12, `12???`),
}

let displaySupplyDays = d =>
  switch d {
  | #EARLY => `??????`
  | #MIDDLE => `??????`
  | #LATE => `??????`
  | _ => ``
  }

let displaySupplyBeginToEnd = (
  s1: BulkSaleProducerAdminFragment_bulkSaleApplication_graphql.Types.fragment_userPccSalesCondition_supplyBegin,
  s2: BulkSaleProducerAdminFragment_bulkSaleApplication_graphql.Types.fragment_userPccSalesCondition_supplyEnd,
) => {
  let m1 = months->List.getAssoc(s1.month, (a, b) => a === b)->Option.getWithDefault("")
  let m2 = months->List.getAssoc(s2.month, (a, b) => a === b)->Option.getWithDefault("")
  let d1 = s1.dayOfMonth->displaySupplyDays
  let d2 = s2.dayOfMonth->displaySupplyDays

  `${m1} ${d1} ~ ${m2} ${d2}`
}

module Gallery = {
  @react.component
  let make = (~imageUrls) => {
    open ReactImagesViewer
    let (imageIndex, setImageIndex) = React.Uncurried.useState(_ => 0)
    let (isOpen, setIsOpen) = React.Uncurried.useState(_ => false)

    <>
      <span
        className=%twc("underline")
        onClick={_ => {
          setIsOpen(._ => true)
        }}>
        {`?????? ??????`->React.string}
      </span>
      <ReactImagesViewer
        imgs={imageUrls->Array.map(url => {
          {src: Some(url)}
        })}
        isOpen={isOpen}
        currImg={imageIndex}
        showThumbnails={true}
        onClickThumbnail={idx => setImageIndex(._ => idx)}
        onClose={() => setIsOpen(._ => false)}
        onClickPrev={() => setImageIndex(.idx => Js.Math.max_int(0, idx - 1))}
        onClickNext={() =>
          setImageIndex(.idx => Js.Math.min_int(idx + 1, imageUrls->Array.length - 1))}
      />
    </>
  }
}

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
                )}???~${campaign.estimatedPurchasePriceMax->Locale.Float.show(
                  ~digits=0,
                )}???`->React.string
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
              j`????????? ${campaign.estimatedSellerEarningRate->Float.toString}%`->React.string
            )}
          </p>
        </div>
        <div className=%twc("h-full flex flex-row justify-between px-4 py-3")>
          {application.userPccSalesCondition
          ->Option.flatMap(c => c.averageAnnualSales)
          ->Option.mapWithDefault("", averageAnnualSales =>
            averageAnnualSales->displayAnnualProductSalesInfo
          )
          ->React.string}
        </div>
        <div className=%twc("h-full flex flex-row justify-between px-4 py-3")>
          {application.userPccSalesCondition
          ->Option.mapWithDefault(``, c => c.canDeliver ? `???` : `?????????`)
          ->React.string}
        </div>
        <div className=%twc("h-full flex flex-row justify-between px-4 py-3")>
          {application.userPccSalesCondition
          ->Option.flatMap(c => c.deliveryWeightUnit)
          ->Option.getWithDefault("")
          ->React.string}
        </div>
        <div className=%twc("h-full flex flex-row justify-between px-4 py-3")>
          {application.userPccSalesCondition
          ->Option.flatMap(c => c.deliveryDailyCapacity)
          ->Option.getWithDefault("")
          ->React.string}
        </div>
        <div className=%twc("h-full flex flex-row justify-between px-4 py-3")>
          {application.userPccSalesCondition
          ->Option.mapWithDefault("", c => c.supplyFrequency->displaySupplyFrequency)
          ->React.string}
        </div>
        <div className=%twc("h-full flex flex-row justify-between px-4 py-3")>
          {application.userPccSalesCondition
          ->Option.mapWithDefault("", c => {
            switch (c.supplyBegin, c.supplyEnd) {
            | (_, None)
            | (None, _) => `?????? ??????`
            | (Some(s1), Some(s2)) => displaySupplyBeginToEnd(s1, s2)
            }
          })
          ->React.string}
        </div>
        <div className=%twc("h-full flex flex-row justify-between px-4 py-3")>
          {application.userPccSalesCondition
          ->Option.mapWithDefault("", p =>
            p.deliveryPackages->Array.map(p => p->displayDeliveryPackage) |> Js.Array.joinWith(", ")
          )
          ->React.string}
        </div>
        <div className=%twc("h-full flex flex-row justify-between px-4 py-3")>
          {application.userPccProduction
          ->Option.mapWithDefault("", p => p.facilityType->displayFacilityType)
          ->React.string}
        </div>
        <div className=%twc("h-full flex flex-row justify-between px-4 py-3")>
          {application.userPccProduction
          ->Option.mapWithDefault("", p =>
            p.certificates->Array.map(c => c->displayCertificate) |> Js.Array.joinWith(", ")
          )
          ->React.string}
        </div>
        <div className=%twc("h-full flex flex-row justify-between px-4 py-3")>
          {application.userPccProduction->Option.mapWithDefault("", p => p.grade)->React.string}
        </div>
        <div className=%twc("h-full flex flex-col justify-center px-4 py-2")>
          <BulkSale_Producer_MarketSales_Admin query=application.fragmentRefs />
        </div>
        <div className=%twc("h-full flex flex-col justify-center px-4 py-2")>
          {(
            application.bulkSaleProducerDetail
            ->Option.flatMap(d => d.hasOnlineExperience)
            ->Option.getWithDefault(false)
              ? `???`
              : `?????????`
          )->React.string}
        </div>
        <div className=%twc("h-full flex flex-row justify-between px-4 py-3")>
          {
            let imageUrls = application.userPccProduction->Option.mapWithDefault([], p => p.images)

            imageUrls->Garter_Array.isEmpty
              ? <span> {`?????? ??????`->React.string} </span>
              : <Gallery imageUrls={imageUrls} />
          }
        </div>
        <div className=%twc("h-full flex flex-col justify-center px-4 py-2")>
          <div className=%twc("flex")>
            <p>
              {if application.applicantName == "" {
                `?????????: ${application.farmmorningUser.name}`->React.string
              } else {
                `?????????: ${application.applicantName}`->React.string
              }}
            </p>
            {switch application.farmmorningUser.isDeleted {
            | true =>
              <span className=%twc("ml-2 py-0.5 px-1.5 text-xs bg-red-100 text-notice rounded")>
                {`??????`->React.string}
              </span>
            | false => React.null
            }}
          </div>
          <p>
            {
              let name =
                application.farmmorningUser.userBusinessRegistrationInfo->Option.mapWithDefault(
                  "",
                  i => i.name,
                )
              if name == "" {
                React.null
              } else {
                `?????????: ${name}`->React.string
              }
            }
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
            ->Option.getWithDefault(`?????? ??????`)
            ->React.string}
          </p>
          <p className=%twc("text-text-L3")>
            {switch application.farm.zipCode {
            | Some(zipCode) => `???)${zipCode}`
            | None => `(???????????? ??????)`
            }->React.string}
          </p>
        </div>
        <div className=%twc("h-full flex flex-row justify-between px-4 py-3")>
          {application.bulkSaleProducerDetail
          ->Option.flatMap(d => d.handsOn)
          ->Option.mapWithDefault(``, handsOn => handsOn ? `???` : `?????????`)
          ->React.string}
        </div>
        <div className=%twc("h-full flex flex-col justify-center px-4 py-2")>
          <p>
            {application.bulkSaleProducerDetail
            ->Option.flatMap(d => d.experienceYearType)
            ->Option.mapWithDefault(``, displayExperiencedYearRange)
            ->React.string}
          </p>
        </div>
        <div className=%twc("h-full flex flex-row justify-between px-4 py-3")>
          {application.bulkSaleProducerDetail
          ->Option.flatMap(d => d.producerComment)
          ->Option.getWithDefault("")
          ->React.string}
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
