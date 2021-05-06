CREATE OR REPLACE FORCE VIEW SEND_2FIRM_PT_ORDER_TO_UPCOM AS
SELECT   "BORS", "FIRM","STRADERID","BTRADERID","CONTRAFIRM", "ACTYPE", "TYPENAME", "CLASS", "OFFTIME", "TXTIME",
         "ORDERID", "EXECTYPE", "CODEID", "SYMBOL", "QUOTEPRICE", "TRADELOT",
         "STOPPRICE", "LIMITPRICE", "ORDERQTTY", "OODPRICE", "OODQTTY",
         "TLID", "BRID", "TXDATE", "TXNUM", "FULLNAME", "CUSTODYCD",
         "ISSUERS", "CUSTID", "OODSTATUS", "AFACCTNO", "CIACCTNO", "SEACCTNO",
         "TRADEUNIT", "BRATIO", "OLDBRATIO", "REFORDERID", "SECUREDRATIOMIN",
         "SECUREDRATIOMAX", "MATCHTYPE", "NORK", "PRICETYPE", "CLEARDAY",
         "TXDESC", "TLTXCD", "ORSTATUS", "BCUSTODIAN", "SCUSTODIAN","BCLIENTID","SCLIENTID","ADVIDREF"
    FROM (SELECT a.bors, s.sysvalue firm,t.sysvalue STRADERID,C.TRADERID BTRADERID,c.contrafirm, c.actype, d.typename, j.CLASS,
                 tllog.offtime, tllog.txtime, a.orgorderid orderid, c.exectype,
                 a.codeid, a.symbol, c.quoteprice  quoteprice,
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
                 c.advidref advidref
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
                 ordersys t,
                 ordersys_upcom ou
           WHERE (    a.codeid = b.codeid
                  AND a.orgorderid = c.orderid
                  AND c.actype = d.actype
                 )
             AND a.txdate = tllog.txdate
             AND a.txnum = tllog.txnum
             AND a.bors = 'S'
             AND
             (
              nvl(c.clientid,'0000000000') not in (select custodycd from cfmast where custodycd is not null)
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
             AND b.tradeplace = '005'
             AND s.sysname = 'FIRM'
             AND t.sysname = 'BROKERID'
             AND ou.sysname = 'CONTROLCODE'
             AND ou.sysvalue = '5'
             AND a.oodstatus IN ('N')
             AND c.deltd <> 'Y'
             AND c.orstatus <> '7'
             AND c.matchtype = 'P'
          )
ORDER BY CLASS DESC,
         SUBSTR (orderid, 5, 12);

