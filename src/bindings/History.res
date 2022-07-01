type t = Dom.history

@val @scope(("window", "history"))
external back: unit => unit = "back"
