module Option = {
  include Option

  let map2 = (xs, ys, f) => xs->Option.flatMap(x => ys->Option.map(y => f(x, y)))

  let sequence = xs =>
    xs->Array.reduce(Some([]), (a, x) => map2(a, x, (a, x) => a->Array.concat([x])))

  let traverse = (xs, f) => sequence(xs->Array.map(f))

  let alt = (a, b) => {
    switch (a, b) {
    | (None, None) => None
    | (Some(_), None) => a
    | (None, Some(_)) => b
    | (Some(_), Some(_)) => a
    }
  }
}

module Result = {
  include Result

  let map2 = (xs, ys, f) => xs->Result.flatMap(x => ys->Result.map(y => f(x, y)))

  let sequence = xs =>
    xs->Array.reduce(Result.Ok([]), (a, x) => map2(a, x, (a, x) => a->Array.concat([x])))
}

module Filename = {
  let parseFilename = value => {
    Js.Re.fromString(`filename\\\*?=['"]?(?:UTF-\\\d['"]*)?([^;\r\n"']*)['"]?;?`)
    ->Js.Re.exec_(value)
    ->Option.map(Js.Re.captures)
    ->Option.flatMap(strings => strings->Garter.Array.get(1))
    ->Option.flatMap(filename => filename->Js.Nullable.toOption)
  }
}

module Invoice = {
  let cleanup = v =>
    v
    ->Js.String2.replaceByRe(%re("/[^0-9a-zA-Z\-\_]/g"), "")
    ->Js.String2.replace("--", "-")
    ->Js.String2.replace("__", "_")
    ->Js.String2.replace("-_", "-")
    ->Js.String2.replace("_-", "_")
}

module PhoneNumber = {
  type t =
    | Mobile(string)
    | LocalLine(string)
    | VoIP(string)
    | ONO(string)
  type regex =
    | Mobile(Js.Re.t)
    | LocalLine(Js.Re.t)
    | VoIP(Js.Re.t)
    | ONO(Js.Re.t)

  let regexOfMobile = Js.Re.fromString("^(010|011|016|017|018|019)([0-9]{3,4})([0-9]{4})$")
  let regexOfLocalLine = Js.Re.fromString(
    "^(02|031|032|033|041|042|043|044|051|052|053|054|055|061|062|063|064)([0-9]{3,4})([0-9]{4})",
  )
  let regexOfVoIP = Js.Re.fromString("^(070)([0-9]{3,4})([0-9]{4})")
  let regexOfONO = Js.Re.fromString("^(050\d|060\d)([0-9]{3,4})([0-9]{4})")

  let regexs = [
    Mobile(regexOfMobile),
    LocalLine(regexOfLocalLine),
    VoIP(regexOfVoIP),
    ONO(regexOfONO),
  ]

  let removeDash = phoneNumber =>
    phoneNumber->Js.String2.replaceByRe(Js.Re.fromStringWithFlags("\-", ~flags="g"), "")

  let extract = (regex, s): option<t> => {
    switch regex {
    | Mobile(regex') => regex'->Js.Re.test_(s) ? Mobile(s)->Some : None
    | LocalLine(regex') => regex'->Js.Re.test_(s) ? LocalLine(s)->Some : None
    | VoIP(regex') => regex'->Js.Re.test_(s) ? VoIP(s)->Some : None
    | ONO(regex') => regex'->Js.Re.test_(s) ? ONO(s)->Some : None
    }
  }

  /**
   * ## Parse ##
   * "01051973097"->Helper.PhoneNumber.parse // Some(Mobile(01051973097))
   * "02051973097"->Helper.PhoneNumber.parse // None
   */
  let parse = s => {
    regexs->Array.reduce(None, (acc, regex) => {
      Option.alt(acc, extract(regex, s))
    })
  }

  let formatByRe = (phoneNumber, regex) =>
    regex
    ->Js.Re.exec_(phoneNumber)
    ->Option.map(result => result->Js.Re.captures->Array.map(Js.Nullable.toOption))
    ->Option.flatMap(Option.sequence)
    ->Option.map(arr => arr->Array.sliceToEnd(1)->Js.Array2.joinWith("-"))

  /**
   * ## Format ##
   * Some(Mobile(01051973097))->Option.flatMap(Helper.PhoneNumber.format) // Some("010-5197-3097")
   */
  let format = (kind: t) => {
    switch kind {
    | Mobile(phoneNumber) => phoneNumber->formatByRe(regexOfMobile)
    | LocalLine(phoneNumber) => phoneNumber->formatByRe(regexOfLocalLine)
    | VoIP(phoneNumber) => phoneNumber->formatByRe(regexOfVoIP)
    | ONO(phoneNumber) => phoneNumber->formatByRe(regexOfONO)
    }
  }
}

module Debounce = {
  @new external makeExn: Js.Promise.error => exn = "Error"
  let make1 = (fun, await) => {
    let timeoutId = ref(None)

    args => {
      timeoutId.contents
      ->Option.map(id' => {
        Js.Global.clearTimeout(id')
        timeoutId := None
      })
      ->ignore

      Js.Promise.make((~resolve, ~reject) => {
        timeoutId :=
          Js.Global.setTimeout(
            () =>
              fun(args)
              ->Js.Promise.then_(res => Js.Promise.resolve(resolve(. res)), _)
              ->Js.Promise.catch(error => Js.Promise.resolve(reject(. makeExn(error))), _)
              ->ignore,
            await,
          )->Some
      })
    }
  }
}
