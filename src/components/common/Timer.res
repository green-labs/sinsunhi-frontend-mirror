type status = Start | Pause | Resume | Stop

let format = second => {
  let doubleDigit = n => {
    if n < 10 {
      `0${n->Int.toString}`
    } else {
      n->Int.toString
    }
  }

  let minuteAndSecond = second' => {
    let min = second' / 60
    let sec = second' - min * 60

    `${min->Int.toString}:${sec->doubleDigit}`
  }

  if second < 0 {
    `-${second->Js.Math.abs_int->minuteAndSecond}`
  } else {
    second->Js.Math.abs_int->minuteAndSecond
  }
}

@react.component
let make = (~status, ~onChangeStatus, ~startTimeInSec, ~className) => {
  let (status', setStatus') = React.Uncurried.useState(_ => status)
  let (time, setTime) = React.Uncurried.useState(_ => startTimeInSec)

  React.useEffect1(_ => {
    setStatus'(._ => status)

    None
  }, [status])

  React.useEffect1(_ => {
    let id = Js.Global.setInterval(_ => {
      setTime(.time => time - 1)
    }, 1000)
    switch status' {
    | Start => setTime(._ => startTimeInSec)
    | Pause => id->Js.Global.clearInterval
    | Resume => ()
    | Stop => {
        id->Js.Global.clearInterval
        setTime(._ => startTimeInSec)
      }
    }
    onChangeStatus(status')

    Some(_ => id->Js.Global.clearInterval)
  }, [status'])

  React.useEffect1(_ => {
    if time <= 0 {
      setStatus'(._ => Stop)
    }

    None
  }, [time])

  <div className> {time->format->React.string} </div>
}
