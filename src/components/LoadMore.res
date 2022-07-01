@react.component
let make = (~_disabled=?, ()) => {
  <div className=%twc("text-center")>
    <button
      className=%twc(
        "border-2 border-gray-300 py-3 text-center rounded-xl font-bold text-gray-700 mb-2 w-full sm:w-80"
      )>
      {j`더보기`->React.string}
    </button>
  </div>
}
