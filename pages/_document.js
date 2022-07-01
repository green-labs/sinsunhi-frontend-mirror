import Document, { Html, Head, Main, NextScript } from "next/document";

class MyDocument extends Document {
  static async getInitialProps(ctx) {
    const initialProps = await Document.getInitialProps(ctx);
    return { ...initialProps };
  }

  render() {
    const kcpScriptUrl = process.env.NEXT_PUBLIC_KCP_SCRIPT_URL

    return (
      <Html>
        <Head>
          <meta name="naver-site-verification" content="118b9725fc68d47f420bded30c9a1fbc10ef2d6c" />
          <meta name="google-site-verification" content="hxOisu7UrmoAE5HN9HWorLkG0Y4016ojm4NQ5aCPZT8" />
          <meta name="description" content="농산물 소싱은 신선하이에서! 전국 60만 산지농가의 우수한 농산물을 싸고 편리하게 공급합니다. 국내 유일한 농산물 B2B 플랫폼 신선하이와 함께 매출을 올려보세요." />
          {/* Google Tag Manager */}
          <script dangerouslySetInnerHTML={{
            __html: `(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':
new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],
j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src=
'https://www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);
})(window,document,'script','dataLayer','${process.env.NEXT_PUBLIC_GTM_APP_ID}');`
          }}>
          </script>
          {/* End Google Tag Manager */}
          <link
            rel="stylesheet"
            href="https://cdn.jsdelivr.net/npm/@duetds/date-picker@1.4.0/dist/duet/themes/default.css"
          />
          <link rel="icon" type="image/ico" href="/favicon.ico" />
          <meta
            property="og:url"
            content="https://app.sinsunhi.com"
          />
          <meta property="og:type" content="website" />
          <meta property="og:title" content="신선하이" />
          <meta property="og:description" content="농산물 소싱 플랫폼" />
          <meta
            property="og:image"
            content="https://app.sinsunhi.com/og_img.jpg"
          />
          <link rel="preconnect" href="https://fonts.googleapis.com" />
          <link rel="preconnect" href="https://fonts.gstatic.com" crossOrigin="true" />
          <link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard/dist/web/static/pretendard-dynamic-subset.css" />
          <script
            type="text/javascript"
            src={`${kcpScriptUrl}`}
          ></script>
          <script
            type="text/javascript"
            dangerouslySetInnerHTML={{
              __html: `
             /* KCP 인증완료시 호출 함수  */
              var closeEventKCP /* 결제창 닫는 함수를 담을 전역 변수 */
              function m_Completepayment(FormOrJson, closeEvent) {
                closeEventKCP = closeEvent;
                var frm = document.order_info;
                // FormOrJson 데이터를 form 엘리먼트의 hidden input value에 채워주는 함수
                GetField(frm, FormOrJson);
                if (frm.res_cd.value == "0000") {
                  // 우리 API KCP 인증 정보를 mutate 한다.
                  mutate_completepayment(frm);
                } else {
                  alert("[" + frm.res_cd.value + "] " + frm.res_msg.value);
                  closeEvent();
                }
              }
              /* KCP 결제창 실행 함수 */
              function jsf__pay(form) {
                try {
                  KCP_Pay_Execute(form);
                } catch (e) {
                  console.log(e);
                }
              }`,
            }}
          ></script>
          <script src="https://js.tosspayments.com/v1"></script>
          <script dangerouslySetInnerHTML={{
            __html: `
          var clientKey = '${process.env.NEXT_PUBLIC_TOSS_PAYMENTS_CLIENT_KEY}'
          var tossPayments = TossPayments(clientKey) // 클라이언트 키로 초기화하기
          `}}></script>
        </Head>
        <body>
          {/* Google Tag Manager (noscript) */}
          <noscript dangerouslySetInnerHTML={{
            __html: `<iframe src="https://www.googletagmanager.com/ns.html?id=${process.env.NEXT_PUBLIC_GTM_APP_ID}"
height="0" width="0" style="display:none;visibility:hidden"></iframe>`}}></noscript>
          {/* End Google Tag Manager (noscript) */}
          {/* Channel Talk */}
          <script dangerouslySetInnerHTML={{
            __html: `
(function () {
  var w = window;
  if (w.ChannelIO) {
    return (window.console.error || window.console.log || function () {})(
      "ChannelIO script included twice."
    );
  }
  var ch = function () {
    ch.c(arguments);
  };
  ch.q = [];
  ch.c = function (args) {
    ch.q.push(args);
  };
  w.ChannelIO = ch;
  function l() {
    if (w.ChannelIOInitialized) {
      return;
    }
    w.ChannelIOInitialized = true;
    var s = document.createElement("script");
    s.type = "text/javascript";
    s.async = true;
    s.src = "https://cdn.channel.io/plugin/ch-plugin-web.js";
    s.charset = "UTF-8";
    var x = document.getElementsByTagName("script")[0];
    x.parentNode.insertBefore(s, x);
  }
  if (document.readyState === "complete") {
    l();
  } else if (window.attachEvent) {
    window.attachEvent("onload", l);
  } else {
    window.addEventListener("DOMContentLoaded", l, false);
    window.addEventListener("load", l, false);
  }
})();
`}}>
            {/* End Channel Talk*/}
          </script>
          <Main />
          <NextScript />
        </body>
      </Html>
    );
  }
}

export default MyDocument;
