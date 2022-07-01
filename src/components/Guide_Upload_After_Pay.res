@react.component
let make = () =>
  <div className=%twc("container max-w-lg mx-auto sm:mt-4 sm:shadow-gl mb-10")>
    <RadixUI.Accordian.Root _type=#multiple>
      <RadixUI.Accordian.Item value="guide-1">
        <RadixUI.Accordian.Header>
          <RadixUI.Accordian.Trigger className=%twc("w-full focus:outline-none accordian-trigger")>
            <div className=%twc("flex justify-between py-6 px-7 bg-white border-b border-gray-100")>
              <span className=%twc("font-bold")>
                {j`주문서 업로드 사용설명서`->React.string}
              </span>
              <IconArrowSelect
                height="24" width="24" fill="#121212" className=%twc("accordian-icon")
              />
            </div>
          </RadixUI.Accordian.Trigger>
        </RadixUI.Accordian.Header>
        <RadixUI.Accordian.Content className=%twc("accordian-content")>
          <section className=%twc("p-7 text-sm bg-gray-gl")>
            <h4 className=%twc("text-gray-500 font-semibold")>
              {j`주문서 업로드 사용설명서`->React.string}
            </h4>
            <div className=%twc("flex mt-5")>
              <a href="/buyer/products/advanced-search" target="_blank" className=%twc("flex-1")>
                <span
                  className=%twc(
                    "block text-center p-3 rounded-xl border border-green-gl text-base font-bold text-green-gl mr-2 bg-white"
                  )>
                  {j`운영 코드 확인`->React.string}
                </span>
              </a>
              <a href=Env.buyerUploadGuideUri className=%twc("flex-1") target="_blank">
                <span
                  className=%twc(
                    "block text-center p-3 rounded-xl border border-green-gl text-base font-bold text-green-gl bg-white"
                  )>
                  {j`발주 메뉴얼 보기`->React.string}
                </span>
              </a>
            </div>
            <div className=%twc("leading-6 mt-4")>
              <h5 className=%twc("font-bold")> {j`1. 주문서 양식`->React.string} </h5>
              <ul className=%twc("ml-3")>
                <li>
                  <h6> {j`• 방식`->React.string} </h6>
                  <ul className=%twc("ml-3")>
                    <li>
                      <span className=%twc("font-bold")>
                        {j`- 상품 및 옵션 코드 번호 부여`->React.string}
                      </span>
                      {j` : 상품 페이지 확인 가능 / 미 작성시 출고 불가`->React.string}
                    </li>
                  </ul>
                </li>
              </ul>
              <h5 className=%twc("font-bold mt-4")>
                {j`2. 주문서 마감시간`->React.string}
              </h5>
              <ul className=%twc("ml-3")>
                <li>
                  <span className=%twc("font-bold")>
                    {j`• 오전 10시 이전 주문서 전달 시 당일 출고`->React.string}
                  </span>
                  {j` - 당일 출고 주문건에 한해 주문서 수정 및 취소건 반영(운송장 번호 발생시 수정 및 취소 불가)`->React.string}
                </li>
                <li>
                  <span className=%twc("font-bold")>
                    {j`• 오전 10시 이후 주문서 전달 시 익일 출고`->React.string}
                  </span>
                  {j` - 익일 출고 주문건에 한해 이메일 확인은 하지 않으며, 별도의 수정 및 취소건 발생시 익일 10시 이전수정 완료된 주문건으로 "재 전달" 요청`->React.string}
                </li>
                <li>
                  <span>
                    {j`• 일부 상품의 주문서 마감 시간 상이`->React.string}
                  </span>
                  <ul className=%twc("ml-3")>
                    <li>
                      {j`- 일부 상품에 한해 오전 9시 이전 주문서 전달 시 당일 출고`->React.string}
                    </li>
                    <li>
                      {j`- 오전 9시 이후 주문서 전달 시 익일 출고`->React.string}
                    </li>
                    <li>
                      {j`- 주문서 마감 시간은 신선하이 상세페이지 또는 상단 상품 페이지(상품 및 옵션 코드번호 안내 상품 페이지) 내에서 확인 가능합니다.`->React.string}
                    </li>
                  </ul>
                </li>
              </ul>
              <h5 className=%twc("font-bold mt-4")>
                {j`3. 안내 및 문의사항`->React.string}
              </h5>
              <ul className=%twc("ml-3")>
                <li>
                  {j`• 상품 및 옵션 코드 번호 `->React.string}
                  <span className=%twc("text-red-500")>
                    {j`작성 오류로 인한 출고 오류의 건 책임 불가`->React.string}
                  </span>
                </li>
                <li>
                  {j`• 신선하이는 바이어분들의 작성 주문서를 내부 시스템에 업로드 하는 형식으로 운영됩니다. 위에 안내된 상품 페이지를 확인하시어 신선하이의 `->React.string}
                  <span className=%twc("font-bold")>
                    {j`상품 및 옵션 코드 번호는 바이어분들께서 입력 해주셔야합니다.`->React.string}
                  </span>
                  {j` 상품 및 옵션 코드 번호 작성 오류로 인한 오 배송건, 배송 지연등은 신선하이에서 책임을 지지 않습니다.`->React.string}
                </li>
                <li>
                  {j`• 이점 유의 하시어 주문서 작성 부탁드립니다.`->React.string}
                </li>
                <li className=%twc("mt-4")>
                  {j`• 해당 발주서는 바이어분들께서 소비자들에게 "판매완료"한 상품의 발주서입니다. 샘플 구매 또한 발주서에 기입해 업로드해주셔야 합니다.`->React.string}
                </li>
              </ul>
            </div>
          </section>
        </RadixUI.Accordian.Content>
      </RadixUI.Accordian.Item>
      <RadixUI.Accordian.Item value="guide-2">
        <RadixUI.Accordian.Header>
          <RadixUI.Accordian.Trigger className=%twc("w-full focus:outline-none accordian-trigger")>
            <div className=%twc("flex justify-between py-6 px-7 bg-white")>
              <span className=%twc("font-bold")> {j`주문취소 방법`->React.string} </span>
              <IconArrowSelect
                height="24" width="24" fill="#121212" className=%twc("accordian-icon")
              />
            </div>
          </RadixUI.Accordian.Trigger>
        </RadixUI.Accordian.Header>
        <RadixUI.Accordian.Content className=%twc("accordian-content")>
          <section className=%twc("p-7 text-sm bg-gray-gl whitespace-pre")>
            {j`신규주문건만  주문내역 조회 페이지를 통해 취소가 가능합니다.

배송준비중 주문건 취소가 필요할 경우
취소 요청양식에 맞게 작성해
`->React.string}
            <span className=%twc("font-bold")> {j`farmhub@greenlabs.co.kr`->React.string} </span>
            {j`로 접수해주세요.
(농가 확인 후 취소가 불가능 할 수도 있습니다.)

*메일 제목 : [취소요청건] 바이어명_날짜  `->React.string}
            <div>
              <a
                href="https://freshmarket-farmmorning.co.kr/notice/?q=YToxOntzOjEyOiJrZXl3b3JkX3R5cGUiO3M6MzoiYWxsIjt9&bmode=view&idx=7414754&t=board"
                target="_blank"
                className=%twc("inline-block underline mt-6")>
                {j`자세히 보러가기`->React.string}
              </a>
            </div>
          </section>
        </RadixUI.Accordian.Content>
      </RadixUI.Accordian.Item>
    </RadixUI.Accordian.Root>
  </div>
