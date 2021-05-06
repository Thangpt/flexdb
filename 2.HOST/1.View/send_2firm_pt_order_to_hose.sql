CREATE OR REPLACE FORCE VIEW SEND_2FIRM_PT_ORDER_TO_HOSE AS
SELECT   "BORS", "FIRM","STRADERID","BTRADERID","CONTRAFIRM", "ACTYPE", "TYPENAME", "CLASS", "OFFTIME", "TXTIME",
         "ORDERID", "EXECTYPE", "CODEID", "SYMBOL", "QUOTEPRICE", "TRADELOT",
         "STOPPRICE", "LIMITPRICE", "ORDERQTTY", "OODPRICE", "OODQTTY",
         "TLID", "BRID", "TXDATE", "TXNUM", "FULLNAME", "CUSTODYCD",
         "ISSUERS", "CUSTID", "OODSTATUS", "AFACCTNO", "CIACCTNO", "SEACCTNO",
         "TRADEUNIT", "BRATIO", "OLDBRATIO", "REFORDERID", "SECUREDRATIOMIN",
         "SECUREDRATIOMAX", "MATCHTYPE", "NORK", "PRICETYPE", "CLEARDAY",
         "TXDESC", "TLTXCD", "ORSTATUS", "BCUSTODIAN", "SCUSTODIAN","BCLIENTID","SCLIENTID"
    FROM (SELECT a.bors, s.sysvalue firm,t.sysvalue STRADERID,C.TRADERID BTRADERID,c.contrafirm, c.actype, d.typename, j.CLASS,
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
                 a.custodycd sclientid
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
                 ordersys t
           WHERE (    a.codeid = b.codeid
                  AND a.orgorderid = c.orderid
                  AND c.actype = d.actype
                 )
             AND a.txdate = tllog.txdate
             AND a.txnum = tllog.txnum
             AND a.bors = 'S'
             AND NVL(c.ISFO_ORDER,'N') <>'Y'
             AND
             (
              nvl(upper(c.clientid),'0000000000') not in (select custodycd from cfmast where custodycd is not null)
             )
             AND (   tllog.txstatus = '1'
                  OR (tllog.tltxcd IN ('8882', '8883')
                      AND tllog.txstatus = '1'
                     )
                 )
             AND b.codeid = l.codeid
             AND c.orstatus NOT IN ('3', '0', '6')
             AND c.afacctno = i.acctno
             AND i.custid = j.custid
             AND b.issuerid = k.issuerid
             AND b.tradeplace = '001'
             AND s.sysname = 'FIRM'
             AND t.sysname = 'BROKERID'
             AND a.oodstatus IN ('N')
             AND c.deltd <> 'Y'
             AND c.orstatus <> '7'
             AND c.matchtype = 'P'
          )
ORDER BY DECODE (CLASS,
                 '004', '07:45:00',
                 (CASE
                     WHEN offtime IS NULL
                        THEN txtime
                     ELSE offtime
                  END
                 )
                ),
         SUBSTR (orderid, 5, 12);

