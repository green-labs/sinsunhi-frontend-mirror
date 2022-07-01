/**
 * 수기 주문데이터 관리자 업로드 시연용 컴포넌트
 * TODO: 시연이 끝나면 지워도 된다.
*/
import { make as OrdersAll } from "src/pages/admin/Orders_All_Admin.mjs";

export default function Index(props) {
  return <OrdersAll {...props} />;
}
