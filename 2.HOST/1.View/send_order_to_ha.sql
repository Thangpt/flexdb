-- Start of DDL Script for View HOSTMSTRADE.SEND_ORDER_TO_HA
-- Generated 26-Sep-2018 11:19:12 from HOSTMSTRADE@FLEX_111

CREATE OR REPLACE VIEW send_order_to_ha (
   bors,
   firm,
   orderid,
   symbol,
   quoteprice,
   orderqtty,
   oodprice,
   oodqtty,
   custodycd,
   via,
   quoteqtty,
   pricetype,
   limitprice,
   codeid )
AS
SELECT              a.bors,
                    s.sysvalue firm,
                    a.orgorderid orderid,
                    a.symbol,
                    c.quoteprice ,
                    c.orderqtty,
                    a.price oodprice,
                    a.qtty oodqtty,
                    a.custodycd,
                    c.via,
                    c.QUOTEQTTY,
                    c.PRICETYPE,
                    c.limitprice,
                    l.codeid
               FROM ood a,
                    sbsecurities b,
                    odmast c,
                    securities_info l,
                    ordersys_ha s,
                    hasecurity_req hr,
                    HA_BRD hb
              WHERE     a.codeid = b.codeid
                     AND a.orgorderid = c.orderid
                AND b.codeid = l.codeid
                AND c.orstatus NOT IN ('3', '0', '6')
                AND c.quoteprice <= l.ceilingprice
                AND c.quoteprice >= l.floorprice
                AND c.deltd <> 'Y'
                AND c.orstatus <> '7'
                AND c.matchtype = 'N'
                AND c.EXECTYPE <> 'CB' AND c.EXECTYPE <> 'CS'
                AND NVL(c.ISFO_ORDER,'N') <>'Y'
                AND s.sysname = 'FIRM'
                AND oodstatus IN ('N')
                --begin HNX_update |iss 1774
                AND hr.symbol =a.symbol
                AND hb.BRD_CODE = hr.tradingsessionsubid
                --ma <> 1, 27 theo co bang
                AND( (HR.SECURITYTRADINGSTATUS in ('17','24','25','26','28')
                            AND hb.TRADSESSTATUS ='1')
                    OR    --ma = 1, 27 theo co bang va co ma
                    (HR.SECURITYTRADINGSTATUS in ('1','27')
                           AND hb.TRADSESSTATUS ='1'
                            AND hr.TRADSESSTATUS ='1'
                            AND hb.TRADINGSESSIONID= hr.TradingSessionID )
                   )
                --end  HNX_update |iss 1774
                 AND
                    (
                        (hb.TRADINGSESSIONID in ('CONT','CONTUP') and c.pricetype in ('LO','MTL','MAK','MOK'))
                          or
                          ( hb.TRADINGSESSIONID = 'CLOSE' and c.pricetype in ('ATC','LO'))
                          or
                          ( hb.TRADINGSESSIONID = 'CLOSE_BL' and c.pricetype in ('ATC','LO'))
                          Or
                          ( hb.TRADINGSESSIONID = 'PCLOSE' and c.pricetype in ('PLO'))	--HNX_update |iss 1774

                     )
    ORDER BY  C.LAST_CHANGE
/


-- End of DDL Script for View HOSTMSTRADE.SEND_ORDER_TO_HA
