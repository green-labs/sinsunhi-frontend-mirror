module Box = {
  @react.component
  let make = (~className=?) => {
    <div
      className={cx([
        %twc("flex h-6 animate-pulse rounded-lg bg-gray-100 my-0.5"),
        switch className {
        | Some(className') => className'
        | None => ""
        },
      ])}
    />
  }
}
