let decodeMarket: string => result<
  BulkSaleProducerOnlineMarketInfoAdminFragment_graphql.Types.enum_OnlineMarket,
  unit,
> = rm =>
  if rm == `naver` {
    Ok(#NAVER)
  } else if rm == `coupang` {
    Ok(#COUPANG)
  } else if rm == `gmarket` {
    Ok(#GMARKET)
  } else if rm == `11st` {
    Ok(#ST11)
  } else if rm == `wemakeprice` {
    Ok(#WEMAKEPRICE)
  } else if rm == `tmon` {
    Ok(#TMON)
  } else if rm == `auction` {
    Ok(#AUCTION)
  } else if rm == `ssg` {
    Ok(#SSG)
  } else if rm == `interpark` {
    Ok(#INTERPARK)
  } else if rm == `gsshop` {
    Ok(#GSSHOP)
  } else if rm == `other` {
    Ok(#OTHER)
  } else {
    Error()
  }
let stringifyMarket = (
  rm: BulkSaleProducerOnlineMarketInfoAdminFragment_graphql.Types.enum_OnlineMarket,
) =>
  switch rm {
  | #NAVER => `naver`
  | #COUPANG => `coupang`
  | #GMARKET => `gmarket`
  | #ST11 => `11st`
  | #WEMAKEPRICE => `wemakeprice`
  | #TMON => `tmon`
  | #AUCTION => `auction`
  | #SSG => `ssg`
  | #INTERPARK => `interpark`
  | #GSSHOP => `gsshop`
  | #OTHER
  | _ => `etc`
  }
let displayMarket = (
  rm: BulkSaleProducerOnlineMarketInfoAdminFragment_graphql.Types.enum_OnlineMarket,
) =>
  switch rm {
  | #NAVER => `네이버`
  | #COUPANG => `쿠팡`
  | #GMARKET => `지마켓`
  | #ST11 => `11번가`
  | #WEMAKEPRICE => `위메프`
  | #TMON => `티몬`
  | #AUCTION => `옥션`
  | #SSG => `SSG`
  | #INTERPARK => `인터파크`
  | #GSSHOP => `지에스숍`
  | #OTHER
  | _ => `기타`
  }
let convertOnlineMarket = om => {
  switch om {
  | #NAVER => Some(#NAVER)
  | #COUPANG => Some(#COUPANG)
  | #GMARKET => Some(#GMARKET)
  | #ST11 => Some(#ST11)
  | #WEMAKEPRICE => Some(#WEMAKEPRICE)
  | #TMON => Some(#TMON)
  | #AUCTION => Some(#AUCTION)
  | #SSG => Some(#SSG)
  | #INTERPARK => Some(#INTERPARK)
  | #GSSHOP => Some(#GSSHOP)
  | #OTHER => Some(#OTHER)
  | _ => None
  }
}
