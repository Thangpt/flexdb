-- Start of DDL Script for View HOSTMSTRADE.V_FO_INSTRUMENTS
-- Generated 30/01/2019 5:18:13 PM from HOSTMSTRADE@FLEX_111

CREATE OR REPLACE VIEW v_fo_instruments (
   symbol,
   fullname,
   cficode,
   exchange,
   board,
   price_ce,
   price_fl,
   price_rf,
   qttysum,
   fqtty,
   halt,
   symbolnum,
   price_nav,
   qtty_avrtrade,
   parvalue)
AS
Select sbs.symbol SYMBOL, iss.fullname FULLNAME,
    CASE WHEN sbs.is_etf = 'Y' THEN 'ETF' ELSE   --MSBS-1847     1.5.2.6    1.5.8.1
    CASE WHEN ald.cdval = '001' THEN 'ES' ELSE
    CASE WHEN ald.cdval = '002' THEN 'EP' ELSE
    CASE WHEN ald.cdval = '003' THEN 'DC' ELSE
    CASE WHEN ald.cdval = '005' THEN 'FF' ELSE
    CASE WHEN ald.cdval = '006' THEN 'DB' ELSE
    CASE WHEN ald.cdval = '008' THEN 'MM' ELSE
    CASE WHEN ald.cdval = '011' THEN 'CW' ELSE
    CASE WHEN ald.cdval = '012' THEN 'DN' ELSE 'NONE' END   --1.5.6.0
    END END END END END END END END CFICODE,    --MSBS-1847     1.5.2.6
    CASE WHEN sbs.TRADEPLACE = '000' THEN 'ALL'
        WHEN sbs.TRADEPLACE = '001' THEN 'HSX'
        WHEN sbs.TRADEPLACE = '002' THEN 'HNX'
        WHEN sbs.TRADEPLACE = '003' THEN 'OTC'
        WHEN sbs.TRADEPLACE = '005' THEN 'HNX'
        WHEN sbs.TRADEPLACE = '006' THEN 'WFT'
        WHEN sbs.TRADEPLACE = '009' THEN 'DCCNY ' ELSE
        'NONE' END  EXCHANGE,
    CASE WHEN alsa.cdcontent = 'HOSE' THEN 'HSX' WHEN ald.cdval = '012' THEN 'BOND' ELSE alsa.cdcontent END BOARD,  --1.5.6.0
    nvl(sif.ceilingprice, 0) PRICE_CE,
    nvl(sif.floorprice, 0) PRICE_FL,
    nvl(sif.basicprice, 0) PRICE_RF,
    nvl(se.QUANTITY, 0) QTTYSUM,
    sif.CURRENT_ROOM FQTTY,
    CASE WHEN sbs.halt ='Y' THEN sbs.halt
         WHEN hosec.code IS NULL AND hasec.symbol IS NULL THEN 'Y'
         ELSE 'N'
    END
    halt,
    CASE  WHEN  sbs.TRADEPLACE  = '001' THEN  to_char(hosec.STOCK_ID) ELSE   sbs.SYMBOL END   SYMBOLNUM,
    NVL(sif.navprice, 0) PRICE_NAV, NVL(sif.avrtradeqtt, 0) QTTY_AVRTRADE,
    sbs.parvalue --1.8.2.5: them menh gia
FROM sbsecurities sbs, securities_info sif, issuers iss, ho_sec_info hosec, hasecurity_req hasec,
(Select codeid, SUM(TRADE + RECEIVING) QUANTITY FROM semast GROUP BY codeid) se,
(Select * from allcode where cdname =  'SECTYPE') ald,
(Select * from allcode where cdname =  'TRADEPLACE' AND cdtype = 'SA') alsa
WHERE sbs.codeid = sif.codeid(+)
    AND sbs.sectype = ald.cdval
    AND sbs.issuerid = iss.issuerid(+)
    AND sbs.TRADEPLACE = alsa.cdval
    --AND sbs.symbol = ST.symbol(+)
    AND sbs.codeid = se.codeid(+)
    AND sbs.sectype <> '004'
    AND sbs.TRADEPLACE IN ('000','001','002','005')
    AND sbs.symbol =hosec.code(+)
    AND sbs.symbol = hasec.symbol(+)
    AND  (nvl(sif.ceilingprice, 0) > 0 OR nvl(sif.floorprice, 0) >0  OR  nvl(sif.basicprice, 0) >0)
/


-- End of DDL Script for View HOSTMSTRADE.V_FO_INSTRUMENTS

