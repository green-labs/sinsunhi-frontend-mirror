module Option: {
  let map2: (option<'a>, option<'b>, ('a, 'b) => 'c) => option<'c>
  let sequence: array<option<'a>> => option<array<'a>>
  let traverse: (array<'a>, 'a => option<'b>) => option<array<'b>>
  let alt: (option<'a>, option<'a>) => option<'a>
}

module Result: {
  let map2: (Result.t<'a, 'd>, result<'b, 'd>, ('a, 'b) => 'c) => result<'c, 'd>
  let sequence: array<result<'a, 'd>> => result<array<'a>, 'd>
}

module Filename: {
  let parseFilename: string => option<string>
}

module Invoice: {
  let cleanup: string => string
}

module PhoneNumber: {
  type t
  let removeDash: Js.String2.t => Js.String2.t
  let parse: string => option<t>
  let format: t => option<string>
}

module Debounce: {
  let make1: ('a => Js.Promise.t<'b>, int, 'a) => Js.Promise.t<'b>
}
