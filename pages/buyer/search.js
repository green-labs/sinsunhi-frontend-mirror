import { make as SRP_Buyer } from "src/pages/buyer/srp/SRP_Buyer.mjs";
import { detectDeviceFromCtx } from "src/bindings/DeviceDetect.mjs";

export default function Index(props) {
  return <SRP_Buyer {...props} />;
}

export function getServerSideProps(ctx) {
  let initProps = { deviceType: detectDeviceFromCtx(ctx) }
  return { props: initProps }
}
