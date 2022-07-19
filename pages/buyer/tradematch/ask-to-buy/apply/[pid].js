import dynamic from "next/dynamic";
import Script from "next/script";
import { useRouter } from "next/router";

const TradematchAskToBuyApplyBuyer = dynamic(
  () =>
    import(
      "src/pages/buyer/tradematch/Tradematch_Ask_To_Buy_Apply_Buyer.mjs"
    ).then((mod) => mod.make),
  { ssr: false }
);

export default function Index(props) {
  const router = useRouter();
  const { pid = "" } = router.query;
  return (
    <>
      <Script
        src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"
        beforeInteractive
      />
      <TradematchAskToBuyApplyBuyer {...props} pid={pid} />
    </>
  );
}
