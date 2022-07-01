type browser = {
  name: string,
  version: string,
  @as("type") type_: string,
  os: string,
}
@module("detect-browser")
external detect: unit => browser = "detect"
