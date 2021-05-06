CREATE OR REPLACE FORCE VIEW SEND_ORDER_TO_HOSE AS
SELECT   "BORS", "FIRM", "ACTYPE", "TYPENAME", "CLASS", "OFFTIME",
            "TXTIME", "ORDERID", "EXECTYPE", "CODEID", "SYMBOL",(CASE WHEN pricetype='ATO' THEN 'ATO' WHEN pricetype='ATC' THEN 'ATC' ELSE TO_CHAR(quoteprice) END ) QUOTEPRICE,
            "TRADELOT", "STOPPRICE", "LIMITPRICE", "ORDERQTTY", "OODPRICE",
            "OODQTTY", "TLID", "BRID", "TXDATE", "TXNUM", "FULLNAME",
            "CUSTODYCD", "ISSUERS", "CUSTID", "OODSTATUS", "AFACCTNO",
            "CIACCTNO", "SEACCTNO", "TRADEUNIT", "BRATIO", "OLDBRATIO",
            "REFORDERID", "SECUREDRATIOMIN", "SECUREDRATIOMAX", "MATCHTYPE",
            "NORK", "PRICETYPE", "CLEARDAY", "TXDESC", "TLTXCD", "ORSTATUS"
       FROM (SELECT a.bors, s.sysvalue firm, c.actype, d.typename, j.CLASS,
                    tllog.offtime, tllog.txtime, orgorderid orderid,
                    c.exectype, a.codeid, a.symbol,
                    c.quoteprice / l.tradeunit quoteprice, l.tradelot,
                    c.stopprice, c.limitprice, c.orderqtty, a.price oodprice,
                    a.qtty oodqtty, tllog.tlid, tllog.brid, a.txdate, a.txnum,
                    j.fullname, j.custodycd, k.fullname issuers, j.custid,
                    a.oodstatus, c.afacctno, c.ciacctno, c.seacctno,
                    l.tradeunit, c.bratio, c.bratio oldbratio, c.reforderid,
                    l.securedratiomin, l.securedratiomax, c.matchtype, c.nork,
                    c.pricetype, c.clearday, tllog.txdesc, tllog.tltxcd,
                    c.orstatus
               FROM ood a,
                    sbsecurities b,
                    odmast c,
                    odtype d,
                    afmast i,
                    cfmast j,
                    issuers k,
                    securities_info l,
                    tllog,
                    ordersys s,
                    ordersys tt
              WHERE (    a.codeid = b.codeid
                     AND a.orgorderid = c.orderid
                     AND c.actype = d.actype
                    )
                AND a.txdate = tllog.txdate
                AND a.txnum = tllog.txnum
                AND (   tllog.txstatus = '1'
                     OR (    tllog.tltxcd IN ('8882', '8883')
                         AND tllog.txstatus = '1'
                        )
                    )
                AND b.codeid = l.codeid
                AND c.orstatus NOT IN ('3', '0', '6')
                AND c.afacctno = i.acctno
                AND i.custid = j.custid
                AND c.quoteprice <= l.ceilingprice
                AND c.quoteprice >= l.floorprice
                AND b.issuerid = k.issuerid
                AND b.tradeplace = '001'
                AND s.sysname = 'FIRM'
                AND oodstatus IN ('N')
                AND c.deltd <> 'Y'
                AND c.orstatus <> '7'
                AND c.matchtype = 'N'
                AND tt.sysname ='CONTROLCODE'
                AND c.EXECTYPE <> 'CB' AND c.EXECTYPE <> 'CS'
                --AND to_char(sysdate,'hh24miss') <='104505'
                AND (
                      (tt.sysvalue <> 'P' and c.pricetype in ('ATO','LO') AND to_char(sysdate,'hh24miss') >='082730' AND to_char(sysdate,'hh24mi') <='084500')
                     or

                       (tt.sysvalue ='P' and c.pricetype in ('ATO','LO'))
                     or
                       (tt.sysvalue ='O' and c.pricetype in ('LO'))
                     or
                       (tt.sysvalue ='A' and c.pricetype in ('ATC','LO'))
                    )
             UNION
             SELECT a.bors, s.sysvalue firm, c.actype, d.typename, j.CLASS,
                    tllog.offtime, tllog.txtime, orgorderid orderid,
                    c.exectype, a.codeid, a.symbol,
                    c.quoteprice / l.tradeunit quoteprice, l.tradelot,
                    c.stopprice, c.limitprice, c.orderqtty, a.price oodprice,
                    a.qtty oodqtty, tllog.tlid, tllog.brid, a.txdate, a.txnum,
                    j.fullname, j.custodycd, k.fullname issuers, j.custid,
                    a.oodstatus, c.afacctno, c.ciacctno, c.seacctno,
                    l.tradeunit, e.bratio, c.bratio oldbratio, e.reforderid,
                    l.securedratiomin, l.securedratiomax, c.matchtype, c.nork,
                    e.pricetype, c.clearday, tllog.txdesc, tllog.tltxcd,
                    c.orstatus
               FROM ood a,
                    sbsecurities b,
                    odmast c,
                    odmast e,
                    odtype d,
                    afmast i,
                    cfmast j,
                    issuers k,
                    securities_info l,
                    tllog,
                    ordersys s,
                    ordersys tt
              WHERE (    a.codeid = b.codeid
                     AND a.orgorderid = e.orderid
                     AND e.reforderid = c.orderid
                     AND c.actype = d.actype
                    )
                AND a.txdate = tllog.txdate
                AND a.txnum = tllog.txnum
                AND (   tllog.txstatus = '1'
                     OR (    tllog.tltxcd IN ('8882', '8883')
                         AND tllog.txstatus = '1'
                        )
                    )
                AND b.codeid = l.codeid
                AND c.orstatus IN ('8')
                AND c.afacctno = i.acctno
                AND i.custid = j.custid
                AND b.issuerid = k.issuerid
                AND e.quoteprice <= l.ceilingprice
                AND e.quoteprice >= l.floorprice
                AND b.tradeplace = '001'
                AND s.sysname = 'FIRM'
                AND oodstatus IN ('N')
                AND c.deltd <> 'Y'
                AND c.orstatus <> '7'
                AND c.matchtype = 'N'
                AND tllog.tltxcd IN ('8884', '8885')
                AND tt.sysname ='CONTROLCODE'
                AND c.EXECTYPE <> 'CB' AND c.EXECTYPE <> 'CS'
               -- AND to_char(sysdate,'hh24miss') <='104505'
                AND (
                      (tt.sysvalue <> 'P' and c.pricetype in ('ATO','LO') AND to_char(sysdate,'hh24miss') >='082730' AND to_char(sysdate,'hh24mi') <='084500')
                     or
                       (tt.sysvalue ='P' and c.pricetype in ('ATO','LO'))
                     or
                       (tt.sysvalue ='O' and c.pricetype in ('LO'))
                     or
                       (tt.sysvalue ='A' and c.pricetype in ('ATC','LO'))
                    )
                    )
    ORDER BY CLASS DESC , SUBSTR(ORDERID,5,12),(CASE WHEN OFFTIME IS NULL THEN TXTIME ELSE OFFTIME END)
;

