open ReactHookForm

module Mutation = %relay(`
  mutation ProductDetailEditorMutation($filename: String!) {
    createPresignedUrlForImage(filename: $filename) {
      ... on CreatePresignedUrlForImageResult {
        url
        image {
          original
          thumb1920x1920
        }
      }
    }
  }
`)

@react.component
let make = (~control, ~name, ~defaultValue=?, ~disabled=?) => {
  let (mutate, _) = Mutation.use()

  let handleImageUpload = (~blobInfo: TinyMCE.blobInfo, ~success, ~failure, ~_progress, ()) => {
    let onFailWithRemove = _ => {
      failure(. `업로드 실패하였습니다.`, {"remove": true})
    }

    mutate(
      ~variables={
        filename: blobInfo.filename(),
      },
      ~onCompleted={
        ({createPresignedUrlForImage: res}, _) => {
          switch res {
          | #CreatePresignedUrlForImageResult(res') =>
            UploadFileToS3PresignedUrl.uploadImage(
              ~file=blobInfo.blob(),
              ~original=res'.url,
              ~thumb1920=res'.image.thumb1920x1920,
              ~onSuccess={
                _ => success(res'.image.thumb1920x1920)->ignore
              },
              ~onFailure={onFailWithRemove},
              (),
            )->ignore
          | _ => ()
          }
        }
      },
      ~onError={
        err => {
          Js.log(err)
          onFailWithRemove(err)
        }
      },
      (),
    )->ignore
  }
  <Controller
    name={name}
    control
    defaultValue={defaultValue->Option.getWithDefault("")->Js.Json.string}
    rules={Rules.make(~required=true, ())}
    render={({field: {value, onChange}}) =>
      <Editor
        value={value->Js.Json.decodeString->Option.getWithDefault("")}
        onEditorChange={(value, _) => onChange(Controller.OnChangeArg.value(value->Js.Json.string))}
        height=800
        initOptions={Editor.initOptions(
          ~menubar=[#file, #edit, #view, #insert, #format, #tools, #table, #help],
          ~quickbars_insert_toolbar=false,
          ~paste_data_images=true,
          ~toolbar=[
            [#undo, #redo],
            [#fontsizeselect, #formatselect, #bold, #italic, #underline, #forecolor, #backcolor],
            [#alignleft, #aligncenter, #alignright],
            [#outdent, #indent],
            [#numlist, #bullist],
            [#image, #charmap, #emoticons],
            [#preview, #fullscreen],
          ],
          ~images_upload_handler={handleImageUpload},
          (),
        )}
        plugins=Editor.basicPlugins
        ?disabled
      />}
  />
}
