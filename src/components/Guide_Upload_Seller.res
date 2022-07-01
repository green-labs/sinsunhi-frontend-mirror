@react.component
let make = () =>
  <div className=%twc("container max-w-lg mx-auto sm:mt-4 sm:shadow-gl mb-10 text-black-gl")>
    <div className=%twc("p-5 sm:p-7 mt-4 md:shadow-gl text-sm bg-gray-gl")>
      <h4 className=%twc("text-gray-700 font-bold")>
        {j`송장번호 등록 방법`->React.string}
      </h4>
      <div className=%twc("mt-4")>
        {j`신선하이 웹사이트에 송장번호를 등록해주셔야만 정상적으로 처리됩니다.`->React.string}
      </div>
      <div>
        <div className=%twc("mt-4")>
          {j`이메일, 카카오톡으로 송장번호를 전달할 경우 처리되지 않습니다. 고객님의 실수로 발생된 피해에 대해서는 일체 책임지지 않습니다. 주문서 업로드 결과를 필히 확인해 성공/실패 여부를 확인하시기 바랍니다.`->React.string}
        </div>
        <ol className=%twc("mt-4")>
          <li className=%twc("mt-2")>
            <h6 className=%twc("font-bold")>
              {j`1. 송장번호 개별입력 사용가이드`->React.string}
            </h6>
            <ul className=%twc("mt-2 ml-6 list-disc leading-6")>
              <li>
                {j`상품주문번호, 주문번호, 상품명을 참고해 `->React.string}
                <span className=%twc("font-bold")>
                  {j`정확한 택배사명과 송장번호를 입력`->React.string}
                </span>
                {j`한다.`->React.string}
              </li>
              <li>
                <span className=%twc("font-bold")> {j`[등록]`->React.string} </span>
                {j` 버튼을 클릭해 택배사와 송장번호를 최종적으로 등록한다.`->React.string}
              </li>
            </ul>
          </li>
          <li className=%twc("mt-4")>
            <h6 className=%twc("font-bold")>
              {j`2. 송장번호 대량 등록 사용가이드`->React.string}
            </h6>
            <ul className=%twc("mt-2 ml-6 list-disc leading-6")>
              <li>
                {j`상품준비중인 주문 엑셀 다운로드를 클릭한다.`->React.string}
              </li>
              <li>
                {j`해당 엑셀에서 택배사명과 송장번호를 형식에 맞게 정확히 입력한다.`->React.string}
              </li>
              <li>
                <span className=%twc("font-bold")>
                  {j`[2.송장번호 엑셀 파일 선택]`->React.string}
                </span>
                {j` 항목에서 [파일선택]을 클릭 후 송장번호 입력이 완료된 파일을 업로드한다. (엑셀파일만 업로드 가능)`->React.string}
              </li>
              <li>
                <span className=%twc("font-bold")>
                  {j`[3. 송장번호 파일 업로드]`->React.string}
                </span>
                {j` 항목에서 [업로드]를 클릭해 최종 업로드한다.`->React.string}
              </li>
              <li>
                <span className=%twc("font-bold")>
                  {j`[4. 파일 업로드 결과 확인]`->React.string}
                </span>
                {j`를 참고해 주문서가 정상적으로 업로드되었는지 확인한다.`->React.string}
              </li>
            </ul>
          </li>
        </ol>
      </div>
    </div>
  </div>
