module Fragment = %relay(`
  fragment UpdateProductDetailDescriptionAdmin on Product {
    status
    notice
    description
    image {
      original
      thumb1000x1000
      thumb100x100
      thumb1920x1920
      thumb400x400
      thumb800x800
    }
    salesDocument
    noticeStartAt
    noticeEndAt
  }
`)

let queryImageToFormImage: UpdateProductDetailDescriptionAdmin_graphql.Types.fragment_image => Upload_Thumbnail_Admin.Form.image = image => {
  original: image.original,
  thumb1000x1000: image.thumb1000x1000,
  thumb100x100: image.thumb100x100,
  thumb1920x1920: image.thumb1920x1920,
  thumb400x400: image.thumb400x400,
  thumb800x800: image.thumb800x800,
}

@react.component
let make = (~query) => {
  let data = Fragment.use(query)

  let allFieldsDisabled = data.status == #NOSALE

  <Product_Detail_Description_Admin
    defaultNotice={data.notice->Option.getWithDefault("")}
    defaultDescription={data.description}
    defaultThumbnail={data.image->queryImageToFormImage}
    defaultSalesDocument={data.salesDocument->Option.getWithDefault("")}
    defaultNoticeStratAt=?{data.noticeStartAt}
    defaultNoticeEndAt=?{data.noticeEndAt}
    allFieldsDisabled
  />
}
