/**
* react hook form resolver 사용을 위한 필드 validator 모듈입니다.
* 상품 등록에 resolver 를 사용하기 위해 추가했으나
* nest form, field array 에는 적합하지 않다는 판단으로 결국 resolver를 사용하지 않았습니다.
* 그러나 다른 폼에서는 충분히 사용할수 있음으로 남겨두었습니다.
* 사용 예시
*
let resolver: (. Js.Json.t) => {"values": Js.Json.t, "errors": Js.Json.t} = (. data) => {
  open Schema
  let {
    producerProductName: pName,
  } = Form.formName

  let input = data->Js.Json.decodeObject->Option.getWithDefault(Js.Dict.empty())

  Js.log2("resolver input: ", input)

  // Validation
  let valid = validate(
    [
      notEmpty(pName, makeError(pName, "required", "required error")),
      maxLength(pName, 100, makeError(pName, "maxLength", "maxLength error")),
    ],
    input,
  )

  let result = switch valid {
  | Ok(res) => {
      "values": res->Js.Json.object_,
      "errors": Js.Dict.empty()->Js.Json.object_,
    }
    // Parsing

  | Error(errs) => {
      Js.log2("errors: ", errs)
      errs->makeResolverError
    }
  }

  Js.log2("final result: ", result)
  result
}
*/
type t = Js.Dict.t<Js.Json.t>
type error = {@as("type") type_: string, message: string, keyName: string}

type validator = t => Result.t<t, error>

let validate = (vs: array<validator>, data: t): Result.t<t, array<error>> => {
  vs->Array.reduce(Result.Ok(data), (r, v) => {
    switch (r, data->v) {
    | (Ok(data), Ok(_)) => Ok(data)
    | (Ok(_), Error(err)) => Error([err])
    | (Error(errs), Ok(_)) => Error(errs)
    | (Error(errs), Error(err)) => Error(errs->Array.concat([err]))
    }
  })
}

let makeError = (keyName, type_, msg) => {keyName: keyName, type_: type_, message: msg}

let makeResolverError: array<error> => {"values": Js.Json.t, "errors": Js.Json.t} = errors => {
  let resolverError = errors->Array.reduce(Js.Dict.empty(), (dict, error) => {
    switch dict->Js.Dict.get(error.keyName) {
    // 선행 에러가 없는 경우에만 추가
    | None =>
      dict->Js.Dict.set(
        error.keyName,
        [("type", error.type_->Js.Json.string), ("message", error.message->Js.Json.string)]
        ->Js.Dict.fromArray
        ->Js.Json.object_,
      )
    | Some(_) => ()
    }

    dict
  })

  {"values": Js.Dict.empty()->Js.Json.object_, "errors": resolverError->Js.Json.object_}
}

let notEmpty = (keyName, error, data) => {
  switch data->Js.Dict.get(keyName) {
  | Some(s) =>
    switch s->Js.Json.decodeString {
    | Some(str) if str == "" => Error(error)
    | _ => Ok(data)
    }
  | None => Error(error)
  }
}

let maxLength = (keyName, max, error, data) => {
  switch data
  ->Js.Dict.get(keyName)
  ->Option.flatMap(Js.Json.decodeString)
  ->Option.map(Js.String2.length) {
  | Some(i) if i <= max => Ok(data)
  | Some(_)
  | None =>
    Error(error)
  }
}
