module Int = {
  @send
  external toLocaleString: (int, ~locale: string, unit) => string = "toLocaleString"
  let show = (~showPlusSign=?, num) => {
    let sign = showPlusSign->Option.mapWithDefault("", show => show && num > 0 ? "+" : "")

    let value = num->toLocaleString(~locale="ko-KR", ())
    sign ++ value
  }
}

module Float = {
  type toLocaleStringOptions = {
    minimumFractionDigits: int,
    maximumFractionDigits: int,
  }

  @send
  external toLocaleStringF: (
    float,
    ~locale: string,
    ~options: toLocaleStringOptions=?,
    unit,
  ) => string = "toLocaleString"

  let show = (~showPlusSign=?, num, ~digits) => {
    let sign = showPlusSign->Option.mapWithDefault("", show => show && num > 0.0 ? "+" : "")
    let value =
      num->toLocaleStringF(
        ~locale="ko-KR",
        ~options={minimumFractionDigits: 0, maximumFractionDigits: digits},
        (),
      )
    sign ++ value
  }
  /**
   * float 값을 소수점 이하 반올림한다.
   */
  let round0 = num => num->Js.Math.round

  /**
   * float 값을 소수점 1자리 이하 반올림한다.
   */
  let round1 = num => (num *. 10.0)->Js.Math.round /. 10.0
}

module DateTime = {
  /* API에서 내려주는 datetime 값이 Zulu 타임 없이 내려오는 경우가 있어 임시로 처리하기 위한 함수 */
  let formatFromUTC = (dt, formatString) => dt->DateFns.addHours(9)->DateFns.format(formatString)
}
