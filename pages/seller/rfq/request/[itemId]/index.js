import dynamic from "next/dynamic";
import { useRouter } from "next/router";

const RfqItemDetailSeller = dynamic(
  () =>
    import("src/pages/seller/rfq/RfqItemDetail_Seller.mjs").then(
      (mod) => mod.make
    ),
  { ssr: false }
);

export default function Index(props) {
  const router = useRouter();
  const { itemId = "" } = router.query;
  return <RfqItemDetailSeller {...props} itemId={itemId} />;
}
