let formatDate = d => d->Js.Date.fromString->Locale.DateTime.formatFromUTC("yyyy/MM/dd HH:mm:ss")

module Item = {
  module Table = {
    @react.component
    let make = (~user: CustomHooks.QueryUser.Farmer.user) => {
      <li className=%twc("grid grid-cols-13-gl-admin-seller text-gray-700")>
        <div className=%twc("px-4 py-2")>
          {user.producerCode->Option.getWithDefault("")->React.string}
        </div>
        <div className=%twc("px-4 py-2")> {user.name->React.string} </div>
        <div className=%twc("px-4 py-2")>
          {user.phone
          ->Helper.PhoneNumber.parse
          ->Option.flatMap(Helper.PhoneNumber.format)
          ->Option.getWithDefault(user.phone)
          ->React.string}
        </div>
        <div className=%twc("px-4 py-2")>
          {user.email->Option.getWithDefault("")->React.string}
        </div>
        <div className=%twc("px-4 py-2")>
          {user.address->Option.getWithDefault("")->React.string}
        </div>
        <div className=%twc("px-4 py-2")>
          {user.producerTypeDescription->Option.getWithDefault("")->React.string}
        </div>
        <div className=%twc("px-4 py-2")>
          {user.businessRegistrationNumber->Option.getWithDefault("")->React.string}
        </div>
        <div className=%twc("px-4 py-2")> {user.rep->Option.getWithDefault("")->React.string} </div>
        <div className=%twc("px-4 py-2 text-left")>
          <div> {user.manager->Option.getWithDefault("")->React.string} </div>
          <div> {user.managerPhone->Option.getWithDefault("")->React.string} </div>
        </div>
        <div className=%twc("px-4 py-2 text-left")>
          <p className=%twc("line-clamp-2")>
            {user.etc->Option.getWithDefault("-")->React.string}
          </p>
        </div>
        <div className=%twc("py-2 flex justify-center")>
          <User_Update_Button_Admin_Farmer user />
        </div>
        <div className=%twc("px-4 py-2")>
          {user.mdName->Option.getWithDefault("")->React.string}
        </div>
        <div className=%twc("py-2 flex justify-center")>
          <User_MD_Update_Button_Admin_Farmer user />
        </div>
      </li>
    }
  }
}

@react.component
let make = (~user: CustomHooks.QueryUser.Farmer.user) => {
  <Item.Table user />
}
