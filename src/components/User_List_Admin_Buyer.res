@react.component
let make = (~status: CustomHooks.QueryUser.result) => {
  switch status {
  | Error(error) => <ErrorPanel error />
  | Loading => <div> {j`로딩 중..`->React.string} </div>
  | Loaded(users) => <>
      <div className=%twc("w-full min-w-max text-sm divide-y divide-gray-100 pr-7")>
        <div className=%twc("grid grid-cols-8-admin-users-buyer bg-gray-100 text-gray-500 h-12")>
          <div className=%twc("flex items-center px-4 whitespace-nowrap")>
            {j`바이어명`->React.string}
          </div>
          <div className=%twc("flex items-center px-4 whitespace-nowrap")>
            {j`이메일·연락처`->React.string}
          </div>
          <div className=%twc("flex items-center px-4 whitespace-nowrap")>
            {j`상태`->React.string}
          </div>
          <div className=%twc("flex items-center justify-end px-4 whitespace-nowrap")>
            {j`주문가능잔액`->React.string}
          </div>
          <div className=%twc("flex items-center justify-center px-4 whitespace-nowrap")>
            {j`거래내역`->React.string}
          </div>
          <div className=%twc("flex items-center px-4 whitespace-nowrap")>
            {j`사업장주소·사업자번호`->React.string}
          </div>
          <div className=%twc("flex items-center px-4 whitespace-nowrap")>
            {j`담당자`->React.string}
          </div>
          <div className=%twc("flex items-center px-4 whitespace-nowrap")>
            {j`판매URL`->React.string}
          </div>
        </div>
        <ol className=%twc("divide-y")>
          {switch users->CustomHooks.QueryUser.Buyer.users_decode {
          | Ok(users') =>
            users'.data
            ->Garter.Array.map(user => <User_Admin_Buyer key={user.id->Int.toString} user />)
            ->React.array
          | Error(error) =>
            error->Js.Console.log
            React.null
          }}
        </ol>
      </div>
      {switch status {
      | Loaded(users) =>
        switch users->CustomHooks.QueryUser.Buyer.users_decode {
        | Ok(users') =>
          <div className=%twc("flex justify-center py-10")>
            <Pagination
              pageDisplySize=Constants.pageDisplySize itemPerPage=users'.limit total=users'.count
            />
          </div>
        | Error(_) => React.null
        }
      | _ => React.null
      }}
    </>
  | _ => React.null
  }
}
