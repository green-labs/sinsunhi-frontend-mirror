module Head = {
  @react.component
  let make = (~icon, ~selected, ~title) => {
    <div className={%twc("flex flex-row items-center w-full px-16 py-4")}>
      icon
      <div />
      <p className={selected ? %twc("ml-2 font-bold") : %twc("ml-2 font-normal")}>
        {title->React.string}
      </p>
    </div>
  }
}

let rec render = (
  t: Layout_Admin_Data.Item.t,
  pathname: string,
  openedAdminMenu,
  setOpenedAdminMenu,
) => {
  switch t {
  | Root({title, icon, children, anchor: {url, target}}) => {
      let headComponent = <Head title icon selected={t->Layout_Admin_Data.Item.hasUrl(pathname)} />

      let head = switch children {
      | [] =>
        <Next.Link href={url} passHref=true>
          <a target={(target :> string)}> headComponent </a>
        </Next.Link>
      | _ => headComponent
      }

      <Layout_Admin_Root key={url} accordianItemValue={url} head openedAdminMenu setOpenedAdminMenu>
        {children
        ->Array.map(d => d->render(pathname, openedAdminMenu, setOpenedAdminMenu))
        ->React.array}
      </Layout_Admin_Root>
    }
  | Sub({anchor: {url, target}, title}) =>
    <Layout_Admin_Sub
      key={url} title href={url} selected={t->Layout_Admin_Data.Item.hasUrl(pathname)} target
    />
  }
}

@react.component
let make = (~children) => {
  let router = Next.Router.useRouter()
  let (openedAdminMenu, setOpenedAdminMenu) = LocalStorageHooks.AdminMenu.useLocalStorage()

  <>
    <Header.Admin />
    <main className="flex flex-row bg-div-shape-L1">
      <aside className=%twc("mt-px min-h-screen bg-white")>
        {Layout_Admin_Data.Item.items
        ->Array.map(t =>
          t->render(router.pathname, openedAdminMenu->Option.getWithDefault([]), setOpenedAdminMenu)
        )
        ->React.array}
      </aside>
      <article className=%twc("w-full max-w-gnb-panel")> children </article>
    </main>
  </>
}
