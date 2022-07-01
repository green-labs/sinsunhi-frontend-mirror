type env = {
  "NEXT_PUBLIC_API_URL": string,
  "NEXT_PUBLIC_IMWEB_PAY_URL": string,
  "NEXT_PUBLIC_GRAPHQL_API_URL": string,
  "NEXT_PUBLIC_FMB_GRAPHQL_API_URL": string,
  "NEXT_PUBLIC_CHANNEL_TALK_KEY": string,
  "NEXT_PUBLIC_BUYER_SIGNUP_SURVEY_KEY": string,
  "NEXT_PUBLIC_BUYER_UPLOAD_GUIDE_URI": string,
  "NEXT_PUBLIC_BUYER_ORDER_EXCEL_FORM_URI": string,
  "NEXT_PUBLIC_CANCEL_FORM_URL": string,
  "NEXT_PUBLIC_S3_PUBLIC_URL": string,
  "NEXT_PUBLIC_LOGO_150x50_URI": string,
  "NEXT_PUBLIC_KCP_WEB_API_URL": string,
  "NEXT_PUBLIC_KCP_MOBILE_API_URL": string,
  "NEXT_PUBLIC_KCP_SITE_CD": string,
  "NEXT_PUBLIC_KCP_SITE_KEY": string,
  "NEXT_PUBLIC_AFTER_PAY_API_URL": string,
}

@val external env: env = "process.env"

let restApiUrl = env["NEXT_PUBLIC_API_URL"]
// 신선하이 그래프큐엘 API
// https://api.sinsunhi.com/graphql
let graphqlApiUrl = env["NEXT_PUBLIC_GRAPHQL_API_URL"]
// 팜모닝 브릿지 그래프큐엘 API : 안심판매
// https://api.sinsunhi.com/farmmorning-bridge/graphql
let fmbGraphqlApiUrl = env["NEXT_PUBLIC_FMB_GRAPHQL_API_URL"]
let channelTalkKey = env["NEXT_PUBLIC_CHANNEL_TALK_KEY"]

// 나중 결제 API
let afterPayApiUrl = env["NEXT_PUBLIC_AFTER_PAY_API_URL"]

// let amplitudeApiKey = "9487848bf1b535343b25ff67fe4530c8"

let originProd = "https://app.sinsunhi.com"

let sweettrackerUrl = "https://info.sweettracker.co.kr/tracking/5" // http://info.sweettracker.co.kr/apidoc 템플릿 스타일은 url 마지막 번호 1~5 변경

let customerServiceUrl = "https://freshmarket.channel.io/support-bots"
let customerServicePaths = {"rfqContactManager": `/40022`, "rfqMeatProcess": `/40277`}
let kakaotalkChannel = "https://pf.kakao.com/_JftIs"

// 바이어 주문서 등록 가이드
let buyerUploadGuideUri = env["NEXT_PUBLIC_BUYER_UPLOAD_GUIDE_URI"]

// 바이어 주문 양식
let buyerOrderExcelFormUri = env["NEXT_PUBLIC_BUYER_ORDER_EXCEL_FORM_URI"]

// 취소양식 url
let cancelFormUrl = env["NEXT_PUBLIC_CANCEL_FORM_URL"]

// 크롬 다운로드 url
let downloadChromeUrl = "https://www.google.com/intl/ko/chrome/"
// 엣지 다운로드 url
let downloadEdgeUrl = "https://www.microsoft.com/ko-kr/edge"
// 아임웹 결제 url
let imwebPayUrl = env["NEXT_PUBLIC_IMWEB_PAY_URL"]

// S3 public url
let s3PublicUrl = env["NEXT_PUBLIC_S3_PUBLIC_URL"]

// 페이퍼폼 (3rd party 서베이 페이지, 마케팅팀 요청으로 삽입)
let paperformEmbedUrl = "https://paperform.co/__embed.min.js"
let buyerSignupSurveyKey = env["NEXT_PUBLIC_BUYER_SIGNUP_SURVEY_KEY"]

// Logo 150x50 uri
let logo150x50 = env["NEXT_PUBLIC_LOGO_150x50_URI"]
