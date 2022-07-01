// fetch 응답 에러를 만들기 위한 바인딩
type customError = {
  status: int,
  info: Js.Json.t,
  message: option<string>,
}
@spice
type errJson = {message: string}

@new external makeError: string => customError = "Error"
@set external setInfo: (customError, 'info) => unit = "info"
@set external setStatus: (customError, int) => unit = "status"
@set external setMessage: (customError, string) => unit = "message"
external convertToExn: customError => 'exn = "%identity"
external convertFromJsPromiseError: Js.Promise.error => customError = "%identity"
external convertToExnFromPromiseError: Js.Promise.error => 'exn = "%identity"

let get = (~url, ~onSuccess, ~onFailure) => {
  Fetch.fetchWithInit(
    url,
    Fetch.RequestInit.make(
      ~method_=Get,
      ~headers=Fetch.HeadersInit.make({"Content-Type": "application/json"}),
      (),
    ),
  )
  |> Js.Promise.then_(res => {
    if res->Fetch.Response.ok {
      res->Fetch.Response.json
    } else {
      res->Fetch.Response.json
      |> Js.Promise.then_(errJson => {
        Js.Promise.reject({
          let error = makeError(`요청에 실패했습니다.`)
          error->setStatus(res->Fetch.Response.status)
          error->setInfo(errJson)
          switch errJson->errJson_decode {
          | Ok(errJson') => error->setMessage(errJson'.message)
          | Error(_) => ()
          }
          error->convertToExn
        })
      })
      |> Js.Promise.catch(err => {
        Js.Promise.reject(err->convertToExnFromPromiseError)
      })
    }
  })
  |> Js.Promise.then_(json => Js.Promise.resolve(json->onSuccess))
  |> Js.Promise.catch(err => Js.Promise.resolve(err->onFailure))
}

let post = (~url, ~body, ~onSuccess, ~onFailure) => {
  Fetch.fetchWithInit(
    url,
    Fetch.RequestInit.make(
      ~method_=Post,
      ~body=Fetch.BodyInit.make(body),
      ~headers=Fetch.HeadersInit.make({"Content-Type": "application/json"}),
      (),
    ),
  )
  |> Js.Promise.then_(res => {
    if res->Fetch.Response.ok {
      res->Fetch.Response.json
    } else {
      res->Fetch.Response.json
      |> Js.Promise.then_(errJson => {
        Js.Promise.reject({
          let error = makeError(`요청에 실패했습니다.`)
          error->setStatus(res->Fetch.Response.status)
          error->setInfo(errJson)
          switch errJson->errJson_decode {
          | Ok(errJson') => error->setMessage(errJson'.message)
          | Error(_) => ()
          }
          error->convertToExn
        })
      })
      |> Js.Promise.catch(err => {
        Js.Promise.reject(err->convertToExnFromPromiseError)
      })
    }
  })
  |> Js.Promise.then_(json => Js.Promise.resolve(json->onSuccess))
  |> Js.Promise.catch(err => Js.Promise.resolve(err->onFailure))
}

let postWithURLSearchParams = (~url, ~urlSearchParams, ~onSuccess, ~onFailure) => {
  Fetch.fetchWithInit(
    url,
    Fetch.RequestInit.make(
      ~method_=Post,
      ~body=Fetch.BodyInit.make(urlSearchParams),
      ~headers=Fetch.HeadersInit.make({"Content-Type": "application/x-www-form-urlencoded"}),
      (),
    ),
  )
  |> Js.Promise.then_(res => {
    if res->Fetch.Response.ok {
      res->Fetch.Response.json
    } else {
      res->Fetch.Response.json
      |> Js.Promise.then_(errJson => {
        Js.Promise.reject({
          let error = makeError(`요청에 실패했습니다.`)
          error->setStatus(res->Fetch.Response.status)
          error->setInfo(errJson)
          switch errJson->errJson_decode {
          | Ok(errJson') => error->setMessage(errJson'.message)
          | Error(_) => ()
          }
          error->convertToExn
        })
      })
      |> Js.Promise.catch(err => {
        Js.Promise.reject(err->convertToExnFromPromiseError)
      })
    }
  })
  |> Js.Promise.then_(json => Js.Promise.resolve(json->onSuccess))
  |> Js.Promise.catch(err => Js.Promise.resolve(err->onFailure))
}

let put = (~url, ~body, ~onSuccess, ~onFailure) => {
  Fetch.fetchWithInit(
    url,
    Fetch.RequestInit.make(
      ~method_=Put,
      ~body=Fetch.BodyInit.make(body),
      ~headers=Fetch.HeadersInit.make({"Content-Type": "application/json"}),
      (),
    ),
  )
  |> Js.Promise.then_(res => {
    if res->Fetch.Response.ok {
      res->Fetch.Response.json
    } else {
      res->Fetch.Response.json
      |> Js.Promise.then_(errJson => {
        Js.Promise.reject({
          let error = makeError(`요청에 실패했습니다.`)
          error->setStatus(res->Fetch.Response.status)
          error->setInfo(errJson)
          switch errJson->errJson_decode {
          | Ok(errJson') => error->setMessage(errJson'.message)
          | Error(_) => ()
          }
          error->convertToExn
        })
      })
      |> Js.Promise.catch(err => {
        Js.Promise.reject(err->convertToExnFromPromiseError)
      })
    }
  })
  |> Js.Promise.then_(json => Js.Promise.resolve(json->onSuccess))
  |> Js.Promise.catch(err => Js.Promise.resolve(err->onFailure))
}

let putWithToken = (url, body) => {
  let accessToken = LocalStorageHooks.AccessToken.get()
  Fetch.fetchWithInit(
    url,
    Fetch.RequestInit.make(
      ~method_=Put,
      ~body=Fetch.BodyInit.make(body),
      ~headers=Fetch.HeadersInit.make({
        "Content-Type": "application/json",
        "Authorization": `Bearer ${accessToken}`,
      }),
      (),
    ),
  ) |> Js.Promise.then_(res =>
    if res->Fetch.Response.ok {
      res->Fetch.Response.json
    } else {
      res->Fetch.Response.json
      |> Js.Promise.then_(errJson => {
        Js.Promise.reject({
          let error = makeError(`요청에 실패했습니다.`)
          error->setStatus(res->Fetch.Response.status)
          error->setInfo(errJson)
          switch errJson->errJson_decode {
          | Ok(errJson') => error->setMessage(errJson'.message)
          | Error(_) => ()
          }
          error->convertToExn
        })
      })
      |> Js.Promise.catch(err => Js.Promise.reject(err->convertToExnFromPromiseError))
    }
  )
}

let putWithFormData = (~url, ~formData, ~onSuccess, ~onFailure) => {
  Fetch.fetchWithInit(
    url,
    Fetch.RequestInit.make(~method_=Put, ~body=Fetch.BodyInit.makeWithFormData(formData), ()),
  )
  |> Js.Promise.then_(res => {
    if res->Fetch.Response.ok {
      Js.Promise.resolve(res)
    } else {
      res->Fetch.Response.json
      |> Js.Promise.then_(errJson => {
        Js.Promise.reject({
          let error = makeError(`요청에 실패했습니다.`)
          error->setStatus(res->Fetch.Response.status)
          error->setInfo(errJson)
          switch errJson->errJson_decode {
          | Ok(errJson') => error->setMessage(errJson'.message)
          | Error(_) => ()
          }
          error->convertToExn
        })
      })
      |> Js.Promise.catch(err => {
        Js.Promise.reject(err->convertToExnFromPromiseError)
      })
    }
  })
  |> Js.Promise.then_(res => Js.Promise.resolve(res->onSuccess))
  |> Js.Promise.catch(err => Js.Promise.resolve(err->onFailure))
}

let putWithFile = (url, file) => {
  Fetch.fetchWithInit(
    url,
    Fetch.RequestInit.make(~method_=Put, ~body=Fetch.BodyInit.makeWithBlob(file), ()),
  ) |> Js.Promise.then_(res => {
    if res->Fetch.Response.ok {
      Js.Promise.resolve(res)
    } else {
      res->Fetch.Response.json
      |> Js.Promise.then_(errJson => {
        Js.Promise.reject({
          let error = makeError(`요청에 실패했습니다.`)
          error->setStatus(res->Fetch.Response.status)
          error->setInfo(errJson)
          switch errJson->errJson_decode {
          | Ok(errJson') => error->setMessage(errJson'.message)
          | Error(_) => ()
          }
          error->convertToExn
        })
      })
      |> Js.Promise.catch(err => {
        Js.Promise.reject(err->convertToExnFromPromiseError)
      })
    }
  })
}

let putWithFileAsAttachment = (url, file) => {
  Fetch.fetchWithInit(
    url,
    Fetch.RequestInit.make(
      ~method_=Put,
      ~body=Fetch.BodyInit.makeWithBlob(file),
      ~headers=Fetch.HeadersInit.makeWithArray([("Content-Disposition", "attachment")]),
      (),
    ),
  ) |> Js.Promise.then_(res => {
    if res->Fetch.Response.ok {
      Js.Promise.resolve(res)
    } else {
      res->Fetch.Response.json
      |> Js.Promise.then_(errJson => {
        Js.Promise.reject({
          let error = makeError(`요청에 실패했습니다.`)
          error->setStatus(res->Fetch.Response.status)
          error->setInfo(errJson)
          switch errJson->errJson_decode {
          | Ok(errJson') => error->setMessage(errJson'.message)
          | Error(_) => ()
          }
          error->convertToExn
        })
      })
      |> Js.Promise.catch(err => {
        Js.Promise.reject(err->convertToExnFromPromiseError)
      })
    }
  })
}

// swr fetcher
let fetcher = url => {
  let accessToken = LocalStorageHooks.AccessToken.get()
  Fetch.fetchWithInit(
    url,
    Fetch.RequestInit.make(
      ~method_=Get,
      ~headers=Fetch.HeadersInit.make({
        "Content-Type": "application/json",
        "Authorization": `Bearer ${accessToken}`,
      }),
      (),
    ),
  ) |> Js.Promise.then_(res =>
    if res->Fetch.Response.ok {
      res->Fetch.Response.json
    } else {
      res->Fetch.Response.json
      |> Js.Promise.then_(errJson => {
        Js.Promise.reject({
          let error = makeError(`요청에 실패했습니다.`)
          error->setStatus(res->Fetch.Response.status)
          error->setInfo(errJson)
          switch errJson->errJson_decode {
          | Ok(errJson') => error->setMessage(errJson'.message)
          | Error(_) => ()
          }
          error->convertToExn
        })
      })
      |> Js.Promise.catch(err => {
        Js.Promise.reject(err->convertToExnFromPromiseError)
      })
    }
  )
}

let getWithToken = (url, _body) => {
  let accessToken = LocalStorageHooks.AccessToken.get()
  Fetch.fetchWithInit(
    url,
    Fetch.RequestInit.make(
      ~method_=Get,
      ~headers=Fetch.HeadersInit.make({
        "Content-Type": "application/json",
        "Authorization": `Bearer ${accessToken}`,
      }),
      (),
    ),
  ) |> Js.Promise.then_(res =>
    if res->Fetch.Response.ok {
      res->Fetch.Response.json
    } else {
      res->Fetch.Response.json
      |> Js.Promise.then_(errJson => {
        Js.Promise.reject({
          let error = makeError(`요청에 실패했습니다.`)
          error->setStatus(res->Fetch.Response.status)
          error->setInfo(errJson)
          switch errJson->errJson_decode {
          | Ok(errJson') => error->setMessage(errJson'.message)
          | Error(_) => ()
          }
          error->convertToExn
        })
      })
      |> Js.Promise.catch(err => Js.Promise.reject(err->convertToExnFromPromiseError))
    }
  )
}

let getWithTokenForExcel = (url, _body) => {
  let accessToken = LocalStorageHooks.AccessToken.get()
  Fetch.fetchWithInit(
    url,
    Fetch.RequestInit.make(
      ~method_=Get,
      ~headers=Fetch.HeadersInit.make({
        "Content-Type": "application/json",
        "Authorization": `Bearer ${accessToken}`,
      }),
      (),
    ),
  ) |> Js.Promise.then_(res =>
    if res->Fetch.Response.ok {
      Js.Promise.resolve(res)
    } else {
      res->Fetch.Response.json
      |> Js.Promise.then_(errJson => {
        Js.Promise.reject({
          let error = makeError(`요청에 실패했습니다.`)
          error->setStatus(res->Fetch.Response.status)
          error->setInfo(errJson)
          switch errJson->errJson_decode {
          | Ok(errJson') => error->setMessage(errJson'.message)
          | Error(_) => ()
          }
          error->convertToExn
        })
      })
      |> Js.Promise.catch(err => Js.Promise.reject(err->convertToExnFromPromiseError))
    }
  )
}

// 상품 원본 이미지를 업로드 하면, 정해진 사이즈 별로 리사이즈 한 이미지들이 자동 생성되는데,
// 자동 생성된 이미지를 확인하기 위한 Fetch 함수 입니다.
let getProcessedImage = (url, _body) => {
  Fetch.fetchWithInit(url, Fetch.RequestInit.make(~method_=Get, ())) |> Js.Promise.then_(res =>
    if res->Fetch.Response.ok {
      Js.Promise.resolve(res)
    } else {
      Js.Promise.reject(Js.Exn.raiseError(`처리된 이미지를 찾을 수 없습니다.`))
    }
  )
}

let postWithToken = (url, body) => {
  let headers = switch LocalStorageHooks.AccessToken.get() {
  | "" =>
    Fetch.HeadersInit.make({
      "Content-Type": "application/json",
      "Accept": "application/json",
    })

  | accessToken =>
    Fetch.HeadersInit.make({
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": `Bearer ${accessToken}`,
    })
  }

  Fetch.fetchWithInit(
    url,
    Fetch.RequestInit.make(~method_=Post, ~body=Fetch.BodyInit.make(body), ~headers, ()),
  ) |> Js.Promise.then_(res =>
    if res->Fetch.Response.ok {
      if res->Fetch.Response.status === 201 || res->Fetch.Response.status === 204 {
        Js.Promise.resolve(Js.Json.null)
      } else {
        res->Fetch.Response.json
      }
    } else {
      res->Fetch.Response.json
      |> Js.Promise.then_(errJson => {
        Js.Promise.reject({
          let error = makeError(`요청에 실패했습니다.`)
          error->setStatus(res->Fetch.Response.status)
          error->setInfo(errJson)
          switch errJson->errJson_decode {
          | Ok(errJson') => error->setMessage(errJson'.message)
          | Error(_) => ()
          }
          error->convertToExn
        })
      })
      |> Js.Promise.catch(err => Js.Promise.reject(err->convertToExnFromPromiseError))
    }
  )
}

let postWithTokenForExcel = (url, body) => {
  let accessToken = LocalStorageHooks.AccessToken.get()
  Fetch.fetchWithInit(
    url,
    Fetch.RequestInit.make(
      ~method_=Post,
      ~body=Fetch.BodyInit.make(body),
      ~headers=Fetch.HeadersInit.make({
        "Content-Type": "application/json",
        "Authorization": `Bearer ${accessToken}`,
      }),
      (),
    ),
  ) |> Js.Promise.then_(res =>
    if res->Fetch.Response.ok {
      Js.Promise.resolve(res)
    } else {
      res->Fetch.Response.json
      |> Js.Promise.then_(errJson => {
        Js.Promise.reject({
          let error = makeError(`요청에 실패했습니다.`)
          error->setStatus(res->Fetch.Response.status)
          error->setInfo(errJson)
          switch errJson->errJson_decode {
          | Ok(errJson') => error->setMessage(errJson'.message)
          | Error(_) => ()
          }
          error->convertToExn
        })
      })
      |> Js.Promise.catch(err => Js.Promise.reject(err->convertToExnFromPromiseError))
    }
  )
}
let patchWithToken = (url, body) => {
  let headers = switch LocalStorageHooks.AccessToken.get() {
  | "" =>
    Fetch.HeadersInit.make({
      "Content-Type": "application/json",
      "Accept": "application/json",
    })

  | accessToken =>
    Fetch.HeadersInit.make({
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": `Bearer ${accessToken}`,
    })
  }

  Fetch.fetchWithInit(
    url,
    Fetch.RequestInit.make(~method_=Patch, ~body=Fetch.BodyInit.make(body), ~headers, ()),
  ) |> Js.Promise.then_(res =>
    if res->Fetch.Response.ok {
      if res->Fetch.Response.status === 201 || res->Fetch.Response.status === 204 {
        Js.Promise.resolve(Js.Json.null)
      } else {
        res->Fetch.Response.json
      }
    } else {
      res->Fetch.Response.json
      |> Js.Promise.then_(errJson => {
        Js.Promise.reject({
          let error = makeError(`요청에 실패했습니다.`)
          error->setStatus(res->Fetch.Response.status)
          error->setInfo(errJson)
          switch errJson->errJson_decode {
          | Ok(errJson') => error->setMessage(errJson'.message)
          | Error(_) => ()
          }
          error->convertToExn
        })
      })
      |> Js.Promise.catch(err => Js.Promise.reject(err->convertToExnFromPromiseError))
    }
  )
}

@spice
type responseToken = {
  token: string,
  @spice.key("refresh-token") refreshToken: string,
}

let refreshToken = () => {
  let rt = LocalStorageHooks.RefreshToken.get()
  let {makeWithArray, toString} = module(Webapi.Url.URLSearchParams)
  let urlSearchParams =
    [("grant-type", "refresh-token"), ("refresh-token", rt)]->makeWithArray->toString

  Fetch.fetchWithInit(
    `${Env.restApiUrl}/user/token`,
    Fetch.RequestInit.make(
      ~method_=Post,
      ~body=Fetch.BodyInit.make(urlSearchParams),
      ~headers=Fetch.HeadersInit.make({"Content-Type": "application/x-www-form-urlencoded"}),
      (),
    ),
  )
  |> Js.Promise.then_(res => {
    if res->Fetch.Response.ok {
      res->Fetch.Response.json
    } else {
      res->Fetch.Response.json
      |> Js.Promise.then_(errJson => {
        Js.Promise.reject({
          let error = makeError(`요청에 실패했습니다.`)
          error->setStatus(res->Fetch.Response.status)
          error->setInfo(errJson)
          switch errJson->errJson_decode {
          | Ok(errJson') => error->setMessage(errJson'.message)
          | Error(_) => ()
          }
          error->convertToExn
        })
      })
      |> Js.Promise.catch(err => {
        Js.Promise.reject(err->convertToExnFromPromiseError)
      })
    }
  })
  |> Js.Promise.then_(res => {
    let result = responseToken_decode(res)
    switch result {
    | Ok(res) => {
        LocalStorageHooks.AccessToken.set(res.token)
        LocalStorageHooks.RefreshToken.set(res.refreshToken)
        Js.Promise.resolve()
      }
    | Error(_) => Js.Promise.reject(Js.Exn.raiseError(`토큰 갱신에 실패하였습니다.`))
    }
  })
  |> Js.Promise.catch(err => {
    if (err->convertFromJsPromiseError).status === 400 {
      LocalStorageHooks.AccessToken.remove()
      LocalStorageHooks.RefreshToken.remove()
    }
    Js.Promise.reject(Js.Exn.raiseError(`토큰 갱신에 실패하였습니다.`))
  })
}

let wait = ms =>
  Js.Promise.make((~resolve, ~reject) => {
    reject->ignore
    Js.Global.setTimeout(_ => resolve(. true), ms)->ignore
  })

let rec retry = (~err=None, ~fn, ~count, ~interval) =>
  if count <= 0 {
    err->Option.forEach(err => Sentry.captureException(err))
    Js.Promise.reject(
      err->Option.getWithDefault(Js.Exn.raiseError(`요청 재시도를 실패하였습니다.`)),
    )
  } else {
    fn() |> Js.Promise.catch(err => {
      if (err->convertFromJsPromiseError).status == 401 {
        refreshToken()
        |> Js.Promise.then_(_ =>
          wait(interval) |> Js.Promise.then_(_ =>
            retry(~fn, ~count=count - 1, ~err=None, ~interval)
          )
        )
        |> Js.Promise.catch(err => {
          wait(interval) |> Js.Promise.then_(_ =>
            retry(~fn, ~count=count - 1, ~err=err->convertToExnFromPromiseError->Some, ~interval)
          )
        })
      } else {
        wait(interval) |> Js.Promise.then_(_ =>
          retry(~fn, ~count=count - 1, ~err=err->convertToExnFromPromiseError->Some, ~interval)
        )
      }
    })
  }

let fetchWithRetry = (~fetcher, ~url, ~body, ~count) =>
  retry(~fn=_ => fetcher(url, body), ~count, ~interval=0, ~err=None)

let fetchWithIntervalRetry = (~fetcher, ~url, ~body, ~count, ~interval) =>
  retry(~fn=_ => fetcher(url, body), ~count, ~interval, ~err=None)

@spice
type relayResponse = {
  data: option<Js.Json.t>,
  errors: option<array<GraphQL.Error.t>>,
}

@spice
type relayResponseData = {
  __typename: option<Js.Json.t>,
  message: option<Js.Json.t>,
}

let checkResponseErrorForSentry = (relayResponse: relayResponse, body: string) => {
  relayResponse.data->Option.forEach(x =>
    switch x->Js.Json.classify {
    | Js.Json.JSONObject(obj) => {
        let resultObj =
          obj
          ->Js.Dict.keys
          ->Garter.Array.first
          ->Option.flatMap(firstKey => obj->Js.Dict.get(firstKey))

        resultObj->Option.forEach(obj =>
          switch obj->relayResponseData_decode {
          | Ok(relayResponse) =>
            relayResponse.__typename->Option.forEach(__typename' => {
              if (
                __typename'->Js.Json.decodeString->Option.mapWithDefault(false, s => s == "Error")
              ) {
                Sentry.CaptureException.makeWithRelayError(
                  ~errorType="RelayResponseResultError",
                  ~errorMessage=relayResponse.message,
                  ~body,
                )
              }
            })
          | Error(_) => ()
          }
        )
      }
    | _ => ()
    }
  )

  relayResponse.errors
  ->Option.map(errors => errors->Array.keep(error => error.message != "Unauthorized"))
  ->Option.forEach(errors =>
    if errors->Array.length > 0 {
      Sentry.CaptureException.makeWithRelayError(
        ~errorType="RelayError",
        ~errorMessage=errors,
        ~body,
      )
    }
  )
}

