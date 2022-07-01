@react.component
let make = (~accordianItemValue, ~head, ~children, ~openedAdminMenu, ~setOpenedAdminMenu) => {
  let onValueChange = arr => {
    // onValueChange의 인자인 arr에 accordianItemValue이 포함되어있다면,
    // 메뉴가 펼쳐진 상태, 그렇지 않다면 메뉴가 닫힌 상태이다.
    let newOpenedAdminMenu = if arr->Array.some(x => x == accordianItemValue) {
      openedAdminMenu->Set.String.fromArray->Set.String.add(accordianItemValue)->Set.String.toArray
    } else {
      openedAdminMenu
      ->Set.String.fromArray
      ->Set.String.remove(accordianItemValue)
      ->Set.String.toArray
    }

    setOpenedAdminMenu(newOpenedAdminMenu)
  }

  <RadixUI.Accordian.RootMultiple
    _type=#multiple className=%twc("text-text-L1") value={openedAdminMenu} onValueChange>
    <RadixUI.Accordian.Item value=accordianItemValue>
      <RadixUI.Accordian.Header>
        <RadixUI.Accordian.Trigger
          className=%twc(
            "flex flex-row items-center w-72 bg-white accordian-trigger hover:bg-div-border-L2 cursor-pointer"
          )>
          head
        </RadixUI.Accordian.Trigger>
      </RadixUI.Accordian.Header>
      <RadixUI.Accordian.Content className=%twc("accordian-content")>
        <ul className=%twc("flex flex-col")> children </ul>
      </RadixUI.Accordian.Content>
    </RadixUI.Accordian.Item>
  </RadixUI.Accordian.RootMultiple>
}
