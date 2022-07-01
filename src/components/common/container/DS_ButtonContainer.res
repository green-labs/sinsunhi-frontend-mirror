module Floating1 = {
  @react.component
  let make = (~label, ~disabled=?, ~onClick=?, ~buttonType=?, ~dataGtm=?) => {
    <div
      className=%twc(
        "fixed w-full max-w-3xl bottom-0 left-1/2 -translate-x-1/2 p-5 gradient-cta-t tab-highlight-color"
      )>
      {dataGtm->Option.mapWithDefault(
        <DS_Button.Normal.Large1 label ?disabled ?onClick ?buttonType />,
        dataGtm' =>
          <DataGtm dataGtm=dataGtm'>
            <div onClick={_ => ()}>
              <DS_Button.Normal.Large1 label ?disabled ?onClick ?buttonType />
            </div>
          </DataGtm>,
      )}
    </div>
  }
}

module Full1 = {
  @react.component
  let make = (~label, ~disabled=?, ~onClick=?, ~buttonType=?, ~dataGtm=?) => {
    <div
      className=%twc(
        "fixed w-full max-w-3xl bottom-0 left-1/2 -translate-x-1/2 tab-highlight-color"
      )>
      {dataGtm->Option.mapWithDefault(
        <DS_Button.Normal.Full1 label ?disabled ?onClick ?buttonType />,
        dataGtm' =>
          <DataGtm dataGtm=dataGtm'>
            <div onClick={_ => ()}>
              <DS_Button.Normal.Full1 label ?disabled ?onClick ?buttonType />
            </div>
          </DataGtm>,
      )}
    </div>
  }
}
