/*
  1. 컴포넌트 위치
  바이어 센터 전시 매장 > PDP Page > 주문 버튼
  
  2. 역할
  {인증}/{단품 선택 여부} 등을 고려한 일반상품의 주문 버튼을 보여줍니다.
*/

module Fragment = %relay(`
  fragment PDPProductNormalSubmitBuyerFragment on Product
  @argumentDefinitions(
    first: { type: "Int", defaultValue: 20 }
    after: { type: "ID", defaultValue: null }
  ) {
    status
    type_: type
    productOptions(first: $first, after: $after) {
      edges {
        node {
          stockSku
          price
          status
          productOptionCost {
            deliveryCost
          }
        }
      }
    }
  }
`)

module PC = {
  @react.component
  let make = (
    ~query,
    ~selected: option<PDP_SelectOption_Buyer.selectedSku>,
    ~quantity,
    ~setQuantity,
  ) => {
    let user = CustomHooks.User.Buyer.use2()

    let {status} = query->Fragment.use

    let (showModal, setShowModal) = React.Uncurried.useState(_ =>
      PDP_Product_Normal_Modals_Buyer.Hide
    )

    switch status {
    | #SOLDOUT =>
      let btnStyle = %twc(
        "w-full h-16 rounded-xl flex items-center justify-center bg-gray-300 text-white font-bold text-xl"
      )
      <button disabled=true className=btnStyle> <span> {`품절`->React.string} </span> </button>

    | _ =>
      let btnStyle = %twc(
        "w-full h-16 rounded-xl flex items-center justify-center bg-primary hover:bg-primary-variant text-lg font-bold text-white"
      )
      <>
        {switch user {
        | Unknown =>
          <button className=btnStyle> <span> {`구매하기`->React.string} </span> </button>

        | NotLoggedIn => {
            let onClick = ReactEvents.interceptingHandler(_ => {
              setShowModal(._ => Show(Unauthorized))
            })

            <button onClick className=btnStyle>
              <span> {`구매하기`->React.string} </span>
            </button>
          }

        | LoggedIn(_) => {
            let onClick = ReactEvents.interceptingHandler(_ => {
              switch selected {
              | None => setShowModal(._ => Show(NoOption))
              | Some(_) => setShowModal(._ => Show(Confirm))
              }
            })

            <button onClick className=btnStyle>
              <span> {`구매하기`->React.string} </span>
            </button>
          }
        }}
        <PDP_Product_Normal_Modals_Buyer.PC
          show=showModal setShow=setShowModal selected quantity setQuantity
        />
      </>
    }
  }
}

module MO = {
  module CTAContainer = {
    @react.component
    let make = (~children=?) => {
      <div className=%twc("fixed w-full bottom-0 left-0")>
        <div className=%twc("w-full max-w-[768px] p-3 mx-auto border-t border-t-gray-100 bg-white")>
          <div className=%twc("w-full h-14 flex")>
            <button onClick={ReactEvents.interceptingHandler(_ => ChannelTalk.showMessenger())}>
              <img
                src="/icons/cs-gray-square.png"
                className=%twc("w-14 h-14 mr-2")
                alt="cta-cs-btn-mobile"
              />
            </button>
            {children->Option.getWithDefault(React.null)}
          </div>
        </div>
      </div>
    }
  }

  module OrderBtn = {
    @react.component
    let make = (~status, ~selected, ~setShowModal) => {
      let user = CustomHooks.User.Buyer.use2()

      let btnStyle = %twc(
        "flex flex-1 rounded-xl items-center justify-center bg-primary font-bold text-white"
      )

      let disabledStyle = %twc(
        "flex flex-1 rounded-xl items-center justify-center bg-gray-300 text-white font-bold"
      )

      switch status {
      | #SOLDOUT =>
        <button disabled=true className=disabledStyle> {`품절`->React.string} </button>

      | _ =>
        switch user {
        | Unknown =>
          <button disabled=true className=disabledStyle> {`구매하기`->React.string} </button>

        | NotLoggedIn => <>
            <button
              className=btnStyle
              onClick={ReactEvents.interceptingHandler(_ => {
                setShowModal(._ => PDP_Product_Normal_Modals_Buyer.Show(Unauthorized))
              })}>
              {`구매하기`->React.string}
            </button>
          </>

        | LoggedIn(_) =>
          <button
            className=btnStyle
            onClick={ReactEvents.interceptingHandler(_ => {
              switch selected {
              | None => setShowModal(._ => Show(NoOption))
              | Some(_) => setShowModal(._ => Show(Confirm))
              }
            })}>
            {`구매하기`->React.string}
          </button>
        }
      }
    }
  }

  module RfqBtn = {
    @react.component
    let make = () => {
      let user = CustomHooks.User.Buyer.use2()

      let btnStyle = %twc(
        "flex flex-1 items-center justify-center rounded-xl bg-white border border-primary text-primary text-lg font-bold"
      )
      let disabledStyle = %twc("flex flex-1 items-center justify-center rounded-xl bg-disabled-L2")

      let (showModal, setShowModal) = React.Uncurried.useState(_ =>
        PDP_Product_Quoted_Modals_Buyer.Hide
      )

      switch user {
      | Unknown =>
        <button className=disabledStyle> {`최저가 견적문의`->React.string} </button>

      | NotLoggedIn => <>
          <button
            className=btnStyle
            onClick={ReactEvents.interceptingHandler(_ => {
              setShowModal(._ => PDP_Product_Quoted_Modals_Buyer.Show(Unauthorized))
            })}>
            {`최저가 견적문의`->React.string}
          </button>
          <PDP_Product_Quoted_Modals_Buyer.MO show=showModal setShow=setShowModal />
        </>

      | LoggedIn({role}) =>
        switch role {
        | Admin | Seller =>
          <button className=disabledStyle> {`최저가 견적문의`->React.string} </button>

        | Buyer => <RfqCreateRequestButton className=btnStyle buttonText=`최저가 견적문의` />
        }
      }
    }
  }

  @react.component
  let make = (
    ~query,
    ~selected: option<PDP_SelectOption_Buyer.selectedSku>,
    ~quantity,
    ~setQuantity,
  ) => {
    let {status, type_} = query->Fragment.use

    let (showModal, setShowModal) = React.Uncurried.useState(_ =>
      PDP_Product_Normal_Modals_Buyer.Hide
    )

    switch type_ {
    | #QUOTABLE =>
      let gap = %twc("w-2")
      <>
        // 컨텐츠 내 버튼
        <div className=%twc("w-full h-14 flex")>
          <RfqBtn /> <div className=gap /> <OrderBtn status selected setShowModal />
        </div>
        // 플로팅 버튼
        <CTAContainer>
          <RfqBtn /> <div className=gap /> <OrderBtn status selected setShowModal />
        </CTAContainer>
        <PDP_Product_Normal_Modals_Buyer.MO
          show=showModal setShow=setShowModal selected setQuantity quantity
        />
      </>

    | _ => <>
        // 컨텐츠 내 버튼
        <div className=%twc("w-full h-14 flex")> <OrderBtn status selected setShowModal /> </div>
        // 플로팅 버튼
        <CTAContainer> <OrderBtn status selected setShowModal /> </CTAContainer>
        <PDP_Product_Normal_Modals_Buyer.MO
          show=showModal setShow=setShowModal selected setQuantity quantity
        />
      </>
    }
  }
}
