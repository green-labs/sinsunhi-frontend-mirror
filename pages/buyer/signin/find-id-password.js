import FindIdPassword from "src/pages/buyer/FindIdPassword_Buyer.mjs";

export { getServerSideProps } from "src/pages/buyer/FindIdPassword_Buyer.mjs";

export default function Index(props) {
  return <FindIdPassword {...props} />;
}
