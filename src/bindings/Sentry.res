type config

type intergration

@obj
external makeConfig: (
  ~dsn: string=?,
  ~integrations: array<intergration>=?,
  ~tracesSampleRate: float=?,
  ~whitelistUrls: array<string>=?,
  ~ignoreErrors: array<string>=?,
  ~environment: string=?,
  ~enabled: bool=?,
  ~release: string=?,
  unit,
) => config = ""

@module("@sentry/nextjs") external init: config => unit = "init"

@module("@sentry/nextjs") external captureException: 'a => unit = "captureException"

module ErrorBoundary = {
  @module("@sentry/nextjs") @react.component
  external make: (~fallback: React.element, ~children: React.element) => React.element =
    "ErrorBoundary"
}

module Scope = {
  type t
  @send external setUser: (t, 'a) => unit = "setUser"
  @send external setExtra: (t, string, 'a) => unit = "setExtra"
  @send external setTag: (t, string, 'a) => unit = "setTag"
}
@module("@sentry/nextjs") external withScope: (Scope.t => unit) => unit = "withScope"

// BrowserTracing Integration을 사용하려면 tracingOrigins를 설정해야 CORS 관련된 오류가 발생하지 않는다.
module Integrations = {
  type config

  @obj
  external makeConfig: (
    ~tracingOrigins: array<string>=?,
    ~beforeNavigate: 'context => 'transactionContext=?,
    ~shouldCreateSpanForRequest: 'url => bool=?,
    ~idleTimeout: int=?,
    ~startTransactionOnLocationChange: bool=?,
    ~startTransactionOnPageLoad: bool=?,
    ~maxTransactionDuration: int=?,
    ~markBackgroundTransactions: bool=?,
    unit,
  ) => config = ""

  @module("@sentry/tracing") @scope("Integrations") @new
  external makeBrowserTracing: config => intergration = "BrowserTracing"
}

@spice
type relayRequest = {
  query: option<Js.Json.t>,
  variables: option<Js.Json.t>,
}

let parseStringToJson = s =>
  try Ok(Js.Json.parseExn(s)) catch {
  | _ => Spice.error("요청 body 파싱에 실패하였습니다.", Js.Json.string(s))
  }

let getRelayRequestInfo = s =>
  s
  ->parseStringToJson
  ->Result.flatMap(relayRequest_decode)
  ->Result.flatMap(relayRequest =>
    switch (relayRequest.query, relayRequest.variables) {
    | (Some(query), Some(variables)) => Ok((query->Js.Json.stringify, variables->Js.Json.stringify))
    | _ =>
      Spice.error("요청 query, variables 파싱에 실패하였습니다.", Js.Json.string(s))
    }
  )

module CaptureException = {
  let makeWithURLError = (error: option<Js.Exn.t>, url) => {
    withScope(scope => {
      // Global.User.make()
      // scope->Scope.setUser(Webapi.Dom.window->Global.User.getUser)
      scope->Scope.setExtra("Invalid Url Error", error)
      scope->Scope.setExtra("URL Input", url)
      scope->Scope.setTag("type", "InvalidUrlError")
      scope->captureException
    })
  }
  let makeWithRelayError = (~errorType, ~errorMessage, ~body) => {
    withScope(scope => {
      switch getRelayRequestInfo(body) {
      | Ok((query, variables)) => {
          scope->Scope.setExtra("query", query)
          scope->Scope.setExtra("variables", variables)
        }
      | Error(_) => ()
      }
      scope->Scope.setTag("type", errorType)
      scope->Scope.setExtra("message", errorMessage)
      captureException(scope)
    })
  }
}
