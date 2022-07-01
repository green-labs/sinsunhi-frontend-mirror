open ChannelTalk

// 바이어 전용 채널톡 유저 정보 전송 모듈
module Query = %relay(`
  query ChannelTalkHelper_channelIO_Query {
    channelIO {
      bootEvent {
        memberId
        pluginKey
        profile {
          joinTime
          mobileNumber
          name
          purchasedAmount
          purchasedCount
        }
      }
    }
  }
`)

let bootWithProfile = () => {
  (Query.fetchPromised(
    ~variables=(),
    ~environment=RelayEnv.envSinsunMarket,
    (),
  ) |> Js.Promise.then_((res: ChannelTalkHelper_channelIO_Query_graphql.Types.response) => {
    Js.Promise.resolve(
      res.channelIO->Option.forEach(({bootEvent}) =>
        bootEvent->Option.forEach(({profile} as bootEvent) =>
          make(.
            "boot",
            {
              "pluginKey": Env.channelTalkKey,
              "memberId": bootEvent.memberId,
              "profile": profile,
            },
          )
        )
      ),
    )
  }))->ignore
}

let updateProfile = () => {
  (Query.fetchPromised(
    ~variables=(),
    ~environment=RelayEnv.envSinsunMarket,
    (),
  ) |> Js.Promise.then_((res: ChannelTalkHelper_channelIO_Query_graphql.Types.response) => {
    Js.Promise.resolve(
      res.channelIO->Option.forEach(({bootEvent}) =>
        bootEvent->Option.forEach(({profile}) =>
          make(.
            "updateUser",
            {
              "language": "ko",
              "profile": profile,
            },
          )
        )
      ),
    )
  }))->ignore
}

let logout = () => {
  make(. "boot", {"pluginKey": Env.channelTalkKey, "hideChannelButtonOnBoot": true})
}

module Hook = {
  type trackData<'eventProperty> = {
    eventName: string,
    eventProperty: 'eventProperty,
  }

  type viewMode =
    | PcAndMobile
    | PcOnly
    | MobileOnly

  let useBoot = () => {
    React.useEffect0(_ => {
      switch %external(window) {
      | Some(_) =>
        make(. "boot", {"pluginKey": Env.channelTalkKey, "hideChannelButtonOnBoot": true})
      | None => ()
      }

      // 채널톡을 종료합니다.
      Some(shutdown)
    })

    let user = CustomHooks.Auth.use()
    React.useEffect1(_ => {
      switch user {
      | LoggedIn({role: Buyer}) => updateProfile()
      | _ => ()
      }

      None
    }, [user])
  }

  let use = (~viewMode=PcAndMobile, ~trackData: option<trackData<'eventProperty>>=?, ()) => {
    let dimension = CustomHooks.UserAgent.useDimension()

    React.useEffect1(_ => {
      switch viewMode {
      | PcAndMobile => showChannelButton()
      | PcOnly if dimension == PC => showChannelButton()
      | MobileOnly if dimension == Mobile => showChannelButton()
      | _ => ()
      }

      Some(hideChannelButton)
    }, [dimension])

    React.useEffect1(_ => {
      switch trackData {
      | Some(data) => ChannelTalk.track(. "track", data.eventName, data.eventProperty)
      | None => ()
      }

      None
    }, [trackData])
  }
}
