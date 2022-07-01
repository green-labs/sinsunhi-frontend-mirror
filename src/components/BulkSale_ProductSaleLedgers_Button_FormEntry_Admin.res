/*
 * 1. 컴포넌트 위치
 *   어드민 센터 - 전량 구매 - 생산자 소싱 관리 - (리스트) 원표정보 입력 - 원표 항목 폼
 *
 * 2. 역할
 *   어드민이 농민의 판매원표의 내용(등급, 중량, 등) 입력 폼 입니다.
 * */

type rec entry = {
  id: string,
  grade: string,
  price: string,
  quantity: productPackageMass,
  volume: string,
}
and productPackageMass = {
  amount: string,
  unit: [#KG | #G | #MG],
}

@react.component
let make = (~id, ~entries: Map.String.t<entry>, ~setEntries, ~formErrors) => {
  let grade = entries->Map.String.get(id)->Option.map(entry => entry.grade)
  let handleOnChangeGrade = e => {
    let value: string = (e->ReactEvent.Synthetic.target)["value"]
    let newEntry =
      entries
      ->Map.String.get(id)
      ->Option.map(entry => {
        ...entry,
        grade: value,
      })
    let newEntries = newEntry->Option.map(newEntry' => {
      entries->Map.String.set(id, newEntry')
    })
    switch newEntries {
    | Some(newEntries') => setEntries(._ => newEntries')
    | None => ()
    }
  }
  let amount = entries->Map.String.get(id)->Option.map(entry => entry.quantity.amount)
  let handleOnChangeAmount = e => {
    let value: string = (e->ReactEvent.Synthetic.target)["value"]
    let newEntry =
      entries
      ->Map.String.get(id)
      ->Option.map(entry => {
        ...entry,
        quantity: {
          ...entry.quantity,
          amount: value,
        },
      })
    let newEntries = newEntry->Option.map(newEntry' => {
      entries->Map.String.set(id, newEntry')
    })
    switch newEntries {
    | Some(newEntries') => setEntries(._ => newEntries')
    | None => ()
    }
  }
  let unit = entries->Map.String.get(id)->Option.mapWithDefault(#KG, entry => entry.quantity.unit)
  let handleOnChangeUnit = e => {
    let value: string = (e->ReactEvent.Synthetic.target)["value"]
    let newEntry =
      entries
      ->Map.String.get(id)
      ->Option.map(entry => {
        ...entry,
        quantity: {
          ...entry.quantity,
          unit: value
          ->Input_Select_BulkSale_ProductQuantity.decodePackageUnit
          ->Result.getWithDefault(#KG),
        },
      })
    let newEntries = newEntry->Option.map(newEntry' => {
      entries->Map.String.set(id, newEntry')
    })
    switch newEntries {
    | Some(newEntries') => setEntries(._ => newEntries')
    | None => ()
    }
  }
  let volume = entries->Map.String.get(id)->Option.map(entry => entry.volume)
  let handleOnChangeVolume = e => {
    let value: string = (e->ReactEvent.Synthetic.target)["value"]
    let newEntry =
      entries
      ->Map.String.get(id)
      ->Option.map(entry => {
        ...entry,
        volume: value,
      })
    let newEntries = newEntry->Option.map(newEntry' => {
      entries->Map.String.set(id, newEntry')
    })
    switch newEntries {
    | Some(newEntries') => setEntries(._ => newEntries')
    | None => ()
    }
  }
  let price = entries->Map.String.get(id)->Option.map(entry => entry.price)
  let handleOnChangePrice = e => {
    let value: string = (e->ReactEvent.Synthetic.target)["value"]
    let newEntry =
      entries
      ->Map.String.get(id)
      ->Option.map(entry => {
        ...entry,
        price: value,
      })
    let newEntries = newEntry->Option.map(newEntry' => {
      entries->Map.String.set(id, newEntry')
    })
    switch newEntries {
    | Some(newEntries') => setEntries(._ => newEntries')
    | None => ()
    }
  }

  <div className=%twc("py-4")>
    <section className=%twc("flex gap-2")>
      <article className=%twc("flex-1")>
        <h3 className=%twc("text-sm")> {`등급`->React.string} </h3>
        <Input
          type_="text"
          name="grade"
          size=Input.Small
          className=%twc("mt-2")
          value={grade->Option.getWithDefault("")}
          onChange=handleOnChangeGrade
          error={formErrors
          ->Array.keepMap(error =>
            switch error {
            | (id', #ErrorGrade(msg)) if id == id' => Some(msg)
            | _ => None
            }
          )
          ->Garter.Array.first}
        />
      </article>
      <article>
        <h3 className=%twc("text-sm")> {`중량`->React.string} </h3>
        <Input_Select_BulkSale_ProductQuantity
          quantityAmount=amount
          quantityUnit=unit
          onChangeAmount=handleOnChangeAmount
          onChangeUnit=handleOnChangeUnit
          error={formErrors
          ->Array.keepMap(error =>
            switch error {
            | (id', #ErrorAmount(msg)) if id == id' => Some(msg)
            | _ => None
            }
          )
          ->Garter.Array.first}
        />
      </article>
    </section>
    <section className=%twc("flex gap-2 mt-4")>
      <article className=%twc("flex-1")>
        <h3 className=%twc("text-sm")> {`거래량`->React.string} </h3>
        <Input
          type_="number"
          name="volume"
          size=Input.Small
          className=%twc("mt-2")
          placeholder="0"
          value={price->Option.getWithDefault("")}
          onChange=handleOnChangePrice
          textAlign=Input.Right
          error={formErrors
          ->Array.keepMap(error =>
            switch error {
            | (id', #ErrorVolume(msg)) if id == id' => Some(msg)
            | _ => None
            }
          )
          ->Garter.Array.first}
        />
      </article>
      <article>
        <h3 className=%twc("text-sm")> {`경락단가`->React.string} </h3>
        <Input
          type_="number"
          name="price"
          size=Input.Small
          className=%twc("mt-2")
          placeholder="0"
          value={volume->Option.getWithDefault("")}
          onChange=handleOnChangeVolume
          textAlign=Input.Right
          error={formErrors
          ->Array.keepMap(error =>
            switch error {
            | (id', #ErrorPrice(msg)) if id == id' => Some(msg)
            | _ => None
            }
          )
          ->Garter.Array.first}
        />
      </article>
    </section>
  </div>
}
