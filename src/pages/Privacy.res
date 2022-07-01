@react.component
let make = () => {
  <>
    <Next.Head>
      <title> {j`개인 정보 수집이용 동의 - 신선하이`->React.string} </title>
    </Next.Head>
    <div className=%twc("p-4 mx-auto w-full sm:w-2/3 lg:w-1/2")>
      <div className=%twc("flex justify-center items-center relative text-xl font-bold")>
        <h1> {j`개인 정보 수집이용 동의 `->React.string} </h1>
        <span
          className=%twc("absolute right-0")
          onClick={_ => Webapi.Dom.history |> Webapi.Dom.History.back}>
          <IconClose height="32" width="32" fill="#262626" />
        </span>
      </div>
      <p className=%twc("mt-8")>
        {j`(주)그린랩스는 원활한 서비스 제공을 위해 최소한의 범위 내에서 아래와 같이 개인정보를 수정·이용합니다.`->React.string}
      </p>
      <ol className=%twc("mt-8 leading-8")>
        <li>
          <h3 className=%twc("font-bold")>
            {j`1. 개인정보의 수집 및 이용 목적`->React.string}
          </h3>
          <ol>
            <li>
              {j`1) 성명, 농가주소, 연락처 등 : 신선하이 판매자 중개 및 서비스 이용 안내`->React.string}
            </li>
            <ul className=%twc("ml-3")>
              <li>
                {j`- 연락처 및 이메일 주소 : 소식 및 고지사항 전달, 불만처리, 추후 ㈜그린랩스 스마트팜 기기 및 농자재 유통 등의 마케팅 활용을 위한 경로 확보`->React.string}
              </li>
            </ul>
          </ol>
        </li>
        <li className=%twc("mt-4")>
          <h3 className=%twc("font-bold")>
            {j`2. 개인정보의 보유 및 이용기간`->React.string}
          </h3>
          <ul className=%twc("ml-3")>
            <li>
              {j`- ㈜그린랩스는 수집된 고객의 개인정보를 진료정보를 보관하는 법정 기간(5년)동안만 보유하며 그 이후는 DB에서 삭제하고 있습니다.`->React.string}
            </li>
            <li>
              {j`- 정보제공자가 개인정보 삭제를 요청할 경우 즉시 삭제합니다.`->React.string}
            </li>
            <li>
              {j`단, 타법령의 규정에 의해 보유하도록 한 기간 동안은 보관할 수 있습니다.`->React.string}
            </li>
          </ul>
          <ul className=%twc("ml-3 mt-3 whitespace-pre")>
            <li>
              {j`소비자의 불만 또는 분쟁처리에 관한 기록 : `->React.string}
              <span className=%twc("font-bold")> {j`3년\n`->React.string} </span>
              {j`(전자상거래 등에서의 소비자보호에 관한 법률)`->React.string}
            </li>
            <li className=%twc("mt-3")>
              {j`신용정보의 수집/처리 및 이용 등에 관한 기록 : `->React.string}
              <span className=%twc("font-bold")> {j`3년\n`->React.string} </span>
              {j`(신용정보의 이용 및 보호에 관한 법률)`->React.string}
            </li>
            <li className=%twc("mt-3")>
              {j`본인 확인에 관한 기록 : `->React.string}
              <span className=%twc("font-bold")> {j`6개월\n`->React.string} </span>
              {j`(정보통신망 이용촉진 및 정보보호 등에 관한 법률)`->React.string}
            </li>
          </ul>
        </li>
        <li className=%twc("mt-4")>
          <h3 className=%twc("font-bold")>
            {j`3. 개인정보 제공 동의 거부 권리 및 동의 거부 따른 불이익 내용 또는 제한사항`->React.string}
          </h3>
          <p>
            {j`㈜그린랩스는 귀하는 개인정보 제공 동의를 거부할 권리가 있으며, 동의 거부에 따른 불이익은 없음, 다만, 신선하이 판매자와의 연결 및 관련 정보 제공 안내 서비스를 받을 수 없음.`->React.string}
          </p>
        </li>
      </ol>
    </div>
  </>
}
