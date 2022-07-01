type revalidateOptions = {
  retryCount: int,
  dedupe: bool,
}
@obj
external revalidateOptions: (~retryCount: int=?, ~dedupe: bool=?, unit) => revalidateOptions = ""

type fetcherOptions
@obj
external fetcherOptions: (
  ~suspense: bool=?,
  ~fetcher: 'fetcher=?,
  ~initialData: Js.Json.t=?,
  ~revalidateIfStale: bool=?,
  ~revalidateOnMount: bool=?,
  ~revalidateOnFocus: bool=?,
  ~revalidateOnReconnect: bool=?,
  ~refreshInterval: int=?,
  ~refreshWhenHidden: bool=?,
  ~refreshWhenOffline: bool=?,
  ~shouldRetryOnError: bool=?,
  ~dedupingInterval: int=?,
  ~focusThrottleInterval: int=?,
  ~loadingTimeout: int=?,
  ~errorRetryInterval: int=?,
  ~errorRetryCount: int=?,
  ~onLoadingSlow: (string, fetcherOptions) => unit=?,
  ~onSuccess: (Js.Json.t, string, fetcherOptions) => unit=?,
  ~onError: (FetchHelper.customError, string, fetcherOptions) => unit=?,
  ~onErrorRetry: (
    FetchHelper.customError,
    string,
    fetcherOptions,
    revalidateOptions => Js.Promise.t<bool>,
    revalidateOptions,
  ) => unit=?,
  ~compare: (Js.Nullable.t<Js.Json.t>, Js.Nullable.t<Js.Json.t>) => bool=?,
  ~isPaused: unit => bool=?,
  unit,
) => fetcherOptions = ""

type fetcher<'shouldRevalidated> = {
  data: option<Js.Json.t>,
  error: option<FetchHelper.customError>,
  isValidating: bool,
  mutate: (~data: Js.Json.t=?, ~shouldRevalidate: 'shouldRevalidated=?) => Js.Promise.t<bool>,
}

type fetcherInfinite<'shouldRevalidated> = {
  data: option<Js.Json.t>,
  error: option<FetchHelper.customError>,
  isValidating: bool,
  mutate: (~data: Js.Json.t=?, ~shouldRevalidate: 'shouldRevalidated=?) => Js.Promise.t<bool>,
  size: int,
  setSize: int => unit,
}

@module("swr")
external useSwr: ('key, 'fetcher, 'options) => fetcher<'shouldRevalidated> = "default"

@module("swr")
external useSwrInfinite: ('key, 'fetcher, 'options) => fetcherInfinite<'shouldRevalidated> =
  "useSWRInfinite"

type config<'key> = {
  // uncurried일 경우 optional labelled 인자가 의도한 대로 되지 않는다. 더 찾아보기
  // https://rescript-lang.org/docs/manual/latest/function
  mutate: (. ~url: 'key, ~data: option<Js.Json.t>, ~revalidation: option<bool>) => unit,
}
@module("swr")
external useSwrConfig: unit => config<'key> = "useSWRConfig"

type cache
@module("swr") external cache: cache = "cache"
@send external clear: cache => unit = "clear"
@send external delete: (cache, 'key) => unit = "delete"
