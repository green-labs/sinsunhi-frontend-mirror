@react.component
let make = () =>
  <div className=%twc("container max-w-lg mx-auto sm:mt-4 sm:shadow-gl mb-10")>
    <RadixUI.Accordian.RootMultiple _type=#multiple>
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
                  {j`상품・단품번호 확인`->React.string}
                </span>
              </a>
              <a href=Env.buyerUploadGuideUri className=%twc("flex-1") target="_blank">
                <span
                  className=%twc(
                    "block text-center p-3 rounded-xl border border-green-gl text-base font-bold text-green-gl bg-white"
                  )>
                  {j`주문 메뉴얼 보기`->React.string}
                </span>
              </a>
            </div>
            <div className=%twc("leading-6 mt-4")>
              <h5 className=%twc("font-bold")> {j`1. 주문서 양식`->React.string} </h5>
              <ul className=%twc("ml-3")>
                <li>
                  <h6> {j`• 방식`->React.string} </h6>
                  <ul className=%twc("ml-3")>
                    <li className=%twc("flex gap-1")>
                      <span className=%twc("min-w-max font-bold")>
                        {j`- 상품・단품번호:`->React.string}
                      </span>
                      <div className=%twc("inline sm:whitespace-pre-wrap")>
                        <a
                          id="link-of-upload-guide"
                          href="/buyer/products/advanced-search"
                          target="_blank">
                          <p className=%twc("inline cursor-pointer hover:underline")>
                            {`상품 페이지(클릭)`->React.string}
                          </p>
                        </a>
                        {` 에서 상품 검색하여 확인.\n유효하지 않은 번호 기입시 주문서 업로드 실패.`->React.string}
                      </div>
                    </li>
                  </ul>
                </li>
              </ul>
              <h5 className=%twc("font-bold mt-4")>
                {j`2. 주문서 마감시간`->React.string}
              </h5>
              <ul className=%twc("ml-3")>
                <li>
                  {j`• 오전 10시 이전 주문서 업로드 성공할 경우 당일 출고`->React.string}
                </li>
                <li>
                  {j`• 오전 10시 이후 주문서 업로드 성공할 경우 익일 출고`->React.string}
                </li>
                <li className=%twc("flex gap-1")>
                  {j`*`->React.string}
                  <span className=%twc("sm:whitespace-pre-wrap")>
                    {j`일부 상품은 출고시간이 상이한 경우가 있으므로 \n상품별 출고 마감시간은 `->React.string}
                    <a
                      id="link-of-upload-guide"
                      href="/buyer/products/advanced-search"
                      target="_blank">
                      <p className=%twc("inline cursor-pointer hover:underline")>
                        {`상품 페이지(클릭)`->React.string}
                      </p>
                    </a>
                    {` 에서 상품 검색하여 확인 요망`->React.string}
                  </span>
                </li>
              </ul>
              <h5 className=%twc("font-bold mt-4")> {j`3. 주의사항`->React.string} </h5>
              <ul className=%twc("ml-3")>
                <li>
                  {j`• 상품・단품번호 오기입 등 주문서 내용 오류로 인한 오출고는 신선하이에서 책임지지 않습니다.`->React.string}
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
          <section className=%twc("p-7 text-sm bg-gray-gl whitespace-pre-wrap")>
            {j`신규주문건만 `->React.string}
            <a id="link-of-orders" href="/buyer/orders" target="_blank">
              <p className=%twc("inline cursor-pointer hover:underline")>
                {`주문내역 페이지(클릭)`->React.string}
              </p>
            </a>
            {j`에서 직접 취소하실 수 있습니다.`->React.string}
            <p className=%twc("mt-5 whitespace-pre-wrap ")>
              {j`신선식품 특성 상 상품이 준비된 후에는 회수 및 재판매가 어렵기 때문에 상품준비중 단계부터는 주문 취소가 어렵습니다. \n부득이하게 꼭 취소가 필요한 경우 화면 오른쪽 하단의 [1:1 MD문의]를 눌러 상담매니저에게 내용 전달 부탁드리며, 경우에 따라 취소가 어려울 수 있는 점 양해부탁드립니다.`->React.string}
            </p>
            <div />
          </section>
        </RadixUI.Accordian.Content>
      </RadixUI.Accordian.Item>
    </RadixUI.Accordian.RootMultiple>
  </div>
