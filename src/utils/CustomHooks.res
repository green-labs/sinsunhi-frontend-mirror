let useSetPassword = token => {
  let (isShowSetPassword, setShowSetPassword) = React.Uncurried.useState(_ => Dialog.Hide)

  React.useEffect1(_ => {
    switch token {
    | Some(_t) => setShowSetPassword(._ => Dialog.Show)
    | None => ()
    }
    Some(_ => setShowSetPassword(._ => Dialog.Hide))
  }, [token])

  (isShowSetPassword, setShowSetPassword)
}

let useDebounce = (value, delay) => {
  let (debouncedValue, setDebouncedValue) = React.Uncurried.useState(_ => value)

  React.useEffect1(() => {
    let handler = Js.Global.setTimeout(() => setDebouncedValue(._ => value), delay)

    Some(() => Js.Global.clearTimeout(handler))
  }, [value])

  (debouncedValue, setDebouncedValue)
}

module Scroll = {
  type scrollStatus =
    | Visible
    | Hidden

  type thresholds =
    | Pct(float)
    | Px(float)

  type direction =
    | ScrollStop
    | ScrollDown
    | ScrollUp

  let useScrollObserver = (thresholds, ~sensitive: option<int>) => {
    open Webapi
    let (scrollStatus, setVisible) = React.useState(_ => Hidden)

    let (prevScrollPos, setPrevScrollPos) = React.useState(_ => Dom.window->Dom.Window.scrollY)

    let (debounceValue, _) = useDebounce(prevScrollPos, sensitive->Belt.Option.getWithDefault(300))
    let (scrollDiff, setScrollDiff) = React.useState(_ => 0.0)

    let (scrollDirection, setScrollDirection) = React.useState(_ => ScrollStop)

    let handleScrollEvent = _ => {
      let currentScrollTop = Dom.window->Dom.Window.scrollY

      Option.forEach(Dom.document->Dom.Document.querySelector("body"), body => {
        let isVisible = switch thresholds {
        | Pct(v) => currentScrollTop /. float_of_int(body->Dom.Element.clientHeight) >= v
        | Px(v) => currentScrollTop >= v
        }
        setPrevScrollPos(_ => Dom.window->Dom.Window.scrollY)
        isVisible ? setVisible(_ => Visible) : setVisible(_ => Hidden)
      })
    }

    React.useLayoutEffect1(_ => {
      let diff = Dom.window->Dom.Window.scrollY -. debounceValue

      switch diff {
      | _d if diff > 0.0 =>
        setScrollDirection(_ => ScrollDown)
        setScrollDiff(_ => diff)
      | _d if diff < 0.0 =>
        setScrollDirection(_ => ScrollUp)
        setScrollDiff(_ => diff)
      | _ =>
        setScrollDirection(_ => ScrollStop)
        setScrollDiff(_ => diff)
      }

      None
    }, [prevScrollPos])

    React.useLayoutEffect2(_ => {
      Dom.window->Dom.Window.addEventListener("scroll", handleScrollEvent)
      Some(() => Dom.window->Dom.Window.removeEventListener("scroll", handleScrollEvent))
    }, (handleScrollEvent, thresholds))
    (scrollStatus, scrollDirection, scrollDiff, Dom.window->Dom.Window.scrollY)
  }
}

let onErrorRetry = (
  error: FetchHelper.customError,
  _key,
  _config,
  revalidate,
  {retryCount}: Swr.revalidateOptions,
) => {
  if error.status === 401 {
    (FetchHelper.refreshToken() |> Js.Promise.catch(err => {
      Js.Console.log(err)
      Js.Promise.resolve()
    }))->ignore
  }

  if retryCount <= 3 {
    let revalidateOptions = Swr.revalidateOptions(~retryCount, ())
    Js.Global.setTimeout(_ => revalidate(revalidateOptions)->ignore, 500)->ignore
  }
}

module IntersectionObserver = {
  type t
  type intersectingEntry = {isIntersecting: bool}

  @new
  external makeIntersectionObserver: (
    ~onIntersect: array<intersectingEntry> => unit,
    ~options: {"root": Js.Nullable.t<Dom.element>, "rootMargin": string, "thresholds": float},
  ) => t = "IntersectionObserver"

  @send external observe: (t, Dom.element) => unit = "observe"
  @send external unobserve: (t, Dom.element) => unit = "unobserve"

  let use = (
    ~root: option<React.ref<Js.Nullable.t<Dom.element>>>=?,
    ~target: React.ref<Js.Nullable.t<Dom.element>>,
    ~thresholds,
    ~rootMargin,
    (),
  ) => {
    let (isIntersecting, setIntersecting) = React.Uncurried.useState(_ => false)

    React.useEffect4(_ =>
      switch target.current->Js.Nullable.toOption {
      | Some(t) =>
        let observer = makeIntersectionObserver(
          ~onIntersect=entries => {
            if entries->Array.every(e => e.isIntersecting) {
              setIntersecting(._ => true)
            } else {
              setIntersecting(._ => false)
            }
          },
          ~options={
            "root": switch root {
            | Some(root') => root'.current
            | None => Js.Nullable.null
            },
            "rootMargin": rootMargin,
            "thresholds": thresholds,
          },
        )

        observe(observer, t)

        Some(_ => unobserve(observer, t))
      | None => None
      }
    , (root, target, thresholds, rootMargin))

    isIntersecting
  }
}

module Auth = {
  @module("jwt-decode") external decodeJwt: string => Js.Json.t = "default"

  type role = Seller | Buyer | Admin

  let encoderRole = v =>
    switch v {
    | Seller => "farmer"
    | Buyer => "buyer"
    | Admin => "admin"
    }->Js.Json.string

  let decoderRole = json => {
    switch json |> Js.Json.classify {
    | Js.Json.JSONString(str) =>
      switch str {
      | "farmer" => Seller->Ok
      | "buyer" => Buyer->Ok
      | "admin" => Admin->Ok
      | _ => Error({Spice.path: "", message: "Expected JSONString", value: json})
      }
    | _ => Error({Spice.path: "", message: "Expected JSONString", value: json})
    }
  }

  let codecRole: Spice.codec<role> = (encoderRole, decoderRole)

  @spice
  type user = {
    id: int,
    uid: string,
    email: option<string>,
    role: @spice.codec(codecRole) role,
    address: option<string>,
    phone: option<string>,
    name: string,
    @spice.key("business-registration-number") businessRegistrationNumber: option<string>,
    @spice.key("producer-type") producerType: option<string>,
    @spice.key("producer-code") producerCode: option<string>,
    @spice.key("zip-code") zipCode: option<string>,
  }

  // 유저 정보가 local storage에 저장됨.
  // ssr에서는 유저 정보를 확인 할 수 없어 Unknown을 사용.
  type status = Unknown | LoggedIn(user) | NotLoggedIn

  let toOption = u =>
    switch u {
    | LoggedIn(user) => Some(user)
    | NotLoggedIn | Unknown => None
    }

  let use = (): status => {
    let (token, setToken) = React.Uncurried.useState(_ => Unknown)

    React.useEffect0(() => {
      let accessToken = LocalStorageHooks.AccessToken.get()
      if accessToken == "" {
        setToken(._ => NotLoggedIn)
      } else {
        switch accessToken->decodeJwt->user_decode {
        | Ok(user) => setToken(._ => LoggedIn(user))
        | Error(_) => setToken(._ => NotLoggedIn)
        }
      }

      None
    })

    token
  }

  let logOut = () => {
    LocalStorageHooks.AccessToken.remove()
    LocalStorageHooks.RefreshToken.remove()
  }
}

module User = {
  module Seller = {
    let use = () => {
      let router = Next.Router.useRouter()
      // 상태를 만들지 않고 Auth.use()를 호출하고 반환해도 되지만,
      // state + useEffect를 사용하지 않으면 Next.js 최초 렌더링 때 UI가 깨지는 현상이 있다.
      // 우선 커스텀 훅으로 만들어서 처리하고 추후 리팩토링 예정
      let (status, setStatus) = React.Uncurried.useState(_ => Auth.Unknown)
      let user = Auth.use()

      React.useEffect2(_ => {
        switch user {
        | LoggedIn(user') =>
          switch user'.role {
          | Buyer => Redirect.setHref(`/buyer`)
          | Admin => Redirect.setHref(`/admin`)
          | Seller => setStatus(._ => user)
          }
        | NotLoggedIn => Redirect.setHref(`/seller/signin?redirect=${router.asPath}`)
        | Unknown => setStatus(._ => user)
        }

        None
        // TODO: dependency list에 object를 대신 할 방법 찾기.
      }, (user, router.asPath))
      status
    }
  }

  module Buyer = {
    let use = () => {
      let router = Next.Router.useRouter()
      let (status, setStatus) = React.Uncurried.useState(_ => Auth.Unknown)

      let user = Auth.use()
      React.useEffect2(_ => {
        switch user {
        | LoggedIn(user') =>
          switch user'.role {
          | Seller => Redirect.setHref(`/seller`)
          | Admin => Redirect.setHref(`/admin/`)
          | Buyer => setStatus(._ => user)
          }
        | NotLoggedIn => Redirect.setHref(`/buyer/signin?redirect=${router.asPath}`)
        | Unknown => setStatus(._ => Unknown)
        }

        None
      }, (user, router.asPath))

      status
    }

