type isShow = Show | Hide

module BtnSection = {
  @react.component
  let make = (~confirmText, ~cancelText, ~onConfirm=?, ~onCancel) => {
    switch onConfirm {
    | Some(onConfirm') =>
      <div className=%twc("grid grid-cols-2 gap-2 px-5 pb-5 mt-4")>
        <button
          className=%twc("h-13 bg-gray-100 rounded-xl text-gray-800 focus:outline-none")
          onClick={onCancel}>
          {cancelText->React.string}
        </button>
        <button
          className=%twc(
            "h-13 bg-green-500 hover:bg-green-600 rounded-xl text-white font-bold focus:outline-none"
          )
          onClick={onConfirm'}>
          {confirmText->React.string}
        </button>
      </div>

    | None =>
      <div className=%twc("w-full flex px-5 pb-5 mt-4")>
        <button
          className=%twc(
            "h-13 bg-gray-100 rounded-xl text-gray-800 flex flex-1 items-center justify-center"
          )
          onClick={onCancel}>
          {cancelText->React.string}
        </button>
      </div>
    }
  }
}

module Mo = {
  @react.component
  let make = (
    ~isShow,
    ~confirmText=`확인`,
    ~cancelText=`취소`,
    ~onConfirm=?,
    ~onCancel,
    ~children=?,
  ) => {
    let _open = switch isShow {
    | Show => true
    | Hide => false
    }

    <RadixUI.Dialog.Root _open>
      <RadixUI.Dialog.Portal>
        <RadixUI.Dialog.Overlay className=%twc("dialog-overlay") />
        <RadixUI.Dialog.Content
          className=%twc(
            "dialog-content-base bg-white rounded-xl w-[calc(100vw-40px)] max-w-[calc(768px-40px)]"
          )
          onPointerDownOutside={onCancel}>
          {children->Option.getWithDefault(React.null)}
          <BtnSection confirmText cancelText ?onConfirm onCancel />
        </RadixUI.Dialog.Content>
      </RadixUI.Dialog.Portal>
    </RadixUI.Dialog.Root>
  }
}

@react.component
let make = (
  ~isShow,
  ~confirmText=`확인`,
  ~cancelText=`취소`,
  ~onConfirm=?,
  ~onCancel,
  ~children=?,
) => {
  let _open = switch isShow {
  | Show => true
  | Hide => false
  }

  <RadixUI.Dialog.Root _open>
    <RadixUI.Dialog.Portal>
      <RadixUI.Dialog.Overlay className=%twc("dialog-overlay") />
      <RadixUI.Dialog.Content
        className=%twc("dialog-content-base bg-white rounded-xl w-[480px]")
        onPointerDownOutside={onCancel}>
        {children->Option.getWithDefault(React.null)}
        <BtnSection confirmText cancelText ?onConfirm onCancel />
      </RadixUI.Dialog.Content>
    </RadixUI.Dialog.Portal>
  </RadixUI.Dialog.Root>
}
