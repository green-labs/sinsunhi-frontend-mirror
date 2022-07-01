type isShow = Show | Hide
type kindOfConfirm = Positive | Negative

module ButtonBox = {
  @react.component
  let make = (
    ~onCancel=?,
    ~onConfirm=?,
    ~textOnCancel=?,
    ~textOnConfirm=?,
    ~kindOfConfirm=?,
    ~confirmBg=?,
    ~confirmTextColor=?,
  ) => {
    <div className=%twc("flex flex-row p-7")>
      {switch onCancel {
      | Some(f) =>
        <button
          type_="button"
          className={cx([%twc("flex-1 justify-center py-3 mr-2"), %twc("btn-level6")])}
          onClick=f>
          {textOnCancel->Option.getWithDefault(`취소`)->React.string}
        </button>
      | None => React.null
      }}
      {switch (onConfirm, textOnConfirm) {
      // textOnConfirm이 빈 문자열이면 버튼 미노출
      | (Some(_), Some("")) => React.null
      | (Some(f), None) | (Some(f), Some(_)) =>
        <button
          type_="button"
          className={switch kindOfConfirm {
          | Some(kindOfConfirm') =>
            switch kindOfConfirm' {
            | Positive => cx([%twc("flex-1 justify-center py-3"), %twc("btn-level1")])
            | Negative => cx([%twc("flex-1 justify-center py-3"), %twc("btn-level4")])
            }
          | None =>
            %twc(
              "flex-1 justify-center rounded-xl border border-transparent shadow-sm py-3 bg-green-gl hover:bg-green-gl-dark focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-green-gl focus:ring-opacity-100 text-white font-bold"
            )
          }}
          style={switch (confirmBg, confirmTextColor) {
          | (Some(bgColor), Some(textColor)) =>
            ReactDOMStyle.make(~backgroundColor=bgColor, ~color=textColor, ())
          | _ => ReactDOMStyle.make()
          }}
          onClick=f>
          {textOnConfirm->Option.getWithDefault(`확인`)->React.string}
        </button>
      | (None, _) => React.null
      }}
    </div>
  }
}

@react.component
let make = (
  ~isShow,
  ~children,
  ~onCancel=?,
  ~onConfirm=?,
  ~textOnCancel=?,
  ~textOnConfirm=?,
  ~kindOfConfirm=?,
  ~confirmBg=?,
  ~confirmTextColor=?,
  ~boxStyle=?,
) => {
  let _open = switch isShow {
  | Show => true
  | Hide => false
  }

  let boxBase = %twc("dialog-content")
  let boxClassName = switch boxStyle {
  | Some(boxStyle') => cx([boxBase, boxStyle'])
  | None => boxBase
  }

  <RadixUI.Dialog.Root _open>
    <RadixUI.Dialog.Portal>
      <RadixUI.Dialog.Overlay className=%twc("dialog-overlay") />
      <RadixUI.Dialog.Content className=boxClassName>
        <div className=%twc("pt-10 px-7")> {children} </div>
        <ButtonBox
          ?onCancel
          ?onConfirm
          ?textOnConfirm
          ?textOnCancel
          ?kindOfConfirm
          ?confirmBg
          ?confirmTextColor
        />
      </RadixUI.Dialog.Content>
    </RadixUI.Dialog.Portal>
  </RadixUI.Dialog.Root>
}
