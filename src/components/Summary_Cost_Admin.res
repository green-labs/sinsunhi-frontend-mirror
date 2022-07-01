module FormFields = Query_Cost_Form_Admin.FormFields
module Form = Query_Cost_Form_Admin.Form

type productIdentifier = ProductIds | ProductSkus

let parseProductIdentifier = value =>
  if value === `product-ids` {
    Some(ProductIds)
  } else if value === `product-sku` {
    Some(ProductSkus)
  } else {
    None
  }
let stringifyProductIdentifier = productIdentifier =>
  switch productIdentifier {
  | ProductIds => `상품번호`
  | ProductSkus => `단품번호`
  }

@react.component
let make = () => {
  let router = Next.Router.useRouter()

  let (productIdentifier, setProductIdentifier) = React.Uncurried.useState(_ => ProductIds)

  let handleOnSelect = (setFn, e) => {
    let value = (e->ReactEvent.Synthetic.target)["value"]
    if value === `상품번호` {
      setFn(._ => ProductIds)
    } else if value === `단품번호` {
      setFn(._ => ProductSkus)
    } else {
      setFn(._ => ProductIds)
    }
  }

  let onSubmit = ({state}: Form.onSubmitAPI) => {
    let producerName = state.values->FormFields.get(FormFields.ProducerName)
    let productName = state.values->FormFields.get(FormFields.ProductName)
    let productIdsOrSkus = state.values->FormFields.get(FormFields.ProductIdsOrSkus)

    let {makeWithDict, toString} = module(Webapi.Url.URLSearchParams)

    Js.Dict.unsafeDeleteKey(. router.query, "product-ids")
    Js.Dict.unsafeDeleteKey(. router.query, "skus")

    router.query->Js.Dict.set("producer-name", producerName)
    router.query->Js.Dict.set("product-name", productName)

    switch productIdentifier {
    | ProductIds => router.query->Js.Dict.set("product-ids", productIdsOrSkus)
    | ProductSkus => router.query->Js.Dict.set("skus", productIdsOrSkus)
    }

    router->Next.Router.push(`${router.pathname}?${router.query->makeWithDict->toString}`)

    None
  }

  let form: Form.api = Form.use(
    ~validationStrategy=Form.OnChange,
    ~onSubmit,
    ~initialState=Query_Cost_Form_Admin.initialState,
    ~schema={
      open Form.Validation
      Schema(
        [
          regExp(
            ProductIdsOrSkus,
            ~matches="^([0-9]+([,\n\s]+)?)*$",
            ~error=`숫자(Enter 또는 ","로 구분 가능)만 입력해주세요`,
          ),
        ]->Array.concatMany,
      )
    },
    (),
  )

  let handleOnSubmit = (
    _ => {
      form.submit()
    }
  )->ReactEvents.interceptingHandler

  React.useEffect1(_ => {
    router.query
    ->Js.Dict.entries
    ->Garter.Array.forEach(entry => {
      let (k, v) = entry
      if k === "producer-name" {
        FormFields.ProducerName->form.setFieldValue(v, ~shouldValidate=true, ())
      } else if k === "product-name" {
        FormFields.ProductName->form.setFieldValue(v, ~shouldValidate=true, ())
      } else if k === "product-ids" {
        setProductIdentifier(._ => ProductIds)
        FormFields.ProductIdsOrSkus->form.setFieldValue(v, ~shouldValidate=true, ())
      } else if k === "skus" {
        setProductIdentifier(._ => ProductSkus)
        FormFields.ProductIdsOrSkus->form.setFieldValue(v, ~shouldValidate=true, ())
      }
    })

    None
  }, [router.query])

  let handleOnReset = (
    _ => {
      FormFields.ProducerName->form.setFieldValue("", ~shouldValidate=true, ())
      FormFields.ProductName->form.setFieldValue("", ~shouldValidate=true, ())
      FormFields.ProductIdsOrSkus->form.setFieldValue("", ~shouldValidate=true, ())
    }
  )->ReactEvents.interceptingHandler

  // <textarea> 에서 엔터를 입력하는 경우 폼 submit으로 처리한다.
  // 줄바꿈은 쉬프트 엔터
  let handleKeyDownEnter = (e: ReactEvent.Keyboard.t) => {
    if e->ReactEvent.Keyboard.keyCode === 13 && e->ReactEvent.Keyboard.shiftKey === false {
      e->ReactEvent.Keyboard.preventDefault

      form.submit()
    }
  }

  <div className=%twc("p-7 m-4 bg-white shadow-gl rounded")>
    <form onSubmit={handleOnSubmit}>
      <h2 className=%twc("text-text-L1 text-lg font-bold mb-5")>
        {j`상품 검색`->React.string}
      </h2>
      <div className=%twc("py-6 flex flex-col text-sm bg-gray-gl rounded-xl")>
        <div className=%twc("flex")>
          <div className=%twc("w-32 font-bold mt-2 pl-7 whitespace-nowrap")>
            {j`검색`->React.string}
          </div>
          <div className=%twc("flex-1")>
            <div className=%twc("flex")>
              <div className=%twc("flex w-64 items-center mr-14")>
                <label htmlFor="seller-name" className=%twc("block whitespace-nowrap w-20 mr-2")>
                  {j`생산자명`->React.string}
                </label>
                <Input
                  type_="text"
                  name="seller-name"
                  className=%twc("flex-1")
                  placeholder=`생산자명`
                  value={form.values->FormFields.get(FormFields.ProducerName)}
                  onChange={FormFields.ProducerName->form.handleChange->ReForm.Helpers.handleChange}
                  error=None
                  tabIndex=1
                />
              </div>
              <div className=%twc("flex w-64 items-center")>
                <label htmlFor="product-name" className=%twc("whitespace-nowrap w-16")>
                  {j`상품명`->React.string}
                </label>
                <Input
                  type_="text"
                  name="product-name"
                  placeholder=`상품명`
                  value={form.values->FormFields.get(FormFields.ProductName)}
                  onChange={FormFields.ProductName->form.handleChange->ReForm.Helpers.handleChange}
                  error=None
                  tabIndex=2
                />
              </div>
            </div>
            <div className=%twc("flex mt-3")>
              <div className=%twc("w-64 flex items-center mr-2")>
                <label htmlFor="product-identifier" className=%twc("block whitespace-nowrap w-16")>
                  {j`범위`->React.string}
                </label>
                <div className=%twc("flex-1 block relative")>
                  <span
                    className=%twc(
                      "flex items-center border border-border-default-L1 rounded-lg py-2 px-3 text-enabled-L1 bg-white leading-4.5"
                    )>
                    {productIdentifier->stringifyProductIdentifier->React.string}
                  </span>
                  <span className=%twc("absolute top-1.5 right-2")>
                    <IconArrowSelect height="24" width="24" fill="#121212" />
                  </span>
                  <select
                    id="product-identifier"
                    value={stringifyProductIdentifier(productIdentifier)}
                    className=%twc("block w-full h-full absolute top-0 opacity-0")
                    onChange={handleOnSelect(setProductIdentifier)}>
                    <option value=`상품번호`> {j`상품번호`->React.string} </option>
                    <option value=`단품번호`> {j`단품번호`->React.string} </option>
                  </select>
                </div>
              </div>
              <div className=%twc("min-w-1/2 flex items-center")>
                <Textarea
                  type_="text"
                  name="product-identifiers"
                  className=%twc("flex-1")
                  placeholder=`상품번호 입력(Enter 또는 “,”로 구분 가능, 최대 100개 입력 가능)`
                  value={form.values->FormFields.get(FormFields.ProductIdsOrSkus)}
                  onChange={FormFields.ProductIdsOrSkus
                  ->form.handleChange
                  ->ReForm.Helpers.handleChange}
                  error={FormFields.ProductIdsOrSkus->Form.ReSchema.Field->form.getFieldError}
                  rows=1
                  tabIndex=5
                  onKeyDown=handleKeyDownEnter
                />
              </div>
            </div>
          </div>
        </div>
      </div>
      <div className=%twc("flex justify-center mt-5")>
        <span className=%twc("w-20 h-11 flex mr-2")>
          <input
            type_="button"
            className=%twc("btn-level6")
            value=`초기화`
            onClick={handleOnReset}
            tabIndex=7
          />
        </span>
        <span className=%twc("w-20 h-11 flex")>
          <input type_="submit" className=%twc("btn-level1") value=`검색` tabIndex=6 />
        </span>
      </div>
    </form>
  </div>
}
