@react.component
let make = (~courierCode: option<string>, ~setCourier) => {
  let status = CustomHooks.Courier.use()

  let onChange = e => {
    let code = (e->ReactEvent.Synthetic.target)["value"]
    switch status {
    | Loaded(couriers) =>
      couriers
      ->CustomHooks.Courier.response_decode
      ->Result.map(couriers' => {
        let selected =
          couriers'.data
          ->Array.getBy(courier => courier.code === code)
          ->Option.map(courier => courier.code)
        setCourier(._ => selected)
      })
      ->ignore
    | _ => ()
    }
  }

  let courierName = switch status {
  | Loaded(couriers) =>
    courierCode
    ->Option.flatMap(courierCode' => {
      couriers
      ->CustomHooks.Courier.response_decode
      ->Result.map(couriers' => {
        couriers'.data->Array.getBy(courier => courier.code === courierCode')
      })
      ->Result.getWithDefault(None)
    })
    ->Option.map(courier => courier.name)
    ->Option.getWithDefault(`택배사 선택`)
  | _ => `택배사 선택`
  }

  <label className=%twc("block relative h-13 lg:h-8")>
    <span
      className=%twc(
        "block border border-gray-gl-light rounded-xl py-3 lg:py-1 lg:rounded-md px-3 text-gray-500"
      )>
      {switch status {
      | Loading => `...`->React.string
      | Loaded(_) => courierName->React.string
      | _ => `택배사 선택`->React.string
      }}
    </span>
    <select
      value={courierCode->Option.getWithDefault("-1")}
      className=%twc("block w-full h-full absolute top-0 opacity-0")
      onChange>
      <option value=`택배사 선택`> {j`-- 택배사 선택 --`->React.string} </option>
      {switch status {
      | Loaded(couriers) =>
        switch couriers->CustomHooks.Courier.response_decode {
        | Ok(couriers') =>
          couriers'.data
          ->Garter.Array.map(courier => {
            <option key=courier.code value=courier.code> {courier.name->React.string} </option>
          })
          ->React.array
        | Error(_) => React.null
        }
      | _ => React.null
      }}
    </select>
    <span className=%twc("absolute top-3 lg:top-0.5 right-2")>
      <IconArrowSelect height="24" width="24" fill="#121212" />
    </span>
  </label>
}
