module Item = {
  type rec t =
    | Root({title: string, anchor: anchor, icon: React.element, children: array<t>})
    | Sub({title: string, anchor: anchor, slug: option<Js.Re.t>})
  and anchor = {
    url: string,
    target: target,
  }
  and target = [
    | @as("_self") #_self
    | @as("_blank") #_blank
    | @as("_parent") #_parent
    | @as("_top") #_top
  ]

  let items: array<t> = [
    Root({
      title: `대시 보드`,
      anchor: {url: "/admin/dashboard", target: #_self}, // fs 원래대로
      icon: <IconNaviDashboard width="1.25rem" height="1.25rem" fill="#262626" />,
      children: [],
    }),
    Root({
      title: `상품`,
      anchor: {url: "/admin/products", target: #_self},
      icon: <IconNaviProduct height="1.25rem" width="1.25rem" fill="#262626" />,
      children: [
        Sub({
          title: `상품 등록`,
          anchor: {url: "/admin/add-product", target: #_self},
          slug: None,
        }),
        Sub({
          title: `상품 조회·수정`,
          anchor: {url: "/admin/products", target: #_self},
          slug: Some(%re("/\/admin\/products\/\[pid\]/g")),
        }),
        Sub({
          title: `단품 조회`,
          anchor: {url: "/admin/product-options", target: #_self},
          slug: None,
        }),
      ],
    }),
    Root({
      title: `주문 배송`,
      anchor: {url: "/admin/orders", target: #_self},
      icon: <IconNaviOrder height="1.25rem" width="1.25rem" fill="#262626" />,
      children: [
        Sub({
          title: `주문서 조회`,
          anchor: {url: "/admin/orders", target: #_self},
          slug: None,
        }),
        Sub({
          title: `주문서 등록`,
          anchor: {url: "/admin/add-orders", target: #_self},
          slug: None,
        }),
        Sub({
          title: `송장번호 조회`,
          anchor: {url: "/admin/tracking-numbers", target: #_self},
          slug: None,
        }),
        Sub({
          title: `송장번호 등록`,
          anchor: {url: "/admin/add-tracking-numbers", target: #_self},
          slug: None,
        }),
        Sub({
          title: `오프라인 주문관리`,
          anchor: {
            url: {
              let {makeWithDict, toString} = module(Webapi.Url.URLSearchParams)
              let defaultQueryParams = Js.Dict.empty()

              defaultQueryParams->Js.Dict.set(
                "created-at-from",
                Js.Date.make()->DateFns.setDate(1)->DateFns.format("yyyy-MM-dd"),
              )
              defaultQueryParams->Js.Dict.set(
                "created-at-to",
                Js.Date.make()->DateFns.endOfMonth->DateFns.format("yyyy-MM-dd"),
              )
              defaultQueryParams->Js.Dict.set(
                "release-due-date-from",
                Js.Date.make()->DateFns.setDate(1)->DateFns.format("yyyy-MM-dd"),
              )
              defaultQueryParams->Js.Dict.set(
                "release-due-date-to",
                Js.Date.make()->DateFns.endOfMonth->DateFns.format("yyyy-MM-dd"),
              )
              defaultQueryParams->Js.Dict.set("limit", "25")
              `/admin/offline-orders?${defaultQueryParams->makeWithDict->toString}`
            },
            target: #_self,
          },
          slug: None,
        }),
        Sub({
          title: `오프라인 주문등록`,
          anchor: {url: "/admin/add-offline-orders", target: #_self},
          slug: None,
        }),
      ],
    }),
    Root({
      title: `정산`,
      anchor: {url: "/admin/cost-management", target: #_self},
      icon: <IconNaviSettlement width="1.25rem" height="1.25rem" fill="#262626" />,
      children: [
        Sub({
          title: `단품가격관리`,
          anchor: {url: "/admin/cost-management", target: #_self},
          slug: None,
        }),
        Sub({
          title: `정산기초금액 조회`,
          anchor: {url: "/admin/settlements", target: #_self},
          slug: None,
        }),
      ],
    }),
    Root({
      title: `소싱 관리`,
      anchor: {url: "/admin/bulk-sale", target: #_self},
      icon: <IconNaviBulkSale width="1.25rem" height="1.25rem" fill="#262626" />,
      children: [
        Sub({
          title: `소싱 상품 등록/수정`,
          anchor: {url: "/admin/bulk-sale/products", target: #_self},
          slug: None,
        }),
        Sub({
          title: `생산자 소싱 관리`,
          anchor: {url: "/admin/bulk-sale/producers", target: #_self},
          slug: None,
        }),
      ],
    }),
    Root({
      title: `회원`,
      anchor: {url: "/admin/farmer-users", target: #_self},
      icon: <IconNaviUser height="1.25rem" width="1.25rem" fill="#262626" />,
      children: [
        Sub({
          title: `생산자 사용자 조회`,
          anchor: {url: "/admin/farmer-users", target: #_self},
          slug: None,
        }),
        Sub({
          title: `바이어 사용자 조회`,
          anchor: {url: "/admin/buyer-users", target: #_self},
          slug: None,
        }),
      ],
    }),
    Root({
      title: `다운로드 센터`,
      anchor: {url: "/admin/download-center", target: #_self},
      icon: <IconDownloadCenter height="1.25rem" width="1.25rem" fill="#262626" />,
      children: [],
    }),
    Root({
      title: `농산물 시세분석`,
      anchor: {url: "https://crophet.farmmorning.com/pages/marketprice", target: #_blank},
      icon: <IconSise height="1.25rem" width="1.25rem" fill="#262626" />,
      children: [],
    }),
  ]

  let rec hasUrl = (item, url) =>
    switch item {
    | Root(root) => url == root.anchor.url || root.children->Array.some(child => hasUrl(child, url))
    | Sub(sub) =>
      url == sub.anchor.url ||
        sub.slug->Option.mapWithDefault(false, slug => Js.Re.test_(slug, url))
    }
}
