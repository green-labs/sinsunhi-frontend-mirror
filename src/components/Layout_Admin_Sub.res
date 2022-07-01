@react.component
let make = (~title, ~href, ~selected, ~target: Layout_Admin_Data.Item.target) => {
  <Next.Link href passHref=true key={href}>
    <a
      className={%twc(
        "bg-div-shape-L2 hover:bg-div-border-L2 cursor-pointer text-sm w-full pl-16 py-4"
      )}
      target={(target :> string)}>
      <p className={selected ? %twc("ml-2 font-bold pl-5") : %twc("ml-2 font-normal pl-5")}>
        {title->React.string}
      </p>
    </a>
  </Next.Link>
}
