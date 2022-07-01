open TinyMCE

@deriving(abstract)
type initOptions<'a> = {
  @optional
  menubar: array<Menu.t>,
  @optional
  toolbar: array<array<Tool.t>>,
  @optional
  content_style: string,
  @optional
  quickbars_insert_toolbar: bool,
  @optional
  paste_data_images: bool,
  @optional
  images_upload_url: string,
  // success: success callback with image location
  // progress: progress callback takes a value between 1 and 100
  images_upload_handler: (
    ~blobInfo: blobInfo,
    ~success: string => unit,
    ~failure: (. string, {"remove": bool}) => unit,
    ~_progress: int => unit,
    unit,
  ) => unit,
}

let basicPlugins: array<Plugin.t> = [
  #lists,
  #advlist,
  #anchor,
  #print,
  #preview,
  #autolink,
  #directionality,
  #visualblocks,
  #visualchars,
  #charmap,
  #fullscreen,
  #help,
  #hr,
  #image,
  #link,
  #quickbars,
  #searchreplace,
  #wordcount,
  #paste,
  #emoticons,
  #table,
]

@react.component
let make = (
  ~initOptions,
  ~height,
  ~plugins,
  ~initialValue=?,
  ~id=?,
  ~name=?,
  ~value=?,
  ~onEditorChange=?,
  ~disabled=?,
) => {
  let init = TinyMCE.init(
    ~height,
    ~menubar={
      initOptions
      ->menubarGet
      ->Option.getWithDefault([])
      ->Array.map(Menu.toString)
      ->Garter.Array.joinWith(" ", Garter.Fn.identity)
    },
    ~quickbars_insert_toolbar={
      initOptions->quickbars_insert_toolbarGet->Option.getWithDefault(true)
    },
    ~paste_data_images={
      initOptions->paste_data_imagesGet->Option.getWithDefault(false)
    },
    ~toolbar={
      initOptions
      ->toolbarGet
      ->Option.getWithDefault([])
      ->Garter.Array.joinWith(" | ", block =>
        block->Array.map(Tool.toString)->Garter.Array.joinWith(" ", Garter.Fn.identity)
      )
    },
    ~images_upload_handler=initOptions->images_upload_handlerGet,
    ~image_upload_credentials=true,
    ~file_picker_types="image",
    ~table_responsive_width=true,
    ~content_css="/tinymce/skins/content/default/content.css",
    (),
  )

  let plugins' = plugins->Array.map(Plugin.toString)->Garter.Array.joinWith(" ", Garter.Fn.identity)

  <TinyMCE
    ?id
    ?name
    ?value
    ?onEditorChange
    init={init}
    ?initialValue
    ?disabled
    plugins={plugins'}
    tinymceScriptSrc="/tinymce/tinymce.min.js"
  />
}

module Viewer = {
  @react.component
  let make = (~id=?, ~name=?, ~value=?) => {
    <div id="editor-inline">
      <TinyMCE
        ?id ?name ?value disabled={true} inline={true} tinymceScriptSrc="/tinymce/tinymce.min.js"
      />
    </div>
  }
}
