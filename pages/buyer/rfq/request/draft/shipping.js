import { useRouter } from "next/router";
import Script from "next/script";
import { make as RfqShippingBuyer } from "src/pages/buyer/rfq/RfqShipping_Buyer.mjs";

export default function Index(props) {
  const router = useRouter();
  const { requestId = "", from = "" } = router.query;

  return (
    <>
      <Script
        src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"
        beforeInteractive
      />
      <RfqShippingBuyer {...props} requestId={requestId} />
    </>
  );
}
