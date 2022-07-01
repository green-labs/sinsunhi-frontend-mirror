let getFromLS = k =>
  %external(window)->Option.flatMap(_ => Dom_storage2.localStorage->Dom_storage2.getItem(k))
let setToLS = (k, v) =>
  %external(window)->Option.map(_ => Dom_storage2.localStorage->Dom_storage2.setItem(k, v))->ignore
let removeFromLS = k =>
  %external(window)->Option.map(_ => Dom_storage2.localStorage->Dom_storage2.removeItem(k))->ignore

module type Config = {
  type t
  let key: string
  let fromString: option<string> => t
  let toString: t => string
}

module Make = (Config: Config) => {
  type t = Config.t
  let useLocalStorage = () => {
    let key = Config.key
    let (state, setState) = React.Uncurried.useState(_ => None)

    React.useEffect0(() => {
      setState(._ => Some(getFromLS(key)->Config.fromString))
      None
    })

    let setValue = value => {
      setToLS(key, value->Config.toString)
      setState(._ => Some(value))
    }

    (state, setValue)
  }
  let get = () => getFromLS(Config.key)->Config.fromString
  let set = value => setToLS(Config.key, value->Config.toString)
  let remove = () => removeFromLS(Config.key)
}
