import { useRouter } from "next/router";

import { make as RfqListBuyer } from "src/pages/buyer/rfq/RfqList_Buyer.mjs";

export default function Index(props) {
  const router = useRouter();
  const { requestId = "" } = router.query;
  return <RfqListBuyer {...props} requestId={requestId} />;
}
