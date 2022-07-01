@react.component
let make = () => {
  <>
    // -----
    // PC 뷰
    // -----
    <tr className=%twc("hidden lg:table-row")>
      <td className=%twc("py-2 align-top")>
        <span className=%twc("block text-gray-400 mb-1")> {j`2021/06/24 12:02`->React.string} </span>
      </td>
      <td className=%twc("p-2 align-top")>
        <span className=%twc("block text-gray-400")> {j`김그린`->React.string} </span>
      </td>
      <td className=%twc("p-2 align-top")>
        <span className=%twc("block whitespace-nowrap")>
          {j`service@greenlabs.co.kr`->React.string}
        </span>
        <span className=%twc("whitespace-nowrap")> {j`(010-2398-2398)`->React.string} </span>
      </td>
      <td className=%twc("p-2 align-top")>
        <span className=%twc("block")> {j`100,000,000원`->React.string} </span>
        <button
          type_="button" className=%twc("block bg-gray-100 text-gray-500 py-1 px-2 rounded-lg mt-2")>
          {j`조회하기`->React.string}
        </button>
      </td>
      <td className=%twc("p-2 align-top")>
        <span className=%twc("block")> {j`120,000,000원`->React.string} </span>
        <button
          type_="button" className=%twc("block bg-gray-100 text-gray-500 py-1 px-2 rounded-lg mt-2")>
          {j`조회하기`->React.string}
        </button>
      </td>
      <td className=%twc("p-2 align-top")>
        <span className=%twc("block")> {j`금액부족`->React.string} </span>
        <button
          type_="button" className=%twc("block bg-gray-100 text-gray-500 py-1 px-2 rounded-lg mt-2")>
          {j`일괄취소`->React.string}
        </button>
      </td>
    </tr>
  </>
}
