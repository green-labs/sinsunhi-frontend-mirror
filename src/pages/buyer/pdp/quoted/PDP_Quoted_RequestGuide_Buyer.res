module PC = {
  @react.component
  let make = () => {
    <div className=%twc("w-full flex flex-col gap-4")>
      <h1 className=%twc("text-text-L1 font-bold text-lg")> {`견적 안내`->React.string} </h1>
      <div className=%twc("w-full bg-surface p-4 rounded-lg")>
        <span className=%twc("text-text-L1 text-base")>
          {`15시까지 견적 요청 시 16시에 최저가 견적을 받아볼 수 있습니다.`->React.string}
        </span>
      </div>
    </div>
  }
}

module MO = {
  @react.component
  let make = () => {
    <div className=%twc("w-full flex flex-col gap-4")>
      <h1 className=%twc("text-text-L1 font-bold text-lg")> {`견적 안내`->React.string} </h1>
      <div className=%twc("w-full bg-surface p-4 rounded-lg")>
        <span className=%twc("text-text-L1")>
          {`15시까지 견적 요청 시 16시에 최저가 견적을 받아볼 수 있습니다.`->React.string}
        </span>
      </div>
    </div>
  }
}
