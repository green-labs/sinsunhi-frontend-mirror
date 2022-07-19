@react.component
let make = (~onConfirmed, ~isMarketing, ~setMarketing) => {
  let (isAgreedAll, setAgreedAll) = React.Uncurried.useState(_ => false) // 전체 내용에 동의
  let (isBasic, setBasic) = React.Uncurried.useState(_ => false) // 신선하이 이용약관 동의
  let (isPersonalInformation, setPersonalInformation) = React.Uncurried.useState(_ => false) // 개인정보 수집 이용 동의

  let handleOnChangeAgreeAll = e => {
    let value = (e->ReactEvent.Synthetic.target)["checked"]
    setAgreedAll(._ => value)
  }
  let handleOnChangeBasic = e => {
    let value = (e->ReactEvent.Synthetic.target)["checked"]
    setBasic(._ => value)
  }
  let handleOnChangePersonalInformation = e => {
    let value = (e->ReactEvent.Synthetic.target)["checked"]
    setPersonalInformation(._ => value)
  }
  let handleOnChangeMarketing = e => {
    let value = (e->ReactEvent.Synthetic.target)["checked"]
    setMarketing(._ => value)
  }

  React.useEffect1(_ => {
    if isAgreedAll {
      setBasic(._ => true)
      setPersonalInformation(._ => true)
      setMarketing(._ => true)
    } else if isBasic && isPersonalInformation && isMarketing {
      setBasic(._ => false)
      setPersonalInformation(._ => false)
      setMarketing(._ => false)
    }

    None
  }, [isAgreedAll])

  React.useEffect3(_ => {
    switch (isBasic, isPersonalInformation, isMarketing) {
    | (true, true, true) => {
        setAgreedAll(._ => true)
        onConfirmed(true)
      }
    | (true, true, false) => {
        setAgreedAll(._ => false)
        onConfirmed(true)
      }
    | _ => {
        setAgreedAll(._ => false)
        onConfirmed(false)
      }
    }

    None
  }, (isBasic, isPersonalInformation, isMarketing))

  <div className=%twc("py-4")>
    <div className=%twc("flex items-center mt-2")>
      <span className=%twc("mr-2")>
        <Checkbox
          id="agree-all" name="agree-all" checked=isAgreedAll onChange=handleOnChangeAgreeAll
        />
      </span>
      <span className=%twc("font-bold text-text-L1")>
        {`전체 내용에 동의합니다`->React.string}
      </span>
    </div>
    <div className=%twc("flex justify-between items-center mt-2")>
      <div className=%twc("flex items-center")>
        <span className=%twc("mr-2")>
          <Checkbox id="terms" name="terms" checked=isBasic onChange=handleOnChangeBasic />
          <input type_="checkbox" className=%twc("hidden") />
        </span>
        <span className=%twc("text-text-L1")>
          {`신선하이 이용약관(필수)`->React.string}
        </span>
      </div>
      <Next.Link href="/terms">
        <span> <IconArrow height="20" width="20" stroke="#DDDDDD" /> </span>
      </Next.Link>
    </div>
    <div className=%twc("flex justify-between items-center mt-2")>
      <div className=%twc("flex items-center")>
        <span className=%twc("mr-2")>
          <Checkbox
            id="privacy"
            name="privacy"
            checked=isPersonalInformation
            onChange=handleOnChangePersonalInformation
          />
        </span>
        <span className=%twc("text-text-L1")>
          {`개인정보 수집·이용(필수)`->React.string}
        </span>
      </div>
      <Next.Link href="/privacy">
        <span> <IconArrow height="20" width="20" stroke="#DDDDDD" /> </span>
      </Next.Link>
    </div>
    <div className=%twc("flex items-center mt-2")>
      <span className=%twc("mr-2")>
        <Checkbox
          id="marketing" name="marketing" checked=isMarketing onChange=handleOnChangeMarketing
        />
      </span>
      <span className=%twc("text-text-L1")>
        {`할인쿠폰·이벤트 등 마케팅 정보 수신(선택)`->React.string}
      </span>
    </div>
  </div>
}
