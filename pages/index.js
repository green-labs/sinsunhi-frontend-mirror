import { make as IndexRes } from "src/Index.mjs";
import { detectDeviceFromCtx } from "src/bindings/DeviceDetect.mjs"

// Note:
// We need to wrap the make call with
// a Fast-Refresh conform function name,
// (in this case, uppercased first letter)
//
// If you don't do this, your Fast-Refresh will
// not work!
export default function Index(props) {
  return <IndexRes {...props} />;
}

export function getServerSideProps(ctx) {
  let initProps = { deviceType: detectDeviceFromCtx(ctx) }
  return { props: initProps }
}
