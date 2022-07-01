open CustomHooks.Products

let encodeWeightUnit = unit =>
  switch unit {
  | G => `g`
  | Kg => `kg`
  | Ton => `t`
  }
let decodeWeightUnit = str => {
  switch str {
  | `g` => G->Some
  | `kg` => Kg->Some
  | `t` => Ton->Some
  | _ => None
  }
}

let encodeSizeUnit = unit =>
  switch unit {
  | Mm => `mm`
  | Cm => `cm`
  | M => `m`
  }

let decodeSizeUnit = str =>
  switch str {
  | `mm` => Mm->Some
  | `cm` => Cm->Some
  | `m` => M->Some
  | _ => None
  }

module Weight = {
  @react.component
  let make = (~unit, ~onChange, ~disabled=false) => {
    let displayUnit = unit->encodeWeightUnit

    <span>
      <label className=%twc("block relative")>
        <span
          className={cx([
            %twc(
              "md:w-20 flex items-center border border-border-default-L1 rounded-md px-3 text-enabled-L1 h-9"
            ),
            disabled ? %twc("bg-disabled-L3") : %twc("bg-white"),
          ])}>
          {displayUnit->React.string}
        </span>
        <span className=%twc("absolute top-1.5 right-2")>
          <IconArrowSelect height="24" width="24" fill="#121212" />
        </span>
        <select
          disabled
          value={unit->encodeWeightUnit}
          className=%twc("block w-full h-full absolute top-0 opacity-0")
          onChange>
          {[G, Kg, Ton]
          ->Garter.Array.map(s =>
            <option key={s->encodeWeightUnit} value={s->encodeWeightUnit}>
              {s->encodeWeightUnit->React.string}
            </option>
          )
          ->React.array}
        </select>
      </label>
    </span>
  }
}

module Size = {
  @react.component
  let make = (~unit, ~onChange, ~disabled=false) => {
    let displayUnit = unit->encodeSizeUnit

    <span>
      <label className=%twc("block relative")>
        <span
          className={cx([
            %twc(
              "md:w-20 flex items-center border border-border-default-L1 rounded-md h-9 px-3 text-enabled-L1"
            ),
            disabled ? %twc("bg-disabled-L3") : %twc("bg-white"),
          ])}>
          {displayUnit->React.string}
        </span>
        <span className=%twc("absolute top-1.5 right-2")>
          <IconArrowSelect height="24" width="24" fill="#121212" />
        </span>
        <select
          disabled
          value={unit->encodeSizeUnit}
          className=%twc("block w-full h-full absolute top-0 opacity-0")
          onChange>
          {[Mm, Cm, M]
          ->Garter.Array.map(s =>
            <option key={s->encodeSizeUnit} value={s->encodeSizeUnit}>
              {s->encodeSizeUnit->React.string}
            </option>
          )
          ->React.array}
        </select>
      </label>
    </span>
  }
}
