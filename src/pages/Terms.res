@react.component
let make = () => {
  <>
    <Next.Head>
      <title> {j`서비스 이용약관 - 신선하이`->React.string} </title>
    </Next.Head>
    <div className=%twc("p-4 mx-auto w-full sm:w-2/3 lg:w-1/2")>
      <div className=%twc("flex justify-center items-center relative text-xl font-bold")>
        <h1> {j`신선하이 서비스 이용약관`->React.string} </h1>
        <span
          className=%twc("absolute right-0")
          onClick={_ => Webapi.Dom.history |> Webapi.Dom.History.back}>
          <IconClose height="32" width="32" fill="#262626" />
        </span>
      </div>
      <ol className=%twc("mt-8 leading-8")>
        <li>
          <h3 className=%twc("font-bold")> {j`제 1 조 【 목적 】`->React.string} </h3>
          <p>
            {j`신선하이 서비스 이용 시 ‘회사’가 요구하는 ‘고객’ 정보 및 제공되는 서비스는 다음과 같습니다.`->React.string}
          </p>
        </li>
        <li className=%twc("mt-4")>
          <h3 className=%twc("font-bold")> {j`제 2 조 【 용어 정의 】`->React.string} </h3>
          <p>
            {j`본 약관에서 사용하는 용어는 신용정보의 이용 및 보호에 관한 법률(이하 “법률”이라 한다)에서 정한 바에 따른다.`->React.string}
          </p>
        </li>
        <li className=%twc("mt-4")>
          <h3 className=%twc("font-bold")>
            {j`제 3 조 【 개인정보 및 추가활용 정보 】`->React.string}
          </h3>
          <p>
            {j`신선하이 서비스 이용 시 ‘회사’가 요구하는 ‘고객’ 정보 및 제공되는 서비스는 다음과 같습니다.`->React.string}
          </p>
          <ol className=%twc("ml-3 mt-3")>
            <li>
              {j`1. 고객 정보: 신청자 성함, 농가명, 신청자 연락처, 판매 작물 및 품종, 판매 가능시기, 재배 방식(노지농사, 하우스, 스마트팜 중), 대략적인 재배 면적, 재배 경력, 인증서(GAP, 무농약, 유기농, 저탄소 등), 현재 공급 거래처(이마트, 지역농협, 공판장, 네이버 스토어, 마켓컬리 등), 상품 구성과 스펙, 최저 공급가(택배비 포함), 상품 및 농가의 특장점, 택배 배송 가능여부, 농가 소개 정보(농장 주소, 재배 농작물명, 재배 기간, 온라인 판매 목적) 등`->React.string}
            </li>
            <li>
              {j`2. 제공서비스: 판매자를 통해 판매된 고객 정보, 마케팅 정보 활용을 위한 개인정보(첨부내용 참조)`->React.string}
            </li>
            <li>
              {j`3. 계좌이체: 고객 개인 계좌정보(예금주, 은행명, 계좌번호 기입)`->React.string}
            </li>
            <li>
              {j`4. 그 외 서비스 개발 등에 필요한 정보는 법률의 범위 하에 상호 협의 후 교환될 수 있다.`->React.string}
            </li>
          </ol>
        </li>
        <li className=%twc("mt-4")>
          <h3 className=%twc("font-bold")>
            {j`제 4 조 【 개인정보의 이용목적 】`->React.string}
          </h3>
          <p>
            {j`‘회사’는 ‘고객’의 개인정보 및 제3조의 정보내용을 다음 각 호의 목적으로만 이용할 수 있다.`->React.string}
          </p>
          <ol className=%twc("ml-3 mt-3")>
            <li>
              {j`1. 신용정보주체와의 금융거래 등 상거래관계의 설정 및 유지여부의 판단목적`->React.string}
            </li>
            <li> {j`2. 채권관리 및 민원에 대응할 목적`->React.string} </li>
            <li>
              {j`3. 서비스를 통한 ‘고객’과 판매자와의 중개매매 연결`->React.string}
            </li>
            <li>
              {j`4. 추후 서비스에서 업데이트 되는 기능 및 공지사항에 대한 마케팅 활용(선택사항)`->React.string}
            </li>
          </ol>
        </li>
        <li className=%twc("mt-4")>
          <h3 className=%twc("font-bold")> {j`제 5 조 【 사용기간 】`->React.string} </h3>
          <ol className=%twc("ml-3 mt-3")>
            <li>
              {j`1. 본 약관은 약관을 체결한 날로부터 효력이 발생하고 중도 해지의 경우 1개월 전에 서면 통보하여 한다.`->React.string}
            </li>
            <li>
              {j`2. 본 약관의 유효기간은 시행일로부터 1년간으로 하되, 기간 만료 1개월 전까지 서면에 의한 해지통지가 없는 경우 자동으로 1년씩 연장되는 것으로 한다.`->React.string}
            </li>
          </ol>
        </li>
        <li className=%twc("mt-4")>
          <h3 className=%twc("font-bold")>
            {j`제 6 조 【 개인정보 근거자료 보관 】`->React.string}
          </h3>
          <p>
            {j`‘회사’는 개인정보를 이용함에 있어 개인정보를 조회한 근거자료 조회일로부터 3년간 보관하여야 한다. 그 외 개인정보의 보유 및 이용기간에 대한 사항은 <개인정보 수집 및 마케팅 활용 동의서>에 따른다.`->React.string}
          </p>
        </li>
        <li className=%twc("mt-4")>
          <h3 className=%twc("font-bold")>
            {j`제 7 조 【 정보조회 방법 및 시간 】`->React.string}
          </h3>
          <ol className=%twc("ml-3 mt-3")>
            <li>
              {j`1. ‘회사’는 ‘고객’의 정보를 인터넷통신을 활용한 해당 ‘서비스’를 통해서 이용한다.`->React.string}
            </li>
            <li>
              {j`2. ‘고객’이 제공하는 정보에 대한 ‘회사’의 조회가능시간은 연중 00:00~24:00으로 한다.`->React.string}
            </li>
            <li>
              {j`3. ‘회사’는 ‘고객’이 제공하는 정보를 ‘고객’의 동의 없이 제3자 및 기타 방법으로 이용할 수 없다.`->React.string}
            </li>
          </ol>
        </li>
        <li className=%twc("mt-4")>
          <h3 className=%twc("font-bold")> {j`제 8 조 【 대금결재 】`->React.string} </h3>
          <ol className=%twc("ml-3 mt-3")>
            <li>
              {j`1. ‘회사’는 ‘고객’에게 판매자가 신선하이에서 월요일~일요일까지 1주일 간 결제한 건에 대해 차주 목요일에 제3조에 ‘고객’이 기입한 계좌 정보에 따라 계좌이체 한다.`->React.string}
            </li>
            <li> {j`2. *세금계산서 발행기간 추가 기입`->React.string} </li>
            <li>
              {j`3. 가격 변경이 필요한 경우, 3일 전에 ‘회사’측에 정정 요청을 하고, 만약 사전 협의가 안된 경우에 기존 고객이 제공한 가격으로 한다.`->React.string}
            </li>
          </ol>
        </li>
        <li className=%twc("mt-4")>
          <h3 className=%twc("font-bold")>
            {j`제 9 조 【 책임과 의무 】`->React.string}
          </h3>
          <ol className=%twc("ml-3 mt-3")>
            <li>
              {j`1. ‘고객’은 ‘회사’의 담당자와 사전협의가 없는 경우 발주서를 받은 후 주말,공휴일을 제외하고 영업일 2일 내로 발송을 원칙으로 한다. 단, 배송 지연 시 이에 대한 책임은 ‘고객’이 책임진다.`->React.string}
            </li>
            <li>
              {j`2. ‘고객’이 ‘회사’에 제공한 상품 정보와 상이하거나 판매자의 발주서 기준에 미달한 제품이 고객에게 배송되었을 경우, 이에 대한 반품 및 교환의 책임은 ‘고객’이 부담한다.`->React.string}
            </li>
            <li>
              {j`3. ‘회사’는 대금지급 관련 신용공여 및 실명확인 등의 업무상 필요한 경우에만 ‘고객’에게 정보제공을 요청할 수 있다.`->React.string}
            </li>
            <li>
              {j`4. ‘회사’는 ‘고객’의 개인정보를 타 기관, 업체, 개인 등 ‘고객’의 사전 승인하지 않은 제 3자에게 누설되지 않도록 통신 시 필요한 자료의 암호화에 최선을 다한다.`->React.string}
            </li>
            <li>
              {j`5. ‘고객’과 ‘회사’는 업무수행 중 취득한 영업비밀 및 정보를 업무와 관계없는 용도에 사용할 수 없다.`->React.string}
            </li>
            <li>
              {j`6. ‘고객’과 ‘회사’는 제공한 정보의 사실여부에 대한 분쟁이 발생할 경우 상대방에게 성실히 해명하여야 한다.`->React.string}
            </li>
          </ol>
        </li>
        <li className=%twc("mt-4")>
          <h3 className=%twc("font-bold")>
            {j`제 10 조 【 약관의 해지 】`->React.string}
          </h3>
          <ol className=%twc("ml-3 mt-3")>
            <li>
              {j`1. 다음 각 호에 해당하는 경우 양 당사자는 약관을 즉시 해지할 수 있다.`->React.string}
            </li>
            <ol className=%twc("ml-3")>
              <li>
                {j`1) 제4조 각 항의 목적 이외로 정보를 이용한 경우`->React.string}
              </li>
              <li>
                {j`2) 제9조 각 항에 규정된 사항을 위반한 경우`->React.string}
              </li>
              <li>
                {j`3) ‘회사’가 ‘고객’에게 이체해야 할 대금 지급을 2개월 이상 연체한 경우`->React.string}
              </li>
            </ol>
            <li>
              {j`2. 약관해지 후에는 ‘회사’는 ‘고객’의 신용정보를 이용할 수 없다.`->React.string}
            </li>
          </ol>
        </li>
        <li className=%twc("mt-4")>
          <h3 className=%twc("font-bold")> {j`제 11 조 【 관할법원 】`->React.string} </h3>
          <p>
            {j`본 약관에 정하지 않은 사항은 일반 상관습에 따르되 본 약관과 관련된 소송의 관할법원은 ‘회사’의 소재지 관할법원인 서울동부지방법원으로 한다.`->React.string}
          </p>
        </li>
        <li className=%twc("mt-4")>
          <h3 className=%twc("font-bold")>
            {j`제 12 조 【 약관 보관 및 효력 】`->React.string}
          </h3>
          <p>
            {j`본 약관의 성립을 증명하기 위해 ‘고객’과 ‘회사’는 본 약관에 대한 ‘고객’의 동의를 받고, ‘고객’이 직접 개인정보 수집 및 마케팅 활용 동의서를 추가 작성하는 것으로 한다.`->React.string}
          </p>
        </li>
      </ol>
    </div>
  </>
}
