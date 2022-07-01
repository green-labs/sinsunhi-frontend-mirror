module type Config = {
  type t
  let key: string
  let fromString: option<string> => t
  let toString: t => string
}

module Make: (Config: Config) =>
{
  type t = Config.t
  let useLocalStorage: unit => (option<t>, t => unit)
  let get: unit => t
  let set: t => unit
  let remove: unit => unit
}