let fetchWithRetryForRelay = (~fetcher, ~url, ~body, ~count) => {
  let fn = () =>
    fetcher(url, body) |> Js.Promise.then_(json =>
      switch json->relayResponse_decode {
      | Ok(relayResponse') =>
        if (
          relayResponse'.errors
          ->Option.flatMap(errors' =>
            errors'->Array.getBy(error => error.message == "Unauthorized")
          )
          ->Option.isSome
        ) {
          let error = makeError(`릴레이 Unauthorized`)
          error->setStatus(401)
          Js.Promise.reject(error->convertToExn)
        } else {
          checkResponseErrorForSentry(relayResponse', body)
          Js.Promise.resolve(json)
        }
      | Error(_) => Js.Promise.reject(Js.Exn.raiseError(`Cannot parse Relay response`))
      }
    )

  // FIXME retry 로직의 Promise가 중첩되어 마치 병렬로 처리되고 있어 interval=200 핫픽스를 합니다.
  // interval을 주어 토큰을 갱신하는 사이 원래 하려던 요청의 Promise가 또 생성되기 전에 토큰 갱신을 성공할 수 있게 합니다.
  // TODO retry 리팩토링
  retry(~fn, ~count, ~interval=200, ~err=None)
}

let requestWithRetry = (~fetcher, ~url, ~body, ~count, ~onSuccess, ~onFailure) => {
  fetchWithRetry(~fetcher, ~url, ~body, ~count)
  |> Js.Promise.then_(json => Js.Promise.resolve(json->onSuccess))
  |> Js.Promise.catch(err => Js.Promise.resolve(err->onFailure))
}
