let stopSyntheticDefaultEvent = e => {
  e->ReactEvent.Synthetic.preventDefault
  e->ReactEvent.Synthetic.stopPropagation
}

let stopSyntheticEventWithTarget = e => {
  e->stopSyntheticDefaultEvent
  e->ReactEvent.Synthetic.target
}

let interceptingHandler = (f, e) => {
  e->stopSyntheticDefaultEvent
  f(e)
}
