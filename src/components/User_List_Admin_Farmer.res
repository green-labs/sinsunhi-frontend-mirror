@react.component
let make = (~status: CustomHooks.QueryUser.result) => {
  switch status {
  | Error(error) => <ErrorPanel error />
  | Loading => <div> {j`로딩 중..`->React.string} </div>
  | Loaded(users) => <>
      <ol className=%twc("w-full min-w-max text-sm divide-y divide-gray-100 pr-7")>
        <li className=%twc("grid grid-cols-13-gl-admin-seller bg-gray-100 text-gray-500 h-12")>
          <div className=%twc("flex items-center px-4 text-center whitespace-nowrap")>
            {j`생산자코드`->React.string}
          </div>
          <div className=%twc("flex items-center px-4 text-center whitespace-nowrap")>
            {j`업체명`->React.string}
          </div>
          <div className=%twc("flex items-center px-4 text-center whitespace-nowrap")>
            {j`전화번호`->React.string}
          </div>
          <div className=%twc("flex items-center px-4 text-center whitespace-nowrap")>
            {j`이메일`->React.string}
          </div>
          <div className=%twc("flex items-center px-4 text-center whitespace-nowrap")>
            {j`주소`->React.string}
          </div>
          <div className=%twc("flex items-center px-4 text-center whitespace-nowrap")>
            {j`생산자유형`->React.string}
          </div>
          <div className=%twc("flex items-center px-4 text-center whitespace-nowrap")>
            {j`사업자등록번호`->React.string}
          </div>
          <div className=%twc("flex items-center px-4 text-center whitespace-nowrap")>
            {j`대표자`->React.string}
          </div>
          <div className=%twc("flex items-center px-4 text-center whitespace-nowrap")>
            {j`담당자·연락처`->React.string}
          </div>
          <div className=%twc("flex items-center px-4 text-center whitespace-nowrap")>
            {j`업체비고`->React.string}
          </div>
          <div className=%twc("flex items-center px-4 text-center whitespace-nowrap col-start-12")>
            {j`담당소싱MD`->React.string}
          </div>
        </li>
        {switch users->CustomHooks.QueryUser.Farmer.users_decode {
        | Ok(users') =>
          users'.data
          ->Garter.Array.map(user => <User_Admin_Farmer key={user.id->Int.toString} user />)
          ->React.array
        | Error(error) =>
          error->Js.Console.log
          React.null
        }}
      </ol>
      {switch status {
      | Loaded(users) =>
        switch users->CustomHooks.QueryUser.Farmer.users_decode {
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
