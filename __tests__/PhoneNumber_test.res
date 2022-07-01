open Jest
open Helper.PhoneNumber

describe("TEST Parser PhoneNumber", () => {
  open Expect

  test("mobile number - 010", () => {
    expect("01012345678"->parse->Option.flatMap(format)) |> toEqual(Some("010-1234-5678"))
  })
  test("mobile number - 011", () => {
    expect("0111234567"->parse->Option.flatMap(format)) |> toEqual(Some("011-123-4567"))
  })
  test("mobile number - 016", () => {
    expect("0161234567"->parse->Option.flatMap(format)) |> toEqual(Some("016-123-4567"))
  })
  test("mobile number - 017", () => {
    expect("0171234567"->parse->Option.flatMap(format)) |> toEqual(Some("017-123-4567"))
  })
  test("mobile number - 018", () => {
    expect("0181234567"->parse->Option.flatMap(format)) |> toEqual(Some("018-123-4567"))
  })
  test("mobile number - 019", () => {
    expect("0191234567"->parse->Option.flatMap(format)) |> toEqual(Some("019-123-4567"))
  })
  test("mobile number - 02-{3}-{4}", () => {
    expect("021234567"->parse->Option.flatMap(format)) |> toEqual(Some("02-123-4567"))
  })
  test("mobile number - 02-{4}-{4}", () => {
    expect("0212345678"->parse->Option.flatMap(format)) |> toEqual(Some("02-1234-5678"))
  })
  test("mobile number - 031-{3}-{4}", () => {
    expect("0311234567"->parse->Option.flatMap(format)) |> toEqual(Some("031-123-4567"))
  })
  test("mobile number - 031-{4}-{4}", () => {
    expect("03112345678"->parse->Option.flatMap(format)) |> toEqual(Some("031-1234-5678"))
  })
  test("mobile number - 070-{4}-{4}", () => {
    expect("07012345678"->parse->Option.flatMap(format)) |> toEqual(Some("070-1234-5678"))
  })
  test("mobile number - 0504-{4}-{4}", () => {
    expect("050212345678"->parse->Option.flatMap(format)) |> toEqual(Some("0502-1234-5678"))
  })
})
