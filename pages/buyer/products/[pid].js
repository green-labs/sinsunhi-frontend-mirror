import { make as PDP_Buyer } from "src/pages/buyer/pdp/PDP_Buyer.mjs";
import { detectDeviceFromCtx } from "src/bindings/DeviceDetect.mjs";

export default function Index(props) {
  return <PDP_Buyer {...props} />;
}

export function getServerSideProps(ctx) {
  let initProps = { deviceType: detectDeviceFromCtx(ctx) }
  return { props: initProps }
}
