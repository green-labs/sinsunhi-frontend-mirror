/* This is just a custom exception to indicate that something went wrong. */
exception Graphql_error(string)

/**
 * A standard fetch that sends our operation and variables to the
 * GraphQL server, and then decodes and returns the response.
 */
type api = SinsunMarket(string) | FMBridge(string)

let fetchQuery: api => RescriptRelay.Network.fetchFunctionPromise = (
  api,
  operation,
  variables,
  _cacheConfig,
  _uploadables,
) => {
  FetchHelper.fetchWithRetryForRelay(
    ~fetcher=FetchHelper.postWithToken,
    ~url={
      switch api {
      | SinsunMarket(uri) => uri
      | FMBridge(uri) => uri
      }
    },
    ~body=Js.Dict.fromList(list{
      ("query", Js.Json.string(operation.text)),
      ("variables", variables),
    })
    ->Js.Json.object_
    ->Js.Json.stringify,
    ~count=5,
  )
}

let network = api => RescriptRelay.Network.makePromiseBased(~fetchFunction=fetchQuery(api), ())

let environment = api =>
  RescriptRelay.Environment.make(
    ~network=network(api),
    ~store=RescriptRelay.Store.make(
      ~source=RescriptRelay.RecordSource.make(),
      ~gcReleaseBufferSize=10 /* This sets the query cache size to 10 */,
      (),
    ),
    (),
  )

let envSinsunMarket = environment(SinsunMarket(Env.graphqlApiUrl))
let envFMBridge = environment(FMBridge(Env.fmbGraphqlApiUrl))
