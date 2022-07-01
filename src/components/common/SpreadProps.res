/**
 * 커스텀 prop을 전달하여 사용할 수 있는 리액트 컴포넌트 모듈
 * powered by @jeong-sik
 * https://github.com/green-labs/morningnote-re/pull/1050#issuecomment-804661387
 *
 * 사용 예
 * <SpreadProps props={"data-gtm": `home_mainbanner_n${idx}`}>
 *   <div />
 * </SpreadProps>
 */
@react.component
let make = (~children, ~props) => {
  React.cloneElement(children, props)
}
