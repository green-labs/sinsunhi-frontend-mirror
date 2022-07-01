// <DS_Toast.Normal.Root>
//   <DS_Toast.Normal.IconSuccess />
//   <DS_Toast.Normal.Content>
//     {j`This is an awesome Toast`->React.string}
//   </DS_Toast.Normal.Content>
// </DS_Toast.Normal.Root>
module Normal = {
  module IconSuccess = {
    @react.component
    let make = () =>
      <span className=%twc("min-w-[24px] mr-1")>
        <DS_Icon.Common.LineCheckedLarge1 height="24" width="24" fill="#12B564" />
      </span>
  }

  module IconError = {
    @react.component
    let make = () =>
      <span className=%twc("min-w-[24px] mr-1")> <IconError height="24" width="24" /> </span>
  }

  module Root = {
    @react.component
    let make = (~children) =>
      <div className=%twc("w-full flex items-center truncate")> children </div>
  }

  module Content = {
    @react.component
    let make = (~children) =>
      <span className=%twc("text-white truncate tracking-tight")> children </span>
  }
}

let getToastComponent = (text: string, appearance: [#succ | #error]) => {
  <Normal.Root>
    {switch appearance {
    | #succ => <Normal.IconSuccess />
    | #error => <Normal.IconError />
    }}
    <Normal.Content> {text->React.string} </Normal.Content>
  </Normal.Root>
}
