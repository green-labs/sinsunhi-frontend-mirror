open ReactHookForm

@react.component
let make = (~control, ~name, ~disabled) => {
  let {errors} = Hooks.FormState.use(. ~config=Hooks.FormState.config(~control))

  <>
    <div className=%twc("flex gap-2 h-9")> <Select_Product_Category control name disabled /> </div>
    <ErrorMessage
      name
      errors
      render={_ =>
        <span className=%twc("flex")>
          <IconError width="20" height="20" />
          <span className=%twc("text-sm text-notice ml-1")>
            {`표준카테고리를 입력해주세요.`->React.string}
          </span>
        </span>}
    />
  </>
}
