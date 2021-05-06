CREATE OR REPLACE FORCE VIEW SEND_PUTTHROUGH_ORDER_TO_HOSE AS
SELECT   "BORS", "FIRM","TRADERID", "ACTYPE", "TYPENAME", "CLASS", "OFFTIME", "TXTIME",
         "ORDERID", "EXECTYPE", "CODEID", "SYMBOL", "QUOTEPRICE", "TRADELOT",
         "STOPPRICE", "LIMITPRICE", "ORDERQTTY", "OODPRICE", "OODQTTY",
         "TLID", "BRID", "TXDATE", "TXNUM", "FULLNAME", "CUSTODYCD",
         "ISSUERS", "CUSTID", "OODSTATUS", "AFACCTNO", "CIACCTNO", "SEACCTNO",
         "TRADEUNIT", "BRATIO", "OLDBRATIO", "REFORDERID", "SECUREDRATIOMIN",
         "SECUREDRATIOMAX", "MATCHTYPE", "NORK", "PRICETYPE", "CLEARDAY",
         "TXDESC", "TLTXCD", "ORSTATUS", "BCUSTODIAN", "SCUSTODIAN","BCLIENTID","SCLIENTID","BUYORDERID"
    FROM (SELECT a.bors, s.sysvalue firm,C.TRADERID, c.actype, d.typename, j.CLASS,
                 tllog.offtime, tllog.txtime, a.orgorderid orderid, c.exectype,
                 a.codeid, a.symbol, c.quoteprice / l.tradeunit quoteprice,
                 l.tradelot, c.stopprice, c.limitprice, c.orderqtty,
                 a.price oodprice, a.qtty oodqtty, tllog.tlid, tllog.brid,
                 a.txdate, a.txnum, j.fullname, j.custodycd,
                 k.fullname issuers, j.custid, a.oodstatus, c.afacctno,
                 c.ciacctno, c.seacctno, l.tradeunit, c.bratio,
                 c.bratio oldbratio, c.reforderid, l.securedratiomin,
                 l.securedratiomax, c.matchtype, c.nork, c.pricetype,
                 c.clearday, tllog.txdesc, tllog.tltxcd, c.orstatus,
                 SUBSTR (c.clientid, 4, 1) bcustodian,
                 SUBSTR (a.custodycd, 4, 1) scustodian,
                 c.clientid bclientid,
                 a.custodycd sclientid,
                 aa.orgorderid BUYORDERID
            FROM ood a,
                 ood aa,
                 sbsecurities b,
                 odmast c,
                 odmast cc,
                 odtype d,
                 afmast i,
                 cfmast j,
                 issuers k,
                 securities_info l,
                 tllog,
                 ordersys s
           WHERE (a.codeid = b.codeid AND a.orgorderid = c.orderid AND c.actype = d.actype)
             and c.clientid=aa.custodycd and a.qtty=aa.qtty and a.price=aa.price and a.bors<> aa.bors
             and cc.orderid=aa.orgorderid  AND a.txdate = tllog.txdate  AND a.txnum = tllog.txnum
             AND a.bors = 'S'
             AND (NVL(c.clientid,'123') in (select custodycd from cfmast where custodycd is not null )
                 )
             AND (tllog.txstatus = '1' OR (tllog.tltxcd IN ('8882', '8883') AND tllog.txstatus = '1'))
             AND b.codeid = l.codeid  AND c.orstatus NOT IN ('3', '0', '6')  AND c.afacctno = i.acctno
             AND i.custid = j.custid AND b.issuerid = k.issuerid AND b.tradeplace = '001' AND s.sysname = 'FIRM'
             AND a.oodstatus IN ('N')  AND c.deltd <> 'Y' AND cc.deltd <> 'Y' AND c.orstatus <> '7'
             AND aa.oodstatus  ='N'
             AND c.matchtype = 'P'   AND cc.matchtype = 'P' and aa.oodstatus='N'
             AND NVL(c.ISFO_ORDER,'N') <>'Y' AND  NVL(cc.ISFO_ORDER,'N') <>'Y'
          )
          ORDER BY DECODE (CLASS, '004', '07:45:00', (CASE WHEN offtime IS NULL THEN txtime ELSE offtime END )),SUBSTR (orderid, 5, 12);

