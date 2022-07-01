external unsafeAsHtmlInputElement: Dom.element => Dom.htmlInputElement = "%identity"

module Mutation = %relay(`
  mutation UploadThumbnailAdminMutation($filename: String!) {
    createPresignedUrlForImage(filename: $filename) {
      ... on CreatePresignedUrlForImageResult {
        url
        image {
          original
          thumb1000x1000
          thumb100x100
          thumb1920x1920
          thumb400x400
          thumb800x800
        }
      }
    }
  }
`)

type thumbnailURL = Init | Loading | Error | Loaded(string)

module Form = {
  @spice
  type image = {
    original: string,
    thumb1000x1000: string,
    thumb100x100: string,
    thumb1920x1920: string,
    thumb400x400: string,
    thumb800x800: string,
  }

  let resetImage = {
    original: "",
    thumb1000x1000: "",
    thumb100x100: "",
    thumb1920x1920: "",
    thumb400x400: "",
    thumb800x800: "",
  }
}

let mutationImageToFormImage: UploadThumbnailAdminMutation_graphql.Types.response_createPresignedUrlForImage_CreatePresignedUrlForImageResult_image => Form.image = image => {
  original: image.original,
  thumb1000x1000: image.thumb1000x1000,
  thumb100x100: image.thumb100x100,
  thumb1920x1920: image.thumb1920x1920,
  thumb400x400: image.thumb400x400,
  thumb800x800: image.thumb800x800,
}

@react.component
let make = (~name, ~updateFn: Form.image => unit, ~value: Form.image, ~disabled=?) => {
  let (mutate, _) = Mutation.use()
  let (thumbnailURL, setThumbnailURL) = React.Uncurried.useState(_ => Init)
  let isThumbnailUploading = thumbnailURL == Loading

  let resetFile = () => {
    open Webapi

    let inputFile = Dom.document->Dom.Document.getElementById("thumbnail")
    inputFile
    ->Option.map(inputFile' =>
      inputFile'->unsafeAsHtmlInputElement->Dom.HtmlInputElement.setValue("")
    )
    ->ignore
  }

  let onSuccessWithUpdate = (updateFn, ~imageUrls, ~filename) => {
    setThumbnailURL(._ => Loaded(filename))

    updateFn(imageUrls)
  }

  let onFailureWithReset = (resetFn, updateFn, _) => {
    setThumbnailURL(._ => Error)

    resetFn()
    updateFn(Form.resetImage)
  }

  let imageUrlStateReset = () => {
    updateFn(Form.resetImage)
    setThumbnailURL(._ => Loading)
  }

  let handleOnChangeFile = e => {
    let files = (e->ReactEvent.Synthetic.target)["files"]
    let file = files->Option.flatMap(Garter.Array.first)

    switch file {
    | Some(file') => {
        imageUrlStateReset()

        let filename = file'->Webapi.File.name

        mutate(
          ~variables={
            filename: filename,
          },
          ~onCompleted={
            ({createPresignedUrlForImage: res}, _) => {
              switch res {
              | #CreatePresignedUrlForImageResult(res') =>
                UploadFileToS3PresignedUrl.uploadImage(
                  ~file=file',
                  ~original=res'.url,
                  ~thumb1920=res'.image.thumb1920x1920,
                  ~onSuccess={
                    _ => {
                      onSuccessWithUpdate(
                        updateFn,
                        ~imageUrls=mutationImageToFormImage(res'.image),
                        ~filename,
                      )
                    }
                  },
                  ~onFailure={err => onFailureWithReset(resetFile, updateFn, err)},
                  (),
                )->ignore
              | _ => ()
              }
            }
          },
          ~onError={
            err => {
              Js.log(err)
              onFailureWithReset(resetFile, updateFn, err)
            }
          },
          (),
        )->ignore
      }

    | None => ()
    }
  }

  let displayName =
    Js.Re.exec_(%re("/[^/]+$/"), value.original)
    ->Option.map(Js.Re.captures)
    ->Option.flatMap(Garter.Array.first)
    ->Option.flatMap(Js.Nullable.toOption)

  <div className=%twc("flex flex-col gap-1")>
    <div className=%twc("flex gap-2 items-center")>
      <label className=%twc("flex gap-2 items-center")>
        <span className=%twc("bg-div-shape-L1 rounded-lg py-2 px-3 block")>
          {`대표 이미지 선택하기`->React.string}
        </span>
        <input
          name
          id=name
          type_="file"
          className=%twc("file:hidden sr-only")
          accept=`.png,.jpg`
          disabled={disabled->Option.getWithDefault(false) || isThumbnailUploading}
          onChange={handleOnChangeFile}
        />
        {switch isThumbnailUploading {
        | true => <span> {`업로드 중 입니다.....`->React.string} </span>
        | false =>
          <span className=%twc("truncate")>
            {displayName->Option.getWithDefault(`선택된 파일이 없습니다.`)->React.string}
          </span>
        }}
      </label>
      {switch thumbnailURL {
      | Loaded(_) =>
        <button
          type_="button"
          onClick={ReactEvents.interceptingHandler(_ => {
            resetFile()
            updateFn(Form.resetImage)
          })}>
          <IconCloseInput height="28" width="28" fill="#B2B2B2" />
        </button>
      | _ => React.null
      }}
    </div>
    {thumbnailURL == Error
      ? <span className=%twc("flex gap-1 text-xs")>
          <IconError width="20" height="20" />
          <span className=%twc("text-sm text-notice")>
            {`업로드에 실패했습니다.`->React.string}
          </span>
        </span>
      : React.null}
  </div>
}
