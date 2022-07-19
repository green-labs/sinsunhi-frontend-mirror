import dynamic from "next/dynamic";

const TradematchAskToBuyAppliedBuyer = dynamic(
  () =>
    import(
      "src/pages/buyer/tradematch/Tradematch_Ask_To_Buy_Applied_Buyer.mjs"
    ).then((mod) => mod.make),
  { ssr: false }
);

export default function Index(props) {
  return <TradematchAskToBuyAppliedBuyer {...props} />;
}
