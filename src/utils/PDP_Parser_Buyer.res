// 단품
module ProductOption = {
  // 중량
  let makeWeightLabel = (weight, unit) => {
    let weightToStr = w => {
      w->Locale.Float.round1->Float.toString
    }

    let unitToStr = u => {
      switch u {
      | #G => "g"
      | #KG => "kg"
      | #T => "t"
      | _ => ""
      }
    }

    Helper.Option.map2(weight->Option.map(weightToStr), unit->Option.map(unitToStr), (
      wLabel,
      uLabel,
    ) => `${wLabel}${uLabel}`)
  }

  // 입수: (min은 라벨 표현에 이용되지 않음)
  let makeCountPerPkgLabel = max => {
    max->Option.mapWithDefault("", count => `최대 ${count->Int.toString}입`)
  }

  // 개당 크기: (min은 라벨 표현에 이용되지 않음)
  let makePerSizeLabel = (max, unit) => {
    let unitToStr = u => {
      switch u {
      | #CM => "cm"
      | #M => "m"
      | #MM => "mm"
      | _ => ""
      }
    }

    Helper.Option.map2(max->Option.map(Float.toString), unit->Option.map(unitToStr), (
      mLabel,
      uLabel,
    ) => `최대 ${mLabel}${uLabel}`)
  }

  // 개당 중량: (min은 라벨 표현에 이용되지 않음)
  let makePerWeightLabel = (max, unit) => {
    let maxWeightToStr = w => {
      w->Locale.Float.round1->Float.toString
    }

    let unitToStr = u => {
      switch u {
      | #G => "g"
      | #KG => "kg"
      | #T => "t"
      | _ => ""
      }
    }

    Helper.Option.map2(max->Option.map(maxWeightToStr), unit->Option.map(unitToStr), (
      wLabel,
      uLabel,
    ) => `최대 ${wLabel}${uLabel}`)
  }

  // 가격: 단품가격 - 배송비 (배송비는 별도로 보여주어야 하기 때문에 단품 가격에서 배송비를 제외시킨다.)
  let makePriceLabel = (price, deliveryCost) => {
    price->Option.mapWithDefault("", price' =>
      `${(price' - deliveryCost)->Float.fromInt->Locale.Float.show(~digits=0)}원`
    )
  }
}

// 상품
module Product = {
  // 일반상품
  module Normal = {
    // 일반상품 중량 variation: 단품의 중량정보를 취합하여 중복제거 후 join하여 표현
    let makeWeightLabel = weightOptions => {
      weightOptions
      ->Array.keepMap(((weight, unit)) => ProductOption.makeWeightLabel(weight, unit))
      ->Set.String.fromArray
      ->Set.String.toArray
      ->Array.joinWith("/", x => x)
    }

    // 일반상품 등급 variation: 일반상품의 경우 단품의 등급정보를 취합하여 중복제거 후 join하여 표현
    // ToImprove:
    //   - 일반/견적상품의 등급체계를 일원화 하던가
    //   - 일반/견적상품의 타입을 분리하던가
    let makeGradeLabel = grades => {
      let label = grades->Set.String.fromArray->Set.String.toArray->Js.Array2.joinWith("/")
      switch label {
      | "" => None
      | label' => Some(label')
      }
    }

    // 상품 카테고리
    let makeCategoryLabel = (categoryItem, categoryKind) => {
      [categoryItem, categoryKind]->Array.keep(Option.isSome)->Js.Array2.joinWith("/")
    }

    // 상품 패키지 variation: 단품의 package정보를 취합하여 중복제거 후 join하여 표현
    let makePkgLabel = pkgs => {
      pkgs->Set.String.fromArray->Set.String.toArray->Array.joinWith("/", x => x)
    }

    // 상품 공지사항 적용기간
    let makeNoticeDateLabel = (startDate, endDate) => {
      let formatDate = dateString => dateString->Js.Date.fromString->DateFns.format("y.MM.dd")

      switch (startDate, endDate) {
      | (Some(start), Some(end)) => `적용기준일: ${start->formatDate}~${end->formatDate}`
      | (Some(start), None) => `적용기준일: ${start->formatDate}~`
      | (None, Some(end)) => `적용기준일: ~${end->formatDate}`
      | (None, None) => ""
      }
    }
  }

  // 견적상품
  module Quatable = {

  }
}