    /*
    --- redirection 효과가 없는 use (임시) ---
    기본 use 함수의 경우 redirection이라는 부수효과를 가지고 있음.
    아임웹 독립 후 바이어센터에는 로그인 없이 접근할 수 있는 페이지들이 존재하기때문에, 리디렉션 없이 role기반의 유저를 가져올 수 있는 방안이 필요.
    현 시점에서 부수효과를 함수 인자로 밀어내면, 해당 함수를 사용하는곳마다 수정할 포인트가 너무 많아짐.
    추후 이슈화 하여 use, use2 통합 및 부수효과 제거, 통합해볼것
 */
    let use2 = () => {
      let router = Next.Router.useRouter()
      let (status, setStatus) = React.Uncurried.useState(_ => Auth.Unknown)

      let user = Auth.use()
      React.useEffect2(_ => {
        setStatus(._ => user)

        None
      }, (user, router.query))

      status
    }
  }

  module Admin = {
    let use = () => {
      let router = Next.Router.useRouter()
      let (status, setStatus) = React.Uncurried.useState(_ => Auth.Unknown)
      let user = Auth.use()

      React.useEffect2(_ => {
        switch user {
        | LoggedIn(user') =>
          switch user'.role {
          | Seller => Redirect.setHref(`/seller/`)
          | Buyer => Redirect.setHref(`/buyer`)
          | Admin => setStatus(._ => user)
          }
        | NotLoggedIn => Redirect.setHref(`/admin/signin?redirect=${router.asPath}`)
        | Unknown => setStatus(._ => user)
        }

        None
      }, (user, router.asPath))

      status
    }
  }
}

module CRMUser = {
  // CRM을 위한 전역 객체로 추가할 user 타입
  type user = {
    id: int,
    name: string,
    email: option<string>,
    role: string,
  }
  @set external setUser: (Global.window, option<user>) => unit = "user"

  let roleToString = r =>
    switch r {
    | Auth.Seller => "seller"
    | Auth.Buyer => "buyer"
    | Auth.Admin => "admin"
    }

  let use = () => {
    let user = Auth.use()
    React.useEffect1(_ => {
      switch (Global.window, user) {
      | (Some(window'), LoggedIn(user)) =>
        window'->setUser(
          Some({
            id: user.id,
            name: user.name,
            email: user.email,
            role: user.role->roleToString,
          }),
        )
      | _ => ()
      }

      Some(
        _ =>
          switch Global.window {
          | Some(window) => window->setUser(None)
          | None => ()
          },
      )
    }, [user])
  }
}

module Orders = {
  type result = Loading | Loaded(Js.Json.t) | Error(FetchHelper.customError)

  /*
   * PROCESSING = 파일 업로드 대기 & 파일 처리중
   * SUCCESS = 파일 파싱, 주문생성 성공
   * FAIL = 엑셀파일 오류
   */
  @spice
  type orderStatus =
    | @spice.as("PROCESSING") PROCESSING
    | @spice.as("SUCCESS") SUCCESS
    | @spice.as("FAIL") FAIL
    | @spice.as("COMPLETE") COMPLETE

  /**
  - CREATE — 신규 주문 → 바이어가 아임웹에서 결제하고 신선하이 서비스에 발주서 엑셀을 업로드함
  - PACKING — 상품준비중 → 농민이 주문 들어온거 확인하고 상품 준비중으로 변경함
  - DEPARTURE — 집하중 → 농민이 택배 보내고 송장번호를 입력함
  - DELIVERING — 배송중 → 배송추적API를 통해 송장번호 배송상태 연동됨
  - COMPLETE — 배송완료 → 배송추적API를 통해 송장번호 배송완료 연동됨
  - CANCEL — 주문취소 → 바이어/어드민이 취소함
  - ERROR — 송장번호에러 → 송장번호 입력했을때 배송추적API 호출하는데, 여기서 송장번호 유효성검사 실패한 경우
 */
  @spice
  type status =
    | @spice.as("CREATE") CREATE
    | @spice.as("PACKING") PACKING
    | @spice.as("DEPARTURE") DEPARTURE
    | @spice.as("DELIVERING") DELIVERING
    | @spice.as("COMPLETE") COMPLETE
    | @spice.as("CANCEL") CANCEL
    | @spice.as("ERROR") ERROR
    | @spice.as("REFUND") REFUND
    | @spice.as("NEGOTIATING") NEGOTIATING

  @spice
  type payType =
    | @spice.as("PAID") PAID
    | @spice.as("AFTER_PAY") AFTER_PAY

  @spice
  type deliveryType =
    | @spice.as("SELF") SELF
    | @spice.as("FREIGHT") FREIGHT
    | @spice.as("PARCEL") PARCEL

  @spice
  type order = {
    @spice.key("courier-code") courierCode: option<string>,
    @spice.key("delivery-date") deliveryDate: option<string>,
    @spice.key("delivery-message") deliveryMessage: option<string>,
    @spice.key("delivery-type") deliveryType: option<deliveryType>,
    @spice.key("error-code") errorCode: option<string>,
    @spice.key("error-message") errorMessage: option<string>,
    invoice: option<string>,
    @spice.key("order-date") orderDate: string,
    @spice.key("order-no") orderNo: string,
    @spice.key("order-product-no") orderProductNo: string,
    @spice.key("order-status") orderStatus: orderStatus,
    @spice.key("product-id") productId: int,
    @spice.key("product-sku") productSku: string,
    @spice.key("product-name") productName: string,
    @spice.key("product-option-name") productOptionName: option<string>,
    @spice.key("product-price") productPrice: float,
    quantity: int,
    @spice.key("orderer-name") ordererName: option<string>,
    @spice.key("orderer-phone") ordererPhone: option<string>,
    @spice.key("receiver-address") receiverAddress: option<string>,
    @spice.key("receiver-name") receiverName: option<string>,
    @spice.key("receiver-phone") receiverPhone: option<string>,
    @spice.key("receiver-zipcode") receiverZipcode: option<string>,
    status: status,
    // showcase 용, 나중에 지우기
    // 기사정보: courier_name
    // 기사연락처: courier_phone
    // 출고여부 (t/f): is_shipped
    // 배송여부 (t/f): is_delivered
    // ----
    // 검수담당자: inspector_name
    // 검수여부 (t/f): is_inspected
    // 검수의견: inspection_opinion
    @spice.key("courier-name") driverName: option<string>,
    @spice.key("courier-phone") driverPhone: option<string>,
    @spice.key("is-shipped") isShipped: bool,
    @spice.key("is-delivered") isDelivered: bool,
    @spice.key("inspector-name") inspectorName: option<string>,
    @spice.key("is-inspected") isInspected: bool,
    @spice.key("inspection-opinion") inspectionOpinion: option<string>,
    // showcase 용 END
    @spice.key("pay-type") payType: payType,
  }

  @spice
  type orders = {
    data: array<order>,
    count: int,
    offset: int,
    limit: int,
  }

