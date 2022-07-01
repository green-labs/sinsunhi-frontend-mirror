module Option = {
  let pure = (error, v) =>
    switch v {
    | Some(v') => Ok(v')
    | None => Error(error)
    }
  let nonEmpty = (error, s) =>
    switch s {
    | Some(s') if s' != "" => Ok(s')
    | _ => Error(error)
    }
  let shouldBeTrue = (error, v) =>
    switch v {
    | Some(v') if v' => Ok(v')
    | Some(_)
    | None =>
      Error(error)
    }
  let float = (error, v) =>
    switch v->Option.flatMap(Float.fromString) {
    | Some(v') => Ok(v')
    | None => Error(error)
    }
  let int = (error, v) =>
    switch v->Option.flatMap(Int.fromString) {
    | Some(v') => Ok(v')
    | None => Error(error)
    }
}

let pure = v => Ok(v)
let nonEmpty = (error, s) =>
  if s == "" {
    Error(error)
  } else {
    Ok(s)
  }
let shouldBeTrue = (error, v) => v ? Ok(v) : Error(error)
let float = (error, v) =>
  switch v->Float.fromString {
  | Some(v') => Ok(v')
  | None => Error(error)
  }
let int = (error, v) =>
  switch v->Int.fromString {
  | Some(v') => Ok(v')
  | None => Error(error)
  }
let map = (f, v) =>
  switch v {
  | Ok(v') => Ok(f(v'))
  | Error(err) => Error([err])
  }
let ap = (f, v) => {
  switch (f, v) {
  | (Ok(f'), Ok(v')) => Ok(f'(v'))
  | (Ok(_), Error(err)) => Error([err])
  | (Error(errs), Ok(_)) => Error(errs)
  | (Error(errs), Error(err)) => Error(errs->Array.concat([err]))
  }
}
