let formatDate = d => d->Js.Date.fromString->Locale.DateTime.formatFromUTC("yyyy/MM/dd HH:mm:ss")

module Item = {
  module Table = {
    @react.component
    let make = (~user: CustomHooks.QueryUser.Buyer.user) => {
      <li className=%twc("grid grid-cols-8-admin-users-buyer text-gray-700")>
        <div className=%twc("px-4 py-2")> {user.name->React.string} </div>
        <div className=%twc("px-4 py-2")>
          <span className=%twc("block")> {user.email->React.string} </span>
          <span className=%twc("block")> {user.phone->React.string} </span>
        </div>
        <div className=%twc("px-4 py-2")> <Badge_User_Transaction_Admin status=user.status /> </div>
        <div className=%twc("px-4 py-2 text-right")>
          <span className=%twc("block mb-4")>
            {`${user.deposit->Locale.Float.show(~digits=0)}원`->React.string}
          </span>
          <Buyer_Cash_Refund_Button_Admin buyerId=user.id />
        </div>
        <div className=%twc("py-2 text-center")>
          <Buyer_Transaction_Detail_Button_Admin buyerId=user.id buyerName=user.name />
        </div>
        <div className=%twc("px-4 py-2")>
          <span className=%twc("block")>
            {user.address->Option.getWithDefault("")->React.string}
          </span>
          <span className=%twc("block")>
            {user.businessRegistrationNumber->Option.getWithDefault("")->React.string}
          </span>
        </div>
        <div className=%twc("px-4 py-2")>
          {user.manager->Option.getWithDefault("-")->React.string}
        </div>
        <div className=%twc("px-4 py-2")>
          {user.shopUrl->Option.getWithDefault("-")->React.string}
        </div>
      </li>
    }
  }
}

@react.component
let make = (~user: CustomHooks.QueryUser.Buyer.user) => {
  <Item.Table user />
}
