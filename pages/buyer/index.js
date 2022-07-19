import { make as ShopMain_Buyer } from "src/pages/buyer/ShopMain_Buyer.mjs";
import { detectDeviceFromCtx } from "src/bindings/DeviceDetect.mjs"

export default function Index(props) {
  return <ShopMain_Buyer {...props} />;
}

export function getServerSideProps(ctx) {
  let initProps = { deviceType: detectDeviceFromCtx(ctx) }
  return { props: initProps }
}
