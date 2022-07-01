@react.component
let make = (~children) => {
  let router = Next.Router.useRouter()

  let status = CustomHooks.Downloads.use(
    router.query->Webapi.Url.URLSearchParams.makeWithDict->Webapi.Url.URLSearchParams.toString,
  )

  switch status {
  | Error(error) => <ErrorPanel error />
  | Loading => <div> {j`로딩 중..`->React.string} </div>
  | Loaded(downloads) => {
      let decode = downloads->CustomHooks.Downloads.downloads_decode
      switch decode {
      | Error(_) => <div> {j`오류가 발생하였습니다.`->React.string} </div>
      | Ok(downloads') =>
        children->React.cloneElement({"children": <Download_Center_Table downloads' />})
      }
    }
  }
}
