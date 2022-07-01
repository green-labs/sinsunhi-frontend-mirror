type blobInfo = {
  id: unit => string,
  name: unit => string,
  filename: unit => string,
  blob: unit => Webapi.File.t,
  base64: unit => string,
  blobUri: unit => string,
}

type init
@obj
external init: (
  ~height: int=?,
  ~menubar: string=?,
  ~toolbar: string=?,
  ~content_style: string=?,
  ~quickbars_insert_toolbar: bool=?,
  ~paste_data_images: bool=?,
  ~images_upload_url: bool=?,
  ~images_upload_handler: (
    ~blobInfo: blobInfo,
    ~success: string => unit,
    ~failure: (. string, {"remove": bool}) => unit,
    ~_progress: int => unit,
    unit,
  ) => unit,
  ~image_upload_credentials: bool,
  ~file_picker_types: string,
  ~table_responsive_width: bool=?,
  ~content_css: string=?,
  unit,
) => init = ""

@module("@tinymce/tinymce-react") @react.component
external make: (
  ~id: string=?,
  ~name: string=?,
  ~value: string=?,
  ~onEditorChange: (string, 'editor) => unit=?,
  ~init: init=?,
  ~initialValue: string=?,
  ~plugins: string=?,
  ~tinymceScriptSrc: string=?,
  ~disabled: bool=?,
  ~inline: bool=?,
  ~disabled: bool=?,
) => React.element = "Editor"

module Menu = {
  type t = [#file | #edit | #view | #insert | #format | #tools | #table | #help]
  let toString = (x: t) => (x :> string)
}

module Tool = {
  type t = [
    | #undo
    | #redo
    | #bold
    | #italic
    | #underline
    | #strikethrough
    | #fontselect
    | #fontsizeselect
    | #formatselect
    | #alignleft
    | #aligncenter
    | #alignright
    | #alignjustify
    | #outdent
    | #image
    | #indent
    | #numlist
    | #bullist
    | #forecolor
    | #backcolor
    | #casechange
    | #permanentpen
    | #formatpainter
    | #removeformat
    | #pagebreak
    | #charmap
    | #emoticons
    | #preview
    | #fullscreen
    | #print
    | #image
    | #link
    | #anchor
    | #ltr
    | #rtl
  ]
  let toString = (x: t) => (x :> string)
}

module Plugin = {
  type t = [
    | #lists
    | #advlist
    | #anchor
    | #print
    | #preview
    | #autolink
    | #directionality
    | #visualblocks
    | #visualchars
    | #charmap
    | #code
    | #fullscreen
    | #help
    | #hr
    | #image
    | #imagetools
    | #link
    | #quickbars
    | #searchreplace
    | #table
    | #wordcount
    | #paste
    | #emoticons
  ]

  let toString = (x: t) => (x :> string)
}
