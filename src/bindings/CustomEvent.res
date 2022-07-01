module MakeCustomEvent = (
  Detail: {
    type t
  },
) => {
  type t = Dom.customEvent

  include Webapi__Dom__Event.Impl({
    type t = t
  })

  @get external detail: t => Detail.t = "detail"
}
