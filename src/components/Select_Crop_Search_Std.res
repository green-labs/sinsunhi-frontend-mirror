type searchType = Search_Crop_Cultivar.searchType<[#Crop | #Cultivar]>

let toString = (std: searchType) =>
  switch std {
  | #Crop => `Crop`
  | #Cultivar => `Cultivar`
  }

let decodeStd = (std: string) =>
  if std === `Crop` {
    #Crop->Some
  } else if std === `Cultivar` {
    #Cultivar->Some
  } else {
    None
  }

let parseSearchStd = q => q->Js.Dict.get("searchStd")->Option.flatMap(decodeStd)

let formatStd = (std: searchType) =>
  switch std {
  | #Crop => `작물`
  | #Cultivar => `품종`
  }

@react.component
let make = (~std, ~onChange) => {
  let displayStd = std->formatStd

  <span>
    <label className=%twc("block relative")>
      <span
        className=%twc(
          "md:w-44 flex items-center border border-border-default-L1 bg-white rounded-md h-9 px-3 text-enabled-L1"
        )>
        {displayStd->React.string}
      </span>
      <span className=%twc("absolute top-1.5 right-2")>
        <IconArrowSelect height="24" width="24" fill="#121212" />
      </span>
      <select
        value={std->toString}
        className=%twc("block w-full h-full absolute top-0 opacity-0")
        onChange>
        {[#Crop, #Cultivar]
        ->Garter.Array.map(s =>
          <option key={s->toString} value={s->toString}> {s->formatStd->React.string} </option>
        )
        ->React.array}
      </select>
    </label>
  </span>
}