  let use = queryParams => {
    let fetcherOptions = Swr.fetcherOptions(~onErrorRetry, ())

    let {data, error} = Swr.useSwr(
      `${Env.restApiUrl}/order?${queryParams}`,
      FetchHelper.fetcher,
      fetcherOptions,
    )

    let result = switch (error, data) {
    | (None, None) => Loading
    | (None, Some(data')) => Loaded(data')
    | (Some(error'), _) => Error(error')
    }

    result
  }
}

// TODO: Orders 모듈과 합치기
module OrdersAdmin = {
  type result = Loading | Loaded(Js.Json.t) | Error(FetchHelper.customError)

  /*
   * PROCESSING = 파일 업로드 대기 & 파일 처리중
   * SUCCESS = 파일 파싱, 주문생성 성공
   * FAIL = 엑셀파일 오류
   */
  @spice
  type orderStatus =
    | @spice.as("PROCESSING") PROCESSING
    | @spice.as("SUCCESS") SUCCESS
    | @spice.as("FAIL") FAIL
    | @spice.as("COMPLETE") COMPLETE

  /**
  - CREATE — 신규 주문 → 바이어가 아임웹에서 결제하고 신선하이 서비스에 발주서 엑셀을 업로드함
  - PACKING — 상품준비중 → 농민이 주문 들어온거 확인하고 상품 준비중으로 변경함
  - DEPARTURE — 집하중 → 농민이 택배 보내고 송장번호를 입력함
  - DELIVERING — 배송중 → 배송추적API를 통해 송장번호 배송상태 연동됨
  - COMPLETE — 배송완료 → 배송추적API를 통해 송장번호 배송완료 연동됨
  - CANCEL — 주문취소 → 바이어/어드민이 취소함
  - ERROR — 송장번호에러 → 송장번호 입력했을때 배송추적API 호출하는데, 여기서 송장번호 유효성검사 실패한 경우
 */
  @spice
  type status =
    | @spice.as("CREATE") CREATE
    | @spice.as("PACKING") PACKING
    | @spice.as("DEPARTURE") DEPARTURE
    | @spice.as("DELIVERING") DELIVERING
    | @spice.as("COMPLETE") COMPLETE
    | @spice.as("CANCEL") CANCEL
    | @spice.as("ERROR") ERROR
    | @spice.as("REFUND") REFUND
    | @spice.as("NEGOTIATING") NEGOTIATING

  @spice
  type payType =
    | @spice.as("PAID") PAID
    | @spice.as("AFTER_PAY") AFTER_PAY

  // order-refund-delivery-delayed: 배송지연
  // order-refund-defective-product: 상품불량
  @spice
  type refundReason =
    | @spice.as("order-refund-delivery-delayed") DeliveryDelayed
    | @spice.as("order-refund-defective-product") DefectiveProduct

  @spice
  type deliveryType =
    | @spice.as("SELF") SELF
    | @spice.as("FREIGHT") FREIGHT
    | @spice.as("PARCEL") PARCEL

  @spice
  type order = {
    @spice.key("admin-memo") adminMemo: option<string>,
    @spice.key("buyer-email") buyerEmail: string,
    @spice.key("buyer-name") buyerName: string,
    @spice.key("buyer-phone") buyerPhone: string,
    @spice.key("courier-code") courierCode: option<string>,
    @spice.key("delivery-date") deliveryDate: option<string>,
    @spice.key("delivery-message") deliveryMessage: option<string>,
    @spice.key("delivery-type") deliveryType: option<deliveryType>,
    @spice.key("desired-delivery-date") desiredDeliveryDate: option<string>,
    @spice.key("error-code") errorCode: option<string>,
    @spice.key("error-message") errorMessage: option<string>,
    @spice.key("farmer-email") farmerEmail: option<string>,
    @spice.key("farmer-name") farmerName: string,
    @spice.key("farmer-phone") farmerPhone: string,
    invoice: option<string>,
    @spice.key("order-date") orderDate: string,
    @spice.key("order-no") orderNo: string,
    @spice.key("order-product-no") orderProductNo: string,
    @spice.key("order-status") orderStatus: orderStatus,
    @spice.key("product-id") productId: int,
    @spice.key("product-sku") productSku: string,
    @spice.key("product-name") productName: string,
    @spice.key("product-option-name") productOptionName: option<string>,
    @spice.key("product-price") productPrice: float,
    quantity: int,
    @spice.key("orderer-name") ordererName: option<string>,
    @spice.key("orderer-phone") ordererPhone: option<string>,
    @spice.key("receiver-address") receiverAddress: option<string>,
    @spice.key("receiver-name") receiverName: option<string>,
    @spice.key("receiver-phone") receiverPhone: option<string>,
    @spice.key("receiver-zipcode") receiverZipcode: option<string>,
    status: status,
    @spice.key("refund-requestor-id") refundRequestorId: option<int>,
    @spice.key("refund-requestor-name") refundRequestorName: option<string>,
    @spice.key("refund-reason") refundReason: option<string>,
    // showcase 용, 나중에 지우기
    // 기사정보: courier_name
    // 기사연락처: courier_phone
    // 출고여부 (t/f): is_shipped
    // 배송여부 (t/f): is_delivered
    // ----
    // 검수담당자: inspector_name
    // 검수여부 (t/f): is_inspected
    // 검수의견: inspection_opinion
    @spice.key("courier-name") driverName: option<string>,
    @spice.key("courier-phone") driverPhone: option<string>,
    @spice.key("is-shipped") isShipped: bool,
    @spice.key("is-delivered") isDelivered: bool,
    @spice.key("inspector-name") inspectorName: option<string>,
    @spice.key("is-inspected") isInspected: bool,
    @spice.key("inspection-opinion") inspectionOpinion: option<string>,
    // showcase 용 END
    @spice.key("pay-type") payType: payType,
  }

  @spice
  type orders = {
    data: array<order>,
    count: int,
    offset: int,
    limit: int,
  }

  let use = queryParams => {
    let fetcherOptions = Swr.fetcherOptions(~onErrorRetry, ())

    let {data, error} = Swr.useSwr(
      `${Env.restApiUrl}/order?${queryParams}`,
      FetchHelper.fetcher,
      fetcherOptions,
    )

    let result = switch (error, data) {
    | (None, None) => Loading
    | (None, Some(data')) => Loaded(data')
    | (Some(error'), _) => Error(error')
    }

    result
  }
}

/**
 * 수기 주문데이터 관리자 업로드 시연용 훅
 * TODO: 시연이 끝나면 지워도 된다.
 */
module OrdersAllAdmin = {
  type result = Loading | Loaded(Js.Json.t) | Error(FetchHelper.customError)

  @spice
  type orderType = | @spice.as(`온라인`) Online | @spice.as(`오프라인`) Offline
  /**
   * No. - no
   * 주문일자 - order-date
   * 거래유형 - order-type - "온라인" | "오프라인"
   * 생산자명 - producer-name
   * 바이어명 - buyer-name
   * 판매금액 - total-price
   * 주문번호 - order-no
   * 품목 - product-category
   * 상품명 - product-name
   * 옵션명 - product-option-name

   * nullable: 주문번호 바이어명 생산자명 옵션명
 */
  @spice
  type order = {
    no: int,
    @spice.key("order-date") orderDate: string,
    @spice.key("order-type") orderType: orderType,
    @spice.key("producer-name") producerName: option<string>,
    @spice.key("buyer-name") buyerName: option<string>,
    @spice.key("total-price") totalPrice: float,
    @spice.key("order-no") orderNo: option<string>,
    @spice.key("product-category") productCategory: string,
    @spice.key("product-name") productName: string,
    @spice.key("product-option-name") productOptionName: option<string>,
  }

  @spice
  type orders = {
    data: array<order>,
    count: int,
    offset: int,
    limit: int,
  }

  let use = queryParams => {
    let fetcherOptions = Swr.fetcherOptions(~onErrorRetry, ())

    let {data, error} = Swr.useSwr(
      `${Env.restApiUrl}/order/sc?${queryParams}`,
      FetchHelper.fetcher,
      fetcherOptions,
    )

    let result = switch error {
    | Some(error') => Error(error')
    | None =>
      switch data {
      | Some(data') => Loaded(data')
      | None => Loading
      }
    }

    result
  }
}

module OrdersAdminUncompleted = {
  type result = Loading | Loaded(Js.Json.t) | Error(FetchHelper.customError)

  @spice
  type orderDetail = {
    @spice.key("courier-code") courierCode: option<string>,
    @spice.key("delivery-message") deliveryMessage: option<string>,
    etc: option<string>,
    invoice: option<string>,
    @spice.key("orderer-name") ordererName: option<string>,
    @spice.key("orderer-phone") ordererPhone: option<string>,
    @spice.key("product-id") productId: int,
    @spice.key("product-name") productName: string,
    @spice.key("product-option-name") productOptionName: option<string>,
    @spice.key("product-price") productPrice: float,
    @spice.key("product-sku") productSku: string,
    quantity: string,
    @spice.key("receiver-address") receiverAddress: string,
    @spice.key("receiver-name") receiverName: string,
    @spice.key("receiver-phone") receiverPhone: string,
    @spice.key("receiver-zipcode") receiverZipcode: string,
    @spice.key("seller-code") sellerCode: string,
  }

  @spice
  type orderUncompleted = {
    @spice.key("current-deposit") currentDeposit: float,
    email: string,
    @spice.key("error-code") errorCode: option<string>,
    @spice.key("error-message") errorMessage: option<string>,
    name: string,
    @spice.key("order-date") orderDate: string,
    @spice.key("order-no") orderNo: string,
    phone: string,
    price: option<float>,
    @spice.key("user-deposit") userDeposit: option<float>,
    data: option<array<orderDetail>>,
  }

  @spice
  type orders = {
    data: array<orderUncompleted>,
    count: int,
    limit: int,
    message: string,
    offset: int,
  }

  let use = queryParams => {
    let fetcherOptions = Swr.fetcherOptions(~onErrorRetry, ())

    let {data, error} = Swr.useSwr(
      `${Env.restApiUrl}/order/failed?${queryParams}`,
      FetchHelper.fetcher,
      fetcherOptions,
    )

    let result = switch (error, data) {
    | (None, None) => Loading
    | (None, Some(data')) => Loaded(data')
    | (Some(error'), _) => Error(error')
    }

    result
  }
}

module OrdersSummary = {
  type result = Loading | Loaded(Js.Json.t) | Error(FetchHelper.customError)

  /*
   * CREATE = 초기상태
   * PACKING = 상품 준비중
   * DEPARTURE = 상품 집하중
   * DELIVERING = 배송중
   * COMPLETE = 완료
   * CANCEL = 주문취소
   * ERROR = 송장에러
   * REFUND = 환불
   */
  @spice
  type status =
    | @spice.as("CREATE") CREATE
    | @spice.as("PACKING") PACKING
    | @spice.as("DEPARTURE") DEPARTURE
    | @spice.as("DELIVERING") DELIVERING
    | @spice.as("COMPLETE") COMPLETE
    | @spice.as("CANCEL") CANCEL
    | @spice.as("ERROR") ERROR
    | @spice.as("REFUND") REFUND
    | @spice.as("NEGOTIATING") NEGOTIATING

  @spice
  type order = {
    status: status,
    count: int,
  }

  @spice
  type orders = {
    message: string,
    data: array<order>,
  }

  let use = (~queryParams=?, ()) => {
    let fetcherOptions = Swr.fetcherOptions(~onErrorRetry, ())

    let {data, error} = Swr.useSwr(
      `${Env.restApiUrl}/order/summary?${queryParams->Option.getWithDefault("")}`,
      FetchHelper.fetcher,
      fetcherOptions,
    )

    let result = switch (error, data) {
    | (None, None) => Loading
    | (None, Some(data')) => Loaded(data')
    | (Some(error'), _) => Error(error')
    }

    result
  }
}

module OrdersSummaryFarmerDelivery = {
  type result = Loading | Loaded(Js.Json.t) | Error(FetchHelper.customError)

  @spice
  type order = {
    @spice.key("product-name") productName: string,
    @spice.key("product-option-name") productOptionName: string,
    @spice.key("quantity-sum") quantitySum: int,
    @spice.key("order-count") orderCount: int,
  }

  @spice
  type orders = {
    message: string,
    data: array<order>,
    count: int,
  }

  let use = () => {
    let fetcherOptions = Swr.fetcherOptions(~onErrorRetry, ())

    let {data, error} = Swr.useSwr(
      `${Env.restApiUrl}/order/farmer-delivery-summary`,
      FetchHelper.fetcher,
      fetcherOptions,
    )

    let result = switch (error, data) {
    | (None, None) => Loading
    | (None, Some(data')) => Loaded(data')
    | (Some(error'), _) => Error(error')
    }

    result
  }
}

module OrdersSummaryAdminDashboard = {
  type result = Loading | Loaded(Js.Json.t) | Error(FetchHelper.customError)

  @spice
  type summary = {
    @spice.key("invoice-not-updated") invoiceNotUpdated: int,
    @spice.key("invoice-requested") invoiceRequested: int,
    @spice.key("invoice-updated") invoiceUpdated: int,
    @spice.key("new-orders") newOrders: int,
    @spice.key("orders-fail") ordersFail: int,
    @spice.key("orders-success") ordersSuccess: int,
  }

  @spice
  type orders = {
    message: string,
    data: summary,
  }

  let use = () => {
    let fetcherOptions = Swr.fetcherOptions(~onErrorRetry, ())

    let {data, error} = Swr.useSwr(
      `${Env.restApiUrl}/order/admin-dashboard-summary`,
      FetchHelper.fetcher,
      fetcherOptions,
    )

    let result = switch (error, data) {
    | (None, None) => Loading
    | (None, Some(data')) => Loaded(data')
    | (Some(error'), _) => Error(error')
    }

    result
  }
}

module S3PresignedUrl = {
  type t = Seller | Buyer
  type status = Waiting | Loading | Loaded(Js.Json.t) | Validating | Error(FetchHelper.customError)

  @spice
  type responseData = {url: string}
  @spice
  type response = {
    message: string,
    data: responseData,
  }

  let use = (~filename, ~kind, ~userId=?, ()) => {
    let fetcherOptions = Swr.fetcherOptions(
      ~onErrorRetry,
      ~revalidateOnFocus=false,
      ~revalidateOnReconnect=false,
      (),
    )

    let {data, error, isValidating} = Swr.useSwr(
      switch (userId, kind) {
      | (Some(userId'), Seller) =>
        `${Env.restApiUrl}/order/delivery/upload-url?file-name=${filename}&user-id=${userId'}`
      | (None, Seller) => `${Env.restApiUrl}/order/delivery/upload-url?file-name=${filename}`
      | (Some(userId'), Buyer) =>
        `${Env.restApiUrl}/order/upload-url?file-name=${filename}&user-id=${userId'}`
      | (None, Buyer) => `${Env.restApiUrl}/order/upload-url?file-name=${filename}`
      },
      FetchHelper.fetcher,
      fetcherOptions,
    )

    let status = switch (error, data, isValidating) {
    | (None, None, false) => Waiting
    | (None, None, true) => Loading
    | (None, Some(_), true) => Validating
    | (None, Some(data'), false) => Loaded(data')
    | (Some(error'), _, _) => Error(error')
    }

    status
  }
}

module Courier = {
  type status = Waiting | Loading | Loaded(Js.Json.t) | Validating | Error(FetchHelper.customError)

  @spice
  type courier = {
    code: string,
    name: string,
  }
  @spice
  type couriers = array<courier>
  @spice
  type response = {
    message: string,
    data: couriers,
  }

  let use = () => {
    let fetcherOptions = Swr.fetcherOptions(
      ~onErrorRetry,
      ~revalidateOnFocus=false,
      ~revalidateOnReconnect=false,
      (),
    )

    let {data, error, isValidating} = Swr.useSwr(
      `${Env.restApiUrl}/order/delivery-company-codes`,
      FetchHelper.fetcher,
      fetcherOptions,
    )

    let status = switch (error, data, isValidating) {
    | (None, None, false) => Waiting
    | (None, None, true) => Loading
    | (None, Some(_), true) => Validating
    | (None, Some(data'), false) => Loaded(data')
    | (Some(error'), _, _) => Error(error')
    }

    status
  }
}

module SweetTracker = {
  type status = Loading | Loaded(Js.Json.t) | Validating | Error(FetchHelper.customError)

  @spice
  type data = {@spice.key("st-api-key") stApiKey: string}
  @spice
  type response = {
    message: string,
    data: data,
  }

  let use = () => {
    let fetcherOptions = Swr.fetcherOptions(
      ~onErrorRetry,
      ~revalidateOnFocus=false,
      ~revalidateOnReconnect=false,
      (),
    )

    let {data, error} = Swr.useSwr(
      `${Env.restApiUrl}/order/delivery/st-api-key`,
      FetchHelper.fetcher,
      fetcherOptions,
    )

    let status = switch (error, data) {
    | (None, None) => Loading
    | (None, Some(data')) => Loaded(data')
    | (Some(error'), _) => Error(error')
    }

    status
  }
}

module UploadStatus = {
  type status = Loading | Loaded(Js.Json.t) | Error(FetchHelper.customError)
  type kind = Seller | Buyer | Admin
  type uploadType = Order | Invoice | Offline | OrderAfterPay

  @spice
  type uploadStatus =
    | @spice.as("WAITING") WAITING
    | @spice.as("PROCESSING") PROCESSING
    | @spice.as("SUCCESS") SUCCESS
    | @spice.as("FAIL") FAIL

  // error-code : 1. s3-getobject       (S3 객체 조회실패 | 잘못된 파일을 올린 경우)
  //            2. required-columns   (엑셀파일 필수컬럼 부재 | 잘못된 파일을 올린 경우)
  //            3. excel-cell         (엑셀 cell 파싱실패 | 잘못된 파일을 올린 경우)
  //            4. encrypted-document (암호가 걸린 엑셀 | 잘못된 파일을 올린 경우)
  //            5. deposit            (잔액 부족 | 현재 유효성검사하지 않음)
  //            6. product-id         (유효하지 않은 product-id)
  //            7. sku                (유효하지 않은 sku)
  //            8. order-product-no   (imweb order-no 부재)
  //            9. orderer-id         (주문자 아이디 부재)
  //            10. etc               (기타)
  // success-count: option<int>
  // fail-count: option<int>
  @spice
  type errorCode =
    | S3GetObject(string)
    | RequiredColumns(string)
    | ExcelCell(string)
    | EncryptedDocument(string)
    | Deposit(string)
    | ProductId(string)
    | Sku(string)
    | OrderProductNo(string)
    | OrdererId(string)
    | Etc(string)
    | AfterPay(string)

  let encoderErrorCode = v =>
    switch v {
    | S3GetObject(s) => s
    | RequiredColumns(s) => s
    | ExcelCell(s) => s
    | EncryptedDocument(s) => s
    | Deposit(s) => s
    | ProductId(s) => s
    | Sku(s) => s
    | OrderProductNo(s) => s
    | OrdererId(s) => s
    | Etc(s) => s
    | AfterPay(s) => s
    }->Js.Json.string

  let decoderErrorCode = json => {
    switch json |> Js.Json.classify {
    | Js.Json.JSONString(str) =>
      switch str {
      | "s3-getobject" => S3GetObject(`파일을 찾을 수 없습니다.`)->Ok
      | "required-columns" =>
        RequiredColumns(`엑셀 파일의 필수 열을 찾을 수 없습니다.`)->Ok
      | "excel-cell" => ExcelCell(`엑셀 파일 양식에 문제를 발견하였습니다.`)->Ok
      | "encrypted-document" =>
        EncryptedDocument(`엑셀 파일에 암호가 걸려 있습니다.`)->Ok
      | "deposit" => Deposit(`잔액이 부족합니다.`)->Ok
      | "product-id" => ProductId(`상품코드(A열)에 문제를 발견하였습니다.`)->Ok
      | "sku" => Sku(`옵션코드(C열)에 문제를 발견하였습니다.`)->Ok
      | "order-product-no" =>
        OrderProductNo(`신선하이 주문번호(C열)에 문제를 발견하였습니다.`)->Ok
      | "orderer-id" => OrdererId(`주문자 아이디를 찾을 수가 없습니다.`)->Ok
      | "etc" => Etc(`알 수 없는 오류가 발생하였습니다.`)->Ok
      | "after-pay" => AfterPay(`한도가 부족합니다.`)->Ok
      | _ => Error({Spice.path: "", message: "Expected JSONString", value: json})
      }
    | _ => Error({Spice.path: "", message: "Expected JSONString", value: json})
    }
  }

  let codecErrorCode: Spice.codec<errorCode> = (encoderErrorCode, decoderErrorCode)

  // fail-code : 1. is-spec-valid (엑셀파일 필수컬럼 부재)
  //             2. courier-code  (올바르지 않은 배송회사 입력)
  //             3. is-your-product (자신의 상품이 아닌 경우)
  //             4. is-renewable-status (수정가능한 상태가 아닌 경우)
  @spice
  type failCode =
    | InvalidSpec(string)
    | InvalidCourierCode(string)
    | NotYourProduct(string)
    | NotAllowedModify(string)

  let encoderFailCode = v =>
    switch v {
    | InvalidSpec(s) => s
    | InvalidCourierCode(s) => s
    | NotYourProduct(s) => s
    | NotAllowedModify(s) => s
    }->Js.Json.string

  let decoderFailCode = json => {
    switch json |> Js.Json.classify {
    | Js.Json.JSONString(str) =>
      switch str {
      | "is-spec-valid" => InvalidSpec(`엑셀파일 필수컬럼 부재`)->Ok
      | "courier-code" => InvalidCourierCode(`올바르지 않은 배송회사 입력`)->Ok
      | "is-your-product" => NotYourProduct(`자신의 상품이 아닌 경우`)->Ok
      | "is-renewable-status" => NotAllowedModify(`수정가능한 상태가 아닌 경우`)->Ok
      | _ => Error({Spice.path: "", message: "알 수 없는 오류", value: json})
      }
    | _ => Error({Spice.path: "", message: "Expected JSONString", value: json})
    }
  }

  let codecFailCode: Spice.codec<failCode> = (encoderFailCode, decoderFailCode)

  @spice
  type failDataJson = {
    @spice.key("row-number") rowNumber: int,
    @spice.key("fail-code") failCode: @spice.codec(codecFailCode) failCode,
  }

  @spice
  type data = {
    @spice.key("created-at") createdAt: string,
    @spice.key("upload-no") orderNo: string,
    status: uploadStatus,
    @spice.key("file-name") filename: string,
    @spice.key("error-code") errorCode: option<@spice.codec(codecErrorCode) errorCode>,
    @spice.key("success-count") successCount: option<int>,
    @spice.key("fail-count") failCount: option<int>,
    @spice.key("fail-data-json") failDataJson: option<array<failDataJson>>,
  }
  @spice
  type response = {
    message: string,
    data: array<data>,
  }

  let use = (~kind, ~uploadType) => {
    let fetcherOptions = Swr.fetcherOptions(
      ~onErrorRetry,
      ~revalidateOnFocus=false,
      ~revalidateOnReconnect=false,
      ~refreshInterval=switch kind {
      | Buyer => 5000
      | Seller => 5000
      | Admin => 3000
      },
      (),
    )

    let {data, error} = Swr.useSwr(
      switch uploadType {
      | Order => `${Env.restApiUrl}/order/recent-uploads?upload-type=order&pay-type=PAID`
      | Invoice => `${Env.restApiUrl}/order/recent-uploads?upload-type=invoice`
      | Offline => `${Env.restApiUrl}/offline-order/recent-uploads?upload-type=offline`
      | OrderAfterPay =>
        `${Env.restApiUrl}/order/recent-uploads?upload-type=order&pay-type=AFTER_PAY`
      },
      FetchHelper.fetcher,
      fetcherOptions,
    )

    let status = switch (error, data) {
    | (None, None) => Loading
    | (None, Some(data')) => Loaded(data')
    | (Some(error'), _) => Error(error')
    }

    status
  }
}

module QueryUser = {
  type result = Waiting | Loading | Loaded(Js.Json.t) | Error(FetchHelper.customError)
  type role = Buyer | Farmer | Admin

  module Farmer = {
    @spice
    type user = {
      id: int,
      uid: string,
      name: string,
      email: option<string>,
      phone: string,
      address: option<string>,
      role: string,
      @spice.key("business-registration-number") businessRegistrationNumber: option<string>,
      @spice.key("producer-type") producerType: option<string>,
      @spice.key("producer-code") producerCode: option<string>,
      @spice.key("created-at") createdAt: string,
      @spice.key("description") producerTypeDescription: option<string>,
      @spice.key("md-name") mdName: option<string>,
      @spice.key("boss-name") rep: option<string>,
      @spice.key("manager") manager: option<string>,
      @spice.key("manager-phone") managerPhone: option<string>,
      @spice.key("etc") etc: option<string>,
    }
    @spice
    type users = {
      data: array<user>,
      count: int,
      offset: int,
      limit: int,
    }

    let use = queryParams => {
      let fetcherOptions = Swr.fetcherOptions(~onErrorRetry, ())

      let {data, error} = Swr.useSwr(
        `${Env.restApiUrl}/user?${queryParams}`,
        FetchHelper.fetcher,
        fetcherOptions,
      )

      let result = switch (error, data) {
      | (None, None) => Loading
      | (None, Some(data')) => Loaded(data')
      | (Some(error'), _) => Error(error')
      }

      result
    }
  }

  module Buyer = {
    @spice
    type status = | @spice.as("CAN-ORDER") CanOrder | @spice.as("CANNOT-ORDER") CanNotOrder

    @spice
    type user = {
      id: int,
      uid: string,
      name: string,
      deposit: float,
      status: status,
      email: string,
      phone: string,
      address: option<string>,
      role: string,
      @spice.key("business-registration-number") businessRegistrationNumber: option<string>,
      manager: option<string>,
      @spice.key("shop-url") shopUrl: option<string>,
    }
    @spice
    type users = {
      data: array<user>,
      count: int,
      offset: int,
      limit: int,
    }

    let use = queryParams => {
      let fetcherOptions = Swr.fetcherOptions(~onErrorRetry, ())

      let {data, error} = Swr.useSwr(
        `${Env.restApiUrl}/user?${queryParams}`,
        FetchHelper.fetcher,
        fetcherOptions,
      )

      let result = switch (error, data) {
      | (None, None) => Loading
      | (None, Some(data')) => Loaded(data')
      | (Some(error'), _) => Error(error')
      }

      result
    }
  }

  module Admin = {
    @spice
    type user = {
      id: int,
      uid: string,
      name: string,
      email: option<string>,
      phone: string,
    }

    @spice
    type users = {
      data: array<user>,
      count: int,
      offset: int,
      limit: int,
    }
  }
}

module Products = {
  type result = Loading | Loaded(Js.Json.t) | Error(FetchHelper.customError)

  /*
   * SALE = 판매중
   * SOLDOUT = 판매중지(품절)
   * HIDDEN_SALE = 전시판매숨김
   * NOSALE = 숨김
   * RETIRE = 영구판매중지
   * HIDDEN = 숨김(depreated)
   */
  @spice
  type salesStatus =
    | @spice.as("SALE") SALE
    | @spice.as("SOLDOUT") SOLDOUT
    | @spice.as("HIDDEN_SALE") HIDDEN_SALE
    | @spice.as("NOSALE") NOSALE
    | @spice.as("RETIRE") RETIRE
    | @spice.as("HIDDEN") HIDDEN

  @spice
  type weightUnit = | @spice.as("g") G | @spice.as("kg") Kg | @spice.as("t") Ton

  @spice
  type sizeUnit = | @spice.as("mm") Mm | @spice.as("cm") Cm | @spice.as("m") M

  @spice
  type product = {
    @spice.key("product-id") productId: int,
    @spice.key("product-name") productName: string,
    @spice.key("product-status") salesStatus: salesStatus,
    @spice.key("stock-sku") productSku: string,
    @spice.key("option-name") productOptionName: option<string>,
    @spice.key("producer-name") producerName: string,
    price: float,
    memo: option<string>,
    @spice.key("cut-off-time") cutOffTime: option<string>,
    @spice.key("md-name") mdName: option<string>,
    weight: option<float>,
    @spice.key("weight-unit") weightUnit: weightUnit,
    @spice.key("package-type") packageType: option<string>,
    @spice.key("count-per-package") cntPerPackage: option<string>,
    @spice.key("grade") grade: option<string>,
    @spice.key("per-weight-max") unitWeightMax: option<float>,
    @spice.key("per-weight-min") unitWeightMin: option<float>,
    @spice.key("per-weight-unit") unitWieghtUnit: weightUnit,
    @spice.key("per-size-max") unitSizeMax: option<float>,
    @spice.key("per-size-min") unitSizeMin: option<float>,
    @spice.key("per-size-unit") unitSizeUnit: sizeUnit,
    @spice.key("item") crop: option<string>,
    @spice.key("kind") cultivar: option<string>,
  }

  @spice
  type products = {
    data: array<product>,
    count: int,
    offset: int,
    limit: int,
  }

  let use = queryParams => {
    let fetcherOptions = Swr.fetcherOptions(~onErrorRetry, ())

    let {data, error} = Swr.useSwr(
      `${Env.restApiUrl}/product?${queryParams}`,
      FetchHelper.fetcher,
      fetcherOptions,
    )

    let result = switch (error, data) {
    | (None, None) => Loading
    | (None, Some(data')) => Loaded(data')
    | (Some(error'), _) => Error(error')
    }

    result
  }
}

module NoIE = {
  let use = (router: Next.Router.router) => {
    React.useEffect1(_ => {
      let browserInfo = DetectBrowser.detect()
      let firstPathname = router.pathname->Js.String2.split("/")->Array.getBy(x => x !== "")

      switch (browserInfo.name, firstPathname) {
      // IE만 /browser-guide 페이지로 리디렉션하여 막는다.
      | ("ie", Some(pathname)) if pathname != "browser-guide" =>
        router->Next.Router.replace("/browser-guide")
      // IE가 /browser-guide 페이지에 접근하는 경우 무한 루프를 막는다.
      | ("ie", Some(pathname)) if pathname == "browser-guide" => ()
      // IE외의 브라우저가 /browser-guide에 접근하는 경우 루트 페이지로 리디렉션 시킨다.
      | (_, Some(pathname)) if pathname === "browser-guide" => router->Next.Router.replace("/")
      | (_, _) => ()
      }

      None
    }, [router])
  }
}

let useInvoice = initialInvoice => {
  let (invoice, setInvoice) = React.Uncurried.useState(_ => initialInvoice)

  let handleOnChangeInvoice = e => {
    let cleanedValue = (e->ReactEvent.Synthetic.currentTarget)["value"]->Helper.Invoice.cleanup
    setInvoice(._ => Some(cleanedValue))
  }

  (invoice, handleOnChangeInvoice)
}

module Costs = {
  type result = Loading | Loaded(Js.Json.t) | Error(FetchHelper.customError)

  @spice
  type contractType = | @spice.as("bulk-sale") Bulksale | @spice.as("online") Online

  @spice
  type cost = {
    cost: option<float>,
    @spice.key("working-cost") workingCost: option<float>,
    @spice.key("delivery-cost") deliveryCost: option<float>,
    @spice.key("raw-cost") rawCost: option<float>,
    @spice.key("effective-date") effectiveDate: string,
    @spice.key("producer-name") producerName: string,
    @spice.key("contract-type") contractType: contractType,
    @spice.key("product-name") productName: string,
    @spice.key("option-name") optionName: string,
    @spice.key("producer-id") producerId: int,
    @spice.key("product-id") productId: int,
    sku: string,
    price: float,
  }

  @spice
  type costs = {
    data: array<cost>,
    count: int,
    offset: int,
    limit: int,
    message: string,
  }

  let use = queryParams => {
    let fetcherOptions = Swr.fetcherOptions(~onErrorRetry, ())

    let {data, error} = Swr.useSwr(
      `${Env.restApiUrl}/settlement/cost?${queryParams}`,
      FetchHelper.fetcher,
      fetcherOptions,
    )

    let result = switch (error, data) {
    | (None, None) => Loading
    | (None, Some(data')) => Loaded(data')
    | (Some(error'), _) => Error(error')
    }

    result
  }
}

module Settlements = {
  type result = Loading | Loaded(Js.Json.t) | Error(FetchHelper.customError)

  @spice
  type settlementCycle =
    | @spice.as("week") Week | @spice.as("half-month") HalfMonth | @spice.as("month") Month

  @spice
  type settlement = {
    @spice.key("producer-code") producerCode: string,
    @spice.key("producer-name") producerName: string,
    @spice.key("settlement-cycle")
    settlementCycle: settlementCycle,
    @spice.key("invoice-updated-sum") invoiceUpdatedSum: float,
    @spice.key("false-excluded-sum") falseExcludedSum: float,
    @spice.key("complete-sum") completeSum: float,
    @spice.key("false-excluded-tax") falseExcludedTax: float,
    @spice.key("complete-tax") completeTax: float,
  }

  @spice
  type settlements = {
    data: array<settlement>,
    count: int,
    offset: int,
    limit: int,
    message: string,
  }

  let use = queryParams => {
    let fetcherOptions = Swr.fetcherOptions(~onErrorRetry, ())

    let {data, error} = Swr.useSwr(
      `${Env.restApiUrl}/settlement?${queryParams}`,
      FetchHelper.fetcher,
      fetcherOptions,
    )

    let result = switch (error, data) {
    | (None, None) => Loading
    | (None, Some(data')) => Loaded(data')
    | (Some(error'), _) => Error(error')
    }

    result
  }
}

module UserDeposit = {
  type result = Loading | Loaded(Js.Json.t) | Error(FetchHelper.customError)

  @spice
  type data = {deposit: float}

  @spice
  type response = {
    data: data,
    message: string,
  }

  let use = queryParams => {
    let fetcherOptions = Swr.fetcherOptions(~onErrorRetry, ())

    let {data, error} = Swr.useSwr(
      `${Env.restApiUrl}/user/deposit?${queryParams}`,
      FetchHelper.fetcher,
      fetcherOptions,
    )

    let result = switch (error, data) {
    | (None, None) => Loading
    | (None, Some(data')) => Loaded(data')
    | (Some(error'), _) => Error(error')
    }

    result
  }
}

module Transaction = {
  type result = Loading | Loaded(Js.Json.t) | Error(FetchHelper.customError)

  @spice
  type kind =
    | @spice.as("order-complete") OrderComplete
    | @spice.as("cash-refund") CashRefund
    | @spice.as("imweb-pay") ImwebPay
    | @spice.as("imweb-cancel") ImwebCancel
    | @spice.as("order-cancel") OrderCancel
    | @spice.as("order-refund-delivery-delayed") OrderRefundDeliveryDelayed
    | @spice.as("order-refund-defective-product") OrderRefundDefectiveProduct
    | @spice.as("sinsun-cash") SinsunCash

  @spice
  type transaction = {
    id: int,
    @spice.key("type") type_: kind,
    amount: float,
    @spice.key("created-at") createdAt: string,
    deposit: float,
  }

  @spice
  type response = {
    data: array<transaction>,
    message: string,
    count: int,
    offset: int,
    limit: int,
  }

  let use = queryParams => {
    let fetcherOptions = Swr.fetcherOptions(~onErrorRetry, ())

    let {data, error} = Swr.useSwr(
      `${Env.restApiUrl}/transaction?${queryParams}`,
      FetchHelper.fetcher,
      fetcherOptions,
    )

    let result = switch (error, data) {
    | (None, None) => Loading
    | (None, Some(data')) => Loaded(data')
    | (Some(error'), _) => Error(error')
    }

    result
  }
}

module TransactionSummary = {
  type result = Loading | Loaded(Js.Json.t) | Error(FetchHelper.customError)

  type amounts =
    | OrderComplete
    | CashRefund
    | ImwebPay
    | ImwebCancel
    | OrderCancel
    | OrderRefund
    | Deposit
    | SinsunCash

  @spice
  type data = {
    @spice.key("order-complete") orderComplete: float,
    @spice.key("cash-refund") cashRefund: float,
    @spice.key("imweb-pay") imwebPay: float,
    @spice.key("imweb-cancel") imwebCancel: float,
    @spice.key("order-cancel") orderCancel: float,
    @spice.key("order-refund") orderRefund: float,
    @spice.key("sinsun-cash") sinsunCash: float,
    deposit: float,
  }

  @spice
  type response = {
    data: data,
    message: string,
  }

  let use = queryParams => {
    let fetcherOptions = Swr.fetcherOptions(~onErrorRetry, ~revalidateIfStale=true, ())

    let {data, error} = Swr.useSwr(
      `${Env.restApiUrl}/transaction/summary?${queryParams}`,
      FetchHelper.fetcher,
      fetcherOptions,
    )

    let result = switch (error, data) {
    | (None, None) => Loading
    | (None, Some(data')) => Loaded(data')
    | (Some(error'), _) => Error(error')
    }

    result
  }
}

module Downloads = {
  type result = Loading | Loaded(Js.Json.t) | Error(FetchHelper.customError)

  /*
   * REQUEST = 다운로드 요청
   * PROCESSING = 다운로드 파일 생성중
   * SUCCESS = 다운로드 가능
   * FAIL = 다운로드 오류
   */
  @spice
  type status =
    | @spice.as("REQUEST") REQUEST
    | @spice.as("PROCESSING") PROCESSING
    | @spice.as("SUCCESS") SUCCESS
    | @spice.as("FAIL") FAIL
  /*
  - id : id
  - request-message-id : sqs 요청시 생성된 메세지 id
  - requested-at : 요청일시 (UTC)
  - type : 엑셀 유형 (product-buyer, product-admin, user-transaction, order, invoice, settlement, farmer-user, buyer-user, ...앞으로 더 늘어날 수 있음)
  - status : 진행상황 (REQUEST -> PROCESSING -> SUCCESS/FAIL)
  - file-name : 파일명
  - file-path : 파일 업로드 경로
  - file-expired-at : 파일 만료일시 (UTC)
 */
  @spice
  type download = {
    id: int,
    @spice.key("requested-at") requestAt: string,
    @spice.key("file-name") filename: string,
    status: status,
    @spice.key("file-expired-at") expiredAt: option<string>,
    @spice.key("request-message-id") requestMessageId: option<string>,
    @spcie.key("type") excelType: option<string>,
    @spice.key("file-path") filepath: option<string>,
  }

  @spice
  type downloads = {
    data: array<download>,
    count: int,
    offset: int,
    limit: int,
  }

  let use = queryParams => {
    let fetcherOptions = Swr.fetcherOptions(~onErrorRetry, ~refreshInterval=10000, ())

    let {data, error} = Swr.useSwr(
      `${Env.restApiUrl}/excel-export?${queryParams}`,
      FetchHelper.fetcher,
      fetcherOptions,
    )
    let result = switch (error, data) {
    | (None, None) => Loading
    | (None, Some(data')) => Loaded(data')
    | (Some(error'), _) => Error(error')
    }

    result
  }
}

module Shipments = {
  type result = Loading | Loaded(Js.Json.t) | Error(FetchHelper.customError)

  @spice
  type marketType =
    | @spice.as("online") ONLINE | @spice.as("wholesale") WHOLESALE | @spice.as("offline") OFFLINE

  @spice
  type shipment = {
    @spice.key("shipment-date") date: string,
    @spice.key("market-type") marketType: marketType,
    @spice.key("item") crop: string,
    @spice.key("kind") cultivar: string,
    @spice.key("weight") weight: option<float>,
    @spice.key("weight-unit") weightUnit: option<Products.weightUnit>,
    @spice.key("package-type") packageType: option<string>,
    @spice.key("grade") grade: option<string>,
    @spice.key("total-quantity") totalQuantity: float,
    @spice.key("total-price") totalPrice: float,
    sku: string,
  }

  @spice
  type shipments = {
    data: array<shipment>,
    count: int,
    offset: int,
    limit: int,
  }

  let use = queryParams => {
    let fetcherOptions = Swr.fetcherOptions(~onErrorRetry, ())

    let {data, error} = Swr.useSwr(
      `${Env.restApiUrl}/shipment?${queryParams}`,
      FetchHelper.fetcher,
      fetcherOptions,
    )

    let result = switch error {
    | Some(error') => Error(error')
    | None =>
      switch data {
      | Some(data') => Loaded(data')
      | None => Loading
      }
    }

    result
  }
}

module ShipmentSummary = {
  type result = Loading | Loaded(Js.Json.t) | Error(FetchHelper.customError)

  @spice
  type response = {
    @spice.key("data") price: float,
    message: string,
  }

  let use = queryParam => {
    let fetcherOptions = Swr.fetcherOptions(~onErrorRetry, ())

    let {data, error} = Swr.useSwr(
      `${Env.restApiUrl}/shipment/amounts?${queryParam}`,
      FetchHelper.fetcher,
      fetcherOptions,
    )

    let result = switch error {
    | Some(error') => Error(error')
    | None =>
      switch data {
      | Some(data') => Loaded(data')
      | None => Loading
      }
    }

    result
  }
}

module ShipmentMontlyAmount = {
  type result = Loading | Loaded(Js.Json.t) | Error(FetchHelper.customError)

  @spice
  type response = {
    @spice.key("data") price: float,
    message: string,
  }

  let use = () => {
    let fetcherOptions = Swr.fetcherOptions(~onErrorRetry, ())

    let {data, error} = Swr.useSwr(
      `${Env.restApiUrl}/shipment/monthly-amounts?market-type=all`,
      FetchHelper.fetcher,
      fetcherOptions,
    )

    let result = switch error {
    | Some(error') => Error(error')
    | None =>
      switch data {
      | Some(data') => Loaded(data')
      | None => Loading
      }
    }

    result
  }
}

module OfflineOrders = {
  type result = Loading | Loaded(Js.Json.t) | Error(FetchHelper.customError)

  @spice
  type offlineOrder = {
    id: int,
    @spice.key("order-product-no") orderProductNo: string,
    @spice.key("sku") sku: string,
    @spice.key("created-at") createdAt: string,
    @spice.key("release-date") releaseDate: option<string>,
    @spice.key("order-no") orderNo: string,
    @spice.key("order-quantity-complete") confirmedOrderQuantity: option<float>,
    @spice.key("order-quantity") orderQuantity: float,
    @spice.key("buyer-sell-price") price: float,
    @spice.key("producer-name") producerName: string,
    @spice.key("producer-id") producerId: int,
    @spice.key("buyer-name") buyerName: string,
    @spice.key("buyer-id") buyerId: int,
    @spice.key("producer-product-cost") cost: float,
    @spice.key("item") crop: string,
    @spice.key("order-product-id") orderProductId: string,
    @spice.key("release-due-date") releaseDueDate: string,
    @spice.key("kind") cultivar: string,
    @spice.key("weight") weight: option<float>,
    @spice.key("weight-unit") weightUnit: Products.weightUnit,
    @spice.key("package-type") packageType: option<string>,
    @spice.key("grade") grade: option<string>,
  }

  @spice
  type offlineOrders = {
    data: array<offlineOrder>,
    count: int,
    offset: int,
    limit: int,
  }

  let use = queryParams => {
    let fetcherOptions = Swr.fetcherOptions(~onErrorRetry, ())

    let {data, error} = Swr.useSwr(
      `${Env.restApiUrl}/offline-order?${queryParams}`,
      FetchHelper.fetcher,
      fetcherOptions,
    )

    let result = switch error {
    | Some(error') => Error(error')
    | None =>
      switch data {
      | Some(data') => Loaded(data')
      | None => Loading
      }
    }

    result
  }
}

module OfflineUploadStatus = {
  type status = Loading | Loaded(Js.Json.t) | Error(FetchHelper.customError)

  @spice
  type errorCode =
    | Sku(string)
    | EncryptedDocument(string)
    | Role(string)
    | Columns(string)
    | BuyerId(string)
    | ReleaseDueDate(string)
    | ProductDetail(string)
    | Etc(string)

  let encoderErrorCode = v =>
    switch v {
    | Sku(s) => s
    | EncryptedDocument(s) => s
    | Role(s) => s
    | Columns(s) => s
    | BuyerId(s) => s
    | ReleaseDueDate(s) => s
    | ProductDetail(s) => s
    | Etc(s) => s
    }->Js.Json.string

  let decoderErrorCode = json => {
    switch json |> Js.Json.classify {
    | Js.Json.JSONString(str) =>
      switch str {
      | "encrypted-document" =>
        EncryptedDocument(`엑셀 파일에 암호가 걸려 있습니다.`)->Ok
      | "sku" => Sku(`옵션코드(C열)에 문제를 발견하였습니다.`)->Ok
      | "role" =>
        Role(`유저 role 유효성검증이 실패하였습다.(admin이 아닌 유저)`)->Ok
      | "columns" => Columns(`엑셀데이터 유효성검증에 실패하였습니다.`)->Ok
      | "buyer-id" => BuyerId(`바이어id 유효성검증에 실패하였습니다.`)->Ok
      | "release-due-date" =>
        ReleaseDueDate(`출고예정일 유효성검증에 실패하였습니다.`)->Ok
      | "product-detail" =>
        ProductDetail(`등록할 상품 상세정보를 기입해주세요.`)->Ok
      | "etc" => Etc(`알 수 없는 오류가 발생하였습니다.`)->Ok
      | _ => Error({Spice.path: "", message: "Expected JSONString", value: json})
      }
    | _ => Error({Spice.path: "", message: "Expected JSONString", value: json})
    }
  }

  let codecErrorCode: Spice.codec<errorCode> = (encoderErrorCode, decoderErrorCode)

  @spice
  type data = {
    @spice.key("created-at") createdAt: string,
    @spice.key("upload-no") uploadNo: string,
    status: UploadStatus.uploadStatus,
    @spice.key("file-name") filename: string,
    @spice.key("error-code") errorCode: option<@spice.codec(codecErrorCode) errorCode>,
    @spice.key("error-msg") errorMsg: option<string>,
    @spice.key("fail-data-json") fileDataRows: option<array<int>>,
  }

  @spice
  type response = {
    message: string,
    data: array<data>,
  }

  let use = () => {
    let fetcherOptions = Swr.fetcherOptions(
      ~onErrorRetry,
      ~revalidateOnFocus=false,
      ~revalidateOnReconnect=false,
      ~refreshInterval=3000,
      (),
    )

    let {data, error} = Swr.useSwr(
      `${Env.restApiUrl}/offline-order/recent-uploads`,
      FetchHelper.fetcher,
      fetcherOptions,
    )

    let status = switch error {
    | Some(error') => Error(error')
    | None =>
      switch data {
      | Some(data') => Loaded(data')
      | None => Loading
      }
    }

    status
  }
}

module AdminS3PresignedUrl = {
  @spice
  type response = {
    message: string,
    @spice.key("download-url") downloadUrl: string,
  }
}

module CropCategory = {
  type result = Loading | Loaded(Js.Json.t) | Error(FetchHelper.customError)

  @spice
  type category = {
    @spice.key("id") id: int,
    @spice.key("item-id") cropId: int,
    @spice.key("item") crop: string,
    @spice.key("kind") cultivar: string,
  }

  @spice
  type data = array<category>

  @spice
  type response = {
    data: data,
    message: string,
  }
}

module WholeSale = {
  type result = Loading | Loaded(Js.Json.t) | Error(FetchHelper.customError)

  @spice
  type order = {
    @spice.key("market-short-name") marketName: string,
    @spice.key("wholesaler-short-name") wholesalerName: string,
    @spice.key("unit-price") unitPrice: float,
    quantity: float,
  }

  @spice
  type bulksale = {
    difference: float,
    @spice.key("total-difference") totalDiff: float,
    @spice.key("unit-price") unitPrice: float,
  }

  @spice
  type wholesale = {
    @spice.key("settlement-date") date: string,
    @spice.key("item") crop: string,
    @spice.key("kind") cultivar: string,
    weight: option<float>,
    @spice.key("package-type") packageType: string,
    grade: string,
    @spice.key("total-quantity") totalQuantity: float,
    @spice.key("total-auction-fee") totalAuctionFee: float,
    @spice.key("total-transport-cost") totalTransportCost: float,
    @spice.key("total-package-cost-support") totalPackageCostSpt: float,
    @spice.key("total-settlement-amount") totalSettlementAmount: float,
    @spice.key("total-unloading-cost") totalUnloadingCost: float,
    @spice.key("total-transport-cost-support") totalTransportCostSpt: float,
    @spice.key("avg-unit-price") avgUnitPirce: float,
    @spice.key("order-list") orders: array<order>,
    bulksale: option<bulksale>,
  }

  @spice
  type response = {
    data: wholesale,
    message: string,
  }

  let use = queryParams => {
    let fetcherOptions = Swr.fetcherOptions(~onErrorRetry, ())

    let {data, error} = Swr.useSwr(
      `${Env.restApiUrl}/wholesale-market-order?${queryParams}`,
      FetchHelper.fetcher,
      fetcherOptions,
    )

    let result = switch error {
    | Some(error') => Error(error')
    | None =>
      switch data {
      | Some(data') => Loaded(data')
      | None => Loading
      }
    }

    result
  }
}

module BulkSaleLedger = {
  type result = Loading | Loaded(Js.Json.t) | Error(FetchHelper.customError)

  @spice
  type response = {
    url: string,
    path: string,
  }

  let use = path => {
    let fetcherOptions = Swr.fetcherOptions(~onErrorRetry, ())

    let {data, error} = Swr.useSwr(
      `${Env.restApiUrl}/farmmorning-bridge/api/bulk-sale/product-sale-ledger/issue-s3-get-url?path=${path}`,
      FetchHelper.fetcher,
      fetcherOptions,
    )

    let result = switch error {
    | Some(error') => Error(error')
    | None =>
      switch data {
      | Some(data') => Loaded(data')
      | None => Loading
      }
    }

    result
  }
}

module AfterPayBuyer = {
  type result = Loading | Loaded(Js.Json.t) | Error(FetchHelper.customError)

  @spice
  type buyerType = EXISTING_BUYER | NEW_BUYER

  @spice
  type response = {
    id: int,
    buyerType: buyerType,
    name: string,
    bizNum: string,
  }

  let use = userId => {
    let fetcherOptions = Swr.fetcherOptions(~onErrorRetry, ())

    let {data, error} = Swr.useSwr(() => {
      userId->Belt.Option.map(id => `${Env.afterPayApiUrl}/buyers/${id->Js.Int.toString}/`)
    }, FetchHelper.fetcher, fetcherOptions)

    let result = switch error {
    | Some(error') => Error(error')
    | None =>
      switch data {
      | Some(data') => Loaded(data')
      | None => Loading
      }
    }

    result
  }
}

module AfterPayCredit = {
  @spice
  type buyerType =
    | @spice.as("EXISTING_BUYER") EXISTING_BUYER
    | @spice.as("NEW_BUYER") NEW_BUYER

  @spice
  type credit = {
    debtTotal: int,
    debtMax: int,
    debtExpiryDays: int,
    debtInterestRate: float,
    isAfterPayEnabled: bool,
  }

  @spice
  type response = {
    id: int,
    buyerType: buyerType,
    name: string,
    bizNum: string,
    credit: credit,
  }

  type result = Loading | Loaded(response) | NotRegistered | Error(FetchHelper.customError)

  let useGetUrl = () => {
    let user = User.Buyer.use()
    let userId = switch user {
    | Auth.LoggedIn({id}) => Some(id)
    | Auth.NotLoggedIn
    | Unknown =>
      None
    }

    userId->Belt.Option.map(id => `${Env.afterPayApiUrl}/buyers/${id->Js.Int.toString}/credit`)
  }

  let use = () => {
    let url = useGetUrl()

    let fetcherOptions = Swr.fetcherOptions(~onErrorRetry, ())

    let {data, error} = Swr.useSwr(() => url, FetchHelper.fetcher, fetcherOptions)

    switch error {
    | Some({status: 404}) => NotRegistered
    | Some(error') => Error(error')
    | None =>
      switch data {
      | Some(data') =>
        switch data'->response_decode {
        | Ok(response) => Loaded(response)
        | Error(e) => {
            data'->Js.log
            e->Js.log
            Error({status: 500, info: Js.Json.string("decode failed"), message: None})
          }
        }
      | None => Loading
      }
    }
  }
}

module AfterPayAgreement = {
  @spice
  type buyerType =
    | @spice.as("EXISTING_BUYER") EXISTING_BUYER
    | @spice.as("NEW_BUYER") NEW_BUYER

  @spice
  type agreement = {agreement: string}

  @spice
  type response = {
    id: int,
    buyerType: buyerType,
    name: string,
    bizNum: string,
    terms: array<agreement>,
  }

  type result = Loading | Loaded(response) | NotRegistered | Error(FetchHelper.customError)

  let use = () => {
    let user = User.Buyer.use()
    let userId = switch user {
    | LoggedIn({id}) => Some(id)
    | NotLoggedIn
    | Unknown =>
      None
    }

    let fetcherOptions = Swr.fetcherOptions(~onErrorRetry, ())

    let {data, error} = Swr.useSwr(() => {
      userId->Belt.Option.map(id => `${Env.afterPayApiUrl}/buyers/${id->Js.Int.toString}/terms`)
    }, FetchHelper.fetcher, fetcherOptions)

    switch error {
    | Some({status: 404}) => NotRegistered
    | Some(error') => Error(error')
    | None =>
      switch data {
      | Some(data') =>
        switch data'->response_decode {
        | Ok(response) => Loaded(response)
        | Error(e) => {
            data'->Js.log
            e->Js.log
            Error({status: 500, info: Js.Json.string("decode failed"), message: None})
          }
        }
      | None => Loading
      }
    }
  }
}

module AfterPayOrdersList = {
  @spice
  type state =
    | @spice.as("WAITING_REPAYMENT") WAITING_REPAYMENT
    | @spice.as("FULL_REPAYMENT") FULL_REPAYMENT
    | @spice.as("CANCELED") CANCELED
    | @spice.as("OVERDUE") OVERDUE
    | @spice.as("PARTIAL_REPAYMENT") PARTIAL_REPAYMENT

  let stateToString = state =>
    switch state {
    | WAITING_REPAYMENT => `상환전`
    | FULL_REPAYMENT => `상환완료`
    | CANCELED => `취소`
    | OVERDUE => `연체`
    | PARTIAL_REPAYMENT => `일부 상환`
    }

  @spice
  type order = {
    paymentWithFees: float,
    payment: float,
    debt: float,
    loanFees: float,
    lateFees: float,
    state: state,
    debtDueDate: string,
    createdAt: string,
  }

  @spice
  type list = {
    size: int,
    totalCount: int,
    totalPage: int,
    data: array<order>,
  }

  type result = Loading | Loaded(list) | Error(FetchHelper.customError)

  let use = page => {
    let user = User.Buyer.use()
    let userId = switch user {
    | LoggedIn({id}) => Some(id)
    | NotLoggedIn
    | Unknown =>
      None
    }

    let fetcherOptions = Swr.fetcherOptions(~onErrorRetry, ())

    let {data, error} = Swr.useSwr(() => {
      userId->Belt.Option.map(id =>
        `${Env.afterPayApiUrl}/orders?buyer_id=${id->Belt.Int.toString}&page=${page->Belt.Int.toString}&size=10`
      )
    }, FetchHelper.fetcher, fetcherOptions)

    switch error {
    | Some(error') => Error(error')
    | None =>
      switch data {
      | Some(data') =>
        switch data'->list_decode {
        | Ok(response) => Loaded(response)
        | Error(e) => {
            data'->Js.log
            e->Js.log
            Error({status: 500, info: Js.Json.string("decode failed"), message: None})
          }
        }
      | None => Loading
      }
    }
  }
}

let useSmoothScroll = () => {
  React.useEffect0(_ => {
    open Webapi
    let htmlElement = Dom.document->Dom.Document.documentElement
    htmlElement->Dom.Element.setClassName("scroll-smooth")

    Some(
      () => {
        let currentClassName = htmlElement->Dom.Element.className
        let nextClassName = currentClassName->Js.String2.replace("scroll-smooth", "")
        htmlElement->Dom.Element.setClassName(nextClassName)
      },
    )
  })
}

module UserAgent = {
  type dimension =
    | Unknown
    | PC
    | Mobile

  let useDimension = () => {
    let (dimension, setDimension) = React.Uncurried.useState(_ => Unknown)

    React.useEffect0(() => {
      // TODO: user-agent 기반으로 개선
      setDimension(._ => Webapi.Dom.window->Webapi.Dom.Window.innerWidth < 1280 ? Mobile : PC)

      None
    })

    dimension
  }
}
