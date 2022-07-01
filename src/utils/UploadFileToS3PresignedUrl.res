type kind = Seller | Buyer | AfterPay | Admin
external unsafeToBlob: Webapi.File.t => Fetch.blob = "%identity"
external makeJsPromiseError: string => Js.Promise.error = "%identity"

@spice
type responseData = {url: string}
@spice
type response = {
  message: string,
  data: responseData,
}

let upload = (~userId=?, ~kind, ~file, ~onSuccess, ~onFailure, ()) => {
  open FetchHelper

  let filename = file->Webapi.File.name

  let url = switch (userId, kind) {
  | (Some(userId'), Seller) =>
    `${Env.restApiUrl}/order/delivery/upload-url?file-name=${filename}&user-id=${userId'}`
  | (None, Seller) => `${Env.restApiUrl}/order/delivery/upload-url?file-name=${filename}`
  | (Some(userId'), Buyer) =>
    `${Env.restApiUrl}/order/upload-url?file-name=${filename}&user-id=${userId'}`
  | (Some(userId'), AfterPay) =>
    `${Env.restApiUrl}/order/upload-url?file-name=${filename}&user-id=${userId'}&pay-type=AFTER_PAY`
  | (None, AfterPay) =>
    `${Env.restApiUrl}/order/upload-url?file-name=${filename}&pay-type=AFTER_PAY`
  | (None, Buyer) => `${Env.restApiUrl}/order/upload-url?file-name=${filename}`
  | (Some(userId'), Admin) =>
    `${Env.restApiUrl}/offlineOrder/upload-url?file-name=${filename}&user-id=${userId'}`
  | (None, Admin) => `${Env.restApiUrl}/offline-order/upload-url?file-name=${filename}`
  }

  // GET the S3 presigned-url first
  fetchWithRetry(~fetcher=getWithToken, ~url, ~body=Js.Nullable.undefined, ~count=3)
  |> Js.Promise.then_(json => {
    switch json->response_decode {
    | Ok(response) =>
      // PUT file to the presigned-url
      fetchWithRetry(
        ~fetcher=putWithFile,
        ~url=response.data.url,
        ~body=file->unsafeToBlob,
        ~count=3,
      )
      |> Js.Promise.then_(res => Js.Promise.resolve(res->onSuccess))
      |> Js.Promise.catch(err => Js.Promise.resolve(err->onFailure))
    | Error(err) =>
      err->Js.Console.log
      Js.Promise.resolve(makeJsPromiseError(err.message)->onFailure)
    }
  })
  |> Js.Promise.catch(err => {
    err->Js.Console.log
    Js.Promise.resolve(err->onFailure)
  })
}

@spice
type responseDataBulkSale = {url: string, path: string}

let uploadBulkSale = (~file, ~farmmorningUserId, ~onSuccess, ~onFailure, ()) => {
  open FetchHelper

  let filename = file->Webapi.File.name

  let url = `${Env.restApiUrl}/farmmorning-bridge/api/bulk-sale/product-sale-ledger/issue-s3-put-url?filename=${filename}&farmmorning-user-id=${farmmorningUserId}`

  // GET the S3 presigned-url first
  fetchWithRetry(~fetcher=getWithToken, ~url, ~body=Js.Nullable.undefined, ~count=3)
  |> Js.Promise.then_(json => {
    switch json->responseDataBulkSale_decode {
    | Ok(response) =>
      // PUT file to the presigned-url
      fetchWithRetry(
        ~fetcher=putWithFileAsAttachment,
        ~url=response.url,
        ~body=file->unsafeToBlob,
        ~count=3,
      )
      /*
       * 안심판매의 판매원표 저장/수정 시, AWS S3의 presigned-url이 필요해서 response 대신 전달
       * */
      |> Js.Promise.then_(_res => Js.Promise.resolve(response.path->onSuccess))
      |> Js.Promise.catch(err => Js.Promise.resolve(err->onFailure))
    | Error(err) =>
      err->Js.Console.log
      Js.Promise.resolve(makeJsPromiseError(err.message)->onFailure)
    }
  })
  |> Js.Promise.catch(err => {
    err->Js.Console.log
    Js.Promise.resolve(err->onFailure)
  })
}

let uploadImage = (~file, ~original, ~thumb1920, ~onSuccess, ~onFailure, ()) => {
  open FetchHelper

  // PUT file to the presigned-url
  fetchWithRetry(~fetcher=putWithFile, ~url=original, ~body=file->unsafeToBlob, ~count=3)
  |> Js.Promise.then_(_res =>
    fetchWithIntervalRetry(
      ~fetcher=getProcessedImage,
      ~url=thumb1920,
      ~body="",
      ~count=10,
      ~interval=3000,
    )
    |> Js.Promise.then_(res => Js.Promise.resolve(res))
    |> Js.Promise.catch(err => Js.Promise.reject(err->convertToExnFromPromiseError))
  )
  |> Js.Promise.then_(res => Js.Promise.resolve(res->onSuccess))
  |> Js.Promise.catch(err => Js.Promise.resolve(err->onFailure))
}
