@react.component
let make = () => {
  <div className=%twc("grid col-span-full justify-center items-center text-black-gl h-96")>
    <div className=%twc("")> {j`주문내역이 없습니다.`->React.string} </div>
  </div>
}
