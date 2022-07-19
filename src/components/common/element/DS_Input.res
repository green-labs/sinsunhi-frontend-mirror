module InputText1 = {
  @react.component
  let make = (
    ~type_,
    ~className=?,
    ~placeholder=?,
    ~value=?,
    ~onChange=?,
    ~disabled=?,
    ~autoFocus=?,
    ~inputMode=?,
    ~maxLength=?,
    ~onFocus=?,
    ~onBlur=?,
  ) => {
    <input
      type_
      className={className->Option.mapWithDefault(
        %twc("w-full outline-none text-xl placeholder:text-gray-400 disabled:bg-white leading-8"),
        className' =>
          cx([
            %twc(
              "w-full outline-none text-xl placeholder:text-gray-400 disabled:bg-white leading-8"
            ),
            className',
          ]),
      )}
      ?onFocus
      ?onBlur
      ?placeholder
      ?value
      ?onChange
      ?disabled
      ?autoFocus
      ?inputMode
      ?maxLength
    />
  }
}
